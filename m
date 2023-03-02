Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE16A7F84
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCBKDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCBKCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:02:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8F943910
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:01:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToSVmtKJZPuykejOyOCA/PGK9MoId1qVSVqw+F3EowOfSCyZF839me4sQZN+8IyNjNARYkGlKKAjqfz0rjh9y+MKYUQQL9mNwdHpBGUbwIXRQTnyY3NcEAst1r34IzJ5BSegKu7eJCOdeEWL/pp1REGNUV6BXNppv/jJwzhQmsXQvaGOj1R8ljKLilfZpKF/baWVE+zYUTlPqSkIeWGPXJpMTwPblD/0kjtoqCry+6HPxOll8ODjPt7TwXK0TGe/uvXa6e2uJ22X9CeFuo4u3CxZfryy50V77paE/QpdJTPteeLcxCDuJTVlsFCgxW4jAe7YXBH3z4/97GKvejYzhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Em64dQQd2jTFUpuNzXAO82pd4eDvPmO78PCBw01qtOc=;
 b=JJlZHDIrQczQhKIIQbptmIBMnQxKTyAaDfMLKheEGpKcNiZmQKjnEH1zZjfqn+7W2OgzbXFYEzd/AG2jiMy+dk/+G45KwayISTxbL+MpT3VSsc736wpTmLaBdR7yFhvZPv5vV5r+hURAsAN5+swX6WHR2P5X7Y8I84uxsivbKLP47OjEIoX2vXY6FGpnKdTzoD4ESmWfuSJzxmanWXEV9BQ1DPkA8zeAZXSv23VmBD3YpdPkzCTL9dc2VCBLdzpuUueoAbZjAxEcXOFbrGf+2NrstjMzMSDGojU0ldY0LG1adYkRanVoutq9WOyXV7l0taR/sAauD/kaHqHzzN4VeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Em64dQQd2jTFUpuNzXAO82pd4eDvPmO78PCBw01qtOc=;
 b=HJSEuYP++/GRipmq2k2nWqq4T2vswo22g6Myr6Gdn7tuimcpz5d7odtES+CY2bD8moZdVWhbGPPEP/HCfqV0Zm6wbzutDqoxxXrYUok+6abtp2Ll/MxmSssf96/cXMK3pAJLJ6pmyWA7tJ6OX8rcjBHLLgGFc86E9QGIXHquBMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5692.namprd13.prod.outlook.com (2603:10b6:a03:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 09:58:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 09:58:58 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 1/3] nfp: fix incorrectly set csum flag for nfd3 path
