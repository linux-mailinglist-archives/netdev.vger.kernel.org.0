Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98A20AFD4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgFZKfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgFZKfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:35:00 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A955C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:35:00 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id x18so9822533lji.1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kDY514mJ0OVp9n6q43MCJebMfINm+D87eq/U5MpYAtc=;
        b=y3GwZ43IHrfcsBL1Z459drHY3qPstOW9higSSw56qPmvWg2dh0cmjQu3UML7zf/7xH
         z374n2CFE37NIhBc2cUblXbXYg6xS0OsiALUMLx4lQN7yFC3vXzswy+sqTxJ2I9UOpgg
         Ue+mb0U3R82rJWf+z3VTVjEOkVCGTwJYcPjNJON+ngjR/hYjeO4WxcYFzURXAq9XkOAV
         R3wmUQ1pTWXFv0e7b9vPfxguMJmZU0J9v2fZy/iK1d2vwsgXD27nvovZWr3bDzvgtM2Z
         u8yibgnr8M/tiW/HIOQfM7G464OgqJIprjAkcYkymFfGK5N0qBlS3yK0GUq9v4WPE9iX
         BaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kDY514mJ0OVp9n6q43MCJebMfINm+D87eq/U5MpYAtc=;
        b=CSXpopUZddyNuH+1N4cmsqwp7x4GdmURX3JHFAACKjAzdpT8Q3JFanb/eG0Bt4a2j3
         4MPdZ2q5CKyRiIBTQcHPNcek2NG9Ag7L1BeMYkexAMb7ek6H4GQ1Xe+Anky+CwnIo+oC
         zUH8IVNNVpqXrAf0ZbmwB1FhrSFpalBpPTtZoLRjirx1zL9dlQrFueJxvIejmH1ko7m2
         edrfA2thfQtbDfsv140Mg2Z568oGJdwORKfNZM6eeBjuDKJdhlfRtMQl4a+cTn6++KWd
         rGOG/W7czGUbbxWKsd2dZn4iqL475t96tn/mlENg2+iDelzcsdEVhtXSixSE+afJQP8S
         Hmdw==
X-Gm-Message-State: AOAM533LZOC+acDY3cKkdPiQlQ6k0kic9uqJQ825QhA3wNx157VsG+8k
        j4DBv631BXzzuj2jBMegB6870BffNbgFZw==
X-Google-Smtp-Source: ABdhPJx/y10uyjYjvcKVpSBnsb0tbOzcGe0Nw8bQWEqd5vKPv5Lupq8VtbijFMNkmgvpPbomdcOJmQ==
X-Received: by 2002:a2e:9a4d:: with SMTP id k13mr1107465ljj.43.1593167698495;
        Fri, 26 Jun 2020 03:34:58 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id l1sm166124ljc.65.2020.06.26.03.34.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 03:34:58 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v11 2/3] xen networking: add basic XDP support for xen-netfront
Date:   Fri, 26 Jun 2020 13:34:33 +0300
Message-Id: <1593167674-1065-3-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org>
References: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds a basic XDP processing to xen-netfront driver.

We ran an XDP program for an RX response received from netback
driver. Also we request xen-netback to adjust data offset for
bpf_xdp_adjust_head() header space for custom headers.

synchronization between frontend and backend parts is done
by using xenbus state switching:
Reconfiguring -> Reconfigured- > Connected

UDP packets drop rate using xdp program is around 310 kpps
using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/Kconfig        |   1 +
 drivers/net/xen-netfront.c | 337 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 328 insertions(+), 10 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9a49c4c..717abf4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -495,6 +495,7 @@ config XEN_NETDEV_FRONTEND
 	tristate "Xen network device frontend driver"
 	depends on XEN
 	select XEN_XENBUS_FRONTEND
+	select PAGE_POOL
 	default y
 	help
 	  This driver provides support for Xen paravirtual network
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8..91a3b53 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -44,6 +44,9 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <net/ip.h>
+#include <linux/bpf.h>
+#include <net/page_pool.h>
+#include <linux/bpf_trace.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -102,6 +105,8 @@ struct netfront_queue {
 	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
 	struct netfront_info *info;
 
+	struct bpf_prog __rcu *xdp_prog;
+
 	struct napi_struct napi;
 
 	/* Split event channels support, tx_* == rx_* when using
@@ -144,6 +149,9 @@ struct netfront_queue {
 	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
 	grant_ref_t gref_rx_head;
 	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
+
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct netfront_info {
@@ -159,6 +167,10 @@ struct netfront_info {
 	struct netfront_stats __percpu *rx_stats;
 	struct netfront_stats __percpu *tx_stats;
 
+	/* XDP state */
+	bool netback_has_xdp_headroom;
+	bool netfront_xdp_enabled;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -265,8 +277,8 @@ static struct sk_buff *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
 	if (unlikely(!skb))
 		return NULL;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
