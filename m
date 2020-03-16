Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BF5186BD2
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 14:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731094AbgCPNKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 09:10:31 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44525 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731025AbgCPNKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 09:10:30 -0400
Received: by mail-lj1-f196.google.com with SMTP id w4so3848314lji.11
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 06:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=yORf4it3Vv0Wn1oq/VUUxw5qCpaXpJiggaRn0bHuwxc=;
        b=LcRjT/QIxGbQlG98lc/84ZZnRRbmx7oDmytob0wYbR/Pp/+kPHl+gFHng5uWfI07+3
         vpg1K+OlKdPYFEqftf0R2HXyOnjSzuJPCg8G4z1+UTHtdOAfu5NqmZ9BiHKFsFYAiYgx
         Z1dn6oSL7S5dBXbncCDg/hhS9YGOZ00XWv2gTFZMJAaq9bUFOqun1nrbIXOUzQLZgwOg
         a+NSBw36u3G449R/5ayZYl9CFQygByfVvkGJLu693YKMfPsnwi3keKrGodDwhnXfs/gU
         o22DvgmY4LZrNJ8RhvCeSfxRtxQe71wjN1lcfi8yEpRiIVu7Cy414SWA1LmrSGwU2KmD
         jQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yORf4it3Vv0Wn1oq/VUUxw5qCpaXpJiggaRn0bHuwxc=;
        b=rWUylfM7skZDF98jGT5qy80zFaaxNirXOHi0ShLaCA7NHmEedQiuREUQDaHdsk+ZI0
         LD7jBZI2nTJOL+iHMha0HYX1CXmu3J0nuIZRRlBynqzg/pcnWy0SL1mTUZcLjUdCQ9Kb
         suU76QjEw5RJ3366COZk/1F0HlXfLLJtXW8xMi86DaiTDKa0Axh1eoCwlGTOht8rXCfg
         BumL6/txTqAa84TFiQ5eci/JosixsQjQdqajgUbrv3Gn3oITpesDbBNlI5SxIUbUEtGM
         YGEyBSFTGNOYyNoWRiRy2N/n6QQTMGChjSu+ir3aucYyiVMq03sMcorHSRnugxtjcI7m
         22ag==
X-Gm-Message-State: ANhLgQ3povbJIeWoIAiiirtCYr7lRmc29pPaMa+VGV3u87KXwG7FcFWk
        6EiB43jNB0eSrorT0yCChowkqUHlEe8=
X-Google-Smtp-Source: ADFU+vtyYp0xwE43zM/6BaohGxXbsXMd/TnivXFXYLplflaL9pHKbK77iBTJGaeqYFaYPf4slH5yOA==
X-Received: by 2002:a2e:920f:: with SMTP id k15mr1714756ljg.178.1584364226498;
        Mon, 16 Mar 2020 06:10:26 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.35.59])
        by smtp.gmail.com with ESMTPSA id o12sm490280ljm.70.2020.03.16.06.10.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 06:10:25 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     jgross@suse.com, ilias.apalodimas@linaro.org, wei.liu@kernel.org,
        paul@xen.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next v4] xen networking: add basic XDP support for xen-netfront
Date:   Mon, 16 Mar 2020 16:09:36 +0300
Message-Id: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds a basic XDP processing to xen-netfront driver.

