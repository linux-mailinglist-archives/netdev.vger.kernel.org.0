Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F63D3F9713
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbhH0JdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:20 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15261 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244725AbhH0JdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gwvcb6txyz87pk;
        Fri, 27 Aug 2021 17:31:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/8] net: hns3: remove redundant param mbx_event_pending
Date:   Fri, 27 Aug 2021 17:28:19 +0800
Message-ID: <1630056504-31725-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
References: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes the redundant param mbx_event_pending.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  | 12 ------------
 2 files changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 73e8bb5efc30..1de8e2deda15 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -317,7 +317,6 @@ struct hclgevf_dev {
 
 	struct hclgevf_mac_table_cfg mac_table;
 
-	bool mbx_event_pending;
 	struct hclgevf_mbx_resp_status mbx_resp; /* mailbox response */
 	struct hclgevf_mbx_arq_ring arq; /* mailbox async rx queue */
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index b339b9bc0625..50309506bb60 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -236,13 +236,6 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		case HCLGE_MBX_LINK_STAT_MODE:
 		case HCLGE_MBX_PUSH_VLAN_INFO:
 		case HCLGE_MBX_PUSH_PROMISC_INFO:
-			/* set this mbx event as pending. This is required as we
-			 * might loose interrupt event when mbx task is busy
-			 * handling. This shall be cleared when mbx task just
-			 * enters handling state.
-			 */
-			hdev->mbx_event_pending = true;
-
 			/* we will drop the async msg if we find ARQ as full
 			 * and continue with next message
 			 */
@@ -298,11 +291,6 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 	u8 flag;
 	u8 idx;
 
-	/* we can safely clear it now as we are at start of the async message
-	 * processing
-	 */
-	hdev->mbx_event_pending = false;
-
 	tail = hdev->arq.tail;
 
 	/* process all the async queue messages */
-- 
2.8.1

