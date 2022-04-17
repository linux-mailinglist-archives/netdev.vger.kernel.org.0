Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640C9504781
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiDQKPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 06:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiDQKPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 06:15:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB1C12623;
        Sun, 17 Apr 2022 03:13:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c23so10366787plo.0;
        Sun, 17 Apr 2022 03:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U+liOa9/svVGl40LoOP91TZqPtAXlBdcwQp39jTLbYM=;
        b=XU2jvVjvgIqBWRZ+Z9MRq//7SDDtBwkJEwppxvIwG9Q82tx7U24IDfdEIX3DYX+e6q
         t81vrGLYHJp2CMsMi/wL+to01+q2FBkjpfz4tXmp7Sr9KPsrrOBczs/oylsGB3eXleVX
         arf8+5TZDV4I6s2JjVhtDDo2u418EleYowzNfYmAYHWoGNqxJwzISJkX6b/08AUrSAyw
         p+neiAfRRZSM7vCi7trgVWPN+sqKkO16sjHL32mQxsrWqZsMAg8GWzePmPA+Zjn6AK9Q
         FnTcd8+UkuBy8UbQhf1RClZGrrhu9u33tJrVRpeiOY+cYE+KY0Og26HboC7M764w5dMo
         hdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U+liOa9/svVGl40LoOP91TZqPtAXlBdcwQp39jTLbYM=;
        b=hCBo/0kk5Pf+xuy3mRZiATCmo6sCgooyx7BYgcln4cCJKv+/8RQWCzDWa9zNPyywaF
         iZGaLl80Olj9OqpWr9EIxj9vTQ8YWHLosrpOvMjXr6OkVg1akfmOxcAIrrl2hn5lh+pe
         aTRnPKTQoKTMx7IiHVJ9yhQq5U2TtDniwdpqtHzW6HnlHca87epXPpRTNiaEUXZ3LOCo
         bZsaJijKOELEWdx6iXz+2mcDltUurC7dB2g/sWrUApuGClHUCtLpcdy7CGabjCqtjPU4
         3+D7hTsXg+HD86kNYrB3U2EClt20U8zVwQAdUM2af19o8+khrDnP7kMuVNk0Z+P7+d5W
         5GRw==
X-Gm-Message-State: AOAM533bfQhy6fZpdl/qfy9zcexK+PXcDZh4Rkny29x8XIEsdBsY2qvS
        J91Rs+NXtnBMOw8Oe7p3iJc=
X-Google-Smtp-Source: ABdhPJyZE/eMM7Gfcrl+kNNBRnt05dC74VvD474Kani68D8KwvBX+kXyhijM1bqwHuu8rP/lrdCJGQ==
X-Received: by 2002:a17:90b:3a89:b0:1d1:6633:5eb9 with SMTP id om9-20020a17090b3a8900b001d166335eb9mr9672139pjb.188.1650190384302;
        Sun, 17 Apr 2022 03:13:04 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x36-20020a056a000be400b0050a40b8290dsm7473760pfu.54.2022.04.17.03.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 03:13:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v5 1/3] net: atlantic: Implement xdp control plane
Date:   Sun, 17 Apr 2022 10:12:45 +0000
Message-Id: <20220417101247.13544-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220417101247.13544-1-ap420073@gmail.com>
References: <20220417101247.13544-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

aq_xdp() is a xdp setup callback function for Atlantic driver.
When XDP is attached or detached, the device will be restarted because
it uses different headroom, tailroom, and page order value.

If XDP enabled, it switches default page order value from 0 to 2.
Because the default maximum frame size is still 2K and it needs
additional area for headroom and tailroom.
The total size(headroom + frame size + tailroom) is 2624.
So, 1472Bytes will be always wasted for every frame.
But when order-2 is used, these pages can be used 6 times
with flip strategy.
It means only about 106Bytes per frame will be wasted.

Also, It supports xdp fragment feature.
MTU can be 16K if xdp prog supports xdp fragment.
If not, MTU can not exceed 2K - ETH_HLEN - ETH_FCS.

