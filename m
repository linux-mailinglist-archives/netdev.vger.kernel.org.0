Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9780293629
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405571AbgJTHyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:25 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:33760
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405546AbgJTHyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYJx0iA11GFVkEbQlvQRwsMqdn9KK4hbrw2is6YElaOQm7xdUr8QxrzSvRmAW0Yd+a7MzDg36KlmAJELdSkrmA0k+Uog2E4ZqtBy5j6gaNGkhul+/pZLKJv6c8/z5eVDh09g5Scn1m7Y6N76swVeNMIKGqnGHh97bA9rxToolLQ/vFsTGKih2/MvI/OmY1b5eKbaSvoUUDoSM5PAk89mTsj3xkwsdpx6csLmAzY9Opr2o+ZiNv0X1vA2mU6zYtqYCT6qIfgbxUr6sUGUqf42e9m+MELRrUwmZC2isPwixLeGWgEiNavWswZK2mRwYGcVLU19T3V/dgiDI82JLXVVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCJodCo2r/+Tzl+AgQJiLwFEQJopamT1XfSgrEiYf+8=;
 b=f8L8I/j8bo1daNBze8poRPTe7x0oiwc6aNKFMLAtywjH+m7bsAmsGVAcYW4Di4sIYLAvgJjEj6ozebFp5JcK4IFePLFD+YZVeoPdAumjikkiHLfnL6i9Umi3NWNd2yqNQ8eNKjZ/odxNf4HRYqxbND+sg5RYeINSe4G/ocx1Z9fBtoP9cTMCgTzcb61UsyEx6dVfPC85BlrOXRkY3uiM+8kWhvcBovgF+Q8YssTysK5SUEQR99njETg/lIQzexDUrgP5kyH+TWunJLjQ21AJARiauKxu/d3nKQPFgHN6+JtIQWClqhQgWlNcifmrzAK/3m0CjKQHX8rriQMH/u6I4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCJodCo2r/+Tzl+AgQJiLwFEQJopamT1XfSgrEiYf+8=;
 b=MW3MlmNU2KeB7Vc4kgoANhbu4d3sA6tikG4FDvoHzWgI+0M12VMBePHZLZZll5unVng2G0Eh33tGvZFqeq5N+dTYV/drLN2wbP7Y5JISVq7d72fv6iDdxfS34pnvjsEQJBLvZqfyhTlmgWz1g5b8BGbFDh2RovSN38Ejtuxawik=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 20 Oct
 2020 07:54:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 04/10] can: flexcan: add ECC initialization for LX2160A
Date:   Tue, 20 Oct 2020 23:53:56 +0800
Message-Id: <20201020155402.30318-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c01c27b-1e03-487c-869d-08d874cd5a88
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73331E46D27868ADFC3FC0A8E61F0@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPuJSnqaowLCr3UJbETsR/GgGfFu0x6f0FaVZdgWrUNTGh0fpGIAsV0Ss2sIMEAS2saDcU/dpQkdA+x/vVxpGqHIYM8+13a+FT2EF76GCPdDv9pgQxKcsPmSTbsi6Q565Fs12ayn69CO+7jsA3Lqk+2ln8FBhJoEYgx36DonfISyuOcaWksFALeOvC8bvh+1LkKUFfrtPwiKDsvI2tBp65MyGoKqqU+bFFz6hDkI/9v94K3S49quNFI2jXn3dGv34/Sk7AsAf6EdsFql4YhCM9PJxne7HIj2o5QRaXQfW+U93K1BjRfZ0w1YTKzeCll9NIsCjoQ4nvkaRYkuuchxvKQ1fu+HzIXQ9w4pwMVOCRM4k5zegrhY1uAvitKKJMHs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(6512007)(2906002)(66476007)(52116002)(66946007)(956004)(2616005)(36756003)(1076003)(6666004)(83380400001)(69590400008)(66556008)(26005)(316002)(4326008)(6506007)(8676002)(16526019)(5660300002)(186003)(8936002)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rkxOfJte5fvK8KDZSSdjsVGAzMg8fSFqUwcc4WakNUI493smCEQEbZFxI19Qc4I5w1qF/ANback6Y7VQxQwpG6kKTK1LCl8GZtjmquvkU2Ygf5Nz7WvE+fqLlDEbgLJV2WWz6ljVlgyYX1nf2tnjdXmfmlqsNZbwK/GG5UwDPlUO0MVtWqTB1T0mEkO/sPZfcESDBD2IvUXNyCTJsBnVJ4/nhcyNNlrrCDkBeLcDaoK2Bxbtb5BQ5xick7nS9WgPKuhNZk1V4yN9Axg6Lj1fTpud++N3lsKOKMz1eRRbkPo4GA8JydqXi4Gf9p3EAqhgan/9m5Uoy4E1NxJLLApH/LJMAZ22e17fqgVpeRNcGYo5QknUTXXFLozbECAAbD3k8m9z0j5EDsSUTdkV+/A6cQ+J9EINB4JKqbd+DFUM9syPJ/ZgAXuAfvHGjovWPOLYJT8PAeOJoy27vJH5jdN+5NzMln2ArLQavlKLjtf1OwngTpgysfKQ8mUCMpCXsiEDlOeU9UBx/Tvg6aNJoQ+RF15F1V4wCdVXgldKDZ81HXugZ8C2eMt2h6/T9QyOt5m0ntf52daiA+LjHePmXXX1WHT0yU7rgmyDbKzFUUgkQQaCRsFpeFZkwbDLg28ys4dFkRETGWkCXc7VSNGtSYgxww==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c01c27b-1e03-487c-869d-08d874cd5a88
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:21.0731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4k4Tb7IyULhijWpqJSJDLkRYhDD8QG9CvLeKlVjxuBoMXuXK8parjnKruBBs2AJ/SpqnTF7aoxV1ojfRgimeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After double check with Layerscape CAN owner (Pankaj Bansal), confirm
that LX2160A indeed supports ECC feature, so correct the feature table.

For SoCs with ECC supported, even use FLEXCAN_QUIRK_DISABLE_MECR quirk to
disable non-correctable errors interrupt and freeze mode, had better use
FLEXCAN_QUIRK_SUPPORT_ECC quirk to initialize all memory.

Fixes: 2c19bb43e5572 ("can: flexcan: add lx2160ar1 support")
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 586e1417a697..c2330eab3595 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -217,7 +217,7 @@
  *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
- * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
+ * LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes
  *
  * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
  */
@@ -411,7 +411,8 @@ static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
-- 
2.17.1

