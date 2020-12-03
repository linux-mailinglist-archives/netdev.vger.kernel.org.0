Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A902CD550
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgLCMTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:19:35 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9367 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgLCMTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:19:34 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cmvxs4L0Yz782g;
        Thu,  3 Dec 2020 20:18:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 20:18:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <huangdaode@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/3] net: hns3: add support for extended promiscuous command
Date:   Thu, 3 Dec 2020 20:18:54 +0800
Message-ID: <1606997936-22166-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

For DEVICE_VERSION_V2, the hardware supports enable tx and rx
promiscuous separately. But tx or rx promiscuous is active for
unicast, multicast and broadcast promiscuous simultaneously.
To support traffics between functions belong to the same port,
we always enable tx promiscuous for broadcast promiscuous, so
tx promiscuous for unicast and multicast promiscuous is also
enabled.

For DEVICE_VERSION_V3, the hardware decouples the above
relationship. Tx unicast promiscuous, rx unicast promiscuous,
tx multicast promiscuous, rx multicast promiscuous, tx broadcast
promiscuous and rx broadcast promiscuous can be enabled separately.

So add support for the new promiscuous command.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 31 +++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 59 +++++++++-------------
 2 files changed, 41 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 49cbd95..7ce8be1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -583,23 +583,26 @@ struct hclge_link_status_cmd {
 	u8 rsv[23];
 };
 
-struct hclge_promisc_param {
-	u8 vf_id;
-	u8 enable;
-};
+/* for DEVICE_VERSION_V1/2, reference to promisc cmd byte8 */
+#define HCLGE_PROMISC_EN_UC	1
+#define HCLGE_PROMISC_EN_MC	2
+#define HCLGE_PROMISC_EN_BC	3
+#define HCLGE_PROMISC_TX_EN	4
+#define HCLGE_PROMISC_RX_EN	5
+
+/* for DEVICE_VERSION_V3, reference to promisc cmd byte10 */
+#define HCLGE_PROMISC_UC_RX_EN	2
+#define HCLGE_PROMISC_MC_RX_EN	3
+#define HCLGE_PROMISC_BC_RX_EN	4
+#define HCLGE_PROMISC_UC_TX_EN	5
+#define HCLGE_PROMISC_MC_TX_EN	6
+#define HCLGE_PROMISC_BC_TX_EN	7
 
-#define HCLGE_PROMISC_TX_EN_B	BIT(4)
-#define HCLGE_PROMISC_RX_EN_B	BIT(5)
-#define HCLGE_PROMISC_EN_B	1
-#define HCLGE_PROMISC_EN_ALL	0x7
-#define HCLGE_PROMISC_EN_UC	0x1
-#define HCLGE_PROMISC_EN_MC	0x2
-#define HCLGE_PROMISC_EN_BC	0x4
 struct hclge_promisc_cfg_cmd {
-	u8 flag;
+	u8 promisc;
 	u8 vf_id;
-	__le16 rsv0;
-	u8 rsv1[20];
+	u8 extend_promisc;
+	u8 rsv0[21];
 };
 
 enum hclge_promisc_type {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ca668a4..f4859ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4826,61 +4826,50 @@ static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle, int vector,
 	return ret;
 }
 
-static int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev,
-				      struct hclge_promisc_param *param)
+static int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev, u8 vf_id,
+				      bool en_uc, bool en_mc, bool en_bc)
 {
 	struct hclge_promisc_cfg_cmd *req;
 	struct hclge_desc desc;
+	u8 promisc_cfg = 0;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_PROMISC_MODE, false);
 
 	req = (struct hclge_promisc_cfg_cmd *)desc.data;
-	req->vf_id = param->vf_id;
+	req->vf_id = vf_id;
 
-	/* HCLGE_PROMISC_TX_EN_B and HCLGE_PROMISC_RX_EN_B are not supported on
-	 * pdev revision(0x20), new revision support them. The
-	 * value of this two fields will not return error when driver
-	 * send command to fireware in revision(0x20).
-	 */
-	req->flag = (param->enable << HCLGE_PROMISC_EN_B) |
-		HCLGE_PROMISC_TX_EN_B | HCLGE_PROMISC_RX_EN_B;
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_UC_RX_EN, en_uc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_MC_RX_EN, en_mc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_BC_RX_EN, en_bc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_UC_TX_EN, en_uc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_MC_TX_EN, en_mc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_BC_TX_EN, en_bc ? 1 : 0);
+	req->extend_promisc = promisc_cfg;
+
+	/* to be compatible with DEVICE_VERSION_V1/2 */
+	promisc_cfg = 0;
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_EN_UC, en_uc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_EN_MC, en_mc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_EN_BC, en_bc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_TX_EN, 1);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_RX_EN, 1);
+	req->promisc = promisc_cfg;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
-			"failed to set vport %d promisc mode, ret = %d.\n",
-			param->vf_id, ret);
+			"failed to set vport %u promisc mode, ret = %d.\n",
+			vf_id, ret);
 
 	return ret;
 }
 
-static void hclge_promisc_param_init(struct hclge_promisc_param *param,
-				     bool en_uc, bool en_mc, bool en_bc,
-				     int vport_id)
-{
-	if (!param)
-		return;
-
-	memset(param, 0, sizeof(struct hclge_promisc_param));
-	if (en_uc)
-		param->enable = HCLGE_PROMISC_EN_UC;
-	if (en_mc)
-		param->enable |= HCLGE_PROMISC_EN_MC;
-	if (en_bc)
-		param->enable |= HCLGE_PROMISC_EN_BC;
-	param->vf_id = vport_id;
-}
-
 int hclge_set_vport_promisc_mode(struct hclge_vport *vport, bool en_uc_pmc,
 				 bool en_mc_pmc, bool en_bc_pmc)
 {
-	struct hclge_dev *hdev = vport->back;
-	struct hclge_promisc_param param;
-
-	hclge_promisc_param_init(&param, en_uc_pmc, en_mc_pmc, en_bc_pmc,
-				 vport->vport_id);
-	return hclge_cmd_set_promisc_mode(hdev, &param);
+	return hclge_cmd_set_promisc_mode(vport->back, vport->vport_id,
+					  en_uc_pmc, en_mc_pmc, en_bc_pmc);
 }
 
 static int hclge_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
-- 
2.7.4