-	if (!page) {
+	page = page_pool_dev_alloc_pages(queue->page_pool);
+	if (unlikely(!page)) {
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -560,6 +572,67 @@ static u16 xennet_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return queue_idx;
 }
 
+static int xennet_xdp_xmit_one(struct net_device *dev,
+			       struct netfront_queue *queue,
+			       struct xdp_frame *xdpf)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
+	struct xen_netif_tx_request *tx;
+	int notify;
+
+	tx = xennet_make_first_txreq(queue, NULL,
+				     virt_to_page(xdpf->data),
+				     offset_in_page(xdpf->data),
+				     xdpf->len);
+
+	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
+	if (notify)
+		notify_remote_via_irq(queue->tx_irq);
+
+	u64_stats_update_begin(&tx_stats->syncp);
+	tx_stats->bytes += xdpf->len;
+	tx_stats->packets++;
+	u64_stats_update_end(&tx_stats->syncp);
+
+	xennet_tx_buf_gc(queue);
+
+	return 0;
+}
+
+static int xennet_xdp_xmit(struct net_device *dev, int n,
+			   struct xdp_frame **frames, u32 flags)
+{
+	unsigned int num_queues = dev->real_num_tx_queues;
+	struct netfront_info *np = netdev_priv(dev);
+	struct netfront_queue *queue = NULL;
+	unsigned long irq_flags;
+	int drops = 0;
+	int i, err;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	queue = &np->queues[smp_processor_id() % num_queues];
+
+	spin_lock_irqsave(&queue->tx_lock, irq_flags);
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+
+		if (!xdpf)
+			continue;
+		err = xennet_xdp_xmit_one(dev, queue, xdpf);
+		if (err) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+	spin_unlock_irqrestore(&queue->tx_lock, irq_flags);
+
+	return n - drops;
+}
+
+
 #define MAX_XEN_SKB_FRAGS (65536 / XEN_PAGE_SIZE + 1)
 
 static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -778,23 +851,82 @@ static int xennet_get_extras(struct netfront_queue *queue,
 	return err;
 }
 
