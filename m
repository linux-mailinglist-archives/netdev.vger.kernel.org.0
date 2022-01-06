Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED064865AE
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbiAFN7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:59:34 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:44357
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239827AbiAFN73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:59:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANVQkb2lloBE6520Nqi/pINV7sEXHT9zxZGAV9bJk7p4sgIYe+4wd8UkKy6Q4dkRumNv1EBeAXbpL7Qk3673jOX90YZe6SNFtqown8EZ6QYJMRrrLkKRyr1DrKuQYhTF/XP7VlD2vi7RDo6+QRGRfSthPMaDC/oCAie14HQBG8q98fBwMuC2z7NZYR6szBZh182l2iuAno9j17v2TyWneNuTBqXZ6RukuDJCz241DWfn2rrUWomMd1Yr4IRj9kzHgE/DQ7IgWRHSvGC60EHg+F1yzS9DCvnwBWEtys9OSXctX/BtEJ0uzCvK0bXNwQUMliyPc5e3qUJcGfpvodFVkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiGiVAW69/Ikcw/8llB56jFvShqszmx432n3VhQFM6g=;
 b=Bx/CIXM73qKSlt23t9BmcSn0uAGcduPKNEiCAw9cNrmG/ebp1qjWhrpO38OUjVr996d98UmHISTcgxTV1OevID0vdP5ZDv6kEOk4yStSkJ/JWhiXTdvVG2eRALVZGAUUvWDnc5IbHExq2AkqsfIW0sAhmyIoBTLAdWke7moD4GloyIKd7et9QeYQX4Ud3DVsv/Yb4qE+/j0DTZrtzBEd6yE5WXueUgofK3/bAoRBIozrtHV3BKCFKVy63c2deJdZggapN3cA3yYrXrkqvCTWV8LpwxHtwXdwTn1iScJVIg3lt+DSl7zgJ7v7l+q+xQO6zvZLKop2TIjiYAynh+fgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiGiVAW69/Ikcw/8llB56jFvShqszmx432n3VhQFM6g=;
 b=FnI+vt0QBps9AeuZFbB7/bM02awGR5ky0cnjrduSzS0ehzqqiwN5633ijpmg6HUq3rnpE6OrWQPPRB+cVEM3GMpBVTcbRbyQ+xyVsTYYYY0goawMc1N22/ki5pAzTzoDxRUHs7yzAmfkrfVYTtpe26YCTo2uVoLiUOUyfFkYt80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AS4PR04MB9267.eurprd04.prod.outlook.com (2603:10a6:20b:4e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 13:59:26 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9%3]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 13:59:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, robert-ionut.alexa@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-switch: check if the port priv is valid
