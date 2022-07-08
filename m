Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2003E56C0AC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbiGHRHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiGHRHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:07:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80130.outbound.protection.outlook.com [40.107.8.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7075565D6D;
        Fri,  8 Jul 2022 10:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rh1jpU+gj4OPGJlJpFRgVL8M0j6CV28+n32SMIZYI8oFXL/nQN/mM1h17L2dJJA64pyNwy+dIpapCtkRM4pDJ0HASNo7dskYQvHLfrnV7/ZVTwSrnnaNao+IWlbqxh7t8FWllQ1FIBiuqZJMt4rzkrMNXpAXrx86ncwsXxYcn6EbwIPujGW42QsG4iFc+ioCHzxNygwzRA8rLRSeu1G1v7Yh6lTN+X6Vq/INjUF5UnP5cFYprOU70MR6doL/fjdhhRTU/oj2+eM0l4yAQ0+t7keAPyeyNkZGIEVC6HPdKi3LEOxMGB6se4tLUCYBI/Xb/0pT8sXXA3F7VeHKoz8qrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMZ5aCs1iVFBXSrmFLtuZa4xVIEDtr7Ev+B3bGOtkHY=;
 b=SmN4FgVrvVRp5HH6xHEccfwnhUN59gXP5pYpIkjElGKN5mwweJDYMypIL/Ad6hsUCmlmcNtJnRmPC9eQJ6lSqoFRC87oHZWSL66yCwFtHspZ0rISel+xrDbwltedTBgOD/U6Cc2p5pDTbTPipVZhGkuQVfDJugflgjYUksAVNa1gf2nvfGGnPy2Wp+u/c0e+IUXRiNrwUxQSDH1BOavgil+6fQ4OQDvm6bX9lN6+S5Dv8I6a74UIwxCc32pJ1VewhMS6nxco2l8TtKJZB7VecrrPvq7O6CaGs0KncFOy9XgsTm5lvLmV1K6vnwTBL2KA2b54OW5lm9j36+WjOTreuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMZ5aCs1iVFBXSrmFLtuZa4xVIEDtr7Ev+B3bGOtkHY=;
 b=u2II0q9pvU3/H3yWxgdenAYJRNq/XbaHFZvpPDbNDiu7T5EHrJEikpXY0Q51VhkI0rgS2MQwql0/+1pIT1vVNQAV7+x8g7LGyKwAA2QqnRxcS5p+yTPRDIOXzVU35jzcTg2v8LstzIqqusgGU2rs+3aZrNKH2eV6FquoZMQ39U8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB9P190MB1842.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:37d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 17:07:33 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 17:07:33 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: [PATCH net-next] net: marvell: prestera: add phylink support
Date:   Fri,  8 Jul 2022 20:06:34 +0300
Message-Id: <20220708170635.13190-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0048.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::29) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 562300a6-f037-40a4-671f-08da61045924
X-MS-TrafficTypeDiagnostic: DB9P190MB1842:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TIijtTsrAHiwWoyNyJIl+8Rg23X6ZiC8qmskkZLxyhjiHK+gMyn49VlwwF/kXeFhyW43UbnW07y4jBflAzydLSzluozuLnfY3zo3pMKo4zmXqP2fx+IMYepiqdc7KVqcouENIa7+q0sw7OXOEj3POn63TrzI0UCN7+BC6qQ02VciNQO5ENt3tyUEeOXVn6MVQegEW4hLJRQxINGQw+lNH/inqNLXzoOhlWGAxPvuxhZi3lEC75yi/LSrpX8f7ThcZIgXorGHbjOMw930brSOr8NtWtxhLn5OFvhbz8a/c2EKllYS+RWQWF0kRYgJV0KHMBvxfgM149bzaO4zoNsXl2L/RDYMDZ6AQWMdmdJ5AHDRBFluvvC38c+9UnSH6f+a3CETinIrZno8WJ+0dxhwHMAbEWHL3dCeleQQRuhuJmseM6vOxz/AgjAXwi81QjwwV7t0V4NXC562wI8Qog5W7416cJm1r2zJ09TmoNrJhykqKgOFdbVqpoGWDjNOfrvDm/npz5ZrPyeFJgLaDNbMKjdFvx1sRlfy4q+0HOF5nbPKskwE4AjPPuaqxCOaSd8KL4e4ros7kD6vcir0akYkpwa6aZZeCneQu79Zd06pulCGx32gugm24gD55CmL19U1yDLIJzwF6SKhqF9qb3+fO5YY27tjgN1o9oi2xzRxbVw6HCW1cPZzESkAN4kpz27m0niZs6w+Y248blmHNrgGhY6gkmRhRRw1IOJs8aRFUb+AtUfDhYSZEpIAovkECRy1asGDsbGfO0TibG/jFtMQ44EvMe4s7wHKi58xTYa9J/iQMBCGuX+ZrBkULnjkgNbG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39830400003)(366004)(136003)(376002)(478600001)(66556008)(66476007)(6506007)(66946007)(66574015)(8676002)(41300700001)(6512007)(6486002)(8936002)(110136005)(54906003)(5660300002)(44832011)(2906002)(30864003)(316002)(4326008)(36756003)(2616005)(83380400001)(107886003)(86362001)(26005)(1076003)(52116002)(38350700002)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fupTYIclq2xDFIbOlHI2TUjBQ3HUlv6cERbdiKytKT4SxSwUZ9HQIbYxhdwq?=
 =?us-ascii?Q?Pa4vW0dYaG5Ik+m4YRdj25wtXRxth9yl2g2H98cd99b97nk6bNnjfcfxP2tX?=
 =?us-ascii?Q?24Zexk8Te/jyz54zvsPTwgI+6Mmrq17Pi5Veo+oFst8ODzkhg1t+lx9oogie?=
 =?us-ascii?Q?8ja8nI1D8HKKxmTTeO7aGjjUV53REZsiEcuQS/x6/Yap1D0v3D5B3355kzop?=
 =?us-ascii?Q?kcMGBymBIvq0cX1eHXn2dEj/IB4ckMLQiN/LUf+2nlrHsmD43qW5HL7BRWDd?=
 =?us-ascii?Q?YZ5hf8dESb5eunbbu7LtpONMWalNjoFWkp22jI9qIyClGGbY7/2n3pimm+Uh?=
 =?us-ascii?Q?uBYHNYr0bFLYmDvLoQqtY9t1EIMQYu2XfsTSVpA/4H/G+aM19Ahds1DcICaK?=
 =?us-ascii?Q?MiKAlO3Ez0fj80VngTA7GcRmNq+UozvF8BI+f1ePYKG+oEMBR0CdX+8KYIJ0?=
 =?us-ascii?Q?ZT3zVqYgIKd/PzDhgrIYX0ikEGFg4Mv79fp8UYjo4HyLWP5v2X75ihxzD0yx?=
 =?us-ascii?Q?Va4O1TpLE7FKuEtyCGFuk8BYb4ZRFRDUTc670dHHkbwEzepnYHbMGGBfC+id?=
 =?us-ascii?Q?+irKoXDvoFYOrREpxyPTzn38jCY+vZkc+VMznIC/DLtv7atQkP2DlSzVGlAU?=
 =?us-ascii?Q?Qk08EMp6dJB6szlWIfDTKUTOZTw6iYkmQNN4W2sxy151U1jRfcm1jCWsT4lG?=
 =?us-ascii?Q?D5//lqvK1myH2yr1VucTuswf8XXw9Yr/QidOMioYh2ylUj56xCFcvzD86/sH?=
 =?us-ascii?Q?3gF+XBqOtlQPSkyD7hjZtlEWR0X0pt5+HuvQQWFB2bPBvZ7WF7bpFdlLIY2K?=
 =?us-ascii?Q?SlmJ+nlVlh4OlS3f8ZaKd2j1ixMjoDZxIVpw/iOok4h92Z+PVke64DZ06AH1?=
 =?us-ascii?Q?fW7A2q8NOz0v8OuvO2whgp1mCMkmxH7SltXbxIqRKYR3gNd3tBW7wWQitYue?=
 =?us-ascii?Q?7Z5eYKJa01bszv2EKca4wCW6uuzglNXSk0dEUkNBxM+1C3E+AlXTf0vDXB/G?=
 =?us-ascii?Q?WOLGuY0yTHN42rmTKeP/cw2g34DTqo9Jab+0daK6Bt4jtRM5mXFLjZ+949eV?=
 =?us-ascii?Q?gkj1rV20mjRWByKxnJsrmgYYwb4oSasILudJbFyunbVWg+Pp7RKYq9ijwJ9F?=
 =?us-ascii?Q?0Izdm2d97w0j9l+MwvvSYejnvCA3KOz0orNGORfwZMQ6+x3Eae42PSNVCHoe?=
 =?us-ascii?Q?EJGWqV16Ij8jY3Ox23Uyt5vgu7SmmFOKS1CkowuO1jFUhczpDtJtLurvslaf?=
 =?us-ascii?Q?eyRurbt/+hng3mTSdsMNXafaeB7OjNEecsujHwIY/OIvFMiVsYRzkG1YG6BA?=
 =?us-ascii?Q?YnPF2ImaI/MCBjnjWvMTTWdLdSXoBWZJGsP2z0O8fIgOAiyUz+oBOpWYa6LF?=
 =?us-ascii?Q?Q6iEPyoE6NDv9LCfBNULH9RheqbpALaZnlyJkNUdtCtC5t5SdyasIyXjB7ly?=
 =?us-ascii?Q?Vd3AMCrmijDlvDGXMxv6ffkzcY2aqVYLGChUxzuWqNrGL1GSk3+4SmuZvns0?=
 =?us-ascii?Q?PNDbbHpPsCvEgTkwTb/DNrjxaknuI3ye+/oL9z0wxWdTAya89jnuQj7sRzFd?=
 =?us-ascii?Q?HSAHIV4kriJTPi1qNjifS2d0FZyAhDLDAqCLdWg26XAMZggDmbJ6LOYKf+oy?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 562300a6-f037-40a4-671f-08da61045924
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 17:07:33.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bzF3Lt2PtRo6f3rSfWvTG5FQoCf4sPdW4yKwPoVGy80j+7p3T53z8dPoO33mQQuV1v9P1YqO1y/HFLVf/IKjs2tdoqcl0T0D+mKjg12o9OU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1842
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SFP port prestera driver will use kernel
phylink infrastucture to configure port mode based on
the module that has beed inserted

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  13 +
 .../marvell/prestera/prestera_ethtool.c       |  31 +-
 .../marvell/prestera/prestera_ethtool.h       |   3 -
 .../ethernet/marvell/prestera/prestera_main.c | 418 ++++++++++++++++--
 4 files changed, 404 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 0bb46eee46b4..6cc59dd049d3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -7,6 +7,7 @@
 #include <linux/notifier.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/phylink.h>
 #include <net/devlink.h>
 #include <uapi/linux/if_ether.h>
 
