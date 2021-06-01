Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFB39728C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhFALjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:39:20 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3321 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhFALjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:39:15 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvVQ835v2z1BGcs;
        Tue,  1 Jun 2021 19:32:48 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 19:37:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 19:37:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/2] net: hns3: add support for PTP
Date:   Tue, 1 Jun 2021 19:34:24 +0800
Message-ID: <1622547265-48051-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622547265-48051-1-git-send-email-huangguangbin2@huawei.com>
References: <1622547265-48051-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

Adds PTP support for HNS3 ethernet driver.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/Kconfig             |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  12 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  27 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  12 +
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  57 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   6 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 520 +++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h | 133 ++++++
 11 files changed, 777 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index fa6025dc4cdb..bb062b02fb85 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -102,6 +102,7 @@ config HNS3_HCLGE
 	tristate "Hisilicon HNS3 HCLGE Acceleration Engine & Compatibility Layer Support"
 	default m
 	depends on PCI_MSI
+	imply PTP_1588_CLOCK
 	help
 	  This selects the HNS3_HCLGE network acceleration engine & its hardware
 	  compatibility layer. The engine would be used in Hisilicon hip08 family of
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 89b2b7fa7b8b..545dcbc7af49 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -522,6 +522,12 @@ struct hnae3_ae_dev {
  *   Check if any cls flower rule exist
  * dbg_read_cmd
  *   Execute debugfs read command.
+ * set_tx_hwts_info
+ *   Save information for 1588 tx packet
+ * get_rx_hwts
+ *   Get 1588 rx hwstamp
+ * get_ts_info
+ *   Get phc info
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -707,6 +713,12 @@ struct hnae3_ae_ops {
 				      struct ethtool_link_ksettings *cmd);
 	int (*set_phy_link_ksettings)(struct hnae3_handle *handle,
 				      const struct ethtool_link_ksettings *cmd);
+	bool (*set_tx_hwts_info)(struct hnae3_handle *handle,
+				 struct sk_buff *skb);
+	void (*get_rx_hwts)(struct hnae3_handle *handle, struct sk_buff *skb,
+			    u32 nsec, u32 sec);
+	int (*get_ts_info)(struct hnae3_handle *handle,
+			   struct ethtool_ts_info *info);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 393979bec170..9a45f3cde6a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1799,6 +1799,18 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 	WRITE_ONCE(ring->last_to_use, ring->next_to_use);
 }
 
+static void hns3_tsyn(struct net_device *netdev, struct sk_buff *skb,
+		      struct hns3_desc *desc)
+{
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+
+	if (!(h->ae_algo->ops->set_tx_hwts_info &&
+	      h->ae_algo->ops->set_tx_hwts_info(h, skb)))
+		return;
+
+	desc->tx.bdtp_fe_sc_vld_ra_ri |= cpu_to_le16(BIT(HNS3_TXD_TSYN_B));
+}
+
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -1851,10 +1863,16 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	pre_ntu = ring->next_to_use ? (ring->next_to_use - 1) :
 					(ring->desc_num - 1);
+
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		hns3_tsyn(netdev, skb, &ring->desc[pre_ntu]);
+
 	ring->desc[pre_ntu].tx.bdtp_fe_sc_vld_ra_ri |=
 				cpu_to_le16(BIT(HNS3_TXD_FE_B));
 	trace_hns3_tx_desc(ring, pre_ntu);
 
