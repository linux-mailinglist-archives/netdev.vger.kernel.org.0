Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675761DB57F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgETNry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:47:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgETNrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:47:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDeVfw003293;
        Wed, 20 May 2020 06:47:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hDAsv1f3qt2jNcxjD+HyGIp6D7ejeCFBJULqLAYXnS4=;
 b=e36navZTQeLJqpxrOytUqpnZDKxQ2mJdDTGrOr46wqFB7nTIK4Ss3NdXFqiNxN/YVhyq
 X9pFPs9J/4CjqQYfAuSpICCTKMqhwwB3bfIU0vS31Xx3iawGMhM3IaVi43aV4wTJx7EA
 AwXkGh2s9IChX2msUISIqKyyYh7xcXiNfYOmlF10E56MR+F1Zq4WkopFmrkV2bJILICq
 yd5QxnnxukuT+84jUUgdR8MwGqOrEi52PBLc8NcTDcpdzKtCZvreY+W550UnvWt+ye6n
 cm/h1NAD5+96YKq647H2XthZLXvFdKIG0bu545cOT1VJVeZS15ptwpim8hEvZwREFqLG eQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs59y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:48 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 463D83F703F;
        Wed, 20 May 2020 06:47:46 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 04/12] net: atlantic: QoS implementation: multi-TC support
Date:   Wed, 20 May 2020 16:47:26 +0300
Message-ID: <20200520134734.2014-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dbezrukov@marvell.com>