@@ -72,6 +73,9 @@ struct prestera_lag {
 struct prestera_flow_block;
 
 struct prestera_port_mac_state {
+#ifdef CONFIG_PHYLINK
+	bool valid;
+#endif
 	u32 mode;
 	u32 speed;
 	bool oper;
@@ -131,6 +135,14 @@ struct prestera_port {
 	struct prestera_port_phy_config cfg_phy;
 	struct prestera_port_mac_state state_mac;
 	struct prestera_port_phy_state state_phy;
+
+#ifdef CONFIG_PHYLINK
+	struct phylink_config phy_config;
+	struct phylink *phy_link;
+	struct phylink_pcs phylink_pcs;
+
+	rwlock_t state_mac_lock;
+#endif
 };
 
 struct prestera_device {
@@ -271,6 +283,7 @@ struct prestera_switch {
 	u32 mtu_min;
 	u32 mtu_max;
 	u8 id;
+	struct device_node *np;
 	struct prestera_router *router;
 	struct prestera_lag *lags;
 	struct prestera_counter *counter;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 40d5b89573bb..3322f97053f1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -520,6 +520,10 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 	ethtool_link_ksettings_zero_link_mode(ecmd, lp_advertising);
 	ecmd->base.speed = SPEED_UNKNOWN;
 	ecmd->base.duplex = DUPLEX_UNKNOWN;
+#ifdef CONFIG_PHYLINK
+	if (port->phy_link)
+		return phylink_ethtool_ksettings_get(port->phy_link, ecmd);
+#endif /* CONFIG_PHYLINK */
 
 	ecmd->base.autoneg = port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 
@@ -648,6 +652,11 @@ prestera_ethtool_set_link_ksettings(struct net_device *dev,
 	u8 adver_fec;
 	int err;
 
+#ifdef CONFIG_PHYLINK
+	if (port->phy_link)
+		return phylink_ethtool_ksettings_set(port->phy_link, ecmd);
+#endif /* CONFIG_PHYLINK */
+
 	err = prestera_port_type_set(ecmd, port);
 	if (err)
 		return err;
@@ -782,28 +791,6 @@ static int prestera_ethtool_nway_reset(struct net_device *dev)
 	return -EINVAL;
 }
 
-void prestera_ethtool_port_state_changed(struct prestera_port *port,
-					 struct prestera_port_event *evt)
-{
-	struct prestera_port_mac_state *smac = &port->state_mac;
-
-	smac->oper = evt->data.mac.oper;
-
-	if (smac->oper) {
-		smac->mode = evt->data.mac.mode;
-		smac->speed = evt->data.mac.speed;
-		smac->duplex = evt->data.mac.duplex;
-		smac->fc = evt->data.mac.fc;
-		smac->fec = evt->data.mac.fec;
-	} else {
-		smac->mode = PRESTERA_MAC_MODE_MAX;
-		smac->speed = SPEED_UNKNOWN;
-		smac->duplex = DUPLEX_UNKNOWN;
-		smac->fc = 0;
-		smac->fec = 0;
-	}
-}
-
 const struct ethtool_ops prestera_ethtool_ops = {
 	.get_drvinfo = prestera_ethtool_get_drvinfo,
 	.get_link_ksettings = prestera_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
index 9eb18e99dea6..bd5600886bc6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
@@ -11,7 +11,4 @@ struct prestera_port;
 
 extern const struct ethtool_ops prestera_ethtool_ops;
 
-void prestera_ethtool_port_state_changed(struct prestera_port *port,
-					 struct prestera_port_event *evt);
-
 #endif /* _PRESTERA_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3952fdcc9240..5c1860673dca 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -9,6 +9,7 @@
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/if_vlan.h>
+#include <linux/phylink.h>
 
 #include "prestera.h"
 #include "prestera_hw.h"
@@ -119,19 +120,29 @@ static int prestera_port_open(struct net_device *dev)
 	struct prestera_port_mac_config cfg_mac;
 	int err = 0;
 
-	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
-		err = prestera_port_cfg_mac_read(port, &cfg_mac);
-		if (!err) {
-			cfg_mac.admin = true;
-			err = prestera_port_cfg_mac_write(port, &cfg_mac);
-		}
+#ifdef CONFIG_PHYLINK
+	if (port->phy_link) {
+		phylink_start(port->phy_link);
 	} else {
-		port->cfg_phy.admin = true;
-		err = prestera_hw_port_phy_mode_set(port, true, port->autoneg,
-						    port->cfg_phy.mode,
-						    port->adver_link_modes,
-						    port->cfg_phy.mdix);
+#endif
+		if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+			err = prestera_port_cfg_mac_read(port, &cfg_mac);
+			if (!err) {
+				cfg_mac.admin = true;
+				err = prestera_port_cfg_mac_write(port,
+								  &cfg_mac);
+			}
+		} else {
+			port->cfg_phy.admin = true;
+			err = prestera_hw_port_phy_mode_set(port, true,
+							    port->autoneg,
+							    port->cfg_phy.mode,
+							    port->adver_link_modes,
+							    port->cfg_phy.mdix);
+		}
+#ifdef CONFIG_PHYLINK
 	}
+#endif
 
 	netif_start_queue(dev);
 
@@ -146,23 +157,308 @@ static int prestera_port_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
-		err = prestera_port_cfg_mac_read(port, &cfg_mac);
-		if (!err) {
-			cfg_mac.admin = false;
-			prestera_port_cfg_mac_write(port, &cfg_mac);
+#ifdef CONFIG_PHYLINK
+	if (port->phy_link) {
+		phylink_stop(port->phy_link);
+		phylink_disconnect_phy(port->phy_link);
+	} else {
+#endif
+		if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+			err = prestera_port_cfg_mac_read(port, &cfg_mac);
+			if (!err) {
+				cfg_mac.admin = false;
+				prestera_port_cfg_mac_write(port, &cfg_mac);
+			}
+		} else {
+			port->cfg_phy.admin = false;
+			err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
+							    port->cfg_phy.mode,
+							    port->adver_link_modes,
+							    port->cfg_phy.mdix);
 		}
+#ifdef CONFIG_PHYLINK
+	}
+#endif
+
+	return err;
+}
+
+#ifdef CONFIG_PHYLINK
+static void
+prestera_port_mac_state_cache_read(struct prestera_port *port,
+				   struct prestera_port_mac_state *state)
+{
+	read_lock(&port->state_mac_lock);
+	*state = port->state_mac;
+	read_unlock(&port->state_mac_lock);
+}
+
+static void
+prestera_port_mac_state_cache_write(struct prestera_port *port,
+				    struct prestera_port_mac_state *state)
+{
+	write_lock(&port->state_mac_lock);
+	port->state_mac = *state;
+	write_unlock(&port->state_mac_lock);
+}
+
+static void prestera_mac_pcs_get_state(struct phylink_config *config,
+				       struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct prestera_port *port = netdev_priv(ndev);
+	struct prestera_port_mac_state smac;
+
+	prestera_port_mac_state_cache_read(port, &smac);
+
+	if (smac.valid) {
+		state->link = smac.oper;
+		state->pause = 0;
+		/* AN is completed, when port is up */
+		state->an_complete = smac.oper ? port->autoneg : false;
+		state->speed = smac.speed;
+		state->duplex = smac.duplex;
 	} else {
-		port->cfg_phy.admin = false;
-		err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
-						    port->cfg_phy.mode,
-						    port->adver_link_modes,
-						    port->cfg_phy.mdix);
+		state->link = false;
+		state->pause = 0;
+		state->an_complete = false;
+		state->speed = SPEED_UNKNOWN;
+		state->duplex = DUPLEX_UNKNOWN;
+	}
+}
+
+static void prestera_mac_config(struct phylink_config *config,
+				unsigned int an_mode,
+				const struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct prestera_port *port = netdev_priv(ndev);
+	struct prestera_port_mac_config cfg_mac;
+
+	prestera_port_cfg_mac_read(port, &cfg_mac);
+	cfg_mac.admin = true;
+	cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
+	cfg_mac.inband = false;
+	cfg_mac.speed = 0;
+	cfg_mac.duplex = DUPLEX_UNKNOWN;
+	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
+
+	/* See sfp_select_interface... fIt */
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
+		cfg_mac.speed = SPEED_10000;
+		if (state->speed == SPEED_1000) {
+			cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
+		} else if (state->speed == SPEED_2500) {
+			cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
+			cfg_mac.inband = true;
+			cfg_mac.speed = SPEED_2500;
+			cfg_mac.duplex = DUPLEX_FULL;
+		}
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
+		/* But it seems to be not supported in HW */
+		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
+		cfg_mac.inband = true;
+		cfg_mac.speed = SPEED_2500;
+		cfg_mac.duplex = DUPLEX_FULL;
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
+		cfg_mac.inband = state->an_enabled;
+		cfg_mac.speed = SPEED_1000;
+		cfg_mac.duplex = DUPLEX_UNKNOWN;
+		break;
+	default:
+		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
+	}
+
+	prestera_port_cfg_mac_write(port, &cfg_mac);
+}
+
+int prestera_mac_finish(struct phylink_config *config, unsigned int mode,
+			phy_interface_t iface)
+{
+	return 0;
+}
+
+static void prestera_mac_an_restart(struct phylink_config *config)
+{
+	/* No need to restart autoneg as it is always with the same parameters,
+	 * because e.g. as for 1000baseX FC isn't supported. And for 1000baseT
+	 * autoneg provided by external tranciever
+	 */
+}
+
+static void prestera_mac_link_down(struct phylink_config *config,
+				   unsigned int mode, phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct prestera_port *port = netdev_priv(ndev);
+	struct prestera_port_mac_state state_mac;
+
+	/* Invalidate. Parameters will update on next link event. */
+	memset(&state_mac, 0, sizeof(state_mac));
+	state_mac.valid = false;
+	prestera_port_mac_state_cache_write(port, &state_mac);
+}
+
+static void prestera_mac_link_up(struct phylink_config *config,
+				 struct phy_device *phy,
+				 unsigned int mode, phy_interface_t interface,
+				 int speed, int duplex,
+				 bool tx_pause, bool rx_pause)
+{
+}
+
+static struct phylink_pcs *prestera_mac_select_pcs(struct phylink_config *config,
+						   phy_interface_t interface)
+{
+	struct net_device *dev = to_net_dev(config->dev);
+	struct prestera_port *port = netdev_priv(dev);
+
+	return &port->phylink_pcs;
+}
+
+static void prestera_pcs_get_state(struct phylink_pcs *pcs,
+				   struct phylink_link_state *state)
+{
+	struct prestera_port *port = container_of(pcs, struct prestera_port,
+						  phylink_pcs);
+	struct prestera_port_mac_state smac;
+
+	prestera_port_mac_state_cache_read(port, &smac);
+
+	if (smac.valid) {
+		state->link = smac.oper;
+		state->pause = 0;
+		/* AN is completed, when port is up */
+		state->an_complete = smac.oper ? port->autoneg : false;
+		state->speed = smac.speed;
+		state->duplex = smac.duplex;
+	} else {
+		state->link = false;
+		state->pause = 0;
+		state->an_complete = false;
+		state->speed = SPEED_UNKNOWN;
+		state->duplex = DUPLEX_UNKNOWN;
+	}
+}
+
+static int prestera_pcs_config(struct phylink_pcs *pcs,
+			       unsigned int mode,
+			       phy_interface_t interface,
+			       const unsigned long *advertising,
+			       bool permit_pause_to_mac)
+{
+	return 0;
+}
+
+void prestera_pcs_an_restart(struct phylink_pcs *pcs)
+{
+}
+
+static const struct phylink_mac_ops prestera_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_select_pcs = prestera_mac_select_pcs,
+	.mac_pcs_get_state = prestera_mac_pcs_get_state,
+	.mac_config = prestera_mac_config,
+	.mac_finish = prestera_mac_finish,
+	.mac_an_restart = prestera_mac_an_restart,
+	.mac_link_down = prestera_mac_link_down,
+	.mac_link_up = prestera_mac_link_up,
+};
+
+static const struct phylink_pcs_ops prestera_pcs_ops = {
+	.pcs_get_state = prestera_pcs_get_state,
+	.pcs_config = prestera_pcs_config,
+	.pcs_an_restart = prestera_pcs_an_restart,
+};
+
+static int prestera_port_sfp_bind(struct prestera_port *port)
+{
+	struct prestera_switch *sw = port->sw;
+	struct device_node *ports, *node;
+	struct fwnode_handle *fwnode;
+	struct phylink *phy_link;
+	int err;
+
+	if (!sw->np)
+		return 0;
+
+	ports = of_find_node_by_name(sw->np, "ports");
+
+	for_each_child_of_node(ports, node) {
+		int num;
+
+		err = of_property_read_u32(node, "prestera,port-num", &num);
+		if (err) {
+			dev_err(sw->dev->dev,
+				"device node %pOF has no valid reg property: %d\n",
+				node, err);
+			goto out;
+		}
+
+		if (port->fp_id != num)
+			continue;
+
+		port->phylink_pcs.ops = &prestera_pcs_ops;
+
+		port->phy_config.dev = &port->dev->dev;
+		port->phy_config.type = PHYLINK_NETDEV;
+
+		fwnode = of_fwnode_handle(node);
+
+		__set_bit(PHY_INTERFACE_MODE_10GBASER,
+			  port->phy_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+			  port->phy_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  port->phy_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  port->phy_config.supported_interfaces);
+
+		port->phy_config.mac_capabilities = MAC_1000 | MAC_2500FD | MAC_10000FD;
+
+		phy_link = phylink_create(&port->phy_config, fwnode,
+					  PHY_INTERFACE_MODE_INTERNAL,
+					  &prestera_mac_ops);
+		if (IS_ERR(phy_link)) {
+			netdev_err(port->dev, "failed to create phylink\n");
+			err = PTR_ERR(phy_link);
+			goto out;
+		}
+
+		port->phy_link = phy_link;
+		break;
 	}
 
+out:
+	of_node_put(ports);
 	return err;
 }
 