And a static key is added and It will be used to call the xdp_clean
handler in ->poll(). data plane implementation will be contained
the followed patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v5:
 - Use MEM_TYPE_PAGE_SHARED instead of MEM_TYPE_PAGE_ORDER0
 - Use 2K frame size instead of 3K
 - Use order-2 page allocation instead of order-0
 - Rename aq_get_rxpage() to aq_alloc_rxpages()

v4:
 - No changed

v3:
 - Disable LRO when single buffer XDP is attached

v2:
 - No changed

 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |  1 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 86 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_main.h  |  2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  3 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 64 +++++++++-----
 .../net/ethernet/aquantia/atlantic/aq_ring.h  | 13 ++-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 23 +++--
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  6 ++
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 10 +--
 10 files changed, 177 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index 52b9833fda99..8bcda2cb3a2e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -40,6 +40,7 @@
 #define AQ_CFG_RX_HDR_SIZE 256U
 
 #define AQ_CFG_RX_PAGEORDER 0U
+#define AQ_CFG_XDP_PAGEORDER 2U
 
 /* LRO */
 #define AQ_CFG_IS_LRO_DEF           1U
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e65ce7199dac..e794ee25b12b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -14,17 +14,22 @@
 #include "aq_ptp.h"
 #include "aq_filters.h"
 #include "aq_hw_utils.h"
+#include "aq_vec.h"
 
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <net/pkt_cls.h>
+#include <linux/filter.h>
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(AQ_CFG_DRV_AUTHOR);
 MODULE_DESCRIPTION(AQ_CFG_DRV_DESC);
 
+DEFINE_STATIC_KEY_FALSE(aq_xdp_locking_key);
+EXPORT_SYMBOL(aq_xdp_locking_key);
+
 static const char aq_ndev_driver_name[] = AQ_CFG_DRV_NAME;
 
 static const struct net_device_ops aq_ndev_ops;
@@ -126,9 +131,19 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 
 static int aq_ndev_change_mtu(struct net_device *ndev, int new_mtu)
 {
+	int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN;
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
+	struct bpf_prog *prog;
 	int err;
 
+	prog = READ_ONCE(aq_nic->xdp_prog);
+	if (prog && !prog->aux->xdp_has_frags &&
+	    new_frame_size > AQ_CFG_RX_FRAME_MAX) {
+		netdev_err(ndev, "Illegal MTU %d for XDP prog without frags\n",
+			   ndev->mtu);
+		return -EOPNOTSUPP;
+	}
+
 	err = aq_nic_set_mtu(aq_nic, new_mtu + ETH_HLEN);
 
 	if (err < 0)
@@ -204,6 +219,25 @@ static int aq_ndev_set_features(struct net_device *ndev,
 	return err;
 }
 
+static netdev_features_t aq_ndev_fix_features(struct net_device *ndev,
+					      netdev_features_t features)
+{
+	struct aq_nic_s *aq_nic = netdev_priv(ndev);
+	struct bpf_prog *prog;
+
+	if (!(features & NETIF_F_RXCSUM))
+		features &= ~NETIF_F_LRO;
+
+	prog = READ_ONCE(aq_nic->xdp_prog);
+	if (prog && !prog->aux->xdp_has_frags &&
+	    aq_nic->xdp_prog && features & NETIF_F_LRO) {
+		netdev_err(ndev, "LRO is not supported with single buffer XDP, disabling\n");
+		features &= ~NETIF_F_LRO;
+	}
+
+	return features;
+}
+
 static int aq_ndev_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
@@ -410,6 +444,56 @@ static int aq_ndo_setup_tc(struct net_device *dev, enum tc_setup_type type,
 				      mqprio->qopt.prio_tc_map);
 }
 
