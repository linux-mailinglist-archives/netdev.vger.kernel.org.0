Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB8A21D52C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgGMLm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:42:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39980 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729668AbgGMLmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:42:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBflbf014179;
        Mon, 13 Jul 2020 04:42:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mZUCctDHXW15piDz3EXdJL4LVxZNnKcsA9etTly0L94=;
 b=RIghghignb0y5U/0Yd/NMSpmrev9ErCGl8XE7KIouPR80fR8bn+XxcuUBqR7vDP8gzoI
 vepuxVbOV4SWfAyJnuq8q77HJI0Zg0srIsivIJ3VtDbXmEEkFwDFiJvd4lFEajq6YGVP
 DyJ/LLmA8BOYC5YE9IAm4jnvcAU2d7o6s9IN5RZi2igPzN34xAQM1GQnp6SHh5OSWOFE
 isO+cMcQVvi5/hBdUSDids/KwWY9yE5VpgblpZ/u53EZDs4z8n+t2HpD+UMJrTCYyHUy
 VNFur68jICW6o2SToVLWW/hpdg7ZYrACZhSkmsUHr0ipefVsjk9oat3iNef7fyTqsGZC TQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhgfgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:42:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:42:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:42:47 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id 78E1B3F703F;
        Mon, 13 Jul 2020 04:42:44 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>, <andrew@lunn.ch>
Subject: [PATCH net-next 01/10] net: atlantic: media detect
Date:   Mon, 13 Jul 2020 14:42:24 +0300
Message-ID: <20200713114233.436-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for low-power autoneg in PHY (media detect).
This is a custom feature of AQC107 builtin PHY, but configuration is only
done through MAC management firmware.
Some of our customers uses it for low power saving systems.

There is no any standard ethtool/phy interface for anything like this,
thus making this available through private flag.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
CC: andrew@lunn.ch
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  7 +++++++
 .../ethernet/aquantia/atlantic/aq_ethtool.h   | 10 +++++----
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  4 ++++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 19 +++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 21 +++++++++++++++++++
 6 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a8f0fbbbd91a..d36afeaae525 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -160,6 +160,7 @@ static const char aq_ethtool_priv_flag_names[][ETH_GSTRING_LEN] = {
 	"DMANetworkLoopback",
 	"PHYInternalLoopback",
 	"PHYExternalLoopback",
+	"MediaDetect"
 };
 
 static u32 aq_ethtool_n_stats(struct net_device *ndev)
@@ -852,6 +853,12 @@ static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 
 	cfg->priv_flags = flags;
 
+	if ((priv_flags ^ flags) & AQ_HW_MEDIA_DETECT_MASK) {
+		aq_nic_set_media_detect(aq_nic);
+		/* Restart aneg to make FW apply the new settings */
+		aq_nic->aq_fw_ops->renegotiate(aq_nic->aq_hw);
+	}
+
 	if ((priv_flags ^ flags) & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
 		if (netif_running(ndev)) {
 			dev_close(ndev);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h
index 6d5be5ebeb13..c0025340af38 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_ethtool.h: Declaration of ethertool related functions. */
@@ -12,6 +13,7 @@
 #include "aq_common.h"
 
 extern const struct ethtool_ops aq_ethtool_ops;
-#define AQ_PRIV_FLAGS_MASK   (AQ_HW_LOOPBACK_MASK)
+#define AQ_PRIV_FLAGS_MASK   ((AQ_HW_LOOPBACK_MASK) |\
+			      (AQ_HW_MEDIA_DETECT_MASK))
 
 #endif /* AQ_ETHTOOL_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index f2663ad22209..6358bed3d64e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -145,6 +145,7 @@ enum aq_priv_flags {
 	AQ_HW_LOOPBACK_DMA_NET,
 	AQ_HW_LOOPBACK_PHYINT_SYS,
 	AQ_HW_LOOPBACK_PHYEXT_SYS,
+	AQ_HW_MEDIA_DETECT,
 };
 
 #define AQ_HW_LOOPBACK_MASK	(BIT(AQ_HW_LOOPBACK_DMA_SYS) |\
