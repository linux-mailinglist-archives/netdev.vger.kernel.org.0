Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAAC415F91
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbhIWNZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:25:24 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:17025
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241215AbhIWNZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:25:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSp4bMXpTo9aDqJYGc2vHQuwGZ1FywjG3PkDv0v+edSfbitMLO8QLiu8OBSuGRgKNL6yzhAOzkbQuFcUtBIQqTLFm2QRSr68/tSPTwFxvAqRt+7zOnKClNOeAqafRHfgGNzM//aqj4J7xHEJ3bF46xpQbC+Gr50b4LKcYpK3lf4hq14DThBbM0dLy8Yuh3+t1WsCoZbbcf/3K+S7G4zS1ROeyTYSRY1/j/vDBRWr7pNmxVSIoOvmMicOmR3uyTmEwVPf7y5Wf2oHpaCZ9r+p6RbPAAXzU3INlWKje1dR719zU8zY1q/gf3BIrKgN+kLEEel7NVn0UIdtDNUYdYlAlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aNl9o/ODX70YUzAxKo2G2cdWKO/Jz0lLY6j5Cg1zTww=;
 b=D/IGbicskk4W8EZUEW8Ha9obMOe/o8Zwn7ldo4qAX/lCbPNZmwibVE+fFPfjUibrKbXhkowJeKpTZivkoZ7suXjMp6dEkwWPYZ1dhsUpL8gC5bzK9jI/iOZHL531Yu2KP3NS3DAYweG8U52FOz7gPbiwLXhZUX+n0383FT3K83AbKaol8+BEpk1HnyX++cmnvjdIjOPv/xxBCFryAHedeGorQJJ9hx0ibigHOmvBWqneL39u/m7CPH5LM+RABsmgBS7ANCd1Dn6y22UYH0yZRFyKPgojXXw/Kum/IYM2Sr4eLd+FoJC1fA28ocepIW0O2XybX2VnxCI7DSP2WGF7Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNl9o/ODX70YUzAxKo2G2cdWKO/Jz0lLY6j5Cg1zTww=;
 b=Sfu2rhZPJhkMtU1TMtfCMapt8dClX6XzlVFtGnxaCZE0fYrmMVYtgx4oojXryjkX5WchY+Ok/ERPCYceI5PoGTaG6vocigagemMNlBArE7eePvwjKecp4VxXbRGfTCK0j48wGgr7APP9mGRjY/VDa+trYXeIqV6GHem38LSJJ64=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 13:23:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 13:23:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Pavel Machek <pavel@denx.de>
