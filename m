Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320402EBE50
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbhAFNLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:34 -0500
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:34081
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbhAFNLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:11:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs64OLjZC1YVJ5toXe1wBA9aG63ntq5uuBOqTp+KandvR4PJG/CX1fkw5W7ERJP36r96nvroewOVuXEpijnaFwXhW0ZlhHKB/TRBUavhi+EZQbeNSRVz7NJtsbobjYoooVTN2K74NYUetj4CVmfR4sTOplDEy4f+qdVpx6Y6qRrfSGXO6MlvQ1A0OU89opwO23rPa5CeLUBAUfAt0LS1XpyuZEMxKdpGlDr5zCfK3DMqU9WmD3VPoOp4mJ343Zd+Txn4snYpSAUwo8P6zWtSvKAob1UtHSyF3u0hlm3TFe2++wJe99XrRZv7s0WqQcjL+a5GN/LqJ+EmE8jA4NrF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl70O0M4Cf5u2s7E7HGSaJYvVT5hd9qTlnj73xumFXE=;
 b=mSbxvjkWQIY4jqWVRGPGG14MnXc08PZP3OFoC7IO85GG2REe3ue53lM32VqsuSbc2NqGUUfbwQWNomXpZakPumTS/zKj7JviQguT/EkAWQFbjwTeCc79euNjkTkyX3eTB+9pRhPhW+wHzx67W4kVOyb3ZCZf+M+4MBNdFQw3k/xufcXt7SkE0v07Bq0azf07upCcLRuFtBTvFoYE7dhZ7JEG4IVwMpGaeZZ4XCKC1bOnAQ5RJ9DIUdd76Ooy37aTvn0EZcvZPtpqJEz6FllgaT9Aai9hafrJO65AuZSz39yR5Vt96PeIyerPNQSZva2drAi85RdydZR1orL/yHYmdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl70O0M4Cf5u2s7E7HGSaJYvVT5hd9qTlnj73xumFXE=;
 b=eqqZgenQvalDgLKsDdbRI1YugPrW1kspH5KEY3VH+a9yki2vEfSaZvnJgApCJJs8GyD7WgRKii7wJ/joElScblaIQHqInSO1htrmPRo7JnNanj4ZhSZuCHPf06jXcCoISGkp5CGNpxbQj0+x2e1J0MmuzpbRd/IdcE8yQ8qBtt8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6418.eurprd05.prod.outlook.com (2603:10a6:208:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:10:24 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:10:24 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH ethtool 2/5] netlink: settings: Add netlink support for lanes parameter
