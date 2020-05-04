Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5131C34A0
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgEDIio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgEDIio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:38:44 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34CFC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:38:43 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w14so9017348lfk.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=bYE0rVQf1O3noBLJyxgRFXg2ZyihOoC6BamzhuKzDH8=;
        b=YC9wDBLzveAc8kYhNuhv3Qjx7mMxy64QGWld257X+BCfzMfbT4HIpZS6l3bYbXqSNz
         mZ0IWQ+bavNvN58uAA/dg5UahOGHwQ5jPQgp1kPD8vLRN3cmzqtqLwTdLDZuZRS3v07c
         /lkoQEHNXxEgMinLxd6Ma6faIAdv676O1bmL9M3e2fg6WkAu1vGl2/YzTDIbAnJOYKvs
         uZo6hNdAccMudt6MnQ2uQom1UYWuzf7jQjr540vm9IY6FSappOBTi4F9vBu6zQjNmkFf
         U5VGRF6UkVEXsJfYFEyz+pSVaajEgOl0uQiKOyDLONy8LUp7IXrG3RQ1Avs39j/SAeXV
         OAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bYE0rVQf1O3noBLJyxgRFXg2ZyihOoC6BamzhuKzDH8=;
        b=j01F44NtO/xhy2PgW1hRay61Gprsd9KiQH07JdPHHKC7dYhMXWLVWw5AhQbxKMYcIR
         r++81us7wZh9PKSoZ6JtSQIHNMy8VajG662cmFgjv/s9m31ZAdW5ukwmknHPf8kfeKVv
         9fcYI/ibmUx80Qq4xUOJXJqk2VG7sEmOJsHuQLyMWG+aerXoGNL+Ko+c6VanY1+vtie4
         C6v3lq8AxzsNNlqUqvlz0h62X9rlJuLHfIDem8KGu62m6J4MSoVItFhhJ9FypRirAzxN
         4CiXTKOBlesc2cxziLyM4jzLjRduGgMDVS/X950pSW9HeDEldTOZcnDaEsrNsUQzKIQG
         /JIA==
X-Gm-Message-State: AGi0PuZqVG+SSCJ/B9+nkZdwMSRSeGX52OHpyT+whxhgjsl0Jgl835mT
        iq4YPz0kd2yhUbdKcvBy6dZgf3NN2tnXSw==
X-Google-Smtp-Source: APiQypILw4EXtWb2jk0d4W2Xq+NwBN3wzvxsK95Jrla/K+jYW+UNx8E13puBVVlHJGoFkoBBRDE/kQ==
X-Received: by 2002:a19:5f04:: with SMTP id t4mr11021066lfb.208.1588581521950;
        Mon, 04 May 2020 01:38:41 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.46.227])
        by smtp.gmail.com with ESMTPSA id z16sm10122418lfq.18.2020.05.04.01.38.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:38:41 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     jgross@suse.com, wei.liu@kernel.org, paul@xen.org,
        ilias.apalodimas@linaro.org
Subject: [PATCH net-next v7 1/2] xen networking: add basic XDP support for xen-netfront
Date:   Mon,  4 May 2020 11:37:53 +0300
Message-Id: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
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

v7:
- use page_pool_dev_alloc_pages() on page allocation
- remove the leftover break statement from netback_changed

v6:
- added the missing SOB line
- fixed subject

v5:
- split netfront/netback changes
- added a sync point between backend/frontend on switching to XDP
- added pagepool API

v4:
- added verbose patch descriprion
- don't expose the XDP headroom offset to the domU guest
- add a modparam to netback to toggle XDP offset
- don't process jumbo frames for now

v3:
- added XDP_TX support (tested with xdping echoserver)
- added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
- moved xdp negotiation to xen-netback