This patch adds multi-TC support.

Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Co-developed-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Co-developed-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_filters.c   |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   1 +
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |  26 ++++
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |   2 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  39 +++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  58 ++++++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  14 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  19 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  74 ++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |   9 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 122 ++++++++++--------
 .../atlantic/hw_atl2/hw_atl2_internal.h       |   7 -
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |   8 ++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |   4 +
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   |  10 ++
 15 files changed, 290 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 03ff92bc4a7f..1bc4d33a0ce5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -153,6 +153,8 @@ aq_check_approve_fvlan(struct aq_nic_s *aq_nic,
 		       struct aq_hw_rx_fltrs_s *rx_fltrs,
 		       struct ethtool_rx_flow_spec *fsp)
 {
+	struct aq_nic_cfg_s *cfg = &aq_nic->aq_nic_cfg;
+
 	if (fsp->location < AQ_RX_FIRST_LOC_FVLANID ||
 	    fsp->location > AQ_RX_LAST_LOC_FVLANID) {
 		netdev_err(aq_nic->ndev,
@@ -170,10 +172,10 @@ aq_check_approve_fvlan(struct aq_nic_s *aq_nic,
 		return -EINVAL;
 	}
 
-	if (fsp->ring_cookie > aq_nic->aq_nic_cfg.num_rss_queues) {
+	if (fsp->ring_cookie > cfg->num_rss_queues * cfg->tcs) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: queue number must be in range [0, %d]",
-			   aq_nic->aq_nic_cfg.num_rss_queues - 1);
+			   cfg->num_rss_queues * cfg->tcs - 1);
 		return -EINVAL;
 	}
 	return 0;
@@ -262,6 +264,7 @@ static bool __must_check
 aq_rule_is_not_correct(struct aq_nic_s *aq_nic,
 		       struct ethtool_rx_flow_spec *fsp)
 {
+	struct aq_nic_cfg_s *cfg = &aq_nic->aq_nic_cfg;
 	bool rule_is_not_correct = false;
 
 	if (!aq_nic) {
@@ -274,11 +277,11 @@ aq_rule_is_not_correct(struct aq_nic_s *aq_nic,
 	} else if (aq_check_filter(aq_nic, fsp)) {
 		rule_is_not_correct = true;
 	} else if (fsp->ring_cookie != RX_CLS_FLOW_DISC) {
-		if (fsp->ring_cookie >= aq_nic->aq_nic_cfg.num_rss_queues) {
+		if (fsp->ring_cookie >= cfg->num_rss_queues * cfg->tcs) {
 			netdev_err(aq_nic->ndev,
 				   "ethtool: The specified action is invalid.\n"
 				   "Maximum allowable value action is %u.\n",
-				   aq_nic->aq_nic_cfg.num_rss_queues - 1);
+				   cfg->num_rss_queues * cfg->tcs - 1);
 			rule_is_not_correct = true;
 		}
 	}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index c3df9da6088c..1dccaaee04b3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -124,6 +124,7 @@ struct aq_stats_s {
 #define AQ_HW_TXD_MULTIPLE 8U
 #define AQ_HW_RXD_MULTIPLE 8U
 
+#define AQ_HW_QUEUES_MAX                32U
 #define AQ_HW_MULTICAST_ADDRESS_MAX     32U
 
 #define AQ_HW_PTP_TC                    2U
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index 7dbf49adcea6..342c5179f846 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -79,3 +79,29 @@ int aq_hw_err_from_flags(struct aq_hw_s *hw)
 err_exit:
 	return err;
 }
+
+int aq_hw_num_tcs(struct aq_hw_s *hw)
+{
+	switch (hw->aq_nic_cfg->tc_mode) {
+	case AQ_TC_MODE_8TCS:
+		return 8;
+	case AQ_TC_MODE_4TCS:
+		return 4;
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+int aq_hw_q_per_tc(struct aq_hw_s *hw)
+{
+	switch (hw->aq_nic_cfg->tc_mode) {
+	case AQ_TC_MODE_8TCS:
+		return 4;
+	case AQ_TC_MODE_4TCS:
+		return 8;
+	default:
+		return 4;
+	}
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
index 9ef82d487e01..32aa5f2fb840 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
@@ -34,5 +34,7 @@ u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg);
 void aq_hw_write_reg(struct aq_hw_s *hw, u32 reg, u32 value);
 u64 aq_hw_read_reg64(struct aq_hw_s *hw, u32 reg);
 int aq_hw_err_from_flags(struct aq_hw_s *hw);
+int aq_hw_num_tcs(struct aq_hw_s *hw);
+int aq_hw_q_per_tc(struct aq_hw_s *hw);
 
 #endif /* AQ_HW_UTILS_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 9fcab646cbd5..ef9e969fbf7a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -12,11 +12,13 @@
 #include "aq_ethtool.h"
 #include "aq_ptp.h"
 #include "aq_filters.h"
+#include "aq_hw_utils.h"
 
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
+#include <net/pkt_cls.h>
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(AQ_CFG_DRV_AUTHOR);
@@ -38,7 +40,7 @@ struct net_device *aq_ndev_alloc(void)
 	struct net_device *ndev = NULL;
 	struct aq_nic_s *aq_nic = NULL;
 
-	ndev = alloc_etherdev_mq(sizeof(struct aq_nic_s), AQ_CFG_VECS_MAX);
+	ndev = alloc_etherdev_mq(sizeof(struct aq_nic_s), AQ_HW_QUEUES_MAX);
 	if (!ndev)
 		return NULL;
 
@@ -330,6 +332,40 @@ static int aq_ndo_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto,
 	return 0;
 }
 
+static int aq_validate_mqprio_opt(struct aq_nic_s *self,
+				  const unsigned int num_tc)
+{
+	if (num_tc > aq_hw_num_tcs(self->aq_hw)) {
+		netdev_err(self->ndev, "Too many TCs requested\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (num_tc != 0 && !is_power_of_2(num_tc)) {
+		netdev_err(self->ndev, "TC count should be power of 2\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int aq_ndo_setup_tc(struct net_device *dev, enum tc_setup_type type,
+			   void *type_data)
+{
+	struct aq_nic_s *aq_nic = netdev_priv(dev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	int err;
+
+	if (type != TC_SETUP_QDISC_MQPRIO)
+		return -EOPNOTSUPP;
+
+	err = aq_validate_mqprio_opt(aq_nic, mqprio->num_tc);
+	if (err)
+		return err;
+
+	return aq_nic_setup_tc_mqprio(aq_nic, mqprio->num_tc,
+				      mqprio->prio_tc_map);
+}
+
 static const struct net_device_ops aq_ndev_ops = {
 	.ndo_open = aq_ndev_open,
 	.ndo_stop = aq_ndev_close,
@@ -341,6 +377,7 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_do_ioctl = aq_ndev_ioctl,
 	.ndo_vlan_rx_add_vid = aq_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = aq_ndo_vlan_rx_kill_vid,
+	.ndo_setup_tc = aq_ndo_setup_tc,
 };
 
 static int __init aq_ndev_init_module(void)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index caa971233f07..c7e3d39fad19 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -26,6 +26,7 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <net/ip.h>
+#include <net/pkt_cls.h>
 
 static unsigned int aq_itr = AQ_CFG_INTERRUPT_MODERATION_AUTO;
 module_param_named(aq_itr, aq_itr, uint, 0644);
@@ -72,6 +73,7 @@ static void aq_nic_rss_init(struct aq_nic_s *self, unsigned int num_rss_queues)
 void aq_nic_cfg_start(struct aq_nic_s *self)
 {
 	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	int i;
 
 	cfg->tcs = AQ_CFG_TCS_DEF;
 
@@ -146,6 +148,9 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 	cfg->is_vlan_rx_strip = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_RX);
 	cfg->is_vlan_tx_insert = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_TX);
 	cfg->is_vlan_force_promisc = true;
+
+	for (i = 0; i < sizeof(cfg->prio_tc_map); i++)
+		cfg->prio_tc_map[i] = cfg->tcs * i / 8;
 }
 
 static int aq_nic_update_link_status(struct aq_nic_s *self)
@@ -521,14 +526,21 @@ int aq_nic_start(struct aq_nic_s *self)
 			goto err_exit;
 	}
 
-	err = netif_set_real_num_tx_queues(self->ndev, self->aq_vecs);
+	err = netif_set_real_num_tx_queues(self->ndev,
+					   self->aq_vecs * cfg->tcs);
 	if (err < 0)
 		goto err_exit;
 
-	err = netif_set_real_num_rx_queues(self->ndev, self->aq_vecs);
+	err = netif_set_real_num_rx_queues(self->ndev,
+					   self->aq_vecs * cfg->tcs);
 	if (err < 0)
 		goto err_exit;
 
+	for (i = 0; i < cfg->tcs; i++) {
+		u16 offset = self->aq_vecs * i;
+
+		netdev_set_tc_queue(self->ndev, i, self->aq_vecs, offset);
+	}
 	netif_tx_start_all_queues(self->ndev);
 
 err_exit:
@@ -694,10 +706,10 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 {
 	unsigned int vec = skb->queue_mapping % self->aq_nic_cfg.vecs;
+	unsigned int tc = skb->queue_mapping / self->aq_nic_cfg.vecs;
 	struct aq_ring_s *ring = NULL;
 	unsigned int frags = 0U;
 	int err = NETDEV_TX_OK;
-	unsigned int tc = 0U;
 
 	frags = skb_shinfo(skb)->nr_frags + 1;
 
@@ -716,7 +728,8 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 	}
 
 	/* Above status update may stop the queue. Check this. */
-	if (__netif_subqueue_stopped(self->ndev, ring->idx)) {
+	if (__netif_subqueue_stopped(self->ndev,
+				     AQ_NIC_RING2QMAP(self, ring->idx))) {
 		err = NETDEV_TX_BUSY;
 		goto err_exit;
 	}
@@ -1270,3 +1283,40 @@ void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 		break;
 	}
 }
+
+int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
+{
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	bool ndev_running;
+	int err = 0;
+	int i;
+
+	/* if already the same configuration or
+	 * disable request (tcs is 0) and we already is disabled
+	 */
+	if (tcs == cfg->tcs || (tcs == 0 && !cfg->is_qos))
+		return 0;
+
+	ndev_running = netif_running(self->ndev);
+	if (ndev_running)
+		dev_close(self->ndev);
+
+	cfg->tcs = tcs;
+	if (cfg->tcs == 0)
+		cfg->tcs = 1;
+	if (prio_tc_map)
+		memcpy(cfg->prio_tc_map, prio_tc_map, sizeof(cfg->prio_tc_map));
+	else
+		for (i = 0; i < sizeof(cfg->prio_tc_map); i++)
+			cfg->prio_tc_map[i] = cfg->tcs * i / 8;
+
+	cfg->is_qos = (tcs != 0 ? true : false);
+	cfg->is_ptp = aq_enable_ptp && (cfg->tcs > AQ_HW_PTP_TC);
+
+	netdev_set_num_tc(self->ndev, cfg->tcs);
+
+	if (ndev_running)
+		err = dev_open(self->ndev, NULL);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 3434f8206823..29e129411945 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -59,10 +59,12 @@ struct aq_nic_cfg_s {
 	bool is_polling;
 	bool is_rss;
 	bool is_lro;
+	bool is_qos;
 	bool is_ptp;
 	enum aq_tc_mode tc_mode;
 	u32 priv_flags;
 	u8  tcs;
+	u8 prio_tc_map[8];
 	struct aq_rss_parameters aq_rss;
 	u32 eee_speeds;
 };
@@ -79,8 +81,15 @@ struct aq_nic_cfg_s {
 #define AQ_NIC_WOL_MODES        (WAKE_MAGIC |\
 				 WAKE_PHY)
 
+#define AQ_NIC_RING_PER_TC(_NIC_) \
+	(((_NIC_)->aq_nic_cfg.tc_mode == AQ_TC_MODE_4TCS) ? 8 : 4)
+
 #define AQ_NIC_TCVEC2RING(_NIC_, _TC_, _VEC_) \
-	((_TC_) * AQ_CFG_TCS_MAX + (_VEC_))
+	((_TC_) * AQ_NIC_RING_PER_TC(_NIC_) + (_VEC_))
+
+#define AQ_NIC_RING2QMAP(_NIC_, _ID_) \
+	((_ID_) / AQ_NIC_RING_PER_TC(_NIC_) * (_NIC_)->aq_vecs + \
+	((_ID_) % AQ_NIC_RING_PER_TC(_NIC_)))
 
 struct aq_hw_rx_fl2 {
 	struct aq_rx_filter_vlan aq_vlans[AQ_VLAN_MAX_FILTERS];
@@ -106,7 +115,7 @@ struct aq_nic_s {
 	atomic_t flags;
 	u32 msg_enable;
 	struct aq_vec_s *aq_vec[AQ_CFG_VECS_MAX];
-	struct aq_ring_s *aq_ring_tx[AQ_CFG_VECS_MAX * AQ_CFG_TCS_MAX];
+	struct aq_ring_s *aq_ring_tx[AQ_HW_QUEUES_MAX];
 	struct aq_hw_s *aq_hw;
 	struct net_device *ndev;
 	unsigned int aq_vecs;
@@ -183,4 +192,5 @@ void aq_nic_shutdown(struct aq_nic_s *self);
 u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type type);
 void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 			   u32 location);
+int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map);
 #endif /* AQ_NIC_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index bae95a618560..68fdb3994088 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -232,8 +232,11 @@ void aq_ring_queue_wake(struct aq_ring_s *ring)
 {
 	struct net_device *ndev = aq_nic_get_ndev(ring->aq_nic);
 
-	if (__netif_subqueue_stopped(ndev, ring->idx)) {
-		netif_wake_subqueue(ndev, ring->idx);
+	if (__netif_subqueue_stopped(ndev,
+				     AQ_NIC_RING2QMAP(ring->aq_nic,
+						      ring->idx))) {
+		netif_wake_subqueue(ndev,
+				    AQ_NIC_RING2QMAP(ring->aq_nic, ring->idx));
 		ring->stats.tx.queue_restarts++;
 	}
 }
@@ -242,8 +245,11 @@ void aq_ring_queue_stop(struct aq_ring_s *ring)
 {
 	struct net_device *ndev = aq_nic_get_ndev(ring->aq_nic);
 
-	if (!__netif_subqueue_stopped(ndev, ring->idx))
-		netif_stop_subqueue(ndev, ring->idx);
+	if (!__netif_subqueue_stopped(ndev,
+				      AQ_NIC_RING2QMAP(ring->aq_nic,
+						       ring->idx)))
+		netif_stop_subqueue(ndev,
+				    AQ_NIC_RING2QMAP(ring->aq_nic, ring->idx));
 }
 
 bool aq_ring_tx_clean(struct aq_ring_s *self)
@@ -466,7 +472,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			     buff->is_hash_l4 ? PKT_HASH_TYPE_L4 :
 			     PKT_HASH_TYPE_NONE);
 		/* Send all PTP traffic to 0 queue */
-		skb_record_rx_queue(skb, is_ptp_ring ? 0 : self->idx);
+		skb_record_rx_queue(skb,
+				    is_ptp_ring ? 0
+						: AQ_NIC_RING2QMAP(self->aq_nic,
+								   self->idx));
 
 		++self->stats.rx.packets;
 		self->stats.rx.bytes += skb->len;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 7caf586ea56c..775382440b47 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -46,7 +46,8 @@
 			NETIF_F_HW_VLAN_CTAG_RX |     \
 			NETIF_F_HW_VLAN_CTAG_TX |     \
 			NETIF_F_GSO_UDP_L4      |     \
-			NETIF_F_GSO_PARTIAL,          \
+			NETIF_F_GSO_PARTIAL |         \
+			NETIF_F_HW_TC,                \
 	.hw_priv_flags = IFF_UNICAST_FLT, \
 	.flow_control = true,		  \
 	.mtu = HW_ATL_B0_MTU_JUMBO,	  \
@@ -134,7 +135,7 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	u32 tx_buff_size = HW_ATL_B0_TXBUF_MAX;
 	u32 rx_buff_size = HW_ATL_B0_RXBUF_MAX;
-	unsigned int i_priority = 0U;
+	unsigned int prio = 0U;
 	u32 tc = 0U;
 
 	if (cfg->is_ptp) {
@@ -153,42 +154,45 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
-	/* TX Packet Scheduler Data TC0 */
-	hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, tc);
-	hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, tc);
-	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
-	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
-
-	/* Tx buf size TC0 */
-	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
-	hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self,
-						   (tx_buff_size *
-						   (1024 / 32U) * 66U) /
-						   100U, tc);
-	hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(self,
-						   (tx_buff_size *
-						   (1024 / 32U) * 50U) /
-						   100U, tc);
-
-	/* QoS Rx buf size per TC */
-	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
-	hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self,
-						   (rx_buff_size *
-						   (1024U / 32U) * 66U) /
-						   100U, tc);
-	hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self,
-						   (rx_buff_size *
-						   (1024U / 32U) * 50U) /
-						   100U, tc);
-
-	hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
+	tx_buff_size /= cfg->tcs;
+	rx_buff_size /= cfg->tcs;
+	for (tc = 0; tc < cfg->tcs; tc++) {
+		u32 threshold = 0U;
+
+		/* TX Packet Scheduler Data TC0 */
+		hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, tc);
+		hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, tc);
+		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
+		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
+
+		/* Tx buf size TC0 */
+		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
+
+		threshold = (tx_buff_size * (1024 / 32U) * 66U) / 100U;
+		hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+
+		threshold = (tx_buff_size * (1024 / 32U) * 50U) / 100U;
+		hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+
+		/* QoS Rx buf size per TC */
+		hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
+
+		threshold = (rx_buff_size * (1024U / 32U) * 66U) / 100U;
+		hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+
+		threshold = (rx_buff_size * (1024U / 32U) * 50U) / 100U;
+		hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+
+		hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
+	}
 
 	if (cfg->is_ptp)
 		hw_atl_b0_tc_ptp_set(self);
 
 	/* QoS 802.1p priority -> TC mapping */