+static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
+		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
+		   struct xdp_buff *xdp, bool *need_xdp_flush)
+{
+	struct xdp_frame *xdpf;
+	u32 len = rx->status;
+	u32 act = XDP_PASS;
+	int err;
+
+	xdp->data_hard_start = page_address(pdata);
+	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
+	xdp_set_data_meta_invalid(xdp);
+	xdp->data_end = xdp->data + len;
+	xdp->rxq = &queue->xdp_rxq;
+	xdp->frame_sz = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_TX:
+		get_page(pdata);
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		err = xennet_xdp_xmit(queue->info->netdev, 1, &xdpf, 0);
+		if (unlikely(err < 0))
+			trace_xdp_exception(queue->info->netdev, prog, act);
+		break;
+	case XDP_REDIRECT:
+		get_page(pdata);
+		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
+		*need_xdp_flush = true;
+		if (unlikely(err))
+			trace_xdp_exception(queue->info->netdev, prog, act);
+		break;
+	case XDP_PASS:
+	case XDP_DROP:
+		break;
+
+	case XDP_ABORTED:
+		trace_xdp_exception(queue->info->netdev, prog, act);
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(act);
+	}
+
+	return act;
+}
+
 static int xennet_get_responses(struct netfront_queue *queue,
 				struct netfront_rx_info *rinfo, RING_IDX rp,
-				struct sk_buff_head *list)
+				struct sk_buff_head *list,
+				bool *need_xdp_flush)
 {
 	struct xen_netif_rx_response *rx = &rinfo->rx;
-	struct xen_netif_extra_info *extras = rinfo->extras;
-	struct device *dev = &queue->info->netdev->dev;
+	int max = XEN_NETIF_NR_SLOTS_MIN + (rx->status <= RX_COPY_THRESHOLD);
 	RING_IDX cons = queue->rx.rsp_cons;
 	struct sk_buff *skb = xennet_get_rx_skb(queue, cons);
+	struct xen_netif_extra_info *extras = rinfo->extras;
 	grant_ref_t ref = xennet_get_rx_ref(queue, cons);
-	int max = XEN_NETIF_NR_SLOTS_MIN + (rx->status <= RX_COPY_THRESHOLD);
+	struct device *dev = &queue->info->netdev->dev;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	unsigned long ret;
 	int slots = 1;
 	int err = 0;
-	unsigned long ret;
+	u32 verdict;
 
 	if (rx->flags & XEN_NETRXF_extra_info) {
 		err = xennet_get_extras(queue, extras, rp);
+		if (!err) {
+			if (extras[XEN_NETIF_EXTRA_TYPE_XDP - 1].type) {
+				struct xen_netif_extra_info *xdp;
+
+				xdp = &extras[XEN_NETIF_EXTRA_TYPE_XDP - 1];
+				rx->offset = xdp->u.xdp.headroom;
+			}
+		}
 		cons = queue->rx.rsp_cons;
 	}
 
@@ -827,9 +959,24 @@ static int xennet_get_responses(struct netfront_queue *queue,
 
 		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
 
-		__skb_queue_tail(list, skb);
-
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(queue->xdp_prog);
+		if (xdp_prog) {
+			if (!(rx->flags & XEN_NETRXF_more_data)) {
+				/* currently only a single page contains data */
+				verdict = xennet_run_xdp(queue,
+							 skb_frag_page(&skb_shinfo(skb)->frags[0]),
+							 rx, xdp_prog, &xdp, need_xdp_flush);
+				if (verdict != XDP_PASS)
+					err = -EINVAL;
+			} else {
+				/* drop the frame */
+				err = -EINVAL;
+			}
+		}
+		rcu_read_unlock();
 next:
+		__skb_queue_tail(list, skb);
 		if (!(rx->flags & XEN_NETRXF_more_data))
 			break;
 
@@ -998,6 +1145,7 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 	struct sk_buff_head errq;
 	struct sk_buff_head tmpq;
 	int err;
+	bool need_xdp_flush = false;
 
 	spin_lock(&queue->rx_lock);
 
@@ -1014,7 +1162,8 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 		memcpy(rx, RING_GET_RESPONSE(&queue->rx, i), sizeof(*rx));
 		memset(extras, 0, sizeof(rinfo.extras));
 
-		err = xennet_get_responses(queue, &rinfo, rp, &tmpq);
+		err = xennet_get_responses(queue, &rinfo, rp, &tmpq,
+					   &need_xdp_flush);
 
 		if (unlikely(err)) {
 err:
@@ -1060,6 +1209,8 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 		i = ++queue->rx.rsp_cons;
 		work_done++;
 	}
+	if (need_xdp_flush)
+		xdp_do_flush();
 
 	__skb_queue_purge(&errq);
 
@@ -1261,6 +1412,101 @@ static void xennet_poll_controller(struct net_device *dev)
 }
 #endif
 
+#define NETBACK_XDP_HEADROOM_DISABLE	0
+#define NETBACK_XDP_HEADROOM_ENABLE	1
+
+static int talk_to_netback_xdp(struct netfront_info *np, int xdp)
+{
+	int err;
+	int headroom;
+
+	headroom = xdp ? XDP_PACKET_HEADROOM : 0;
+	err = xenbus_printf(XBT_NIL, np->xbdev->nodename,
+			    "xdp-headroom", "%hu",
+			    headroom);
+	if (err)
+		pr_warn("Error writing xdp-headroom\n");
+
+	return err;
+}
+
+static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+			  struct netlink_ext_ack *extack)
+{
+	unsigned long max_mtu = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
+	struct netfront_info *np = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+	unsigned int i, err;
+
+	if (dev->mtu > max_mtu) {
+		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_mtu);
+		return -EINVAL;
+	}
+
+	if (!np->netback_has_xdp_headroom)
+		return 0;
+
+	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
+
+	err = talk_to_netback_xdp(np, prog ? NETBACK_XDP_HEADROOM_ENABLE :
+				  NETBACK_XDP_HEADROOM_DISABLE);
+	if (err)
+		return err;
+
+	/* avoid the race with XDP headroom adjustment */
+	wait_event(module_wq,
+		   xenbus_read_driver_state(np->xbdev->otherend) ==
+		   XenbusStateReconfigured);
+	np->netfront_xdp_enabled = true;
+
+	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
+
+	if (prog)
+		bpf_prog_add(prog, dev->real_num_tx_queues);
+
+	for (i = 0; i < dev->real_num_tx_queues; ++i)
+		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
+
+	if (old_prog)
+		for (i = 0; i < dev->real_num_tx_queues; ++i)
+			bpf_prog_put(old_prog);
+
+	xenbus_switch_state(np->xbdev, XenbusStateConnected);
+
+	return 0;
+}
+
+static u32 xennet_xdp_query(struct net_device *dev)
+{
+	unsigned int num_queues = dev->real_num_tx_queues;
+	struct netfront_info *np = netdev_priv(dev);
+	const struct bpf_prog *xdp_prog;
+	struct netfront_queue *queue;
+	unsigned int i;
+
+	for (i = 0; i < num_queues; ++i) {
+		queue = &np->queues[i];
+		xdp_prog = rtnl_dereference(queue->xdp_prog);
+		if (xdp_prog)
+			return xdp_prog->aux->id;
+	}
+
+	return 0;
+}
+
+static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = xennet_xdp_query(dev);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct net_device_ops xennet_netdev_ops = {
 	.ndo_open            = xennet_open,
 	.ndo_stop            = xennet_close,
@@ -1272,6 +1518,8 @@ static void xennet_poll_controller(struct net_device *dev)
 	.ndo_fix_features    = xennet_fix_features,
 	.ndo_set_features    = xennet_set_features,
 	.ndo_select_queue    = xennet_select_queue,
+	.ndo_bpf            = xennet_xdp,
+	.ndo_xdp_xmit	    = xennet_xdp_xmit,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = xennet_poll_controller,
 #endif
@@ -1331,6 +1579,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 	SET_NETDEV_DEV(netdev, &dev->dev);
 
 	np->netdev = netdev;
+	np->netfront_xdp_enabled = false;
 
 	netif_carrier_off(netdev);
 
@@ -1419,6 +1668,8 @@ static void xennet_disconnect_backend(struct netfront_info *info)
 		queue->rx_ring_ref = GRANT_INVALID_REF;
 		queue->tx.sring = NULL;
 		queue->rx.sring = NULL;
+
+		page_pool_destroy(queue->page_pool);
 	}
 }
 
