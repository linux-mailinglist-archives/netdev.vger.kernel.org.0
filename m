Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC121EC969
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFCGWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:22:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55902 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbgFCGVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 02:21:35 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5E94BA54E25950125C75;
        Wed,  3 Jun 2020 14:21:33 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 3 Jun 2020 14:21:24 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <chiqijun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next 4/5] hinic: add support to identify physical device
Date:   Wed, 3 Jun 2020 14:20:14 +0800
Message-ID: <20200603062015.12640-5-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603062015.12640-1-luobin9@huawei.com>
References: <20200603062015.12640-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to identify physical device by flashing an LED
attached to it with ethtool -p cmd.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 41 ++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  2 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  1 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |  4 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    | 55 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 35 ++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |  4 +-
 7 files changed, 139 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 5d6278cf74ad..61a5c59532b8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1759,6 +1759,46 @@ static void hinic_diag_test(struct net_device *netdev,
 		netif_carrier_on(netdev);
 }
 
+static int hinic_set_phys_id(struct net_device *netdev,
+			     enum ethtool_phys_id_state state)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+	u8 port;
+
+	port = nic_dev->hwdev->port_id;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		err = hinic_set_led_status(nic_dev->hwdev, port,
+					   HINIC_LED_TYPE_LINK,
+					   HINIC_LED_MODE_FORCE_2HZ);
+		if (err)
+			netif_err(nic_dev, drv, netdev,
+				  "Set LED blinking in 2HZ failed\n");
+		else
+			netif_info(nic_dev, drv, netdev,
+				   "Set LED blinking in 2HZ success\n");
+		break;
+
+	case ETHTOOL_ID_INACTIVE:
+		err = hinic_reset_led_status(nic_dev->hwdev, port);
+		if (err)
+			netif_err(nic_dev, drv, netdev,
+				  "Reset LED to original status failed\n");
+		else
+			netif_info(nic_dev, drv, netdev,
+				   "Reset LED to original status success\n");
+
+		break;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -1789,6 +1829,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_ethtool_stats = hinic_get_ethtool_stats,
 	.get_strings = hinic_get_strings,
 	.self_test = hinic_diag_test,
