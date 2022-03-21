Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505964E2489
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346443AbiCUKoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346439AbiCUKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C296C14966E
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBss1r/x81XkVlu0/MIVrjqQ1rZuB8bJbfutpAqkWLzoAiN1Y7d2pFcZkkrLy5oOtTY3KcXceE1bOMnuyU5ix9iNUUOOMhP7N1A4Lf96DEtKZsyfBYnBZYuvqCjXQsSXsuC8CKtAdoghqtDoAYMIOzaB5P5CNjLwRTomc5rn3jiLboEaV0mDRTG0o/WyPC7CHL5ns9wD5oaLW+ArCjDdwQIwu8S06TwM3d+tuvZzGBafqepLiJpPuLzDYE6DFS/0CC8ANAOQczn17Ka0ch/SWTkumZSSkrJAJMfDAo8cysKApAshXWZk/m2Q9mW4817Mg9tuaHusade65XQIQJTX+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZriSPFFVghuObPtOO1ichRMXSWu/dQVevKAhkZ0ASs=;
 b=HV1SQAHYA+ki0jAd38QKMqzLq08TyG5Q1RWi8WvRm87hr9dTj4C/XhelTtPT2QhjxYSKWe0r4h1wm3uDeGFqUC64CgJZJC2tviycAgsw7aYgrZAH7uf1MrvW1ApbkTXcznenBLnL+8+4Rfn2aTCXrEzfu9hcrY22H8EciIZzEEa5a1OfFxyM5t8U9hktSsHAWt8DtuJa43lX4PR+BSO11O9ZVLNiVhetqRk/KfSptcS8HYZV84k+2XSDOtniN9kJ6vqR9bT9nSYUAW+eixP/OeZemWTTNSe4XXQY2glQZ4q5Cbyo1Cvxt9XDeo6P1M2el+/hnC+9WYc5zyDHhSgF3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZriSPFFVghuObPtOO1ichRMXSWu/dQVevKAhkZ0ASs=;
 b=koBvVi1KBEbQadDlELtwx8N7PxQy/jYrCnrXcPEeYUxeYoVLrwHw5kf/Ej4oMmK1XSv0XiFzGtTnuCFWQTP+khYzOzS51wjX7uiEFAPrTIc/EwaMu/1creiBeVSHqHIpUAId8KzFJVWp+VD/t9LEdKVg7+apRh7PfAH4ew9H0j0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:35 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 07/10] nfp: add per-data path feature mask