Date:   Thu,  6 Jan 2022 15:59:05 +0200
Message-Id: <20220106135905.81923-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106135905.81923-1-ioana.ciornei@nxp.com>
References: <20220106135905.81923-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49ede3a9-eec6-46a7-fdaa-08d9d11cbfc4
X-MS-TrafficTypeDiagnostic: AS4PR04MB9267:EE_
X-Microsoft-Antispam-PRVS: <AS4PR04MB926781C59B3BAEC5C0AAB5AFE04C9@AS4PR04MB9267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K41rrlEO+jdufIYc6Y988gOvQYwqKcvL9D4qwvKvXRNN8ypseEeNUKnc0y7NlbGrWQBgj4GtW7lOOc8BhDx36vxuIGTxT/ZVaXeRxcu43nBmekXvEnvumjJkKIOGhgdpL2ZwaeasNZhpdF6uVFSj11/cnTU4x57WHzsiOJHM7HQGDIg407x+1MevNO8bCjA/zQvTsgcM4AgyFhAUR/nMtXkAbERI1LNUjjsitDm0o1s6bs8lp6BLjeAR8y3igywIJvMqmJPtuY4pAMDst+nUBSdFzZT2+s8i4xi4zYlEjy174zr4ONahhlXUhmaHaYRcH2y9zf1wGcFg9oIXuGxJuTm7HCd3jkB2Gi0OhgbEjGivN0w5g9NQ8vjagaF281B0kBoFSGy1Pn7V34obkjWtP6YAGCzm80kQ+k1hEd6fvK+qCDR83Z8KDR/+HcHTzjxQcfV9q0byNX3S2Ck17toeuWLyuS3uI9RSLbYrBQzyh8WDkKfqf8lJi+hEb8uvSST2nH+aQoScMJvnmwWrhs2A4mitfNxdg+mXAB/aEqNcxTPMtv0pu0s8BWqP/4Gsq7453ki6iZkVJ68EbipQ6VC2aF9T8blBIW7NTCtvTq8UfYzD4r4a99lsb0YcfgE7zbnq8qXLhD6ElfAZKgUMxVunLpP93tAJfczJXRUspTKbPwIeqa6HKOZKkJIrUXJI5e3RWVsRdEmBORwSOJM8buQ31Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6512007)(66556008)(6486002)(66946007)(66476007)(6666004)(2616005)(4326008)(44832011)(186003)(508600001)(26005)(38350700002)(38100700002)(83380400001)(52116002)(316002)(36756003)(8676002)(2906002)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w88tGP3Y2MruuFKajhXooPK3+QyBTIQ0u0IG2ILJlJPpmK0Z1qVtoHZ3NCFm?=
 =?us-ascii?Q?fsQjXWIqjxPWxEGLzMQ5wCTGcDSBBSG4qjJc8KOg57Zq3Mt8HYNfqQU2f97f?=
 =?us-ascii?Q?scml/raRcbwL4YYYsM1ZhCVTJYRwG4A5NTS53GJiHIcY5ssxrsaBzThX/F4/?=
 =?us-ascii?Q?QbIuVyrXPWqTkDfEfNS4Z9e6IcK/eP6tfJbYhIKm9rez3J5PZu+Uqj13tbpy?=
 =?us-ascii?Q?vuzQKeMgX2YLcKiODCuiPXAzxKYe3oaT9CCksDidPjGK3+g7OsoaXMwmlend?=
 =?us-ascii?Q?j+iUBB3KI6Mwlq9bUtP/rJ8C1ENQIpkqlGaVU/pNxsfzCPkmHfNPgaO0hc6P?=
 =?us-ascii?Q?oJlMcnoTScPvB921q2rTx9bnKydJga8Jyqs9UJJcOmY5UZqPdtZ7CkAAJqtL?=
 =?us-ascii?Q?pKNf3PVOq1Qob5xLJ67bd3tc2Uk2nfKwG/t3y4EBiwWVCFugIul2b1YpTNk9?=
 =?us-ascii?Q?nX1YDwHjk/jWX68I3GMzyOrzlKmGd80tIUJnXXxHbnlyFzYTZ6tyyC0Xvvly?=
 =?us-ascii?Q?UxYeEAYcaLmUi8KooGNARRiI7Caa+Slyxv1D1zI9XPSOCJmd41fogUCNe7FY?=
 =?us-ascii?Q?+dmwjvMoFfCk2A6vuxkTLy+j9DlPs2wLdfGng0aOMvbOjk6q/ibyLkPPFMTC?=
 =?us-ascii?Q?0uNi128F4JGzUGLLMfrENjqn3b4OllQ6aoFfA0dLNca3zuE5ow70a4kLtWWy?=
 =?us-ascii?Q?mfYLl36HOUwm37T0+cGnUzVnULylf7IOkfGeyXDWrrOob/eXtO+CgphECAyL?=
 =?us-ascii?Q?iSN6uOVM6U5axMyMtV8nw3nziZsMGLKFpV2vdJ5OE2CX5LgShhBFBEsz88OG?=
 =?us-ascii?Q?zUyZFH9uF/zuxtUJX6LJP+lyLrdfvch46x+cj64fkSLmkibw37o7L4GEeXSA?=
 =?us-ascii?Q?0SiGuqDhz8OxvW4jJmdWRl8FBf7N7Hr1hvwBwFGZtQIgcQJ414LWMeDEBZ8x?=
 =?us-ascii?Q?ofu4UTEDMtNukFjahia+gf5zIRSkJoqJaELyHLyxI8RU/Nf+SaE5lGN9ghH8?=
 =?us-ascii?Q?BPiWErZshJJnYxCAoI65R9mWswTW75gCPMadOYoGdsFisNAAnGhcrBX/e1V5?=
 =?us-ascii?Q?m3rJKSzc3h3Rp0Jsf1ZNTJA+qaiieOPWHoj2YZ0oel3rLR5c6JG7FbPWdRq6?=
 =?us-ascii?Q?L5l2oHn6Cl4H/8IMw05DI0luUxq3MFOIzIAK+bL+397MHiz0TN/BBynXL/GC?=
 =?us-ascii?Q?EEBj1M8hvmiJfP8HLeKY2dA7d7qR08Fa9e05nRBYn8zs7+CzfuRPevgawYmv?=
 =?us-ascii?Q?NvtwPEgU8ksCPZg2tvI/24/WzeQ2p/mXEVeH+FMKctbBftNa7pTgY8ESgNc1?=
 =?us-ascii?Q?i4wPvhy1MJpCxLgk3ylzb8GTsWGmg1hZ+H5QZ2Ajq8d1tNE5/sQ0KJC56FHf?=
 =?us-ascii?Q?PAvUnLdGIH+lChq0c7sTu7hp1FfcoZfjWWlkhYYR9XmhlUEjML5PI0ozxy/Y?=
 =?us-ascii?Q?A7dZkoHCJJOh18kBtd4dE8w/0R2Y/jLmYtZ55AgAxHRo2bLAc6rxD9g+vQWE?=
 =?us-ascii?Q?Ix1GU3XGk+WiWhAGOB9t1ugFEsn2/Iaj1Phfo0iIXZi1pUXk+TQkCBzaSktJ?=
 =?us-ascii?Q?IUIuPRMNiQ3bttdmszeaT4Dk/NAj/lfkwESP+IRUFdXpnbcub0RJr3qT/kXQ?=
 =?us-ascii?Q?ooqFdbAOl4B7qAojc0HhWCc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ede3a9-eec6-46a7-fdaa-08d9d11cbfc4
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 13:59:25.8832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwZ2x/VumeM3JLuw2LidVtVtm/ePreJovVRxjVyL71A/GXCgqyvVzb51iuatirSJWLrj8i+AdQ+YwlRvskIx5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before accessing the port private structure make sure that there is
still a non-NULL pointer there. A NULL pointer access can happen when we
are on the remove path, some switch ports are unregistered and some are
in the process of unregistering.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d039457928b0..9b5512b4f15d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -394,7 +394,8 @@ static int dpaa2_switch_dellink(struct ethsw_core *ethsw, u16 vid)
 
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		ppriv_local = ethsw->ports[i];
-		ppriv_local->vlans[vid] = 0;
+		if (ppriv_local)
+			ppriv_local->vlans[vid] = 0;
 	}
 
 	return 0;
@@ -1896,9 +1897,11 @@ static int dpaa2_switch_port_del_vlan(struct ethsw_port_priv *port_priv, u16 vid
 		/* Delete VLAN from switch if it is no longer configured on
 		 * any port
 		 */
-		for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
-			if (ethsw->ports[i]->vlans[vid] & ETHSW_VLAN_MEMBER)
+		for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
+			if (ethsw->ports[i] &&
+			    ethsw->ports[i]->vlans[vid] & ETHSW_VLAN_MEMBER)
 				return 0; /* Found a port member in VID */
+		}
 
 		ethsw->vlans[vid] &= ~ETHSW_VLAN_GLOBAL;
 
-- 
2.33.1

