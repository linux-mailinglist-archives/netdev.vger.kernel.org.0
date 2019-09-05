Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BAAAA486
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfIENeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:34:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbfIENeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 09:34:16 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CBD99A2AE7AF5875337C;
        Thu,  5 Sep 2019 21:34:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 21:34:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 4/7] net: hns3: add client node validity judgment
Date:   Thu, 5 Sep 2019 21:31:39 +0800
Message-ID: <1567690302-16648-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567690302-16648-1-git-send-email-tanhuazhong@huawei.com>
References: <1567690302-16648-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

HNS3 driver can only unregister client which included in hnae3_client_list.
This patch adds the client node validity judgment.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 528f624..03ca7d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -138,12 +138,28 @@ EXPORT_SYMBOL(hnae3_register_client);
 
 void hnae3_unregister_client(struct hnae3_client *client)
 {
+	struct hnae3_client *client_tmp;
 	struct hnae3_ae_dev *ae_dev;
+	bool existed = false;
 
 	if (!client)
 		return;
 
 	mutex_lock(&hnae3_common_lock);
+
+	list_for_each_entry(client_tmp, &hnae3_client_list, node) {
+		if (client_tmp->type == client->type) {
+			existed = true;
+			break;
+		}
+	}
+
+	if (!existed) {
+		mutex_unlock(&hnae3_common_lock);
+		pr_err("client %s does not exist!\n", client->name);
+		return;
+	}
+
 	/* un-initialize the client on every matched port */
 	list_for_each_entry(ae_dev, &hnae3_ae_dev_list, node) {
 		hnae3_uninit_client_instance(client, ae_dev);
-- 
2.7.4

