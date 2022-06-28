Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECA555EE4D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiF1TvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C79D3A70D;
        Tue, 28 Jun 2022 12:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445748; x=1687981748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VL3J+vONz0M3On4/kTP4hoS53bYjpYTOUOqGD1HRah8=;
  b=hMw9UQiqeWn6hD0H+8eF9kgMBJRCtSM0LWO/KBLtUr7tsWRY0/ywstFt
   aYxQ8u/ed5Lwvve9fhGmEgTUrcfo+Fpt5gNLEdxJs232eilO0QSfkEGgn
   kHuhVRVCkkkHEw+QecyMOj4wgwBV3QPzGtPR3acbW1P7ReRh1JKPshEhn
   WGeA98QCmluKyCeQ7ytDcFqybodKrR/oeaAmP9ZvTzm1+5cPa6gSlJDyk
   rG4GTxpzuj0YDu8c3UOE+I11zpUC3cWzB07FdfksRJUi/VIzIdUsIRTmn
   mpyZexXt64S1NJG4HNI3DTOht/1+0RUMjgTNluau4oO5xqWdJFgnYvUez
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568045"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568045"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="587988484"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2022 12:49:02 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr95022013;
        Tue, 28 Jun 2022 20:49:00 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 05/52] net, xdp: decouple XDP code from the core networking code
Date:   Tue, 28 Jun 2022 21:47:25 +0200
Message-Id: <20220628194812.1453059-6-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are a couple of rather big pieces of purely XDP
code residing in `net/core/dev.c` and `net/core/filter.c`, and they
won't get smaller any time soon.
To make it more scalable, move them to the new separate files inside
`net/bpf/`, which is almost empty now, along with `net/core/xdp.c`.
This goes so well so that we only had to make 3 functions global
which were static previously (+1 static key). The only mentions of
XDP left in `filter.c` are helpers which share code with the skb
variants and it would cost much more to make the shared code global
instead.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 MAINTAINERS                    |   4 +-
 include/linux/filter.h         |   2 +
 include/linux/netdevice.h      |   5 +
 net/bpf/Makefile               |   5 +-
 net/{core/xdp.c => bpf/core.c} |   2 +-
 net/bpf/dev.c                  | 776 ++++++++++++++++++++++++++++
 net/bpf/prog_ops.c             | 911 +++++++++++++++++++++++++++++++++
 net/core/Makefile              |   2 +-
 net/core/dev.c                 | 771 ----------------------------
 net/core/dev.h                 |   4 -
 net/core/filter.c              | 883 +-------------------------------
 11 files changed, 1705 insertions(+), 1660 deletions(-)
 rename net/{core/xdp.c => bpf/core.c} (99%)
 create mode 100644 net/bpf/dev.c
 create mode 100644 net/bpf/prog_ops.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ca95b1833b97..91190e12a157 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21726,7 +21726,9 @@ F:	include/net/xdp_priv.h
 F:	include/trace/events/xdp.h
 F:	kernel/bpf/cpumap.c
 F:	kernel/bpf/devmap.c
-F:	net/core/xdp.c
+F:	net/bpf/core.c
+F:	net/bpf/dev.c
+F:	net/bpf/prog_ops.c
 F:	samples/bpf/xdp*
 F:	tools/testing/selftests/bpf/*xdp*
 F:	tools/testing/selftests/bpf/*/*xdp*
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 4c1a8b247545..360e60a425ad 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -992,6 +992,8 @@ void xdp_do_flush(void);
 #define xdp_do_flush_map xdp_do_flush
 
 void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act);
+const struct bpf_func_proto *xdp_inet_func_proto(enum bpf_func_id func_id);
+bool xdp_helper_changes_pkt_data(const void *func);
 
 #ifdef CONFIG_INET
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 89afa4f7747d..0b8169c23f22 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3848,7 +3848,12 @@ struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *d
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
 
+DECLARE_STATIC_KEY_FALSE(generic_xdp_needed_key);
+
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
+int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
+		      int fd, int expected_fd, u32 flags);
+void dev_xdp_uninstall(struct net_device *dev);
 u8 dev_xdp_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
 
diff --git a/net/bpf/Makefile b/net/bpf/Makefile
index 1ebe270bde23..715550f9048b 100644
--- a/net/bpf/Makefile
+++ b/net/bpf/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_BPF_SYSCALL)	:= test_run.o
+
+obj-y				:= core.o dev.o prog_ops.o
+
+obj-$(CONFIG_BPF_SYSCALL)	+= test_run.o
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL)	+= bpf_dummy_struct_ops.o
 endif
diff --git a/net/core/xdp.c b/net/bpf/core.c
similarity index 99%
rename from net/core/xdp.c
rename to net/bpf/core.c
index 24420209bf0e..fbb72792320a 100644
--- a/net/core/xdp.c
+++ b/net/bpf/core.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* net/core/xdp.c
+/* net/bpf/core.c
  *
  * Copyright (c) 2017 Jesper Dangaard Brouer, Red Hat Inc.
  */
