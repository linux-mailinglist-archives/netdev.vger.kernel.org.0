Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5898F36598D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhDTNMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:12:21 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:42588
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231313AbhDTNMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:12:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0/oeW5JfCiCiGv0OEbMMvC+WvonppC57eSn2gKInM22m9uBjqwwSr/87WhlMdzYBl9Tux28Q+k1uDJ9xc4Of3eq2lSP2DdhWSD5KWYXryspuC0SKB5qHFsCGzl7TQL9cVUItwOeIJtW3YGp+t4c9aX4v16Ve93fjouAQflJ4S9WQnJTgNW2Dq2vsX4ixj5blXtuooKjWbObj+2zim4VkcGBD3rouRmOCBG6CU82rYVeNUSk/jK/jRyc7TywM/4o1SUyt1VRZCj7GuYbmaKHBsrqKZq9rSkp7cxiM4NS1oUI+2rhvHU4GVKtq0U1cnxiSFmcuSeWCOfLXvANfzksWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8izdcpnP2z88lk8Jcdwlsb0o5ja4AsHz6gXUrXrwfbA=;
 b=gkgxSm+y5fMqCHu246FGMeB1Tl3DT/ZyqSpl4jmyxR/2PsVdUDUv/QIFn6xeYoKBkxZsrB9OVDVsjtf4rzIV/wIjA/THo/Us2W/xLssAcdfLlCzGSblkh0Cny9C1c2qH5iz/OdATN+hKoCQ9Yd3Q4ISKUKGXsXqTgpw1B5zd1re02FkO7Qdo+uwQh1PPCOi49jUVveVhAYzlSOvKen40tvVjoQSUk11FWbccm+qWxXaChb7KY/fRjsHpNmimIs7Lgx4KbqBLD+OVyZkcE5q7Yamkjn7VLoFJoJy1eyF2spM7QU36HmUdBzSMyWwRL4QcPCJq2R+53jBU4lHEkLPCbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8izdcpnP2z88lk8Jcdwlsb0o5ja4AsHz6gXUrXrwfbA=;
 b=TyS2bybgFLYyjLmY8HnMzc1W7+hblXg5k8OcOojaOhrYtkh+X5HkRO0eHKRevjxFtOpdZuHbn99pPFaGUWDrlUKnia7vl3J2f2+3vvN7XfSs+QPbG5Sr89v+LzZ5fyFMDdtKmzScReOPadPZjgzKvFNXrHOv//0Nzb8TaeloWiA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB6061.eurprd04.prod.outlook.com (2603:10a6:803:f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 13:11:45 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 13:11:45 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH] phy: nxp-c45-tja11xx: fix phase offset calculation
