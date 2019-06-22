Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0E54F77F
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFVRmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 13:42:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55588 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVRmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 13:42:24 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hek1n-0007u9-H6; Sat, 22 Jun 2019 13:42:20 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v2 net] af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET
Date:   Sat, 22 Jun 2019 13:41:54 -0400
Message-Id: <20190622174154.14473-1-nhorman@tuxdriver.com>
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
---
 net/packet/af_packet.c | 60 ++++++++++++++++++++++++++++++++----------
 net/packet/internal.h  |  2 ++
 2 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a29d66da7394..8ddb2f7aebb4 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -358,7 +358,8 @@ static inline struct page * __pure pgv_to_page(void *addr)
 	return virt_to_page(addr);
 }
 
-static void __packet_set_status(struct packet_sock *po, void *frame, int status)
+static void __packet_set_status(struct packet_sock *po, void *frame, int status,
+				bool call_complete)
 {
 	union tpacket_uhdr h;
 
@@ -381,6 +382,8 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
 		BUG();
 	}
 
+	if (po->wait_on_complete && call_complete)
+		complete(&po->skb_completion);
 	smp_wmb();
 }
 
@@ -1148,6 +1151,14 @@ static void *packet_previous_frame(struct packet_sock *po,
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
@@ -2360,7 +2371,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 #endif
 
 	if (po->tp_version <= TPACKET_V2) {
-		__packet_set_status(po, h.raw, status);
+		__packet_set_status(po, h.raw, status, false);
 		sk->sk_data_ready(sk);
 	} else {
 		prb_clear_blk_fill_status(&po->rx_ring);
@@ -2400,7 +2411,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		packet_dec_pending(&po->tx_ring);
 
 		ts = __packet_set_timestamp(po, ph, skb);
-		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
+		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts, true);
 	}
 
 	sock_wfree(skb);
@@ -2585,13 +2596,13 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
 
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct net_device *dev;
 	struct virtio_net_hdr *vnet_hdr = NULL;
 	struct sockcm_cookie sockc;
 	__be16 proto;
 	int err, reserve = 0;
-	void *ph;
+	void *ph = NULL;
 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
 	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
 	unsigned char *addr = NULL;
@@ -2600,9 +2611,12 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
+	long timeo;
 
 	mutex_lock(&po->pg_vec_lock);
 
+	timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
+
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
@@ -2647,16 +2661,29 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
 	do {
+
+		if (po->wait_on_complete && need_wait) {
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
 		ph = packet_current_frame(po, &po->tx_ring,
 					  TP_STATUS_SEND_REQUEST);
-		if (unlikely(ph == NULL)) {
-			if (need_wait && need_resched())
-				schedule();
-			continue;
-		}
+
+		if (likely(ph == NULL))
+			break;
 
 		skb = NULL;
 		tp_len = tpacket_parse_header(po, ph, size_max, &data);
+
 		if (tp_len < 0)
 			goto tpacket_error;
 
@@ -2699,7 +2726,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 tpacket_error:
 			if (po->tp_loss) {
 				__packet_set_status(po, ph,
-						TP_STATUS_AVAILABLE);
+						TP_STATUS_AVAILABLE, false);
 				packet_increment_head(&po->tx_ring);
 				kfree_skb(skb);
 				continue;
@@ -2719,7 +2746,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		}
 
 		skb->destructor = tpacket_destruct_skb;
-		__packet_set_status(po, ph, TP_STATUS_SENDING);
+		__packet_set_status(po, ph, TP_STATUS_SENDING, false);
+		if (!packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST))
+			po->wait_on_complete = 1;
 		packet_inc_pending(&po->tx_ring);
 
 		status = TP_STATUS_SEND_REQUEST;
@@ -2753,8 +2782,10 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	goto out_put;
 
 out_status:
-	__packet_set_status(po, ph, status);
-	kfree_skb(skb);
+	if (ph)
+		__packet_set_status(po, ph, status, false);
+	if (skb)
+		kfree_skb(skb);
 out_put:
 	dev_put(dev);
 out:
@@ -3207,6 +3238,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
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