diff --git a/net/bpf/dev.c b/net/bpf/dev.c
new file mode 100644
index 000000000000..dfe0402947f8
--- /dev/null
+++ b/net/bpf/dev.c
@@ -0,0 +1,776 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <trace/events/xdp.h>
+
+DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
+
+static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
+{
+	struct net_device *dev = skb->dev;
+	struct netdev_rx_queue *rxqueue;
+
+	rxqueue = dev->_rx;
+
+	if (skb_rx_queue_recorded(skb)) {
+		u16 index = skb_get_rx_queue(skb);
+
+		if (unlikely(index >= dev->real_num_rx_queues)) {
+			WARN_ONCE(dev->real_num_rx_queues > 1,
+				  "%s received packet on queue %u, but number "
+				  "of RX queues is %u\n",
+				  dev->name, index, dev->real_num_rx_queues);
+
+			return rxqueue; /* Return first rxqueue */
+		}
+		rxqueue += index;
+	}
+	return rxqueue;
+}
+
+u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
+			     struct bpf_prog *xdp_prog)
+{
+	void *orig_data, *orig_data_end, *hard_start;
+	struct netdev_rx_queue *rxqueue;
+	bool orig_bcast, orig_host;
+	u32 mac_len, frame_sz;
+	__be16 orig_eth_type;
+	struct ethhdr *eth;
+	u32 metalen, act;
+	int off;
+
+	/* The XDP program wants to see the packet starting at the MAC
+	 * header.
+	 */
+	mac_len = skb->data - skb_mac_header(skb);
+	hard_start = skb->data - skb_headroom(skb);
+
+	/* SKB "head" area always have tailroom for skb_shared_info */
+	frame_sz = (void *)skb_end_pointer(skb) - hard_start;
+	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+	rxqueue = netif_get_rxqueue(skb);
+	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
+	xdp_prepare_buff(xdp, hard_start, skb_headroom(skb) - mac_len,
+			 skb_headlen(skb) + mac_len, true);
+
+	orig_data_end = xdp->data_end;
+	orig_data = xdp->data;
+	eth = (struct ethhdr *)xdp->data;
+	orig_host = ether_addr_equal_64bits(eth->h_dest, skb->dev->dev_addr);
+	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
+	orig_eth_type = eth->h_proto;
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+
+	/* check if bpf_xdp_adjust_head was used */
+	off = xdp->data - orig_data;
+	if (off) {
+		if (off > 0)
+			__skb_pull(skb, off);
+		else if (off < 0)
+			__skb_push(skb, -off);
+
+		skb->mac_header += off;
+		skb_reset_network_header(skb);
+	}
+
+	/* check if bpf_xdp_adjust_tail was used */
+	off = xdp->data_end - orig_data_end;
+	if (off != 0) {
+		skb_set_tail_pointer(skb, xdp->data_end - xdp->data);
+		skb->len += off; /* positive on grow, negative on shrink */
+	}
+
+	/* check if XDP changed eth hdr such SKB needs update */
+	eth = (struct ethhdr *)xdp->data;
+	if ((orig_eth_type != eth->h_proto) ||
+	    (orig_host != ether_addr_equal_64bits(eth->h_dest,
+						  skb->dev->dev_addr)) ||
+	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
+		__skb_push(skb, ETH_HLEN);
+		skb->pkt_type = PACKET_HOST;
+		skb->protocol = eth_type_trans(skb, skb->dev);
+	}
+
+	/* Redirect/Tx gives L2 packet, code that will reuse skb must __skb_pull
+	 * before calling us again on redirect path. We do not call do_redirect
+	 * as we leave that up to the caller.
+	 *
+	 * Caller is responsible for managing lifetime of skb (i.e. calling
+	 * kfree_skb in response to actions it cannot handle/XDP_DROP).
+	 */
+	switch (act) {
+	case XDP_REDIRECT:
+	case XDP_TX:
+		__skb_push(skb, mac_len);
+		break;
+	case XDP_PASS:
+		metalen = xdp->data - xdp->data_meta;
+		if (metalen)
+			skb_metadata_set(skb, metalen);
+		break;
+	}
+
+	return act;
+}
+
+static u32 netif_receive_generic_xdp(struct sk_buff *skb,
+				     struct xdp_buff *xdp,
+				     struct bpf_prog *xdp_prog)
+{
+	u32 act = XDP_DROP;
+
+	/* Reinjected packets coming from act_mirred or similar should
+	 * not get XDP generic processing.
+	 */
+	if (skb_is_redirected(skb))
+		return XDP_PASS;
+
+	/* XDP packets must be linear and must have sufficient headroom
+	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
+	 * native XDP provides, thus we need to do it here as well.
+	 */
+	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
+		int troom = skb->tail + skb->data_len - skb->end;
+
+		/* In case we have to go down the path and also linearize,
+		 * then lets do the pskb_expand_head() work just once here.
+		 */
+		if (pskb_expand_head(skb,
+				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
+				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
+			goto do_drop;
+		if (skb_linearize(skb))
+			goto do_drop;
+	}
+
+	act = bpf_prog_run_generic_xdp(skb, xdp, xdp_prog);
+	switch (act) {
+	case XDP_REDIRECT:
+	case XDP_TX:
+	case XDP_PASS:
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(skb->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(skb->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_DROP:
+	do_drop:
+		kfree_skb(skb);
+		break;
+	}
+
+	return act;
+}
+
+/* When doing generic XDP we have to bypass the qdisc layer and the
+ * network taps in order to match in-driver-XDP behavior.
+ */
+void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
+{
+	struct net_device *dev = skb->dev;
+	struct netdev_queue *txq;
+	bool free_skb = true;
+	int cpu, rc;
+
+	txq = netdev_core_pick_tx(dev, skb, NULL);
+	cpu = smp_processor_id();
+	HARD_TX_LOCK(dev, txq, cpu);
+	if (!netif_xmit_stopped(txq)) {
+		rc = netdev_start_xmit(skb, dev, txq, 0);
+		if (dev_xmit_complete(rc))
+			free_skb = false;
+	}
+	HARD_TX_UNLOCK(dev, txq);
+	if (free_skb) {
+		trace_xdp_exception(dev, xdp_prog, XDP_TX);
+		kfree_skb(skb);
+	}
+}
+
+int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
+{
+	if (xdp_prog) {
+		struct xdp_buff xdp;
+		u32 act;
+		int err;
+
+		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
+		if (act != XDP_PASS) {
+			switch (act) {
+			case XDP_REDIRECT:
+				err = xdp_do_generic_redirect(skb->dev, skb,
+							      &xdp, xdp_prog);
+				if (err)
+					goto out_redir;
+				break;
+			case XDP_TX:
+				generic_xdp_tx(skb, xdp_prog);
+				break;
+			}
+			return XDP_DROP;
+		}
+	}
+	return XDP_PASS;
+out_redir:
+	kfree_skb_reason(skb, SKB_DROP_REASON_XDP);
+	return XDP_DROP;
+}
+EXPORT_SYMBOL_GPL(do_xdp_generic);
+
+/**
+ *	dev_disable_gro_hw - disable HW Generic Receive Offload on a device
+ *	@dev: device
+ *
+ *	Disable HW Generic Receive Offload (GRO_HW) on a net device.  Must be
+ *	called under RTNL.  This is needed if Generic XDP is installed on
+ *	the device.
+ */
+static void dev_disable_gro_hw(struct net_device *dev)
+{
+	dev->wanted_features &= ~NETIF_F_GRO_HW;
+	netdev_update_features(dev);
+
+	if (unlikely(dev->features & NETIF_F_GRO_HW))
+		netdev_WARN(dev, "failed to disable GRO_HW!\n");
+}
+
+static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct bpf_prog *old = rtnl_dereference(dev->xdp_prog);
+	struct bpf_prog *new = xdp->prog;
+	int ret = 0;
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		rcu_assign_pointer(dev->xdp_prog, new);
+		if (old)
+			bpf_prog_put(old);
+
+		if (old && !new) {
+			static_branch_dec(&generic_xdp_needed_key);
+		} else if (new && !old) {
+			static_branch_inc(&generic_xdp_needed_key);
+			dev_disable_lro(dev);
+			dev_disable_gro_hw(dev);
+		}
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+struct bpf_xdp_link {
+	struct bpf_link link;
+	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
+	int flags;
+};
+
+typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+
+static enum bpf_xdp_mode dev_xdp_mode(struct net_device *dev, u32 flags)
+{
+	if (flags & XDP_FLAGS_HW_MODE)
+		return XDP_MODE_HW;
+	if (flags & XDP_FLAGS_DRV_MODE)
+		return XDP_MODE_DRV;
+	if (flags & XDP_FLAGS_SKB_MODE)
+		return XDP_MODE_SKB;
+	return dev->netdev_ops->ndo_bpf ? XDP_MODE_DRV : XDP_MODE_SKB;
+}
+
+static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
+{
+	switch (mode) {
+	case XDP_MODE_SKB:
+		return generic_xdp_install;
+	case XDP_MODE_DRV:
+	case XDP_MODE_HW:
+		return dev->netdev_ops->ndo_bpf;
+	default:
+		return NULL;
+	}
+}
+
+static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
+					 enum bpf_xdp_mode mode)
+{
+	return dev->xdp_state[mode].link;
+}
+
+static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
+				     enum bpf_xdp_mode mode)
+{
+	struct bpf_xdp_link *link = dev_xdp_link(dev, mode);
+
+	if (link)
+		return link->link.prog;
+	return dev->xdp_state[mode].prog;
+}
+
+u8 dev_xdp_prog_count(struct net_device *dev)
+{
+	u8 count = 0;
+	int i;
+
+	for (i = 0; i < __MAX_XDP_MODE; i++)
+		if (dev->xdp_state[i].prog || dev->xdp_state[i].link)
+			count++;
+	return count;
+}
+EXPORT_SYMBOL_GPL(dev_xdp_prog_count);
+
+u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
+{
+	struct bpf_prog *prog = dev_xdp_prog(dev, mode);
+
+	return prog ? prog->aux->id : 0;
+}
+
+static void dev_xdp_set_link(struct net_device *dev, enum bpf_xdp_mode mode,
+			     struct bpf_xdp_link *link)
+{
+	dev->xdp_state[mode].link = link;
+	dev->xdp_state[mode].prog = NULL;
+}
+
+static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode mode,
+			     struct bpf_prog *prog)
+{
+	dev->xdp_state[mode].link = NULL;
+	dev->xdp_state[mode].prog = prog;
+}
+
+static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
+			   bpf_op_t bpf_op, struct netlink_ext_ack *extack,
+			   u32 flags, struct bpf_prog *prog)
+{
+	struct netdev_bpf xdp;
+	int err;
+
+	memset(&xdp, 0, sizeof(xdp));
+	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
+	xdp.extack = extack;
+	xdp.flags = flags;
+	xdp.prog = prog;
+
+	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
+	 * "moved" into driver), so they don't increment it on their own, but
+	 * they do decrement refcnt when program is detached or replaced.
+	 * Given net_device also owns link/prog, we need to bump refcnt here
+	 * to prevent drivers from underflowing it.
+	 */
+	if (prog)
+		bpf_prog_inc(prog);
+	err = bpf_op(dev, &xdp);
+	if (err) {
+		if (prog)
+			bpf_prog_put(prog);
+		return err;
+	}
+
+	if (mode != XDP_MODE_HW)
+		bpf_prog_change_xdp(dev_xdp_prog(dev, mode), prog);
+
+	return 0;
+}
+
+void dev_xdp_uninstall(struct net_device *dev)
+{
+	struct bpf_xdp_link *link;
+	struct bpf_prog *prog;
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+
+	ASSERT_RTNL();
+
+	for (mode = XDP_MODE_SKB; mode < __MAX_XDP_MODE; mode++) {
+		prog = dev_xdp_prog(dev, mode);
+		if (!prog)
+			continue;
+
+		bpf_op = dev_xdp_bpf_op(dev, mode);
+		if (!bpf_op)
+			continue;
+
+		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
+
+		/* auto-detach link from net device */
+		link = dev_xdp_link(dev, mode);
+		if (link)
+			link->dev = NULL;
+		else
+			bpf_prog_put(prog);
+
+		dev_xdp_set_link(dev, mode, NULL);
+	}
+}
+
+static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack,
+			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
+			  struct bpf_prog *old_prog, u32 flags)
+{
+	unsigned int num_modes = hweight32(flags & XDP_FLAGS_MODES);
+	struct bpf_prog *cur_prog;
+	struct net_device *upper;
+	struct list_head *iter;
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+	int err;
+
+	ASSERT_RTNL();
+
+	/* either link or prog attachment, never both */
+	if (link && (new_prog || old_prog))
+		return -EINVAL;
+	/* link supports only XDP mode flags */
+	if (link && (flags & ~XDP_FLAGS_MODES)) {
+		NL_SET_ERR_MSG(extack, "Invalid XDP flags for BPF link attachment");
+		return -EINVAL;
+	}
+	/* just one XDP mode bit should be set, zero defaults to drv/skb mode */
+	if (num_modes > 1) {
+		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can be set");
+		return -EINVAL;
+	}
+	/* avoid ambiguity if offload + drv/skb mode progs are both loaded */
+	if (!num_modes && dev_xdp_prog_count(dev) > 1) {
+		NL_SET_ERR_MSG(extack,
+			       "More than one program loaded, unset mode is ambiguous");
+		return -EINVAL;
+	}
+	/* old_prog != NULL implies XDP_FLAGS_REPLACE is set */
+	if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
+		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not specified");
+		return -EINVAL;
+	}
+
+	mode = dev_xdp_mode(dev, flags);
+	/* can't replace attached link */
+	if (dev_xdp_link(dev, mode)) {
+		NL_SET_ERR_MSG(extack, "Can't replace active BPF XDP link");
+		return -EBUSY;
+	}
+
+	/* don't allow if an upper device already has a program */
+	netdev_for_each_upper_dev_rcu(dev, upper, iter) {
+		if (dev_xdp_prog_count(upper) > 0) {
+			NL_SET_ERR_MSG(extack, "Cannot attach when an upper device already has a program");
+			return -EEXIST;
+		}
+	}
+
+	cur_prog = dev_xdp_prog(dev, mode);
+	/* can't replace attached prog with link */
+	if (link && cur_prog) {
+		NL_SET_ERR_MSG(extack, "Can't replace active XDP program with BPF link");
+		return -EBUSY;
+	}
+	if ((flags & XDP_FLAGS_REPLACE) && cur_prog != old_prog) {
+		NL_SET_ERR_MSG(extack, "Active program does not match expected");
+		return -EEXIST;
+	}
+
+	/* put effective new program into new_prog */
+	if (link)
+		new_prog = link->link.prog;
+
+	if (new_prog) {
+		bool offload = mode == XDP_MODE_HW;
+		enum bpf_xdp_mode other_mode = mode == XDP_MODE_SKB
+					       ? XDP_MODE_DRV : XDP_MODE_SKB;
+
+		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
+			NL_SET_ERR_MSG(extack, "XDP program already attached");
+			return -EBUSY;
+		}
+		if (!offload && dev_xdp_prog(dev, other_mode)) {
+			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
+			return -EEXIST;
+		}
+		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
+			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
+			return -EINVAL;
+		}
+		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
+			return -EINVAL;
+		}
+		if (new_prog->expected_attach_type == BPF_XDP_CPUMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
+			return -EINVAL;
+		}
+	}
+
+	/* don't call drivers if the effective program didn't change */
+	if (new_prog != cur_prog) {
+		bpf_op = dev_xdp_bpf_op(dev, mode);
+		if (!bpf_op) {
+			NL_SET_ERR_MSG(extack, "Underlying driver does not support XDP in native mode");
+			return -EOPNOTSUPP;
+		}
+
+		err = dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
+		if (err)
+			return err;
+	}
+
+	if (link)
+		dev_xdp_set_link(dev, mode, link);
+	else
+		dev_xdp_set_prog(dev, mode, new_prog);
+	if (cur_prog)
+		bpf_prog_put(cur_prog);
+
+	return 0;
+}
+
+static int dev_xdp_attach_link(struct net_device *dev,
+			       struct netlink_ext_ack *extack,
+			       struct bpf_xdp_link *link)
+{
+	return dev_xdp_attach(dev, extack, link, NULL, NULL, link->flags);
+}
+
+static int dev_xdp_detach_link(struct net_device *dev,
+			       struct netlink_ext_ack *extack,
+			       struct bpf_xdp_link *link)
+{
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+
+	ASSERT_RTNL();
+
+	mode = dev_xdp_mode(dev, link->flags);
+	if (dev_xdp_link(dev, mode) != link)
+		return -EINVAL;
+
+	bpf_op = dev_xdp_bpf_op(dev, mode);
+	WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
+	dev_xdp_set_link(dev, mode, NULL);
+	return 0;
+}
+
+static void bpf_xdp_link_release(struct bpf_link *link)
+{
+	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
+
+	rtnl_lock();
+
+	/* if racing with net_device's tear down, xdp_link->dev might be
+	 * already NULL, in which case link was already auto-detached
+	 */
+	if (xdp_link->dev) {
+		WARN_ON(dev_xdp_detach_link(xdp_link->dev, NULL, xdp_link));
+		xdp_link->dev = NULL;
+	}
+
+	rtnl_unlock();
+}
+
+static int bpf_xdp_link_detach(struct bpf_link *link)
+{
+	bpf_xdp_link_release(link);
+	return 0;
+}
+
+static void bpf_xdp_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
+
+	kfree(xdp_link);
+}
+
+static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
+				     struct seq_file *seq)
+{
+	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
+	u32 ifindex = 0;
+
+	rtnl_lock();
+	if (xdp_link->dev)
+		ifindex = xdp_link->dev->ifindex;
+	rtnl_unlock();
+
+	seq_printf(seq, "ifindex:\t%u\n", ifindex);
+}
+
+static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
+				       struct bpf_link_info *info)
+{
+	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
+	u32 ifindex = 0;
+
+	rtnl_lock();
+	if (xdp_link->dev)
+		ifindex = xdp_link->dev->ifindex;
+	rtnl_unlock();
+
+	info->xdp.ifindex = ifindex;
+	return 0;
+}
+
+static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
+			       struct bpf_prog *old_prog)
+{
+	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+	int err = 0;
+
+	rtnl_lock();
+
+	/* link might have been auto-released already, so fail */
+	if (!xdp_link->dev) {
+		err = -ENOLINK;
+		goto out_unlock;
+	}
+
+	if (old_prog && link->prog != old_prog) {
+		err = -EPERM;
+		goto out_unlock;
+	}
+	old_prog = link->prog;
+	if (old_prog->type != new_prog->type ||
+	    old_prog->expected_attach_type != new_prog->expected_attach_type) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (old_prog == new_prog) {
+		/* no-op, don't disturb drivers */
+		bpf_prog_put(new_prog);
+		goto out_unlock;
+	}
+
+	mode = dev_xdp_mode(xdp_link->dev, xdp_link->flags);
+	bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
+	err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
+			      xdp_link->flags, new_prog);
+	if (err)
+		goto out_unlock;
+
+	old_prog = xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	rtnl_unlock();
+	return err;
+}
+
+static const struct bpf_link_ops bpf_xdp_link_lops = {
+	.release = bpf_xdp_link_release,
+	.dealloc = bpf_xdp_link_dealloc,
+	.detach = bpf_xdp_link_detach,
+	.show_fdinfo = bpf_xdp_link_show_fdinfo,
+	.fill_link_info = bpf_xdp_link_fill_link_info,
+	.update_prog = bpf_xdp_link_update,
+};
+
+int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct bpf_link_primer link_primer;
+	struct bpf_xdp_link *link;
+	struct net_device *dev;
+	int err, fd;
+
+	rtnl_lock();
+	dev = dev_get_by_index(net, attr->link_create.target_ifindex);
+	if (!dev) {
+		rtnl_unlock();
+		return -EINVAL;
+	}
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog);
+	link->dev = dev;
+	link->flags = attr->link_create.flags;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		goto unlock;
+	}
+
+	err = dev_xdp_attach_link(dev, NULL, link);
+	rtnl_unlock();
+
+	if (err) {
+		link->dev = NULL;
+		bpf_link_cleanup(&link_primer);
+		goto out_put_dev;
+	}
+
+	fd = bpf_link_settle(&link_primer);
+	/* link itself doesn't hold dev's refcnt to not complicate shutdown */
+	dev_put(dev);
+	return fd;
+
+unlock:
+	rtnl_unlock();
+
+out_put_dev:
+	dev_put(dev);
+	return err;
+}
+
+/**
+ *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
+ *	@dev: device
+ *	@extack: netlink extended ack
+ *	@fd: new program fd or negative value to clear
+ *	@expected_fd: old program fd that userspace expects to replace or clear
+ *	@flags: xdp-related flags
+ *
+ *	Set or clear a bpf program for a device
+ */
+int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
+		      int fd, int expected_fd, u32 flags)
+{
+	enum bpf_xdp_mode mode = dev_xdp_mode(dev, flags);
+	struct bpf_prog *new_prog = NULL, *old_prog = NULL;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (fd >= 0) {
+		new_prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
+						 mode != XDP_MODE_SKB);
+		if (IS_ERR(new_prog))
+			return PTR_ERR(new_prog);
+	}
+
+	if (expected_fd >= 0) {
+		old_prog = bpf_prog_get_type_dev(expected_fd, BPF_PROG_TYPE_XDP,
+						 mode != XDP_MODE_SKB);
+		if (IS_ERR(old_prog)) {
+			err = PTR_ERR(old_prog);
+			old_prog = NULL;
+			goto err_out;
+		}
+	}
+
+	err = dev_xdp_attach(dev, extack, NULL, new_prog, old_prog, flags);
+
+err_out:
+	if (err && new_prog)
+		bpf_prog_put(new_prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+	return err;
+}
diff --git a/net/bpf/prog_ops.c b/net/bpf/prog_ops.c
new file mode 100644
index 000000000000..33f02842e715
--- /dev/null
+++ b/net/bpf/prog_ops.c
@@ -0,0 +1,911 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <net/xdp_sock.h>
+#include <trace/events/xdp.h>
+
+BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+{
+	return xdp_get_buff_len(xdp);
+}
+
+static const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
+	.func		= bpf_xdp_get_buff_len,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
+BTF_ID_LIST_SINGLE(bpf_xdp_get_buff_len_bpf_ids, struct, xdp_buff)
+
+const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto = {
+	.func		= bpf_xdp_get_buff_len,
+	.gpl_only	= false,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_xdp_get_buff_len_bpf_ids[0],
+};
+
+static unsigned long xdp_get_metalen(const struct xdp_buff *xdp)
+{
+	return xdp_data_meta_unsupported(xdp) ? 0 :
+	       xdp->data - xdp->data_meta;
+}
+
+BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
+{
+	void *xdp_frame_end = xdp->data_hard_start + sizeof(struct xdp_frame);
+	unsigned long metalen = xdp_get_metalen(xdp);
+	void *data_start = xdp_frame_end + metalen;
+	void *data = xdp->data + offset;
+
+	if (unlikely(data < data_start ||
+		     data > xdp->data_end - ETH_HLEN))
+		return -EINVAL;
+
+	if (metalen)
+		memmove(xdp->data_meta + offset,
+			xdp->data_meta, metalen);
+	xdp->data_meta += offset;
+	xdp->data = data;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
+	.func		= bpf_xdp_adjust_head,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
+			     void *buf, unsigned long len, bool flush)
+{
+	unsigned long ptr_len, ptr_off = 0;
+	skb_frag_t *next_frag, *end_frag;
+	struct skb_shared_info *sinfo;
+	void *src, *dst;
+	u8 *ptr_buf;
+
+	if (likely(xdp->data_end - xdp->data >= off + len)) {
+		src = flush ? buf : xdp->data + off;
+		dst = flush ? xdp->data + off : buf;
+		memcpy(dst, src, len);
+		return;
+	}
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	end_frag = &sinfo->frags[sinfo->nr_frags];
+	next_frag = &sinfo->frags[0];
+
+	ptr_len = xdp->data_end - xdp->data;
+	ptr_buf = xdp->data;
+
+	while (true) {
+		if (off < ptr_off + ptr_len) {
+			unsigned long copy_off = off - ptr_off;
+			unsigned long copy_len = min(len, ptr_len - copy_off);
+
+			src = flush ? buf : ptr_buf + copy_off;
+			dst = flush ? ptr_buf + copy_off : buf;
+			memcpy(dst, src, copy_len);
+
+			off += copy_len;
+			len -= copy_len;
+			buf += copy_len;
+		}
+
+		if (!len || next_frag == end_frag)
+			break;
+
+		ptr_off += ptr_len;
+		ptr_buf = skb_frag_address(next_frag);
+		ptr_len = skb_frag_size(next_frag);
+		next_frag++;
+	}
+}
+
+static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	u32 size = xdp->data_end - xdp->data;
+	void *addr = xdp->data;
+	int i;
+
+	if (unlikely(offset > 0xffff || len > 0xffff))
+		return ERR_PTR(-EFAULT);
+
+	if (offset + len > xdp_get_buff_len(xdp))
+		return ERR_PTR(-EINVAL);
+
+	if (offset < size) /* linear area */
+		goto out;
+
+	offset -= size;
+	for (i = 0; i < sinfo->nr_frags; i++) { /* paged area */
+		u32 frag_size = skb_frag_size(&sinfo->frags[i]);
+
+		if  (offset < frag_size) {
+			addr = skb_frag_address(&sinfo->frags[i]);
+			size = frag_size;
+			break;
+		}
+		offset -= frag_size;
+	}
+out:
+	return offset + len < size ? addr + offset : NULL;
+}
+
+BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	void *ptr;
+
+	ptr = bpf_xdp_pointer(xdp, offset, len);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	if (!ptr)
+		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
+	else
+		memcpy(buf, ptr, len);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_load_bytes_proto = {
+	.func		= bpf_xdp_load_bytes,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	void *ptr;
+
+	ptr = bpf_xdp_pointer(xdp, offset, len);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	if (!ptr)
+		bpf_xdp_copy_buf(xdp, offset, buf, len, true);
+	else
+		memcpy(ptr, buf, len);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
+	.func		= bpf_xdp_store_bytes,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+};
+
+static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
+	struct xdp_rxq_info *rxq = xdp->rxq;
+	unsigned int tailroom;
+
+	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
+		return -EOPNOTSUPP;
+
+	tailroom = rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag);
+	if (unlikely(offset > tailroom))
+		return -EINVAL;
+
+	memset(skb_frag_address(frag) + skb_frag_size(frag), 0, offset);
+	skb_frag_size_add(frag, offset);
+	sinfo->xdp_frags_size += offset;
+
+	return 0;
+}
+
+static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int i, n_frags_free = 0, len_free = 0;
+
+	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
+		return -EINVAL;
+
+	for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
+		skb_frag_t *frag = &sinfo->frags[i];
+		int shrink = min_t(int, offset, skb_frag_size(frag));
+
+		len_free += shrink;
+		offset -= shrink;
+
+		if (skb_frag_size(frag) == shrink) {
+			struct page *page = skb_frag_page(frag);
+
+			__xdp_return(page_address(page), &xdp->rxq->mem,
+				     false, NULL);
+			n_frags_free++;
+		} else {
+			skb_frag_size_sub(frag, shrink);
+			break;
+		}
+	}
+	sinfo->nr_frags -= n_frags_free;
+	sinfo->xdp_frags_size -= len_free;
+
+	if (unlikely(!sinfo->nr_frags)) {
+		xdp_buff_clear_frags_flag(xdp);
+		xdp->data_end -= offset;
+	}
+
+	return 0;
+}
+
+BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
+{
+	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
+	void *data_end = xdp->data_end + offset;
+
+	if (unlikely(xdp_buff_has_frags(xdp))) { /* non-linear xdp buff */
+		if (offset < 0)
+			return bpf_xdp_frags_shrink_tail(xdp, -offset);
+
+		return bpf_xdp_frags_increase_tail(xdp, offset);
+	}
+
+	/* Notice that xdp_data_hard_end have reserved some tailroom */
+	if (unlikely(data_end > data_hard_end))
+		return -EINVAL;
+
+	/* ALL drivers MUST init xdp->frame_sz, chicken check below */
+	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
+		WARN_ONCE(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
+		return -EINVAL;
+	}
+
+	if (unlikely(data_end < xdp->data + ETH_HLEN))
+		return -EINVAL;
+
+	/* Clear memory area on grow, can contain uninit kernel memory */
+	if (offset > 0)
+		memset(xdp->data_end, 0, offset);
+
+	xdp->data_end = data_end;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_adjust_tail_proto = {
+	.func		= bpf_xdp_adjust_tail,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_2(bpf_xdp_adjust_meta, struct xdp_buff *, xdp, int, offset)
+{
+	void *xdp_frame_end = xdp->data_hard_start + sizeof(struct xdp_frame);
+	void *meta = xdp->data_meta + offset;
+	unsigned long metalen = xdp->data - meta;
+
+	if (xdp_data_meta_unsupported(xdp))
+		return -ENOTSUPP;
+	if (unlikely(meta < xdp_frame_end ||
+		     meta > xdp->data))
+		return -EINVAL;
+	if (unlikely(xdp_metalen_invalid(metalen)))
+		return -EACCES;
+
+	xdp->data_meta = meta;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
+	.func		= bpf_xdp_adjust_meta,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+/* XDP_REDIRECT works by a three-step process, implemented in the functions
+ * below:
+ *
+ * 1. The bpf_redirect() and bpf_redirect_map() helpers will lookup the target
+ *    of the redirect and store it (along with some other metadata) in a per-CPU
+ *    struct bpf_redirect_info.
+ *
+ * 2. When the program returns the XDP_REDIRECT return code, the driver will
+ *    call xdp_do_redirect() which will use the information in struct
+ *    bpf_redirect_info to actually enqueue the frame into a map type-specific
+ *    bulk queue structure.
+ *
+ * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_flush(),
+ *    which will flush all the different bulk queues, thus completing the
+ *    redirect.
+ *
+ * Pointers to the map entries will be kept around for this whole sequence of
+ * steps, protected by RCU. However, there is no top-level rcu_read_lock() in
+ * the core code; instead, the RCU protection relies on everything happening
+ * inside a single NAPI poll sequence, which means it's between a pair of calls
+ * to local_bh_disable()/local_bh_enable().
+ *
+ * The map entries are marked as __rcu and the map code makes sure to
+ * dereference those pointers with rcu_dereference_check() in a way that works
+ * for both sections that to hold an rcu_read_lock() and sections that are
+ * called from NAPI without a separate rcu_read_lock(). The code below does not
+ * use RCU annotations, but relies on those in the map code.
+ */
+void xdp_do_flush(void)
+{
+	__dev_flush();
+	__cpu_map_flush();
+	__xsk_map_flush();
+}
+EXPORT_SYMBOL_GPL(xdp_do_flush);
+
+void bpf_clear_redirect_map(struct bpf_map *map)
+{
+	struct bpf_redirect_info *ri;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		ri = per_cpu_ptr(&bpf_redirect_info, cpu);
+		/* Avoid polluting remote cacheline due to writes if
+		 * not needed. Once we pass this test, we need the
+		 * cmpxchg() to make sure it hasn't been changed in
+		 * the meantime by remote CPU.
+		 */
+		if (unlikely(READ_ONCE(ri->map) == map))
+			cmpxchg(&ri->map, map, NULL);
+	}
+}
+
+DEFINE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
+EXPORT_SYMBOL_GPL(bpf_master_redirect_enabled_key);
+
+u32 xdp_master_redirect(struct xdp_buff *xdp)
+{
+	struct net_device *master, *slave;
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
+	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
+	if (slave && slave != xdp->rxq->dev) {
+		/* The target device is different from the receiving device, so
+		 * redirect it to the new device.
+		 * Using XDP_REDIRECT gets the correct behaviour from XDP enabled
+		 * drivers to unmap the packet from their rx ring.
+		 */
+		ri->tgt_index = slave->ifindex;
+		ri->map_id = INT_MAX;
+		ri->map_type = BPF_MAP_TYPE_UNSPEC;
+		return XDP_REDIRECT;
+	}
+	return XDP_TX;
+}
+EXPORT_SYMBOL_GPL(xdp_master_redirect);
+
+static inline int __xdp_do_redirect_xsk(struct bpf_redirect_info *ri,
+					struct net_device *dev,
+					struct xdp_buff *xdp,
+					struct bpf_prog *xdp_prog)
+{
+	enum bpf_map_type map_type = ri->map_type;
+	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
+	int err;
+
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
+
+	err = __xsk_map_redirect(fwd, xdp);
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
+	return 0;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
+	return err;
+}
+
+static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
+						   struct net_device *dev,
+						   struct xdp_frame *xdpf,
+						   struct bpf_prog *xdp_prog)
+{
+	enum bpf_map_type map_type = ri->map_type;
+	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
+	struct bpf_map *map;
+	int err;
+
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
+
+	if (unlikely(!xdpf)) {
+		err = -EOVERFLOW;
+		goto err;
+	}
+
+	switch (map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		fallthrough;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		map = READ_ONCE(ri->map);
+		if (unlikely(map)) {
+			WRITE_ONCE(ri->map, NULL);
+			err = dev_map_enqueue_multi(xdpf, dev, map,
+						    ri->flags & BPF_F_EXCLUDE_INGRESS);
+		} else {
+			err = dev_map_enqueue(fwd, xdpf, dev);
+		}
+		break;
+	case BPF_MAP_TYPE_CPUMAP:
+		err = cpu_map_enqueue(fwd, xdpf, dev);
+		break;
+	case BPF_MAP_TYPE_UNSPEC:
+		if (map_id == INT_MAX) {
+			fwd = dev_get_by_index_rcu(dev_net(dev), ri->tgt_index);
+			if (unlikely(!fwd)) {
+				err = -EINVAL;
+				break;
+			}
+			err = dev_xdp_enqueue(fwd, xdpf, dev);
+			break;
+		}
+		fallthrough;
+	default:
+		err = -EBADRQC;
+	}
+
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
+	return 0;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
+	return err;
+}
+
+int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+		    struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+
+	/* XDP_REDIRECT is not fully supported yet for xdp frags since
+	 * not all XDP capable drivers can map non-linear xdp_frame in
+	 * ndo_xdp_xmit.
+	 */
+	if (unlikely(xdp_buff_has_frags(xdp) &&
+		     map_type != BPF_MAP_TYPE_CPUMAP))
+		return -EOPNOTSUPP;
+
+	if (map_type == BPF_MAP_TYPE_XSKMAP)
+		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+
+	return __xdp_do_redirect_frame(ri, dev, xdp_convert_buff_to_frame(xdp),
+				       xdp_prog);
+}
+EXPORT_SYMBOL_GPL(xdp_do_redirect);
+
+int xdp_do_redirect_frame(struct net_device *dev, struct xdp_buff *xdp,
+			  struct xdp_frame *xdpf, struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+
+	if (map_type == BPF_MAP_TYPE_XSKMAP)
+		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+
+	return __xdp_do_redirect_frame(ri, dev, xdpf, xdp_prog);
+}
+EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
+
+static int xdp_do_generic_redirect_map(struct net_device *dev,
+				       struct sk_buff *skb,
+				       struct xdp_buff *xdp,
+				       struct bpf_prog *xdp_prog,
+				       void *fwd,
+				       enum bpf_map_type map_type, u32 map_id)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	struct bpf_map *map;
+	int err;
+
+	switch (map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		fallthrough;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		map = READ_ONCE(ri->map);
+		if (unlikely(map)) {
+			WRITE_ONCE(ri->map, NULL);
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     ri->flags & BPF_F_EXCLUDE_INGRESS);
+		} else {
+			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
+		}
+		if (unlikely(err))
+			goto err;
+		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		err = xsk_generic_rcv(fwd, xdp);
+		if (err)
+			goto err;
+		consume_skb(skb);
+		break;
+	case BPF_MAP_TYPE_CPUMAP:
+		err = cpu_map_generic_redirect(fwd, skb);
+		if (unlikely(err))
+			goto err;
+		break;
+	default:
+		err = -EBADRQC;
+		goto err;
+	}
+
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
+	return 0;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
+	return err;
+}
+
+int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
+			    struct xdp_buff *xdp, struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
+	int err;
+
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
+
+	if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
+		fwd = dev_get_by_index_rcu(dev_net(dev), ri->tgt_index);
+		if (unlikely(!fwd)) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		err = xdp_ok_fwd_dev(fwd, skb->len);
+		if (unlikely(err))
+			goto err;
+
+		skb->dev = fwd;
+		_trace_xdp_redirect(dev, xdp_prog, ri->tgt_index);
+		generic_xdp_tx(skb, xdp_prog);
+		return 0;
+	}
+
+	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id);
+err:
+	_trace_xdp_redirect_err(dev, xdp_prog, ri->tgt_index, err);
+	return err;
+}
+
+BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	if (unlikely(flags))
+		return XDP_ABORTED;
+
+	/* NB! Map type UNSPEC and map_id == INT_MAX (never generated
+	 * by map_idr) is used for ifindex based XDP redirect.
+	 */
+	ri->tgt_index = ifindex;
+	ri->map_id = INT_MAX;
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
+
+	return XDP_REDIRECT;
+}
+
+static const struct bpf_func_proto bpf_xdp_redirect_proto = {
+	.func           = bpf_xdp_redirect,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_ANYTHING,
+	.arg2_type      = ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
+	   u64, flags)
+{
+	return map->ops->map_redirect(map, ifindex, flags);
+}
+
+static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
+	.func           = bpf_xdp_redirect_map,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_CONST_MAP_PTR,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_ANYTHING,
+};
+
+
+static unsigned long bpf_xdp_copy(void *dst, const void *ctx,
+				  unsigned long off, unsigned long len)
+{
+	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
+
+	bpf_xdp_copy_buf(xdp, off, dst, len, false);
+	return 0;
+}
+
+BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct bpf_map *, map,
+	   u64, flags, void *, meta, u64, meta_size)
+{
+	u64 xdp_size = (flags & BPF_F_CTXLEN_MASK) >> 32;
+
+	if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
+		return -EINVAL;
+
+	if (unlikely(!xdp || xdp_size > xdp_get_buff_len(xdp)))
+		return -EFAULT;
+
+	return bpf_event_output(map, flags, meta, meta_size, xdp,
+				xdp_size, bpf_xdp_copy);
+}
+
+static const struct bpf_func_proto bpf_xdp_event_output_proto = {
+	.func		= bpf_xdp_event_output,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_CONST_MAP_PTR,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
+};
+
+BTF_ID_LIST_SINGLE(bpf_xdp_output_btf_ids, struct, xdp_buff)
+
+const struct bpf_func_proto bpf_xdp_output_proto = {
+	.func		= bpf_xdp_event_output,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_xdp_output_btf_ids[0],
+	.arg2_type	= ARG_CONST_MAP_PTR,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
+};
+
+#ifdef CONFIG_INET
+bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
+				  struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= offsetofend(struct bpf_xdp_sock, queue_id))
+		return false;
+
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	default:
+		return size == sizeof(__u32);
+	}
+}
+
+u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
+				    const struct bpf_insn *si,
+				    struct bpf_insn *insn_buf,
+				    struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+#define BPF_XDP_SOCK_GET(FIELD)						\
+	do {								\
+		BUILD_BUG_ON(sizeof_field(struct xdp_sock, FIELD) >	\
+			     sizeof_field(struct bpf_xdp_sock, FIELD));	\
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_sock, FIELD),\
+				      si->dst_reg, si->src_reg,		\
+				      offsetof(struct xdp_sock, FIELD)); \
+	} while (0)
+
+	switch (si->off) {
+	case offsetof(struct bpf_xdp_sock, queue_id):
+		BPF_XDP_SOCK_GET(queue_id);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+#endif /* CONFIG_INET */
+
+static int xdp_noop_prologue(struct bpf_insn *insn_buf, bool direct_write,
+			     const struct bpf_prog *prog)
+{
+	/* Neither direct read nor direct write requires any preliminary
+	 * action.
+	 */
+	return 0;
+}
+
+static bool __is_valid_xdp_access(int off, int size)
+{
+	if (off < 0 || off >= sizeof(struct xdp_md))
+		return false;
+	if (off % size != 0)
+		return false;
+	if (size != sizeof(__u32))
+		return false;
+
+	return true;
+}
+
+static bool xdp_is_valid_access(int off, int size,
+				enum bpf_access_type type,
+				const struct bpf_prog *prog,
+				struct bpf_insn_access_aux *info)
+{
+	if (prog->expected_attach_type != BPF_XDP_DEVMAP) {
+		switch (off) {
+		case offsetof(struct xdp_md, egress_ifindex):
+			return false;
+		}
+	}
+
+	if (type == BPF_WRITE) {
+		if (bpf_prog_is_dev_bound(prog->aux)) {
+			switch (off) {
+			case offsetof(struct xdp_md, rx_queue_index):
+				return __is_valid_xdp_access(off, size);
+			}
+		}
+		return false;
+	}
+
+	switch (off) {
+	case offsetof(struct xdp_md, data):
+		info->reg_type = PTR_TO_PACKET;
+		break;
+	case offsetof(struct xdp_md, data_meta):
+		info->reg_type = PTR_TO_PACKET_META;
+		break;
+	case offsetof(struct xdp_md, data_end):
+		info->reg_type = PTR_TO_PACKET_END;
+		break;
+	}
+
+	return __is_valid_xdp_access(off, size);
+}
+
+void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
+{
+	const u32 act_max = XDP_REDIRECT;
+
+	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
+		     act > act_max ? "Illegal" : "Driver unsupported",
+		     act, prog->aux->name, prog->aux->id, dev ? dev->name : "N/A");
+}
+EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
+
+static u32 xdp_convert_ctx_access(enum bpf_access_type type,
+				  const struct bpf_insn *si,
+				  struct bpf_insn *insn_buf,
+				  struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct xdp_md, data):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, data));
+		break;
+	case offsetof(struct xdp_md, data_meta):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_meta),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, data_meta));
+		break;
+	case offsetof(struct xdp_md, data_end):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_end),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, data_end));
+		break;
+	case offsetof(struct xdp_md, ingress_ifindex):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, rxq));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct xdp_rxq_info, dev));
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+				      offsetof(struct net_device, ifindex));
+		break;
+	case offsetof(struct xdp_md, rx_queue_index):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, rxq));
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+				      offsetof(struct xdp_rxq_info,
+					       queue_index));
+		break;
+	case offsetof(struct xdp_md, egress_ifindex):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, txq),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, txq));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_txq_info, dev),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct xdp_txq_info, dev));
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+				      offsetof(struct net_device, ifindex));
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+bool xdp_helper_changes_pkt_data(const void *func)
+{
+	return func == bpf_xdp_adjust_head ||
+	       func == bpf_xdp_adjust_meta ||
+	       func == bpf_xdp_adjust_tail;
+}
+
+static const struct bpf_func_proto *
+xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_perf_event_output:
+		return &bpf_xdp_event_output_proto;
+	case BPF_FUNC_get_smp_processor_id:
+		return &bpf_get_smp_processor_id_proto;
+	case BPF_FUNC_xdp_adjust_head:
+		return &bpf_xdp_adjust_head_proto;
+	case BPF_FUNC_xdp_adjust_meta:
+		return &bpf_xdp_adjust_meta_proto;
+	case BPF_FUNC_redirect:
+		return &bpf_xdp_redirect_proto;
+	case BPF_FUNC_redirect_map:
+		return &bpf_xdp_redirect_map_proto;
+	case BPF_FUNC_xdp_adjust_tail:
+		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
+	case BPF_FUNC_xdp_load_bytes:
+		return &bpf_xdp_load_bytes_proto;
+	case BPF_FUNC_xdp_store_bytes:
+		return &bpf_xdp_store_bytes_proto;
+	default:
+		return xdp_inet_func_proto(func_id);
+	}
+}
+
+const struct bpf_verifier_ops xdp_verifier_ops = {
+	.get_func_proto		= xdp_func_proto,
+	.is_valid_access	= xdp_is_valid_access,
+	.convert_ctx_access	= xdp_convert_ctx_access,
+	.gen_prologue		= xdp_noop_prologue,
+};
+
+const struct bpf_prog_ops xdp_prog_ops = {
+	.test_run		= bpf_prog_test_run_xdp,
+};
+
+DEFINE_BPF_DISPATCHER(xdp)
+
+void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
+{
+	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
+}
diff --git a/net/core/Makefile b/net/core/Makefile
index e8ce3bd283a6..f6eceff1cf36 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
-			fib_notifier.o xdp.o flow_offload.o gro.o
+			fib_notifier.o flow_offload.o gro.o
 
 obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) += dev_addr_lists_test.o
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8958c4227b67..52b64d24c439 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1593,23 +1593,6 @@ void dev_disable_lro(struct net_device *dev)
 }
 EXPORT_SYMBOL(dev_disable_lro);
 
