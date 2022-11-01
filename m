Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BB36149ED
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiKALvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiKALvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:51:02 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95C41ADAC
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:48:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccNveqQaq5iGhvXUUMFVy9npu+0G3liY/braMhnOowQD7OmOIMUYEn8nI0CTsC7rQM1fD72YUhMe31dqDaeQ6mz6IbWU7gWQxGJAMcts9UDYtNcA5botBY/2LAmiUF4kjAL/tLAlWcdgYFtMAU7UJoAMM6N+6I8UlByiQejQjw/fxAqoMO181v7vE6YmEjoeH+riXMLLRleW6a2tf7bjocPc0ovmMcHE9ZhKnaKZwXfynnl9YaLT2iOyFJ605A6J/qm6DOXKvagPbo9tDb3wyS+m7vre2Dr+jtPHOwbJD/xm5v0+TR2xKVDyzr5u+wwWmDB8/R2ddP3ZMKXAMIP/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKk5sVvcyzqt3rMJ8IlcA1SvBjBv2NB591Oc73Q5V/s=;
 b=nE6uDOgj6AglsSyDLkIkzAtYVEur+dQyL6r3s03Wb/wmFS1Y+AjjwlVd/G42JqvhPswAHrG3415zsxmwAhM1ZGe9ZeQpk8J3LoEJrIZ/FJ7/O3yk5PwJBGfoqMrp9GANuxoaRolQF+sZPv/dAwKawHQOd/ckUAlwzqEOjZKnjip+c0mpctIjMpSpGKqseITK9avDDo1S4OC1ksXzBO4E4bTETPnopmunLA8bZOUhxD+WAgLHyxYHC9ui5SwriasKyE5Mo1jFQjBd9KUrvcvD9U5sBTbzfxrkmiaXGGCZhalP20zvAcI3+6S9rfXqyFwxkkrfAUEAjfw436uxykEt6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKk5sVvcyzqt3rMJ8IlcA1SvBjBv2NB591Oc73Q5V/s=;
 b=DDI0lLS806Vvwz3P38KQifwDxAOHOw6agRsmKuMxzUK4wfhz9iKEe4dPat4+prbSHG1yo10SmT5xejo3hkPSo9DN9+zAy17afnvWsOKsJumQb2BQXBm1h57uvR7L1xDtEjlPM0aoHaBeqxCMEiCU7rqPXhA1Kh36qo8VFsOhEDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8453.eurprd04.prod.outlook.com (2603:10a6:20b:410::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 11:48:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 11:48:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/4] net: phy: aquantia: add AQR112 and AQR412 PHY IDs