v2:
- avoid data copying while passing to XDP
- tell xen-netback that we need the headroom space

Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
---
 drivers/net/xen-netfront.c | 300 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 296 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8..7be8ee6 100644
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
@@ -159,6 +167,8 @@ struct netfront_info {
 	struct netfront_stats __percpu *rx_stats;
 	struct netfront_stats __percpu *tx_stats;
 
+	bool netback_has_xdp_headroom;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -167,6 +177,9 @@ struct netfront_rx_info {
 	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
 };
 
+static int xennet_xdp_xmit(struct net_device *dev, int n,
+			   struct xdp_frame **frames, u32 flags);
+
 static void skb_entry_set_link(union skb_entry *list, unsigned short id)
 {
 	list->link = id;
@@ -265,8 +278,8 @@ static struct sk_buff *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
 	if (unlikely(!skb))
 		return NULL;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
-	if (!page) {
+	page = page_pool_dev_alloc_pages(queue->page_pool);
+	if (unlikely(!page)) {
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -778,6 +791,53 @@ static int xennet_get_extras(struct netfront_queue *queue,
 	return err;
 }
 
+u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
+		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
+		   struct xdp_buff *xdp)
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
+	xdp->handle = 0;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_TX:
+		get_page(pdata);
+		xdpf = convert_to_xdp_frame(xdp);
+		err = xennet_xdp_xmit(queue->info->netdev, 1, &xdpf, 0);
+		if (unlikely(err < 0))
+			trace_xdp_exception(queue->info->netdev, prog, act);
+		break;
+	case XDP_REDIRECT:
+		get_page(pdata);
+		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
+		if (unlikely(err))
+			trace_xdp_exception(queue->info->netdev, prog, act);
+		xdp_do_flush();
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
 				struct sk_buff_head *list)
@@ -792,6 +852,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
 	int slots = 1;
 	int err = 0;
 	unsigned long ret;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 verdict;
 
 	if (rx->flags & XEN_NETRXF_extra_info) {
 		err = xennet_get_extras(queue, extras, rp);
@@ -827,9 +890,20 @@ static int xennet_get_responses(struct netfront_queue *queue,
 
 		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
 
-		__skb_queue_tail(list, skb);
-
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(queue->xdp_prog);
+		if (xdp_prog && !(rx->flags & XEN_NETRXF_more_data)) {
+			/* currently only a single page contains data */
+			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
+			verdict = xennet_run_xdp(queue,
+				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
+				       rx, xdp_prog, &xdp);
+			if (verdict != XDP_PASS)
+				err = -EINVAL;
+		}
+		rcu_read_unlock();
 next:
+		__skb_queue_tail(list, skb);
 		if (!(rx->flags & XEN_NETRXF_more_data))
 			break;
 
@@ -997,6 +1071,7 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 	struct sk_buff_head rxq;
 	struct sk_buff_head errq;
 	struct sk_buff_head tmpq;
+	struct bpf_prog *xdp_prog;
 	int err;
 
 	spin_lock(&queue->rx_lock);
@@ -1014,6 +1089,12 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 		memcpy(rx, RING_GET_RESPONSE(&queue->rx, i), sizeof(*rx));
 		memset(extras, 0, sizeof(rinfo.extras));
 
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(queue->xdp_prog);
+		if (xdp_prog)
+			rx->offset = XDP_PACKET_HEADROOM;
+		rcu_read_unlock();
+
 		err = xennet_get_responses(queue, &rinfo, rp, &tmpq);
 
 		if (unlikely(err)) {
@@ -1261,6 +1342,156 @@ static void xennet_poll_controller(struct net_device *dev)
 }
 #endif
 
+#define NETBACK_XDP_HEADROOM_DISABLE	0
+#define NETBACK_XDP_HEADROOM_ENABLE	1
+
+static int talk_to_netback_xdp(struct netfront_info *np, int xdp)
+{
+	int err;
+
+	err = xenbus_printf(XBT_NIL, np->xbdev->nodename,
+			     "feature-xdp", "%u", xdp);
+	if (err)
+		pr_debug("Error writing feature-xdp\n");
+
+	return err;
+}
+
+static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+	unsigned int i, err;
+	unsigned long int max_mtu = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
+
+	if (dev->mtu > max_mtu) {
+		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_mtu);
+		return -EINVAL;
+	}
+
+	if (!np->netback_has_xdp_headroom)
+		return 0;
+
+	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
+	if (!old_prog && !prog)
+		return 0;
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
+	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
+
+	err = talk_to_netback_xdp(np, prog ? NETBACK_XDP_HEADROOM_ENABLE:
+				  NETBACK_XDP_HEADROOM_DISABLE);
+	if (err)
+		return err;
+
+	/* avoid race with XDP headroom adjustment */
+	wait_event(module_wq,
+		   xenbus_read_driver_state(np->xbdev->otherend) ==
+		   XenbusStateReconfigured);
+	xenbus_switch_state(np->xbdev, XenbusStateConnected);
+
+	return 0;
+}
+
+static u32 xennet_xdp_query(struct net_device *dev)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	unsigned int num_queues = dev->real_num_tx_queues;
+	unsigned int i;
+	struct netfront_queue *queue;
+	const struct bpf_prog *xdp_prog;
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
+static int xennet_xdp_xmit_one(struct net_device *dev, struct xdp_frame *xdpf)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
+	struct netfront_queue *queue = NULL;
+	unsigned int num_queues = dev->real_num_tx_queues;
+	unsigned long flags;
+	int notify;
+	struct xen_netif_tx_request *tx;
+
+	queue = &np->queues[smp_processor_id() % num_queues];
+
+	spin_lock_irqsave(&queue->tx_lock, flags);
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
+	spin_unlock_irqrestore(&queue->tx_lock, flags);
+	return 0;
+}
+
+static int xennet_xdp_xmit(struct net_device *dev, int n,
+			   struct xdp_frame **frames, u32 flags)
+{
+	int drops = 0;
+	int i, err;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+
+		if (!xdpf)
+			continue;
+		err = xennet_xdp_xmit_one(dev, xdpf);
+		if (err) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+
+	return n - drops;
+}
+
 static const struct net_device_ops xennet_netdev_ops = {
 	.ndo_open            = xennet_open,
 	.ndo_stop            = xennet_close,
@@ -1272,6 +1503,8 @@ static void xennet_poll_controller(struct net_device *dev)
 	.ndo_fix_features    = xennet_fix_features,
 	.ndo_set_features    = xennet_set_features,
 	.ndo_select_queue    = xennet_select_queue,
+	.ndo_bpf            = xennet_xdp,
+	.ndo_xdp_xmit	    = xennet_xdp_xmit,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = xennet_poll_controller,
 #endif
@@ -1419,6 +1652,8 @@ static void xennet_disconnect_backend(struct netfront_info *info)
 		queue->rx_ring_ref = GRANT_INVALID_REF;
 		queue->tx.sring = NULL;
 		queue->rx.sring = NULL;
+
+		page_pool_destroy(queue->page_pool);
 	}
 }
 
@@ -1754,6 +1989,51 @@ static void xennet_destroy_queues(struct netfront_info *info)
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
+		 err = PTR_ERR(queue->page_pool);
+		 queue->page_pool = NULL;
+		 return err;
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
+					 MEM_TYPE_PAGE_ORDER0, NULL);
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
@@ -1779,6 +2059,14 @@ static int xennet_create_queues(struct netfront_info *info,
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
@@ -1825,6 +2113,8 @@ static int talk_to_netback(struct xenbus_device *dev,
 		goto out_unlocked;
 	}
 
+	info->netback_has_xdp_headroom = xenbus_read_unsigned(info->xbdev->otherend,
+							      "feature-xdp-headroom", 0);
 	rtnl_lock();
 	if (info->queues)
 		xennet_destroy_queues(info);
@@ -1959,6 +2249,8 @@ static int xennet_connect(struct net_device *dev)
 	err = talk_to_netback(np->xbdev, np);
 	if (err)
 		return err;
+	if (np->netback_has_xdp_headroom)
+		pr_info("backend supports XDP headroom\n");
 
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
-- 
1.8.3.1