+static int prestera_port_sfp_unbind(struct prestera_port *port)
+{
+	if (port->phy_link)
+		phylink_destroy(port->phy_link);
+
+	return 0;
+}
+#else
+static int prestera_port_sfp_bind(struct prestera_port *port)
+{
+	return 0;
+}
+
+static int prestera_port_sfp_unbind(struct prestera_port *port)
+{
+	return 0;
+}
+#endif
+
 static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -358,7 +654,12 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 
+#ifdef CONFIG_PHYLINK
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP)
+		netif_carrier_off(dev);
+#else
 	netif_carrier_off(dev);
+#endif
 
 	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
 	dev->min_mtu = sw->mtu_min;
@@ -451,8 +752,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	prestera_devlink_port_set(port);
 
+	err = prestera_port_sfp_bind(port);
+	if (err)
+		goto err_sfp_bind;
+
 	return 0;
 
+err_sfp_bind:
 err_register_netdev:
 	prestera_port_list_del(port);
 err_port_init:
@@ -498,8 +804,10 @@ static int prestera_create_ports(struct prestera_switch *sw)
 	return 0;
 
 err_port_create:
-	list_for_each_entry_safe(port, tmp, &sw->port_list, list)
+	list_for_each_entry_safe(port, tmp, &sw->port_list, list) {
+		prestera_port_sfp_unbind(port);
 		prestera_port_destroy(port);
+	}
 
 	return err;
 }
