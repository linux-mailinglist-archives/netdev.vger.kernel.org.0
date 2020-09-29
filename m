Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6142B27D368
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgI2QN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:13:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35434 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730020AbgI2QN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 12:13:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG4cI7003369;
        Tue, 29 Sep 2020 09:13:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ni6lwNnmojn80up9aYD3udwHwy3EYVycX15OAnVc+oY=;
 b=dTG9gksU72l93vDlaYCDFZ2m+n40hix7MBz2E0JRR7PgdXP5tVfX8ZbclZalJ5B9hJ3r
 XEv6nSEblh6mrCekYpG2EhIzm3+SReAYuiCCgMTHk4E4jobLW/lVNIdfeJdCUr0d7O2t
 ng5yMa2LH4KIytLrnzizUYD/L0C0XnatO9Q/iZpx8FLA/aR4/KR1Arfm6C8H27Km96dq
 qnZ75WRVxlAmVck5b4UTBgBPZzJHp7IvbEMppQvoi51rVHpDxWIixV9454mgFAgjRd34
 3ImhRjGCQesRCY2cv5OUruUKR5zKGqQcdseY6bHPhxckEJrF59QAlo0RM5wvPL1QC6Gf fw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemcraa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:13:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 09:13:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 09:13:22 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 575133F7040;
        Tue, 29 Sep 2020 09:13:20 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 3/3] net: atlantic: implement media detect feature via phy tunables
Date:   Tue, 29 Sep 2020 19:13:07 +0300
Message-ID: <20200929161307.542-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929161307.542-1-irusskikh@marvell.com>
References: <20200929161307.542-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_10:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mediadetect is another name for the EDPD (energy detect power down).
This feature allows device to save extra power when no link is available.

PHY goes into the extreme power saving mode and only periodically wakes up
and checks for the link.

The feature may increase linkup time.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c  | 14 ++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h   |  2 ++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 16 ++++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h  |  2 ++
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c | 15 +++++++++++++++
 5 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 1a6732e6bf54..7c38f3ab073a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -923,6 +923,12 @@ static int aq_ethtool_get_phy_tunable(struct net_device *ndev,
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
 	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD: {
+		u16 *val = data;
+
+		*val = (u16)aq_nic->aq_nic_cfg.is_media_detect;
+		break;
+	}
 	case ETHTOOL_PHY_DOWNSHIFT: {
 		u8 *val = data;
 
@@ -943,6 +949,14 @@ static int aq_ethtool_set_phy_tunable(struct net_device *ndev,
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
 	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD: {
+		const u16 *val = data;
+
+		/* msecs plays no role - configuration is always fixed in PHY */
+		aq_nic->aq_nic_cfg.is_media_detect = *val ? 1 : 0;
+		err = aq_nic_set_media_detect(aq_nic);
+		break;
+	}
 	case ETHTOOL_PHY_DOWNSHIFT: {
 		const u8 *val = data;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index a17077b0dd49..77a01cf2530e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -388,6 +388,8 @@ struct aq_fw_ops {
 
 	int (*set_downshift)(struct aq_hw_s *self, u32 counter);
 
+	int (*set_media_detect)(struct aq_hw_s *self, bool enable);
+
 	u32 (*get_link_capabilities)(struct aq_hw_s *self);
 
 	int (*send_macsec_req)(struct aq_hw_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index f02d193cf609..a0e858c14769 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -405,6 +405,7 @@ int aq_nic_init(struct aq_nic_s *self)
 	mutex_unlock(&self->fwreq_mutex);
 	if (err < 0)
 		goto err_exit;
+	aq_nic_set_media_detect(self);
 	aq_nic_set_downshift(self);
 
 	err = self->aq_hw_ops->hw_init(self->aq_hw,
@@ -1422,6 +1423,21 @@ int aq_nic_set_downshift(struct aq_nic_s *self)
 	return err;
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
+	err = self->aq_fw_ops->set_media_detect(self->aq_hw, cfg->is_media_detect);
+	mutex_unlock(&self->fwreq_mutex);
+
+	return err;
+}
+
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 {
 	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 0ab29890cb4c..9414a164bdcc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -62,6 +62,7 @@ struct aq_nic_cfg_s {
 	bool is_lro;
 	bool is_qos;
 	bool is_ptp;
+	bool is_media_detect;
 	int downshift_counter;
 	enum aq_tc_mode tc_mode;
 	u32 priv_flags;
@@ -197,6 +198,7 @@ struct aq_nic_cfg_s *aq_nic_get_cfg(struct aq_nic_s *self);
 u32 aq_nic_get_fw_version(struct aq_nic_s *self);
 int aq_nic_set_loopback(struct aq_nic_s *self);
 int aq_nic_set_downshift(struct aq_nic_s *self);
+int aq_nic_set_media_detect(struct aq_nic_s *self);
 int aq_nic_update_interrupt_moderation_settings(struct aq_nic_s *self);
 void aq_nic_shutdown(struct aq_nic_s *self);
 u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type type);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 09500a95380b..ee0c22d04935 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -633,6 +633,20 @@ static int aq_fw2x_set_downshift(struct aq_hw_s *self, u32 counter)
 	return err;
 }
 
+static int aq_fw2x_set_media_detect(struct aq_hw_s *self, bool on)
+{
+	u32 enable;
+	u32 offset;
+
+	if (self->fw_ver_actual < HW_ATL_FW_VER_MEDIA_CONTROL)
+		return -EOPNOTSUPP;
+
+	offset = offsetof(struct hw_atl_utils_settings, media_detect);
+	enable = on;
+
+	return hw_atl_write_fwsettings_dwords(self, offset, &enable, 1);
+}
+
 static u32 aq_fw2x_get_link_capabilities(struct aq_hw_s *self)
 {
 	int err = 0;
@@ -714,6 +728,7 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
 	.set_downshift      = aq_fw2x_set_downshift,
+	.set_media_detect   = aq_fw2x_set_media_detect,
 	.adjust_ptp         = aq_fw3x_adjust_ptp,
 	.get_link_capabilities = aq_fw2x_get_link_capabilities,
 	.send_macsec_req    = aq_fw2x_send_macsec_req,
-- 
2.17.1