+	skb_tx_timestamp(skb);
+
 	/* Complete translate all packets */
 	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
 	doorbell = __netdev_tx_sent_queue(dev_queue, desc_cb->send_bytes,
@@ -3585,6 +3603,15 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	ol_info = le32_to_cpu(desc->rx.ol_info);
 	csum = le16_to_cpu(desc->csum);
 
+	if (unlikely(bd_base_info & BIT(HNS3_RXD_TS_VLD_B))) {
+		struct hnae3_handle *h = hns3_get_handle(netdev);
+		u32 nsec = le32_to_cpu(desc->ts_nsec);
+		u32 sec = le32_to_cpu(desc->ts_sec);
+
+		if (h->ae_algo->ops->get_rx_hwts)
+			h->ae_algo->ops->get_rx_hwts(h, skb, nsec, sec);
+	}
+
 	/* Based on hw strategy, the tag offloaded will be stored at
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
 	 * in one layer tag case.
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 5698a14a804e..79821c7bdc16 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -122,8 +122,9 @@ enum hns3_nic_state {
 #define HNS3_RXD_LUM_B				9
 #define HNS3_RXD_CRCP_B				10
 #define HNS3_RXD_L3L4P_B			11
-#define HNS3_RXD_TSIND_S			12
-#define HNS3_RXD_TSIND_M			(0x7 << HNS3_RXD_TSIND_S)
+#define HNS3_RXD_TSIDX_S			12
+#define HNS3_RXD_TSIDX_M			(0x3 << HNS3_RXD_TSIDX_S)
+#define HNS3_RXD_TS_VLD_B			14
 #define HNS3_RXD_LKBK_B				15
 #define HNS3_RXD_GRO_SIZE_S			16
 #define HNS3_RXD_GRO_SIZE_M			(0x3fff << HNS3_RXD_GRO_SIZE_S)
@@ -240,6 +241,10 @@ struct __packed hns3_desc {
 	union {
 		__le64 addr;
 		__le16 csum;
+		struct {
+			__le32 ts_nsec;
+			__le32 ts_sec;
+		};
 	};
 	union {
 		struct {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index bb7c2ec7ed6f..acef5435d7b7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1598,6 +1598,17 @@ static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
 				 ETHTOOL_COALESCE_TX_USECS_HIGH |	\
 				 ETHTOOL_COALESCE_MAX_FRAMES)
 
+static int hns3_get_ts_info(struct net_device *netdev,
+			    struct ethtool_ts_info *info)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	if (handle->ae_algo->ops->get_ts_info)
+		return handle->ae_algo->ops->get_ts_info(handle, info);
+
+	return ethtool_op_get_ts_info(netdev, info);
+}
+
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.get_drvinfo = hns3_get_drvinfo,
@@ -1662,6 +1673,7 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.get_module_eeprom = hns3_get_module_eeprom,
 	.get_priv_flags = hns3_get_priv_flags,
 	.set_priv_flags = hns3_set_priv_flags,
+	.get_ts_info = hns3_get_ts_info,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
index 6c28c8f6292c..a685392dbfe9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
@@ -7,6 +7,6 @@ ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
 ccflags-y += -I $(srctree)/$(src)
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
-hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o
+hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o hclge_ptp.o
 
 hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index da78a6477e46..0f7346e7b13a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -130,6 +130,10 @@ enum hclge_opcode_type {
 	HCLGE_OPC_COMMON_LOOPBACK       = 0x0315,
 	HCLGE_OPC_CONFIG_FEC_MODE	= 0x031A,
 
+	/* PTP commands */
+	HCLGE_OPC_PTP_INT_EN		= 0x0501,
+	HCLGE_OPC_PTP_MODE_CFG		= 0x0507,
+
 	/* PFC/Pause commands */
 	HCLGE_OPC_CFG_MAC_PAUSE_EN      = 0x0701,
 	HCLGE_OPC_CFG_PFC_PAUSE_EN      = 0x0702,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6ecc106af334..8ee7cdc5a77d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3337,6 +3337,12 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 		return HCLGE_VECTOR0_EVENT_ERR;
 	}
 
+	/* check for vector0 ptp event source */
+	if (BIT(HCLGE_VECTOR0_REG_PTP_INT_B) & msix_src_reg) {
+		*clearval = msix_src_reg;
+		return HCLGE_VECTOR0_EVENT_PTP;
+	}
+
 	/* check for vector0 mailbox(=CMDQ RX) event source */
 	if (BIT(HCLGE_VECTOR0_RX_CMDQ_INT_B) & cmdq_src_reg) {
 		cmdq_src_reg &= ~BIT(HCLGE_VECTOR0_RX_CMDQ_INT_B);
@@ -3357,6 +3363,7 @@ static void hclge_clear_event_cause(struct hclge_dev *hdev, u32 event_type,
 				    u32 regclr)
 {
 	switch (event_type) {
+	case HCLGE_VECTOR0_EVENT_PTP:
 	case HCLGE_VECTOR0_EVENT_RST:
 		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, regclr);
 		break;
@@ -3409,6 +3416,9 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	case HCLGE_VECTOR0_EVENT_RST:
 		hclge_reset_task_schedule(hdev);
 		break;
+	case HCLGE_VECTOR0_EVENT_PTP:
+		hclge_ptp_clean_tx_hwts(hdev);
+		break;
 	case HCLGE_VECTOR0_EVENT_MBX:
 		/* If we are here then,
 		 * 1. Either we are not handling any mbx task and we are not
@@ -3434,7 +3444,7 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	 * cleared by hardware before driver reads status register.
 	 * For this case, vector0 interrupt also should be enabled.
 	 */
-	if (!clearval ||
+	if (!clearval || event_cause == HCLGE_VECTOR0_EVENT_PTP ||
 	    event_cause == HCLGE_VECTOR0_EVENT_MBX) {
 		hclge_enable_vector(&hdev->misc_vector, true);
 	}
@@ -4342,12 +4352,34 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
 	hclge_task_schedule(hdev, delta);
 }
 
+static void hclge_ptp_service_task(struct hclge_dev *hdev)
+{
+	if (!test_bit(HCLGE_STATE_PTP_EN, &hdev->state) ||
+	    !test_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state) ||
+	    !time_is_before_jiffies(hdev->ptp->tx_start + HZ))
+		return;
+
+	/* to prevent concurrence with the irq handler, disable vector0
+	 * before handling ptp service task.
+	 */
+	disable_irq(hdev->misc_vector.vector_irq);
+
+	/* check HCLGE_STATE_PTP_TX_HANDLING here again, since the irq
+	 * handler may handle it just before disable_irq().
+	 */
+	if (test_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state))
+		hclge_ptp_clean_tx_hwts(hdev);
+
+	enable_irq(hdev->misc_vector.vector_irq);
+}
+
 static void hclge_service_task(struct work_struct *work)
 {
 	struct hclge_dev *hdev =
 		container_of(work, struct hclge_dev, service_task.work);
 
 	hclge_reset_service_task(hdev);
+	hclge_ptp_service_task(hdev);
 	hclge_mailbox_service_task(hdev);
 	hclge_periodic_service_task(hdev);
 
@@ -9383,8 +9415,15 @@ static int hclge_do_ioctl(struct hnae3_handle *handle, struct ifreq *ifr,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (!hdev->hw.mac.phydev)
-		return hclge_mii_ioctl(hdev, ifr, cmd);
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+		return hclge_ptp_get_cfg(hdev, ifr);
+	case SIOCSHWTSTAMP:
+		return hclge_ptp_set_cfg(hdev, ifr);
+	default:
+		if (!hdev->hw.mac.phydev)
+			return hclge_mii_ioctl(hdev, ifr, cmd);
+	}
 
 	return phy_mii_ioctl(hdev->hw.mac.phydev, ifr, cmd);
 }