-/**
- *	dev_disable_gro_hw - disable HW Generic Receive Offload on a device
- *	@dev: device
- *
- *	Disable HW Generic Receive Offload (GRO_HW) on a net device.  Must be
- *	called under RTNL.  This is needed if Generic XDP is installed on
- *	the device.
- */
-static void dev_disable_gro_hw(struct net_device *dev)
-{
-	dev->wanted_features &= ~NETIF_F_GRO_HW;
-	netdev_update_features(dev);
-
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
-		netdev_WARN(dev, "failed to disable GRO_HW!\n");
-}
-
 const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 {
 #define N(val) 						\
@@ -4696,227 +4679,6 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	return NET_RX_DROP;
 }
 
-static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
-{
-	struct net_device *dev = skb->dev;
-	struct netdev_rx_queue *rxqueue;
-
-	rxqueue = dev->_rx;
-
-	if (skb_rx_queue_recorded(skb)) {
-		u16 index = skb_get_rx_queue(skb);
-
-		if (unlikely(index >= dev->real_num_rx_queues)) {
-			WARN_ONCE(dev->real_num_rx_queues > 1,
-				  "%s received packet on queue %u, but number "
-				  "of RX queues is %u\n",
-				  dev->name, index, dev->real_num_rx_queues);
-
-			return rxqueue; /* Return first rxqueue */
-		}
-		rxqueue += index;
-	}
-	return rxqueue;
-}
-
-u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
-			     struct bpf_prog *xdp_prog)
-{
-	void *orig_data, *orig_data_end, *hard_start;
-	struct netdev_rx_queue *rxqueue;
-	bool orig_bcast, orig_host;
-	u32 mac_len, frame_sz;
-	__be16 orig_eth_type;
-	struct ethhdr *eth;
-	u32 metalen, act;
-	int off;
-
-	/* The XDP program wants to see the packet starting at the MAC
-	 * header.
-	 */
-	mac_len = skb->data - skb_mac_header(skb);
-	hard_start = skb->data - skb_headroom(skb);
-
-	/* SKB "head" area always have tailroom for skb_shared_info */
-	frame_sz = (void *)skb_end_pointer(skb) - hard_start;
-	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-
-	rxqueue = netif_get_rxqueue(skb);
-	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
-	xdp_prepare_buff(xdp, hard_start, skb_headroom(skb) - mac_len,
-			 skb_headlen(skb) + mac_len, true);
-
-	orig_data_end = xdp->data_end;
-	orig_data = xdp->data;
-	eth = (struct ethhdr *)xdp->data;
-	orig_host = ether_addr_equal_64bits(eth->h_dest, skb->dev->dev_addr);
-	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
-	orig_eth_type = eth->h_proto;
-
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
-
-	/* check if bpf_xdp_adjust_head was used */
-	off = xdp->data - orig_data;
-	if (off) {
-		if (off > 0)
-			__skb_pull(skb, off);
-		else if (off < 0)
-			__skb_push(skb, -off);
-
-		skb->mac_header += off;
-		skb_reset_network_header(skb);
-	}
-
-	/* check if bpf_xdp_adjust_tail was used */
-	off = xdp->data_end - orig_data_end;
-	if (off != 0) {
-		skb_set_tail_pointer(skb, xdp->data_end - xdp->data);
-		skb->len += off; /* positive on grow, negative on shrink */
-	}
-
-	/* check if XDP changed eth hdr such SKB needs update */
-	eth = (struct ethhdr *)xdp->data;
-	if ((orig_eth_type != eth->h_proto) ||
-	    (orig_host != ether_addr_equal_64bits(eth->h_dest,
-						  skb->dev->dev_addr)) ||
-	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
-		__skb_push(skb, ETH_HLEN);
-		skb->pkt_type = PACKET_HOST;
-		skb->protocol = eth_type_trans(skb, skb->dev);
-	}
-
-	/* Redirect/Tx gives L2 packet, code that will reuse skb must __skb_pull
-	 * before calling us again on redirect path. We do not call do_redirect
-	 * as we leave that up to the caller.
-	 *
-	 * Caller is responsible for managing lifetime of skb (i.e. calling
-	 * kfree_skb in response to actions it cannot handle/XDP_DROP).
-	 */
-	switch (act) {
-	case XDP_REDIRECT:
-	case XDP_TX:
-		__skb_push(skb, mac_len);
-		break;
-	case XDP_PASS:
-		metalen = xdp->data - xdp->data_meta;
-		if (metalen)
-			skb_metadata_set(skb, metalen);
-		break;
-	}
-
-	return act;
-}
-
-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
-{
-	u32 act = XDP_DROP;
-
-	/* Reinjected packets coming from act_mirred or similar should
-	 * not get XDP generic processing.
-	 */
-	if (skb_is_redirected(skb))
-		return XDP_PASS;
-
-	/* XDP packets must be linear and must have sufficient headroom
-	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
-	 * native XDP provides, thus we need to do it here as well.
-	 */
-	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
-		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
-		int troom = skb->tail + skb->data_len - skb->end;
-
-		/* In case we have to go down the path and also linearize,
-		 * then lets do the pskb_expand_head() work just once here.
-		 */
-		if (pskb_expand_head(skb,
-				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
-				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
-			goto do_drop;
-		if (skb_linearize(skb))
-			goto do_drop;
-	}
-
-	act = bpf_prog_run_generic_xdp(skb, xdp, xdp_prog);
-	switch (act) {
-	case XDP_REDIRECT:
-	case XDP_TX:
-	case XDP_PASS:
-		break;
-	default:
-		bpf_warn_invalid_xdp_action(skb->dev, xdp_prog, act);
-		fallthrough;
-	case XDP_ABORTED:
-		trace_xdp_exception(skb->dev, xdp_prog, act);
-		fallthrough;
-	case XDP_DROP:
-	do_drop:
-		kfree_skb(skb);
-		break;
-	}
-
-	return act;
-}
-
-/* When doing generic XDP we have to bypass the qdisc layer and the
- * network taps in order to match in-driver-XDP behavior.
- */
-void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
-{
-	struct net_device *dev = skb->dev;
-	struct netdev_queue *txq;
-	bool free_skb = true;
-	int cpu, rc;
-
-	txq = netdev_core_pick_tx(dev, skb, NULL);
-	cpu = smp_processor_id();
-	HARD_TX_LOCK(dev, txq, cpu);
-	if (!netif_xmit_stopped(txq)) {
-		rc = netdev_start_xmit(skb, dev, txq, 0);
-		if (dev_xmit_complete(rc))
-			free_skb = false;
-	}
-	HARD_TX_UNLOCK(dev, txq);
-	if (free_skb) {
-		trace_xdp_exception(dev, xdp_prog, XDP_TX);
-		kfree_skb(skb);
-	}
-}
-
-static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
-
-int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
-{
-	if (xdp_prog) {
-		struct xdp_buff xdp;
-		u32 act;
-		int err;
-
-		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
-		if (act != XDP_PASS) {
-			switch (act) {
-			case XDP_REDIRECT:
-				err = xdp_do_generic_redirect(skb->dev, skb,
-							      &xdp, xdp_prog);
-				if (err)
-					goto out_redir;
-				break;
-			case XDP_TX:
-				generic_xdp_tx(skb, xdp_prog);
-				break;
-			}
-			return XDP_DROP;
-		}
-	}
-	return XDP_PASS;
-out_redir:
-	kfree_skb_reason(skb, SKB_DROP_REASON_XDP);
-	return XDP_DROP;
-}
-EXPORT_SYMBOL_GPL(do_xdp_generic);
-
 static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
@@ -5624,35 +5386,6 @@ static void __netif_receive_skb_list(struct list_head *head)
 		memalloc_noreclaim_restore(noreclaim_flag);
 }
 
