Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4BF2EBE39
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbhAFNHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:07:54 -0500
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:24773
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbhAFNHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:07:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV8tzSh6liqSzQp7NwzqgMPOYmCp7ZxTmY+bmdFeh1PIWcugK60nfalIW5b49CQGUo5ctpdN5schToNhN1M6xGDYuvCqPs83Q1YY66hYxwG9GA4zRWUKbLel1wpbSTpSdta+lk/VS+GMWAcsq7KSo1Zr8RWRVfCNFxKWmJ8b9E/+SIgS11a/KtdLlT05HC4KRM3nCkb9ZxT1HhrN077TMPgBimf99bONmGdETR7nUkbgYHApJShG8X6rHWRxqs2yksEHQx86FgljUSuAk1VQIlZoCnnwUWkqPZyumWnaVd/4Jv50fZtQwoMF8qhcHc/WSJ3v2bqTernPrNnHzK22Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ym3JrqXoYK2nT9AMid1b18BCMf89angICHbopd32oU=;
 b=K+7jlcC146Hve8CYtMhlDzzwaFsQxDRsRqG0hemJdCRjpRlZvstVXExZxBPCdy7LZxXIgWEkRXLusaVxJ1CLGep1hyWpbuyPKt8PcU29yl5/U3F0TMpax5Bq5LBGsmv/wiJBl73tbHblEUJSUoP2oCoXJ64AXlsnQRXpgXrJTMrdPIribBCVkOTIlW+HCTLrfFMc0GSX7AfRMyodrZqIA5JRIGWp7+01fbbAd+ymRAKGgFj4T3YOOkT1q0UANwNFb7Zf97nawysS48S509dwmzWvQAzH9GR04f5bEm/F2M3SLjftjmtAja5XosXSbNmdKBMpRyCUnY2Qo7bEKrvecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ym3JrqXoYK2nT9AMid1b18BCMf89angICHbopd32oU=;
 b=sU8MLmNLKSiLxK5N5QI2vo+niMz7jTYQiKMUMKwFeJU1Rlkbj2sDiqFmDwCcQz+hL6XoyD1sTVt0wabcBFd/mIzVpNy8VfOAjW9M4hQPuRE8mfxUfjX8mpc3b0/One4FCWX81/U2ngb9CPrXvBEh2r8hpBzDSk8QDm+I66BZ8lc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4308.eurprd05.prod.outlook.com (2603:10a6:208:62::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 13:06:43 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:43 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 2/7] ethtool: Get link mode in use instead of speed and duplex parameters