Subject: [PATCH net] net: enetc: fix the incorrect clearing of IF_MODE bits
Date:   Thu, 23 Sep 2021 16:23:33 +0300
Message-Id: <20210923132333.2929379-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0026.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by AM8P189CA0026.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 13:23:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4de3da5d-cde6-44df-145e-08d97e9560b6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74703EFCF0BC4D2DD9069617E0A39@VE1PR04MB7470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWfIY1lqF25+ghmRyXIXB+Z3q0CBeMnGD01m76stNyDNyLjk06yo07cBNOd8JW51pOHUT79axjPSezhiJGcgUcubWr9wG1+CDmJNInQbOJxMHS1SfTsnL499VhSZWtQ3AVMqedZlKyBrGTmFil8Lq102WIuRB3k89GhPu4ZWkdHnxeWZ71dDV+323Hjuu+VMSHwBw/r11Gl6CfH+uIxI8SYIGeAXZ87ChCxNgNBMHCUHAitdkI2fVi7I3hqPAHe7ELAIL+EYeh/KVCdoTCqANbr6WcDYB8trhE6XQJtTcQan1kOGjARxi7E5Ub9PGc38YC5dosnX1ngBXrulDa9Bm8NlBdb2294RvbQIhsECaCLR2/tPTq8p7+IjvCNXKhhF5jc4G/X3ou6hpRpDIIFN+y9PjmqkUYYRkCEPpkr2pRbzqdllHqn2hzh1PLaJF0P0U9PEgOpx60GUGug9uTQ4zzu7IGxi2dJm5GPUMhk43JQNDbsv6LT4L0hBBJqyrouUYY+i404w0/A3ztFU5obZ1HhlqODm0rJ0hTpRMmDArK94wjzR10w/O4+iJgiW4IVrH+bQ94DfKpDWG8fTGGjMmPjw+U8RdpaHmg9WVhsnfTZVd0yvRYhovcELip6nSkCKl3sKLggua5snoHyHbyd1tWcbP1t9tDdvhh42E/fYvIUCVjQ+InIyRVsyNk5QivKzW284jYBWdBmDJQLx6KGU5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(2616005)(8936002)(86362001)(54906003)(316002)(5660300002)(956004)(4326008)(6506007)(36756003)(6916009)(186003)(2906002)(44832011)(26005)(8676002)(83380400001)(6486002)(38100700002)(38350700002)(1076003)(52116002)(66946007)(66556008)(66476007)(6512007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QIAK4/I+bfWYJjCkmHw39ogtLttgvDK78GK70+hdRpbeHYKETZmjERm4WfKD?=
 =?us-ascii?Q?CuJCm0220ZuYsN25R6Q61eYVLiGeWv8UXYniL1yXO++l898ymJ+232il9RpR?=
 =?us-ascii?Q?MClK4FRbMdIMqxC++HQpVZZkf/ti3HitexpL1jN/KGZMv3VQPkU4CXUmHLj0?=
 =?us-ascii?Q?EdIWnKMqbVOx1bgNGMfpPmdSKd+bz0oB3JQrgRL2/DuGnNiRY6gL2mYukYvS?=
 =?us-ascii?Q?cKBLLhz6CyD6Mn9TA/nQbQ6+S+F1jFuVePNq8v6Wwpr5ilSEG0V5rudvtN7M?=
 =?us-ascii?Q?G+yvpauFEqI0FJK9PZvrt3Oe6p3s6BwTMJhCiDajfyVLt4JTD5vQujeFzh0g?=
 =?us-ascii?Q?4x6rURQ7Wuf8FyWNCZT0Iw3X1iiYA77dEgGx4pbIN+njYJ48DgddTJ3AK8SD?=
 =?us-ascii?Q?Srl5XQ1MmB0ANdwqjK220omdze1nmldztNAvpvRXQpHigSHABtXSfZpYI1oH?=
 =?us-ascii?Q?orZsCujoOagKc7DA71s3lA/Ksa10owC+wXKAhDWOb2XsHuJPVTzPFhvAxiY6?=
 =?us-ascii?Q?76LI7gA5faiqavWCIZSUXE2P/FN7vqyXJNlLtzPn4cFyKYShK1+xowY8EkAQ?=
 =?us-ascii?Q?iBAX2wMrZV/2TBAC0N6XPEVt203ls+TmbY6x5qnLqfXQPKArm1/x99g3FNA6?=
 =?us-ascii?Q?fZzN4mq8MMyyLxBzm/bhwvBTdDxPvv56FkuX9EvLYFqhsRFsKF6KJvVZH16P?=
 =?us-ascii?Q?wyy2F7SnWk1M5L3iQaG0dpnoPUslXWib9qJvX/I3YJtgOO9mO0C/r4JSJ5o3?=
 =?us-ascii?Q?p5MG7F6uSf7XgbE5K9Op6bh812qwWes01m7ktu/38fY0p6rDrINT7mAY7m/R?=
 =?us-ascii?Q?1sZHORUS1GmbwDj8svK6q9EALoCE7zxcnPutPB+sT0oCKQZRTD1QcvHkZoU7?=
 =?us-ascii?Q?v0/xqTo/G9TEfOEpC68AWCHqezdzcQeDEMlxmzNeqRybt3P/JWqGK9Ai1a/D?=
 =?us-ascii?Q?SG4OanHUcpGJBDPsWhRDh3KgIleuckeRUUUOWrp0U9A9CJIEABS84yEhQr4o?=
 =?us-ascii?Q?kXyUm26dqzEP2UWRvz7HT/sMSAtLdYw1CW/7uE8RLcxC6J5I6jDqQFtzATtR?=
 =?us-ascii?Q?v3Dz0Zjvvtag2G688jNGLYUDssurTEO4fsqO6LuOrENbQVioMb74mnNxgd+l?=
 =?us-ascii?Q?YPv/SQ2FXhd3IUvulAZ9d+taoQ0YP+bOk1xfELb5IEe07emCeubs/I72yqDe?=
 =?us-ascii?Q?GVdoYCmEeOpUdC76AF1gDuYSe+GzOS4dm50NRroPZIdYVLxObHtXcwmLMAIv?=
 =?us-ascii?Q?5W/waC9unC8X0h6Sy85kB3tGdHfma7XATvzOiviGApLQuNREcHVP/MsDuhDY?=
 =?us-ascii?Q?jltpt7PthSP2ewEnab8pZsk5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de3da5d-cde6-44df-145e-08d97e9560b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 13:23:48.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HLnuAQzp6IxBFGhpmWm3u/etQq8L0TzJeoH0/zAjc5gyEItSc5lNyhJI47kr30zeXhj5ircDz3v/KeAtOVgyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enetc phylink .mac_config handler intends to clear the IFMODE field
(bits 1:0) of the PM0_IF_MODE register, but incorrectly clears all the
other fields instead.

For normal operation, the bug was inconsequential, due to the fact that
we write the PM0_IF_MODE register in two stages, first in
phylink .mac_config (which incorrectly cleared out a bunch of stuff),
then we update the speed and duplex to the correct values in
phylink .mac_link_up.

Judging by the code (not tested), it looks like maybe loopback mode was
broken, since this is one of the settings in PM0_IF_MODE which is
incorrectly cleared.

Fixes: c76a97218dcb ("net: enetc: force the RGMII speed and duplex instead of operating in inband mode")
Reported-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index f0ff95096846..8c6fa1345996 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -541,8 +541,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 
 	if (phy_interface_mode_is_rgmii(phy_mode)) {
 		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
-		val &= ~ENETC_PM0_IFM_EN_AUTO;
-		val &= ENETC_PM0_IFM_IFMODE_MASK;
+		val &= ~(ENETC_PM0_IFM_EN_AUTO | ENETC_PM0_IFM_IFMODE_MASK);
 		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
 	}
-- 
2.25.1

