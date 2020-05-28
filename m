Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CCE1E6146
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389951AbgE1Mrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:47:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53518 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389827AbgE1Mrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:47:46 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 665B7D89C7569B9AB143;
        Thu, 28 May 2020 20:46:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 20:46:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/11] net: hns3: modify an incorrect type in struct hclge_cfg_gro_status_cmd
Date:   Thu, 28 May 2020 20:45:05 +0800
Message-ID: <1590669912-21867-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify field .gro_en in struct hclge_cfg_gro_status_cmd to u8
according to the UM, otherwise, it will overwrite the reserved
byte which may be used for other purpose.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index e3bab8f..463f291 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -884,8 +884,8 @@ struct hclge_cfg_tso_status_cmd {
 
 #define HCLGE_GRO_EN_B		0
 struct hclge_cfg_gro_status_cmd {
-	__le16 gro_en;
-	u8 rsv[22];
+	u8 gro_en;
+	u8 rsv[23];
 };
 
 #define HCLGE_TSO_MSS_MIN	256
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6c84413..87473f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1456,7 +1456,7 @@ static int hclge_config_gro(struct hclge_dev *hdev, bool en)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_GRO_GENERIC_CONFIG, false);
 	req = (struct hclge_cfg_gro_status_cmd *)desc.data;
 
-	req->gro_en = cpu_to_le16(en ? 1 : 0);
+	req->gro_en = en ? 1 : 0;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-- 
2.7.4