@@ -1754,6 +2005,51 @@ static void xennet_destroy_queues(struct netfront_info *info)
 	info->queues = NULL;
 }
 
+
+
+static int xennet_create_page_pool(struct netfront_queue *queue)
+{
+	int err;
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = 0,
+		.pool_size = NET_RX_RING_SIZE,
+		.nid = NUMA_NO_NODE,
+		.dev = &queue->info->netdev->dev,
+		.offset = XDP_PACKET_HEADROOM,
+		.max_len = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
+	};
+
+	queue->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(queue->page_pool)) {
+		err = PTR_ERR(queue->page_pool);
+		queue->page_pool = NULL;
+		return err;
+	}
+
+	err = xdp_rxq_info_reg(&queue->xdp_rxq, queue->info->netdev,
+			       queue->id);
+	if (err) {
+		netdev_err(queue->info->netdev, "xdp_rxq_info_reg failed\n");
+		goto err_free_pp;
+	}
+
+	err = xdp_rxq_info_reg_mem_model(&queue->xdp_rxq,
+					 MEM_TYPE_PAGE_POOL, queue->page_pool);
+	if (err) {
+		netdev_err(queue->info->netdev, "xdp_rxq_info_reg_mem_model failed\n");
+		goto err_unregister_rxq;
+	}
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&queue->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(queue->page_pool);
+	queue->page_pool = NULL;
+	return err;
+}
+
 static int xennet_create_queues(struct netfront_info *info,
 				unsigned int *num_queues)
 {
@@ -1779,6 +2075,14 @@ static int xennet_create_queues(struct netfront_info *info,
 			break;
 		}
 
+		/* use page pool recycling instead of buddy allocator */
+		ret = xennet_create_page_pool(queue);
+		if (ret < 0) {
+			dev_err(&info->xbdev->dev, "can't allocate page pool\n");
+			*num_queues = i;
+			return ret;
+		}
+
 		netif_napi_add(queue->info->netdev, &queue->napi,
 			       xennet_poll, 64);
 		if (netif_running(info->netdev))
@@ -1825,6 +2129,17 @@ static int talk_to_netback(struct xenbus_device *dev,
 		goto out_unlocked;
 	}
 
+	info->netback_has_xdp_headroom = xenbus_read_unsigned(info->xbdev->otherend,
+							      "feature-xdp-headroom", 0);
+	if (info->netback_has_xdp_headroom) {
+		/* set the current xen-netfront xdp state */
+		err = talk_to_netback_xdp(info, info->netfront_xdp_enabled ?
+					  NETBACK_XDP_HEADROOM_ENABLE :
+					  NETBACK_XDP_HEADROOM_DISABLE);
+		if (err)
+			goto out_unlocked;
+	}
+
 	rtnl_lock();
 	if (info->queues)
 		xennet_destroy_queues(info);
@@ -1959,6 +2274,8 @@ static int xennet_connect(struct net_device *dev)
 	err = talk_to_netback(np->xbdev, np);
 	if (err)
 		return err;
+	if (np->netback_has_xdp_headroom)
+		pr_info("backend supports XDP headroom\n");
 
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
-- 
1.8.3.1

