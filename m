Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2C283B24
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgJEPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:39:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728368AbgJEPjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:39:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095FPhC7013662;
        Mon, 5 Oct 2020 08:39:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BVwlK55jrepybVubqP4+Znl97Eu6zzYDT/6TFb8phg0=;
 b=YesmX1ovDFboh3InY7pHKJNlp/6subPZBkWro5hOoOK2F8v4r97JzbpDe50fcJcACXAK
 u1ArVMm8kTjzg+NsoQjKYzMD9T0CLbNEPeAhsEv2JtHcxgsLu4nA5ROGIMKeb6ips6ZT
 Mum33t8DrCQ7HywQG3IhrT4eOXf7CPdUViA9J7ntXIUoLOUrKgFOx0K0txZwJw0YxU6z
 xdiwtPE7W/cB03KeF+ioCnLD5NcbYy5G+QyD3ZoA3ThCuGECeOsBuZ8oHnVXm9GvlAyp
 Iq6ALHeEZ+XrFyDHI3qvWOrmzsesFG7yoftdIJF7jmpsSy2bSKPLZoWFVv4n2FxebL6e /w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33xpnpng2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 08:39:48 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 08:39:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 08:39:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 08:39:47 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 7859D3F703F;
        Mon,  5 Oct 2020 08:39:45 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v3 net-next 2/3] net: atlantic: implement phy downshift feature
Date:   Mon, 5 Oct 2020 18:39:38 +0300
Message-ID: <20201005153939.248-3-irusskikh@marvell.com>
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

PHY downshift allows phy to try renegotiate if link is unstable
and can carry higher speed.

AQC devices has integrated PHY which is controlled by MAC firmware.
Thus, driver defines new ethtool callbacks to implement phy tunables
via netdev.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 41 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 23 +++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 22 ++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 13 ++++++
 6 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 1ab5314c4c1b..3f87cc6e2538 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -917,6 +917,45 @@ static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 	return ret;
 }
 
+static int aq_ethtool_get_phy_tunable(struct net_device *ndev,
+				      const struct ethtool_tunable *tuna, void *data)
+{
+	struct aq_nic_s *aq_nic = netdev_priv(ndev);
+
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT: {
+		u8 *val = data;
+
+		*val = (u8)aq_nic->aq_nic_cfg.downshift_counter;
+		break;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int aq_ethtool_set_phy_tunable(struct net_device *ndev,
+				      const struct ethtool_tunable *tuna, const void *data)
+{
+	int err = -EOPNOTSUPP;
+	struct aq_nic_s *aq_nic = netdev_priv(ndev);
+
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT: {
+		const u8 *val = data;
+
+		err = aq_nic_set_downshift(aq_nic, *val);
+		break;
+	}
+	default:
+		break;
+	}
+
+	return err;
+}
+
 const struct ethtool_ops aq_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -952,4 +991,6 @@ const struct ethtool_ops aq_ethtool_ops = {
 	.get_coalesce	     = aq_ethtool_get_coalesce,
 	.set_coalesce	     = aq_ethtool_set_coalesce,
 	.get_ts_info         = aq_ethtool_get_ts_info,
+	.get_phy_tunable     = aq_ethtool_get_phy_tunable,
+	.set_phy_tunable     = aq_ethtool_set_phy_tunable,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 7df74015fbc9..a17077b0dd49 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -386,6 +386,8 @@ struct aq_fw_ops {
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
 			    u32 *supported_rates);
 
+	int (*set_downshift)(struct aq_hw_s *self, u32 counter);
+
 	u32 (*get_link_capabilities)(struct aq_hw_s *self);
 
 	int (*send_macsec_req)(struct aq_hw_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index c6bdf1d677d1..088aa3c3d19c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -405,6 +405,8 @@ int aq_nic_init(struct aq_nic_s *self)
 	mutex_unlock(&self->fwreq_mutex);
 	if (err < 0)
 		goto err_exit;
+	/* Restore default settings */
+	aq_nic_set_downshift(self, self->aq_nic_cfg.downshift_counter);
 
 	err = self->aq_hw_ops->hw_init(self->aq_hw,
 				       aq_nic_get_ndev(self)->dev_addr);
@@ -1398,6 +1400,27 @@ void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 	}
 }
 
+int aq_nic_set_downshift(struct aq_nic_s *self, int val)
+{
+	int err = 0;
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+
+	if (!self->aq_fw_ops->set_downshift)
+		return -EOPNOTSUPP;
+
+	if (val > 15) {
+		netdev_err(self->ndev, "downshift counter should be <= 15\n");
+		return -EINVAL;
+	}
+	cfg->downshift_counter = val;
+
+	mutex_lock(&self->fwreq_mutex);
+	err = self->aq_fw_ops->set_downshift(self->aq_hw, cfg->downshift_counter);
+	mutex_unlock(&self->fwreq_mutex);
+
+	return err;
+}
+
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 {
 	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index eb7d8430f2f5..61e0e627e959 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -62,6 +62,7 @@ struct aq_nic_cfg_s {
 	bool is_lro;
 	bool is_qos;
 	bool is_ptp;
+	int downshift_counter;
 	enum aq_tc_mode tc_mode;
 	u32 priv_flags;
 	u8  tcs;
@@ -195,6 +196,7 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 struct aq_nic_cfg_s *aq_nic_get_cfg(struct aq_nic_s *self);
 u32 aq_nic_get_fw_version(struct aq_nic_s *self);
 int aq_nic_set_loopback(struct aq_nic_s *self);
+int aq_nic_set_downshift(struct aq_nic_s *self, int val);
 int aq_nic_update_interrupt_moderation_settings(struct aq_nic_s *self);
 void aq_nic_shutdown(struct aq_nic_s *self);
 u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type type);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 93c06dfa6c55..09500a95380b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -612,6 +612,27 @@ static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
 	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE2_ADDR);
 }
 