Date:   Thu,  2 Mar 2023 10:58:28 +0100
Message-Id: <20230302095830.2512535-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230302095830.2512535-1-simon.horman@corigine.com>
References: <20230302095830.2512535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0008.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5692:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bdfd4c2-e859-43f8-209e-08db1b04bda9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wg9ixQJuwtwqtFKwzmlwxf+6owWRm9q5AjEDqcKheORwrc1zkj/68JhJuIRgoXhBiNkANTQCpnA5s1Ap1y1R7FhntOJPRVe/V8gOe7K+lsTxW5WS5xmiSE5zzsk/TFmEHtmwx5qx1JXPN59UuoJC4UK3s7g421JU56i7KL0xmUvMvJMHNYR6kmmN9yVbRHn97/QHlt0ocQavJmgrkX3Sm9sRaZp/fvA8PUFfufg8SLYYzd5woQ0AsZQRToFP+BS7os0T6WLMH/72qKmq/L1HMexvP+jjptG9Bb8ilHPeXJ/tYG2raWVSFSO/qoJOLRGBlPUgxJ5OoDKZlk2igbIQo5zxQldqRafE0MwcKUoBs02ukOZ4OLuLOIwvl+H6NHLlpAL17/EoPg7tt5GK0WTt2cgC83Kg8lV3BqhnkPeCGMiPR8Jtk2m1Bo3c9DR4sYg+tVgMUjZXWECnmMMDkNKZFLP10zgXDduh3U0lv88cQb5CNDA/01GGZq9L8eQLG9U9uEvY2Jvu1KHo1Rs5AYFr6OhWSMgTQhnWF+hjM6F1O1BK3zf6SbSDdBT5LrHAefw9BzdXkgCaNi4eAYRGjSXDOxCi9KjJbgMDv7mvS7VZUSkrnM9/XZe8xsl8hklVeJZx6S4hZSQQ83AaILs4cXm1hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(366004)(39840400004)(451199018)(5660300002)(2616005)(44832011)(6666004)(54906003)(107886003)(110136005)(52116002)(38100700002)(6486002)(478600001)(41300700001)(186003)(36756003)(6512007)(8936002)(6506007)(1076003)(316002)(4326008)(86362001)(66556008)(66476007)(8676002)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kTElDPwy2hb2m++Qhnsxo5fMUC88HeVxgv8KR6jvT10PVOef2v66ejjofaFY?=
 =?us-ascii?Q?7yBmif4UZS1MEnojQwIxkGAEHlF/bNKdlNwAEdKSmwLFEoHpln81Edjo5+5B?=
 =?us-ascii?Q?BBAR2BjSbqPRg8gIPKHNHnMmsKrhJjfyJdnkJLy4NgsPXR5gYPEfdaLnkQbq?=
 =?us-ascii?Q?PebtfL8neUzgaKWZ1z0z5VRnPFUwW1IIiqdmdySy08i+q4TRdet/uWMheKzU?=
 =?us-ascii?Q?O5KXp55PJCD47WMrDZRGUPOHNinB/tHddlXaEOiPdwYHyp3qcnLxjjYHjmHN?=
 =?us-ascii?Q?hdMwqDSIEpU1oZ7Aa/hku9/W2bfUd/YiwuOXKM3qfMGEXHaLiyol6Qkqem12?=
 =?us-ascii?Q?lnZ/Xjg25sNHQTdhriLC+3oxHca0qONzffVqxZvHFsr1rZB7maLuoskr26gp?=
 =?us-ascii?Q?XNJV7XJjuOuh/MQwkwlrVeXfgs1XXkDqNweD0x0mjFRKjp+Gg3VQgCDFVHyD?=
 =?us-ascii?Q?91UMFWz+X3hsDN4cLLXWFw8ohst/64kCWvgFUfxFAiUlXdEeyC6SpWlNeO37?=
 =?us-ascii?Q?3EsC141dyItttht2sQzsFkStQhU/EkeNyanLQ5gjCZmX44yiKUDFQ2ZKm8Ny?=
 =?us-ascii?Q?V7QqL4lVkB2Qo/K7mARmlV4lXMtNW2sNq5snzZTO5bsUASVYM7LL92EfqJIC?=
 =?us-ascii?Q?gAtWFXFQHuna5t+w/d7iij0aZAj0P4KMiqbjUUzhc1Sy7RvWsQbj26H10Y9t?=
 =?us-ascii?Q?BRqBjFf7aT5H4xf1ntd6y3U/T1MY0cV4+QkPKIbMr8/iDRFmHFtQ4yraFM94?=
 =?us-ascii?Q?BS3IYyKEoJ+OiMtOaNsI/jgLnxPmewRxT7UIsQz6/idNSs8eJzhAQFWUzxvH?=
 =?us-ascii?Q?K0bkDBENeRSnnuvDx4Jggral/uTSNA3el+X7Jv3IbggwJNpJC+Z2rS051lRk?=
 =?us-ascii?Q?CIXvBnck0XI3JOEpiAVrODArhl1STcgvv2wPKVb05ZIIcPsBIp2+ZwQo6Lq7?=
 =?us-ascii?Q?p1TOJauWRPiCqV1pPTM9KDaGFwuBSsGQZNdmWZQ0xu0Ce8hYGSTrj6mCjsYC?=
 =?us-ascii?Q?UTJoOoPGIvyg2PEY/PC1fiwCLCAMEmUkMagk+FBJ4RV47c1eg9bmJaavlslP?=
 =?us-ascii?Q?O0872v3C3lKlwCuAF5YpHTCLMpk9fMosHH/f+MGEDDBGIARbwbhyWz8FhIvG?=
 =?us-ascii?Q?EBn6z/tZIrVEgvtQFVrcdxOGS18K5vuWNIhcKGR0xUjUKOgvxywW54hYkgjf?=
 =?us-ascii?Q?s32luOIhoMZubLg64iJA6YCogg3D/ProsgInXFwGIxnhk5f4DXg9ZRqNZTtS?=
 =?us-ascii?Q?pD6w8R7FEIcf4YyRDrZ5RZDmxIZAQEL/GXGgVr5ucRVDgZyxXiBQxlJroWhb?=
 =?us-ascii?Q?8RyecTAhePzDLLsvP+yCb6KC7kja5RZPmp/oa49Mlc7/BwgVoIMlYUoJ6HZY?=
 =?us-ascii?Q?FAmf2tWp8WneQPNG+KG3KrfXQlkKwlHNtR5PQnMvJjWXiwNtEFJ9NVE44GVK?=
 =?us-ascii?Q?VvVyPgbYOXOmaf+x/4RucKMtnlnA6Gs4b4n6eEL5cQ7FYelBvCEvbTj4RH8i?=
 =?us-ascii?Q?xLh+6lPqGOfJVAZTYBwZbDhGksBfaW/ogtSB0PRg8grXhYYNwSXp4C3ufPM9?=
 =?us-ascii?Q?So/O8Qo5SPCmrkYLF9Y45C2JprK0GAHVDY//O8h7EtoTyd8AXzgt+xoo+G30?=
 =?us-ascii?Q?qBKRDoajsSx86O+UEPxqsBRdks8yeCJr4ZmK8JB1ClCDASyFWdWLLUBoMUlO?=
 =?us-ascii?Q?mvLyeg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bdfd4c2-e859-43f8-209e-08db1b04bda9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 09:58:58.0883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAoXKrC8uGs3T/QolDkaKChaKZXdQraPyVJ8E7+DaYEp8E2luC3Lbh7+wSP30ImRt5WXhMao2DeWK1Gwsajm54bKHoBVwBEOBAJhbwxF8ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

