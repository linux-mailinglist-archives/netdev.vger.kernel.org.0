Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860D84D2438
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348226AbiCHW1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350773AbiCHW1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:27:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2133.outbound.protection.outlook.com [40.107.223.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7E758E58;
        Tue,  8 Mar 2022 14:25:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyowduxBizJPgD/fQDNg/2c0HDDN/W9dmF3iHF3cJDk3w+dxc37qf3ZYDPHqS3x59agEW84DVuU3CaQ2x14gXZbt9E4S7MzqFZHatAq9klP18KEVABq92UwAh401fEyWXJa4bFxG8fROXLwG5slE74/Tlhr/BwFUH8An+YARMJALAashaTiddk4a5tLzAftpVJfQ92YRbuQZjLIhftN6U+9KE/tZ1L4N5TLeopp6KNZ7Jgt9DiLWQmv+9mECl27rMBjhrVdmAEuJEy1fI9lPr0v/vZyoD9ZGlFViOy4SMvRapxbGSdA0j7VRQcER7yH3T4VbyuIpQ2GsiRjcRF8ElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cv5AdWhDmo6e2NqYtP2bMWkU11grLP43B5MDY+DO5pQ=;
 b=BVIC2FF57PVEm+4GGAP1NaneOnbzhybtDJCP7jMckK86El/xYaogTVH7eQwlrBIyP3hjpoSnwCvgVZ2B+dH1XE5AAQ/U54ktBKj+jzPE627awCXuPYPZO0VKE5QDfoApCmj/Pgo5cLO3n1mWYEmdb7MjeeLd+MCik+i7u+1qJjAq8meyO9Lz/DQvAAVhnEJ4lhAyJhsjJEPkcoQPB+iRtRkU8YpnurqYdxgVLfkYCllKGCuJgf/2PGGym67tY2daY7JMzgjvcOPgdURSfC1a24vOBUibAEFfSJJpADEvEhej73Ox9tgoQvdfyB1YJRTyIwo69GZZjnfuVLeTAVWT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cv5AdWhDmo6e2NqYtP2bMWkU11grLP43B5MDY+DO5pQ=;
 b=xxq57jit3Jt0sGXiw4S92ZKP1ww2RYfK0jPL1hYA/yCULDrY37GeBM6AEy5YiRvor9ndaVu2noPpzLpei2c5itvlDxu9C+rulXMzONwLABDk5tfdrZ4hkDyrgqdxd3miQ+j//cGuIhRNQreHLLONByejlMjqxNrlNeAPTIHgjnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3114.namprd10.prod.outlook.com
 (2603:10b6:5:1a1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 22:25:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:25:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] net: phy: correct spelling error of media in documentation
Date:   Tue,  8 Mar 2022 22:25:44 -0800
Message-Id: <20220309062544.3073-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:907:1::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d8b2631-7c33-4f4f-7333-08da01529d40
X-MS-TrafficTypeDiagnostic: DM6PR10MB3114:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3114BEE905496026C089586FA4099@DM6PR10MB3114.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ol7GC5q8hs2uQ9/XQ7Appnk1Sgts3Nf25yjS7CzRprNWbSXe0MCoHHkQGdYKjFnsTJ1LZoI7MHAT2WEoSoqWB2C6ld3jkL8frlj823GB8P6OGaGhKO5gBHpYNzuPWmQyGu7vE7A884BP808AD2WYKIP79RNTY4p3x1V5h0hsZ8A0BndAFXzTPN4q00n6OXnXWlzgzVpUhMuagigg6iEZ8STV7oYOhQZAeNisvGVpSja6+pTIPQDnDPB54teStik9z6L20Rr6+xr5yNtvwrM23BnIrLXFidCuTTrzqKiQZcH/ekvEYgmdcGgIEFzVcBI7VjygxE02mfLVLLNZZFaHMrkhu2mDVgkzNXjCV4KX85Ai+D665hJAot0mhJ931yVqdDEDLGSnyQAgOJgO22/lzh94/BohtETcYsjlQm/dqSNxwPjLd4dBwmWJUwVW0ZVQxt8IVuVZerp2K8pkJnamHSvgKABZ/UuWwmQmH7gPl+iVuTBFu5hIYEqyO6s9ubF3C+8jF3untzMSwEh+qx7Pt/6FIDibRUwhm/7/C3duIXt2AEggvdCGVPq/KmClCLjYDqElDcnAELhmhe9vUTnHSADfnQ7PtFnV08V+D/rkeFwFOexIA74bwgktOrxpBTWu8M++g986e4yR603FUbp9d1WwomnzF3f2/QAGELIsR4SoCJo0DFtLMfEu+OLu+pYLoc+1dJM14FgmmCYQw/T2yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(42606007)(39830400003)(376002)(136003)(396003)(366004)(346002)(8676002)(38100700002)(66946007)(38350700002)(2906002)(66476007)(66556008)(4326008)(54906003)(44832011)(8936002)(5660300002)(86362001)(6486002)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(6512007)(83380400001)(6666004)(1076003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OOZ/CjE+I0RHLQZQawOc8jQa4K+gnKGLNWQkitjw8j6g5J3QDWVedkZ5b6r/?=
 =?us-ascii?Q?eCSPxxq2/D7C66MIgDtCADPgzaOuMghL/5lIa8s0S6RE7IlHvldbgOxbyCQa?=
 =?us-ascii?Q?pSUpSdgGN5Inr3AknTVwb8M+P/QqNzSyZaWulAcnfuCMF6R5t6fpk/wj8UIU?=
 =?us-ascii?Q?7YioF/VJ32J+sS92x+SfnxPtRLusWvQRtAS8JT+F3dH4VP6WN/qid2MKRclz?=
 =?us-ascii?Q?+GecshvN+qKF+vGVtjkVnqY9Xp4Ums1S4FCxPJVE2q2ToZKETKvFPB4GNRlt?=
 =?us-ascii?Q?teijj/hSlMW9+T8Wg92ttTA3T3d2OcVBTbpKH/qKfB7KMggvq/3vMDX9MCmc?=
 =?us-ascii?Q?CCWkfA4lVo8Zi0lQdaslXqtN1HB60gBtdwL62fMoLQ5JaHkxgOmJQ295kocs?=
 =?us-ascii?Q?9bEr9snWqywBTmnkGfF2Eqt3Wd+83RlihW4eWlamoiSwPHVdpSdSa1mrJBBO?=
 =?us-ascii?Q?DdqVXZDn3PPhBHUshOFXGVHNYu5HfwIzqSUG6C7T3zUNx8PbIsPMeI+iSe5G?=
 =?us-ascii?Q?EFHNpmz1a28bvXRtIWWJ75VDWWmEoCCuMga3TgchEOEFYZWUlzjYQm40o+Te?=
 =?us-ascii?Q?AFwGiAJRq4Vr8SWmISmMM3F5xCzAY/boJ+S5ZgsUBJMSsB1DTWDk6hfaOy29?=
 =?us-ascii?Q?o+Z0/ndpqJfyhZzAFErE2FNymmZ+PRL76uFXeYxyf176JB3j7rjYpzrie7Es?=
 =?us-ascii?Q?o8qa17Fxip5XRPeknr1Osg5QEgmZYsTz1fxZHWtM+l/uV34OPI16bHhQL9gE?=
 =?us-ascii?Q?Lx33WiOgeqDgPEZUxy7FhVwhHMLl0ESuCBiJrzLu/TogfOkQuo91pyx3PMr7?=
 =?us-ascii?Q?k5tbhzmHU+oQocenuwaWCfiI0UO3W9W15cufQiBIqoiA7cLvrJZDSCmQ2UMR?=
 =?us-ascii?Q?DscHKaS+ESon0Z0kwWYImvDHDf8c96o3oWELv2KDTRKhdcDDeeDz1sThf/Zq?=
 =?us-ascii?Q?qUf7k2kOBxMUA5ErFndJi1MiUO169sQ0ZlXU8juoFwmtWsjeC0uCP5T8UZHm?=
 =?us-ascii?Q?p/FtjUziz2HOa8EUN1aBeI8tHkTQJFbI6Sc2rrVLetMed7H6Cev4Z9Ri1fgo?=
 =?us-ascii?Q?KVei3OdJnEIXlvgbKqd9NlEofed8roioyxT7nG2Izll8x3gy8bV7VTYuclCr?=
 =?us-ascii?Q?gjE3RYR39ddmrdZMxn8H7R2GrD4aBcI4ArwxYghDY4uwECZvJ9wQFJ3NRThX?=
 =?us-ascii?Q?CBRqOpzUAhmsue2rNBMg8dhJWI1DfELPVE+YFt1mOwhyC9ekdZvELqu1/VG+?=
 =?us-ascii?Q?DamaeXe41VmInQxbkpFPem2dhpgtWfNSuJpKo73g6uoqmv7QLX54VYa7DexQ?=
 =?us-ascii?Q?79N5iUCwCAMzoyw+mO9gBAyxQRi7t2XL61noWGtOfF8jIPtgh6qdaeajI2Of?=
 =?us-ascii?Q?+stg9zHGrwPfIhsCveo76fPYybLLePRwfh9y+F0VtNgWUR11D4ZxCH6FSxEe?=
 =?us-ascii?Q?CdolpwFKy7KHN1ute8JtKlzHvTBeUJ33CuT1VJN/oaL/UX0w9J22DZ8LwIHK?=
 =?us-ascii?Q?K82BtOwchBo4fYby6RQU79RARII1qNJgKjgCguhJvvZ9aV0nYMoayi/sk5dy?=
 =?us-ascii?Q?Y9zly3t2xwMUO7j1bGHbBVsOXLFHgRv4eyFssRhxtfi0Htu6+oVXs8o6OBEq?=
 =?us-ascii?Q?TgxtXZBGzhm7mxs3YrhnmQpM95CGTgkOGHRtOCGlXpcZ+DQmZxAVo8KKEddi?=
 =?us-ascii?Q?GcuMVLtAZNqvT1RKJoejW7nVujg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8b2631-7c33-4f4f-7333-08da01529d40
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 22:25:56.7288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+omy/BIS75i0oQIrR4XMotqDL0kzY2o2yUSBPDMFgss+TZDSPaPvW4kY2ze592r8xwPcwtfDS1EfakqdPZWkGUk6YKcUX+wSHbXDv/kOoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3114
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header file incorrectly referenced "median-independant interface"
instead of media. Correct this typo.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Fixes: 4069a572d423 ("net: phy: Document core PHY structures")
---
 include/linux/phy.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index cd08cf1a8b0d..1a0ac0bcb65f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -87,8 +87,8 @@ extern const int phy_10gbit_features_array[1];
  *
  * @PHY_INTERFACE_MODE_NA: Not Applicable - don't touch
  * @PHY_INTERFACE_MODE_INTERNAL: No interface, MAC and PHY combined
- * @PHY_INTERFACE_MODE_MII: Median-independent interface
- * @PHY_INTERFACE_MODE_GMII: Gigabit median-independent interface
+ * @PHY_INTERFACE_MODE_MII: Media-independent interface
+ * @PHY_INTERFACE_MODE_GMII: Gigabit media-independent interface
  * @PHY_INTERFACE_MODE_SGMII: Serial gigabit media-independent interface
  * @PHY_INTERFACE_MODE_TBI: Ten Bit Interface
  * @PHY_INTERFACE_MODE_REVMII: Reverse Media Independent Interface
-- 
2.25.1