+	.set_phys_id = hinic_set_phys_id,
 };
 
 static const struct ethtool_ops hinicvf_ethtool_ops = {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 4de50e4ba4df..45c137827a16 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -83,6 +83,8 @@ static int parse_capability(struct hinic_hwdev *hwdev,
 		nic_cap->max_vf_qps = dev_cap->max_vf_sqs + 1;
 	}
 
+	hwdev->port_id = dev_cap->port_id;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index c92c39a50b81..01fe94f2d4bc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -312,6 +312,7 @@ struct hinic_hwdev {
 	struct hinic_mbox_func_to_func  *func_to_func;
 
 	struct hinic_cap                nic_cap;
+	u8				port_id;
 };
 
 struct hinic_nic_cb {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index a3349ae30ff3..919d2c6ffc35 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -81,7 +81,9 @@ enum hinic_comm_cmd {
 	HINIC_COMM_CMD_MSI_CTRL_REG_WR_BY_UP,
 	HINIC_COMM_CMD_MSI_CTRL_REG_RD_BY_UP,
 
-	HINIC_COMM_CMD_L2NIC_RESET		= 0x4b,
+	HINIC_COMM_CMD_SET_LED_STATUS	= 0x4a,
+
+	HINIC_COMM_CMD_L2NIC_RESET	= 0x4b,
 
 	HINIC_COMM_CMD_PAGESIZE_SET	= 0x50,
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 53ea2740ba9f..fc99d9f6799a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -1271,3 +1271,58 @@ int hinic_set_loopback_mode(struct hinic_hwdev *hwdev, u32 mode, u32 enable)
 
 	return 0;
 }
+
+static int _set_led_status(struct hinic_hwdev *hwdev, u8 port,
+			   enum hinic_led_type type,
+			   enum hinic_led_mode mode, u8 reset)
+{
+	struct hinic_led_info led_info = {0};
+	u16 out_size = sizeof(led_info);
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	led_info.port = port;
+	led_info.reset = reset;
+
+	led_info.type = type;
+	led_info.mode = mode;
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_SET_LED_STATUS,
+				&led_info, sizeof(led_info),
+				&led_info, &out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || led_info.status || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set led status, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, led_info.status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int hinic_set_led_status(struct hinic_hwdev *hwdev, u8 port,
+			 enum hinic_led_type type, enum hinic_led_mode mode)
+{
+	if (!hwdev)
+		return -EINVAL;
+
+	return _set_led_status(hwdev, port, type, mode, 0);
+}
+
+int hinic_reset_led_status(struct hinic_hwdev *hwdev, u8 port)
+{
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	err = _set_led_status(hwdev, port, HINIC_LED_TYPE_INVALID,
+			      HINIC_LED_MODE_INVALID, 1);
+	if (err)
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to reset led status\n");
+
+	return err;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index b21956d7232e..5c916875f295 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -666,6 +666,17 @@ struct hinic_port_loopback {
 	u32	en;
 };
 
+struct hinic_led_info {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u8	port;
+	u8	type;
+	u8	mode;
+	u8	reset;
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -765,6 +776,30 @@ int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap);
 
 int hinic_set_loopback_mode(struct hinic_hwdev *hwdev, u32 mode, u32 enable);
 
+enum hinic_led_mode {
+	HINIC_LED_MODE_ON,
+	HINIC_LED_MODE_OFF,
+	HINIC_LED_MODE_FORCE_1HZ,
+	HINIC_LED_MODE_FORCE_2HZ,
+	HINIC_LED_MODE_FORCE_4HZ,
+	HINIC_LED_MODE_1HZ,
+	HINIC_LED_MODE_2HZ,
+	HINIC_LED_MODE_4HZ,
+	HINIC_LED_MODE_INVALID,
+};
+
+enum hinic_led_type {
+	HINIC_LED_TYPE_LINK,
+	HINIC_LED_TYPE_LOW_SPEED,
+	HINIC_LED_TYPE_HIGH_SPEED,
+	HINIC_LED_TYPE_INVALID,
+};
+
+int hinic_reset_led_status(struct hinic_hwdev *hwdev, u8 port);
+
+int hinic_set_led_status(struct hinic_hwdev *hwdev, u8 port,
+			 enum hinic_led_type type, enum hinic_led_mode mode);
+
 int hinic_open(struct net_device *netdev);
 
 int hinic_close(struct net_device *netdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index efab2dd2c889..f5c7c1f48542 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -383,7 +383,7 @@ static int hinic_del_vf_mac_msg_handler(void *hwdev, u16 vf_id,
 
 	nic_io = &hw_dev->func_to_io;
 	vf_info = nic_io->vf_infos + HW_VF_ID_TO_OS(vf_id);
-	if (vf_info->pf_set_mac  && is_valid_ether_addr(mac_in->mac) &&
+	if (vf_info->pf_set_mac && is_valid_ether_addr(mac_in->mac) &&
 	    !memcmp(vf_info->vf_mac_addr, mac_in->mac, ETH_ALEN)) {
 		dev_warn(&hw_dev->hwif->pdev->dev, "PF has already set VF mac.\n");
 		mac_out->status = HINIC_PF_SET_VF_ALREADY;
@@ -905,7 +905,6 @@ int hinic_ndo_set_vf_spoofchk(struct net_device *netdev, int vf, bool setting)
 
 	err = hinic_set_vf_spoofchk(sriov_info->hwdev,
 				    OS_VF_ID_TO_HW(vf), setting);
-
 	if (!err) {
 		netif_info(nic_dev, drv, netdev, "Set VF %d spoofchk %s successfully\n",
 			   vf, setting ? "on" : "off");
@@ -1020,6 +1019,7 @@ static int cfg_mbx_pf_proc_vf_msg(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 	dev_cap->max_vf = cap->max_vf;
 	dev_cap->max_sqs = cap->max_vf_qps;
 	dev_cap->max_rqs = cap->max_vf_qps;
+	dev_cap->port_id = dev->port_id;
 
 	*out_size = sizeof(*dev_cap);
 
-- 
2.17.1

