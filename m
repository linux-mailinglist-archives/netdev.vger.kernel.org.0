Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B201E62E6
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390609AbgE1NxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:53:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5381 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390606AbgE1NvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:51:04 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 56A3D8C3420CE5161ED8;
        Thu, 28 May 2020 21:50:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 21:50:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: modify an incorrect type in struct hclgevf_cfg_gro_status_cmd
Date:   Thu, 28 May 2020 21:48:13 +0800
Message-ID: <1590673699-63819-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
References: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify field .gro_en in struct hclgevf_cfg_gro_status_cmd to u8
according to the UM, otherwise, it will overwrite the reserved
byte which may be used for other purpose.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h  | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index f830eef..40d6e602 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -161,8 +161,8 @@ struct hclgevf_query_res_cmd {
 
 #define HCLGEVF_GRO_EN_B               0
 struct hclgevf_cfg_gro_status_cmd {
-	__le16 gro_en;
-	u8 rsv[22];
+	u8 gro_en;
+	u8 rsv[23];
 };
 
 #define HCLGEVF_RSS_DEFAULT_OUTPORT_B	4
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 59fcb80..be5789b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2403,7 +2403,7 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
 				     false);
 	req = (struct hclgevf_cfg_gro_status_cmd *)desc.data;
 
-	req->gro_en = cpu_to_le16(en ? 1 : 0);
+	req->gro_en = en ? 1 : 0;
 
 	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-- 
2.7.4