@@ -507,25 +815,59 @@ static int prestera_create_ports(struct prestera_switch *sw)
 static void prestera_port_handle_event(struct prestera_switch *sw,
 				       struct prestera_event *evt, void *arg)
 {
+	struct prestera_port_mac_state smac;
+	struct prestera_port_event *pevt;
 	struct delayed_work *caching_dw;
 	struct prestera_port *port;
 
-	port = prestera_find_port(sw, evt->port_evt.port_id);
-	if (!port || !port->dev)
-		return;
-
-	caching_dw = &port->cached_hw_stats.caching_dw;
+	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
+		pevt = &evt->port_evt;
+		port = prestera_find_port(sw, pevt->port_id);
+		if (!port || !port->dev)
+			return;
+
+		caching_dw = &port->cached_hw_stats.caching_dw;
+
+		memset(&smac, 0, sizeof(smac));
+#ifdef CONFIG_PHYLINK
+		smac.valid = true;
+#endif
+		smac.oper = pevt->data.mac.oper;
+		if (smac.oper) {
+			smac.mode = pevt->data.mac.mode;
+			smac.speed = pevt->data.mac.speed;
+			smac.duplex = pevt->data.mac.duplex;
+			smac.fc = pevt->data.mac.fc;
+			smac.fec = pevt->data.mac.fec;
+		}
 
-	prestera_ethtool_port_state_changed(port, &evt->port_evt);
+#ifdef CONFIG_PHYLINK
+		prestera_port_mac_state_cache_write(port, &smac);
+#endif
 
-	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
 		if (port->state_mac.oper) {
+#ifdef CONFIG_PHYLINK
+			if (port->phy_link)
+				phylink_mac_change(port->phy_link, true);
+			else
+				netif_carrier_on(port->dev);
+#else
 			netif_carrier_on(port->dev);
+#endif
+
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
 		} else if (netif_running(port->dev) &&
 			   netif_carrier_ok(port->dev)) {
+#ifdef CONFIG_PHYLINK
+			if (port->phy_link)
+				phylink_mac_change(port->phy_link, false);
+			else
+				netif_carrier_off(port->dev);
+#else
 			netif_carrier_off(port->dev);
+#endif
+
 			if (delayed_work_pending(caching_dw))
 				cancel_delayed_work(caching_dw);
 		}
@@ -548,19 +890,20 @@ static void prestera_event_handlers_unregister(struct prestera_switch *sw)
 static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 {
 	struct device_node *base_mac_np;
-	struct device_node *np;
 	int ret;
 
-	np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
-	base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
+	if (sw->np) {
+		base_mac_np = of_parse_phandle(sw->np, "base-mac-provider", 0);
+		if (base_mac_np) {
+			ret = of_get_mac_address(base_mac_np, sw->base_mac);
+			of_node_put(base_mac_np);
+		}
+	}
 
-	ret = of_get_mac_address(base_mac_np, sw->base_mac);
-	if (ret) {
+	if (!is_valid_ether_addr(sw->base_mac) || ret) {
 		eth_random_addr(sw->base_mac);
 		dev_info(prestera_dev(sw), "using random base mac address\n");
 	}
-	of_node_put(base_mac_np);
-	of_node_put(np);
 
 	return prestera_hw_switch_mac_set(sw, sw->base_mac);
 }
@@ -892,6 +1235,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 {
 	int err;
 
+	sw->np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+
 	err = prestera_hw_switch_init(sw);
 	if (err) {
 		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
@@ -992,6 +1337,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_router_fini(sw);
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
+	of_node_put(sw->np);
 }
 
 int prestera_device_register(struct prestera_device *dev)
-- 
2.17.1

