Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6E1DE1AA
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgEVIUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:20:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64788 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728152AbgEVIUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 04:20:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M8FKre032651;
        Fri, 22 May 2020 01:19:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=xpnhuZIkm/HHr1XJJc0TwJMHwW7EPssMp1BZZ8lIlAU=;
 b=Gt61Z1ozoxgz0kJs4orHjLA9v7BG/Ie5sUzwdTT4e5ypmNJQVmIFFJtGtWrt504A/Ixt
 qBl230f3RUYT5ibcloK/VXGKomAzJriedINUTx33UpbxpvQu86CuidlgQqhhurdXmdlh
 Drgi2VB4xkr7UrjJvT0BcVzg8twwufROqIsW69ulPpbunRCCkDRvIr2YFXp8t/+WoMgJ
 LIwazvBXCtlPrXvdoWafKW814cVVe1GgIJVoYUzlk5WKsCj070S6gqJoEZBg47ZhbfBT
 Ofrftmd/bnfUac7rsuBLakK3VOfEyp/EQFV1hNv7AvLSehhWHOhxT05E7WDyvPIpXQ1Z Mg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhr29e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 01:19:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 01:19:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 01:19:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 01:19:56 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id AD0AB3F7043;
        Fri, 22 May 2020 01:19:54 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 01/12] net: atlantic: changes for multi-TC support
Date:   Fri, 22 May 2020 11:19:37 +0300
Message-ID: <20200522081948.167-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200522081948.167-1-irusskikh@marvell.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_04:2020-05-21,2020-05-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dbezrukov@marvell.com>

This patch contains the following changes:
* access cfg via aq_nic_get_cfg() in aq_nic_start() and aq_nic_map_skb();
* call aq_nic_get_dev() just once in aq_nic_map_skb();
* move ring allocation/deallocation out of aq_vec_alloc()/aq_vec_free();
* add the missing aq_nic_deinit() in atl_resume_common();
* rename 'tcs' field to 'tcs_max' in aq_hw_caps_s to differentiate it from
  the 'tcs' field in aq_nic_cfg_s, which is used for the current number of
  TCs;
* update _TC_MAX defines to the actual number of supported TCs;
* move tx_tc_mode register defines slightly higher (just to keep the order
  of definitions);
* separate variables for TX/RX buff_size in hw_atl*_hw_qos_set();
* use AQ_HW_*_TC instead of hardcoded magic numbers;
* actually use the 'ret' value in aq_mdo_add_secy();

Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Co-developed-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  4 +-
 .../ethernet/aquantia/atlantic/aq_macsec.c    |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 43 +++++++++++------
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  3 ++
 .../net/ethernet/aquantia/atlantic/aq_vec.c   | 47 ++++++++++++-------
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |  3 ++
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 34 ++++++--------
 .../atlantic/hw_atl/hw_atl_b0_internal.h      |  2 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 31 +++++++-----
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  4 +-
 .../atlantic/hw_atl2/hw_atl2_internal.h       |  2 +-
 12 files changed, 105 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 03fea9469f01..703ef8d064a2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -46,7 +46,7 @@ struct aq_hw_caps_s {
 	u32 mac_regs_count;
 	u32 hw_alive_check_addr;
 	u8 msix_irqs;
-	u8 tcs;
+	u8 tcs_max;
 	u8 rxd_alignment;
 	u8 rxd_size;
 	u8 txd_alignment;
@@ -120,6 +120,8 @@ struct aq_stats_s {
 
 #define AQ_HW_MULTICAST_ADDRESS_MAX     32U
 
+#define AQ_HW_PTP_TC                    2U
+
 #define AQ_HW_LED_BLINK    0x2U
 #define AQ_HW_LED_DEFAULT  0x0U
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 91870ceaf3fe..4a6dfac857ca 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -478,7 +478,7 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 
 	set_bit(txsc_idx, &cfg->txsc_idx_busy);
 
-	return 0;
+	return ret;
 }
 
 static int aq_mdo_upd_secy(struct macsec_context *ctx)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 1c6d12deb47a..b003f1035701 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -399,9 +399,15 @@ int aq_nic_init(struct aq_nic_s *self)
 		err = aq_phy_init(self->aq_hw);
 	}
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
+	for (i = 0U; i < self->aq_vecs; i++) {
+		aq_vec = self->aq_vec[i];
+		err = aq_vec_ring_alloc(aq_vec, self, i,
+					aq_nic_get_cfg(self));
+		if (err)
+			goto err_exit;
+
 		aq_vec_init(aq_vec, self->aq_hw_ops, self->aq_hw);
+	}
 
 	err = aq_ptp_init(self, self->irqvecs - 1);
 	if (err < 0)
