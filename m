Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33159E3D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 16:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfF1OxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 10:53:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60891 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfF1OxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 10:53:07 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hgsFF-0003VH-2t; Fri, 28 Jun 2019 10:53:03 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] af_packet: convert pending frame counter to atomic_t
Date:   Fri, 28 Jun 2019 10:52:06 -0400
Message-Id: <20190628145206.13871-1-nhorman@tuxdriver.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AF_PACKET protocol, when running as a memory mapped socket uses a
pending frame counter to track the number of skbs in flight during
transmission.  It is incremented during the sendmsg call (via
tpacket_snd), and decremented (possibly asynchronously) in the skb
desructor during skb_free.

The counter is currently implemented as a percpu variable for each open
socket, but for reads (via packet_read_pending), we iterate over every
cpu variable, accumulating the total pending count.

Given that the socket transmit path is an exclusive path (locked via the
pg_vec_lock mutex), we do not have the ability to increment this counter
on multiple cpus in parallel.  This implementation also seems to have
the potential to be broken, in that, should an skb be freed on a cpu
other than the one that it was initially transmitted on, we may
decrement a counter that was not initially incremented, leading to
underflow.

As such, adjust the packet socket struct to convert the per-cpu counter
to an atomic_t variable (to enforce consistency between the send path
and the skb free path).  This saves us some space in the packet_sock
structure, prevents the possibility of underflow, and should reduce the
run time of packet_read_pending, as we only need to read a single
variable, instead of having to loop over every available cpu variable
instance.

Tested by myself by running a small program which sends frames via
AF_PACKET on multiple cpus in parallel, with good results.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 40 +++++-----------------------------------
 net/packet/internal.h  |  2 +-
 2 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8d54f3047768..25ffb486fac9 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1154,43 +1154,17 @@ static void packet_increment_head(struct packet_ring_buffer *buff)
 
 static void packet_inc_pending(struct packet_ring_buffer *rb)
 {
-	this_cpu_inc(*rb->pending_refcnt);
+	atomic_inc(&rb->pending_refcnt);
 }
 
 static void packet_dec_pending(struct packet_ring_buffer *rb)
 {
-	this_cpu_dec(*rb->pending_refcnt);
+	atomic_dec(&rb->pending_refcnt);
 }
 
 static unsigned int packet_read_pending(const struct packet_ring_buffer *rb)
 {
-	unsigned int refcnt = 0;
-	int cpu;
-
-	/* We don't use pending refcount in rx_ring. */
-	if (rb->pending_refcnt == NULL)
-		return 0;
-
-	for_each_possible_cpu(cpu)
-		refcnt += *per_cpu_ptr(rb->pending_refcnt, cpu);
-
-	return refcnt;
-}
-
-static int packet_alloc_pending(struct packet_sock *po)
-{
-	po->rx_ring.pending_refcnt = NULL;
-
-	po->tx_ring.pending_refcnt = alloc_percpu(unsigned int);
-	if (unlikely(po->tx_ring.pending_refcnt == NULL))
-		return -ENOBUFS;
-
-	return 0;
-}
-
-static void packet_free_pending(struct packet_sock *po)
-{
-	free_percpu(po->tx_ring.pending_refcnt);
+	atomic_read(&rb->pending_refcnt);
 }
 
 #define ROOM_POW_OFF	2
@@ -3046,7 +3020,6 @@ static int packet_release(struct socket *sock)
 	/* Purge queues */
 
 	skb_queue_purge(&sk->sk_receive_queue);
-	packet_free_pending(po);
 	sk_refcnt_debug_release(sk);
 
 	sock_put(sk);
@@ -3236,9 +3209,8 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	po->num = proto;
 	po->xmit = dev_queue_xmit;
 
-	err = packet_alloc_pending(po);
-	if (err)
-		goto out2;
+	atomic_set(&po->tx_ring.pending_refcnt,0);
+	atomic_set(&po->rx_ring.pending_refcnt,0);
 
 	packet_cached_dev_reset(po);
 
@@ -3273,8 +3245,6 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	preempt_enable();
 
 	return 0;
-out2:
-	sk_free(sk);
 out:
 	return err;
 }
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 82fb2b10f790..b0fdb54bb91b 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -68,7 +68,7 @@ struct packet_ring_buffer {
 	unsigned int		pg_vec_pages;
 	unsigned int		pg_vec_len;
 
-	unsigned int __percpu	*pending_refcnt;
+	atomic_t		pending_refcnt;
 
 	struct tpacket_kbdq_core	prb_bdqc;
 };
-- 
2.21.0

