Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2686E55A6F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfFYV6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:58:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55552 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfFYV6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:58:07 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hftRs-0005sp-P6; Tue, 25 Jun 2019 17:58:00 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v4 net] af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET
Date:   Tue, 25 Jun 2019 17:57:49 -0400
Message-Id: <20190625215749.22840-1-nhorman@tuxdriver.com>
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

V3->V4:
	Willem has requested that the control flow be restored to the
previous state.  Doing so lets us eliminate the need for the
po->wait_on_complete flag variable, and lets us get rid of the
packet_next_frame function, but introduces another complexity.
Specifically, but using the packet pending count, we can, if an
applications calls sendmsg multiple times with MSG_DONTWAIT set, each
set of transmitted frames, when complete, will cause
tpacket_destruct_skb to issue a complete call, for which there will
never be a wait_on_completion call.  This imbalance will lead to any
future call to wait_for_completion here to return early, when the frames
they sent may not have completed.  To correct this, we need to re-init
the completion queue on every call to tpacket_snd before we enter the
loop so as to ensure we wait properly for the frames we send in this
iteration.

	Change the timeout and interrupted gotos to out_put rather than
out_status so that we don't try to free a non-existant skb
	Clean up some extra newlines (Willem de Bruijn)
---
 net/packet/af_packet.c | 20 +++++++++++++++++---
 net/packet/internal.h  |  1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a29d66da7394..a7ca6a003ebe 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2401,6 +2401,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
+
+		if (!packet_read_pending(&po->tx_ring))
+			complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
@@ -2585,7 +2588,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
 
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct net_device *dev;
 	struct virtio_net_hdr *vnet_hdr = NULL;
 	struct sockcm_cookie sockc;
@@ -2600,6 +2603,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
+	long timeo = 0;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2646,12 +2650,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
+	reinit_completion(&po->skb_completion);
+
 	do {
 		ph = packet_current_frame(po, &po->tx_ring,
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
-			if (need_wait && need_resched())
-				schedule();
+			if (need_wait && skb) {
+				timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
+				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
+				if (timeo <= 0) {
+					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;
+					goto out_put;
+				}
+			}
+			/* check for additional frames */
 			continue;
 		}
 
@@ -3207,6 +3220,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	sock_init_data(sock, sk);
 
 	po = pkt_sk(sk);
+	init_completion(&po->skb_completion);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
 	po->xmit = dev_queue_xmit;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 3bb7c5fb3bff..c70a2794456f 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -128,6 +128,7 @@ struct packet_sock {
 	unsigned int		tp_hdrlen;
 	unsigned int		tp_reserve;
 	unsigned int		tp_tstamp;
+	struct completion	skb_completion;
 	struct net_device __rcu	*cached_dev;
 	int			(*xmit)(struct sk_buff *skb);
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
-- 
2.20.1

