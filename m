Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFB11DDD6A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgEVCvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:51:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4886 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727975AbgEVCvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 22:51:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B6794C78E3C994C4A5F8;
        Fri, 22 May 2020 10:51:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 22 May 2020 10:51:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: add a resetting check in hclgevf_init_nic_client_instance()
Date:   Fri, 22 May 2020 10:49:43 +0800
Message-ID: <1590115786-9940-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
References: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

To prevent from initializing VF NIC client in reset handling state,
this patch adds resetting check in hclgevf_init_nic_client_instance().

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 32341dc..59fcb80 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2713,6 +2713,7 @@ static int hclgevf_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 					    struct hnae3_client *client)
 {
 	struct hclgevf_dev *hdev = ae_dev->priv;
+	int rst_cnt = hdev->rst_stats.rst_cnt;
 	int ret;
 
 	ret = client->ops->init_instance(&hdev->nic);
@@ -2720,6 +2721,14 @@ static int hclgevf_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 		return ret;
 
 	set_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) ||
+	    rst_cnt != hdev->rst_stats.rst_cnt) {
+		clear_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
+
+		client->ops->uninit_instance(&hdev->nic, 0);
+		return -EBUSY;
+	}
+
 	hnae3_set_client_init_flag(client, ae_dev, 1);
 
 	if (netif_msg_drv(&hdev->nic))
-- 
2.7.4

