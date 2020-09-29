Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6FD27C15B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgI2JfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:35:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbgI2Je5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:57 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A1E18F607E6605FE11D4;
        Tue, 29 Sep 2020 17:34:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: debugfs add new command to query device specifications
Date:   Tue, 29 Sep 2020 17:32:04 +0800
Message-ID: <1601371925-49426-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

In order to query specifications of the device, add a new debugfs
command "dev spec" to do that.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 15333ec..d6f8817 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -245,6 +245,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "queue map\n");
 	dev_info(&h->pdev->dev, "bd info <q_num> <bd index>\n");
 	dev_info(&h->pdev->dev, "dev capability\n");
+	dev_info(&h->pdev->dev, "dev spec\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
@@ -307,6 +308,31 @@ static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 		 test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, caps) ? "yes" : "no");
 }
 
+static void hns3_dbg_dev_specs(struct hnae3_handle *h)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	struct hnae3_dev_specs *dev_specs = &ae_dev->dev_specs;
+	struct hnae3_knic_private_info *kinfo = &h->kinfo;
+	struct hns3_nic_priv *priv  = h->priv;
+
+	dev_info(priv->dev, "MAC entry num: %u\n", dev_specs->mac_entry_num);
+	dev_info(priv->dev, "MNG entry num: %u\n", dev_specs->mng_entry_num);
+	dev_info(priv->dev, "MAX non tso bd num: %u\n",
+		 dev_specs->max_non_tso_bd_num);
+	dev_info(priv->dev, "RSS ind tbl size: %u\n",
+		 dev_specs->rss_ind_tbl_size);
+	dev_info(priv->dev, "RSS key size: %u\n", dev_specs->rss_key_size);
+	dev_info(priv->dev, "RSS size: %u\n", kinfo->rss_size);
+	dev_info(priv->dev, "Allocated RSS size: %u\n", kinfo->req_rss_size);
+	dev_info(priv->dev, "Task queue pairs numbers: %u\n", kinfo->num_tqps);
+
+	dev_info(priv->dev, "RX buffer length: %u\n", kinfo->rx_buf_len);
+	dev_info(priv->dev, "Desc num per TX queue: %u\n", kinfo->num_tx_desc);
+	dev_info(priv->dev, "Desc num per RX queue: %u\n", kinfo->num_rx_desc);
+	dev_info(priv->dev, "Total number of enabled TCs: %u\n", kinfo->num_tc);
+	dev_info(priv->dev, "MAX INT QL: %u\n", dev_specs->int_ql_max);
+}
+
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
 				 size_t count, loff_t *ppos)
 {
@@ -384,6 +410,8 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 		ret = hns3_dbg_bd_info(handle, cmd_buf);
 	else if (strncmp(cmd_buf, "dev capability", 14) == 0)
 		hns3_dbg_dev_caps(handle);
+	else if (strncmp(cmd_buf, "dev spec", 8) == 0)
+		hns3_dbg_dev_specs(handle);
 	else if (handle->ae_algo->ops->dbg_run_cmd)
 		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 	else
-- 
2.7.4