Date:   Wed,  6 Jan 2021 15:06:17 +0200
Message-Id: <20210106130622.2110387-3-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106130622.2110387-1-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 38f664e8-100c-45a0-793d-08d8b243ea22
X-MS-TrafficTypeDiagnostic: AM0PR05MB4308:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB43084E7694C457628B742A23D5D00@AM0PR05MB4308.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sh8luagnmSAuD5TLljXPAeBB+/HGc29J/ZsYsGOoqh1CFC18HjkWP1UntwE/FLtXq+9IbXZmXb78ksCsOQU9AfP4LNQyjFocBNg6U4DwvYyJtq8IkfU2i5qeWoPwRmaumlgdMn/6mPBO5yrOseNcqSKuNfMY//9UUlQ+bA/4kDjhzDF8ZJY+oYQWDoRhERFBKdjQv5+P9L4oQUt0Hc/7NocTpBid5MM7ckFZeSAhy4w46mw6YL++FLShV1muHvjlY/me5PRpeW17MOADqMitqcOWHYwz89czGYMzSC4OH1kmSodDUlSsIdYsRwBAJpYV1xGVwLlufgye2cV2f3i/KjKBUy7HnNN2uvdoVw3ud+jZAFSKcLqPcBH2Vez8rYHYDfu6qUiu0cqXo/o3RWsdYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(1076003)(186003)(478600001)(7416002)(26005)(30864003)(6506007)(16526019)(83380400001)(6486002)(4326008)(52116002)(6512007)(2616005)(2906002)(316002)(6666004)(8676002)(8936002)(956004)(66476007)(66556008)(36756003)(86362001)(5660300002)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AYV0B42Tjstj1HZzuongKEtmo74ZCRS8woqJlmZMbyM206x1EUyVoGorkD5t?=
 =?us-ascii?Q?GXDqfhbLiuivbqwBDWky5jBcM5PBlEYiEDJOoOwmOvmcLt9Ql04t749sGfw4?=
 =?us-ascii?Q?Ipv8w9Dqf06fsRRBJDNMbBRE3wAONEahHjsS7JqvIHAnGMJW3c5XIz9C5/it?=
 =?us-ascii?Q?eLJSLUmCsa/cDxZimBrUzLcKz98swVSXswhs/D7ihxoMdrjhGp0mzcF+57WX?=
 =?us-ascii?Q?JGKPBnUbF2d+aFJ7s3zDH4n9BXO7/Mvr8Sm1SjAfbFynw6wF7KrqkozUwMoO?=
 =?us-ascii?Q?ujFoNN5/ZhZKFY0vVAgF7gGtp2AEyHvQMGFCCMau0MYHt32Fg6ZTKZFhDuIq?=
 =?us-ascii?Q?XdiajxyfrsVxtRDAmKJX0bR04xS0sAcpg0GhCgG6UQETHopPoNDh6ayEcczR?=
 =?us-ascii?Q?oL67PUUKV5cNWriN67j9kEBOxJku9Cv0VC3oN1sXGGjPC40lAGQmLRHrBlIX?=
 =?us-ascii?Q?2XT8pZKYE2NqmghQYGEdnUgdz3ZkoVTcIeleehrVkRwJrH72h0l6EDAEvz8c?=
 =?us-ascii?Q?fLkFtZwqoUtEVM0lwhFGulL+0mfjd00Wp0ps+Dvwb+FTOk3JWOzOnvpBB6MJ?=
 =?us-ascii?Q?yAmGAqC49EHP2VEforWmi09xb8AyoLCd1E+itS71xI3u5mmPlE3owesOqq/X?=
 =?us-ascii?Q?9cYverkzNYCAb9bbVql2vFfsOxMRivw/CJ9L9TyU8IS5vVmVuYu+bav1Kby2?=
 =?us-ascii?Q?0JfrFOhEUACdWsMVv8bZpl2UFGd981sulJW8A5oTyRuNBlivZETtQEiqGHEO?=
 =?us-ascii?Q?GavsoiPu1fAXtPc9JSaOMObXkkGtnreIXHcIGhc4lvzSA1WGEQ9wf8Ch+x3/?=
 =?us-ascii?Q?GlkV2R1q/4tKneuaKHkgt232EyIo/1wvOp8zDW5VpKfQiDe0Oe7BXPAmwRT/?=
 =?us-ascii?Q?gSHu6PvR8FxM263k40UNAeHu0UvnoA0Sc9aeMLURbczPHjQv1xYjiBd6UdXx?=
 =?us-ascii?Q?LDHWCpwVsXvut8zi0/ysbf2BrG2kJti+4WdkU1RC8R6pCsJFDhjY0koqGNKa?=
 =?us-ascii?Q?GHPV?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:43.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f664e8-100c-45a0-793d-08d8b243ea22
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czjX+59xRNTYTbHt4a+mKRlEYaZITE8/RSXsuZWP0BguCaiu/jM9rh3l7EPehsJ8ULZ4XT9vNyVmkTYc6+BF9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when user space queries the link's parameters, as speed and
duplex, each parameter is passed from the driver to ethtool.

Instead, get the link mode bit in use, and derive each of the parameters
from it in ethtool.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |   1 +
 include/linux/ethtool.h                      |   1 +
 include/uapi/linux/ethtool.h                 |   2 +
 net/ethtool/linkmodes.c                      | 252 ++++++++++---------
 4 files changed, 137 insertions(+), 119 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 05073482db05..c21e71e0c0e8 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -406,6 +406,7 @@ Kernel response contents:
   ``ETHTOOL_A_LINKMODES_PEER``                bitset  partner link modes
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
+  ``ETHTOOL_A_LINKMODES_LINK_MODE``           u8      link mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
   ==========================================  ======  ==========================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index afae2beacbc3..668a7737a483 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -129,6 +129,7 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
 	u32	lanes;
