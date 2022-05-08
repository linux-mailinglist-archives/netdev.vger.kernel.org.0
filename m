Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45F751EF59
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbiEHTGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382524AbiEHS5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510EDBC08;
        Sun,  8 May 2022 11:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzJsNqBDbwgfO9fjHlte6OAvYIdnbElhBmVIE+8Rh427IhcbIO9ogie2R9whGQrM730KY9L068jTbwDyc02cwhslgnqKtLFjmH+6xd/Y+3VzPylkOVDeQFkMKF8qRu7RiWKE/9mgeMJIKVYCRoRcTWWWkB61Tjy8BUzgcovBZXXTw8RSHN9Lxz93IfrUpxauNVShDP0MWLBoHUF/u86e64Pe4lua7a95o4NiVqbEfFZmHmUCvcKSxbrbn/gMxq8K5P34WfwXHyHAFWeJEbXfzGgmiti491TriNg7j7TwA6RV2nNjiAFr+Isx5i1IC23+VJ3ZZ4L6sbK1W8v1Kw6P9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gx6AZJnfc614Ow3stmxcAnCSyXe6NZrFhq+L/kh8pzI=;
 b=coMIbYo2Ptr3jXfxc1hqvhlRV0k+f6On7xSbOExSjRXI+ctF5+fzKVDKBnUnPvFaez0gv8xFBF+5x5fRJ10yEmW92irzHHsA1c3oQ0TiWYMyACZsY8gjTW/U2JzMgaEDsoRNYqqMZimdeRbIHewOslFRTDU+bYlxso36H48Vqlfg9XUuCyZ49orG459sGuIR1MnWbny9jKyw+Fjcv03EhNDY5PpzXO17JQcm+e9oo+ZwrxgSOXwxwIbuL9tgtnfv3cw+7ta7KTZIoLdVVkH1mgttEo74c/BG6wQ1uEf6+Hzmtl9jM128gsCiDQpEqsJ5LEI84H5/kOes2FvONe4p9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gx6AZJnfc614Ow3stmxcAnCSyXe6NZrFhq+L/kh8pzI=;
 b=nIUNiq5CiFfHrYjjDxnJQAFK7HOIoJDa2XoWsSJPLk4I9ANAHQh2b2F30ef3OpDnV9YwoG+2PoEnnVfhs0iCollUZ9/GepmPrBAYpzYZZoVdcRNizDUpn5EL1qGfg2GrTdLCrJdiQGkRccb1vWz5ANCyDNFRhY4grTvPBF+91Zs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:53:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 10/16] net: dsa: felix: add configurable device quirks