Date:   Tue,  1 Nov 2022 13:48:03 +0200
Message-Id: <20221101114806.1186516-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0057.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: d16a67c0-fde1-437d-cea0-08dabbfefc39
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FEnDCqBFws3eTGEOzguzw7PqtwmR2R5tXGEbmMs46QOEryR+a/JFdJcGymcQk4iuOIYicLdZr4OGga34jONr10el0d299skZrrpdkrRqvINqNUnj6ta7926g/CUYDH5oqusOuEVrhat9t8GE2AczJw59azWowmJogbG/WYqyGeo3Blg2SCGRoB8JbaGVoWfKxuEk44s0G01DRc7S21n11PRvyO/ALa6/xfKfeVkDIq18dRqxdXlWmWPU4hx3Ap9aM6noGKbGvvBhQDig4USxelibtuuEeNOM97yTe1rZGT6OSKTvBUdIygKhD1qPkk19G8edhQe+r9JFw8A/gmpPu9qA1feMVHpOnN+QoaJvoR0CU+cbmQbGFEBG8GcOea2pjdYgC0lwTMNR4MPeAEBSW9JQb85O3+ZOXBCsHRkQTkzi0gl9LnZkC+HL4tM0rTUIWMWw++9lHaPesYW1EZXKuXJwyJOO+YoNEG/KWeSthDkIzxlhFCewGlk7QXNfWAoG7T1yUp/YYsObz5g5APuW/RqVxbxlHWwwcuGMVxYTMXmq3HuaXGS6HnYUeWZ2Lj9/Z+oI4CJR/v0CWerwEikp8Ew88hVfbv7F60EonUQSWXQ0a1dXhlRL8MAdie7pIzUeVHp8ECJ5FDaiWwMVGFDr27FLIoC9jbK/mn5HYM+52eVaz+p4ryam75SlQQ7vg6wpkVxyizo0ncu9pat6paMTmaSYPNkfes/Qeb0RWMKlAU0rv7XL0u8F5N/JCiAkdx7h4rCzrHIDOMRpADWbgkyDbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(6486002)(41300700001)(26005)(478600001)(44832011)(7416002)(5660300002)(2616005)(2906002)(6512007)(83380400001)(6666004)(36756003)(54906003)(6916009)(8936002)(66946007)(52116002)(8676002)(4326008)(66476007)(66556008)(186003)(1076003)(86362001)(38100700002)(38350700002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L+4nwWGvk0zjlu5ytsBWcdaxYog9yUQgpy52UDYEc5El2h7JxOQ0x2s2lEJ7?=
 =?us-ascii?Q?uLnSoseiskUYmKWjqvrJWBJjZl7GBAYhOibBBQAkUiYtyGihN2TOzuE80uTn?=
 =?us-ascii?Q?heZcvSsGns8T5lvZATsrigSCdJkJ/2TRQokETzNwNvc/M8qSrLuT4xYNNlZ9?=
 =?us-ascii?Q?mTEroz25z/yOaCJaUTC0rkZ/jsCogOlQvb4ThkjbPUUdKsNoEepkorK+to9c?=
 =?us-ascii?Q?07C4GZq2L5KADqIdzn5QuwXE+n+lNw6+tHVZCZGu8NAf70IEfOu3wGynRUJb?=
 =?us-ascii?Q?Kt8utzhhZO04esgHWot9iPmZH+wmRC9Ogo2ytTxeqamWmXG9/SojcRqJR/RJ?=
 =?us-ascii?Q?jdmTUUZlbcjSOPNwTa1vCVQm8T4Y4GGbgPSWDm8UoFIJf8iyiWrKDiKPBpXr?=
 =?us-ascii?Q?n0yUUQj4wnm+rwC8Rp0hteSptMHLW3k+QXh7Dgz0XluX0wjRbkfL9lzbZmQI?=
 =?us-ascii?Q?a9x8tRh6OGe0u/iFl2ySMai7CJs/oqlkW8RFLhrIbXVXWORrWVCq+FxvYASo?=
 =?us-ascii?Q?MERNJoFw3BysV/5jmSJ0379peVfr4+q8htLsZUplwT44oBD8ODLuyovUqqkY?=
 =?us-ascii?Q?htPHoGDIIuV1mrByytvTUswc/M3KNkeVDljbB75XfNAnc+zATaORatbPeoCD?=
 =?us-ascii?Q?sIdk1kcCjLrUYXV60rdvRU+D2gjQdM/SAdnfxf2UBFziGG8mRJC5tHhz8HUy?=
 =?us-ascii?Q?SejKc7wpb9selpkS5Vs7I1JitEcJ+UrtNr+TH82MSpGXQvkaekUEWDkpAKp/?=
 =?us-ascii?Q?YuKWwgs8YnV40ikz3LpxOu7vQK34loiEujd1FjwoACTqEmIrzfaYrPax8pi2?=
 =?us-ascii?Q?d6OPBtbBeCUN8s0pQizY1LCGvyxqVqnOkcTQFTgtjFDejMfq1gfuNwcJwO9F?=
 =?us-ascii?Q?irIFM2VZk1sUQzOlOtZwgTcEL3l9fBmx+++maMxszTQ1TMhsWM/a8UHgx/am?=
 =?us-ascii?Q?aMovPa94WgVE1m+6GCd9LhZOxu/i6USU/NmsvJujFvQAuEAwhcaJu0/RJlGY?=
 =?us-ascii?Q?e8erM9r74pr2XzGavVTxQXU8im6vUmIdm7u7PXfqXo3PrDT0pUb7XCkoUbUQ?=
 =?us-ascii?Q?QW7yZvI8OTIWpGOXW1ByjzKWtCXcCH21NYpWLd3DFMe850pAFRHsvpJvQN41?=
 =?us-ascii?Q?8KMKh9TSzCOdIHJshB4fZg18bzLIOiamG+8vwPWBxMTNGIkbgM721sc6UqSF?=
 =?us-ascii?Q?ErxEyuAgpqTL6dmmUQRV2Cy0c6eb1+n4uJY03H4dCSbMdgqLwmZwSvKoAfun?=
 =?us-ascii?Q?e/l8z8l+aFnCcMhy4+CVmVTdSqCM7IuSXXVV+/0wuETb6E3jnOQz1b+oYGjX?=
 =?us-ascii?Q?T2KRxSQXfSU3rc/UW1i6kQhTUlRT4s0jkuPc6WFcrxZ1t9I5w0UIcYAnU5Rc?=
 =?us-ascii?Q?hkdyWOhsvCqShmSPLLBI/Jk5MXnqFaO4RjC+6bSdnLdFaRRkZUpx1SqV+JaA?=
 =?us-ascii?Q?zOGzBvfmHYJKqItXJvVGiZPT9ggdMK3sanKY/nus0ZDwWqOE9TKCZhcaqbMD?=
 =?us-ascii?Q?wu33YfRd+3Af1Lx0seZitStYkkG8LoX/sRwzH8VghEa98b3oGWkB6MZagx6n?=
 =?us-ascii?Q?UpGLosCiCXa8Sw7zG4OPh/ukDl29LhFFpNRM5MpK56Tm8zoNA7u0w5+g5EUE?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d16a67c0-fde1-437d-cea0-08dabbfefc39
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:48:25.6424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAYrOtjjtCUfXCVacjiucTa0MhyIEf46tOEmeqTZlwPK4AG1hqAksQDMyHQb6O+eN+r4DnKjbRW5be4YfF55Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are Gen3 Aquantia N-BASET PHYs which support 5GBASE-T,
2.5GBASE-T, 1000BASE-T and 100BASE-TX (not 10G); also EEE, Sync-E,
PTP, PoE.

The 112 is a single PHY package, the 412 is a quad PHY package.

The system-side SERDES interface of these PHYs selects its protocol
depending on the negotiated media side link speed. That protocol can be
1000BASE-X, 2500BASE-X, 10GBASE-R, SGMII, USXGMII.

The configuration of which SERDES protocol to use for which link speed
is made by firmware; even though it could be overwritten over MDIO by
Linux, we assume that the firmware provisioning is ok for the board on
which the driver probes.

For cases when the system side runs at a fixed rate, we want phylib/phylink
to detect the PAUSE rate matching ability of these PHYs, so we need to
use the Aquantia rather than the generic C45 driver. This needs
aqr107_read_status() -> aqr107_read_rate() to set phydev->rate_matching,
as well as the aqr107_get_rate_matching() method.

I am a bit unsure about the naming convention in the driver. Since
AQR107 is a Gen2 PHY, I assume all functions prefixed with "aqr107_"
rather than "aqr_" mean Gen2+ features. So I've reused this naming
convention.

I've tested PHY "SGMII" statistics as well as the .link_change_notify
method, which prints:

Aquantia AQR412 mdio_mux-0.4:00: Link partner is Aquantia PHY, FW 4.3, fast-retrain downshift advertised, fast reframe advertised

Tested SERDES protocols are usxgmii and 2500base-x (the latter with
PAUSE rate matching). Tested link modes are 100/1000/2500 Base-T
(with Aquantia link partner and with other link partners). No notable
events observed.

The placement of these PHY IDs in the driver is right before AQR113C,
a Gen4 PHY.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/aquantia_main.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 47a76df36b74..334a6904ca5a 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -22,6 +22,8 @@
 #define PHY_ID_AQR107	0x03a1b4e0
 #define PHY_ID_AQCS109	0x03a1b5c2
 #define PHY_ID_AQR405	0x03a1b4b0
+#define PHY_ID_AQR112	0x03a1b662
+#define PHY_ID_AQR412	0x03a1b712
 #define PHY_ID_AQR113C	0x31c31c12
 
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
@@ -800,6 +802,42 @@ static struct phy_driver aqr_driver[] = {
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
+{
+	PHY_ID_MATCH_MODEL(PHY_ID_AQR112),
+	.name		= "Aquantia AQR112",
+	.probe		= aqr107_probe,
+	.config_aneg    = aqr_config_aneg,
+	.config_intr	= aqr_config_intr,
+	.handle_interrupt = aqr_handle_interrupt,
+	.get_tunable    = aqr107_get_tunable,
+	.set_tunable    = aqr107_set_tunable,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
+	.read_status	= aqr107_read_status,
+	.get_rate_matching = aqr107_get_rate_matching,
+	.get_sset_count = aqr107_get_sset_count,
+	.get_strings	= aqr107_get_strings,
+	.get_stats	= aqr107_get_stats,
+	.link_change_notify = aqr107_link_change_notify,
+},
+{
+	PHY_ID_MATCH_MODEL(PHY_ID_AQR412),
+	.name		= "Aquantia AQR412",
+	.probe		= aqr107_probe,
+	.config_aneg    = aqr_config_aneg,
+	.config_intr	= aqr_config_intr,
+	.handle_interrupt = aqr_handle_interrupt,
+	.get_tunable    = aqr107_get_tunable,
+	.set_tunable    = aqr107_set_tunable,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
+	.read_status	= aqr107_read_status,
+	.get_rate_matching = aqr107_get_rate_matching,
+	.get_sset_count = aqr107_get_sset_count,
+	.get_strings	= aqr107_get_strings,
+	.get_stats	= aqr107_get_stats,
+	.link_change_notify = aqr107_link_change_notify,
+},
 {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
 	.name           = "Aquantia AQR113C",
@@ -831,6 +869,8 @@ static struct mdio_device_id __maybe_unused aqr_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR107) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQCS109) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR405) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR112) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR412) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR113C) },
 	{ }
 };
-- 
2.34.1