+static int aq_xdp_setup(struct net_device *ndev, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack)
+{
+	bool need_update, running = netif_running(ndev);
+	struct aq_nic_s *aq_nic = netdev_priv(ndev);
+	struct bpf_prog *old_prog;
+
+	if (prog && !prog->aux->xdp_has_frags) {
+		if (ndev->mtu > AQ_CFG_RX_FRAME_MAX) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "prog does not support XDP frags");
+			return -EOPNOTSUPP;
+		}
+
+		if (prog && ndev->features & NETIF_F_LRO) {
+			netdev_err(ndev,
+				   "LRO is not supported with single buffer XDP, disabling\n");
+			ndev->features &= ~NETIF_F_LRO;
+		}
+	}
+
+	need_update = !!aq_nic->xdp_prog != !!prog;
+	if (running && need_update)
+		aq_ndev_close(ndev);
+
+	old_prog = xchg(&aq_nic->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (!old_prog && prog)
+		static_branch_inc(&aq_xdp_locking_key);
+	else if (old_prog && !prog)
+		static_branch_dec(&aq_xdp_locking_key);
+
+	if (running && need_update)
+		return aq_ndev_open(ndev);
+
+	return 0;
+}
+
+static int aq_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return aq_xdp_setup(dev, xdp->prog, xdp->extack);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct net_device_ops aq_ndev_ops = {
 	.ndo_open = aq_ndev_open,
 	.ndo_stop = aq_ndev_close,
@@ -418,10 +502,12 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_change_mtu = aq_ndev_change_mtu,
 	.ndo_set_mac_address = aq_ndev_set_mac_address,
 	.ndo_set_features = aq_ndev_set_features,
+	.ndo_fix_features = aq_ndev_fix_features,
 	.ndo_eth_ioctl = aq_ndev_ioctl,
 	.ndo_vlan_rx_add_vid = aq_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = aq_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc = aq_ndo_setup_tc,
+	.ndo_bpf = aq_xdp,
 };
 
 static int __init aq_ndev_init_module(void)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.h b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
index a5a624b9ce73..99870865f66d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
@@ -12,6 +12,8 @@
 #include "aq_common.h"
 #include "aq_nic.h"
 
+DECLARE_STATIC_KEY_FALSE(aq_xdp_locking_key);
+
 void aq_ndev_schedule_work(struct work_struct *work);
 struct net_device *aq_ndev_alloc(void);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 1a7148041e3d..47123baabd5e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -11,6 +11,8 @@
 #define AQ_NIC_H
 
 #include <linux/ethtool.h>
+#include <net/xdp.h>
+#include <linux/bpf.h>
 
 #include "aq_common.h"
 #include "aq_rss.h"
@@ -128,6 +130,7 @@ struct aq_nic_s {
 	struct aq_vec_s *aq_vec[AQ_CFG_VECS_MAX];
 	struct aq_ring_s *aq_ring_tx[AQ_HW_QUEUES_MAX];
 	struct aq_hw_s *aq_hw;
+	struct bpf_prog *xdp_prog;
 	struct net_device *ndev;
 	unsigned int aq_vecs;
 	unsigned int packet_filter;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 77e76c9efd32..31a14a0dc25d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -7,12 +7,16 @@
 
 /* File aq_ring.c: Definition of functions for Rx/Tx rings. */
 
-#include "aq_ring.h"
 #include "aq_nic.h"
 #include "aq_hw.h"
 #include "aq_hw_utils.h"
 #include "aq_ptp.h"
+#include "aq_vec.h"
+#include "aq_main.h"
 
+#include <net/xdp.h>
+#include <linux/filter.h>
+#include <linux/bpf_trace.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
@@ -27,9 +31,10 @@ static inline void aq_free_rxpage(struct aq_rxpage *rxpage, struct device *dev)
 	rxpage->page = NULL;
 }
 
