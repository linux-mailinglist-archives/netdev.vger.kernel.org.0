Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33293479DB5
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhLRVuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:17 -0500
Received: from mail-mw2nam10on2118.outbound.protection.outlook.com ([40.107.94.118]:19424
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234584AbhLRVuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzkItCJC3HA3EYE/CXEfQYQ1dWt0YbWBYOHKoSMZOQm8DBrqbcSOZqaXp45OdstiqoHR0xzCPlb6+AguM/uGGY9JWgMhwY2Mk3oFn69bECNGNPTj0sEBMJ7LliSrVYYddMM8/lNmuQd7lh4mJN2tQzsK3liS1lj1fL/fsRPvidC+CyMzCK5cPobDrhCvxlQLuhzh9lOUCRCj+NUNC2Z4JZOfEkVPs73pgUpLrAboz6NSruP3AZ6BNCPx9YVLrGco5UML0XZIzhs9h3Gg7A7IMvy6hHRumr56x2hY1mn1G6kVmg4UM/Lhb+eUuX976Vy7Th7a6G3Sj0E74FWtWItYOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7L+ch2FcrUf0zkFBDOZNc4FDSDPoaesnmW9gk57wzhk=;
 b=gZuUqWEsLT8+rmBVYMcEUb7aX/J8xH9PtvjRgrTU8+5t6cIYJNR5ajHtlw5Izp+6FkryiaDHyKpPtla3gml8AVaBIvn9G5p7Nm7wZflNglD++3CzmqcZK0C1co2G3RLFcBXsIupySrNm2TtO4fHbMcdQroqfx7OiWHSIipmBD9i3QlrYjpcJjiCGZbP1tcu34RmTUq6QWfeVB1uLlgUR7d6/phEJTC41Z+KFJstWS9r1pcIjB9DwiS2h/oMp1I95sLfkWUqPNa3iSqJu4fbGZVGaYZfI6AEkfNxdL4ragtI3/l93WzuHhujqCeA0sBveP2PlmazKMNVmY+DN4S4b/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7L+ch2FcrUf0zkFBDOZNc4FDSDPoaesnmW9gk57wzhk=;
 b=Y7ucBFCSzcHG0VoMnBrPzmHZESHjWNbAixHvbxXzKGI1PQo/d/5uW1wiDxwkLn3mb7zigKjX/wSR5C0z97UMc68TUE+TD88tsaKOld0EgOPteWT5ZcJgacFo+X51VPqr12pVv3NOAUk2jcAWBNPiCuNlrOsnhGbDHu9oUkoZzcU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:08 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 04/13] net: dsa: felix: add configurable device quirks