Date:   Tue, 20 Apr 2021 16:11:33 +0300
Message-Id: <20210420131133.370259-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::17) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM0PR10CA0100.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 20 Apr 2021 13:11:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9b428e7-733a-426b-fc92-08d903fdd8c7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6061:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB606158254EF88441EE64B1A79F489@VI1PR04MB6061.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:59;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gzeEAyOmfiKtqfh+2GTZu7Y3cfqegu7L+AGWVVZu7yWEstwaRdSNHiX1twszOpdp9qEbwV1MTvcE07FFk9N/DqboFQxEGtp6oZOkdgkcrLlQ8U3vrjEFsrZbZ4FiQOrmgWsmlBQVFnuk9rAXp37gUKp+pls+9P83GxEJe4SsQAk+OtYws9064Q1Z/DVigz/7StFjMInLyiTjMDkPnLVT2yOqzHD/7EWQQbwewW7miqj3JXZscE/5Q4SB/V+zifMyO/q2G22PKX7cUX5QVNrUjMSEOpyFcXbOEcWtI7SoIQRLuVTEHWQq03RKQ4LeaqIgXhsYhJPzlvz2YtGbDmSrbgOzoQNgqhpObAlsl1Z52JPpckDS/Zl6oAn38THZtx40nQLClsZY8k8Jbgg0AKdAIid/ine4l1MD61ZbxK5IJaVp5BXGEbbIhjUoniA0NVxsAONxdhzvZdGOjxSvZ6OhCG4d3vVmwwGirpXB7UJZxX6S7q0tO45Qb2KgYAmKyJfzKW7un3eloETSGOMajDRfZSddaL5AkDkNTet5JomOFqExG94UrNfEM0ZC2YH/JRUICTCCVdNNDnOvSbqpsDuYzqJqAdbkrScjNWeNdNIBku3l/33/CYn048n7i5QjKJo+kMPXo/LL6pkFvGZ+9Coa5XxMuhMqZ6pMT9HOaEcv3cBF4erZTkI2WtaN+1ECS1yIAv8hVVAagUn1lrhMv/TK5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(6506007)(4326008)(956004)(5660300002)(16526019)(83380400001)(66476007)(38100700002)(52116002)(478600001)(6486002)(4744005)(26005)(2616005)(1076003)(66556008)(86362001)(8936002)(6512007)(66946007)(6666004)(316002)(8676002)(186003)(2906002)(38350700002)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/woaH6tF48ZIs+v48Xvm3ppBetjZLy2YI0GkF0RhTTLf9B/C73+DGW3IxHOx?=
 =?us-ascii?Q?Tfr00rNq2Yp0dCwyW1Q9MtLmWcOHKcW2SIxQgYzomw81Nz5PiLcjwBUQAGM2?=
 =?us-ascii?Q?twrUk4SA4YObctZayaT2HZ9q0D279bMRtJh69+6tful5L814BKtuLaCDbidn?=
 =?us-ascii?Q?w2SLEg5kVtuMT2rhZg+I3BGNcJVN9+qsx/YIjpUEfJrVAIfTsmcDsPp7/uEn?=
 =?us-ascii?Q?E4MHw4VRHV5nJMUSJogNns/yZKR+j3Ak8heR+MK3suK68fxM/XeTy6AjmAiH?=
 =?us-ascii?Q?mOc9qkP9KV+jpCav9j9w9T3gESZl0ngCPjTXq5Irw3y+U89FQ4XyZbRT/OMx?=
 =?us-ascii?Q?7G0iSkej33Lb8Ld3GbFJPAFzVNkDpN0kz8/l9HtK5wmMcpm+OZy+lpqD8unx?=
 =?us-ascii?Q?R4RyA3mzzTH7nRWOEIR2AQhW5uj/egqwQZ0S9Hwko2ERQEBMK/YZG1Zbr4m3?=
 =?us-ascii?Q?TqBTPWoXBBsBDLBrQEjyuGqS67Phb1WnQxoclg3ePeLzAAgrILQth0Bfcc63?=
 =?us-ascii?Q?JXJqUcKsAFHshd/owa7WZaWYN4ANfAYb8Ho/EiL2nnPvqi1RIT4QZOF09KEI?=
 =?us-ascii?Q?niU9YjuMU1VvuWD/73YUF5XVWOQZsOA+Ye5E4tfC/TPnhAcSpHOPOyvZuz8X?=
 =?us-ascii?Q?q5WcX0yKoWlI/WVn9mDxzAzCZ/St0XPJuVttJ9XcspsuM9qQxr6fN0L+mnaK?=
 =?us-ascii?Q?WRzV6JPFebRpnLearPCCq0j4Qqx2ZhAJU1d4PoSTO7Cz9eea3K81Dx66fEGI?=
 =?us-ascii?Q?k4cMDmGrJMp+Anxv9YQrs6ulOJ/heNY3oJqZpfQxCt8LhhDbjPVXLU5DA3eM?=
 =?us-ascii?Q?bgO0zk0ktO2fFf591BZsK8iaQz1kq1yWMv7G+97YZqNipN3eqqlNNu/q+wjJ?=
 =?us-ascii?Q?7UKKkzn/EwgacPFig39eRwKpCloxU5nvYGJBQ2nYM5B1qpI08m5/r5/F61H0?=
 =?us-ascii?Q?DptpfINK7M+dqx+/PGIOenCLsJQCotUpfayHmZ4Kyc8ba4v+LI8sBdzcf5nN?=
 =?us-ascii?Q?9wPXOAXoamhc+pui3R8/6owLZUjQtkYiOxzdUlaIeESe1AWxp4AcbxT+MDAI?=
 =?us-ascii?Q?20/4RfLM03flw+XXD3QgcCBXCqig8YZcp+/o73IUA5fL8mEkS+TZ/9bTW4AI?=
 =?us-ascii?Q?7jHEp1z2TvA1CW60kWwQIJUSsmEuLUMW0RWJ00lQUZI7ptfb8V0SPDX7tNJ0?=
 =?us-ascii?Q?/bPe2h8j3NI95fiXjwCO4NVYaEwdWKZ8p4ephCXm/bFhSQ//ZtLZxPOSRdWJ?=
 =?us-ascii?Q?FjaH+sKdgOV+neninaO4WUsNfMLHsObxve1K1y6a2vjR/p2Yy3JwbeniVZ/7?=
 =?us-ascii?Q?5BxPoUGuRkRE0v6Jjt23wkEX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b428e7-733a-426b-fc92-08d903fdd8c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 13:11:45.1388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Ah+mHjbFNJ6RWNo240TAwJH3M7ROB1WP6BgtvmdsN0N2mZ0yZ1ZafWxNv+wcdANfoordlf58dBlwFlosDUbEbbGTi1+Sx8odLn50xj+oxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix phase offset calculation.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 47cacda8836f..95307097ebff 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -354,7 +354,7 @@ static u64 nxp_c45_get_phase_shift(u64 phase_offset_raw)
 	 * and get 1 decimal point precision.
 	 */
 	phase_offset_raw *= 10;
-	phase_offset_raw -= phase_offset_raw;
+	phase_offset_raw -= 738;
 	return div_u64(phase_offset_raw, 9);
 }
 

base-commit: e9377a911d772d27ef2810c241154ba479bad368
-- 
2.31.1

