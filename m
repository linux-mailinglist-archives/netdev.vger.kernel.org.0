Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792B06047B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 12:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfGEKae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 06:30:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8145 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfGEKad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 06:30:33 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B584633BF1CAB0FAE970;
        Fri,  5 Jul 2019 18:30:31 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 5 Jul 2019 18:30:24 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next] hinic: add fw version query
Date:   Fri, 5 Jul 2019 02:40:28 +0000
Message-ID: <20190705024028.5768-1-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds firmware version query in ethtool -i.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  8 +++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 ++
 .../net/ethernet/huawei/hinic/hinic_port.c    | 30 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 14 +++++++++
 4 files changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 73a20f01ad4c..60ec48fe4144 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -117,11 +117,19 @@ static void hinic_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *info)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u8 mgmt_ver[HINIC_MGMT_VERSION_MAX_LEN] = {0};
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	int err;
 
 	strlcpy(info->driver, HINIC_DRV_NAME, sizeof(info->driver));
 	strlcpy(info->bus_info, pci_name(hwif->pdev), sizeof(info->bus_info));
+
+	err = hinic_get_mgmt_version(nic_dev, mgmt_ver);
+	if (err)
+		return;
+
+	snprintf(info->fw_version, sizeof(info->fw_version), "%s", mgmt_ver);
 }
 
 static void hinic_get_ringparam(struct net_device *netdev,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 984c98f33258..b069045de416 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -77,6 +77,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
 
+	HINIC_PORT_CMD_GET_MGMT_VERSION = 88,
+
 	HINIC_PORT_CMD_SET_FUNC_STATE   = 93,
 
 	HINIC_PORT_CMD_GET_GLOBAL_QPN   = 102,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 1bbeb91be808..1e389a004e50 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -1038,3 +1038,33 @@ int hinic_get_phy_port_stats(struct hinic_dev *nic_dev,
 
 	return err;
 }
+
+int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver)
+{
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_version_info up_ver = {0};
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
+	u16 out_size;
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_MGMT_VERSION,
+				 &up_ver, sizeof(up_ver), &up_ver,
+				 &out_size);
+	if (err || !out_size || up_ver.status) {
+		dev_err(&pdev->dev,
+			"Failed to get mgmt version, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, up_ver.status, out_size);
+		return -EINVAL;
+	}
+
+	snprintf(mgmt_ver, HINIC_MGMT_VERSION_MAX_LEN, "%s", up_ver.ver);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 1bc47c7a5c00..44772fd47fc1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -16,6 +16,18 @@
 #define HINIC_RSS_KEY_SIZE	40
 #define HINIC_RSS_INDIR_SIZE	256
 #define HINIC_PORT_STATS_VERSION	0
+#define HINIC_FW_VERSION_NAME	16
+#define HINIC_COMPILE_TIME_LEN	20
+#define HINIC_MGMT_VERSION_MAX_LEN	32
+
+struct hinic_version_info {
+	u8 status;
+	u8 version;
+	u8 rsvd[6];
+
+	u8 ver[HINIC_FW_VERSION_NAME];
+	u8 time[HINIC_COMPILE_TIME_LEN];
+};
 
 enum hinic_rx_mode {
 	HINIC_RX_MODE_UC        = BIT(0),
@@ -571,4 +583,6 @@ int hinic_get_vport_stats(struct hinic_dev *nic_dev,
 
 int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en);
 
+int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver);
+
 #endif
-- 
2.17.1