+	enum ethtool_link_mode_bit_indices link_mode;
 };
 
 /**
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 80edae2c24f7..f61f726d1567 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1733,6 +1733,8 @@ enum ethtool_link_mode_bit_indices {
 
 #define SPEED_UNKNOWN		-1
 
+#define LINK_MODE_UNKNOWN	-1
+
 static inline int ethtool_validate_speed(__u32 speed)
 {
 	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index f41f9327436c..505a9b395fce 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -4,6 +4,127 @@
 #include "common.h"
 #include "bitset.h"
 
+struct link_mode_info {
+	int				speed;
+	u32				lanes;
+	u8				duplex;
+};
+
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
+	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
+		.speed	= SPEED_ ## _speed, \
+		.lanes	= _lanes, \
+		.duplex	= __DUPLEX_ ## _duplex \
+	}
+#define __DUPLEX_Half DUPLEX_HALF
+#define __DUPLEX_Full DUPLEX_FULL
+#define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
+	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = { \
+		.speed	= SPEED_UNKNOWN, \
+		.lanes	= ETHTOOL_LANES_UNKNOWN, \
+		.duplex	= DUPLEX_UNKNOWN, \
+	}
+
+static const struct link_mode_info link_mode_params[] = {
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
+	__DEFINE_SPECIAL_MODE_PARAMS(TP),
+	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
+	__DEFINE_SPECIAL_MODE_PARAMS(MII),
+	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
+	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
+	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
+	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
+	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
+	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
+	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
+		.speed	= SPEED_10000,
+		.duplex = DUPLEX_FULL,
+	},
+	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
+};
+
+/* LINKMODES_GET */
+
 struct linkmodes_req_info {
 	struct ethnl_req_info		base;
 };
@@ -29,7 +150,9 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
 {
 	struct linkmodes_reply_data *data = LINKMODES_REPDATA(reply_base);
 	struct net_device *dev = reply_base->dev;
+	const struct link_mode_info *link_info;
 	int ret;
+	unsigned int i;
 
 	data->lsettings = &data->ksettings.base;
 
@@ -43,6 +166,16 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
 		goto out;
 	}
 
+	if (data->ksettings.link_mode) {
+		for (i = 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; i++) {
+			if (data->ksettings.link_mode == i) {
+				link_info = &link_mode_params[i];
+				data->lsettings->speed = link_info->speed;
+				data->lsettings->duplex = link_info->duplex;
+			}
+		}
+	}
+
 	data->peer_empty =
 		bitmap_empty(data->ksettings.link_modes.lp_advertising,
 			     __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -150,125 +283,6 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 
 /* LINKMODES_SET */
 
-struct link_mode_info {
-	int				speed;
-	u32				lanes;
-	u8				duplex;
-};
-
-#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
-	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
-		.speed	= SPEED_ ## _speed, \
-		.lanes	= _lanes, \
-		.duplex	= __DUPLEX_ ## _duplex \
-	}
-#define __DUPLEX_Half DUPLEX_HALF
-#define __DUPLEX_Full DUPLEX_FULL
-#define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
-	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = { \
-		.speed	= SPEED_UNKNOWN, \
-		.lanes	= ETHTOOL_LANES_UNKNOWN, \
-		.duplex	= DUPLEX_UNKNOWN, \
-	}
-
-static const struct link_mode_info link_mode_params[] = {
-	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
-	__DEFINE_SPECIAL_MODE_PARAMS(TP),
-	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
-	__DEFINE_SPECIAL_MODE_PARAMS(MII),
-	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
-	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
-	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
-	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
-	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
-	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
-	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
-		.speed	= SPEED_10000,
-		.duplex = DUPLEX_FULL,
-	},
-	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
-};
-
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
 	[ETHTOOL_A_LINKMODES_HEADER]		=
 		NLA_POLICY_NESTED(ethnl_header_policy),
-- 
2.26.2

