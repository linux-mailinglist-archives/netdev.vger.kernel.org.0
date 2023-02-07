Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C75A68D3EA
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjBGKRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjBGKRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:17:42 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC142384F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:17:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bhuc02aB8G9bJ6mPTNDaJNI8ArcEWXsG6gz2gBf9FtSBGy9h/j80EfhHATr4X4VdyyqkkwP6iRREK+WHcrH1ITFOOTk7vA/wG6zmntges0NtHoO6H2IMygzyK4qRLz4GKlC9JuSc34+f1SVQerv+RQOvR5+OUl56W77SX4qwdIip43ZUhjss+BtqVgyCG4sXCVnqyNlf16ZcirJr2yGUMNHngvRV+dg2ZYS5eQeHVllJw7+SPqMkKy8GummP0beTvStJMsrnXk6oL5kQQCDE+bSYsNvdtqu7IgkGlTQJA/oCz/MvYIipwpJj8J9qmg8LEZOfhTba2kXiFM9m/fTtxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=411VCj+qL4jObja54X8UimhYK9Djz0PFgk1JIglpGlQ=;
 b=E3gShtZAXoeLPiKaw3VoGAhoIQL3/myfmfRXa3PX5idgP8uUFORUljBBdky3BIbASOpeHX+SSUAmuHwKUovT4l+7LFuimBhKAUpHvSGCK9Wuf9ejUIxANorYIZwV+oCvb0YugWBG40BEfMzCoV+HGuIg9eHVfWCYejtwF7VGTZPFvIjgAZ2ruIjd7aO1IgwJkiQb3xenvn07JNVV5dyQRuIQOQuytceeh7NB9svvpepVlGC8PScx/4UPBormR7EvZAtgoYV7lsstUpjGqq7rv8532o5kXHfdEw3bPBrCD053G7Vy5KJbxZWaPdXlp85MgWZd6QRU7MXBKcafOWgFDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=411VCj+qL4jObja54X8UimhYK9Djz0PFgk1JIglpGlQ=;
 b=FcdTApfjsFcgEBlEZnRxqfWz3QiethEmelvAvIaLrSfqwmBVUURXy/isfW56SPbkPzk96ncpEmUzMB1wJJ+zzcjQLeQTokiUnDCbcqBzpRV1v/ARN7t7ZZv55JPrCtMFy4ZQFlpt3157vmxQCOFpmoa/eSX0i/mLnvXPzW7IwSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5759.namprd13.prod.outlook.com (2603:10b6:806:216::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 10:17:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 10:17:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: ethtool: fix the bug of setting unsupported port speed
Date:   Tue,  7 Feb 2023 11:16:50 +0100
Message-Id: <20230207101650.2827218-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0141.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5759:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f945a1-3d00-4dd9-50b0-08db08f488b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HhiioGBOK4AAuJFPMWyT/xuruzWfVDKl3DE2th2cfSPnJnXlL96KHHasXXmHLFWW6D6fgnbtvl7VVV0odkZggfrl+gY5iPittbpw+m5AYj4OTTFBUHRkkam1y0CAdxq0MzS94xy7iADrKLFhBn4KpPO6vb928LguWQwMJQ2CP0VXIMRS8uAI8iFh9GkRKAxy6zXNKWAFlYzrO1NvRNsW8ds23T6BD5PhKoWstyWdLmYioyL7MlrOhZMGEtWo9HS+p1vnrMmuwvrWBYa9tyj5FCQoRp8cJXo8IfRmIvn0yhZ8FFCfyKmxHz650h63pEZ7rU9oRcWz9ddYRT/oONuAeFCS038Plo/RUVBPcKSEbpHTcothSdY7Ir6GzjRXrMF3SUlgZnGORKl+KQaCsPgbQp6NzEGYqNBGALJSUk6Ic1jN8zUzLKuirvaMmktjjRq5w2200fcWTwH5jUhQHWfPgeyQVi82U0RBEnZZeAo51gwDxG92SDR0GmzDHqaDZONuov2NK1lW87otg4xRMnIc26hhMQdwdgsSzyKGALh1v1dB82ZhWdBa5LrxOvyUwogSSz621pvyU6D58d1jAE+7ARTVeK+pkCgxOtpcLv3VQN0tuI8eKr56Te/+W8JD9+PKuqFOa3ykrqTLCdy4VQK8eymTNxdG15j+OFPp9BLF93BXnBk2rV0HRbaW3Gq4aiQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(346002)(396003)(39840400004)(451199018)(36756003)(1076003)(107886003)(6666004)(52116002)(6486002)(6506007)(478600001)(2616005)(186003)(6512007)(8936002)(41300700001)(316002)(5660300002)(8676002)(4326008)(66476007)(66556008)(66946007)(2906002)(44832011)(110136005)(54906003)(30864003)(86362001)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8A05HspRbkXa9hR3HzjVgUHthrpkPriHnlyA4lIpSW7LxjqMzdOjNgvPqzsc?=
 =?us-ascii?Q?9RiaByvUEW0rZuCdXSwljFbSMlb01B7bIl3Lv7MVFYclUbK+HE5XgNev8gyt?=
 =?us-ascii?Q?jKumq93q7XC0nbkfDBkovd68O6kizfFhg6G42guUDYkz5Y6nlJG+IRCncTCg?=
 =?us-ascii?Q?hrZXXZCY1OQX/1U89cjrIS4/q1kRJcRHsGXmfSwbCGC+tKnXJHkwD8B2yDEF?=
 =?us-ascii?Q?KmhcQO1jbpoVvRJ5nH2CYkXe1qzchmRrRrylNfjfEdNJOJhEZWq4QDnymERs?=
 =?us-ascii?Q?ucfVO7a2yE/q6rmyEPSTVXN7uDQmVcJCOKYoY5qwEEMYSn6f+YSwRh1UGdkg?=
 =?us-ascii?Q?sjEZzbpZc7kO7BBHhv222jEV+4jbo9eHtwdNcQSUazZuCxTQQ3NoVatsBKB+?=
 =?us-ascii?Q?Z3HeVdYSoHcelE4ylmKqBWcpBRlY9BGwI4tUktj6YC1M3ZWgiaFg0nM59NJ5?=
 =?us-ascii?Q?sDEngAuNDdH6IlvrgLDwq27B985pmfWXIqI+Pkv/ImAx/MEPhPsz09m9shI0?=
 =?us-ascii?Q?dy/8pe6QNvAGUh9ulj+yMeXBUh4JfDjDJxGTe0JlL3eMSAw+2nexBR7XwbIp?=
 =?us-ascii?Q?LXB1xX5HyJhKvHbUwN+3PUP++T3sbelMbmPhRXfcDE+1q0q5VqujeQTn8oHH?=
 =?us-ascii?Q?yk4+w6v7zrO7dwHjS73BhcfAHQA1fqWyfey92+yw/2PW0jbd9Z+KFK85R14a?=
 =?us-ascii?Q?KvBVQ5/jt5rwhPUT3Dqb9MAsPzsIFnNsYHDmk99NKomx9uDR+XeFAE7ba0md?=
 =?us-ascii?Q?xEP+tZ83g1i0TVbbNcqCMijJyh5Q4jbt5bqx+KIOozcf3q34/h8+kvD8XCmp?=
 =?us-ascii?Q?kJb9Cv3qbfRcQWuFgBeTVkYqO2n0LXgZ+kL2MauY+UNvIyXVpJBuGKv8N6cY?=
 =?us-ascii?Q?GrGtlIoZ2cK1sBzbBA16Mfn/64YJwsduftOude9rotrRPj2ohgFyKPrVoIhS?=
 =?us-ascii?Q?pNrjDNJSqKBssVXz12J2PN2KM/SBIYvkDO6PwQndnuchHpAhjr4zTFo4iWmK?=
 =?us-ascii?Q?SaFCV5O0fUw4hM1Ye039c2oSVKvsZezPmHi6E+In0T8NBtnXvwnkieYtJkyG?=
 =?us-ascii?Q?IuR78E15RywojMBBuyd+3AqISlsBvegouy3rgMgNZgM7esm9e/QQcaGJDdqB?=
 =?us-ascii?Q?30/QMrPIIvPf7/vDQ5bfh+v0GCGkQhsOVB7/ZIEUKSf+6/6gyL+ic+/RM1RM?=
 =?us-ascii?Q?KC1iV/5rwXbvO2sdpAAdi9DQZhIVq/LT5BschHvzwvJRxtpbuCvL4JwI8tyH?=
 =?us-ascii?Q?ZRkkXFp8NXrE2h68tBRs6qhTwCUk9I6YbMCumMtf1ujFgibZGiOGXiDwupOc?=
 =?us-ascii?Q?todru2oRs6LkCl19GwfhsbPzHrbRnL3l4mfE2lQISqmmpOAEMu7QhoQ+o6l2?=
 =?us-ascii?Q?DpXF1ug9M2JmQZkDAqtRilozpzO3qSn83tcURYhVEBPvsAKmkQ8ghAvmfbAW?=
 =?us-ascii?Q?rGVZoOJtUgUQjuEYDEUqOhG9tm9l46NFmSLJSjiUT6rW6X/81SvKTBJNfxcs?=
 =?us-ascii?Q?u8MaBqXitw0YAYPPaiSyTjoIRmDwCsmoYqm3T0LRDLEd0zbvwktQl193Jt0x?=
 =?us-ascii?Q?c6C5Fd35h47jfURORzcYwJgg0vPy/EPdzQvAFGmwi8zpbCQF4MchWsX/OSNw?=
 =?us-ascii?Q?UU/eznNQv4IvLRTR2XfVCBg/7D3q5cotHml/dEj+t7F+R9GXs4UoJeqDEVqA?=
 =?us-ascii?Q?9kZGrA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f945a1-3d00-4dd9-50b0-08db08f488b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:17:36.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AnzRHLDAyS655sf1FsBXrR1Qm9qjg2qljTSV23hWu8tItYusgKKxCK0MreKya2ZpmLZPre/St3SRYXGpi9OHBg2YcnwmacNPsjIFo+n/90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5759
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Unsupported port speed can be set and cause error. Now fixing it
and return an error if setting unsupported speed.

This fix depends on the following, which was included in v6.2-rc1:
commit a61474c41e8c ("nfp: ethtool: support reporting link modes").

Fixes: 7c698737270f ("nfp: add support for .set_link_ksettings()")
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 194 ++++++++++++++----
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  12 ++
 2 files changed, 170 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index a4a89ef3f18b..cc97b3d00414 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -293,35 +293,131 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
 	}
 }
 