Date:   Mon, 21 Mar 2022 11:42:06 +0100
Message-Id: <20220321104209.273535-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe9334c6-f9eb-4432-fefa-08da0b27830f
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB151245EB94D50319547700F0E8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iswJy6JCiIdu/vW2fQFuThbRGyR5XCuCBbVzes9/dDRcSlp9qfoSvuHVQzy7R3ckEpj0gyWjL9+fRhQIjcMg9MyTFHriUoz6kheLruh4whH/FgZxN5yZ0trzQdNB7I4lH5mmyYrsniMb3IC2cTgv0zjDphOg+x0nqALTe2Kt2enqibBIk6pfGJPrTqFUDJNIgmDcv2zJsvg3XXkavbFlBqBfZ/uiw7kNCAeOZYszKxntXAU0d9fN0TpqhTIsOWp/IV1aMJVIqrXaO2vVe9cC+7I8ZmoxM4TEJvWwezSKyllvLB/FXfhkqBlJICWZjJkafdE/ESJioLg7wLwGEhN/ItwaF1Vih7U7SQGe6hjl7AVRZJX7YV3w6cYCSZFv1MJKJOVEJrbc1wXLl0kPX7c/ELtK6MYyc1rkpBHNX6U3J93fDcBRT6OX1ZhFomI/mlAawwaYGTpqgoFHLoxUeIdFIKf4IjTUJyGUpLeXNQ4R8BLIunNa5O9HD/fZp2IO9+xSZJyKIip+GDTpthhTEyqdcscwGI5WEoKK7voPAGmMIIjeZ0DGbF4nItBOnRCIsHPVI13pS0iCBiyBboSMVAbI+BHzi90EWuLmoDcvDEa+smxZCvQmw/pjLq5zlZLXL1zeYsflKug+DxUpKEeKnlPW7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8t0gEDEUse/6e6PFj/yWy2ay5+PYdj3g4gSrMUMEu8A2kdphHGTyngZqaj6A?=
 =?us-ascii?Q?DhzXZZvKsxVWKBZsiBBQ5GwpdME25EUd3/j7OnPZIOVJQzZHuf88Jkl5gH3j?=
 =?us-ascii?Q?XcjgjiVSuPrEyOIzjf4hodSLm4uSHOBuMeK01tN58wYOrrtT9gHrQKQefamy?=
 =?us-ascii?Q?luZOSzzCnvCaWcbxNtEvtGZT9VWJRnPnb6ED2ipf23k/gal4Njq9PjLo2PFX?=
 =?us-ascii?Q?8C3mwDV1QHp3kOiny13lTQQHnuOIgf9UGeKBohyxWQZTYg3lW+g9oB5agYBv?=
 =?us-ascii?Q?a2OZTGDhdeMXbJlXDxGr/yLTUcRNy9ta2TwmcP3lWSIbF3ngnlTREdt3oW5w?=
 =?us-ascii?Q?/4h7J39ZhHkEHSOpYc0Z7sn28CCOAugO1EsuEaJmVauhL9ZUpbVHp6ppHA6T?=
 =?us-ascii?Q?RfXUhvdz5VMUwau8t1oAk/NAeMhdHrTBStKO1SHoI8OJ2Ip0M3FKReB1l/X0?=
 =?us-ascii?Q?/5SQOpavouFIInMAkXYghedaqbuOMqIibcXXlMldLEoZr0pc4M+o9FGJE+ts?=
 =?us-ascii?Q?fDmB8kRlJD8MfP19MYOWtolWeo0rNEL9MalgNYsABmPRy05JrRPocr6IgFOr?=
 =?us-ascii?Q?5uDK8tlFFyYncQo8qoDWYmj4jOwnfN514eeaKhpOquaYhlSvbIkWkMDsOiZK?=
 =?us-ascii?Q?3E+BvcrAgg8vfB7dQsP92p1ncqoxM+75sY/a7VQu7hSopEmhTf1+vWBmpz85?=
 =?us-ascii?Q?2+KhzMpRCrqKKdaV3vDx8DDtE5U5NuM7oh+/aAXTwmKq38cBXm14FYbYidaC?=
 =?us-ascii?Q?KbO9+RmGSZEiTBZNA/IyzWxuzWSQYjiRclBGHMrWLC+Gtbu3n6JwLE3A0nhn?=
 =?us-ascii?Q?lP3Rg3HDVTLfhVMwivdQba1/w/6xk3d9g8lDRt94vEFOMDNohe64vGHWeWDO?=
 =?us-ascii?Q?4r8GOi6FZ2rOo71nNUBDqqFiJYJsPF30OyTqj+whWKu733D5jO0kc985h33W?=
 =?us-ascii?Q?Elv4KZ2o5gVluD/s/IbReQZVmfj0EDRQsKB5epX0lUGkistisZbY6rfi4qFa?=
 =?us-ascii?Q?J6FsYLpNdKirbrw94uV6rYLca5ysC4i05SN0/OF5HNFTKXIZCIz+AqRf8cgQ?=
 =?us-ascii?Q?m+YaSrTFHgS9nqbht5RiOxm4d8IWwh8JQKiyPs+DdapXZzFoYsjLYuX3qJ/E?=
 =?us-ascii?Q?W5M54x1ppcFOdR9bNLya41NnnqueBNV36FF3t7Pz3EGtkkDZqSINadbvmqYa?=
 =?us-ascii?Q?7DfKhLVZiKaFgYIzj81ZuC3YIf1166613IIOtXAiMuOCfMmFspHv9GgBcbRd?=
 =?us-ascii?Q?b9ZP3UH5LxPCeMr6G69H06dTf/aCi/IKNu4KV0BcTcUEc+yT8GkW9zUVZCJw?=
 =?us-ascii?Q?gbYK9zXM/g+WW03cjufirqdT+J1Cm36iqDqM9PIiZ7vN00jghW35vVv+SZ/T?=
 =?us-ascii?Q?C3YRT9o1/RyrRBm/F8m77FUFvr3u2nqUsvU8NiDo05deWbINywj0lhzui0FC?=
 =?us-ascii?Q?9fOqMsrvUKs0XhaDKzfl/Dpb/buVk00yb69oIDVF1gF85OKeV74nVHnDcMbV?=
 =?us-ascii?Q?QD6TvQVC/HydhsSHdBgIr7sYkWAFzZTpDj7I6KTjGPHK+2e+t352HSCd/g?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9334c6-f9eb-4432-fefa-08da0b27830f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:35.7777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iq2L3K50VKFSFO56eJFgZXL6jq3pQnkUJ+Ia4sBJemNtIVuP7kh9sSpYrqbEJDfcO15noI6LoBVJy3tILmjbOD7k8E7hViK0ZyXZgQWzJSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Make sure that features supported only by some of the data paths