Date:   Wed,  6 Jan 2021 15:10:03 +0200
Message-Id: <20210106131006.2110613-3-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106131006.2110613-1-danieller@mellanox.com>
References: <20210106131006.2110613-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:803:a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:10:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ab025fc-d65a-4077-2351-08d8b2446def
X-MS-TrafficTypeDiagnostic: AM0PR05MB6418:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB64183EDFA506A8E8C38EF20AD5D00@AM0PR05MB6418.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lekiJrK7rq1EjbNbLCRGX53lRQMoqAkyQqF+pDj3EoyX+CbmPA/uu+NSwe/0IV1LCUFQ8kwixGXdlNYp4gHPp0JDK3gB8921TozmJA0nTweD6I6o/TNe94F4DHfF59ZKe0/xeA1YYlXLy5x97/HD8yIAStsrXtr9Xwmdtv/et/Nw4VZqpliBoxnbC4vt1gy/5hVQFjpVAWt1T+C7miEK1c2Msh5XzMR2AplTa1+g9CqgZUxK9w5ZoSjE0+5t7FDmaAZw3WR6Iy2PkV5P2MGt7zZc2DUQmlHAJ3aDh1U+sFtYjd5OnLzX9KxkXg3+omqcTF+A+duo6RcZhzh8H7dXyG20nuhNq8HYBINguEL7BvHHX3dAt/0gp5jcfufva7N0eiEVot3glgJCuLPBai2glA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(26005)(8936002)(16526019)(186003)(107886003)(6486002)(6512007)(316002)(6916009)(5660300002)(6666004)(4326008)(2906002)(6506007)(956004)(2616005)(86362001)(1076003)(8676002)(66946007)(478600001)(66556008)(66476007)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5UHE/t7GdwMRKpDZ80fZ4gpQwhSI4V/egJhXP9830hqKYMsMr+gVHlMam+Iy?=
 =?us-ascii?Q?SgCyVaySg9pAeqQIKDo2+ogH/H1TUurqaG00h8JQeXgw2AYIHBgTGB7NRyQ4?=
 =?us-ascii?Q?HtwT/U1jF6wb4Y0+yCPgRAc3YICWyf/zPmEGpx2dlYoC/jHjo3johVWpdGZQ?=
 =?us-ascii?Q?13H+Vw3BmsQTCmuZ9lRq6E/1X/GiywhUS96YwgFuH8s31T0D+PiV/whZS+h4?=
 =?us-ascii?Q?8Bl/M57ZBtZIFAIDtDCoVkT1yl2TQnbVz0KOjinUph0lrLkl5DaepE/hFAdq?=
 =?us-ascii?Q?DKy54orzHTvyLSbh2ZsTm8k4FV521UvrkAQcGE9Dulqct/Ybihep3ylufQ4g?=
 =?us-ascii?Q?QBTXGuyraAdGRGB97IwLum1yBvBn0GrIkMnp67Tr4X7qmSZLlxGz7wg0z0M/?=
 =?us-ascii?Q?BpRE0x22TRJ9tXiVCu6EfDpey4nm77+tkvhP0kpEr/4P9akru4TGYaM78U8W?=
 =?us-ascii?Q?KlZ6Hlz9/PqZnMV/21GGpxSIl3UKBiN4NDWhiZhR/ct2yPwwGPJPT4aY0F9H?=
 =?us-ascii?Q?kkcXEcR0NJ5JCNnpzyHXivoNk4ljYPSUqLQShIY5EN+nF+ORnXmwWTN6wdia?=
 =?us-ascii?Q?2Ht8/SxT8fv6w/lxP8XCqd9pmFfrWzW7kG71GGQTaq/HrZzlksf2wgWpddvC?=
 =?us-ascii?Q?QGUJ9gubvFKuGyWAgE9rvGQVWcaH+M0quAMeZXvs2agBBetK2W4Ys1kT0UBa?=
 =?us-ascii?Q?IXqbjwHxMAw8S755odcuU3r6xhb/0XHNMpHWg0JTyPyXnsbWg8A3MXr2wqC8?=
 =?us-ascii?Q?tsshLhOHSvK+ZeT0yW3Qfgq4ofW5TgKX2Y6RxG76IEPNYnTP5IL9HXOqzNZu?=
 =?us-ascii?Q?Jpd73xeGx8d8fTEhUsBigfuZk6is7km4a0hUvpRuysyhcjbI7PHdM4N8N1zG?=
 =?us-ascii?Q?XiZs7OQuTFPrmIAjQS4N8a6fo+K638tdZ5mPzSls28eQaq1L0bjF+snUhThq?=
 =?us-ascii?Q?s4uC3/u/3mZAgs0pIsD4wFlFd/XJ8LA0A0kNPT8D0Cc+9RAt00kosAa2FO8A?=
 =?us-ascii?Q?8jo5?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:10:24.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab025fc-d65a-4077-2351-08d8b2446def
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqPA1YSqmQkxTN90P0r2HArYleyeR4hjsSPjj6kp/Z159gdU4VCIBe6jgE7a7EsQWeIhbXIkibCaogQ2ZJmptg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for "ethtool -s <dev> lanes N ..." for setting a specific
number of lanes.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 ethtool.c          | 1 +
 netlink/settings.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 585aafa..fcb09f7 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5620,6 +5620,7 @@ static const struct option args[] = {
 		.nlfunc	= nl_sset,
 		.help	= "Change generic options",
 		.xhelp	= "		[ speed %d ]\n"
+			  "		[ lanes %d ]\n"
 			  "		[ duplex half|full ]\n"
 			  "		[ port tp|aui|bnc|mii|fibre|da ]\n"
 			  "		[ mdix auto|on|off ]\n"
diff --git a/netlink/settings.c b/netlink/settings.c
index 90c28b1..6cb5d5b 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -20,6 +20,7 @@
 struct link_mode_info {
 	enum link_mode_class	class;
 	u32			speed;
+	u32			lanes;
 	u8			duplex;
 };
 
@@ -1067,6 +1068,13 @@ static const struct param_parser sset_params[] = {
 		.handler	= nl_parse_direct_u32,
 		.min_argc	= 1,
 	},
+	{
+		.arg		= "lanes",
+		.group		= ETHTOOL_MSG_LINKMODES_SET,
+		.type		= ETHTOOL_A_LINKMODES_LANES,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
 	{
 		.arg		= "duplex",
 		.group		= ETHTOOL_MSG_LINKMODES_SET,
-- 
2.26.2

