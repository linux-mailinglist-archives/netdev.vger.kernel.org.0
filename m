Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C72F6693
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfKJCl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfKJCly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC50921019;
        Sun, 10 Nov 2019 02:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353713;
        bh=tcqXIsDZ/fwaw6bNtdBN2YjV3WXKhsfVXHfENSPcaYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dslDZ1XVeE8pEIhsNZGmj3qxlGZFqiB+y76JLtXjxfaAOS+gnA/txP0BOzf2Vwbjx
         X2Rw9Nkj49i3EzBUEeoj/bv+yCDHJX76VBo09afUgu55bPe+TXVmtZ5BKJ5q4B/SId
         XaKyb9Odm1KA5t56mk7MyncpPSsnvUAZzPeP4ohg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/191] net: hns3: Fix client initialize state issue when roce client initialize failed
Date:   Sat,  9 Nov 2019 21:37:51 -0500
Message-Id: <20191110024013.29782-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit d9f28fc23d544f673d087b00a6c7132d972f89ea ]

When roce is loaded before nic, the roce client will not be initialized
until nic client is initialized, but roce init flag is set before it.
Furthermore, in this case of nic initialized success and roce failed,
the nic init flag is not set, and roce init flag is not cleared.

This patch fixes it by set init flag only after the client is initialized
successfully.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c          | 12 +++++-------
 drivers/net/ethernet/hisilicon/hns3/hnae3.h          |  3 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |  9 +++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c    |  9 +++++++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 0594a6c3dccda..2097f92e14c5c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -29,8 +29,8 @@ static bool hnae3_client_match(enum hnae3_client_type client_type,
 	return false;
 }
 
-static void hnae3_set_client_init_flag(struct hnae3_client *client,
-				       struct hnae3_ae_dev *ae_dev, int inited)
+void hnae3_set_client_init_flag(struct hnae3_client *client,
+				struct hnae3_ae_dev *ae_dev, int inited)
 {
 	switch (client->type) {
 	case HNAE3_CLIENT_KNIC:
@@ -46,6 +46,7 @@ static void hnae3_set_client_init_flag(struct hnae3_client *client,
 		break;
 	}
 }
+EXPORT_SYMBOL(hnae3_set_client_init_flag);
 
 static int hnae3_get_client_init_flag(struct hnae3_client *client,
 				       struct hnae3_ae_dev *ae_dev)
@@ -86,14 +87,11 @@ static int hnae3_match_n_instantiate(struct hnae3_client *client,
 	/* now, (un-)instantiate client by calling lower layer */
 	if (is_reg) {
 		ret = ae_dev->ops->init_client_instance(client, ae_dev);
-		if (ret) {
+		if (ret)
 			dev_err(&ae_dev->pdev->dev,
 				"fail to instantiate client, ret = %d\n", ret);
-			return ret;
-		}
 
-		hnae3_set_client_init_flag(client, ae_dev, 1);
-		return 0;
+		return ret;
 	}
 
 	if (hnae3_get_client_init_flag(client, ae_dev)) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 67befff0bfc50..f5c7fc9c5e5cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -521,4 +521,7 @@ void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo);
 
 void hnae3_unregister_client(struct hnae3_client *client);
 int hnae3_register_client(struct hnae3_client *client);
+
+void hnae3_set_client_init_flag(struct hnae3_client *client,
+				struct hnae3_ae_dev *ae_dev, int inited);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 671144d1f14ac..5b579a740e5d1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5476,6 +5476,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				goto clear_nic;
 			}
 
+			hnae3_set_client_init_flag(client, ae_dev, 1);
+
 			if (hdev->roce_client &&
 			    hnae3_dev_roce_supported(hdev)) {
 				struct hnae3_client *rc = hdev->roce_client;
@@ -5487,6 +5489,9 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				ret = rc->ops->init_instance(&vport->roce);
 				if (ret)
 					goto clear_roce;
+
+				hnae3_set_client_init_flag(hdev->roce_client,
+							   ae_dev, 1);
 			}
 
 			break;
@@ -5498,6 +5503,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 			if (ret)
 				goto clear_nic;
 
+			hnae3_set_client_init_flag(client, ae_dev, 1);
+
 			break;
 		case HNAE3_CLIENT_ROCE:
 			if (hnae3_dev_roce_supported(hdev)) {
@@ -5513,6 +5520,8 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				ret = client->ops->init_instance(&vport->roce);
 				if (ret)
 					goto clear_roce;
+
+				hnae3_set_client_init_flag(client, ae_dev, 1);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 83fcdd326de71..beae1e2cd59b1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1631,6 +1631,8 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 		if (ret)
 			goto clear_nic;
 
+		hnae3_set_client_init_flag(client, ae_dev, 1);
+
 		if (hdev->roce_client && hnae3_dev_roce_supported(hdev)) {
 			struct hnae3_client *rc = hdev->roce_client;
 
@@ -1640,6 +1642,9 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			ret = rc->ops->init_instance(&hdev->roce);
 			if (ret)
 				goto clear_roce;
+
+			hnae3_set_client_init_flag(hdev->roce_client, ae_dev,
+						   1);
 		}
 		break;
 	case HNAE3_CLIENT_UNIC:
@@ -1649,6 +1654,8 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 		ret = client->ops->init_instance(&hdev->nic);
 		if (ret)
 			goto clear_nic;
+
+		hnae3_set_client_init_flag(client, ae_dev, 1);
 		break;
 	case HNAE3_CLIENT_ROCE:
 		if (hnae3_dev_roce_supported(hdev)) {
@@ -1665,6 +1672,8 @@ static int hclgevf_init_client_instance(struct hnae3_client *client,
 			if (ret)
 				goto clear_roce;
 		}
+
+		hnae3_set_client_init_flag(client, ae_dev, 1);
 	}
 
 	return 0;
-- 
2.20.1