-	for (i_priority = 8U; i_priority--;)
-		hw_atl_rpf_rpb_user_priority_tc_map_set(self, i_priority, 0U);
+	for (prio = 0; prio < 8; ++prio)
+		hw_atl_rpf_rpb_user_priority_tc_map_set(self, prio,
+							cfg->prio_tc_map[prio]);
 
 	return aq_hw_err_from_flags(self);
 }
@@ -319,7 +323,7 @@ int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 static int hw_atl_b0_hw_init_tx_path(struct aq_hw_s *self)
 {
 	/* Tx TC/Queue number config */
-	hw_atl_tpb_tps_tx_tc_mode_set(self, 1U);
+	hw_atl_tpb_tps_tx_tc_mode_set(self, self->aq_nic_cfg->tc_mode);
 
 	hw_atl_thm_lso_tcp_flag_of_first_pkt_set(self, 0x0FF6U);
 	hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(self, 0x0FF6U);
@@ -345,7 +349,7 @@ static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *self)
 	int i;
 
 	/* Rx TC/RSS number config */
-	hw_atl_rpb_rpf_rx_traf_class_mode_set(self, 1U);
+	hw_atl_rpb_rpf_rx_traf_class_mode_set(self, cfg->tc_mode);
 
 	/* Rx flow control */
 	hw_atl_rpb_rx_flow_ctl_mode_set(self, 1U);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 9e2d01a6aac8..8cb6765a1398 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -754,7 +754,7 @@ void hw_atl_rpfl2_accept_all_mc_packets_set(struct aq_hw_s *aq_hw,
 }
 
 void hw_atl_rpf_rpb_user_priority_tc_map_set(struct aq_hw_s *aq_hw,
-					     u32 user_priority_tc_map, u32 tc)
+					     u32 user_priority, u32 tc)
 {
 /* register address for bitfield rx_tc_up{t}[2:0] */
 	static u32 rpf_rpb_rx_tc_upt_adr[8] = {
@@ -773,10 +773,9 @@ void hw_atl_rpf_rpb_user_priority_tc_map_set(struct aq_hw_s *aq_hw,
 			0U, 4U, 8U, 12U, 16U, 20U, 24U, 28U
 		};
 
-	aq_hw_write_reg_bit(aq_hw, rpf_rpb_rx_tc_upt_adr[tc],
-			    rpf_rpb_rx_tc_upt_msk[tc],
-			    rpf_rpb_rx_tc_upt_shft[tc],
-			    user_priority_tc_map);
+	aq_hw_write_reg_bit(aq_hw, rpf_rpb_rx_tc_upt_adr[user_priority],
+			    rpf_rpb_rx_tc_upt_msk[user_priority],
+			    rpf_rpb_rx_tc_upt_shft[user_priority], tc);
 }
 
 void hw_atl_rpf_rss_key_addr_set(struct aq_hw_s *aq_hw, u32 rss_key_addr)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index a14118550882..05c049661b2e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -47,7 +47,8 @@ static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 			NETIF_F_HW_VLAN_CTAG_RX |     \
 			NETIF_F_HW_VLAN_CTAG_TX |     \
 			NETIF_F_GSO_UDP_L4      |     \
-			NETIF_F_GSO_PARTIAL,          \
+			NETIF_F_GSO_PARTIAL     |     \
+			NETIF_F_HW_TC,                \
 	.hw_priv_flags = IFF_UNICAST_FLT, \
 	.flow_control = true,		  \
 	.mtu = HW_ATL2_MTU_JUMBO,	  \
@@ -132,7 +133,6 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	u32 tx_buff_size = HW_ATL2_TXBUF_MAX;
 	u32 rx_buff_size = HW_ATL2_RXBUF_MAX;
 	unsigned int prio = 0U;
-	u32 threshold = 0U;
 	u32 tc = 0U;
 
 	/* TPS Descriptor rate init */
@@ -146,34 +146,41 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
-	/* TX Packet Scheduler Data TC0 */
-	hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF0, tc);
-	hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, 0x640, tc);
-	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
-	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
+	tx_buff_size /= cfg->tcs;
+	rx_buff_size /= cfg->tcs;
+	for (tc = 0; tc < cfg->tcs; tc++) {
+		u32 threshold = 0U;
 
-	/* Tx buf size TC0 */
-	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
+		/* TX Packet Scheduler Data TC0 */
+		hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF0,
+							       tc);
+		hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, 0x640, tc);
+		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
+		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
 