@@ -152,6 +153,7 @@ enum aq_priv_flags {
 				 BIT(AQ_HW_LOOPBACK_DMA_NET) |\
 				 BIT(AQ_HW_LOOPBACK_PHYINT_SYS) |\
 				 BIT(AQ_HW_LOOPBACK_PHYEXT_SYS))
+#define AQ_HW_MEDIA_DETECT_MASK (BIT(AQ_HW_MEDIA_DETECT))
 
 #define ATL_HW_CHIP_MIPS         0x00000001U
 #define ATL_HW_CHIP_TPO2         0x00000002U
@@ -378,6 +380,8 @@ struct aq_fw_ops {
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
 			    u32 *supported_rates);
 
+	int (*set_media_detect)(struct aq_hw_s *self, bool enable);
+
 	u32 (*get_link_capabilities)(struct aq_hw_s *self);
 
 	int (*send_macsec_req)(struct aq_hw_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 43b8914c3ef5..f2f02908109e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -405,6 +405,7 @@ int aq_nic_init(struct aq_nic_s *self)
 	mutex_unlock(&self->fwreq_mutex);
 	if (err < 0)
 		goto err_exit;
+	aq_nic_set_media_detect(self);
 
 	err = self->aq_hw_ops->hw_init(self->aq_hw,
 				       aq_nic_get_ndev(self)->dev_addr);
@@ -1389,6 +1390,24 @@ void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 	}
 }
 
+int aq_nic_set_media_detect(struct aq_nic_s *self)
+{
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	int err = 0;
+
+	if (!self->aq_fw_ops->set_media_detect)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&self->fwreq_mutex);
+	err = self->aq_fw_ops->set_media_detect(self->aq_hw,
+						!!(cfg->priv_flags &
+						   AQ_HW_MEDIA_DETECT_MASK));
+
+	mutex_unlock(&self->fwreq_mutex);
+
+	return err;
+}
+
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 {
 	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 317bfc646f0a..b1e4a5b5284a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -193,6 +193,7 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 struct aq_nic_cfg_s *aq_nic_get_cfg(struct aq_nic_s *self);
 u32 aq_nic_get_fw_version(struct aq_nic_s *self);
 int aq_nic_set_loopback(struct aq_nic_s *self);
+int aq_nic_set_media_detect(struct aq_nic_s *self);
 int aq_nic_update_interrupt_moderation_settings(struct aq_nic_s *self);
 void aq_nic_shutdown(struct aq_nic_s *self);
 u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type type);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 013676cd38e4..360195b564cf 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -612,6 +612,26 @@ static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
 	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE2_ADDR);
 }
 
+static int aq_fw2x_set_media_detect(struct aq_hw_s *self, bool on)
+{
+	int err = 0;
+	u32 enable;
+	u32 offset;
+
+	if (self->fw_ver_actual < HW_ATL_FW_VER_MEDIA_CONTROL)
+		return -EOPNOTSUPP;
+
+	offset = offsetof(struct hw_atl_utils_settings, media_detect);
+	enable = on;
+
+	err = hw_atl_write_fwsettings_dwords(self, offset, &enable, 1);
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static u32 aq_fw2x_get_link_capabilities(struct aq_hw_s *self)
 {
 	int err = 0;
@@ -691,6 +711,7 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.enable_ptp         = aq_fw3x_enable_ptp,
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
+	.set_media_detect   = aq_fw2x_set_media_detect,
 	.adjust_ptp         = aq_fw3x_adjust_ptp,
 	.get_link_capabilities = aq_fw2x_get_link_capabilities,
 	.send_macsec_req    = aq_fw2x_send_macsec_req,
-- 
2.17.1