Date:   Sat, 18 Dec 2021 13:49:45 -0800
Message-Id: <20211218214954.109755-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c0cf8a7-4b89-4ce0-2884-08d9c2705bee
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633AE5A7C5BF6E219600CE9A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20yE39jlSSbuauD7r7DFXyNY61rFPWTDgH7ji7hq/wiUg4sx+QyDtWvsGL1NlDtgmBzsa/kT+skfW1C6dzO2DsFrVw7DAOaGeRU/0Numxwu5Nhj2UYa6cKMgRrjTAMMcyJPzrFN1LZCFs9KrOoriB4ne9zTUXPGakLE7a9ZLVR3orMmK+s4OUuvuBFgiY9IjEN6pH/xJ2UdyikMAyXJg5/eQSlgdtSlYjbnhVtce9MOjKdHyzB3SGJ1m/ToVyclMaPtXi24tC6f6YrxAmilz6V0uE0Jj6yixFbqWKWnFRVj9wa8tgc7kDOJT02m6q2LPKOTbhFwqQnFqkVSMwklyTHKPS2zd4IewIDlpjI8wqkSrv8cQtWHCxfiVZhuq+X9io0Qkw5cSdmR0fijx/XbMDEgaVNlzWqff2qIP5tu9quWOAM1vi+tXCn1MxBjZK2U2VrIuN25r1nZdW3QEVvYiP8yYrj78PzfwxlU0Gmm7cr9t+kWc/csL/OFPr0dpTa3kywuZNeM3K0a2CsNjExK50iVw2Wp5K+OxemSiTVnMcMeZSK1jYP6oKNpbtxRA7gX1ylD2gbUa7LHlqtiLvgq+xj/xnhG54KMRspwoZt50DQyj3GkWwWYgCkMYT8AdiFzJG+W4ZwwtAOgoUu6B8c2dJsQmya089ALNQQ6y//l45wkjH8ZhI/9a6S/6yw0jHUfg3W0BdId0VFWhMRVb54+Jyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1rEXSbPS8eu0Fna9gRepvjtCEeWdjdQ7tzzZe8IG5rH5SzHauLypau7RS20I?=
 =?us-ascii?Q?hvw/cH8Eh+CTmGRK1BRhYXw2O9vg7BmoJK1j0J7mzia8mQprNeY5ZS/J28T3?=
 =?us-ascii?Q?2q82nBPFcViW2TMr/cXsXw5rbaAHFy2rFvBodo9E59ha04SpT22mWSJlHIK/?=
 =?us-ascii?Q?693HRihrZ7Fiq9lVBcAdGTPCOBEHMP6oSYReWMhJMkv1z+3GTKTfaUT/+8SM?=
 =?us-ascii?Q?9z0c83IGtAxzM70YwbaIuJOEyLNxN5aI2mfo8xkOsH4dIX3QwCloAZicL6wd?=
 =?us-ascii?Q?3vafwHoYGzXzWClL3lChmrPvJOGzbl0D2010jSK1hPVUT46X0JjMaDLrBCFI?=
 =?us-ascii?Q?ly1NCmKzFR8BbwwPr5T5+BoEYhbY5R/WL6hZHQqlqBV0L6Zq55/7l0xTIeUx?=
 =?us-ascii?Q?JVejYx/9Y483lmXbo/robInZZqVdqppz1Joex+2pgIXBVr552kGBMGYY+AfU?=
 =?us-ascii?Q?X7OOtJKxtoEOF8X340yIG/sc5dLUu+PfTqBNd23a7SS2Pt5DIM8vgroHaRyj?=
 =?us-ascii?Q?CDOo/oRm9vaMGEn/BDi6zc+sZC5tWtkanLF4v0uL2GFJBedNHcetqsshsttL?=
 =?us-ascii?Q?MeUQRH3UwEZwfguQPCSjLcb4AX2bAU4vpdzbvFbR5nkXKDiO38+QwYNhwIOf?=
 =?us-ascii?Q?J7jzOCASu9ShBlgQxdFWsWPIXaxHQOQNUy2istzWmCyge4iac49Bow49T9+y?=
 =?us-ascii?Q?psPHGATwPhyfIguT36JnNXwcd0x6lvEOTGO9FBtUAJMpIM4srI+cFGS2ZCC2?=
 =?us-ascii?Q?uqado0kWo82PfWIFI7G9uCbWrFXrWb+DT4gSIBE0i6nuVt1sPWIzlDv3Oapy?=
 =?us-ascii?Q?z2z1UfoV7cTatr4AM+npM9rUF9CbEJlPFRT97BRrmdW4PVOBB7hE4EaQ3i+i?=
 =?us-ascii?Q?MtTT5R7Oxhpy1TFEN7Oi0fBNOyZpfGfvlbJ9kLH+nEV9pn+SjX31t7vB0KDp?=
 =?us-ascii?Q?dtQgqrdsSH+NRxU5WftNvoN+2wi+geRU+URWem9xDHSezqPYFFudG0qLztfX?=
 =?us-ascii?Q?jpwN+SgFumdXgildhP/oYdD7cdXxutMY/HZAg/5zRT/5cGrJoJUQcOgGCL6N?=
 =?us-ascii?Q?FSeclU1xf2cp/gL9ocP2UAmRAGZmBY1lrYxBZjZl6qob1DrlJmPlhu6rRoks?=
 =?us-ascii?Q?vyda8Kk7LcqTthsnma4ajMNyjrJ8ApkhVpSYaauwn0Hy2ocX6NPSVtJfh4kq?=
 =?us-ascii?Q?Jqhqno18I57W8+wJY5JQNUvbYddLDZEEK2t7s9sI4z26tH3UNdGwwoSK+pNq?=
 =?us-ascii?Q?bPI//yKg4KxZOCMEV/SnpWB0JdiwZid55NtT4Vdp5QHDnIs4PNXkRhCZltyo?=
 =?us-ascii?Q?FxzTuxLw908YZODp1DSRV0sILjbBwD1IkbhUL/n/bERhsumnay/MBYLSLZto?=
 =?us-ascii?Q?2C2pba582a9bKXjwucFqcYI7jUywO2yHjEUFzoVvBuBen9306jWba52670HS?=
 =?us-ascii?Q?pdqrbECzilPBxdq8igivfPCaHVn1L5dwMtXpeNIdqPDlRZbYy4XCqtdnGYhb?=
 =?us-ascii?Q?prAe8iuY+97G7MWBidm5VCwmhBg6UPqF+AUm7nh5Uf5zAunN8ELRmjkoraFV?=
 =?us-ascii?Q?lyTV06gszQUCUZjRs2zMeinPsez5uEzcNRprR424FvBWZ4HC7rYnklhilHj3?=
 =?us-ascii?Q?MEe/mAbDSNTYOSnuotx8J47DPexCoB90HFOMbWefyBUsT7xcWOptrsKC+UzH?=
 =?us-ascii?Q?V2T0uA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0cf8a7-4b89-4ce0-2884-08d9c2705bee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:08.7377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihxktbP1jOvvPKjvtTnhnLSe3qfMwBpQ4Aih250k9AFL2Z/y3R+P53X8IcPg4vMrJckbq6EoxwmnO672soYq3L8ReRd8mHjUuR+mTw/xAlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f4fc403fbc1e..757ae35f3d56 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -840,9 +840,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -857,7 +860,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 515bddc012c0..69c97f35a607 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -26,6 +26,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	u32				quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 110d6c403bdd..c6ee393fd35c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2229,6 +2229,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e110550e3507..a7db8781310b 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1097,6 +1097,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

