Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224DB4FF07
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfFXCFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:05:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59834 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfFXCFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 22:05:36 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hfD7j-0003oU-Ck; Sun, 23 Jun 2019 20:46:25 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v3 net] af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET
Date:   Sun, 23 Jun 2019 20:46:04 -0400
Message-Id: <20190624004604.25607-1-nhorman@tuxdriver.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619202533.4856-1-nhorman@tuxdriver.com>
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an application is run that:
a) Sets its scheduler to be SCHED_FIFO
and
b) Opens a memory mapped AF_PACKET socket, and sends frames with the
MSG_DONTWAIT flag cleared, its possible for the application to hang
forever in the kernel.  This occurs because when waiting, the code in
tpacket_snd calls schedule, which under normal circumstances allows
other tasks to run, including ksoftirqd, which in some cases is
responsible for freeing the transmitted skb (which in AF_PACKET calls a
destructor that flips the status bit of the transmitted frame back to
available, allowing the transmitting task to complete).

However, when the calling application is SCHED_FIFO, its priority is
such that the schedule call immediately places the task back on the cpu,
preventing ksoftirqd from freeing the skb, which in turn prevents the
transmitting task from detecting that the transmission is complete.

We can fix this by converting the schedule call to a completion
mechanism.  By using a completion queue, we force the calling task, when
it detects there are no more frames to send, to schedule itself off the
cpu until such time as the last transmitted skb is freed, allowing
forward progress to be made.

Tested by myself and the reporter, with good results

Appies to the net tree

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Matteo Croce <mcroce@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

Change Notes:

V1->V2:
	Enhance the sleep logic to support being interruptible and
allowing for honoring to SK_SNDTIMEO (Willem de Bruijn)

V2->V3:
	Rearrage the point at which we wait for the completion queue, to
avoid needing to check for ph/skb being null at the end of the loop.
Also move the complete call to the skb destructor to avoid needing to
modify __packet_set_status.  Also gate calling complete on
packet_read_pending returning zero to avoid multiple calls to complete.
(Willem de Bruijn)

	Move timeo computation within loop, to re-fetch the socket
timeout since we also use the timeo variable to record the return code
from the wait_for_complete call (Neil Horman)
---
 net/packet/af_packet.c | 59 +++++++++++++++++++++++++++++++++++++-----
 net/packet/internal.h  |  2 ++
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a29d66da7394..5c48bb7a4fa5 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -380,7 +380,6 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
 		WARN(1, "TPACKET version not supported.\n");
 		BUG();
 	}
-
 	smp_wmb();
 }
 
@@ -1148,6 +1147,14 @@ static void *packet_previous_frame(struct packet_sock *po,
 	return packet_lookup_frame(po, rb, previous, status);
 }
 
+static void *packet_next_frame(struct packet_sock *po,
+		struct packet_ring_buffer *rb,
+		int status)
+{
+	unsigned int next = rb->head != rb->frame_max ? rb->head+1 : 0;
+	return packet_lookup_frame(po, rb, next, status);
+}
+
 static void packet_increment_head(struct packet_ring_buffer *buff)
 {
 	buff->head = buff->head != buff->frame_max ? buff->head+1 : 0;
@@ -2401,6 +2408,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
+
+		if (po->wait_on_complete && !packet_read_pending(&po->tx_ring))
+			complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
@@ -2600,9 +2610,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
+	long timeo = 0;
 
 	mutex_lock(&po->pg_vec_lock);
 
+
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
@@ -2647,16 +2659,16 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
 	do {
+
 		ph = packet_current_frame(po, &po->tx_ring,
 					  TP_STATUS_SEND_REQUEST);
-		if (unlikely(ph == NULL)) {
-			if (need_wait && need_resched())
-				schedule();
-			continue;
-		}
+
+		if (unlikely(ph == NULL))
+			break;
 
 		skb = NULL;
 		tp_len = tpacket_parse_header(po, ph, size_max, &data);
+
 		if (tp_len < 0)
 			goto tpacket_error;
 
@@ -2720,6 +2732,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		skb->destructor = tpacket_destruct_skb;
 		__packet_set_status(po, ph, TP_STATUS_SENDING);
+
+		/*
+		 * If we need to wait and we've sent the last frame pending
+		 * transmission in the mmaped buffer, flag that we need to wait
+		 * on those frames to get freed via tpacket_destruct_skb.  This
+		 * flag indicates that tpacket_destruct_skb should call complete
+		 * when the packet_pending count reaches zero, and that we need
+		 * to call wait_on_complete_interruptible_timeout below, to make
+		 * sure we pick up the result of that completion
+		 */
+		if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
+			po->wait_on_complete = 1;
+			timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
+		}
+
 		packet_inc_pending(&po->tx_ring);
 
 		status = TP_STATUS_SEND_REQUEST;
@@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 			err = net_xmit_errno(err);
 			if (err && __packet_get_status(po, ph) ==
 				   TP_STATUS_AVAILABLE) {
+				/* re-init completion queue to avoid subsequent fallthrough
+				 * on a future thread calling wait_on_complete_interruptible_timeout
+				 */
+				po->wait_on_complete = 0;
+				init_completion(&po->skb_completion);
 				/* skb was destructed already */
 				skb = NULL;
 				goto out_status;
@@ -2740,6 +2772,20 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		}
 		packet_increment_head(&po->tx_ring);
 		len_sum += tp_len;
+
+		if (po->wait_on_complete) {
+			timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
+			po->wait_on_complete = 0;
+			if (!timeo) {
+				/* We timed out, break out and notify userspace */
+				err = -ETIMEDOUT;
+				goto out_status;
+			} else if (timeo == -ERESTARTSYS) {
+				err = -ERESTARTSYS;
+				goto out_status;
+			}
+		}
+
 	} while (likely((ph != NULL) ||
 		/* Note: packet_read_pending() might be slow if we have
 		 * to call it as it's per_cpu variable, but in fast-path
@@ -3207,6 +3253,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	sock_init_data(sock, sk);
 
 	po = pkt_sk(sk);
+	init_completion(&po->skb_completion);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
 	po->xmit = dev_queue_xmit;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 3bb7c5fb3bff..bbb4be2c18e7 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -128,6 +128,8 @@ struct packet_sock {
 	unsigned int		tp_hdrlen;
 	unsigned int		tp_reserve;
 	unsigned int		tp_tstamp;
+	struct completion	skb_completion;
+	unsigned int		wait_on_complete;
 	struct net_device __rcu	*cached_dev;
 	int			(*xmit)(struct sk_buff *skb);
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
-- 
2.20.1

