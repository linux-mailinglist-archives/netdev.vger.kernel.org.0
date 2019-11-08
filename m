Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382A5F4AB5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbfKHLjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387848AbfKHLjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D87921D82;
        Fri,  8 Nov 2019 11:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213182;
        bh=N1pWcBOj31y9uIOAZtMAT/3HfEKBzIxyzNdyyjpV8zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2L+Lh6ZPQjmjhp6ut7Cq/RO+atC16L/oB3MYmyTZSPvlWQT82QXnYl8bWZEypTmxP
         2eR/yLRXCISu1qTsCQTEBg6xv8w2ukQtyFC/gTt/5c13fFdEb4QUtLv52zwso5DFsA
         VvM39UCKM1UuYfYfWmhpZVs/rmW76oz5jifeEezc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 073/205] net: hns3: Fix for loopback selftest failed problem
Date:   Fri,  8 Nov 2019 06:35:40 -0500
Message-Id: <20191108113752.12502-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 0f29fc23b21d3cbd966537bfabba07c00466b787 ]

Tqp and mac need to be enabled when doing loopback selftest,
ae_algo->ops->start/stop is used to do the job, there is a
time window between ae_algo->ops->start/stop and loopback setup,
which will cause selftest failed problem when there is frame
coming in during that time window.

This patch fixes it by enabling the tqp and mac during loopback
setup process.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 17 +------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 51 +++++++++++--------
 2 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6a3c6b02a77cd..5bdcd92d86122 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -100,41 +100,26 @@ static int hns3_lp_up(struct net_device *ndev, enum hnae3_loop loop_mode)
 	struct hnae3_handle *h = hns3_get_handle(ndev);
 	int ret;
 
-	if (!h->ae_algo->ops->start)
-		return -EOPNOTSUPP;
-
 	ret = hns3_nic_reset_all_ring(h);
 	if (ret)
 		return ret;
 
-	ret = h->ae_algo->ops->start(h);
-	if (ret) {
-		netdev_err(ndev,
-			   "hns3_lb_up ae start return error: %d\n", ret);
-		return ret;
-	}
-
 	ret = hns3_lp_setup(ndev, loop_mode, true);
 	usleep_range(10000, 20000);
 
-	return ret;
+	return 0;
 }
 
 static int hns3_lp_down(struct net_device *ndev, enum hnae3_loop loop_mode)
 {
-	struct hnae3_handle *h = hns3_get_handle(ndev);
 	int ret;
 
-	if (!h->ae_algo->ops->stop)
-		return -EOPNOTSUPP;
-
 	ret = hns3_lp_setup(ndev, loop_mode, false);
 	if (ret) {
 		netdev_err(ndev, "lb_setup return error: %d\n", ret);
 		return ret;
 	}
 
-	h->ae_algo->ops->stop(h);
 	usleep_range(10000, 20000);
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0e7c92f624e91..0cf33fa351df3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3666,6 +3666,8 @@ static int hclge_set_mac_loopback(struct hclge_dev *hdev, bool en)
 	/* 2 Then setup the loopback flag */
 	loop_en = le32_to_cpu(req->txrx_pad_fcs_loop_en);
 	hnae3_set_bit(loop_en, HCLGE_MAC_APP_LP_B, en ? 1 : 0);
+	hnae3_set_bit(loop_en, HCLGE_MAC_TX_EN_B, en ? 1 : 0);
+	hnae3_set_bit(loop_en, HCLGE_MAC_RX_EN_B, en ? 1 : 0);
 
 	req->txrx_pad_fcs_loop_en = cpu_to_le32(loop_en);
 
@@ -3726,15 +3728,36 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en)
 		return -EIO;
 	}
 
+	hclge_cfg_mac_mode(hdev, en);
 	return 0;
 }
 
+static int hclge_tqp_enable(struct hclge_dev *hdev, int tqp_id,
+			    int stream_id, bool enable)
+{
+	struct hclge_desc desc;
+	struct hclge_cfg_com_tqp_queue_cmd *req =
+		(struct hclge_cfg_com_tqp_queue_cmd *)desc.data;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
+	req->tqp_id = cpu_to_le16(tqp_id & HCLGE_RING_ID_MASK);
+	req->stream_id = cpu_to_le16(stream_id);
+	req->enable |= enable << HCLGE_TQP_ENABLE_B;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"Tqp enable fail, status =%d.\n", ret);
+	return ret;
+}
+
 static int hclge_set_loopback(struct hnae3_handle *handle,
 			      enum hnae3_loop loop_mode, bool en)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	int ret;
+	int i, ret;
 
 	switch (loop_mode) {
 	case HNAE3_MAC_INTER_LOOP_MAC:
@@ -3750,27 +3773,13 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 		break;
 	}
 
-	return ret;
-}
-
-static int hclge_tqp_enable(struct hclge_dev *hdev, int tqp_id,
-			    int stream_id, bool enable)
-{
-	struct hclge_desc desc;
-	struct hclge_cfg_com_tqp_queue_cmd *req =
-		(struct hclge_cfg_com_tqp_queue_cmd *)desc.data;
-	int ret;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
-	req->tqp_id = cpu_to_le16(tqp_id & HCLGE_RING_ID_MASK);
-	req->stream_id = cpu_to_le16(stream_id);
-	req->enable |= enable << HCLGE_TQP_ENABLE_B;
+	for (i = 0; i < vport->alloc_tqps; i++) {
+		ret = hclge_tqp_enable(hdev, i, 0, en);
+		if (ret)
+			return ret;
+	}
 
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Tqp enable fail, status =%d.\n", ret);
-	return ret;
+	return 0;
 }
 
 static void hclge_reset_tqp_stats(struct hnae3_handle *handle)
-- 
2.20.1

