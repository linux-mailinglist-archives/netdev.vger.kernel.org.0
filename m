Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58613387E1
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCLIty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:49:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13153 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhCLItv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:49:51 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DxfZr4YQhzmWXS;
        Fri, 12 Mar 2021 16:47:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 16:49:40 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: add ioctl support for imp-controlled PHYs
Date:   Fri, 12 Mar 2021 16:50:15 +0800
Message-ID: <1615539016-45698-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
References: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

When the imp-controlled PHYs feature is enabled, driver will not
register mdio bus. In order to support ioctl ops for phy tool to
read or write phy register in this case, the firmware implement
a new command for driver and driver implement ioctl by using this
new command.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  8 +++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 25 +++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    | 39 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |  2 ++
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index f45ceaa..abeacc9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -306,6 +306,7 @@ enum hclge_opcode_type {
 
 	/* PHY command */
 	HCLGE_OPC_PHY_LINK_KSETTING	= 0x7025,
+	HCLGE_OPC_PHY_REG		= 0x7026,
 };
 
 #define HCLGE_TQP_REG_OFFSET		0x80000
@@ -1166,6 +1167,13 @@ struct hclge_phy_link_ksetting_1_cmd {
 	u8 rsv[22];
 };
 
+struct hclge_phy_reg_cmd {
+	__le16 reg_addr;
+	u8 rsv0[2];
+	__le16 reg_val;
+	u8 rsv1[18];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dbca489..adc2ec7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8904,6 +8904,29 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 	return 0;
 }
 
+static int hclge_mii_ioctl(struct hclge_dev *hdev, struct ifreq *ifr, int cmd)
+{
+	struct mii_ioctl_data *data = if_mii(ifr);
+
+	if (!hnae3_dev_phy_imp_supported(hdev))
+		return -EOPNOTSUPP;
+
+	switch (cmd) {
+	case SIOCGMIIPHY:
+		data->phy_id = hdev->hw.mac.phy_addr;
+		/* this command reads phy id and register at the same time */
+		fallthrough;
+	case SIOCGMIIREG:
+		data->val_out = hclge_read_phy_reg(hdev, data->reg_num);
+		return 0;
+
+	case SIOCSMIIREG:
+		return hclge_write_phy_reg(hdev, data->reg_num, data->val_in);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int hclge_do_ioctl(struct hnae3_handle *handle, struct ifreq *ifr,
 			  int cmd)
 {
@@ -8911,7 +8934,7 @@ static int hclge_do_ioctl(struct hnae3_handle *handle, struct ifreq *ifr,
 	struct hclge_dev *hdev = vport->back;
 
 	if (!hdev->hw.mac.phydev)
-		return -EOPNOTSUPP;
+		return hclge_mii_ioctl(hdev, ifr, cmd);
 
 	return phy_mii_ioctl(hdev->hw.mac.phydev, ifr, cmd);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index e898207..08e88d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -268,3 +268,42 @@ void hclge_mac_stop_phy(struct hclge_dev *hdev)
 
 	phy_stop(phydev);
 }
+
+u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr)
+{
+	struct hclge_phy_reg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PHY_REG, true);
+
+	req = (struct hclge_phy_reg_cmd *)desc.data;
+	req->reg_addr = cpu_to_le16(reg_addr);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to read phy reg, ret = %d.\n", ret);
+
+	return le16_to_cpu(req->reg_val);
+}
+
+int hclge_write_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 val)
+{
+	struct hclge_phy_reg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PHY_REG, false);
+
+	req = (struct hclge_phy_reg_cmd *)desc.data;
+	req->reg_addr = cpu_to_le16(reg_addr);
+	req->reg_val = cpu_to_le16(val);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to write phy reg, ret = %d.\n", ret);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
index dd9a121..fd0e201 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
@@ -9,5 +9,7 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle);
 void hclge_mac_disconnect_phy(struct hnae3_handle *handle);
 void hclge_mac_start_phy(struct hclge_dev *hdev);
 void hclge_mac_stop_phy(struct hclge_dev *hdev);
+u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr);
+int hclge_write_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 val);
 
 #endif
-- 
2.7.4

