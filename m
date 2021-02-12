Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790063198B2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhBLDWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:22:35 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12510 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhBLDW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:22:27 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJfC50kVzjMHg;
        Fri, 12 Feb 2021 11:20:19 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:21:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 06/13] net: hns3: refactor out hclge_get_rss_tuple()
Date:   Fri, 12 Feb 2021 11:21:06 +0800
Message-ID: <20210212032113.5384-7-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032113.5384-1-tanhuazhong@huawei.com>
References: <20210212032113.5384-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

To improve code readability and maintainability, separate
the flow type parsing part and the converting part from
bloated hclge_get_rss_tuple().

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 59 ++++++++++++-------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3eb675d54d6f..17090c2b6c8b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4580,52 +4580,69 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 	return 0;
 }
 
-static int hclge_get_rss_tuple(struct hnae3_handle *handle,
-			       struct ethtool_rxnfc *nfc)
+static int hclge_get_vport_rss_tuple(struct hclge_vport *vport, int flow_type,
+				     u8 *tuple_sets)
 {
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	u8 tuple_sets;
-
-	nfc->data = 0;
-
-	switch (nfc->flow_type) {
+	switch (flow_type) {
 	case TCP_V4_FLOW:
-		tuple_sets = vport->rss_tuple_sets.ipv4_tcp_en;
+		*tuple_sets = vport->rss_tuple_sets.ipv4_tcp_en;
 		break;
 	case UDP_V4_FLOW:
-		tuple_sets = vport->rss_tuple_sets.ipv4_udp_en;
+		*tuple_sets = vport->rss_tuple_sets.ipv4_udp_en;
 		break;
 	case TCP_V6_FLOW:
-		tuple_sets = vport->rss_tuple_sets.ipv6_tcp_en;
+		*tuple_sets = vport->rss_tuple_sets.ipv6_tcp_en;
 		break;
 	case UDP_V6_FLOW:
-		tuple_sets = vport->rss_tuple_sets.ipv6_udp_en;
+		*tuple_sets = vport->rss_tuple_sets.ipv6_udp_en;
 		break;
 	case SCTP_V4_FLOW:
-		tuple_sets = vport->rss_tuple_sets.ipv4_sctp_en;
+		*tuple_sets = vport->rss_tuple_sets.ipv4_sctp_en;
 		break;
 	case SCTP_V6_FLOW:
-		tuple_sets = vport->rss_tuple_sets.ipv6_sctp_en;
+		*tuple_sets = vport->rss_tuple_sets.ipv6_sctp_en;
 		break;
 	case IPV4_FLOW:
 	case IPV6_FLOW:
-		tuple_sets = HCLGE_S_IP_BIT | HCLGE_D_IP_BIT;
+		*tuple_sets = HCLGE_S_IP_BIT | HCLGE_D_IP_BIT;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (!tuple_sets)
-		return 0;
+	return 0;
+}
+
+static u64 hclge_convert_rss_tuple(u8 tuple_sets)
+{
+	u64 tuple_data = 0;
 
 	if (tuple_sets & HCLGE_D_PORT_BIT)
-		nfc->data |= RXH_L4_B_2_3;
+		tuple_data |= RXH_L4_B_2_3;
 	if (tuple_sets & HCLGE_S_PORT_BIT)
-		nfc->data |= RXH_L4_B_0_1;
+		tuple_data |= RXH_L4_B_0_1;
 	if (tuple_sets & HCLGE_D_IP_BIT)
-		nfc->data |= RXH_IP_DST;
+		tuple_data |= RXH_IP_DST;
 	if (tuple_sets & HCLGE_S_IP_BIT)
-		nfc->data |= RXH_IP_SRC;
+		tuple_data |= RXH_IP_SRC;
+
+	return tuple_data;
+}
+
+static int hclge_get_rss_tuple(struct hnae3_handle *handle,
+			       struct ethtool_rxnfc *nfc)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	u8 tuple_sets;
+	int ret;
+
+	nfc->data = 0;
+
+	ret = hclge_get_vport_rss_tuple(vport, nfc->flow_type, &tuple_sets);
+	if (ret || !tuple_sets)
+		return ret;
+
+	nfc->data = hclge_convert_rss_tuple(tuple_sets);
 
 	return 0;
 }
-- 
2.25.1