-static const u16 nfp_eth_media_table[] = {
-	[NFP_MEDIA_1000BASE_CX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-	[NFP_MEDIA_1000BASE_KX]		= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-	[NFP_MEDIA_10GBASE_KX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-	[NFP_MEDIA_10GBASE_KR]		= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-	[NFP_MEDIA_10GBASE_CX4]		= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-	[NFP_MEDIA_10GBASE_CR]		= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
-	[NFP_MEDIA_10GBASE_SR]		= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
-	[NFP_MEDIA_10GBASE_ER]		= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
-	[NFP_MEDIA_25GBASE_KR]		= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-	[NFP_MEDIA_25GBASE_KR_S]	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-	[NFP_MEDIA_25GBASE_CR]		= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-	[NFP_MEDIA_25GBASE_CR_S]	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-	[NFP_MEDIA_25GBASE_SR]		= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
-	[NFP_MEDIA_40GBASE_CR4]		= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
-	[NFP_MEDIA_40GBASE_KR4]		= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
-	[NFP_MEDIA_40GBASE_SR4]		= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
-	[NFP_MEDIA_40GBASE_LR4]		= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
-	[NFP_MEDIA_50GBASE_KR]		= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
-	[NFP_MEDIA_50GBASE_SR]		= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
-	[NFP_MEDIA_50GBASE_CR]		= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
-	[NFP_MEDIA_50GBASE_LR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	[NFP_MEDIA_50GBASE_ER]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	[NFP_MEDIA_50GBASE_FR]		= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	[NFP_MEDIA_100GBASE_KR4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_SR4]	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_CR4]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_KP4]	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-	[NFP_MEDIA_100GBASE_CR10]	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+static const struct nfp_eth_media_link_mode {
+	u16 ethtool_link_mode;
+	u16 speed;
+} nfp_eth_media_table[NFP_MEDIA_LINK_MODES_NUMBER] = {
+	[NFP_MEDIA_1000BASE_CX] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed			= NFP_SPEED_1G,
+	},
+	[NFP_MEDIA_1000BASE_KX] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed			= NFP_SPEED_1G,
+	},
+	[NFP_MEDIA_10GBASE_KX4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_CX4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_10GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+		.speed			= NFP_SPEED_10G,
+	},
+	[NFP_MEDIA_25GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_KR_S] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_CR_S] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_25GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_25G,
+	},
+	[NFP_MEDIA_40GBASE_CR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_KR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_SR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_40GBASE_LR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+		.speed			= NFP_SPEED_40G,
+	},
+	[NFP_MEDIA_50GBASE_KR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_SR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_CR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_LR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_ER] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_50GBASE_FR] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		.speed			= NFP_SPEED_50G,
+	},
+	[NFP_MEDIA_100GBASE_KR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_SR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_CR4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_KP4] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+	[NFP_MEDIA_100GBASE_CR10] = {
+		.ethtool_link_mode	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed			= NFP_SPEED_100G,
+	},
+};
+
+static const unsigned int nfp_eth_speed_map[NFP_SUP_SPEED_NUMBER] = {
+	[NFP_SPEED_1G]		= SPEED_1000,
+	[NFP_SPEED_10G]		= SPEED_10000,
+	[NFP_SPEED_25G]		= SPEED_25000,
+	[NFP_SPEED_40G]		= SPEED_40000,
+	[NFP_SPEED_50G]		= SPEED_50000,
+	[NFP_SPEED_100G]	= SPEED_100000,
 };
 
 static void nfp_add_media_link_mode(struct nfp_port *port,
@@ -334,8 +430,12 @@ static void nfp_add_media_link_mode(struct nfp_port *port,
 	};
 	struct nfp_cpp *cpp = port->app->cpp;
 
-	if (nfp_eth_read_media(cpp, &ethm))
+	if (nfp_eth_read_media(cpp, &ethm)) {
+		bitmap_fill(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
 		return;
+	}
+
+	bitmap_zero(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
 
 	for (u32 i = 0; i < 2; i++) {
 		supported_modes[i] = le64_to_cpu(ethm.supported_modes[i]);
@@ -344,20 +444,26 @@ static void nfp_add_media_link_mode(struct nfp_port *port,
 
 	for (u32 i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; i++) {
 		if (i < 64) {
-			if (supported_modes[0] & BIT_ULL(i))
-				__set_bit(nfp_eth_media_table[i],
+			if (supported_modes[0] & BIT_ULL(i)) {
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.supported);
+				__set_bit(nfp_eth_media_table[i].speed,
+					  port->speed_bitmap);
+			}
 
 			if (advertised_modes[0] & BIT_ULL(i))
-				__set_bit(nfp_eth_media_table[i],
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.advertising);
 		} else {
-			if (supported_modes[1] & BIT_ULL(i - 64))
-				__set_bit(nfp_eth_media_table[i],
+			if (supported_modes[1] & BIT_ULL(i - 64)) {
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.supported);
+				__set_bit(nfp_eth_media_table[i].speed,
+					  port->speed_bitmap);
+			}
 
 			if (advertised_modes[1] & BIT_ULL(i - 64))
-				__set_bit(nfp_eth_media_table[i],
+				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.advertising);
 		}
 	}
@@ -468,6 +574,22 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 
 	if (cmd->base.speed != SPEED_UNKNOWN) {
 		u32 speed = cmd->base.speed / eth_port->lanes;
+		bool is_supported = false;
+
+		for (u32 i = 0; i < NFP_SUP_SPEED_NUMBER; i++) {
+			if (cmd->base.speed == nfp_eth_speed_map[i] &&
+			    test_bit(i, port->speed_bitmap)) {
+				is_supported = true;
+				break;
+			}
+		}
+
+		if (!is_supported) {
+			netdev_err(netdev, "Speed %u is not supported.\n",
+				   cmd->base.speed);
+			err = -EINVAL;
+			goto err_bad_set;
+		}
 
 		if (req_aneg) {
 			netdev_err(netdev, "Speed changing is not allowed when working on autoneg mode.\n");
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index f8cd157ca1d7..9c04f9f0e2c9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -38,6 +38,16 @@ enum nfp_port_flags {
 	NFP_PORT_CHANGED = 0,
 };
 
+enum {
+	NFP_SPEED_1G,
+	NFP_SPEED_10G,
+	NFP_SPEED_25G,
+	NFP_SPEED_40G,
+	NFP_SPEED_50G,
+	NFP_SPEED_100G,
+	NFP_SUP_SPEED_NUMBER
+};
+
 /**
  * struct nfp_port - structure representing NFP port
  * @netdev:	backpointer to associated netdev
@@ -52,6 +62,7 @@ enum nfp_port_flags {
  * @eth_forced:	for %NFP_PORT_PHYS_PORT port is forced UP or DOWN, don't change
  * @eth_port:	for %NFP_PORT_PHYS_PORT translated ETH Table port entry
  * @eth_stats:	for %NFP_PORT_PHYS_PORT MAC stats if available
+ * @speed_bitmap:	for %NFP_PORT_PHYS_PORT supported speed bitmap
  * @pf_id:	for %NFP_PORT_PF_PORT, %NFP_PORT_VF_PORT ID of the PCI PF (0-3)
  * @vf_id:	for %NFP_PORT_VF_PORT ID of the PCI VF within @pf_id
  * @pf_split:	for %NFP_PORT_PF_PORT %true if PCI PF has more than one vNIC
@@ -78,6 +89,7 @@ struct nfp_port {
 			bool eth_forced;
 			struct nfp_eth_table_port *eth_port;
 			u8 __iomem *eth_stats;
+			DECLARE_BITMAP(speed_bitmap, NFP_SUP_SPEED_NUMBER);
 		};
 		/* NFP_PORT_PF_PORT, NFP_PORT_VF_PORT */
 		struct {
-- 
2.30.2

