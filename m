Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D256F3877CC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 13:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbhERLhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 07:37:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3583 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbhERLhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 07:37:34 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fkv5Q21NMzsRYy;
        Tue, 18 May 2021 19:33:30 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:15 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 4/4] net: hns3: check the return of skb_checksum_help()
Date:   Tue, 18 May 2021 19:36:03 +0800
Message-ID: <1621337763-61946-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
References: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently skb_checksum_help()'s return is ignored, but it may
return error when it fails to allocate memory when linearizing.

So adds checking for the return of skb_checksum_help().

Fixes: 76ad4f0ee747("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Fixes: 3db084d28dc0("net: hns3: Fix for vxlan tx checksum bug")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6d6c0ac..026558f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -841,8 +841,6 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 	      l4.udp->dest == htons(4790))))
 		return false;
 
-	skb_checksum_help(skb);
-
 	return true;
 }
 
@@ -919,8 +917,7 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 			/* the stack computes the IP header already,
 			 * driver calculate l4 checksum when not TSO.
 			 */
-			skb_checksum_help(skb);
-			return 0;
+			return skb_checksum_help(skb);
 		}
 
 		hns3_set_outer_l2l3l4(skb, ol4_proto, ol_type_vlan_len_msec);
@@ -965,7 +962,7 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 		break;
 	case IPPROTO_UDP:
 		if (hns3_tunnel_csum_bug(skb))
-			break;
+			return skb_checksum_help(skb);
 
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4T_S,
@@ -990,8 +987,7 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 		/* the stack computes the IP header already,
 		 * driver calculate l4 checksum when not TSO.
 		 */
-		skb_checksum_help(skb);
-		return 0;
+		return skb_checksum_help(skb);
 	}
 
 	return 0;
-- 
2.7.4

