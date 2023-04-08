Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9FD6DBA50
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjDHK6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjDHK6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:58:20 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3011AEFBD
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcp6GilN/3z4uFFAd/rDf4RtejR+d4jiHbEiM9j5g3Oem5PRGfz1H8bK7hu0XQLmCQqedHdG4sssvMvU5/6l4KxTq53gimyNNJomLKpretVowpgAHyOpgDk02hBMmwmat6TtfcG7KuWrM3yE0nzVyxfZoyUdA59XsB23K8IXEEasJK+ZGbjlQVmywDhn2rzCv3pe7oV4Y4Aqru+SSGXrsqTN5JwQae6QR9IMnm/Dx8LbXUtxDeWKktOIrx9x2X8vWlfZtyPtZHQT/2BRxVfEZJXaZ3ko4MvkCqnAFblmej0mEVKan5u3i5YKDeDOvwsDIp6/hN8hmQDLlSvdO7Tdyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6T/SO8oUNbvbM0BdqWmJEMh6erpXxnEqaAQJA/00/OA=;
 b=IAxKWrMyCE7AtGz4A7pLb96tDX8mKUMWrrrpPzTdkqgpOyePtWNKxGdDa2BsAs9I53i5K9NpkVhBz0ZRx2VMujjPRM9Cx3G/B/zw4gmxgY/CSaWU7xAU/NUfPUc6LM7PekGvPgc1lQQGC5zIWLToJGzxoZzxyPAPkGlOxrS0XIZ3fUtIGt8WygyPzDGOsdshX15hyk2ohCZEA7KvCKcB3EMI31MXF13GhcgRd2NfypNc7vcsu1XMh0EAzvEr1Seu+7c11F19VZD4lx7rfM9mj86hgqHVA9VZXJkmFMY3ZJ8kC/b4pM5aJZVgsERabVOR/MIgdy4B5ihM55RqDhCHZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6T/SO8oUNbvbM0BdqWmJEMh6erpXxnEqaAQJA/00/OA=;
 b=OwkGy8YQmd/yamP7UXgjjDz/XZwjDgjlIJTwPDP/ajHSFK+i6nsDT7aujuxwODkbZ3ILw24KxnrdvOnc4lg7u5AqvlxL3g0KMOFFLaNkwrDQddIr2O/o1VuzEL/QH5VIG3iK+cIFsqj2FYlnh4XCFMtGWfkIol/f1XMXHl7/QRAQU6FtbfdXFYzTvgo7FUHqHJ4EncmLnuQp8bhUlwtdWJgtQz6c5Hwe/Lkay8GVKJz5Tp7HkawfUQfIo7P8Cix0O3cBEv3+8/4Kgvi/xSXG7iqS195J4zNdHQk0nkJK6M/a2ozVbOciWC3aul6Nr9rt0SpIvwQkXQi0sKAxRO8yVg==