@@ -424,9 +430,12 @@ int aq_nic_init(struct aq_nic_s *self)
 int aq_nic_start(struct aq_nic_s *self)
 {
 	struct aq_vec_s *aq_vec = NULL;
+	struct aq_nic_cfg_s *cfg;
 	unsigned int i = 0U;
 	int err = 0;
 
+	cfg = aq_nic_get_cfg(self);
+
 	err = self->aq_hw_ops->hw_multicast_list_set(self->aq_hw,
 						     self->mc_list.ar,
 						     self->mc_list.count);
@@ -464,7 +473,7 @@ int aq_nic_start(struct aq_nic_s *self)
 	timer_setup(&self->service_timer, aq_nic_service_timer_cb, 0);
 	aq_nic_service_timer_cb(&self->service_timer);
 
-	if (self->aq_nic_cfg.is_polling) {
+	if (cfg->is_polling) {
 		timer_setup(&self->polling_timer, aq_nic_polling_timer_cb, 0);
 		mod_timer(&self->polling_timer, jiffies +
 			  AQ_CFG_POLLING_TIMER_INTERVAL);
@@ -482,16 +491,16 @@ int aq_nic_start(struct aq_nic_s *self)
 		if (err < 0)
 			goto err_exit;
 
-		if (self->aq_nic_cfg.link_irq_vec) {
+		if (cfg->link_irq_vec) {
 			int irqvec = pci_irq_vector(self->pdev,
-						   self->aq_nic_cfg.link_irq_vec);
+						    cfg->link_irq_vec);
 			err = request_threaded_irq(irqvec, NULL,
 						   aq_linkstate_threaded_isr,
 						   IRQF_SHARED | IRQF_ONESHOT,
 						   self->ndev->name, self);
 			if (err < 0)
 				goto err_exit;
-			self->msix_entry_mask |= (1 << self->aq_nic_cfg.link_irq_vec);
+			self->msix_entry_mask |= (1 << cfg->link_irq_vec);
 		}
 
 		err = self->aq_hw_ops->hw_irq_enable(self->aq_hw,
@@ -518,6 +527,8 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 			    struct aq_ring_s *ring)
 {
 	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
+	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(self);
+	struct device *dev = aq_nic_get_dev(self);
 	struct aq_ring_buff_s *first = NULL;
 	u8 ipver = ip_hdr(skb)->version;
 	struct aq_ring_buff_s *dx_buff;
@@ -559,7 +570,7 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 		need_context_tag = true;
 	}
 
-	if (self->aq_nic_cfg.is_vlan_tx_insert && skb_vlan_tag_present(skb)) {
+	if (cfg->is_vlan_tx_insert && skb_vlan_tag_present(skb)) {
 		dx_buff->vlan_tx_tag = skb_vlan_tag_get(skb);
 		dx_buff->len_pkt = skb->len;
 		dx_buff->is_vlan = 1U;
@@ -574,12 +585,12 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 	}
 
 	dx_buff->len = skb_headlen(skb);
-	dx_buff->pa = dma_map_single(aq_nic_get_dev(self),
+	dx_buff->pa = dma_map_single(dev,
 				     skb->data,
 				     dx_buff->len,
 				     DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(aq_nic_get_dev(self), dx_buff->pa))) {
+	if (unlikely(dma_mapping_error(dev, dx_buff->pa))) {
 		ret = 0;
 		goto exit;
 	}
@@ -611,13 +622,13 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 			else
 				buff_size = frag_len;
 
-			frag_pa = skb_frag_dma_map(aq_nic_get_dev(self),
+			frag_pa = skb_frag_dma_map(dev,
 						   frag,
 						   buff_offset,
 						   buff_size,
 						   DMA_TO_DEVICE);
 
-			if (unlikely(dma_mapping_error(aq_nic_get_dev(self),
+			if (unlikely(dma_mapping_error(dev,
 						       frag_pa)))
 				goto mapping_error;
 
@@ -651,12 +662,12 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 		if (!(dx_buff->is_gso_tcp || dx_buff->is_gso_udp) &&
 		    !dx_buff->is_vlan && dx_buff->pa) {
 			if (unlikely(dx_buff->is_sop)) {
-				dma_unmap_single(aq_nic_get_dev(self),
+				dma_unmap_single(dev,
 						 dx_buff->pa,
 						 dx_buff->len,
 						 DMA_TO_DEVICE);
 			} else {
-				dma_unmap_page(aq_nic_get_dev(self),
+				dma_unmap_page(dev,
 					       dx_buff->pa,
 					       dx_buff->len,
 					       DMA_TO_DEVICE);
@@ -1145,9 +1156,11 @@ void aq_nic_deinit(struct aq_nic_s *self, bool link_down)
 	if (!self)
 		goto err_exit;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
+	for (i = 0U; i < self->aq_vecs; i++) {
+		aq_vec = self->aq_vec[i];
 		aq_vec_deinit(aq_vec);
+		aq_vec_ring_free(aq_vec);
+	}
 
 	aq_ptp_unregister(self);
 	aq_ptp_ring_deinit(self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index d10fff8a8c71..41c0f560f95b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -431,6 +431,9 @@ static int atl_resume_common(struct device *dev, bool deep)
 	netif_tx_start_all_queues(nic->ndev);
 
 err_exit:
+	if (ret < 0)
+		aq_nic_deinit(nic, true);
+
 	rtnl_unlock();
 
 	return ret;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index f40a427970dc..d5650cd6e236 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -103,16 +103,11 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 			      struct aq_nic_cfg_s *aq_nic_cfg)
 {
-	struct aq_ring_s *ring = NULL;
 	struct aq_vec_s *self = NULL;
-	unsigned int i = 0U;
-	int err = 0;
 
 	self = kzalloc(sizeof(*self), GFP_KERNEL);
-	if (!self) {
-		err = -ENOMEM;
+	if (!self)
 		goto err_exit;
-	}
 
 	self->aq_nic = aq_nic;
 	self->aq_ring_param.vec_idx = idx;
@@ -128,10 +123,19 @@ struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 	netif_napi_add(aq_nic_get_ndev(aq_nic), &self->napi,
 		       aq_vec_poll, AQ_CFG_NAPI_WEIGHT);
 
+err_exit:
+	return self;
+}
+
+int aq_vec_ring_alloc(struct aq_vec_s *self, struct aq_nic_s *aq_nic,
+		      unsigned int idx, struct aq_nic_cfg_s *aq_nic_cfg)
+{
+	struct aq_ring_s *ring = NULL;
+	unsigned int i = 0U;
+	int err = 0;
+
 	for (i = 0; i < aq_nic_cfg->tcs; ++i) {
-		unsigned int idx_ring = AQ_NIC_TCVEC2RING(self->nic,
-						self->tx_rings,
-						self->aq_ring_param.vec_idx);
+		unsigned int idx_ring = AQ_NIC_TCVEC2RING(aq_nic, i, idx);
 
 		ring = aq_ring_tx_alloc(&self->ring[i][AQ_VEC_TX_ID], aq_nic,
 					idx_ring, aq_nic_cfg);
@@ -156,11 +160,11 @@ struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 
 err_exit:
 	if (err < 0) {
-		aq_vec_free(self);
+		aq_vec_ring_free(self);
 		self = NULL;
 	}
 
-	return self;
+	return err;
 }
 
 int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
@@ -269,6 +273,18 @@ err_exit:;
 }
 
 void aq_vec_free(struct aq_vec_s *self)
+{
+	if (!self)
+		goto err_exit;
+
+	netif_napi_del(&self->napi);
+
+	kfree(self);
+
+err_exit:;
+}
+
+void aq_vec_ring_free(struct aq_vec_s *self)
 {
 	struct aq_ring_s *ring = NULL;
 	unsigned int i = 0U;
@@ -279,13 +295,12 @@ void aq_vec_free(struct aq_vec_s *self)
 	for (i = 0U, ring = self->ring[0];
 		self->tx_rings > i; ++i, ring = self->ring[i]) {
 		aq_ring_free(&ring[AQ_VEC_TX_ID]);
-		aq_ring_free(&ring[AQ_VEC_RX_ID]);
+		if (i < self->rx_rings)
+			aq_ring_free(&ring[AQ_VEC_RX_ID]);
 	}
 
-	netif_napi_del(&self->napi);
-
-	kfree(self);
-
+	self->tx_rings = 0;
+	self->rx_rings = 0;
 err_exit:;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
index 0fe8e0904c7f..0ee86b26df8a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
@@ -25,10 +25,13 @@ irqreturn_t aq_vec_isr(int irq, void *private);
 irqreturn_t aq_vec_isr_legacy(int irq, void *private);
 struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 			      struct aq_nic_cfg_s *aq_nic_cfg);
+int aq_vec_ring_alloc(struct aq_vec_s *self, struct aq_nic_s *aq_nic,
+		      unsigned int idx, struct aq_nic_cfg_s *aq_nic_cfg);
 int aq_vec_init(struct aq_vec_s *self, const struct aq_hw_ops *aq_hw_ops,
 		struct aq_hw_s *aq_hw);
 void aq_vec_deinit(struct aq_vec_s *self);
 void aq_vec_free(struct aq_vec_s *self);
+void aq_vec_ring_free(struct aq_vec_s *self);
 int aq_vec_start(struct aq_vec_s *self);
 void aq_vec_stop(struct aq_vec_s *self);
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 1b0670a8ae33..88b17cf77625 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -21,7 +21,7 @@
 	.msix_irqs = 4U,		  \
 	.irq_mask = ~0U,		  \
 	.vecs = HW_ATL_A0_RSS_MAX,	  \
-	.tcs = HW_ATL_A0_TC_MAX,	  \
+	.tcs_max = HW_ATL_A0_TC_MAX,	  \
 	.rxd_alignment = 1U,		  \
 	.rxd_size = HW_ATL_A0_RXD_SIZE,   \
 	.rxds_max = HW_ATL_A0_MAX_RXD,    \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index fa3cd7e9954b..bee4fb3c8741 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -23,7 +23,7 @@
 	.msix_irqs = 8U,		  \
 	.irq_mask = ~0U,		  \
 	.vecs = HW_ATL_B0_RSS_MAX,	  \
-	.tcs = HW_ATL_B0_TC_MAX,	  \
+	.tcs_max = HW_ATL_B0_TC_MAX,	  \
 	.rxd_alignment = 1U,		  \
 	.rxd_size = HW_ATL_B0_RXD_SIZE,   \
 	.rxds_max = HW_ATL_B0_MAX_RXD,    \
@@ -116,8 +116,9 @@ static int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc)
 
 static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 {
+	u32 tx_buff_size = HW_ATL_B0_TXBUF_MAX;
+	u32 rx_buff_size = HW_ATL_B0_RXBUF_MAX;
 	unsigned int i_priority = 0U;
-	u32 buff_size = 0U;
 	u32 tc = 0U;
 
 	/* TPS Descriptor rate init */
@@ -131,8 +132,6 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
-	tc = 0;
-
 	/* TX Packet Scheduler Data TC0 */
 	hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, tc);
 	hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, tc);
@@ -140,46 +139,41 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
 
 	/* Tx buf size TC0 */
-	buff_size = HW_ATL_B0_TXBUF_MAX - HW_ATL_B0_PTP_TXBUF_SIZE;
+	tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
 
-	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, buff_size, tc);
+	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
 	hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self,
-						   (buff_size *
+						   (tx_buff_size *
 						   (1024 / 32U) * 66U) /
 						   100U, tc);
 	hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(self,
-						   (buff_size *
+						   (tx_buff_size *
 						   (1024 / 32U) * 50U) /
 						   100U, tc);
 	/* Init TC2 for PTP_TX */
-	tc = 2;
-
 	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_TXBUF_SIZE,
-					       tc);
+					       AQ_HW_PTP_TC);
 
 	/* QoS Rx buf size per TC */
-	tc = 0;
-	buff_size = HW_ATL_B0_RXBUF_MAX - HW_ATL_B0_PTP_RXBUF_SIZE;
+	rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
 
-	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, buff_size, tc);
+	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
 	hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self,
-						   (buff_size *
+						   (rx_buff_size *
 						   (1024U / 32U) * 66U) /
 						   100U, tc);
 	hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self,
-						   (buff_size *
+						   (rx_buff_size *
 						   (1024U / 32U) * 50U) /
 						   100U, tc);
 
 	hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
 
 	/* Init TC2 for PTP_RX */
-	tc = 2;
-
 	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_RXBUF_SIZE,
-					       tc);
+					       AQ_HW_PTP_TC);
 	/* No flow control for PTP */
-	hw_atl_rpb_rx_xoff_en_per_tc_set(self, 0U, tc);
+	hw_atl_rpb_rx_xoff_en_per_tc_set(self, 0U, AQ_HW_PTP_TC);
 
 	/* QoS 802.1p priority -> TC mapping */
 	for (i_priority = 8U; i_priority--;)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
index 7ab23a1751d3..4fba4e0928c7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
@@ -75,7 +75,7 @@
 #define HW_ATL_B0_RSS_HASHKEY_BITS 320U
 
 #define HW_ATL_B0_TCRSS_4_8  1
-#define HW_ATL_B0_TC_MAX 1U
+#define HW_ATL_B0_TC_MAX 8U
 #define HW_ATL_B0_RSS_MAX 8U
 
 #define HW_ATL_B0_LRO_RXD_MAX 16U
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 18de2f7b8959..5d86ffab4ece 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -2038,6 +2038,24 @@
 /* default value of bitfield lso_tcp_flag_mid[b:0] */
 #define HW_ATL_THM_LSO_TCP_FLAG_MID_DEFAULT 0x0
 
+/* tx tx_tc_mode bitfield definitions
+ * preprocessor definitions for the bitfield "tx_tc_mode".
+ * port="pif_tpb_tx_tc_mode_i,pif_tps_tx_tc_mode_i"
+ */
+
+/* register address for bitfield tx_tc_mode */
+#define HW_ATL_TPB_TX_TC_MODE_ADDR 0x00007900
+/* bitmask for bitfield tx_tc_mode */
+#define HW_ATL_TPB_TX_TC_MODE_MSK 0x00000100
+/* inverted bitmask for bitfield tx_tc_mode */
+#define HW_ATL_TPB_TX_TC_MODE_MSKN 0xFFFFFEFF
+/* lower bit position of bitfield tx_tc_mode */
+#define HW_ATL_TPB_TX_TC_MODE_SHIFT 8
+/* width of bitfield tx_tc_mode */
+#define HW_ATL_TPB_TX_TC_MODE_WIDTH 1
+/* default value of bitfield tx_tc_mode */
+#define HW_ATL_TPB_TX_TC_MODE_DEFAULT 0x0
+
 /* tx tx_buf_en bitfield definitions
  * preprocessor definitions for the bitfield "tx_buf_en".
  * port="pif_tpb_tx_buf_en_i"
@@ -2056,19 +2074,6 @@
 /* default value of bitfield tx_buf_en */
 #define HW_ATL_TPB_TX_BUF_EN_DEFAULT 0x0
 
-/* register address for bitfield tx_tc_mode */
-#define HW_ATL_TPB_TX_TC_MODE_ADDR 0x00007900
-/* bitmask for bitfield tx_tc_mode */
-#define HW_ATL_TPB_TX_TC_MODE_MSK 0x00000100
-/* inverted bitmask for bitfield tx_tc_mode */
-#define HW_ATL_TPB_TX_TC_MODE_MSKN 0xFFFFFEFF
-/* lower bit position of bitfield tx_tc_mode */
-#define HW_ATL_TPB_TX_TC_MODE_SHIFT 8
-/* width of bitfield tx_tc_mode */
-#define HW_ATL_TPB_TX_TC_MODE_WIDTH 1
-/* default value of bitfield tx_tc_mode */
-#define HW_ATL_TPB_TX_TC_MODE_DEFAULT 0x0
-
 /* tx tx{b}_hi_thresh[c:0] bitfield definitions
  * preprocessor definitions for the bitfield "tx{b}_hi_thresh[c:0]".
  * parameter: buffer {b} | stride size 0x10 | range [0, 7]
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 6f2b33ae3d06..ccdb74562270 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -23,7 +23,7 @@ static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 	.msix_irqs = 8U,		  \
 	.irq_mask = ~0U,		  \
 	.vecs = HW_ATL2_RSS_MAX,	  \
-	.tcs = HW_ATL2_TC_MAX,	  \
+	.tcs_max = HW_ATL2_TC_MAX,	  \
 	.rxd_alignment = 1U,		  \
 	.rxd_size = HW_ATL2_RXD_SIZE,   \
 	.rxds_max = HW_ATL2_MAX_RXD,    \
@@ -126,8 +126,6 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
-	tc = 0;
-
 	/* TX Packet Scheduler Data TC0 */
 	hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF0, tc);
 	hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, 0x640, tc);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index e66b3583bfe9..be0c049ea582 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -31,7 +31,7 @@
 
 #define HW_ATL2_RSS_REDIRECTION_MAX 64U
 
-#define HW_ATL2_TC_MAX 1U
+#define HW_ATL2_TC_MAX 8U
 #define HW_ATL2_RSS_MAX 8U
 
 #define HW_ATL2_INTR_MODER_MAX  0x1FF
-- 
2.25.1

