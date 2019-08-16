Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991138FD58
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfHPIMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfHPIMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7AA95FDE10C9B34E50BA;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        Huzhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/6] net: hns3: modify redundant initialization of variable
Date:   Fri, 16 Aug 2019 16:09:38 +0800
Message-ID: <1565942982-12105-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Some temporary variables do not need to be initialized that
they will be set before used, so this patch deletes the
initialization value of these temporary variables.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huzhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c               | 7 +++----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c    | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c     | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c  | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 908d4f4..6bbba15 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -104,7 +104,6 @@ int hnae3_register_client(struct hnae3_client *client)
 {
 	struct hnae3_client *client_tmp;
 	struct hnae3_ae_dev *ae_dev;
-	int ret = 0;
 
 	if (!client)
 		return -ENODEV;
@@ -123,7 +122,7 @@ int hnae3_register_client(struct hnae3_client *client)
 		/* if the client could not be initialized on current port, for
 		 * any error reasons, move on to next available port
 		 */
-		ret = hnae3_init_client_instance(client, ae_dev);
+		int ret = hnae3_init_client_instance(client, ae_dev);
 		if (ret)
 			dev_err(&ae_dev->pdev->dev,
 				"match and instantiation failed for port, ret = %d\n",
@@ -164,7 +163,7 @@ void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo)
 	const struct pci_device_id *id;
 	struct hnae3_ae_dev *ae_dev;
 	struct hnae3_client *client;
-	int ret = 0;
+	int ret;
 
 	if (!ae_algo)
 		return;
@@ -258,7 +257,7 @@ int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 	const struct pci_device_id *id;
 	struct hnae3_ae_algo *ae_algo;
 	struct hnae3_client *client;
-	int ret = 0;
+	int ret;
 
 	if (!ae_dev)
 		return -ENODEV;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 677bfe06..4260653 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -749,7 +749,7 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
-	int ret = 0;
+	int ret;
 
 	/* Chip don't support this mode. */
 	if (cmd->base.speed == SPEED_1000 && cmd->base.duplex == DUPLEX_HALF)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 05a4cdb..5ce9a8a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1557,8 +1557,8 @@ int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en)
 
 static void hclge_handle_rocee_ras_error(struct hnae3_ae_dev *ae_dev)
 {
-	enum hnae3_reset_type reset_type = HNAE3_NONE_RESET;
 	struct hclge_dev *hdev = ae_dev->priv;
+	enum hnae3_reset_type reset_type;
 
 	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
 	    hdev->pdev->revision < 0x21)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index f30d112..e829101 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -404,8 +404,8 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_port_shapping_cmd *shap_cfg_cmd;
 	struct hclge_desc desc;
-	u32 shapping_para = 0;
 	u8 ir_u, ir_b, ir_s;
+	u32 shapping_para;
 	int ret;
 
 	ret = hclge_shaper_para_calc(hdev->hw.mac.speed,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 55d3c78..4c2c945 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -43,7 +43,7 @@ static int hclgevf_cmd_csq_clean(struct hclgevf_hw *hw)
 {
 	struct hclgevf_dev *hdev = container_of(hw, struct hclgevf_dev, hw);
 	struct hclgevf_cmq_ring *csq = &hw->cmq.csq;
-	int clean = 0;
+	int clean;
 	u32 head;
 
 	head = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index defc905..594cae8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2302,7 +2302,7 @@ static void hclgevf_uninit_msi(struct hclgevf_dev *hdev)
 
 static int hclgevf_misc_irq_init(struct hclgevf_dev *hdev)
 {
-	int ret = 0;
+	int ret;
 
 	hclgevf_get_misc_vector(hdev);
 
-- 
2.7.4