-static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
-{
-	struct bpf_prog *old = rtnl_dereference(dev->xdp_prog);
-	struct bpf_prog *new = xdp->prog;
-	int ret = 0;
-
-	switch (xdp->command) {
-	case XDP_SETUP_PROG:
-		rcu_assign_pointer(dev->xdp_prog, new);
-		if (old)
-			bpf_prog_put(old);
-
-		if (old && !new) {
-			static_branch_dec(&generic_xdp_needed_key);
-		} else if (new && !old) {
-			static_branch_inc(&generic_xdp_needed_key);
-			dev_disable_lro(dev);
-			dev_disable_gro_hw(dev);
-		}
-		break;
-
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
 static int netif_receive_skb_internal(struct sk_buff *skb)
 {
 	int ret;
@@ -9016,510 +8749,6 @@ void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
 	}
 }
 
-struct bpf_xdp_link {
-	struct bpf_link link;
-	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
-	int flags;
-};
-
-static enum bpf_xdp_mode dev_xdp_mode(struct net_device *dev, u32 flags)
-{
-	if (flags & XDP_FLAGS_HW_MODE)
-		return XDP_MODE_HW;
-	if (flags & XDP_FLAGS_DRV_MODE)
-		return XDP_MODE_DRV;
-	if (flags & XDP_FLAGS_SKB_MODE)
-		return XDP_MODE_SKB;
-	return dev->netdev_ops->ndo_bpf ? XDP_MODE_DRV : XDP_MODE_SKB;
-}
-
-static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
-{
-	switch (mode) {
-	case XDP_MODE_SKB:
-		return generic_xdp_install;
-	case XDP_MODE_DRV:
-	case XDP_MODE_HW:
-		return dev->netdev_ops->ndo_bpf;
-	default:
-		return NULL;
-	}
-}
-
-static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
-					 enum bpf_xdp_mode mode)
-{
-	return dev->xdp_state[mode].link;
-}
-
-static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
-				     enum bpf_xdp_mode mode)
-{
-	struct bpf_xdp_link *link = dev_xdp_link(dev, mode);
-
-	if (link)
-		return link->link.prog;
-	return dev->xdp_state[mode].prog;
-}
-
-u8 dev_xdp_prog_count(struct net_device *dev)
-{
-	u8 count = 0;
-	int i;
-
-	for (i = 0; i < __MAX_XDP_MODE; i++)
-		if (dev->xdp_state[i].prog || dev->xdp_state[i].link)
-			count++;
-	return count;
-}
-EXPORT_SYMBOL_GPL(dev_xdp_prog_count);
-
-u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
-{
-	struct bpf_prog *prog = dev_xdp_prog(dev, mode);
-
-	return prog ? prog->aux->id : 0;
-}
-
-static void dev_xdp_set_link(struct net_device *dev, enum bpf_xdp_mode mode,
-			     struct bpf_xdp_link *link)
-{
-	dev->xdp_state[mode].link = link;
-	dev->xdp_state[mode].prog = NULL;
-}
-
-static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode mode,
-			     struct bpf_prog *prog)
-{
-	dev->xdp_state[mode].link = NULL;
-	dev->xdp_state[mode].prog = prog;
-}
-
-static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
-			   bpf_op_t bpf_op, struct netlink_ext_ack *extack,
-			   u32 flags, struct bpf_prog *prog)
-{
-	struct netdev_bpf xdp;
-	int err;
-
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = mode == XDP_MODE_HW ? XDP_SETUP_PROG_HW : XDP_SETUP_PROG;
-	xdp.extack = extack;
-	xdp.flags = flags;
-	xdp.prog = prog;
-
-	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
-	 * "moved" into driver), so they don't increment it on their own, but
-	 * they do decrement refcnt when program is detached or replaced.
-	 * Given net_device also owns link/prog, we need to bump refcnt here
-	 * to prevent drivers from underflowing it.
-	 */
-	if (prog)
-		bpf_prog_inc(prog);
-	err = bpf_op(dev, &xdp);
-	if (err) {
-		if (prog)
-			bpf_prog_put(prog);
-		return err;
-	}
-
-	if (mode != XDP_MODE_HW)
-		bpf_prog_change_xdp(dev_xdp_prog(dev, mode), prog);
-
-	return 0;
-}
-
-static void dev_xdp_uninstall(struct net_device *dev)
-{
-	struct bpf_xdp_link *link;
-	struct bpf_prog *prog;
-	enum bpf_xdp_mode mode;
-	bpf_op_t bpf_op;
-
-	ASSERT_RTNL();
-
-	for (mode = XDP_MODE_SKB; mode < __MAX_XDP_MODE; mode++) {
-		prog = dev_xdp_prog(dev, mode);
-		if (!prog)
-			continue;
-
-		bpf_op = dev_xdp_bpf_op(dev, mode);
-		if (!bpf_op)
-			continue;
-
-		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
-
-		/* auto-detach link from net device */
-		link = dev_xdp_link(dev, mode);
-		if (link)
-			link->dev = NULL;
-		else
-			bpf_prog_put(prog);
-
-		dev_xdp_set_link(dev, mode, NULL);
-	}
-}
-
-static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack,
-			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
-			  struct bpf_prog *old_prog, u32 flags)
-{
-	unsigned int num_modes = hweight32(flags & XDP_FLAGS_MODES);
-	struct bpf_prog *cur_prog;
-	struct net_device *upper;
-	struct list_head *iter;
-	enum bpf_xdp_mode mode;
-	bpf_op_t bpf_op;
-	int err;
-
-	ASSERT_RTNL();
-
-	/* either link or prog attachment, never both */
-	if (link && (new_prog || old_prog))
-		return -EINVAL;
-	/* link supports only XDP mode flags */
-	if (link && (flags & ~XDP_FLAGS_MODES)) {
-		NL_SET_ERR_MSG(extack, "Invalid XDP flags for BPF link attachment");
-		return -EINVAL;
-	}
-	/* just one XDP mode bit should be set, zero defaults to drv/skb mode */
-	if (num_modes > 1) {
-		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can be set");
-		return -EINVAL;
-	}
-	/* avoid ambiguity if offload + drv/skb mode progs are both loaded */
-	if (!num_modes && dev_xdp_prog_count(dev) > 1) {
-		NL_SET_ERR_MSG(extack,
-			       "More than one program loaded, unset mode is ambiguous");
-		return -EINVAL;
-	}
-	/* old_prog != NULL implies XDP_FLAGS_REPLACE is set */
-	if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
-		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not specified");
-		return -EINVAL;
-	}
-
-	mode = dev_xdp_mode(dev, flags);
-	/* can't replace attached link */
-	if (dev_xdp_link(dev, mode)) {
-		NL_SET_ERR_MSG(extack, "Can't replace active BPF XDP link");
-		return -EBUSY;
-	}
-
-	/* don't allow if an upper device already has a program */
-	netdev_for_each_upper_dev_rcu(dev, upper, iter) {
-		if (dev_xdp_prog_count(upper) > 0) {
-			NL_SET_ERR_MSG(extack, "Cannot attach when an upper device already has a program");
-			return -EEXIST;
-		}
-	}
-
-	cur_prog = dev_xdp_prog(dev, mode);
-	/* can't replace attached prog with link */
-	if (link && cur_prog) {
-		NL_SET_ERR_MSG(extack, "Can't replace active XDP program with BPF link");
-		return -EBUSY;
-	}
-	if ((flags & XDP_FLAGS_REPLACE) && cur_prog != old_prog) {
-		NL_SET_ERR_MSG(extack, "Active program does not match expected");
-		return -EEXIST;
-	}
-
-	/* put effective new program into new_prog */
-	if (link)
-		new_prog = link->link.prog;
-
-	if (new_prog) {
-		bool offload = mode == XDP_MODE_HW;
-		enum bpf_xdp_mode other_mode = mode == XDP_MODE_SKB
-					       ? XDP_MODE_DRV : XDP_MODE_SKB;
-
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
-			NL_SET_ERR_MSG(extack, "XDP program already attached");
-			return -EBUSY;
-		}
-		if (!offload && dev_xdp_prog(dev, other_mode)) {
-			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
-			return -EEXIST;
-		}
-		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
-			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
-			return -EINVAL;
-		}
-		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
-			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
-			return -EINVAL;
-		}
-		if (new_prog->expected_attach_type == BPF_XDP_CPUMAP) {
-			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
-			return -EINVAL;
-		}
-	}
-
-	/* don't call drivers if the effective program didn't change */
-	if (new_prog != cur_prog) {
-		bpf_op = dev_xdp_bpf_op(dev, mode);
-		if (!bpf_op) {
-			NL_SET_ERR_MSG(extack, "Underlying driver does not support XDP in native mode");
-			return -EOPNOTSUPP;
-		}
-
-		err = dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
-		if (err)
-			return err;
-	}
-
-	if (link)
-		dev_xdp_set_link(dev, mode, link);
-	else
-		dev_xdp_set_prog(dev, mode, new_prog);
-	if (cur_prog)
-		bpf_prog_put(cur_prog);
-
-	return 0;
-}
-
-static int dev_xdp_attach_link(struct net_device *dev,
-			       struct netlink_ext_ack *extack,
-			       struct bpf_xdp_link *link)
-{
-	return dev_xdp_attach(dev, extack, link, NULL, NULL, link->flags);
-}
-
-static int dev_xdp_detach_link(struct net_device *dev,
-			       struct netlink_ext_ack *extack,
-			       struct bpf_xdp_link *link)
-{
-	enum bpf_xdp_mode mode;
-	bpf_op_t bpf_op;
-
-	ASSERT_RTNL();
-
-	mode = dev_xdp_mode(dev, link->flags);
-	if (dev_xdp_link(dev, mode) != link)
-		return -EINVAL;
-
-	bpf_op = dev_xdp_bpf_op(dev, mode);
-	WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
-	dev_xdp_set_link(dev, mode, NULL);
-	return 0;
-}
-
-static void bpf_xdp_link_release(struct bpf_link *link)
-{
-	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-
-	rtnl_lock();
-
-	/* if racing with net_device's tear down, xdp_link->dev might be
-	 * already NULL, in which case link was already auto-detached
-	 */
-	if (xdp_link->dev) {
-		WARN_ON(dev_xdp_detach_link(xdp_link->dev, NULL, xdp_link));
-		xdp_link->dev = NULL;
-	}
-
-	rtnl_unlock();
-}
-
-static int bpf_xdp_link_detach(struct bpf_link *link)
-{
-	bpf_xdp_link_release(link);
-	return 0;
-}
-
-static void bpf_xdp_link_dealloc(struct bpf_link *link)
-{
-	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-
-	kfree(xdp_link);
-}
-
-static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
-				     struct seq_file *seq)
-{
-	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-	u32 ifindex = 0;
-
-	rtnl_lock();
-	if (xdp_link->dev)
-		ifindex = xdp_link->dev->ifindex;
-	rtnl_unlock();
-
-	seq_printf(seq, "ifindex:\t%u\n", ifindex);
-}
-
-static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
-				       struct bpf_link_info *info)
-{
-	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-	u32 ifindex = 0;
-
-	rtnl_lock();
-	if (xdp_link->dev)
-		ifindex = xdp_link->dev->ifindex;
-	rtnl_unlock();
-
-	info->xdp.ifindex = ifindex;
-	return 0;
-}
-
-static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
-			       struct bpf_prog *old_prog)
-{
-	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-	enum bpf_xdp_mode mode;
-	bpf_op_t bpf_op;
-	int err = 0;
-
-	rtnl_lock();
-
-	/* link might have been auto-released already, so fail */
-	if (!xdp_link->dev) {
-		err = -ENOLINK;
-		goto out_unlock;
-	}
-
-	if (old_prog && link->prog != old_prog) {
-		err = -EPERM;
-		goto out_unlock;
-	}
-	old_prog = link->prog;
-	if (old_prog->type != new_prog->type ||
-	    old_prog->expected_attach_type != new_prog->expected_attach_type) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
-
-	if (old_prog == new_prog) {
-		/* no-op, don't disturb drivers */
-		bpf_prog_put(new_prog);
-		goto out_unlock;
-	}
-
-	mode = dev_xdp_mode(xdp_link->dev, xdp_link->flags);
-	bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
-	err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
-			      xdp_link->flags, new_prog);
-	if (err)
-		goto out_unlock;
-
-	old_prog = xchg(&link->prog, new_prog);
-	bpf_prog_put(old_prog);
-
-out_unlock:
-	rtnl_unlock();
-	return err;
-}
-
-static const struct bpf_link_ops bpf_xdp_link_lops = {
-	.release = bpf_xdp_link_release,
-	.dealloc = bpf_xdp_link_dealloc,
-	.detach = bpf_xdp_link_detach,
-	.show_fdinfo = bpf_xdp_link_show_fdinfo,
-	.fill_link_info = bpf_xdp_link_fill_link_info,
-	.update_prog = bpf_xdp_link_update,
-};
-
-int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
-{
-	struct net *net = current->nsproxy->net_ns;
-	struct bpf_link_primer link_primer;
-	struct bpf_xdp_link *link;
-	struct net_device *dev;
-	int err, fd;
-
-	rtnl_lock();
-	dev = dev_get_by_index(net, attr->link_create.target_ifindex);
-	if (!dev) {
-		rtnl_unlock();
-		return -EINVAL;
-	}
-
-	link = kzalloc(sizeof(*link), GFP_USER);
-	if (!link) {
-		err = -ENOMEM;
-		goto unlock;
-	}
-
-	bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog);
-	link->dev = dev;
-	link->flags = attr->link_create.flags;
-
-	err = bpf_link_prime(&link->link, &link_primer);
-	if (err) {
-		kfree(link);
-		goto unlock;
-	}
-
-	err = dev_xdp_attach_link(dev, NULL, link);
-	rtnl_unlock();
-
-	if (err) {
-		link->dev = NULL;
-		bpf_link_cleanup(&link_primer);
-		goto out_put_dev;
-	}
-
-	fd = bpf_link_settle(&link_primer);
-	/* link itself doesn't hold dev's refcnt to not complicate shutdown */
-	dev_put(dev);
-	return fd;
-
-unlock:
-	rtnl_unlock();
-
-out_put_dev:
-	dev_put(dev);
-	return err;
-}
-
-/**
- *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
- *	@dev: device
- *	@extack: netlink extended ack
- *	@fd: new program fd or negative value to clear
- *	@expected_fd: old program fd that userspace expects to replace or clear
- *	@flags: xdp-related flags
- *
- *	Set or clear a bpf program for a device
- */
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags)
-{
-	enum bpf_xdp_mode mode = dev_xdp_mode(dev, flags);
-	struct bpf_prog *new_prog = NULL, *old_prog = NULL;
-	int err;
-
-	ASSERT_RTNL();
-
-	if (fd >= 0) {
-		new_prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-						 mode != XDP_MODE_SKB);
-		if (IS_ERR(new_prog))
-			return PTR_ERR(new_prog);
-	}
-
-	if (expected_fd >= 0) {
-		old_prog = bpf_prog_get_type_dev(expected_fd, BPF_PROG_TYPE_XDP,
-						 mode != XDP_MODE_SKB);
-		if (IS_ERR(old_prog)) {
-			err = PTR_ERR(old_prog);
-			old_prog = NULL;
-			goto err_out;
-		}
-	}
-
-	err = dev_xdp_attach(dev, extack, NULL, new_prog, old_prog, flags);
-
-err_out:
-	if (err && new_prog)
-		bpf_prog_put(new_prog);
-	if (old_prog)
-		bpf_prog_put(old_prog);
-	return err;
-}
-
 /**
  *	dev_new_index	-	allocate an ifindex
  *	@net: the applicable net namespace
diff --git a/net/core/dev.h b/net/core/dev.h
index cbb8a925175a..36a68992f17b 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -78,10 +78,6 @@ int dev_change_proto_down(struct net_device *dev, bool proto_down);
 void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
 				  u32 value);
 
-typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags);
-
 int dev_change_tx_queue_len(struct net_device *dev, unsigned long new_len);
 void dev_set_group(struct net_device *dev, int new_group);
 int dev_change_carrier(struct net_device *dev, bool new_carrier);
diff --git a/net/core/filter.c b/net/core/filter.c
index 151aa4756bd6..3933465eb972 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3788,641 +3788,6 @@ static const struct bpf_func_proto sk_skb_change_head_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
-BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
-{
-	return xdp_get_buff_len(xdp);
-}
-
-static const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
-	.func		= bpf_xdp_get_buff_len,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-};
-
-BTF_ID_LIST_SINGLE(bpf_xdp_get_buff_len_bpf_ids, struct, xdp_buff)
-
-const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto = {
-	.func		= bpf_xdp_get_buff_len,
-	.gpl_only	= false,
-	.arg1_type	= ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id	= &bpf_xdp_get_buff_len_bpf_ids[0],
-};
-
-static unsigned long xdp_get_metalen(const struct xdp_buff *xdp)
-{
-	return xdp_data_meta_unsupported(xdp) ? 0 :
-	       xdp->data - xdp->data_meta;
-}
-
-BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
-{
-	void *xdp_frame_end = xdp->data_hard_start + sizeof(struct xdp_frame);
-	unsigned long metalen = xdp_get_metalen(xdp);
-	void *data_start = xdp_frame_end + metalen;
-	void *data = xdp->data + offset;
-
-	if (unlikely(data < data_start ||
-		     data > xdp->data_end - ETH_HLEN))
-		return -EINVAL;
-
-	if (metalen)
-		memmove(xdp->data_meta + offset,
-			xdp->data_meta, metalen);
-	xdp->data_meta += offset;
-	xdp->data = data;
-
-	return 0;
-}
-
-static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
-	.func		= bpf_xdp_adjust_head,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
-};
-
-static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
-			     void *buf, unsigned long len, bool flush)
-{
-	unsigned long ptr_len, ptr_off = 0;
-	skb_frag_t *next_frag, *end_frag;
-	struct skb_shared_info *sinfo;
-	void *src, *dst;
-	u8 *ptr_buf;
-
-	if (likely(xdp->data_end - xdp->data >= off + len)) {
-		src = flush ? buf : xdp->data + off;
-		dst = flush ? xdp->data + off : buf;
-		memcpy(dst, src, len);
-		return;
-	}
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	end_frag = &sinfo->frags[sinfo->nr_frags];
-	next_frag = &sinfo->frags[0];
-
-	ptr_len = xdp->data_end - xdp->data;
-	ptr_buf = xdp->data;
-
-	while (true) {
-		if (off < ptr_off + ptr_len) {
-			unsigned long copy_off = off - ptr_off;
-			unsigned long copy_len = min(len, ptr_len - copy_off);
-
-			src = flush ? buf : ptr_buf + copy_off;
-			dst = flush ? ptr_buf + copy_off : buf;
-			memcpy(dst, src, copy_len);
-
-			off += copy_len;
-			len -= copy_len;
-			buf += copy_len;
-		}
-
-		if (!len || next_frag == end_frag)
-			break;
-
-		ptr_off += ptr_len;
-		ptr_buf = skb_frag_address(next_frag);
-		ptr_len = skb_frag_size(next_frag);
-		next_frag++;
-	}
-}
-
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
-{
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	u32 size = xdp->data_end - xdp->data;
-	void *addr = xdp->data;
-	int i;
-
-	if (unlikely(offset > 0xffff || len > 0xffff))
-		return ERR_PTR(-EFAULT);
-
-	if (offset + len > xdp_get_buff_len(xdp))
-		return ERR_PTR(-EINVAL);
-
-	if (offset < size) /* linear area */
-		goto out;
-
-	offset -= size;
-	for (i = 0; i < sinfo->nr_frags; i++) { /* paged area */
-		u32 frag_size = skb_frag_size(&sinfo->frags[i]);
-
-		if  (offset < frag_size) {
-			addr = skb_frag_address(&sinfo->frags[i]);
-			size = frag_size;
-			break;
-		}
-		offset -= frag_size;
-	}
-out:
-	return offset + len < size ? addr + offset : NULL;
-}
-
-BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
-	   void *, buf, u32, len)
-{
-	void *ptr;
-
-	ptr = bpf_xdp_pointer(xdp, offset, len);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-
-	if (!ptr)
-		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
-	else
-		memcpy(buf, ptr, len);
-
-	return 0;
-}
-
-static const struct bpf_func_proto bpf_xdp_load_bytes_proto = {
-	.func		= bpf_xdp_load_bytes,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg4_type	= ARG_CONST_SIZE,
-};
-
-BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
-	   void *, buf, u32, len)
-{
-	void *ptr;
-
-	ptr = bpf_xdp_pointer(xdp, offset, len);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-
-	if (!ptr)
-		bpf_xdp_copy_buf(xdp, offset, buf, len, true);
-	else
-		memcpy(ptr, buf, len);
-
-	return 0;
-}
-
-static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
-	.func		= bpf_xdp_store_bytes,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg4_type	= ARG_CONST_SIZE,
-};
-
-static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
-{
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
-	struct xdp_rxq_info *rxq = xdp->rxq;
-	unsigned int tailroom;
-
-	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
-		return -EOPNOTSUPP;
-
-	tailroom = rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag);
-	if (unlikely(offset > tailroom))
-		return -EINVAL;
-
-	memset(skb_frag_address(frag) + skb_frag_size(frag), 0, offset);
-	skb_frag_size_add(frag, offset);
-	sinfo->xdp_frags_size += offset;
-
-	return 0;
-}
-
-static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
-{
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, n_frags_free = 0, len_free = 0;
-
-	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
-		return -EINVAL;
-
-	for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
-		skb_frag_t *frag = &sinfo->frags[i];
-		int shrink = min_t(int, offset, skb_frag_size(frag));
-
-		len_free += shrink;
-		offset -= shrink;
-
-		if (skb_frag_size(frag) == shrink) {
-			struct page *page = skb_frag_page(frag);
-
-			__xdp_return(page_address(page), &xdp->rxq->mem,
-				     false, NULL);
-			n_frags_free++;
-		} else {
-			skb_frag_size_sub(frag, shrink);
-			break;
-		}
-	}
-	sinfo->nr_frags -= n_frags_free;
-	sinfo->xdp_frags_size -= len_free;
-
-	if (unlikely(!sinfo->nr_frags)) {
-		xdp_buff_clear_frags_flag(xdp);
-		xdp->data_end -= offset;
-	}
-
-	return 0;
-}
-
-BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
-{
-	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
-	void *data_end = xdp->data_end + offset;
-
-	if (unlikely(xdp_buff_has_frags(xdp))) { /* non-linear xdp buff */
-		if (offset < 0)
-			return bpf_xdp_frags_shrink_tail(xdp, -offset);
-
-		return bpf_xdp_frags_increase_tail(xdp, offset);
-	}
-
-	/* Notice that xdp_data_hard_end have reserved some tailroom */
-	if (unlikely(data_end > data_hard_end))
-		return -EINVAL;
-
-	/* ALL drivers MUST init xdp->frame_sz, chicken check below */
-	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
-		WARN_ONCE(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
-		return -EINVAL;
-	}
-
-	if (unlikely(data_end < xdp->data + ETH_HLEN))
-		return -EINVAL;
-
-	/* Clear memory area on grow, can contain uninit kernel memory */
-	if (offset > 0)
-		memset(xdp->data_end, 0, offset);
-
-	xdp->data_end = data_end;
-
-	return 0;
-}
-
-static const struct bpf_func_proto bpf_xdp_adjust_tail_proto = {
-	.func		= bpf_xdp_adjust_tail,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
-};
-
-BPF_CALL_2(bpf_xdp_adjust_meta, struct xdp_buff *, xdp, int, offset)
-{
-	void *xdp_frame_end = xdp->data_hard_start + sizeof(struct xdp_frame);
-	void *meta = xdp->data_meta + offset;
-	unsigned long metalen = xdp->data - meta;
-
-	if (xdp_data_meta_unsupported(xdp))
-		return -ENOTSUPP;
-	if (unlikely(meta < xdp_frame_end ||
-		     meta > xdp->data))
-		return -EINVAL;
-	if (unlikely(xdp_metalen_invalid(metalen)))
-		return -EACCES;
-
-	xdp->data_meta = meta;
-
-	return 0;
-}
-
-static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
-	.func		= bpf_xdp_adjust_meta,
-	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
-};
-
-/* XDP_REDIRECT works by a three-step process, implemented in the functions
- * below:
- *
- * 1. The bpf_redirect() and bpf_redirect_map() helpers will lookup the target
- *    of the redirect and store it (along with some other metadata) in a per-CPU
- *    struct bpf_redirect_info.
- *
- * 2. When the program returns the XDP_REDIRECT return code, the driver will
- *    call xdp_do_redirect() which will use the information in struct
- *    bpf_redirect_info to actually enqueue the frame into a map type-specific
- *    bulk queue structure.
- *
- * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_flush(),
- *    which will flush all the different bulk queues, thus completing the
- *    redirect.
- *
- * Pointers to the map entries will be kept around for this whole sequence of
- * steps, protected by RCU. However, there is no top-level rcu_read_lock() in
- * the core code; instead, the RCU protection relies on everything happening
- * inside a single NAPI poll sequence, which means it's between a pair of calls
- * to local_bh_disable()/local_bh_enable().
- *
- * The map entries are marked as __rcu and the map code makes sure to
- * dereference those pointers with rcu_dereference_check() in a way that works
- * for both sections that to hold an rcu_read_lock() and sections that are
- * called from NAPI without a separate rcu_read_lock(). The code below does not
- * use RCU annotations, but relies on those in the map code.
- */
-void xdp_do_flush(void)
-{
-	__dev_flush();
-	__cpu_map_flush();
-	__xsk_map_flush();
-}
-EXPORT_SYMBOL_GPL(xdp_do_flush);
-
-void bpf_clear_redirect_map(struct bpf_map *map)
-{
-	struct bpf_redirect_info *ri;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		ri = per_cpu_ptr(&bpf_redirect_info, cpu);
-		/* Avoid polluting remote cacheline due to writes if
-		 * not needed. Once we pass this test, we need the
-		 * cmpxchg() to make sure it hasn't been changed in
-		 * the meantime by remote CPU.
-		 */
-		if (unlikely(READ_ONCE(ri->map) == map))
-			cmpxchg(&ri->map, map, NULL);
-	}
-}
-
-DEFINE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
-EXPORT_SYMBOL_GPL(bpf_master_redirect_enabled_key);
-
-u32 xdp_master_redirect(struct xdp_buff *xdp)
-{
-	struct net_device *master, *slave;
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-
-	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
-	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
-	if (slave && slave != xdp->rxq->dev) {
-		/* The target device is different from the receiving device, so
-		 * redirect it to the new device.
-		 * Using XDP_REDIRECT gets the correct behaviour from XDP enabled
-		 * drivers to unmap the packet from their rx ring.
-		 */
-		ri->tgt_index = slave->ifindex;
-		ri->map_id = INT_MAX;
-		ri->map_type = BPF_MAP_TYPE_UNSPEC;
-		return XDP_REDIRECT;
-	}
-	return XDP_TX;
-}
-EXPORT_SYMBOL_GPL(xdp_master_redirect);
-
-static inline int __xdp_do_redirect_xsk(struct bpf_redirect_info *ri,
-					struct net_device *dev,
-					struct xdp_buff *xdp,
-					struct bpf_prog *xdp_prog)
-{
-	enum bpf_map_type map_type = ri->map_type;
-	void *fwd = ri->tgt_value;
-	u32 map_id = ri->map_id;
-	int err;
-
-	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
-	ri->map_type = BPF_MAP_TYPE_UNSPEC;
-
-	err = __xsk_map_redirect(fwd, xdp);
-	if (unlikely(err))
-		goto err;
-
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
-	return 0;
-err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
-	return err;
-}
-
-static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
-						   struct net_device *dev,
-						   struct xdp_frame *xdpf,
-						   struct bpf_prog *xdp_prog)
-{
-	enum bpf_map_type map_type = ri->map_type;
-	void *fwd = ri->tgt_value;
-	u32 map_id = ri->map_id;
-	struct bpf_map *map;
-	int err;
-
-	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
-	ri->map_type = BPF_MAP_TYPE_UNSPEC;
-
-	if (unlikely(!xdpf)) {
-		err = -EOVERFLOW;
-		goto err;
-	}
-
-	switch (map_type) {
-	case BPF_MAP_TYPE_DEVMAP:
-		fallthrough;
-	case BPF_MAP_TYPE_DEVMAP_HASH:
-		map = READ_ONCE(ri->map);
-		if (unlikely(map)) {
-			WRITE_ONCE(ri->map, NULL);
-			err = dev_map_enqueue_multi(xdpf, dev, map,
-						    ri->flags & BPF_F_EXCLUDE_INGRESS);
-		} else {
-			err = dev_map_enqueue(fwd, xdpf, dev);
-		}
-		break;
-	case BPF_MAP_TYPE_CPUMAP:
-		err = cpu_map_enqueue(fwd, xdpf, dev);
-		break;
-	case BPF_MAP_TYPE_UNSPEC:
-		if (map_id == INT_MAX) {
-			fwd = dev_get_by_index_rcu(dev_net(dev), ri->tgt_index);
-			if (unlikely(!fwd)) {
-				err = -EINVAL;
-				break;
-			}
-			err = dev_xdp_enqueue(fwd, xdpf, dev);
-			break;
-		}
-		fallthrough;
-	default:
-		err = -EBADRQC;
-	}
-
-	if (unlikely(err))
-		goto err;
-
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
-	return 0;
-err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
-	return err;
-}
-
-int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
-		    struct bpf_prog *xdp_prog)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	enum bpf_map_type map_type = ri->map_type;
-
-	/* XDP_REDIRECT is not fully supported yet for xdp frags since
-	 * not all XDP capable drivers can map non-linear xdp_frame in
-	 * ndo_xdp_xmit.
-	 */
-	if (unlikely(xdp_buff_has_frags(xdp) &&
-		     map_type != BPF_MAP_TYPE_CPUMAP))
-		return -EOPNOTSUPP;
-
-	if (map_type == BPF_MAP_TYPE_XSKMAP)
-		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
-
-	return __xdp_do_redirect_frame(ri, dev, xdp_convert_buff_to_frame(xdp),
-				       xdp_prog);
-}
-EXPORT_SYMBOL_GPL(xdp_do_redirect);
-
-int xdp_do_redirect_frame(struct net_device *dev, struct xdp_buff *xdp,
-			  struct xdp_frame *xdpf, struct bpf_prog *xdp_prog)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	enum bpf_map_type map_type = ri->map_type;
-
-	if (map_type == BPF_MAP_TYPE_XSKMAP)
-		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
-
-	return __xdp_do_redirect_frame(ri, dev, xdpf, xdp_prog);
-}
-EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
-
-static int xdp_do_generic_redirect_map(struct net_device *dev,
-				       struct sk_buff *skb,
-				       struct xdp_buff *xdp,
-				       struct bpf_prog *xdp_prog,
-				       void *fwd,
-				       enum bpf_map_type map_type, u32 map_id)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map;
-	int err;
-
-	switch (map_type) {
-	case BPF_MAP_TYPE_DEVMAP:
-		fallthrough;
-	case BPF_MAP_TYPE_DEVMAP_HASH:
-		map = READ_ONCE(ri->map);
-		if (unlikely(map)) {
-			WRITE_ONCE(ri->map, NULL);
-			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
-						     ri->flags & BPF_F_EXCLUDE_INGRESS);
-		} else {
-			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
-		}
-		if (unlikely(err))
-			goto err;
-		break;
-	case BPF_MAP_TYPE_XSKMAP:
-		err = xsk_generic_rcv(fwd, xdp);
-		if (err)
-			goto err;
-		consume_skb(skb);
-		break;
-	case BPF_MAP_TYPE_CPUMAP:
-		err = cpu_map_generic_redirect(fwd, skb);
-		if (unlikely(err))
-			goto err;
-		break;
-	default:
-		err = -EBADRQC;
-		goto err;
-	}
-
-	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
-	return 0;
-err:
-	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
-	return err;
-}
-
-int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
-			    struct xdp_buff *xdp, struct bpf_prog *xdp_prog)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	enum bpf_map_type map_type = ri->map_type;
-	void *fwd = ri->tgt_value;
-	u32 map_id = ri->map_id;
-	int err;
-
-	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
-	ri->map_type = BPF_MAP_TYPE_UNSPEC;
-
-	if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
-		fwd = dev_get_by_index_rcu(dev_net(dev), ri->tgt_index);
-		if (unlikely(!fwd)) {
-			err = -EINVAL;
-			goto err;
-		}
-
-		err = xdp_ok_fwd_dev(fwd, skb->len);
-		if (unlikely(err))
-			goto err;
-
-		skb->dev = fwd;
-		_trace_xdp_redirect(dev, xdp_prog, ri->tgt_index);
-		generic_xdp_tx(skb, xdp_prog);
-		return 0;
-	}
-
-	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id);
-err:
-	_trace_xdp_redirect_err(dev, xdp_prog, ri->tgt_index, err);
-	return err;
-}
-
-BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
-{
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-
-	if (unlikely(flags))
-		return XDP_ABORTED;
-
-	/* NB! Map type UNSPEC and map_id == INT_MAX (never generated
-	 * by map_idr) is used for ifindex based XDP redirect.
-	 */
-	ri->tgt_index = ifindex;
-	ri->map_id = INT_MAX;
-	ri->map_type = BPF_MAP_TYPE_UNSPEC;
-
-	return XDP_REDIRECT;
-}
-
-static const struct bpf_func_proto bpf_xdp_redirect_proto = {
-	.func           = bpf_xdp_redirect,
-	.gpl_only       = false,
-	.ret_type       = RET_INTEGER,
-	.arg1_type      = ARG_ANYTHING,
-	.arg2_type      = ARG_ANYTHING,
-};
-
-BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
-	   u64, flags)
-{
-	return map->ops->map_redirect(map, ifindex, flags);
-}
-
-static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
-	.func           = bpf_xdp_redirect_map,
-	.gpl_only       = false,
-	.ret_type       = RET_INTEGER,
-	.arg1_type      = ARG_CONST_MAP_PTR,
-	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_ANYTHING,
-};
-
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -4830,55 +4195,6 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
 };
 #endif
 