@@ -11500,6 +11539,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_mdiobus_unreg;
 	}
 
+	ret = hclge_ptp_init(hdev);
+	if (ret)
+		goto err_mdiobus_unreg;
+
 	INIT_KFIFO(hdev->mac_tnl_log);
 
 	hclge_dcb_ops_set(hdev);
@@ -11868,6 +11911,10 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	ret = hclge_ptp_init(hdev);
+	if (ret)
+		return ret;
+
 	/* Log and clear the hw errors those already occurred */
 	hclge_handle_all_hns_hw_errors(ae_dev);
 
@@ -11918,6 +11965,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_clear_vf_vlan(hdev);
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
+	hclge_ptp_uninit(hdev);
 	hclge_uninit_rxd_adv_layout(hdev);
 	hclge_uninit_mac_table(hdev);
 	hclge_del_all_fd_entries(hdev);
@@ -12814,6 +12862,9 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.cls_flower_active = hclge_is_cls_flower_active,
 	.get_phy_link_ksettings = hclge_get_phy_link_ksettings,
 	.set_phy_link_ksettings = hclge_set_phy_link_ksettings,
+	.set_tx_hwts_info = hclge_ptp_set_tx_info,
+	.get_rx_hwts = hclge_ptp_get_rx_hwts,
+	.get_ts_info = hclge_ptp_get_ts_info,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 7595f841aaac..d331a93996b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -10,6 +10,7 @@
 #include <linux/kfifo.h>
 
 #include "hclge_cmd.h"
+#include "hclge_ptp.h"
 #include "hnae3.h"
 
 #define HCLGE_MOD_VERSION "1.0"
@@ -178,6 +179,7 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_FUN_RST_ING_B		0
 
 /* Vector0 register bits define */
+#define HCLGE_VECTOR0_REG_PTP_INT_B	0
 #define HCLGE_VECTOR0_GLOBALRESET_INT_B	5
 #define HCLGE_VECTOR0_CORERESET_INT_B	6
 #define HCLGE_VECTOR0_IMPRESET_INT_B	7
@@ -228,6 +230,8 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_FD_TBL_CHANGED,
 	HCLGE_STATE_FD_CLEAR_ALL,
 	HCLGE_STATE_FD_USER_DEF_CHANGED,
+	HCLGE_STATE_PTP_EN,
+	HCLGE_STATE_PTP_TX_HANDLING,
 	HCLGE_STATE_MAX
 };
 
@@ -235,6 +239,7 @@ enum hclge_evt_cause {
 	HCLGE_VECTOR0_EVENT_RST,
 	HCLGE_VECTOR0_EVENT_MBX,
 	HCLGE_VECTOR0_EVENT_ERR,
+	HCLGE_VECTOR0_EVENT_PTP,
 	HCLGE_VECTOR0_EVENT_OTHER,
 };
 
@@ -933,6 +938,7 @@ struct hclge_dev {
 	/* affinity mask and notify for misc interrupt */
 	cpumask_t affinity_mask;
 	struct irq_affinity_notify affinity_notify;
+	struct hclge_ptp *ptp;
 };
 
 /* VPort level vlan tag configuration for TX direction */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