are not enabled for all.  Add a mask of supported features into
the data path op structure.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/rings.c   | 15 +++++++++++++++
 .../net/ethernet/netronome/nfp/nfp_net_common.c   |  3 +++
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h   |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 3ebbedd8ba64..47604d5e25eb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -242,9 +242,24 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 	}
 }
 
+#define NFP_NFD3_CFG_CTRL_SUPPORTED					\
+	(NFP_NET_CFG_CTRL_ENABLE | NFP_NET_CFG_CTRL_PROMISC |		\
+	 NFP_NET_CFG_CTRL_L2BC | NFP_NET_CFG_CTRL_L2MC |		\
+	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
+	 NFP_NET_CFG_CTRL_RXVLAN | NFP_NET_CFG_CTRL_TXVLAN |		\
+	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
+	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
+	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_RSS |		\
+	 NFP_NET_CFG_CTRL_IRQMOD | NFP_NET_CFG_CTRL_TXRWB |		\
+	 NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE |		\
+	 NFP_NET_CFG_CTRL_BPF | NFP_NET_CFG_CTRL_LSO2 |			\
+	 NFP_NET_CFG_CTRL_RSS2 | NFP_NET_CFG_CTRL_CSUM_COMPLETE |	\
+	 NFP_NET_CFG_CTRL_LIVE_ADDR)
+
 const struct nfp_dp_ops nfp_nfd3_ops = {
 	.version		= NFP_NFD_VER_NFD3,
 	.tx_min_desc_per_pkt	= 1,
+	.cap_mask		= NFP_NFD3_CFG_CTRL_SUPPORTED,
 	.poll			= nfp_nfd3_poll,
 	.xsk_poll		= nfp_nfd3_xsk_poll,
 	.ctrl_poll		= nfp_nfd3_ctrl_poll,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5cac5563028c..331253149f50 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2303,6 +2303,9 @@ static int nfp_net_read_caps(struct nfp_net *nn)
 		nn->dp.rx_offset = NFP_NET_RX_OFFSET;
 	}
 
+	/* Mask out NFD-version-specific features */
+	nn->cap &= nn->dp.ops->cap_mask;
+
 	/* For control vNICs mask out the capabilities app doesn't want. */
 	if (!nn->dp.netdev)
 		nn->cap &= nn->app->type->ctrl_cap_mask;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 99579722aacf..237ca1d9c886 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -115,6 +115,7 @@ enum nfp_nfd_version {
  * struct nfp_dp_ops - Hooks to wrap different implementation of different dp
  * @version:			Indicate dp type
  * @tx_min_desc_per_pkt:	Minimal TX descs needed for each packet
+ * @cap_mask:			Mask of supported features
  * @poll:			Napi poll for normal rx/tx
  * @xsk_poll:			Napi poll when xsk is enabled
  * @ctrl_poll:			Tasklet poll for ctrl rx/tx
@@ -131,6 +132,7 @@ enum nfp_nfd_version {
 struct nfp_dp_ops {
 	enum nfp_nfd_version version;
 	unsigned int tx_min_desc_per_pkt;
+	u32 cap_mask;
 
 	int (*poll)(struct napi_struct *napi, int budget);
 	int (*xsk_poll)(struct napi_struct *napi, int budget);
-- 
2.30.2

