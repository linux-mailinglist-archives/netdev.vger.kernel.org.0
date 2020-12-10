Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5472D51CF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbgLJDom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:44:42 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9423 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgLJDoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:44:20 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x5ND2z7CB5;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: adjust rss tc mode configure command
Date:   Thu, 10 Dec 2020 11:42:12 +0800
Message-ID: <1607571732-24219-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

For the max rss size of PF may be up to 512, the max queue
number of single tc may be up to 512 too. For the total queue
numbers may be up to 1280, so the queue offset of each tc may
be more than 1024. So adjust the rss tc mode configuration
command, including extend tc size field from 10 bits to 11
bits, and extend tc size field from 3 bits to 4 bits.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index a6c306b..edfadb5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -572,9 +572,11 @@ struct hclge_rss_indirection_table_cmd {
 };
 
 #define HCLGE_RSS_TC_OFFSET_S		0
-#define HCLGE_RSS_TC_OFFSET_M		GENMASK(9, 0)
+#define HCLGE_RSS_TC_OFFSET_M		GENMASK(10, 0)
+#define HCLGE_RSS_TC_SIZE_MSB_B		11
 #define HCLGE_RSS_TC_SIZE_S		12
 #define HCLGE_RSS_TC_SIZE_M		GENMASK(14, 12)
+#define HCLGE_RSS_TC_SIZE_MSB_OFFSET	3
 #define HCLGE_RSS_TC_VALID_B		15
 struct hclge_rss_tc_mode_cmd {
 	__le16 rss_tc_mode[HCLGE_MAX_TC_NUM];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5de45a9..7a16411 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4335,6 +4335,8 @@ static int hclge_set_rss_tc_mode(struct hclge_dev *hdev, u16 *tc_valid,
 		hnae3_set_bit(mode, HCLGE_RSS_TC_VALID_B, (tc_valid[i] & 0x1));
 		hnae3_set_field(mode, HCLGE_RSS_TC_SIZE_M,
 				HCLGE_RSS_TC_SIZE_S, tc_size[i]);
+		hnae3_set_bit(mode, HCLGE_RSS_TC_SIZE_MSB_B,
+			      tc_size[i] >> HCLGE_RSS_TC_SIZE_MSB_OFFSET & 0x1);
 		hnae3_set_field(mode, HCLGE_RSS_TC_OFFSET_M,
 				HCLGE_RSS_TC_OFFSET_S, tc_offset[i]);
 
-- 
2.7.4