-static unsigned long bpf_xdp_copy(void *dst, const void *ctx,
-				  unsigned long off, unsigned long len)
-{
-	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
-
-	bpf_xdp_copy_buf(xdp, off, dst, len, false);
-	return 0;
-}
-
-BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct bpf_map *, map,
-	   u64, flags, void *, meta, u64, meta_size)
-{
-	u64 xdp_size = (flags & BPF_F_CTXLEN_MASK) >> 32;
-
-	if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
-		return -EINVAL;
-
-	if (unlikely(!xdp || xdp_size > xdp_get_buff_len(xdp)))
-		return -EFAULT;
-
-	return bpf_event_output(map, flags, meta, meta_size, xdp,
-				xdp_size, bpf_xdp_copy);
-}
-
-static const struct bpf_func_proto bpf_xdp_event_output_proto = {
-	.func		= bpf_xdp_event_output,
-	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_CONST_MAP_PTR,
-	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
-	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
-};
-
-BTF_ID_LIST_SINGLE(bpf_xdp_output_btf_ids, struct, xdp_buff)
-
-const struct bpf_func_proto bpf_xdp_output_proto = {
-	.func		= bpf_xdp_event_output,
-	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id	= &bpf_xdp_output_btf_ids[0],
-	.arg2_type	= ARG_CONST_MAP_PTR,
-	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
-	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
-};
-
 BPF_CALL_1(bpf_get_socket_cookie, struct sk_buff *, skb)
 {
 	return skb->sk ? __sock_gen_cookie(skb->sk) : 0;
@@ -6957,46 +6273,6 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, skb)
 	return INET_ECN_set_ce(skb);
 }
 
-bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
-				  struct bpf_insn_access_aux *info)
-{
-	if (off < 0 || off >= offsetofend(struct bpf_xdp_sock, queue_id))
-		return false;
-
-	if (off % size != 0)
-		return false;
-
-	switch (off) {
-	default:
-		return size == sizeof(__u32);
-	}
-}
-
-u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
-				    const struct bpf_insn *si,
-				    struct bpf_insn *insn_buf,
-				    struct bpf_prog *prog, u32 *target_size)
-{
-	struct bpf_insn *insn = insn_buf;
-
-#define BPF_XDP_SOCK_GET(FIELD)						\
-	do {								\
-		BUILD_BUG_ON(sizeof_field(struct xdp_sock, FIELD) >	\
-			     sizeof_field(struct bpf_xdp_sock, FIELD));	\
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_sock, FIELD),\
-				      si->dst_reg, si->src_reg,		\
-				      offsetof(struct xdp_sock, FIELD)); \
-	} while (0)
-
-	switch (si->off) {
-	case offsetof(struct bpf_xdp_sock, queue_id):
-		BPF_XDP_SOCK_GET(queue_id);
-		break;
-	}
-
-	return insn - insn_buf;
-}
-
 static const struct bpf_func_proto bpf_skb_ecn_set_ce_proto = {
 	.func           = bpf_skb_ecn_set_ce,
 	.gpl_only       = false,
@@ -7569,12 +6845,10 @@ bool bpf_helper_changes_pkt_data(void *func)
 	    func == bpf_clone_redirect ||
 	    func == bpf_l3_csum_replace ||
 	    func == bpf_l4_csum_replace ||
-	    func == bpf_xdp_adjust_head ||
-	    func == bpf_xdp_adjust_meta ||
+	    xdp_helper_changes_pkt_data(func) ||
 	    func == bpf_msg_pull_data ||
 	    func == bpf_msg_push_data ||
 	    func == bpf_msg_pop_data ||
-	    func == bpf_xdp_adjust_tail ||
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 	    func == bpf_lwt_seg6_store_bytes ||
 	    func == bpf_lwt_seg6_adjust_srh ||
@@ -7929,32 +7203,11 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
-static const struct bpf_func_proto *
-xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+const struct bpf_func_proto *xdp_inet_func_proto(enum bpf_func_id func_id)
 {
 	switch (func_id) {
-	case BPF_FUNC_perf_event_output:
-		return &bpf_xdp_event_output_proto;
-	case BPF_FUNC_get_smp_processor_id:
-		return &bpf_get_smp_processor_id_proto;
 	case BPF_FUNC_csum_diff:
 		return &bpf_csum_diff_proto;
-	case BPF_FUNC_xdp_adjust_head:
-		return &bpf_xdp_adjust_head_proto;
-	case BPF_FUNC_xdp_adjust_meta:
-		return &bpf_xdp_adjust_meta_proto;
-	case BPF_FUNC_redirect:
-		return &bpf_xdp_redirect_proto;
-	case BPF_FUNC_redirect_map:
-		return &bpf_xdp_redirect_map_proto;
-	case BPF_FUNC_xdp_adjust_tail:
-		return &bpf_xdp_adjust_tail_proto;
-	case BPF_FUNC_xdp_get_buff_len:
-		return &bpf_xdp_get_buff_len_proto;
-	case BPF_FUNC_xdp_load_bytes:
-		return &bpf_xdp_load_bytes_proto;
-	case BPF_FUNC_xdp_store_bytes:
-		return &bpf_xdp_store_bytes_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
@@ -8643,64 +7896,6 @@ static bool tc_cls_act_is_valid_access(int off, int size,
 	return bpf_skb_is_valid_access(off, size, type, prog, info);
 }
 
-static bool __is_valid_xdp_access(int off, int size)
-{
-	if (off < 0 || off >= sizeof(struct xdp_md))
-		return false;
-	if (off % size != 0)
-		return false;
-	if (size != sizeof(__u32))
-		return false;
-
-	return true;
-}
-
-static bool xdp_is_valid_access(int off, int size,
-				enum bpf_access_type type,
-				const struct bpf_prog *prog,
-				struct bpf_insn_access_aux *info)
-{
-	if (prog->expected_attach_type != BPF_XDP_DEVMAP) {
-		switch (off) {
-		case offsetof(struct xdp_md, egress_ifindex):
-			return false;
-		}
-	}
-
-	if (type == BPF_WRITE) {
-		if (bpf_prog_is_dev_bound(prog->aux)) {
-			switch (off) {
-			case offsetof(struct xdp_md, rx_queue_index):
-				return __is_valid_xdp_access(off, size);
-			}
-		}
-		return false;
-	}
-
-	switch (off) {
-	case offsetof(struct xdp_md, data):
-		info->reg_type = PTR_TO_PACKET;
-		break;
-	case offsetof(struct xdp_md, data_meta):
-		info->reg_type = PTR_TO_PACKET_META;
-		break;
-	case offsetof(struct xdp_md, data_end):
-		info->reg_type = PTR_TO_PACKET_END;
-		break;
-	}
-
-	return __is_valid_xdp_access(off, size);
-}
-
-void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
-{
-	const u32 act_max = XDP_REDIRECT;
-
-	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
-		     act > act_max ? "Illegal" : "Driver unsupported",
-		     act, prog->aux->name, prog->aux->id, dev ? dev->name : "N/A");
-}
-EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
 static bool sock_addr_is_valid_access(int off, int size,
 				      enum bpf_access_type type,
@@ -9705,62 +8900,6 @@ static u32 tc_cls_act_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
-static u32 xdp_convert_ctx_access(enum bpf_access_type type,
-				  const struct bpf_insn *si,
-				  struct bpf_insn *insn_buf,
-				  struct bpf_prog *prog, u32 *target_size)
-{
-	struct bpf_insn *insn = insn_buf;
-
-	switch (si->off) {
-	case offsetof(struct xdp_md, data):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, data));
-		break;
-	case offsetof(struct xdp_md, data_meta):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_meta),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, data_meta));
-		break;
-	case offsetof(struct xdp_md, data_end):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_end),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, data_end));
-		break;
-	case offsetof(struct xdp_md, ingress_ifindex):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, rxq));
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
-				      si->dst_reg, si->dst_reg,
-				      offsetof(struct xdp_rxq_info, dev));
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
-				      offsetof(struct net_device, ifindex));
-		break;
-	case offsetof(struct xdp_md, rx_queue_index):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, rxq));
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
-				      offsetof(struct xdp_rxq_info,
-					       queue_index));
-		break;
-	case offsetof(struct xdp_md, egress_ifindex):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, txq),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, txq));
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_txq_info, dev),
-				      si->dst_reg, si->dst_reg,
-				      offsetof(struct xdp_txq_info, dev));
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
-				      offsetof(struct net_device, ifindex));
-		break;
-	}
-
-	return insn - insn_buf;
-}
-
 /* SOCK_ADDR_LOAD_NESTED_FIELD() loads Nested Field S.F.NF where S is type of
  * context Structure, F is Field in context structure that contains a pointer
  * to Nested Structure of type NS that has the field NF.
@@ -10602,17 +9741,6 @@ const struct bpf_prog_ops tc_cls_act_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops xdp_verifier_ops = {
-	.get_func_proto		= xdp_func_proto,
-	.is_valid_access	= xdp_is_valid_access,
-	.convert_ctx_access	= xdp_convert_ctx_access,
-	.gen_prologue		= bpf_noop_prologue,
-};
-
-const struct bpf_prog_ops xdp_prog_ops = {
-	.test_run		= bpf_prog_test_run_xdp,
-};
-
 const struct bpf_verifier_ops cg_skb_verifier_ops = {
 	.get_func_proto		= cg_skb_func_proto,
 	.is_valid_access	= cg_skb_is_valid_access,
@@ -11266,13 +10394,6 @@ const struct bpf_verifier_ops sk_lookup_verifier_ops = {
 
 #endif /* CONFIG_INET */
 
-DEFINE_BPF_DISPATCHER(xdp)
-
-void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
-{
-	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
-}
-
 BTF_ID_LIST_GLOBAL(btf_sock_ids, MAX_BTF_SOCK_TYPE)
 #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
 BTF_SOCK_TYPE_xxx
-- 
2.36.1