-	threshold = (tx_buff_size * (1024 / 32U) * 66U) / 100U;
-	hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+		/* Tx buf size TC0 */
+		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
 
-	threshold = (tx_buff_size * (1024 / 32U) * 50U) / 100U;
-	hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+		threshold = (tx_buff_size * (1024 / 32U) * 66U) / 100U;
+		hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self, threshold, tc);
 
-	/* QoS Rx buf size per TC */
-	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
+		threshold = (tx_buff_size * (1024 / 32U) * 50U) / 100U;
+		hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(self, threshold, tc);
 
-	threshold = (rx_buff_size * (1024U / 32U) * 66U) / 100U;
-	hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+		/* QoS Rx buf size per TC */
+		hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
 
-	threshold = (rx_buff_size * (1024U / 32U) * 50U) / 100U;
-	hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+		threshold = (rx_buff_size * (1024U / 32U) * 66U) / 100U;
+		hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self, threshold, tc);
+
+		threshold = (rx_buff_size * (1024U / 32U) * 50U) / 100U;
+		hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+	}
 
 	/* QoS 802.1p priority -> TC mapping */
 	for (prio = 0; prio < 8; ++prio)
 		hw_atl_rpf_rpb_user_priority_tc_map_set(self, prio,
-							cfg->tcs * prio / 8);
+							cfg->prio_tc_map[prio]);
 
 	/* ATL2 Apply legacy ring to TC mapping */
 	hw_atl2_hw_queue_to_tc_map_set(self);
