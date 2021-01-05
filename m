Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB12EA3FA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbhAEDi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:38:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10019 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbhAEDi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:38:58 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8yqP3wqGzj1Gy;
        Tue,  5 Jan 2021 11:37:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 11:38:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, "Jian Shen" <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/3] net: hns3: fix incorrect handling of sctp6 rss tuple
Date:   Tue, 5 Jan 2021 11:37:28 +0800
Message-ID: <1609817848-47370-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
References: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For DEVICE_VERSION_V2, the hardware only supports src-ip,
dst-ip and verification-tag for rss tuple set of sctp6
packet. For DEVICE_VERSION_V3, the hardware supports
src-port and dst-port as well.

Currently, when user queries the sctp6 rss tuples info,
some unsupported information will be showed on V2. So add
a check for hardware version when initializing and queries
sctp6 rss tuple to fix this issue.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 9 ++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 135bd0a..c242883 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4538,8 +4538,8 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 		req->ipv4_sctp_en = tuple_sets;
 		break;
 	case SCTP_V6_FLOW:
-		if ((nfc->data & RXH_L4_B_0_1) ||
-		    (nfc->data & RXH_L4_B_2_3))
+		if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
+		    (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)))
 			return -EINVAL;
 
 		req->ipv6_sctp_en = tuple_sets;
@@ -4731,6 +4731,8 @@ static void hclge_rss_init_cfg(struct hclge_dev *hdev)
 		vport[i].rss_tuple_sets.ipv6_udp_en =
 			HCLGE_RSS_INPUT_TUPLE_OTHER;
 		vport[i].rss_tuple_sets.ipv6_sctp_en =
+			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
+			HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT :
 			HCLGE_RSS_INPUT_TUPLE_SCTP;
 		vport[i].rss_tuple_sets.ipv6_fragment_en =
 			HCLGE_RSS_INPUT_TUPLE_OTHER;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 50a294d..ca46bc9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -107,6 +107,8 @@
 #define HCLGE_D_IP_BIT			BIT(2)
 #define HCLGE_S_IP_BIT			BIT(3)
 #define HCLGE_V_TAG_BIT			BIT(4)
+#define HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
+		(HCLGE_D_IP_BIT | HCLGE_S_IP_BIT | HCLGE_V_TAG_BIT)
 
 #define HCLGE_RSS_TC_SIZE_0		1
 #define HCLGE_RSS_TC_SIZE_1		2
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 145757c..674b3a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -917,8 +917,8 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 		req->ipv4_sctp_en = tuple_sets;
 		break;
 	case SCTP_V6_FLOW:
-		if ((nfc->data & RXH_L4_B_0_1) ||
-		    (nfc->data & RXH_L4_B_2_3))
+		if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
+		    (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)))
 			return -EINVAL;
 
 		req->ipv6_sctp_en = tuple_sets;
@@ -2502,7 +2502,10 @@ static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 		tuple_sets->ipv4_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 		tuple_sets->ipv6_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 		tuple_sets->ipv6_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_sctp_en = HCLGEVF_RSS_INPUT_TUPLE_SCTP;
+		tuple_sets->ipv6_sctp_en =
+			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
+					HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT :
+					HCLGEVF_RSS_INPUT_TUPLE_SCTP;
 		tuple_sets->ipv6_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 1b183bc..f6d817a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -122,6 +122,8 @@
 #define HCLGEVF_D_IP_BIT		BIT(2)
 #define HCLGEVF_S_IP_BIT		BIT(3)
 #define HCLGEVF_V_TAG_BIT		BIT(4)
+#define HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
+	(HCLGEVF_D_IP_BIT | HCLGEVF_S_IP_BIT | HCLGEVF_V_TAG_BIT)
 
 #define HCLGEVF_STATS_TIMER_INTERVAL	36U
 
-- 
2.7.4