+static int aq_fw2x_set_downshift(struct aq_hw_s *self, u32 counter)
+{
+	int err = 0;
+	u32 mpi_opts;
+	u32 offset;
+
+	offset = offsetof(struct hw_atl_utils_settings, downshift_retry_count);
+	err = hw_atl_write_fwsettings_dwords(self, offset, &counter, 1);
+	if (err)
+		return err;
+
+	mpi_opts = aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
+	if (counter)
+		mpi_opts |= HW_ATL_FW2X_CTRL_DOWNSHIFT;
+	else
+		mpi_opts &= ~HW_ATL_FW2X_CTRL_DOWNSHIFT;
+	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
+
+	return err;
+}
+
 static u32 aq_fw2x_get_link_capabilities(struct aq_hw_s *self)
 {
 	int err = 0;
@@ -692,6 +713,7 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.enable_ptp         = aq_fw3x_enable_ptp,
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
+	.set_downshift      = aq_fw2x_set_downshift,
 	.adjust_ptp         = aq_fw3x_adjust_ptp,
 	.get_link_capabilities = aq_fw2x_get_link_capabilities,
 	.send_macsec_req    = aq_fw2x_send_macsec_req,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 85628acbcc1d..dd259c8f2f4f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -519,6 +519,18 @@ int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,
 	return 0;
 }
 
+static int aq_a2_fw_set_downshift(struct aq_hw_s *self, u32 counter)
+{
+	struct link_options_s link_options;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+	link_options.downshift = !!counter;
+	link_options.downshift_retry = counter;
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
 const struct aq_fw_ops aq_a2_fw_ops = {
 	.init               = aq_a2_fw_init,
 	.deinit             = aq_a2_fw_deinit,
@@ -536,4 +548,5 @@ const struct aq_fw_ops aq_a2_fw_ops = {
 	.set_flow_control   = aq_a2_fw_set_flow_control,
 	.get_flow_control   = aq_a2_fw_get_flow_control,
 	.set_phyloopback    = aq_a2_fw_set_phyloopback,
+	.set_downshift      = aq_a2_fw_set_downshift,
 };
-- 
2.17.1

