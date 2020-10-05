Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B5E283B34
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgJEPkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:40:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20152 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728715AbgJEPj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:39:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095FPRQS001171;
        Mon, 5 Oct 2020 08:39:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TtIAg48CO+4h8TMOegvzlwpEjOXSYSab8/B3FcTglLw=;
 b=R8asz6vfMwIAJ3rf6pLhfbJrsBQ8if8HvtT37Z/qG0RtwCwrQgnu3ybo/tesiLG7PX2s
 Z6xIq3PS3Cre5iDXX273CF49UyYpG75+TU/CnJ/ZTHNmONWsAhnb3ZqNIYqFkSrSC4bn
 oNbDDgjkolY/5zgcmC92TxvTHh5Gtx5LP81B3NMht5GwGowJGbVCvuknGXcBI0PnJHYT
 XUw+nvmfoQA3O4vU4ndfShOAdbnVuhUXb7uZmBzNzuViUs8nAv7YliplOeKLb1ylA7UE
 Uvp4iDCJR4iiEHtZ3nPwgl7sGLeijx8X06GV4YroU6XRByK9PwmNMBLwGLxTcFBmMAQi cA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtncwk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 08:39:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 08:39:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 08:39:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 08:39:49 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 961803F703F;
        Mon,  5 Oct 2020 08:39:47 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v3 net-next 3/3] net: atlantic: implement media detect feature via phy tunables
Date:   Mon, 5 Oct 2020 18:39:39 +0300
Message-ID: <20201005153939.248-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005153939.248-1-irusskikh@marvell.com>
References: <20201005153939.248-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_11:2020-10-05,2020-10-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mediadetect is another name for the EDPD (energy detect power down).
This feature allows device to save extra power when no link is available.

PHY goes into the extreme power saving mode and only periodically wakes up
and checks for the link.

AQC devices has fixed check period of 6 seconds

The feature may increase linkup time.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 12 +++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  4 +++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 27 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 ++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 15 +++++++++++
 5 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 3f87cc6e2538..de2a9348bc3f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -923,6 +923,12 @@ static int aq_ethtool_get_phy_tunable(struct net_device *ndev,
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
 	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD: {
+		u16 *val = data;
+
+		*val = aq_nic->aq_nic_cfg.is_media_detect ? AQ_HW_MEDIA_DETECT_CNT : 0;
+		break;
+	}
 	case ETHTOOL_PHY_DOWNSHIFT: {
 		u8 *val = data;
 
@@ -943,6 +949,12 @@ static int aq_ethtool_set_phy_tunable(struct net_device *ndev,
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
 	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD: {
+		const u16 *val = data;
+
+		err = aq_nic_set_media_detect(aq_nic, *val);
+		break;
+	}
 	case ETHTOOL_PHY_DOWNSHIFT: {
 		const u8 *val = data;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index a17077b0dd49..bed481816ea3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -143,6 +143,8 @@ struct aq_stats_s {
 #define AQ_HW_LED_BLINK    0x2U
 #define AQ_HW_LED_DEFAULT  0x0U
 
+#define AQ_HW_MEDIA_DETECT_CNT 6000
+
 enum aq_priv_flags {
 	AQ_HW_LOOPBACK_DMA_SYS,
 	AQ_HW_LOOPBACK_PKT_SYS,
@@ -388,6 +390,8 @@ struct aq_fw_ops {
 
 	int (*set_downshift)(struct aq_hw_s *self, u32 counter);
 
+	int (*set_media_detect)(struct aq_hw_s *self, bool enable);
+
 	u32 (*get_link_capabilities)(struct aq_hw_s *self);
 
 	int (*send_macsec_req)(struct aq_hw_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 088aa3c3d19c..0f865daeb36d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -407,6 +407,8 @@ int aq_nic_init(struct aq_nic_s *self)
 		goto err_exit;
 	/* Restore default settings */
 	aq_nic_set_downshift(self, self->aq_nic_cfg.downshift_counter);
+	aq_nic_set_media_detect(self, self->aq_nic_cfg.is_media_detect ?
+				AQ_HW_MEDIA_DETECT_CNT : 0);
 
 	err = self->aq_hw_ops->hw_init(self->aq_hw,
 				       aq_nic_get_ndev(self)->dev_addr);
@@ -1421,6 +1423,31 @@ int aq_nic_set_downshift(struct aq_nic_s *self, int val)
 	return err;
 }
 
+int aq_nic_set_media_detect(struct aq_nic_s *self, int val)
+{
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	int err = 0;
+
+	if (!self->aq_fw_ops->set_media_detect)
+		return -EOPNOTSUPP;
+
+	if (val > 0 && val != AQ_HW_MEDIA_DETECT_CNT) {
+		netdev_err(self->ndev, "EDPD on this device could have only fixed value of %d\n",
+			   AQ_HW_MEDIA_DETECT_CNT);
+		return -EINVAL;
+	}
+
+	mutex_lock(&self->fwreq_mutex);
+	err = self->aq_fw_ops->set_media_detect(self->aq_hw, !!val);
+	mutex_unlock(&self->fwreq_mutex);
+
+	/* msecs plays no role - configuration is always fixed in PHY */
+	if (!err)
+		cfg->is_media_detect = !!val;
+
+	return err;
+}
+
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 {
 	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 61e0e627e959..926cca9a0c83 100644
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
 int aq_nic_set_downshift(struct aq_nic_s *self, int val);
+int aq_nic_set_media_detect(struct aq_nic_s *self, int val);
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