We ran an XDP program for an RX response received from netback
driver. Also we request xen-netback to adjust data offset for
bpf_xdp_adjust_head() header space for custom headers.

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

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/xen-netback/common.h  |   2 +
 drivers/net/xen-netback/netback.c |   7 ++
 drivers/net/xen-netback/rx.c      |   7 +-
 drivers/net/xen-netback/xenbus.c  |  28 +++++
 drivers/net/xen-netfront.c        | 240 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 282 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 05847eb..4a148d6 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -280,6 +280,7 @@ struct xenvif {
 	u8 ip_csum:1;
 	u8 ipv6_csum:1;
 	u8 multicast_control:1;
+	u8 xdp_enabled:1;
 
 	/* Is this interface disabled? True when backend discovers
 	 * frontend is rogue.
@@ -395,6 +396,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 irqreturn_t xenvif_interrupt(int irq, void *dev_id);
 
 extern bool separate_tx_rx_irq;
+extern bool provides_xdp_headroom;
 
 extern unsigned int rx_drain_timeout_msecs;
 extern unsigned int rx_stall_timeout_msecs;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 315dfc6..6dfca72 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -96,6 +96,13 @@
 module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
 MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
 
+/* The module parameter tells that we have to put data
+ * for xen-netfront with the XDP_PACKET_HEADROOM offset
+ * needed for XDP processing
+ */
+bool provides_xdp_headroom = true;
+module_param(provides_xdp_headroom, bool, 0644);
+
 static void xenvif_idx_release(struct xenvif_queue *queue, u16 pending_idx,
 			       u8 status);
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index ef58870..aba826b 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -33,6 +33,11 @@
 #include <xen/xen.h>
 #include <xen/events.h>
 
+static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
+{
+	return (vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0);
+}
+
 static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 {
 	RING_IDX prod, cons;
@@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
 				struct xen_netif_rx_request *req,
 				struct xen_netif_rx_response *rsp)
 {
-	unsigned int offset = 0;
+	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
 	unsigned int flags;
 
 	do {
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 286054b..7c0450e 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
 	}
 }
 
+static void read_xenbus_frontend_xdp(struct backend_info *be,
+				      struct xenbus_device *dev)
+{
+	struct xenvif *vif = be->vif;
+	unsigned int val;
+	int err;
+
+	err = xenbus_scanf(XBT_NIL, dev->otherend,
+			   "feature-xdp", "%u", &val);
+	if (err < 0)
+		return;
+	vif->xdp_enabled = val;
+}
+
 /**
  * Callback received when the frontend's state changes.
  */
@@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device *dev,
 		set_backend_state(be, XenbusStateConnected);
 		break;
 
+	case XenbusStateReconfiguring:
+		read_xenbus_frontend_xdp(be, dev);
+		xenbus_switch_state(dev, XenbusStateReconfigured);
+		break;
+
 	case XenbusStateClosing:
 		set_backend_state(be, XenbusStateClosing);
 		break;
@@ -1036,6 +1055,15 @@ static int netback_probe(struct xenbus_device *dev,
 			goto abort_transaction;
 		}
 
+		/* we can adjust a headroom for netfront XDP processing */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-xdp-headroom", "%d",
+				    !!provides_xdp_headroom);
+		if (err) {
+			message = "writing feature-xdp-headroom";
+			goto abort_transaction;
+		}
+
 		/* We don't support rx-flip path (except old guests who
 		 * don't grok this feature flag).
 		 */
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8..c06ae57 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -44,6 +44,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <net/ip.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -102,6 +104,8 @@ struct netfront_queue {
 	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
 	struct netfront_info *info;
 
+	struct bpf_prog __rcu *xdp_prog;
+
 	struct napi_struct napi;
 
 	/* Split event channels support, tx_* == rx_* when using
@@ -144,6 +148,8 @@ struct netfront_queue {
 	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
 	grant_ref_t gref_rx_head;
 	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
+
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct netfront_info {
@@ -159,6 +165,8 @@ struct netfront_info {
 	struct netfront_stats __percpu *rx_stats;
 	struct netfront_stats __percpu *tx_stats;
 
+	bool netback_has_xdp_headroom;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -167,6 +175,9 @@ struct netfront_rx_info {
 	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
 };
 
+static int xennet_xdp_xmit(struct net_device *dev, int n,
+			   struct xdp_frame **frames, u32 flags);
+
 static void skb_entry_set_link(union skb_entry *list, unsigned short id)
 {
 	list->link = id;
@@ -406,7 +417,8 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
 			queue->grant_tx_ref[id] = GRANT_INVALID_REF;
 			queue->grant_tx_page[id] = NULL;
 			add_id_to_freelist(&queue->tx_skb_freelist, queue->tx_skbs, id);
-			dev_kfree_skb_irq(skb);
+			if (skb)
+				dev_kfree_skb_irq(skb);
 		}
 
 		queue->tx.rsp_cons = prod;
@@ -778,6 +790,52 @@ static int xennet_get_extras(struct netfront_queue *queue,
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
+		xdpf = convert_to_xdp_frame(xdp);
+		err = xennet_xdp_xmit(queue->info->netdev, 1,
+				&xdpf, 0);
+		if (unlikely(err < 0))
+			trace_xdp_exception(queue->info->netdev, prog, act);
+		break;
+	case XDP_REDIRECT:
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
@@ -792,6 +850,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
 	int slots = 1;
 	int err = 0;
 	unsigned long ret;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 verdict;
 
 	if (rx->flags & XEN_NETRXF_extra_info) {
 		err = xennet_get_extras(queue, extras, rp);
@@ -827,6 +888,21 @@ static int xennet_get_responses(struct netfront_queue *queue,
 
 		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
 
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(queue->xdp_prog);
+		if (xdp_prog && !(rx->flags & XEN_NETRXF_more_data)) {
+			/* currently only a single page contains data */
+			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
+			verdict = xennet_run_xdp(queue,
+				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
+				       rx, xdp_prog, &xdp);
+			if (verdict != XDP_PASS && verdict != XDP_TX) {
+				err = -EINVAL;
+				goto next;
+			}
+
+		}
+		rcu_read_unlock();
 		__skb_queue_tail(list, skb);
 
 next:
@@ -1261,6 +1337,144 @@ static void xennet_poll_controller(struct net_device *dev)
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
+	err = talk_to_netback_xdp(np, old_prog ? NETBACK_XDP_HEADROOM_DISABLE:
+				  NETBACK_XDP_HEADROOM_ENABLE);
+	if (err)
+		return err;
+
+	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
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
@@ -1272,6 +1486,8 @@ static void xennet_poll_controller(struct net_device *dev)
 	.ndo_fix_features    = xennet_fix_features,
 	.ndo_set_features    = xennet_set_features,
 	.ndo_select_queue    = xennet_select_queue,
+	.ndo_bpf            = xennet_xdp,
+	.ndo_xdp_xmit	    = xennet_xdp_xmit,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = xennet_poll_controller,
 #endif
@@ -1779,6 +1995,21 @@ static int xennet_create_queues(struct netfront_info *info,
 			break;
 		}
 
+		ret = xdp_rxq_info_reg(&queue->xdp_rxq, queue->info->netdev,
+				       queue->id);
+		if (ret) {
+			dev_err(&info->xbdev->dev, "xdp_rxq_info_reg failed\n");
+			return -EINVAL;
+		}
+
+		ret = xdp_rxq_info_reg_mem_model(&queue->xdp_rxq,
+						 MEM_TYPE_PAGE_ORDER0, NULL);
+		if (ret) {
+			dev_err(&info->xbdev->dev, "xdp_rxq_info_reg_mem_model failed\n");
+			return -EINVAL;
+		}
+
+
 		netif_napi_add(queue->info->netdev, &queue->napi,
 			       xennet_poll, 64);
 		if (netif_running(info->netdev))
@@ -1825,6 +2056,8 @@ static int talk_to_netback(struct xenbus_device *dev,
 		goto out_unlocked;
 	}
 
+	info->netback_has_xdp_headroom = xenbus_read_unsigned(info->xbdev->otherend,
+							      "feature-xdp-headroom", 0);
 	rtnl_lock();
 	if (info->queues)
 		xennet_destroy_queues(info);
@@ -1959,6 +2192,8 @@ static int xennet_connect(struct net_device *dev)
 	err = talk_to_netback(np->xbdev, np);
 	if (err)
 		return err;
+	if (np->netback_has_xdp_headroom)
+		pr_info("backend supports XDP headroom\n");
 
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
@@ -2019,7 +2254,10 @@ static void netback_changed(struct xenbus_device *dev,
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
 	case XenbusStateReconfiguring:
+		break;
 	case XenbusStateReconfigured:
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
 	case XenbusStateUnknown:
 		break;
 
-- 
1.8.3.1