Date:   Sun,  8 May 2022 11:53:07 -0700
Message-Id: <20220508185313.2222956-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7357b10d-a843-488c-99ac-08da31241729
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672C909C97DB42E5A2BE4DCA4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxqaJjfguqqM5JkPY9WZFFgMhQ38eUe4iaIaPcvC58C7CSemwOTUrCmeD046aJmgqO9aabFlP6QJFu2QM5ngHTCj/Nhg+zOay30apu+oPR6vz3G8DO2MYqHYmxMbyaJUvZWBYbb71PpwXgKx6cFHZiv2xoSgST5iZW85banaXy/CLI5KbUXvofv/a+fd2Pz+XVtldvEL91p9ku5uVvEwSSLDeO4nKP2VReEKAz4Q7RC6EoYCkAizwiiuE3IA+Bd/iueFOq4KnloE6ZiZRch0pHUmgqs0oUnELOBLd7GqRlfw8bAe77cZ8OCmcDQSMTXtQrpUd07UBfFiloNzP+phT5CndfMji31Idx9xiQcpljBFO3ouEz0G3GIRwr4HAh2k3b2O1VSokCEQxn5i8vnNBiWCve5ixbZZWeiLjHQoT2oKd6bN+97mFQDABs1bNErOUqDNcfVxAXhCXgx4b4JoDvPAm641TGDJrgq4R1DP+LIzQAiVWKSmsvcMqtgLyhcaE2Wf+4NlMdUQa7OWjMYMbrmSgoZJ7W/OBinSdwjLIaU5zi24Y3Lz6htCUNRrf+2EsZmJB4dMzEs+Xqd3pTXqKwp/J0b5fIb6P+Y85ukf8+xCvKPHU4Ll05ID6M8ZH2ZFKhKEkGbKikgBwLeoMx4+tYBWOI0d2croEFpLZmjz9Tm6Yw+XWUSTGNMf9e8fxQBN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h3LbwlwUNskfxDVmV6mGLnZ8vx1I3nqXT8XZ1P9927aROYpWO9iNvkeb6Lw/?=
 =?us-ascii?Q?M5gloTQ/7aEiUOdVXzLCXPavaatc5Zo+gtLALbJk5o7h4ZdYMTy+3IuuU048?=
 =?us-ascii?Q?+ndAkJClCHlir0Z/GP3WDrRDpE/6ZGWmVnA1BoYlyBVNCpDdAfP3/z6eck/C?=
 =?us-ascii?Q?xEDaiFcxH26Pr4QQMB4fu4iZPxvRWDjLFpvlrNEnwaC9ZcvVcCXsv/5EeIUp?=
 =?us-ascii?Q?SW6C5zlSRzPyJ6Wropk8yLPtsy2rqa8JOBdhjp4NRcF7Zg71l6S/ADw2H4tq?=
 =?us-ascii?Q?iPHnoBDLGQJmXLcdzL877lgZ/nLo3X4kzuAHdjpbHWQNwaqDOKYG4fsbL7i+?=
 =?us-ascii?Q?bvNsEVJuMhfljv1v/QlnsHFw3aC+jB/bVQ35C8C1yjrKbAN4qG4aVBALRTEA?=
 =?us-ascii?Q?4I9+Q1xM/C5Hlv/JcladeSubPvnsWMj2NG1o+xxFYs3HUbw6dLiDBiy6a2KR?=
 =?us-ascii?Q?CXHojfXeVSh7FVL8ncCKMVDCEXjhYvzrcLWoUifOjql5CZ2ZxrSGx262hliS?=
 =?us-ascii?Q?zXLkiqf1ZrVGfOCiZoYV31/5FoG3t0inGbex9/1JDujtD3KQJUpGdQ8/3JTs?=
 =?us-ascii?Q?OI03CDSN4C+Lf2b8PxTAfazAKrCqAHM2MZepLbWzspOaZp3CgsnUKcoEbYRT?=
 =?us-ascii?Q?X+r7hD8VMNy0nsQIf5pJWeYBhdigFiyyTH+SepieIYy9+04WqT1V9XIIW4t1?=
 =?us-ascii?Q?X9ELO/RUZ4/8feJ02pdmkSLdYJFCiRp6oxYcVWFg6IKvhN93m2NpkX0JevH8?=
 =?us-ascii?Q?ZQwIxYUPz8rHjbk/80VaCnzyG4Qn79nbsfQJvX3RCdvG+MmPQqIQn8hOIrXB?=
 =?us-ascii?Q?UwWxA3f8p0L72hC7GwKI2L+Y3FpPEvL1US8k/zvmNqoh4lJGpUca3QIZ+c7V?=
 =?us-ascii?Q?xlJxw9U9Ei3bpl0LHUDBgeQ5xFTCUYTROqTDiFRMzdTS82ANVn2bZIrjp/4M?=
 =?us-ascii?Q?oIoBHqm+I9EGhlaLWr/NK4s5XXXrDjyrvHWuye8do4Yv1poXm/ziKpZ53I0+?=
 =?us-ascii?Q?tBAGI+wlNtUsQv+aw7FHtyWYZB2Xs+P6T6hAN86dufT0k/eE+SIGjYwd9/BP?=
 =?us-ascii?Q?T937neSx1H1Umao0ui2sKiNJytXjjZw6FB/UtQXiyneOTHy1Ij/tcBsa92MM?=
 =?us-ascii?Q?J9GkBSBqDZu2pF7LmLj75Vl7t6MVv40pK0YA7w3e5FmBvHRJeCQU1IAv/REg?=
 =?us-ascii?Q?hZR9sPJzZ9K9hN+k5NSgR1k7ttjxSnyEpnuidgG0bsheS3S8znGDhWHLXG4h?=
 =?us-ascii?Q?ok9z3K60WqSViFeVV+K+1yBf9eXEGK01LVTLc9wipIByKZsy3V47RUCFu3/s?=
 =?us-ascii?Q?B1b36oWxKA/BAgS/LxpfIwR8fQ1FZjuUIzQzGwBDwuBq+E7+r2G0X3nokfPe?=
 =?us-ascii?Q?2C7uI7qZYZfedoJUVGpxUY/iZc6UFugwOs4VOLaO0Sa3+1BOQ3ROB5e/iPik?=
 =?us-ascii?Q?ogjVrshQgC3o39JwhCheZTjk8eQXBnj7HNhHhaqhQOhwIC8ZwWZhzu1HJcaT?=
 =?us-ascii?Q?mFS4obJklKCNvuujMnSv+aft8d6pcSH3MHvMfpUoTJKaIqcL+10EeJB21tuC?=
 =?us-ascii?Q?DEz9V8MCxusIlAxr+tzpjf+6hvN0Q7RqoSQ42xQkmjJ65fWF35Rk1MOehdIM?=
 =?us-ascii?Q?TqvxIc18agdx1vTmnl/X+/NrrP9xRWOleJwANRnbLT91r0dIJhDCuVAdmA1J?=
 =?us-ascii?Q?OtNIAHWEs8RwqH91KhoODDVMm8HYAAbVizYAT0QxzjzCc6LE8CNzR0kfTOVD?=
 =?us-ascii?Q?NaDADnbBlAq4VOsFfXL5gsH0R8gyLW3jNlv0qC+i3OurHVw1IHLh?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7357b10d-a843-488c-99ac-08da31241729
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:50.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLU0/D6O6+sk4aHoBEhZsL2T1jNmOxB3+urWh/4/5qd73RY+PMts3PryLF+1mSjz1FyEoGm/48o45Wap6SviBwfuUXCRp4+TxndtCEswh7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 33cb124ca912..d09408baaab7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1023,9 +1023,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
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
@@ -1040,7 +1043,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 39faf1027965..3ecac79bbf09 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -32,6 +32,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 081871824eaf..95e165a12382 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2225,6 +2225,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 48fd43a93364..e1400fadf064 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1092,6 +1092,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