@@ -184,11 +191,24 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 			      struct aq_rss_parameters *rss_params)
 {
-	u8 *indirection_table =	rss_params->indirection_table;
+	u8 *indirection_table = rss_params->indirection_table;
+	const u32 num_tcs = aq_hw_num_tcs(self);
+	u32 rpf_redir2_enable;
+	int tc;
 	int i;
 
-	for (i = HW_ATL2_RSS_REDIRECTION_MAX; i--;)
-		hw_atl2_new_rpf_rss_redir_set(self, 0, i, indirection_table[i]);
+	rpf_redir2_enable = num_tcs > 4 ? 1 : 0;
+
+	hw_atl2_rpf_redirection_table2_select_set(self, rpf_redir2_enable);
+
+	for (i = HW_ATL2_RSS_REDIRECTION_MAX; i--;) {
+		for (tc = 0; tc != num_tcs; tc++) {
+			hw_atl2_new_rpf_rss_redir_set(self, tc, i,
+						      tc *
+						      aq_hw_q_per_tc(self) +
+						      indirection_table[i]);
+		}
+	}
 
 	return aq_hw_err_from_flags(self);
 }
@@ -196,7 +216,7 @@ static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
 {
 	/* Tx TC/RSS number config */
-	hw_atl_tpb_tps_tx_tc_mode_set(self, 1U);
+	hw_atl_tpb_tps_tx_tc_mode_set(self, self->aq_nic_cfg->tc_mode);
 
 	hw_atl_thm_lso_tcp_flag_of_first_pkt_set(self, 0x0FF6U);
 	hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(self, 0x0FF6U);
@@ -219,13 +239,29 @@ static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
 static void hw_atl2_hw_init_new_rx_filters(struct aq_hw_s *self)
 {
 	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	u8 *prio_tc_map = self->aq_nic_cfg->prio_tc_map;
+	u16 action;
 	u8 index;
+	int i;
 
+	/* Action Resolver Table (ART) is used by RPF to decide which action
+	 * to take with a packet based upon input tag and tag mask, where:
+	 *  - input tag is a combination of 3-bit VLan Prio (PTP) and
+	 *    29-bit concatenation of all tags from filter block;
+	 *  - tag mask is a mask used for matching against input tag.
+	 * The input_tag is compared with the all the Requested_tags in the
+	 * Record table to find a match. Action field of the selected matched
+	 * REC entry is used for further processing. If multiple entries match,
+	 * the lowest REC entry, Action field will be selected.
+	 */
 	hw_atl2_rpf_act_rslvr_section_en_set(self, 0xFFFF);
 	hw_atl2_rpfl2_uc_flr_tag_set(self, HW_ATL2_RPF_TAG_BASE_UC,
 				     HW_ATL2_MAC_UC);
 	hw_atl2_rpfl2_bc_flr_tag_set(self, HW_ATL2_RPF_TAG_BASE_UC);
 
+	/* FW reserves the beginning of ART, thus all driver entries must
+	 * start from the offset specified in FW caps.
+	 */
 	index = priv->art_base_index + HW_ATL2_RPF_L2_PROMISC_OFF_INDEX;
 	hw_atl2_act_rslvr_table_set(self, index, 0,
 				    HW_ATL2_RPF_TAG_UC_MASK |
@@ -238,33 +274,17 @@ static void hw_atl2_hw_init_new_rx_filters(struct aq_hw_s *self)
 					HW_ATL2_RPF_TAG_UNTAG_MASK,
 				    HW_ATL2_ACTION_DROP);
 
-	index = priv->art_base_index + HW_ATL2_RPF_VLAN_INDEX;
-	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_BASE_VLAN,
-				    HW_ATL2_RPF_TAG_VLAN_MASK,
-				    HW_ATL2_ACTION_ASSIGN_TC(0));
+	/* Configure ART to map given VLan Prio (PCP) to the TC index for
+	 * RSS redirection table.
+	 */
+	for (i = 0; i < 8; i++) {
+		action = HW_ATL2_ACTION_ASSIGN_TC(prio_tc_map[i]);
 
-	index = priv->art_base_index + HW_ATL2_RPF_MAC_INDEX;
-	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_BASE_UC,
-				    HW_ATL2_RPF_TAG_UC_MASK,
-				    HW_ATL2_ACTION_ASSIGN_TC(0));
-
-	index = priv->art_base_index + HW_ATL2_RPF_ALLMC_INDEX;
-	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_BASE_ALLMC,
-				    HW_ATL2_RPF_TAG_ALLMC_MASK,
-				    HW_ATL2_ACTION_ASSIGN_TC(0));
-
-	index = priv->art_base_index + HW_ATL2_RPF_UNTAG_INDEX;
-	hw_atl2_act_rslvr_table_set(self, index, HW_ATL2_RPF_TAG_UNTAG_MASK,
-				    HW_ATL2_RPF_TAG_UNTAG_MASK,
-				    HW_ATL2_ACTION_ASSIGN_TC(0));
-
-	index = priv->art_base_index + HW_ATL2_RPF_VLAN_PROMISC_ON_INDEX;
-	hw_atl2_act_rslvr_table_set(self, index, 0, HW_ATL2_RPF_TAG_VLAN_MASK,
-				    HW_ATL2_ACTION_DISABLE);
-
-	index = priv->art_base_index + HW_ATL2_RPF_L2_PROMISC_ON_INDEX;
-	hw_atl2_act_rslvr_table_set(self, index, 0, HW_ATL2_RPF_TAG_UC_MASK,
-				    HW_ATL2_ACTION_DISABLE);
+		index = priv->art_base_index + HW_ATL2_RPF_PCP_TO_TC_INDEX + i;
+		hw_atl2_act_rslvr_table_set(self, index,
+					    i << HW_ATL2_RPF_TAG_PCP_OFFSET,
+					    HW_ATL2_RPF_TAG_PCP_MASK, action);
+	}
 }
 
 static void hw_atl2_hw_new_rx_filter_vlan_promisc(struct aq_hw_s *self,
@@ -327,7 +347,7 @@ static int hw_atl2_hw_init_rx_path(struct aq_hw_s *self)
 	int i;
 
 	/* Rx TC/RSS number config */
-	hw_atl_rpb_rpf_rx_traf_class_mode_set(self, 1U);
+	hw_atl_rpb_rpf_rx_traf_class_mode_set(self, cfg->tc_mode);
 
 	/* Rx flow control */
 	hw_atl_rpb_rx_flow_ctl_mode_set(self, 1U);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index be0c049ea582..9ac1979a4867 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -82,13 +82,6 @@ enum HW_ATL2_RPF_ART_INDEX {
 	HW_ATL2_RPF_VLAN_USER_INDEX	= HW_ATL2_RPF_ET_PCP_USER_INDEX + 16,
 	HW_ATL2_RPF_PCP_TO_TC_INDEX	= HW_ATL2_RPF_VLAN_USER_INDEX +
 					  HW_ATL_VLAN_MAX_FILTERS,
-	HW_ATL2_RPF_VLAN_INDEX		= HW_ATL2_RPF_PCP_TO_TC_INDEX +
-					  AQ_CFG_TCS_MAX,
-	HW_ATL2_RPF_MAC_INDEX,
-	HW_ATL2_RPF_ALLMC_INDEX,
-	HW_ATL2_RPF_UNTAG_INDEX,
-	HW_ATL2_RPF_VLAN_PROMISC_ON_INDEX,
-	HW_ATL2_RPF_L2_PROMISC_ON_INDEX,
 };
 
 #define HW_ATL2_ACTION(ACTION, RSS, INDEX, VALID) \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index e779d70fde66..f096d0a6bda9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -7,6 +7,14 @@
 #include "hw_atl2_llh_internal.h"
 #include "aq_hw_utils.h"
 
+void hw_atl2_rpf_redirection_table2_select_set(struct aq_hw_s *aq_hw,
+					       u32 select)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_ADR,
+			    HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_MSK,
+			    HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_SHIFT, select);
+}
+
 void hw_atl2_rpf_rss_hash_type_set(struct aq_hw_s *aq_hw, u32 rss_hash_type)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_ADR,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index 8c6d78a64d42..5c1ae755ffae 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -15,6 +15,10 @@ void hw_atl2_reg_tx_intr_moder_ctrl_set(struct aq_hw_s *aq_hw,
 					u32 tx_intr_moderation_ctl,
 					u32 queue);
 
+/* Set Redirection Table 2 Select */
+void hw_atl2_rpf_redirection_table2_select_set(struct aq_hw_s *aq_hw,
+					       u32 select);
+
 /** Set RSS HASH type */
 void hw_atl2_rpf_rss_hash_type_set(struct aq_hw_s *aq_hw, u32 rss_hash_type);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
index cde9e9d2836d..b0ac8cd581d7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -6,6 +6,16 @@
 #ifndef HW_ATL2_LLH_INTERNAL_H
 #define HW_ATL2_LLH_INTERNAL_H
 
+/* RX pif_rpf_redir_2_en_i Bitfield Definitions
+ * PORT="pif_rpf_redir_2_en_i"
+ */
+#define HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_ADR 0x000054C8
+#define HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_MSK 0x00001000
+#define HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_MSKN 0xFFFFEFFF
+#define HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_SHIFT 12
+#define HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_WIDTH 1
+#define HW_ATL2_RPF_PIF_RPF_REDIR2_ENI_DEFAULT 0x0
+
 /* RX pif_rpf_rss_hash_type_i Bitfield Definitions
  */
 #define HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_ADR 0x000054C8
-- 
2.25.1

