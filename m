Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D517234C260
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhC2D7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14944 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhC2D60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zK21wKYzrc0k;
        Mon, 29 Mar 2021 11:56:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/9] net: hns3: expand the tc config command
Date:   Mon, 29 Mar 2021 11:57:52 +0800
Message-ID: <1616990273-46426-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

The device HNAE3_DEVICE_VERSION_V3 supports up to 1280 queues
and qsets for one function, so the bitwidth of tc_offset, meaning
the tqps index, needs to expand from 10 bits to 11 bits.

The device HNAE3_DEVICE_VERSION_V3 supports up to 512 queues on
one TC. The tc_size, meaning the exponent with base 2 of queues
supported on TC, which needs to expand from 3 bits to 4 bits.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h  | 7 +++++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 8a37a22..c6dc11b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -223,11 +223,14 @@ struct hclgevf_rss_indirection_table_cmd {
 };
 
 #define HCLGEVF_RSS_TC_OFFSET_S		0
-#define HCLGEVF_RSS_TC_OFFSET_M		(0x3ff << HCLGEVF_RSS_TC_OFFSET_S)
+#define HCLGEVF_RSS_TC_OFFSET_M		GENMASK(10, 0)
+#define HCLGEVF_RSS_TC_SIZE_MSB_B	11
 #define HCLGEVF_RSS_TC_SIZE_S		12
-#define HCLGEVF_RSS_TC_SIZE_M		(0x7 << HCLGEVF_RSS_TC_SIZE_S)
+#define HCLGEVF_RSS_TC_SIZE_M		GENMASK(14, 12)
 #define HCLGEVF_RSS_TC_VALID_B		15
 #define HCLGEVF_MAX_TC_NUM		8
+#define HCLGEVF_RSS_TC_SIZE_MSB_OFFSET	3
+
 struct hclgevf_rss_tc_mode_cmd {
 	__le16 rss_tc_mode[HCLGEVF_MAX_TC_NUM];
 	u8 rsv[8];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ac3afac..1682769 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -706,6 +706,9 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 			      (tc_valid[i] & 0x1));
 		hnae3_set_field(mode, HCLGEVF_RSS_TC_SIZE_M,
 				HCLGEVF_RSS_TC_SIZE_S, tc_size[i]);
+		hnae3_set_bit(mode, HCLGEVF_RSS_TC_SIZE_MSB_B,
+			      tc_size[i] >> HCLGEVF_RSS_TC_SIZE_MSB_OFFSET &
+			      0x1);
 		hnae3_set_field(mode, HCLGEVF_RSS_TC_OFFSET_M,
 				HCLGEVF_RSS_TC_OFFSET_S, tc_offset[i]);
 
-- 
2.7.4