Received: from DM6PR07CA0072.namprd07.prod.outlook.com (2603:10b6:5:74::49) by
 SA3PR12MB8048.namprd12.prod.outlook.com (2603:10b6:806:31e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.37; Sat, 8 Apr 2023 10:58:04 +0000
Received: from DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::3e) by DM6PR07CA0072.outlook.office365.com
 (2603:10b6:5:74::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36 via Frontend
 Transport; Sat, 8 Apr 2023 10:58:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT114.mail.protection.outlook.com (10.13.172.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.20 via Frontend Transport; Sat, 8 Apr 2023 10:58:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sat, 8 Apr 2023
 03:57:53 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sat, 8 Apr 2023 03:57:53 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sat, 8 Apr
 2023 03:57:51 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change support
Date:   Sat, 8 Apr 2023 13:57:35 +0300
Message-ID: <20230408105735.22935-6-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230408105735.22935-1-ehakim@nvidia.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT114:EE_|SA3PR12MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d8fe253-aea6-4a68-b41a-08db38202089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: czDcy/a0VEYUub9tyLPNSGTeDopjmei5pLEs3+ACPynrQ9WeSq9KXWpNI8V9ggRqtURRUtAE9aRNsJZ7V9PAIIPLhH6R7iIYn2VjFwLrffErIo00R/Il/givHY76yD3IYcHVzRmuU2jT/e5XhQi5xFmOsWQJUVUwLDiE23uwcpBq7r/tU8iinQkn346GlJUgAFJOTgvmM4Wlu3ei2GJbhN4ASIQYGBGDbkLrilFkxKFS+BmygxYcOy/gAS0ISkFhQISu2jdvAI+cTfrmiEETDNIavl2n5U4+g7ceRrtA//45q7Hax+p3fqIwfIxTUtC/gTzBavnBVSdDk65p9KvaKVX38DWb76ijll1PeZ/wHtsl35RJsD0s0nycw/dF+BGzGTblFtWZjoGJM0VBImqTa0oBSgCUWhKozlX5o0Pj9z7rSsmdcv4615f9J8t2lswLs1QKYAON6ciRtFzMcic7n2Px2kVmeMBookbOMno0XpZ8iFXxMcQYlEdzTYDrPLgqGWuBoHezB+16VnwYzTEJAt6DRMaR+HGijJ6Z3dCBWdh3FywQvcrQBt7lg1CWwzd/N6l5D6OIL3VF2VM6JP+f7LLbk0oa7S+EVRhJLYid0j4QR0fYEBaeNHwfqNmvItLe+2EjI1060wJq2qCJCBEpl3mx3emAOwjh4Z5e3gyFFgIellFNk/Guqczs6cd8bsRyFFYGhmh8kvE8rFN+p3pmo0BzQ5/3POWrYKETtapB0aYyj+VyjIy94XLOOsxm8Jv1
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(5660300002)(356005)(107886003)(8936002)(8676002)(36756003)(82310400005)(2906002)(7636003)(36860700001)(83380400001)(82740400003)(426003)(336012)(2616005)(4326008)(70206006)(47076005)(40480700001)(1076003)(26005)(186003)(478600001)(54906003)(7696005)(6666004)(110136005)(70586007)(316002)(41300700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 10:58:03.7811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8fe253-aea6-4a68-b41a-08db38202089
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8048
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading device drivers will mark offloaded MACsec SKBs with the
corresponding SCI in the skb_metadata_dst so the macsec rx handler will
know to which interface to divert those skbs, in case of a marked skb
and a mismatch on the dst MAC address, divert the skb to the macsec
net_device where the macsec rx_handler will be called.

Example of such a case is having a MACsec with VLAN as an inner header
ETHERNET | SECTAG | VLAN packet.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25616247d7a5..4e58d2b4f0e1 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1016,14 +1016,18 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		struct sk_buff *nskb;
 		struct pcpu_secy_stats *secy_stats = this_cpu_ptr(macsec->stats);
 		struct net_device *ndev = macsec->secy.netdev;
+		struct macsec_rx_sc *rx_sc_found = NULL;
 
 		/* If h/w offloading is enabled, HW decodes frames and strips
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
-			if (md_dst && md_dst->type == METADATA_MACSEC &&
-			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+			rx_sc_found = (md_dst && md_dst->type == METADATA_MACSEC) ?
+				      find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci) : NULL;
+
+			if (md_dst && md_dst->type == METADATA_MACSEC && !rx_sc_found) {
 				continue;
+			}
 
 			if (ether_addr_equal_64bits(hdr->h_dest,
 						    ndev->dev_addr)) {
@@ -1048,6 +1052,14 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 
 				__netif_rx(nskb);
 			}
+
+			if (md_dst && md_dst->type == METADATA_MACSEC && rx_sc_found) {
+				skb->dev = ndev;
+				skb->pkt_type = PACKET_HOST;
+				ret = RX_HANDLER_ANOTHER;
+				goto out;
+			}
+
 			continue;
 		}
 
-- 
2.21.3

