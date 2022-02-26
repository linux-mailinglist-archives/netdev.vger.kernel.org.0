Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3D84C5880
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 23:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiBZWhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 17:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiBZWhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 17:37:43 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2102.outbound.protection.outlook.com [40.107.244.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC25652D0;
        Sat, 26 Feb 2022 14:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm2DcK1JgwqC4tFqfpshJsyCf6a0Io+fU+r7LKohshLBNOHd22BBkOfyHjM9QPG2ia31P1MbhLGxmNIiT+iZZePKZZigb2XSn+UCB4iAZm3OW6Jqw7m8U3nyEsRGeImLiuMXYWU2YJKhYjwoAiZV7iUzTTu+wMUM0g3TtD8zvHeW+DS9Xe/kReEAUfuhSmmI/yQA5EQyp9BFtIJTUms1hspuRJPBhjmbkj+DHBgSzWDa+dBh2V1d8dS34aaH0GLdT6v/2/tgKgFrE2W3DVdRnakJ3F1Rd2TRXdHAtZhdz7XmNKIq2HRMxVozsYxZxaFF+YPl5RgTudKSjU1Zl3OYJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upgyjGx9geK+UQPlZCccZChHb9BhM5u00Pvp0Ck/Pio=;
 b=eAMPVvb6dcc/Y+/XjSIXp7ka/olS8xClYdKGELLrbFVhFtDWIDMjrVvYCURY5Y1yxBHaeoMjOc7NGh9q97hKjfYiyv21Edfb2NDjHmDoFQ3aje5xc255I6tNut7wTZ44jlq+uN/9uDpGwWUlodsLTJJSPOtEPE4X2Q8xw0CJFsytifO6VjuujRvadDCl5TIl3vxLjD6es8sqQwt5AJR32FCXDv4diGXTH3RXefOPZgaHoGcs+57oRxdAdgz84Tmslsn53EaRPd9zjkpSP5g+cPjUFEBOdwWfobPOvwB6M1cNCbQwXzHn1UAXlUwv5oMrekAzb7DgXXQSaQU46YRglA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upgyjGx9geK+UQPlZCccZChHb9BhM5u00Pvp0Ck/Pio=;
 b=qwRO8LFpVwMtxDEjK3/Lis7h5XsiE27zv5TuKl5Ex6CZS76B8m/w19icVfPex/VKi2G8U4FPmt9hAS1ecBu9tppKizh0hwIbRYk4a7Hn0Oi9tugSmw0KOG9rSKxvGmXT41g3XO2wNq2IuBlAN4S4sK+74HmNBltPJkOcl1651j4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3050.namprd10.prod.outlook.com
 (2603:10b6:5:67::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 22:37:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 22:37:04 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 1/1] net: dsa: felix: remove prevalidate_phy_mode interface
Date:   Sat, 26 Feb 2022 14:36:50 -0800
Message-Id: <20220226223650.4129751-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:303:16d::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f42830d-ddf6-4a90-017b-08d9f97882f7
X-MS-TrafficTypeDiagnostic: DM6PR10MB3050:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3050EB085C1D5E7A82925021A43F9@DM6PR10MB3050.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LSNZ9rGcszKLD/I/n01jenW46jFE7DBZmk88fPMEGxGhuEei+4dxE0v7J3etnd9QtqG/JTA3CE0GJoWB6ZcxkWTXslCL47NcpuglXROXvdeUrqYrxfVBXJ6Omx+JL6ck2JEnIFXpMAhTnTeyoQrUzELJKq/+CTzkc9g42o5KK+t/HmhW0DLJx+LfQBf2wbyEGf6CHS+Cp1ZjbQdiKKqmDzQ4BKHcJ3E4pdjPJA9q3gRBPBFFgvdMzodHaozYoA21vFEpUfmoPeEULC4rT9T/uhwgClbMeIO+l0s7UgbEgGabfdCEYXQPGfXpTJP9cTKHf5fyqAAxlrTNGYGOaeBj2AUsxs//ifBKwD/GtVjD/NtOGNV4fX5RXOG0lDwvfB0joGgfse3JUEAEccfa/aOoNzLKJNuQY/7sYoBSPkQWXFcq1J4g0goYy20DmbkfXQdMb4H2UafrYz/HqggLiYygsOAvI2JDfKmkDut2UYXe0cxnazscgWAEokjayFeBbocR5gy+IWvmgkFIJ0nI3hvnhikYBCX+Z/5TtVZXbDy86URfpRTN4yaXU3KAeO9C4J45a+bXQFczlPVhdulc20r4f6s2LLQnNJ8X6ky3EcrcbQ00WA2QycZMgUyk45TTxltEqMiTZRJ+ZT4TbKffCmPtrcahspP6vKCrdBAPDdEo6l9T1KvEHrcaVHELKN+rQQYC2I6c0iF+2C4+YPlYSbtMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(376002)(42606007)(39830400003)(346002)(366004)(136003)(86362001)(83380400001)(7416002)(4326008)(8676002)(5660300002)(44832011)(66476007)(66946007)(66556008)(8936002)(316002)(54906003)(38100700002)(38350700002)(2906002)(6486002)(36756003)(508600001)(6666004)(6512007)(1076003)(2616005)(52116002)(186003)(26005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EW8Q3pPizzlr2Sv/2XoJm+h3zzyLWG3VcrFW/u17T2C7SB9RdJUlHTZIGIRw?=
 =?us-ascii?Q?7KoCoWdO/FaxVysn5riCyuGeGXFB+tO//py3mbfpNAVQYj2YHf9500F7B0o9?=
 =?us-ascii?Q?/c03rhVfYYMREYKjGGWR2G1hUjR0BBjWUgBifNk4c6DMEYSlUcJ58SBjIaTd?=
 =?us-ascii?Q?kv9x83vN58MzMC+U6EhDObgUpqATomzsabiiHkXV6fH47y0RU/dlkgPBf6B/?=
 =?us-ascii?Q?YX2X5EKhpVrkIxjEZrJ3VOU9/G9oP4T9QkQzdF4suApDAbCS8/RC6bxoHVTD?=
 =?us-ascii?Q?M6xcyIPSQdWZyX/wBHUpz3pGcc1POqdBzl6JNiABi64uLJdfX3uxTM2t9sxG?=
 =?us-ascii?Q?EBVudjQHlGQY8IlcWcJexWjnf3NxhkLu9CYWvCZ/73taFYARkEt84VCI8VQ/?=
 =?us-ascii?Q?/uE5lEQ435p6KEacBq5zPGKiu43gNm0usPfg+byh1foNhKlBrQXmqjwYSJi8?=
 =?us-ascii?Q?wSc9y6S2Hggr8prqInnMgM6FRM4GRwW0G99tzNMZBNC3On0PU5xBksL76N61?=
 =?us-ascii?Q?HDkXpoMr8FV99WD/766p2MM2Sn7yHByQjg9m1WJGoU8WZDbueMEgL5N36EyS?=
 =?us-ascii?Q?L19+g+KKdWVmSRzPK7JogjNihFH+J+dNggd12WqkoKJViQOfXpp/LBdcb0yx?=
 =?us-ascii?Q?WXLLN/TWGubQm4uHADTiejvULX8XP74SZAxCRX2Q9t1cEAoS2t3mH5ZJ7Apb?=
 =?us-ascii?Q?lKC/sfGomxFPEq3GzuPCe1QBSYqYtdfRoeFesRBO2tGCdS+KbT4ef2LKdYro?=
 =?us-ascii?Q?VFoKUYk9d4FmawV1zHo1XamiJrqZ6ErnLTfwPs0/+xqNk16oE+GoekG6o3Oa?=
 =?us-ascii?Q?A8u6ZnS5hCArfMzvkaW+T+39WyjFBkAS6YOACldB7isaXZryIqQs5nOU7I+q?=
 =?us-ascii?Q?JxzRMViiGR0oQH1svdRtoCRND7U4XKU5eZ5SgtrWC5HqvWr98Y3gABGs831a?=
 =?us-ascii?Q?YA34ABrCErjGi+phOcummgfzcxHiCFaReZRedbTkytbXeJGA7YNnVEmfYY8V?=
 =?us-ascii?Q?eCCcAhWTfk8MwcM9oLu10OWiHywREIuOB4ZCqqiRsnsu3FeJA4pMG9yoSeAv?=
 =?us-ascii?Q?mklQ9BHQImc2GNGXSc65SiAv7f6NTzYI509pOHRXsMepHInc5RFyFN6lPH5p?=
 =?us-ascii?Q?XC7n7ccIWISg/mjiK4qXhmcNU+sdE8Q0eTNFbqnXR46SgNbE+TlSZ1gThivX?=
 =?us-ascii?Q?NO4HUbOpW9RnTofQ5XoZTe9IEzap1OM69od0HoA2lhtMAc3f9EMfpN0E3pX0?=
 =?us-ascii?Q?ZZsJsx5bmspbrqm90qflTUC4slLGb+V/kywQIEMcqRk6ejmUg8rpQrKN4+CE?=
 =?us-ascii?Q?MbBbQKZN/c+86Hqf9oN8w5ou9o+KwSX6QDW7J9yuqXGshuU+60ru7k5ZW3A7?=
 =?us-ascii?Q?mRQw7AUs0ODOg1rGg0Yf+aXrctoyD5JAbmFNJ1e65XBa4zH2qHf7ASncTc/u?=
 =?us-ascii?Q?dJYtpvD2Aya9dSyP/xkFk8GsKXfF2ztoQWGB3loiWG2ADPewfqh6xXo3AgSO?=
 =?us-ascii?Q?INn2JSk/TjkigY1iF3qKkwx5+04bVlHSfgwjym0UsI+i2uUYtyNUJCLS0pWN?=
 =?us-ascii?Q?wJ4nEERAlIl7T3OxNRHCvQu4HQTs/XxLv1acaoNEDFfD2FfYGvM20MTwp+xj?=
 =?us-ascii?Q?gPlbcpRyK4z9ZaRd4g1/yURQevZrjMAuoc6UNnjiII5UZP4uYrqxrqoQ1D6X?=
 =?us-ascii?Q?9WygCvsRzw9Fo00PMQCU6sR8VOM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f42830d-ddf6-4a90-017b-08d9f97882f7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 22:37:04.0597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ty3swKx3i0tNSKDvddCQxGHOvYmsTmTVemYhQF5y9LCE7JPG83hHZCNO/h/JYIzTQApo7iAFKM4TLecZ5m2lMxxzn941Jr/Ub7FdlLi+Kds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3050
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All users of the felix driver were creating their own prevalidate_phy_mode
function. The same logic can be performed in a more general way by using a
simple array of bit fields.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 21 ++++++++++--
 drivers/net/dsa/ocelot/felix.h           |  9 ++++--
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 40 ++++++++++-------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 41 ++++++++++++------------
 4 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 1d7c5d7970bd..2bc87e3f4321 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -897,11 +897,28 @@ static int felix_get_ts_info(struct dsa_switch *ds, int port,
 	return ocelot_get_ts_info(ocelot, port, info);
 }
 
+static const u32 felix_phy_match_table[PHY_INTERFACE_MODE_MAX] = {
+	[PHY_INTERFACE_MODE_INTERNAL] = OCELOT_PORT_MODE_INTERNAL,
+	[PHY_INTERFACE_MODE_SGMII] = OCELOT_PORT_MODE_SGMII,
+	[PHY_INTERFACE_MODE_QSGMII] = OCELOT_PORT_MODE_QSGMII,
+	[PHY_INTERFACE_MODE_USXGMII] = OCELOT_PORT_MODE_USXGMII,
+	[PHY_INTERFACE_MODE_2500BASEX] = OCELOT_PORT_MODE_2500BASEX,
+};
+
+static int felix_validate_phy_mode(struct felix *felix, int port,
+				   phy_interface_t phy_mode)
+{
+	u32 modes = felix->info->port_modes[port];
+
+	if (felix_phy_match_table[phy_mode] & modes)
+		return 0;
+	return -EOPNOTSUPP;
+}
+
 static int felix_parse_ports_node(struct felix *felix,
 				  struct device_node *ports_node,
 				  phy_interface_t *port_phy_modes)
 {
-	struct ocelot *ocelot = &felix->ocelot;
 	struct device *dev = felix->ocelot.dev;
 	struct device_node *child;
 
@@ -928,7 +945,7 @@ static int felix_parse_ports_node(struct felix *felix,
 			return -ENODEV;
 		}
 
-		err = felix->info->prevalidate_phy_mode(ocelot, port, phy_mode);
+		err = felix_validate_phy_mode(felix, port, phy_mode);
 		if (err < 0) {
 			dev_err(dev, "Unsupported PHY mode %s on port %d\n",
 				phy_modes(phy_mode), port);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9395ac119d33..f083b06fdfe9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -7,6 +7,12 @@
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
 #define FELIX_MAC_QUIRKS		OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION
 
+#define OCELOT_PORT_MODE_INTERNAL	BIT(0)
+#define OCELOT_PORT_MODE_SGMII		BIT(1)
+#define OCELOT_PORT_MODE_QSGMII		BIT(2)
+#define OCELOT_PORT_MODE_2500BASEX	BIT(3)
+#define OCELOT_PORT_MODE_USXGMII	BIT(4)
+
 /* Platform-specific information */
 struct felix_info {
 	const struct resource		*target_io_res;
@@ -15,6 +21,7 @@ struct felix_info {
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
+	const u32			*port_modes;
 	int				num_mact_rows;
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
@@ -44,8 +51,6 @@ struct felix_info {
 	void	(*phylink_validate)(struct ocelot *ocelot, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
-	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
-					phy_interface_t phy_mode);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 434c7e4f0648..ead3316742f6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -18,12 +18,27 @@
 #include <linux/pci.h>
 #include "felix.h"
 
+#define VSC9959_NUM_PORTS		6
+
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 #define VSC9959_VCAP_POLICER_BASE	63
 #define VSC9959_VCAP_POLICER_MAX	383
 #define VSC9959_SWITCH_PCI_BAR		4
 #define VSC9959_IMDIO_PCI_BAR		0
 
+#define VSC9959_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
+					 OCELOT_PORT_MODE_QSGMII | \
+					 OCELOT_PORT_MODE_2500BASEX | \
+					 OCELOT_PORT_MODE_USXGMII)
+
+static const u32 vsc9959_port_modes[VSC9959_NUM_PORTS] = {
+	VSC9959_PORT_MODE_SERDES,
+	VSC9959_PORT_MODE_SERDES,
+	VSC9959_PORT_MODE_SERDES,
+	VSC9959_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_INTERNAL,
+};
+
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
 	REG(ANA_VLANMASK,			0x0089a4),
@@ -968,27 +983,6 @@ static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 	linkmode_and(state->advertising, state->advertising, mask);
 }
 
-static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
-					phy_interface_t phy_mode)
-{
-	switch (phy_mode) {
-	case PHY_INTERFACE_MODE_INTERNAL:
-		if (port != 4 && port != 5)
-			return -ENOTSUPP;
-		return 0;
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_USXGMII:
-	case PHY_INTERFACE_MODE_2500BASEX:
-		/* Not supported on internal to-CPU ports */
-		if (port == 4 || port == 5)
-			return -ENOTSUPP;
-		return 0;
-	default:
-		return -ENOTSUPP;
-	}
-}
-
 /* Watermark encode
  * Bit 8:   Unit; 0:1, 1:16
  * Bit 7-0: Value to be multiplied with unit
@@ -2224,14 +2218,14 @@ static const struct felix_info felix_info_vsc9959 = {
 	.vcap_pol_base2		= 0,
 	.vcap_pol_max2		= 0,
 	.num_mact_rows		= 2048,
-	.num_ports		= 6,
+	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
 	.phylink_validate	= vsc9959_phylink_validate,
-	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
+	.port_modes		= vsc9959_port_modes,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.init_regmap		= ocelot_regmap_init,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index f12c1a1a3d5c..68ef8f111bbe 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -14,11 +14,29 @@
 #include <linux/iopoll.h>
 #include "felix.h"
 
+#define VSC9953_NUM_PORTS			10
+
 #define VSC9953_VCAP_POLICER_BASE		11
 #define VSC9953_VCAP_POLICER_MAX		31
 #define VSC9953_VCAP_POLICER_BASE2		120
 #define VSC9953_VCAP_POLICER_MAX2		161
 
+#define VSC9953_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
+						 OCELOT_PORT_MODE_QSGMII)
+
+static const u32 vsc9953_port_modes[VSC9953_NUM_PORTS] = {
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	VSC9953_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+};
+
 static const u32 vsc9953_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x00b500),
 	REG(ANA_VLANMASK,			0x00b504),
@@ -938,25 +956,6 @@ static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
 	linkmode_and(state->advertising, state->advertising, mask);
 }
 
-static int vsc9953_prevalidate_phy_mode(struct ocelot *ocelot, int port,
-					phy_interface_t phy_mode)
-{
-	switch (phy_mode) {
-	case PHY_INTERFACE_MODE_INTERNAL:
-		if (port != 8 && port != 9)
-			return -ENOTSUPP;
-		return 0;
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		/* Not supported on internal to-CPU ports */
-		if (port == 8 || port == 9)
-			return -ENOTSUPP;
-		return 0;
-	default:
-		return -ENOTSUPP;
-	}
-}
-
 /* Watermark encode
  * Bit 9:   Unit; 0:1, 1:16
  * Bit 8-0: Value to be multiplied with unit
@@ -1094,12 +1093,12 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
 	.num_mact_rows		= 2048,
-	.num_ports		= 10,
+	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
-	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.port_modes		= vsc9953_port_modes,
 	.init_regmap		= ocelot_regmap_init,
 };
 
-- 
2.25.1

