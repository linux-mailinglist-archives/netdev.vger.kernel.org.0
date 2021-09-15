Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3055840C6D5
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhION5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:49 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9877 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbhION5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:38 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H8hTf08Xfz8yTH;
        Wed, 15 Sep 2021 21:51:50 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 6/6] net: hns3: fix a return value error in hclge_get_reset_status()
Date:   Wed, 15 Sep 2021 21:52:11 +0800
Message-ID: <20210915135211.9129-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915135211.9129-1-huangguangbin2@huawei.com>
References: <20210915135211.9129-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

hclge_get_reset_status() should return the tqp reset status.
However, if the CMDQ fails, the caller will take it as tqp reset
success status by mistake. Therefore, uses a parameters to get
the tqp reset status instead.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 14e9daf09f8c..47fea8985861 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10726,7 +10726,8 @@ static int hclge_reset_tqp_cmd_send(struct hclge_dev *hdev, u16 queue_id,
 	return 0;
 }
 
-static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id)
+static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id,
+				  u8 *reset_status)
 {
 	struct hclge_reset_tqp_queue_cmd *req;
 	struct hclge_desc desc;
@@ -10744,7 +10745,9 @@ static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id)
 		return ret;
 	}
 
-	return hnae3_get_bit(req->ready_to_reset, HCLGE_TQP_RESET_B);
+	*reset_status = hnae3_get_bit(req->ready_to_reset, HCLGE_TQP_RESET_B);
+
+	return 0;
 }
 
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id)
@@ -10763,7 +10766,7 @@ static int hclge_reset_tqp_cmd(struct hnae3_handle *handle)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	u16 reset_try_times = 0;
-	int reset_status;
+	u8 reset_status;
 	u16 queue_gid;
 	int ret;
 	u16 i;
@@ -10779,7 +10782,11 @@ static int hclge_reset_tqp_cmd(struct hnae3_handle *handle)
 		}
 
 		while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
-			reset_status = hclge_get_reset_status(hdev, queue_gid);
+			ret = hclge_get_reset_status(hdev, queue_gid,
+						     &reset_status);
+			if (ret)
+				return ret;
+
 			if (reset_status)
 				break;
 
-- 
2.33.0