new file mode 100644
index 000000000000..b133b5984584
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2021 Hisilicon Limited.
+
+#include <linux/skbuff.h>
+#include "hclge_main.h"
+#include "hnae3.h"
+
+static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
+	u64 adj_val, adj_base, diff;
+	bool is_neg = false;
+	u32 quo, numerator;
+
+	if (ppb < 0) {
+		ppb = -ppb;
+		is_neg = true;
+	}
+
+	adj_base = HCLGE_PTP_CYCLE_ADJ_BASE * HCLGE_PTP_CYCLE_ADJ_UNIT;
+	adj_val = adj_base * ppb;
+	diff = div_u64(adj_val, 1000000000ULL);
+
+	if (is_neg)
+		adj_val = adj_base - diff;
+	else
+		adj_val = adj_base + diff;
+
+	/* This clock cycle is defined by three part: quotient, numerator
+	 * and denominator. For example, 2.5ns, the quotient is 2,
+	 * denominator is fixed to HCLGE_PTP_CYCLE_ADJ_UNIT, and numerator
+	 * is 0.5 * HCLGE_PTP_CYCLE_ADJ_UNIT.
+	 */
+	quo = div_u64_rem(adj_val, HCLGE_PTP_CYCLE_ADJ_UNIT, &numerator);
+	writel(quo, hdev->ptp->io_base + HCLGE_PTP_CYCLE_QUO_REG);
+	writel(numerator, hdev->ptp->io_base + HCLGE_PTP_CYCLE_NUM_REG);
+	writel(HCLGE_PTP_CYCLE_ADJ_UNIT,
+	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_DEN_REG);
+	writel(HCLGE_PTP_CYCLE_ADJ_EN,
+	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_CFG_REG);
+
+	return 0;
+}
+
+bool hclge_ptp_set_tx_info(struct hnae3_handle *handle, struct sk_buff *skb)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_ptp *ptp = hdev->ptp;
+
+	if (!test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ||
+	    test_and_set_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state)) {
+		ptp->tx_skipped++;
+		return false;
+	}
+
+	ptp->tx_start = jiffies;
+	ptp->tx_skb = skb_get(skb);
+	ptp->tx_cnt++;
+
+	return true;
+}
+
+void hclge_ptp_clean_tx_hwts(struct hclge_dev *hdev)
+{
+	struct sk_buff *skb = hdev->ptp->tx_skb;
+	struct skb_shared_hwtstamps hwts;
+	u32 hi, lo;
+	u64 ns;
+
+	ns = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_NSEC_REG) &
+	     HCLGE_PTP_TX_TS_NSEC_MASK;
+	lo = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_SEC_L_REG);
+	hi = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_SEC_H_REG) &
+	     HCLGE_PTP_TX_TS_SEC_H_MASK;
+	hdev->ptp->last_tx_seqid = readl(hdev->ptp->io_base +
+		HCLGE_PTP_TX_TS_SEQID_REG);
+
+	if (skb) {
+		hdev->ptp->tx_skb = NULL;
+		hdev->ptp->tx_cleaned++;
+
+		ns += (((u64)hi) << 32 | lo) * NSEC_PER_SEC;
+		hwts.hwtstamp = ns_to_ktime(ns);
+		skb_tstamp_tx(skb, &hwts);
+		dev_kfree_skb_any(skb);
+	}
+
+	clear_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state);
+}
+
+void hclge_ptp_get_rx_hwts(struct hnae3_handle *handle, struct sk_buff *skb,
+			   u32 nsec, u32 sec)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u64 ns = nsec;
+	u32 sec_h;
+
+	if (!test_bit(HCLGE_PTP_FLAG_RX_EN, &hdev->ptp->flags))
+		return;
+
+	/* Since the BD does not have enough space for the higher 16 bits of
+	 * second, and this part will not change frequently, so read it
+	 * from register.
+	 */
+	sec_h = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_H_REG);
+	ns += (((u64)sec_h) << HCLGE_PTP_SEC_H_OFFSET | sec) * NSEC_PER_SEC;
+	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ns);
+	hdev->ptp->last_rx = jiffies;
+	hdev->ptp->rx_cnt++;
+}
+
+static int hclge_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
+			      struct ptp_system_timestamp *sts)
+{
+	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
+	u32 hi, lo;
+	u64 ns;
+
+	ns = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_NSEC_REG);
+	hi = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_H_REG);
+	lo = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_L_REG);
+	ns += (((u64)hi) << HCLGE_PTP_SEC_H_OFFSET | lo) * NSEC_PER_SEC;
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int hclge_ptp_settime(struct ptp_clock_info *ptp,
+			     const struct timespec64 *ts)
+{
+	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
+
+	writel(ts->tv_nsec, hdev->ptp->io_base + HCLGE_PTP_TIME_NSEC_REG);
+	writel(ts->tv_sec >> HCLGE_PTP_SEC_H_OFFSET,
+	       hdev->ptp->io_base + HCLGE_PTP_TIME_SEC_H_REG);
+	writel(ts->tv_sec & HCLGE_PTP_SEC_L_MASK,
+	       hdev->ptp->io_base + HCLGE_PTP_TIME_SEC_L_REG);
+	/* synchronize the time of phc */
+	writel(HCLGE_PTP_TIME_SYNC_EN,
+	       hdev->ptp->io_base + HCLGE_PTP_TIME_SYNC_REG);
+
+	return 0;
+}
+
+static int hclge_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
+	bool is_neg = false;
+	u32 adj_val = 0;
+
+	if (delta < 0) {
+		adj_val |= HCLGE_PTP_TIME_NSEC_NEG;
+		delta = -delta;
+		is_neg = true;
+	}
+
+	if (delta > HCLGE_PTP_TIME_NSEC_MASK) {
+		struct timespec64 ts;
+		s64 ns;
+
+		hclge_ptp_gettimex(ptp, &ts, NULL);
+		ns = timespec64_to_ns(&ts);
+		ns = is_neg ? ns - delta : ns + delta;
+		ts = ns_to_timespec64(ns);
+		return hclge_ptp_settime(ptp, &ts);
+	}
+
+	adj_val |= delta & HCLGE_PTP_TIME_NSEC_MASK;
+	writel(adj_val, hdev->ptp->io_base + HCLGE_PTP_TIME_NSEC_REG);
+	writel(HCLGE_PTP_TIME_ADJ_EN,
+	       hdev->ptp->io_base + HCLGE_PTP_TIME_ADJ_REG);
+
+	return 0;
+}
+
+int hclge_ptp_get_cfg(struct hclge_dev *hdev, struct ifreq *ifr)
+{
+	if (!test_bit(HCLGE_STATE_PTP_EN, &hdev->state))
+		return -EOPNOTSUPP;
+
+	return copy_to_user(ifr->ifr_data, &hdev->ptp->ts_cfg,
+		sizeof(struct hwtstamp_config)) ? -EFAULT : 0;
+}
+
+static int hclge_ptp_int_en(struct hclge_dev *hdev, bool en)
+{
+	struct hclge_ptp_int_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	req = (struct hclge_ptp_int_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PTP_INT_EN, false);
+	req->int_en = en ? 1 : 0;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to %s ptp interrupt, ret = %d\n",
+			en ? "enable" : "disable", ret);
+
+	return ret;
+}
+
+int hclge_ptp_cfg_qry(struct hclge_dev *hdev, u32 *cfg)
+{
+	struct hclge_ptp_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	req = (struct hclge_ptp_cfg_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PTP_MODE_CFG, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query ptp config, ret = %d\n", ret);
+		return ret;
+	}
+
+	*cfg = le32_to_cpu(req->cfg);
+
+	return 0;
+}
+
+static int hclge_ptp_cfg(struct hclge_dev *hdev, u32 cfg)
+{
+	struct hclge_ptp_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	req = (struct hclge_ptp_cfg_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PTP_MODE_CFG, false);
+	req->cfg = cpu_to_le32(cfg);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to config ptp, ret = %d\n", ret);
+
+	return ret;
+}
+
+static int hclge_ptp_set_tx_mode(struct hwtstamp_config *cfg,
+				 unsigned long *flags, u32 *ptp_cfg)
+{
+	switch (cfg->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		clear_bit(HCLGE_PTP_FLAG_TX_EN, flags);
+		break;
+	case HWTSTAMP_TX_ON:
+		set_bit(HCLGE_PTP_FLAG_TX_EN, flags);
+		*ptp_cfg |= HCLGE_PTP_TX_EN_B;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int hclge_ptp_set_rx_mode(struct hwtstamp_config *cfg,
+				 unsigned long *flags, u32 *ptp_cfg)
+{
+	int rx_filter = cfg->rx_filter;
+
+	switch (cfg->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		clear_bit(HCLGE_PTP_FLAG_RX_EN, flags);
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+		set_bit(HCLGE_PTP_FLAG_RX_EN, flags);
+		*ptp_cfg |= HCLGE_PTP_RX_EN_B;
+		*ptp_cfg |= HCLGE_PTP_UDP_FULL_TYPE << HCLGE_PTP_UDP_EN_SHIFT;
+		rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		set_bit(HCLGE_PTP_FLAG_RX_EN, flags);
+		*ptp_cfg |= HCLGE_PTP_RX_EN_B;
+		*ptp_cfg |= HCLGE_PTP_UDP_FULL_TYPE << HCLGE_PTP_UDP_EN_SHIFT;
+		*ptp_cfg |= HCLGE_PTP_MSG1_V2_DEFAULT << HCLGE_PTP_MSG1_SHIFT;
+		*ptp_cfg |= HCLGE_PTP_MSG0_V2_EVENT << HCLGE_PTP_MSG0_SHIFT;
+		*ptp_cfg |= HCLGE_PTP_MSG_TYPE_V2 << HCLGE_PTP_MSG_TYPE_SHIFT;
+		rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	default:
+		return -ERANGE;
+	}
+
+	cfg->rx_filter = rx_filter;
+
+	return 0;
+}
+
+static int hclge_ptp_set_ts_mode(struct hclge_dev *hdev,
+				 struct hwtstamp_config *cfg)
+{
+	unsigned long flags = hdev->ptp->flags;
+	u32 ptp_cfg = 0;
+	int ret;
+
+	if (test_bit(HCLGE_PTP_FLAG_EN, &hdev->ptp->flags))
+		ptp_cfg |= HCLGE_PTP_EN_B;
+
+	ret = hclge_ptp_set_tx_mode(cfg, &flags, &ptp_cfg);
+	if (ret)
+		return ret;
+
+	ret = hclge_ptp_set_rx_mode(cfg, &flags, &ptp_cfg);
+	if (ret)
+		return ret;
+
+	ret = hclge_ptp_cfg(hdev, ptp_cfg);
+	if (ret)
+		return ret;
+
+	hdev->ptp->flags = flags;
+	hdev->ptp->ptp_cfg = ptp_cfg;
+
+	return 0;
+}
+
+int hclge_ptp_set_cfg(struct hclge_dev *hdev, struct ifreq *ifr)
+{
+	struct hwtstamp_config cfg;
+	int ret;
+
+	if (!test_bit(HCLGE_STATE_PTP_EN, &hdev->state)) {
+		dev_err(&hdev->pdev->dev, "phc is unsupported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	ret = hclge_ptp_set_ts_mode(hdev, &cfg);
+	if (ret)
+		return ret;
+
+	hdev->ptp->ts_cfg = cfg;
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+int hclge_ptp_get_ts_info(struct hnae3_handle *handle,
+			  struct ethtool_ts_info *info)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	if (!test_bit(HCLGE_STATE_PTP_EN, &hdev->state)) {
+		dev_err(&hdev->pdev->dev, "phc is unsupported\n");
+		return -EOPNOTSUPP;
+	}
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	if (hdev->ptp->clock)
+		info->phc_index = ptp_clock_index(hdev->ptp->clock);
+	else
+		info->phc_index = -1;
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON);
+
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ);
+
+	info->rx_filters |= BIT(HWTSTAMP_FILTER_PTP_V1_L4_SYNC) |
+			    BIT(HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_EVENT) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_SYNC) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_L4_SYNC) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_DELAY_REQ) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ);
+
+	return 0;
+}
+
+static int hclge_ptp_create_clock(struct hclge_dev *hdev)
+{
+#define HCLGE_PTP_NAME_LEN	32
+
+	struct hclge_ptp *ptp;
+
+	ptp = devm_kzalloc(&hdev->pdev->dev, sizeof(*ptp), GFP_KERNEL);
+	if (!ptp)
+		return -ENOMEM;
+
+	ptp->hdev = hdev;
+	snprintf(ptp->info.name, HCLGE_PTP_NAME_LEN, "%s",
+		 HCLGE_DRIVER_NAME);
+	ptp->info.owner = THIS_MODULE;
+	ptp->info.max_adj = HCLGE_PTP_CYCLE_ADJ_MAX;
+	ptp->info.n_ext_ts = 0;
+	ptp->info.pps = 0;
+	ptp->info.adjfreq = hclge_ptp_adjfreq;
+	ptp->info.adjtime = hclge_ptp_adjtime;
+	ptp->info.gettimex64 = hclge_ptp_gettimex;
+	ptp->info.settime64 = hclge_ptp_settime;
+
+	ptp->info.n_alarm = 0;
+	ptp->clock = ptp_clock_register(&ptp->info, &hdev->pdev->dev);
+	if (IS_ERR(ptp->clock)) {
+		dev_err(&hdev->pdev->dev, "%d failed to register ptp clock, ret = %ld\n",
+			ptp->info.n_alarm, PTR_ERR(ptp->clock));
+		return PTR_ERR(ptp->clock);
+	}
+
+	ptp->io_base = hdev->hw.io_base + HCLGE_PTP_REG_OFFSET;
+	ptp->ts_cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+	ptp->ts_cfg.tx_type = HWTSTAMP_TX_OFF;
+	hdev->ptp = ptp;
+
+	return 0;
+}
+
+static void hclge_ptp_destroy_clock(struct hclge_dev *hdev)
+{
+	ptp_clock_unregister(hdev->ptp->clock);
+	hdev->ptp->clock = NULL;
+	devm_kfree(&hdev->pdev->dev, hdev->ptp);
+	hdev->ptp = NULL;
+}
+
+int hclge_ptp_init(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct timespec64 ts;
+	int ret;
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_PTP_B, ae_dev->caps))
+		return 0;
+
+	if (!hdev->ptp) {
+		ret = hclge_ptp_create_clock(hdev);
+		if (ret)
+			return ret;
+	}
+
+	ret = hclge_ptp_int_en(hdev, true);
+	if (ret)
+		goto out;
+
+	set_bit(HCLGE_PTP_FLAG_EN, &hdev->ptp->flags);
+	ret = hclge_ptp_adjfreq(&hdev->ptp->info, 0);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to init freq, ret = %d\n", ret);
+		goto out;
+	}
+
+	ret = hclge_ptp_set_ts_mode(hdev, &hdev->ptp->ts_cfg);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to init ts mode, ret = %d\n", ret);
+		goto out;
+	}
+
+	ktime_get_real_ts64(&ts);
+	ret = hclge_ptp_settime(&hdev->ptp->info, &ts);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to init ts time, ret = %d\n", ret);
+		goto out;
+	}
+
+	set_bit(HCLGE_STATE_PTP_EN, &hdev->state);
+	dev_info(&hdev->pdev->dev, "phc initializes ok!\n");
+
+	return 0;
+
+out:
+	hclge_ptp_destroy_clock(hdev);
+
+	return ret;
+}
+
+void hclge_ptp_uninit(struct hclge_dev *hdev)
+{
+	struct hclge_ptp *ptp = hdev->ptp;
+
+	if (!ptp)
+		return;
+
+	hclge_ptp_int_en(hdev, false);
+	clear_bit(HCLGE_STATE_PTP_EN, &hdev->state);
+	clear_bit(HCLGE_PTP_FLAG_EN, &ptp->flags);
+	ptp->ts_cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+	ptp->ts_cfg.tx_type = HWTSTAMP_TX_OFF;
+
+	if (hclge_ptp_set_ts_mode(hdev, &ptp->ts_cfg))
+		dev_err(&hdev->pdev->dev, "failed to disable phc\n");
+
+	if (ptp->tx_skb) {
+		struct sk_buff *skb = ptp->tx_skb;
+
+		ptp->tx_skb = NULL;
+		dev_kfree_skb_any(skb);
+	}
+
+	hclge_ptp_destroy_clock(hdev);
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
new file mode 100644
index 000000000000..d819e4cad4b6
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021 Hisilicon Limited.
+
+#ifndef __HCLGE_PTP_H
+#define __HCLGE_PTP_H
+
+#include <linux/ptp_clock_kernel.h>
+#include <linux/net_tstamp.h>
+#include <linux/types.h>
+
+#define HCLGE_PTP_REG_OFFSET	0x29000
+
+#define HCLGE_PTP_TX_TS_SEQID_REG	0x0
+#define HCLGE_PTP_TX_TS_NSEC_REG	0x4
+#define HCLGE_PTP_TX_TS_NSEC_MASK	GENMASK(29, 0)
+#define HCLGE_PTP_TX_TS_SEC_L_REG	0x8
+#define HCLGE_PTP_TX_TS_SEC_H_REG	0xC
+#define HCLGE_PTP_TX_TS_SEC_H_MASK	GENMASK(15, 0)
+#define HCLGE_PTP_TX_TS_CNT_REG		0x30
+
+#define HCLGE_PTP_TIME_SEC_H_REG	0x50
+#define HCLGE_PTP_TIME_SEC_H_MASK	GENMASK(15, 0)
+#define HCLGE_PTP_TIME_SEC_L_REG	0x54
+#define HCLGE_PTP_TIME_NSEC_REG		0x58
+#define HCLGE_PTP_TIME_NSEC_MASK	GENMASK(29, 0)
+#define HCLGE_PTP_TIME_NSEC_NEG		BIT(31)
+#define HCLGE_PTP_TIME_SYNC_REG		0x5C
+#define HCLGE_PTP_TIME_SYNC_EN		BIT(0)
+#define HCLGE_PTP_TIME_ADJ_REG		0x60
+#define HCLGE_PTP_TIME_ADJ_EN		BIT(0)
+#define HCLGE_PTP_CYCLE_QUO_REG		0x64
+#define HCLGE_PTP_CYCLE_DEN_REG		0x68
+#define HCLGE_PTP_CYCLE_NUM_REG		0x6C
+#define HCLGE_PTP_CYCLE_CFG_REG		0x70
+#define HCLGE_PTP_CYCLE_ADJ_EN		BIT(0)
+#define HCLGE_PTP_CUR_TIME_SEC_H_REG	0x74
+#define HCLGE_PTP_CUR_TIME_SEC_L_REG	0x78
+#define HCLGE_PTP_CUR_TIME_NSEC_REG	0x7C
+
+#define HCLGE_PTP_CYCLE_ADJ_BASE	2
+#define HCLGE_PTP_CYCLE_ADJ_MAX		500000000
+#define HCLGE_PTP_CYCLE_ADJ_UNIT	100000000
+#define HCLGE_PTP_SEC_H_OFFSET		32u
+#define HCLGE_PTP_SEC_L_MASK		GENMASK(31, 0)
+
+#define HCLGE_PTP_FLAG_EN		BIT(0)
+#define HCLGE_PTP_FLAG_TX_EN		BIT(1)
+#define HCLGE_PTP_FLAG_RX_EN		BIT(2)
+
+struct hclge_ptp {
+	struct hclge_dev *hdev;
+	struct ptp_clock *clock;
+	struct sk_buff *tx_skb;
+	unsigned long flags;
+	void __iomem *io_base;
+	struct ptp_clock_info info;
+	struct hwtstamp_config ts_cfg;
+	u32 ptp_cfg;
+	u32 last_tx_seqid;
+	unsigned long tx_start;
+	unsigned long tx_cnt;
+	unsigned long tx_skipped;
+	unsigned long tx_cleaned;
+	unsigned long last_rx;
+	unsigned long rx_cnt;
+	unsigned long tx_timeout;
+};
+
+struct hclge_ptp_int_cmd {
+#define HCLGE_PTP_INT_EN_B	BIT(0)
+
+	u8 int_en;
+	u8 rsvd[23];
+};
+
+enum hclge_ptp_udp_type {
+	HCLGE_PTP_UDP_NOT_TYPE,
+	HCLGE_PTP_UDP_P13F_TYPE,
+	HCLGE_PTP_UDP_P140_TYPE,
+	HCLGE_PTP_UDP_FULL_TYPE,
+};
+
+enum hclge_ptp_msg_type {
+	HCLGE_PTP_MSG_TYPE_V2_L2,
+	HCLGE_PTP_MSG_TYPE_V2,
+	HCLGE_PTP_MSG_TYPE_V2_EVENT,
+};
+
+enum hclge_ptp_msg0_type {
+	HCLGE_PTP_MSG0_V2_DELAY_REQ = 1,
+	HCLGE_PTP_MSG0_V2_PDELAY_REQ,
+	HCLGE_PTP_MSG0_V2_DELAY_RESP,
+	HCLGE_PTP_MSG0_V2_EVENT = 0xF,
+};
+
+#define HCLGE_PTP_MSG1_V2_DEFAULT	1
+
+struct hclge_ptp_cfg_cmd {
+#define HCLGE_PTP_EN_B			BIT(0)
+#define HCLGE_PTP_TX_EN_B		BIT(1)
+#define HCLGE_PTP_RX_EN_B		BIT(2)
+#define HCLGE_PTP_UDP_EN_SHIFT		3
+#define HCLGE_PTP_UDP_EN_MASK		GENMASK(4, 3)
+#define HCLGE_PTP_MSG_TYPE_SHIFT	8
+#define HCLGE_PTP_MSG_TYPE_MASK		GENMASK(9, 8)
+#define HCLGE_PTP_MSG1_SHIFT		16
+#define HCLGE_PTP_MSG1_MASK		GENMASK(19, 16)
+#define HCLGE_PTP_MSG0_SHIFT		24
+#define HCLGE_PTP_MSG0_MASK		GENMASK(27, 24)
+
+	__le32 cfg;
+	u8 rsvd[20];
+};
+
+static inline struct hclge_dev *hclge_ptp_get_hdev(struct ptp_clock_info *info)
+{
+	struct hclge_ptp *ptp = container_of(info, struct hclge_ptp, info);
+
+	return ptp->hdev;
+}
+
+bool hclge_ptp_set_tx_info(struct hnae3_handle *handle, struct sk_buff *skb);
+void hclge_ptp_clean_tx_hwts(struct hclge_dev *dev);
+void hclge_ptp_get_rx_hwts(struct hnae3_handle *handle, struct sk_buff *skb,
+			   u32 nsec, u32 sec);
+int hclge_ptp_get_cfg(struct hclge_dev *hdev, struct ifreq *ifr);
+int hclge_ptp_set_cfg(struct hclge_dev *hdev, struct ifreq *ifr);
+int hclge_ptp_init(struct hclge_dev *hdev);
+void hclge_ptp_uninit(struct hclge_dev *hdev);
+int hclge_ptp_get_ts_info(struct hnae3_handle *handle,
+			  struct ethtool_ts_info *info);
+int hclge_ptp_cfg_qry(struct hclge_dev *hdev, u32 *cfg);
+#endif
-- 
2.8.1