-static int aq_get_rxpage(struct aq_rxpage *rxpage, unsigned int order,
-			 struct device *dev)
+static int aq_alloc_rxpages(struct aq_rxpage *rxpage, struct aq_ring_s *rx_ring)
 {
+	struct device *dev = aq_nic_get_dev(rx_ring->aq_nic);
+	unsigned int order = rx_ring->page_order;
 	struct page *page;
 	int ret = -ENOMEM;
 	dma_addr_t daddr;
@@ -47,7 +52,7 @@ static int aq_get_rxpage(struct aq_rxpage *rxpage, unsigned int order,
 	rxpage->page = page;
 	rxpage->daddr = daddr;
 	rxpage->order = order;
-	rxpage->pg_off = 0;
+	rxpage->pg_off = rx_ring->page_offset;
 
 	return 0;
 
@@ -58,21 +63,26 @@ static int aq_get_rxpage(struct aq_rxpage *rxpage, unsigned int order,
 	return ret;
 }
 
-static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
-			  int order)
+static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf)
 {
+	unsigned int order = self->page_order;
+	u16 page_offset = self->page_offset;
+	u16 frame_max = self->frame_max;
+	u16 tail_size = self->tail_size;
 	int ret;
 
 	if (rxbuf->rxdata.page) {
 		/* One means ring is the only user and can reuse */
 		if (page_ref_count(rxbuf->rxdata.page) > 1) {
 			/* Try reuse buffer */
-			rxbuf->rxdata.pg_off += AQ_CFG_RX_FRAME_MAX;
-			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX <=
-				(PAGE_SIZE << order)) {
+			rxbuf->rxdata.pg_off += frame_max + page_offset +
+						tail_size;
+			if (rxbuf->rxdata.pg_off + frame_max + tail_size <=
+			    (PAGE_SIZE << order)) {
 				u64_stats_update_begin(&self->stats.rx.syncp);
 				self->stats.rx.pg_flips++;
 				u64_stats_update_end(&self->stats.rx.syncp);
+
 			} else {
 				/* Buffer exhausted. We have other users and
 				 * should release this page and realloc
@@ -84,7 +94,7 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
 				u64_stats_update_end(&self->stats.rx.syncp);
 			}
 		} else {
-			rxbuf->rxdata.pg_off = 0;
+			rxbuf->rxdata.pg_off = page_offset;
 			u64_stats_update_begin(&self->stats.rx.syncp);
 			self->stats.rx.pg_reuses++;
 			u64_stats_update_end(&self->stats.rx.syncp);
@@ -92,8 +102,7 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct aq_ring_buff_s *rxbuf,
 	}
 
 	if (!rxbuf->rxdata.page) {
-		ret = aq_get_rxpage(&rxbuf->rxdata, order,
-				    aq_nic_get_dev(self->aq_nic));
+		ret = aq_alloc_rxpages(&rxbuf->rxdata, self);
 		if (ret) {
 			u64_stats_update_begin(&self->stats.rx.syncp);
 			self->stats.rx.alloc_fails++;
@@ -117,6 +126,7 @@ static struct aq_ring_s *aq_ring_alloc(struct aq_ring_s *self,
 		err = -ENOMEM;
 		goto err_exit;
 	}
+
 	self->dx_ring = dma_alloc_coherent(aq_nic_get_dev(aq_nic),
 					   self->size * self->dx_size,
 					   &self->dx_ring_pa, GFP_KERNEL);
@@ -172,11 +182,22 @@ struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *self,
 	self->idx = idx;
 	self->size = aq_nic_cfg->rxds;
 	self->dx_size = aq_nic_cfg->aq_hw_caps->rxd_size;
-	self->page_order = fls(AQ_CFG_RX_FRAME_MAX / PAGE_SIZE +
-			       (AQ_CFG_RX_FRAME_MAX % PAGE_SIZE ? 1 : 0)) - 1;
-
-	if (aq_nic_cfg->rxpageorder > self->page_order)
-		self->page_order = aq_nic_cfg->rxpageorder;
+	self->xdp_prog = aq_nic->xdp_prog;
+	self->frame_max = AQ_CFG_RX_FRAME_MAX;
+
+	/* Only order-2 is allowed if XDP is enabled */
+	if (READ_ONCE(self->xdp_prog)) {
+		self->page_offset = AQ_XDP_HEADROOM;
+		self->page_order = AQ_CFG_XDP_PAGEORDER;
+		self->tail_size = AQ_XDP_TAILROOM;
+	} else {
+		self->page_offset = 0;
+		self->page_order = fls(self->frame_max / PAGE_SIZE +
+				       (self->frame_max % PAGE_SIZE ? 1 : 0)) - 1;
+		if (aq_nic_cfg->rxpageorder > self->page_order)
+			self->page_order = aq_nic_cfg->rxpageorder;
+		self->tail_size = 0;
+	}
 
 	self = aq_ring_alloc(self, aq_nic);
 	if (!self) {
@@ -449,7 +470,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			skb_add_rx_frag(skb, 0, buff->rxdata.page,
 					buff->rxdata.pg_off + hdr_len,
 					buff->len - hdr_len,
-					AQ_CFG_RX_FRAME_MAX);
+					self->frame_max);
 			page_ref_inc(buff->rxdata.page);
 		}
 
@@ -469,7 +490,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 						buff_->rxdata.page,
 						buff_->rxdata.pg_off,
 						buff_->len,
-						AQ_CFG_RX_FRAME_MAX);
+						self->frame_max);
 				page_ref_inc(buff_->rxdata.page);
 				buff_->is_cleaned = 1;
 
@@ -529,7 +550,6 @@ void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic)
 
 int aq_ring_rx_fill(struct aq_ring_s *self)
 {
-	unsigned int page_order = self->page_order;
 	struct aq_ring_buff_s *buff = NULL;
 	int err = 0;
 	int i = 0;
@@ -543,9 +563,9 @@ int aq_ring_rx_fill(struct aq_ring_s *self)
 		buff = &self->buff_ring[self->sw_tail];
 
 		buff->flags = 0U;
-		buff->len = AQ_CFG_RX_FRAME_MAX;
+		buff->len = self->frame_max;
 
-		err = aq_get_rxpages(self, buff, page_order);
+		err = aq_get_rxpages(self, buff);
 		if (err)
 			goto err_exit;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 93659e58f1ce..2dadfaff47f5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -11,6 +11,10 @@
 #define AQ_RING_H
 
 #include "aq_common.h"
+#include "aq_vec.h"
+
+#define AQ_XDP_HEADROOM		ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8)
+#define AQ_XDP_TAILROOM		SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
 
 struct page;
 struct aq_nic_cfg_s;
@@ -51,6 +55,7 @@ struct __packed aq_ring_buff_s {
 		struct {
 			dma_addr_t pa_eop;
 			struct sk_buff *skb;
+			struct xdp_frame *xdpf;
 		};
 		/* TxC */
 		struct {
@@ -132,10 +137,15 @@ struct aq_ring_s {
 	unsigned int size;	/* descriptors number */
 	unsigned int dx_size;	/* TX or RX descriptor size,  */
 				/* stored here for fater math */
-	unsigned int page_order;
+	u16 page_order;
+	u16 page_offset;
+	u16 frame_max;
+	u16 tail_size;
 	union aq_ring_stats_s stats;
 	dma_addr_t dx_ring_pa;
+	struct bpf_prog *xdp_prog;
 	enum atl_ring_type ring_type;
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct aq_ring_param_s {
@@ -175,6 +185,7 @@ struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *self,
 				   struct aq_nic_s *aq_nic,
 				   unsigned int idx,
 				   struct aq_nic_cfg_s *aq_nic_cfg);
+
 int aq_ring_init(struct aq_ring_s *self, const enum atl_ring_type ring_type);
 void aq_ring_rx_deinit(struct aq_ring_s *self);
 void aq_ring_free(struct aq_ring_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 6ab1f3212d24..997f351bc371 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -10,11 +10,6 @@
  */
 
 #include "aq_vec.h"
-#include "aq_nic.h"
-#include "aq_ring.h"
-#include "aq_hw.h"
-
-#include <linux/netdevice.h>
 
 struct aq_vec_s {
 	const struct aq_hw_ops *aq_hw_ops;
@@ -153,9 +148,23 @@ int aq_vec_ring_alloc(struct aq_vec_s *self, struct aq_nic_s *aq_nic,
 
 		aq_nic_set_tx_ring(aq_nic, idx_ring, ring);
 
+		if (xdp_rxq_info_reg(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq,
+				     aq_nic->ndev, idx,
+				     self->napi.napi_id) < 0) {
+			err = -ENOMEM;
+			goto err_exit;
+		}
+		if (xdp_rxq_info_reg_mem_model(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq,
+					       MEM_TYPE_PAGE_ORDER0, NULL) < 0) {
+			xdp_rxq_info_unreg(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq);
+			err = -ENOMEM;
+			goto err_exit;
+		}
+
 		ring = aq_ring_rx_alloc(&self->ring[i][AQ_VEC_RX_ID], aq_nic,
 					idx_ring, aq_nic_cfg);
 		if (!ring) {
+			xdp_rxq_info_unreg(&self->ring[i][AQ_VEC_RX_ID].xdp_rxq);
 			err = -ENOMEM;
 			goto err_exit;
 		}
@@ -300,8 +309,10 @@ void aq_vec_ring_free(struct aq_vec_s *self)
 	for (i = 0U; self->tx_rings > i; ++i) {
 		ring = self->ring[i];
 		aq_ring_free(&ring[AQ_VEC_TX_ID]);
-		if (i < self->rx_rings)
+		if (i < self->rx_rings) {
+			xdp_rxq_info_unreg(&ring[AQ_VEC_RX_ID].xdp_rxq);
 			aq_ring_free(&ring[AQ_VEC_RX_ID]);
+		}
 	}
 
 	self->tx_rings = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
index 567f3d4b79a2..78fac609b71d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
@@ -13,7 +13,13 @@
 #define AQ_VEC_H
 
 #include "aq_common.h"
+#include "aq_nic.h"
+#include "aq_ring.h"
+#include "aq_hw.h"
+
 #include <linux/irqreturn.h>
+#include <linux/filter.h>
+#include <linux/netdevice.h>
 
 struct aq_hw_s;
 struct aq_hw_ops;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 4625ccb79499..9dfd68f0fda9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -531,7 +531,7 @@ static int hw_atl_a0_hw_ring_rx_init(struct aq_hw_s *self,
 	hw_atl_rdm_rx_desc_len_set(self, aq_ring->size / 8U, aq_ring->idx);
 
 	hw_atl_rdm_rx_desc_data_buff_size_set(self,
-					      AQ_CFG_RX_FRAME_MAX / 1024U,
+					      aq_ring->frame_max / 1024U,
 					      aq_ring->idx);
 
 	hw_atl_rdm_rx_desc_head_buff_size_set(self, 0U, aq_ring->idx);
@@ -706,9 +706,9 @@ static int hw_atl_a0_hw_ring_rx_receive(struct aq_hw_s *self,
 
 			if (HW_ATL_A0_RXD_WB_STAT2_EOP & rxd_wb->status) {
 				buff->len = rxd_wb->pkt_len %
-					AQ_CFG_RX_FRAME_MAX;
+					    ring->frame_max;
 				buff->len = buff->len ?
-					buff->len : AQ_CFG_RX_FRAME_MAX;
+					buff->len : ring->frame_max;
 				buff->next = 0U;
 				buff->is_eop = 1U;
 			} else {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index d875ce3ec759..878a53abec33 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -766,7 +766,7 @@ int hw_atl_b0_hw_ring_rx_init(struct aq_hw_s *self, struct aq_ring_s *aq_ring,
 	hw_atl_rdm_rx_desc_len_set(self, aq_ring->size / 8U, aq_ring->idx);
 
 	hw_atl_rdm_rx_desc_data_buff_size_set(self,
-					      AQ_CFG_RX_FRAME_MAX / 1024U,
+					      aq_ring->frame_max / 1024U,
 				       aq_ring->idx);
 
 	hw_atl_rdm_rx_desc_head_buff_size_set(self, 0U, aq_ring->idx);
@@ -969,15 +969,15 @@ int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self, struct aq_ring_s *ring)
 				  rxd_wb->status);
 		if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
 			buff->len = rxd_wb->pkt_len %
-				AQ_CFG_RX_FRAME_MAX;
+				ring->frame_max;
 			buff->len = buff->len ?
-				buff->len : AQ_CFG_RX_FRAME_MAX;
+				buff->len : ring->frame_max;
 			buff->next = 0U;
 			buff->is_eop = 1U;
 		} else {
 			buff->len =
-				rxd_wb->pkt_len > AQ_CFG_RX_FRAME_MAX ?
-				AQ_CFG_RX_FRAME_MAX : rxd_wb->pkt_len;
+				rxd_wb->pkt_len > ring->frame_max ?
+				ring->frame_max : rxd_wb->pkt_len;
 
 			if (buff->is_lro) {
 				/* LRO */
-- 
2.17.1

