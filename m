Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BC9115A7
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfEBIoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:44:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:64537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfEBIoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:44:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="296322445"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.43])
  by orsmga004.jf.intel.com with ESMTP; 02 May 2019 01:39:56 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com
Subject: [RFC bpf-next 5/7] net: add busy-poll support for XDP sockets
Date:   Thu,  2 May 2019 10:39:21 +0200
Message-Id: <1556786363-28743-6-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds busy-poll support for XDP sockets (AF_XDP). With
busy-poll, the driver is executed in process context by calling the
poll() syscall. The main advantage with this is that all processing
occurs on a single core. This eliminates the core-to-core cache
transfers that occur between the application and the softirqd
processing on another core, that occurs without busy-poll. From a
systems point of view, it also provides an advatage that we do not
have to provision extra cores in the system to handle
ksoftirqd/softirq processing, as all processing is done on the single
core that executes the application. The drawback of busy-poll is that
max throughput seen from a single application will be lower (due to
the syscall), but on a per core basis it will often be higher as the
normal mode runs on two cores and busy-poll on a single one.

The semantics of busy-poll from the application point of view are the
following:

* The application is required to call poll() to drive rx and tx
  processing. There is no guarantee that softirq and interrupts will
  do this for you.

* It should be enabled on a per socket basis. No global enablement, i.e.
  the XDP socket busy-poll will not care about the current
  /proc/sys/net/core/busy_poll and busy_read global enablement
  mechanisms.

* The batch size (how many packets that are processed every time the
  napi function in the driver is called, i.e. the weight parameter)
  should be configurable. Currently, the busy-poll size of AF_INET
  sockets is set to 8, but for AF_XDP sockets this is too small as the
  amount of processing per packet is much smaller with AF_XDP. This
  should be configurable on a per socket basis.

* If you put multiple AF_XDP busy-poll enabled sockets into a poll()
  call the napi contexts of all of them should be executed. This is in
  contrast to the AF_INET busy-poll that quits after the fist one that
  finds any packets. We need all napi contexts to be executed due to
  the first requirement in this list. The behaviour we want is much more
  like regular sockets in that all of them are checked in the poll
  call.

* Should be possible to mix AF_XDP busy-poll sockets with any other
  sockets including busy-poll AF_INET ones in a single poll() call
  without any change to semantics or the behaviour of any of those
  socket types.

* As suggested by Maxim Mikityanskiy, poll() will in the busy-poll
  mode return POLLERR if the fill ring is empty or the completion
  queue is full.

Busy-poll support is enabled by calling a new setsockopt called
XDP_BUSY_POLL_BATCH_SIZE that takes batch size as an argument. A value
between 1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it off and
any other value will return an error.

A typical packet processing rxdrop loop with busy-poll will look something
like this:

for (i = 0; i < num_socks; i++) {
    fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
    fds[i].events = POLLIN;
}

for (;;) {
    ret = poll(fds, num_socks, 0);
    if (ret <= 0)
            continue;

    for (i = 0; i < num_socks; i++)
        rx_drop(xsks[i], fds); /* The actual application */
}

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h |   3 ++
 net/xdp/Kconfig        |   1 +
 net/xdp/xsk.c          | 122 ++++++++++++++++++++++++++++++++++++++++++++++++-
 net/xdp/xsk_queue.h    |  18 ++++++--
 4 files changed, 138 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d..2e956b37 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -57,7 +57,10 @@ struct xdp_sock {
 	struct net_device *dev;
 	struct xdp_umem *umem;
 	struct list_head flush_node;
+	unsigned int napi_id_rx;
+	unsigned int napi_id_tx;
 	u16 queue_id;
+	u16 bp_batch_size;
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head list;
 	bool zc;
diff --git a/net/xdp/Kconfig b/net/xdp/Kconfig
index 0255b33..219baaa 100644
--- a/net/xdp/Kconfig
+++ b/net/xdp/Kconfig
@@ -1,6 +1,7 @@
 config XDP_SOCKETS
 	bool "XDP sockets"
 	depends on BPF_SYSCALL
+	select NET_RX_BUSY_POLL
 	default n
 	help
 	  XDP sockets allows a channel between XDP programs and
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e886..bd3d0fe 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -22,6 +22,7 @@
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
+#include <net/busy_poll.h>
 #include <net/xdp_sock.h>
 #include <net/xdp.h>
 
@@ -302,16 +303,107 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
 }
 
