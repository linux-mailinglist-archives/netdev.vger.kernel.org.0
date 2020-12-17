Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46C02DCDFC
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgLQI7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:59:03 -0500
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:41230
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727304AbgLQI7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:59:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K77PBXj8SjFqVwECUHM4SrpByzOSNtRTAMO5VstQRy1GCh5ZcTVsZvxxGjjnLLxtTmuQ0bu567hUYI78aBFowMk1NMTAzEqMIN82iShT1PkMd1l7rtJvI16Fl0XCPDYqyrwH3dXWm8oQpyBHcm5i56/0TM7zGjMZg/rqk77UonHJO0JH0NjJhKR2e9IEM7JmFRMM9LmEkcHjlm8viBwT8i2vaXJx+E4RTbkLSqj7U4MHwInz+B6UwdSHF/JMtr6O6raUQedJ+nl8eqcb9dEcLXCYwByCpcuQixpU8hMB8F+yUyLzFKxh7EXhMsQKQ4N4i/L9RrFFdvzY0VE6+KHRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ym3JrqXoYK2nT9AMid1b18BCMf89angICHbopd32oU=;
 b=IPEax9WB5Ud/X1gAQoilyXUb1Yl+zIwav70kxUF2tBdQT72wxcxH+ojnWXUHQt2U0xx1IWzs6oUC3YelpnIRJMqoctr6+rw+BTXMVuhFa4aEf8e7NFQwjG4P0usTZnVrno8UuNk6Q7uuZYUgO1le2IQ5Mx5CnZQPjPAvi49jryhZYzLRR4Py35njmvgRb21I4mmeVKjvep+6Mwd3FD2WFwqdaF/zSbPOE1YqO8w6fgsf37woI6dSRG7DlxHk6+Fw034STwjxwKNoJZBi/OU4uhQxyJmVkClkmWaBM/AK+dBQemEvJDh5BLGllhFxPWpxByXxX0mPEv033h1B280p+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ym3JrqXoYK2nT9AMid1b18BCMf89angICHbopd32oU=;
 b=G3r3mlk4PPof3uegvCUYzdq4Ym4BF8aBNWSi6d3hX+/ZbAqmqKHNN9O6L3yACmtSl8GuNMy4lnimL7km15LC81/hRJveCgDXaQeJZZw/cTVMylat+148So1o3BonrbILI2VtgGbGB71KQbs8npuYISdEh4QfTAhmTrcs0+2rgT4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:33 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:33 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 2/7] ethtool: Get link mode in use instead of speed and duplex parameters
Date:   Thu, 17 Dec 2020 10:57:12 +0200
Message-Id: <20201217085717.4081793-3-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: abeb8d40-34eb-47a3-f45f-08d8a269cad7
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674AFD1FE466079F33A18BDD5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rt1LVjapbebk0RPrie62vh19/vLWEdMLivPkwc1UYaeYpeEGExF/Q7/1zck2OhXajjg22kDwkl/Ux/eOuW/k7wfY1d9tCrbH7XVnPBjtvbMTj+zA41bMLqIn4Z5ILwGSI2vj7dYQc2VYuP1o6LF5y8Ra1urSpAxiI7upiGO64a7HZiIGICNuia78DTXaVAlNXv7rvRfE9uwe9Ok2+Ybdr4GswJlyE8R8n657s57cgtPKYGzrZw6fldSDqT28Fs470RGexR7JPdWrR7uHXPtTCLyE6uv/a6uaox3QSR5oDYlyPdeRbZR6Rsh8xf8EvkyzEeWkF9hvmuTkMdqh68q8SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(30864003)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tyiU5jiEhdInwS1TAV78Kk/upOjwk1F0NOCm1aBinad6zqtFw56ePDdrSyY3?=
 =?us-ascii?Q?R+dIiksoUOIWmxfHYuBKl4NhQkK2ZZHRpsOmDHssCh4Rx1ASHbcctHQnqXyl?=
 =?us-ascii?Q?yQcY2UMSw5hthvmoxfZf15hUxCbBvSEXmjq1lAdGo5KWqMoGLfQ491LUd4E7?=
 =?us-ascii?Q?9xri2zHBR7HmgUzmo8sndXY8INJFc0SGT42OeNrSTnRThi8HvbTLQ/Ed9cjw?=
 =?us-ascii?Q?aHLbTtzekt+Wupd2sq5Uu/ga7/FwR8cwhcxGYFMjcEnGRxekx+bfs6cpwPdq?=
 =?us-ascii?Q?yNolxL5bcQjkOiw+jeqjTo6AHyWdd0DbfeGDizUMeZ75vI6xpiYikwhTMu2c?=
 =?us-ascii?Q?TC4xUPH8KOtoXJKeNa3GYlHy1AmzOjvVULvFioZxYszx6oyL3HXxXl2P+S1x?=
 =?us-ascii?Q?Gm0g2bo3RzW0Me/FnvjjbRnv84Ch/nK1XaEWb5iZknEJeECW587BtKEid2pA?=
 =?us-ascii?Q?+2Aw78H3wKmkYTvWrU0caMFSyOlrISbFsqjKHxRLcZlQSLCQv/jhIdov7Vvd?=
 =?us-ascii?Q?6TrS3raIq8uh0fWlvK/vqlPkPsQdSuI1/KqC+YjF/3JXPFSreQfNFFIMA1oo?=
 =?us-ascii?Q?826lSn+6H+G6o7rxjBdzu9RyoxU0joBREKqaucqKKdNw83SEKiO99mZMpU5B?=
 =?us-ascii?Q?lnGQdkd8CN3UbKcVrYg1WMznzQ7yhn/Cqt/mU33wmY3Pq8ZgOxc2hDdw6h33?=
 =?us-ascii?Q?sKQ+HBo6Bg7qdsyLzAgBKF448mGeDQs7wB2DIQPpoOd6QB3sa6DcDug3RKuu?=
 =?us-ascii?Q?D7NR8BclYRRmhrS51fvVc1Ti3JgqE1w2K+mfk0tXZ7c76wh0zkaxsb4uEwy2?=
 =?us-ascii?Q?AbzszaqijuySSkvdGS2JXGINWOQIHFJA8LFuIfBkZBv3Cr4k7cvIQnZgaXFg?=
 =?us-ascii?Q?n+/GizDNzF31hEahJDn8JIQv4sA7XB3zDaXjbHabZTidHFG6pHu8Av3JaADV?=
 =?us-ascii?Q?FdRa+uXJUH6Irba4UlK6c6RePa0Otag84FDnV/iRvEjyyv6oAM2mHktIz27c?=
 =?us-ascii?Q?vgoZ?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:33.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: abeb8d40-34eb-47a3-f45f-08d8a269cad7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhKDWe/kguugsEufiImztZWeNX+C0MzOszp0M/Iu35oRRgJaVWwDpL4RA60k5MNdK5uvEw9TbDdydUAuCytggg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
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