The csum flag of IPsec packet are set repeatedly. Therefore, the csum
flag set of IPsec and non-IPsec packet need to be distinguished.

As the ipv6 header does not have a csum field, so l3-csum flag is not
required to be set for ipv6 case.

L4-csum flag include the tcp csum flag and udp csum flag, we shouldn't
set the udp and tcp csum flag at the same time for one packet, should
set l4-csum flag according to the transport layer is tcp or udp.

Fixes: 57f273adbcd4 ("nfp: add framework to support ipsec offloading")
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  7 +++---
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   | 25 +++++++++++++++++--
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 59fb0583cc08..0cc026b0aefd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -324,14 +324,15 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Do not reorder - tso may adjust pkt cnt, vlan may override fields */
 	nfp_nfd3_tx_tso(r_vec, txbuf, txd, skb, md_bytes);
-	nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
+	if (ipsec)
+		nfp_nfd3_ipsec_tx(txd, skb);
+	else
+		nfp_nfd3_tx_csum(dp, r_vec, txbuf, txd, skb);
 	if (skb_vlan_tag_present(skb) && dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN) {
 		txd->flags |= NFD3_DESC_TX_VLAN;
 		txd->vlan = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
 
-	if (ipsec)
-		nfp_nfd3_ipsec_tx(txd, skb);
 	/* Gather DMA */
 	if (nr_frags > 0) {
 		__le64 second_half;
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
index e90f8c975903..51087693072c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
@@ -10,9 +10,30 @@
 void nfp_nfd3_ipsec_tx(struct nfp_nfd3_tx_desc *txd, struct sk_buff *skb)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	struct iphdr *iph = ip_hdr(skb);
+	int l4_proto;
 
 	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)) {
-		txd->flags |= NFD3_DESC_TX_CSUM | NFD3_DESC_TX_IP4_CSUM |
-			      NFD3_DESC_TX_TCP_CSUM | NFD3_DESC_TX_UDP_CSUM;
+		txd->flags |= NFD3_DESC_TX_CSUM;
+
+		if (iph->version == 4)
+			txd->flags |= NFD3_DESC_TX_IP4_CSUM;
+
+		if (x->props.mode == XFRM_MODE_TRANSPORT)
+			l4_proto = xo->proto;
+		else if (x->props.mode == XFRM_MODE_TUNNEL)
+			l4_proto = xo->inner_ipproto;
+		else
+			return;
+
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			txd->flags |= NFD3_DESC_TX_UDP_CSUM;
+			return;
+		case IPPROTO_TCP:
+			txd->flags |= NFD3_DESC_TX_TCP_CSUM;
+			return;
+		}
 	}
 }
-- 
2.30.2

