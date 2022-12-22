Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44960653C3A
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbiLVGnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLVGnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:43:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05E72189C
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:43:46 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nd12r1YHbzJqSG;
        Thu, 22 Dec 2022 14:42:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 22 Dec 2022 14:43:45 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <huangguangbin2@huawei.com>,
        <wangjie125@huawei.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net 2/3] net: hns3: fix miss L3E checking for rx packet
Date:   Thu, 22 Dec 2022 14:43:42 +0800
Message-ID: <20221222064343.61537-3-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221222064343.61537-1-lanhao@huawei.com>
References: <20221222064343.61537-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For device supports RXD advanced layout, the driver will
return directly if the hardware finish the checksum
calculate. It cause missing L3E checking for ip packets.
Fixes it.

Fixes: 1ddc028ac849 ("net: hns3: refactor out RX completion checksum")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0ec5730b1788..b4c4fb873568 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3855,18 +3855,16 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	return 0;
 }
 
-static bool hns3_checksum_complete(struct hns3_enet_ring *ring,
+static void hns3_checksum_complete(struct hns3_enet_ring *ring,
 				   struct sk_buff *skb, u32 ptype, u16 csum)
 {
 	if (ptype == HNS3_INVALID_PTYPE ||
 	    hns3_rx_ptype_tbl[ptype].ip_summed != CHECKSUM_COMPLETE)
-		return false;
+		return;
 
 	hns3_ring_stats_update(ring, csum_complete);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->csum = csum_unfold((__force __sum16)csum);
-
-	return true;
 }
 
 static void hns3_rx_handle_csum(struct sk_buff *skb, u32 l234info,
@@ -3926,8 +3924,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 		ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
 					HNS3_RXD_PTYPE_S);
 
-	if (hns3_checksum_complete(ring, skb, ptype, csum))
-		return;
+	hns3_checksum_complete(ring, skb, ptype, csum);
 
 	/* check if hardware has done checksum */
 	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
@@ -3936,6 +3933,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
 				 BIT(HNS3_RXD_OL3E_B) |
 				 BIT(HNS3_RXD_OL4E_B)))) {
+		skb->ip_summed = CHECKSUM_NONE;
 		hns3_ring_stats_update(ring, l3l4_csum_err);
 
 		return;
-- 
2.30.0

