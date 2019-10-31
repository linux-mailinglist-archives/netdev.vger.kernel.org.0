Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4CEAECF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfJaLXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbfJaLXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 111BB76FE63356C68244;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/9] net: hns3: optimize local variable initialization
Date:   Thu, 31 Oct 2019 19:23:21 +0800
Message-ID: <1572521004-36126-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

The variable tx_ring is unnecessary to be initialized as it will be set
before used, and the variable rst_cnt is better to be initialized when
declaration for simplification.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 23bdfe8..82ed9c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1771,7 +1771,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = hns3_get_handle(ndev);
-	struct hns3_enet_ring *tx_ring = NULL;
+	struct hns3_enet_ring *tx_ring;
 	struct napi_struct *napi;
 	int timeout_queue = 0;
 	int hw_head, hw_tail;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 69ab86a..3002527 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8992,10 +8992,9 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 {
 	struct hnae3_client *client = vport->nic.client;
 	struct hclge_dev *hdev = ae_dev->priv;
-	int rst_cnt;
+	int rst_cnt = hdev->rst_stats.reset_cnt;
 	int ret;
 
-	rst_cnt = hdev->rst_stats.reset_cnt;
 	ret = client->ops->init_instance(&vport->nic);
 	if (ret)
 		return ret;
-- 
2.7.4

