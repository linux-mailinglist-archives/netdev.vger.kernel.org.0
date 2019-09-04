Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E521BA887F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbfIDOJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:09:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730538AbfIDOJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 10:09:15 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9FA0317EC205F5978486;
        Wed,  4 Sep 2019 22:09:13 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 22:09:05 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: add client node validity judgment
Date:   Wed, 4 Sep 2019 22:06:43 +0800
Message-ID: <1567606006-39598-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
References: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
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
index 528f624..6aa5257 100644
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
+		pr_err("client %s not existed!\n", client->name);
+		return;
+	}
+
 	/* un-initialize the client on every matched port */
 	list_for_each_entry(ae_dev, &hnae3_ae_dev_list, node) {
 		hnae3_uninit_client_instance(client, ae_dev);
-- 
2.7.4