+static unsigned int xsk_check_rx_poll_err(struct xdp_sock *xs)
+{
+	return xskq_consumer_empty(xs->umem->fq) ? POLLERR : 0;
+}
+
+static unsigned int xsk_check_tx_poll_err(struct xdp_sock *xs)
+{
+	return xskq_producer_full(xs->umem->cq) ? POLLERR : 0;
+}
+
+static bool xsk_busy_loop_end(void *p, unsigned long start_time)
+{
+	return true;
+}
+
+static unsigned int xsk_get_napi_id_rx(struct xdp_sock *xs)
+{
+	if (xs->napi_id_rx)
+		return xs->napi_id_rx;
+	if (xs->dev->_rx[xs->queue_id].xdp_rxq.napi_id) {
+		xs->napi_id_rx = xdp_rxq_info_get(xs->dev,
+						  xs->queue_id)->napi_id;
+		return xs->napi_id_rx;
+	}
+
+	WARN_ON_ONCE(true);
+	return 0;
+}
+
+static unsigned int xsk_get_napi_id_tx(struct xdp_sock *xs)
+{
+	if (xs->napi_id_tx)
+		return xs->napi_id_tx;
+	if (xs->dev->_tx[xs->queue_id].xdp_txq.napi_id) {
+		xs->napi_id_tx = xdp_txq_info_get(xs->dev,
+						  xs->queue_id)->napi_id;
+		return xs->napi_id_tx;
+	}
+
+	WARN_ON_ONCE(true);
+	return 0;
+}
+
+static void xsk_exec_poll_generic(struct sock *sk, struct xdp_sock *xs,
+				  __poll_t events)
+{
+	if (events & (POLLIN | POLLRDNORM))
+		/* NAPI id filled in by the generic XDP code */
+		napi_busy_loop(xsk_get_napi_id_rx(xs), xsk_busy_loop_end, NULL,
+			       xs->bp_batch_size);
+	if (events & (POLLOUT | POLLWRNORM))
+		/* Use the regular send path as we do not have any
+		 * NAPI id for the Tx path. It is only in the driver
+		 * and not communicated upwards in the skb case.
+		 */
+		xsk_generic_xmit(sk, NULL, 0);
+}
+
+static void xsk_exec_poll_zc(struct xdp_sock *xs, __poll_t events)
+{
+	unsigned int napi_id_rx = xsk_get_napi_id_rx(xs);
+	unsigned int napi_id_tx = xsk_get_napi_id_tx(xs);
+
+	if (events & (POLLIN | POLLRDNORM))
+		napi_busy_loop(xs->napi_id_rx, xsk_busy_loop_end, NULL,
+			       xs->bp_batch_size);
+	if (napi_id_rx != napi_id_tx)
+		if (events & (POLLOUT | POLLWRNORM))
+			/* Tx has its own napi so we need to call it too */
+			napi_busy_loop(xs->napi_id_tx, xsk_busy_loop_end, NULL,
+				       xs->bp_batch_size);
+}
+
 static unsigned int xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
 	unsigned int mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
+	__poll_t events = poll_requested_events(wait);
+
+	if (xs->bp_batch_size) {
+		if (xs->zc)
+			xsk_exec_poll_zc(xs, events);
+		else
+			xsk_exec_poll_generic(sk, xs, events);
+
+		if (events & (POLLIN | POLLRDNORM))
+			mask |= xsk_check_rx_poll_err(xs);
+		if (events & (POLLOUT | POLLWRNORM))
+			mask |= xsk_check_tx_poll_err(xs);
+
+		/* Clear the busy_loop flag so that any further fds in
+		 * the pollfd struct will have their napis scheduled.
+		 */
+		mask &= ~POLL_BUSY_LOOP;
+	}
 
-	if (xs->rx && !xskq_empty_desc(xs->rx))
+	if (xs->rx && !xskq_producer_empty(xs->rx))
 		mask |= POLLIN | POLLRDNORM;
-	if (xs->tx && !xskq_full_desc(xs->tx))
+	if (xs->tx && !xskq_consumer_full(xs->tx))
 		mask |= POLLOUT | POLLWRNORM;
 
 	return mask;
@@ -572,6 +664,21 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
+	case XDP_BUSY_POLL_BATCH_SIZE:
+	{
+		u16 batch_size;
+
+		if (copy_from_user(&batch_size, optval, sizeof(batch_size)))
+			return -EFAULT;
+
+		if (batch_size == 0 || batch_size > NAPI_POLL_WEIGHT)
+			return -EINVAL;
+
+		mutex_lock(&xs->mutex);
+		xs->bp_batch_size = batch_size;
+		mutex_unlock(&xs->mutex);
+		return 0;
+	}
 	default:
 		break;
 	}
@@ -644,6 +751,17 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		return 0;
 	}
+	case XDP_BUSY_POLL_BATCH_SIZE:
+		if (len < sizeof(xs->bp_batch_size))
+			return -EINVAL;
+
+		if (copy_to_user(optval, &xs->bp_batch_size,
+				 sizeof(xs->bp_batch_size)))
+			return -EFAULT;
+		if (put_user(sizeof(xs->bp_batch_size), optlen))
+			return -EFAULT;
+
+		return 0;
 	default:
 		break;
 	}
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 88b9ae2..ebbd996 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -292,14 +292,24 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 	WRITE_ONCE(q->ring->producer, q->prod_tail);
 }
 
-static inline bool xskq_full_desc(struct xsk_queue *q)
+static inline bool xskq_consumer_full(struct xsk_queue *q)
 {
-	return xskq_nb_avail(q, q->nentries) == q->nentries;
+	return READ_ONCE(q->ring->producer) - q->cons_tail == q->nentries;
 }
 
-static inline bool xskq_empty_desc(struct xsk_queue *q)
+static inline bool xskq_producer_empty(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
+	return READ_ONCE(q->ring->consumer) == q->prod_tail;
+}
+
+static inline bool xskq_consumer_empty(struct xsk_queue *q)
+{
+	return READ_ONCE(q->ring->producer) == q->cons_tail;
+}
+
+static inline bool xskq_producer_full(struct xsk_queue *q)
+{
+	return q->prod_tail - READ_ONCE(q->ring->consumer) == q->nentries;
 }
 
 void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
-- 
2.7.4

