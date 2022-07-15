Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53C3576787
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiGOTfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOTfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:35:12 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140098.outbound.protection.outlook.com [40.107.14.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7947E599D0;
        Fri, 15 Jul 2022 12:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbLEVJzr7m1OG6n5FHwZQVj10p0HsgYXsV3FVA4aqTYHSWp8VgLOmCMfnMcmsr+JX8dD6G75tevwMrKcKzJJlgEuo5/cEGZ7RYo281z3nwJpYeujPt2ZJupunLoIq/ahJ7BUSDLs2hs/PBmCgwnG6VofJP6cfUVAgZAEqeyFC+/3/i4onkFjxGBzi8dyyHbNTKKCjOYMtwMUb1AlrDEg/lYsN/Zh7DDTQraBXf9ysOgqX1GI7Siplq7cHuO9hk9KnHXb2k3pU3Jpcge0pgUV7GcjYCwjJoazI71xyQn87KYIhNpNg6RPieF+JBOQv7yNF0Hwdvlvm6x18bZax0ohDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bc1gDi5DHYzg7wEnRitCqIPwYlVX0Mti37fb2kcOnKA=;
 b=VB3o4u+Wx+kzP3cLWWCtKQgpgH4Ynr/FHwBEdSiEdmGjTS73qzo9erwJAUU+53mqQGfphmw2JC3bHzhOKRPhU+tUFmarBetw0+bshXP8Cp//BXq3RjrgLHt6zIELqytKIvHtOy5cgYgj4Aj11DsYDQ6OQtI1g7Uiwrc0cCJZF9boD/jUKO6cQKcpblPTF2MtEeB0j8/fW4S9ioC4ey3GwKtWSmqQhslLLOlPZ8ChyD4irNso1P9hyLeh6auewYga+T76E05Zwm5xXWdFJTQFw6/gvV/2oE2UOy0Lxqfl0x3mo8h9SR7D/whF6WKbe2xJLscmsomJJ4PETIujspL9WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bc1gDi5DHYzg7wEnRitCqIPwYlVX0Mti37fb2kcOnKA=;
 b=X2RpkC15RxtKOmy8+33IGJgfSuEVQxvucoxH395/DdqShSqt/R19skqzzG8DwxFqZ/IgmrpzA+fyq57IqN996EmH6JobKfBib1CeHpLvp1xMOq6j4rGQHivysvy0MsOAhf4E798aRSqUFR+AWWLRYOnJoAoAhUHA0wjkBMzoCMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM9P190MB1459.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 19:35:04 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9917:4436:3c90:ebaf]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9917:4436:3c90:ebaf%6]) with mapi id 15.20.5438.017; Fri, 15 Jul 2022
 19:35:04 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, linux@armlinux.org.uk, andrew@lunn.ch
Subject: [PATCH V4 net-next] net: marvell: prestera: add phylink support
Date:   Fri, 15 Jul 2022 22:34:54 +0300
Message-Id: <20220715193454.7627-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0074.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::34) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 451b2474-d4e1-4d8f-0478-08da66991d88
X-MS-TrafficTypeDiagnostic: AM9P190MB1459:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RiWQ0Tm4issHTAmBW+en7haCJkLquOsNQwbhbJ6JRhx4+e+nF60FL23XBKBa/KDNS2Pm2uBvdItXnrkEvzARWQn+bYEEUeeaJI9a2aOH1+D+DtZlKDrqgMTHLoR3z3o2kpV8FPxuqfIvTRls/UtyvUL1UBxVu7yd7tKCbpYXjIIgIFoZTrKDdcX1XH4oGD+vw06BCpo3450dv6+/aA/wIdCQgs18d88bFdCPhR7tvsM0gwXTndGVb0I/8tULEpyruWQw5yHh2EXk2D6DuFWhEIZ5a0Nqs21d6er7j2UoGItgt32uuZOEaPFoznMkcKvDAxCgq7WNJhvACHn8Q5YbXzP1/CmP/Bd7LFyUwAe2ImeuHlB4qMJsUkB0kZPWXeRqdiCmlo10BDRithS9qg3mwu0X5sX91eu9Wfvm2Sw2panaznSGeRVF/EzRhSlrnPtI7xTc3KWA41iBhrjkPJPBD9LG52jcdVFlQW/iPv3b+VnCu8wkEcC1rbFZGtephBXJE/NRCR55zBNGxfZrIkTXJyg+Lddi59ZSmM2160WCwjg28IMlRFWbekHpAl5B+SAFhTKOelraSYH5iVpsNKwB4yGMGxILx3wNYnslzkXCHIHLgh9Zq2DpRf/PBnT7a01tLkQgLi5zmL1pI1PbUcYVIMEerIPzO2n9TJn+3an6dmR1zJHA5Qq1lfcxv1+L01kr4uLu01Bqjk3dqp1oSuut6U2r2qHpWhzKSh6wth/9suuMtQ1eSUk0lnVFz0ZVwk9xbSoL9Vu3+UoR5Jl/hhdK39xPQzfKLg89SxMNfYy0xlzvRssejGhmRBEtivXrfRDG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39830400003)(376002)(396003)(346002)(30864003)(44832011)(2906002)(5660300002)(8936002)(86362001)(6512007)(36756003)(38100700002)(26005)(6916009)(8676002)(478600001)(6486002)(38350700002)(4326008)(316002)(66556008)(52116002)(6666004)(186003)(66476007)(2616005)(66946007)(66574015)(1076003)(83380400001)(41300700001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4jta/Rn9nHuNECcWsFlIgFCOx9/QoeOTuJ9NARCddxS+U+ihoqmYzf7+DZHb?=
 =?us-ascii?Q?/eM7Z7DOYl/l4iEfxrAIZGH5FdI+a/4gr2OYJhT8wzbgAtf4JvS+8H3pspYp?=
 =?us-ascii?Q?tWS9vGR3BktOQYmtH4SUoMqOdhQoJOFpGqJD1Rjw7TvLxtYyeffjF+ioZgp9?=
 =?us-ascii?Q?0bYNxxb8++680DGjNHT0U3A63ZYtqLZMEPnoYHWdnEBpppaukr5u1O/AsNzh?=
 =?us-ascii?Q?JT5BcFI5dvXiN5Opb3/oq6pPVrb6xVP0aWA41+RixINeeVKbwSr1o9X4duB3?=
 =?us-ascii?Q?NtV7en/OvwY9Ltzdom0z+CZpaA9wto+9ZlYWDzyf+ZQi2iOtHdQXy1ZP6x/J?=
 =?us-ascii?Q?EHGvRqwn7dRDnbNa2xDMPUIZvmfciTDO11JmEtPiF0HUaw10saTnOs4r1P41?=
 =?us-ascii?Q?a3iHmYWxHY3Bur+OYQqgMId/W+CtNGp2ZQx/eqOw7BwGbzDFk6X80pAsieQm?=
 =?us-ascii?Q?L3OeGQkm8T7SXthNjqUFQVEJEa4RITuMz+ZEmE5pMLyKuEqxaV0FfgPhTsTN?=
 =?us-ascii?Q?JDfPe4KX4uILxGfwp+o8DowneKZX/l5AxkEJgFEBIY8VgQ1H7fgOcKNy7LId?=
 =?us-ascii?Q?ppRIOrIllgOmJYFb1+OmYUG2yHyE5+TRVnGQve+sJBeYi/XN/DssEu6ZF5EE?=
 =?us-ascii?Q?X/bksVxqkoXHD6W1Y8OMQ2dbFIkcBnm+/s83WwVISuPxtVNxhcze6RnCLojM?=
 =?us-ascii?Q?D6vdUoopDV7aW2Um7JAaJ75pPEtoYDZAh4N3HJy/dpQBYl3cHWAIK8Oiav96?=
 =?us-ascii?Q?D1/rANnIi4w7CYURAwEZWuUDMxCXrVMfenrS12egoPFCmJX9Wi6T08GnLm3B?=
 =?us-ascii?Q?DZbJJ0anE+2JLYYZAi6Oxr1TK3sCdLQWi4myxCdE7gqPfXSTHD0xQrfrNazt?=
 =?us-ascii?Q?0QR14yyibqkEKqgXFtxSaYJD9XoLZV6j6GrUBr1LoUljmR7am7QUnVyAsb8P?=
 =?us-ascii?Q?IYhXvWTqR/tPlpkPoDnmiS6S1XSikhvxh28JOhi0DMoJuGvoTZWUsIL/V/3y?=
 =?us-ascii?Q?TXmranBMKnbvwbVbT/uAcbrpOoXBoC7jdCPE8mloC2+2zLcMfnXG3pQJdZS+?=
 =?us-ascii?Q?VElVxFQcZx6lt4J+En0pKbTBKFVos/g61f4WIKgnx3HjGAmfWy1BK9K860kc?=
 =?us-ascii?Q?M9Wf4C0uT7kJiPXIvgEMJUmrPVPO+f1ltM2OdpTIKjf/Xc12+NM9T9x+OeUN?=
 =?us-ascii?Q?zIJKyhLHwrShC8T79PeuOZmqWB8yQCDac6ebYnxE/dn1zy9vI0mEzVPRhMJz?=
 =?us-ascii?Q?A1kUggB+WnprxQyB1ggEnmaL7+XwIdxBeiKRLZsTgYYtjhbsbHsHGPK1j9z5?=
 =?us-ascii?Q?p6rNYoHdR1utdHW/WokSRcub/UWIxFKA+6EJ4zZ1F35Fa4nGsNMKcpCr3Un2?=
 =?us-ascii?Q?xnSUnCdheD2zbK+K/+QjhQ6ejrFneMWWMNbIhs9pWUDarzy/EzrUvlNox9oq?=
 =?us-ascii?Q?3FTplsc5EDWT162BiPT5ywj3zLFMYHNRxHfvz8lw/q84LISP2FH2K7U5JOr3?=
 =?us-ascii?Q?yqjT8a6J6IEO6IuntPU0EvWsVCelWb7cmw1CKRTVvQy/tBbOmcdowtT91duV?=
 =?us-ascii?Q?VGgIAwO7NPYWsa7xU4fApnmUddasbde6tpdXP+G3Vmi1I27dwGunqugJfoxb?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 451b2474-d4e1-4d8f-0478-08da66991d88
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 19:35:04.0016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BcDuqK5jAaqQJV2zwHBZsgkdEG2D9qhv6O22SWJbWG6+O4naCeLwwdft9eTRuFdub/TTcAn3ISy3rttBcf6lsgAjaDpuSOp3lx/W1J6T58g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1459
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
PATCH V4:
  - move changelog under threeline separator.
  - add small comment that explains reason for
    empty pcs 'an_restart' function.
PATCH V3:
  - force inband mode for SGMII
  - fix >80 chars warning of checkpatch where possible (2/5)
  - structure phylink_mac_change alongside phylink-related if-clause;
PATCH V2:
  - fix mistreat of bitfield values as if they were bools.
  - remove phylink_config ifdefs.
  - remove obsolete phylink pcs / mac callbacks;
  - rework mac (/pcs) config to not look for speed / duplex
    parameters while link is not yet set up.
  - remove unused functions.
  - add phylink select cfg to prestera Kconfig.

 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/prestera.h  |   9 +
 .../marvell/prestera/prestera_ethtool.c       |  28 +-
 .../marvell/prestera/prestera_ethtool.h       |   3 -
 .../ethernet/marvell/prestera/prestera_main.c | 353 ++++++++++++++++--
 5 files changed, 332 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index b6f20e2034c6..f2f7663c3d10 100644
--- a/drivers/net/ethernet/marvell/prestera/Kconfig
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -8,6 +8,7 @@ config PRESTERA
 	depends on NET_SWITCHDEV && VLAN_8021Q
 	depends on BRIDGE || BRIDGE=n
 	select NET_DEVLINK
+	select PHYLINK
 	help
 	  This driver supports Marvell Prestera Switch ASICs family.
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index bff9651f0a89..832c27e0c284 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -7,6 +7,7 @@
 #include <linux/notifier.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/phylink.h>
 #include <net/devlink.h>
 #include <uapi/linux/if_ether.h>
 
@@ -92,6 +93,7 @@ struct prestera_lag {
 struct prestera_flow_block;
 
 struct prestera_port_mac_state {
+	bool valid;
 	u32 mode;
 	u32 speed;
 	bool oper;
@@ -151,6 +153,12 @@ struct prestera_port {
 	struct prestera_port_phy_config cfg_phy;
 	struct prestera_port_mac_state state_mac;
 	struct prestera_port_phy_state state_phy;
+
+	struct phylink_config phy_config;
+	struct phylink *phy_link;
+	struct phylink_pcs phylink_pcs;
+
+	rwlock_t state_mac_lock;
 };
 
 struct prestera_device {
@@ -291,6 +299,7 @@ struct prestera_switch {
 	u32 mtu_min;
 	u32 mtu_max;
 	u8 id;
+	struct device_node *np;
 	struct prestera_router *router;
 	struct prestera_lag *lags;
 	struct prestera_counter *counter;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 40d5b89573bb..1da7ff889417 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -521,6 +521,9 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 	ecmd->base.speed = SPEED_UNKNOWN;
 	ecmd->base.duplex = DUPLEX_UNKNOWN;
 
+	if (port->phy_link)
+		return phylink_ethtool_ksettings_get(port->phy_link, ecmd);
+
 	ecmd->base.autoneg = port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 
 	if (port->caps.type == PRESTERA_PORT_TYPE_TP) {
@@ -648,6 +651,9 @@ prestera_ethtool_set_link_ksettings(struct net_device *dev,
 	u8 adver_fec;
 	int err;
 
+	if (port->phy_link)
+		return phylink_ethtool_ksettings_set(port->phy_link, ecmd);
+
 	err = prestera_port_type_set(ecmd, port);
 	if (err)
 		return err;
@@ -782,28 +788,6 @@ static int prestera_ethtool_nway_reset(struct net_device *dev)
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
index ea5bd5069826..192ab706e45e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -9,6 +9,7 @@
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/if_vlan.h>
+#include <linux/phylink.h>
 
 #include "prestera.h"
 #include "prestera_hw.h"
@@ -142,18 +143,24 @@ static int prestera_port_open(struct net_device *dev)
 	struct prestera_port_mac_config cfg_mac;
 	int err = 0;
 
-	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
-		err = prestera_port_cfg_mac_read(port, &cfg_mac);
-		if (!err) {
-			cfg_mac.admin = true;
-			err = prestera_port_cfg_mac_write(port, &cfg_mac);
-		}
+	if (port->phy_link) {
+		phylink_start(port->phy_link);
 	} else {
-		port->cfg_phy.admin = true;
-		err = prestera_hw_port_phy_mode_set(port, true, port->autoneg,
-						    port->cfg_phy.mode,
-						    port->adver_link_modes,
-						    port->cfg_phy.mdix);
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
 	}
 
 	netif_start_queue(dev);
@@ -169,23 +176,260 @@ static int prestera_port_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+	if (port->phy_link) {
+		phylink_stop(port->phy_link);
+		phylink_disconnect_phy(port->phy_link);
 		err = prestera_port_cfg_mac_read(port, &cfg_mac);
 		if (!err) {
 			cfg_mac.admin = false;
 			prestera_port_cfg_mac_write(port, &cfg_mac);
 		}
 	} else {
-		port->cfg_phy.admin = false;
-		err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
-						    port->cfg_phy.mode,
-						    port->adver_link_modes,
-						    port->cfg_phy.mdix);
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
+		}
 	}
 
 	return err;
 }
 
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
+static struct prestera_port *prestera_pcs_to_port(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct prestera_port, phylink_pcs);
+}
+
+static void prestera_mac_config(struct phylink_config *config,
+				unsigned int an_mode,
+				const struct phylink_link_state *state)
+{
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
+static struct phylink_pcs *
+prestera_mac_select_pcs(struct phylink_config *config,
+			phy_interface_t interface)
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
+		state->link = smac.oper ? 1 : 0;
+		/* AN is completed, when port is up */
+		state->an_complete = (smac.oper && port->autoneg) ? 1 : 0;
+		state->speed = smac.speed;
+		state->duplex = smac.duplex;
+	} else {
+		state->link = 0;
+		state->an_complete = 0;
+	}
+}
+
+static int prestera_pcs_config(struct phylink_pcs *pcs,
+			       unsigned int mode,
+			       phy_interface_t interface,
+			       const unsigned long *advertising,
+			       bool permit_pause_to_mac)
+{
+	struct prestera_port *port = port = prestera_pcs_to_port(pcs);
+	struct prestera_port_mac_config cfg_mac;
+	int err;
+
+	err = prestera_port_cfg_mac_read(port, &cfg_mac);
+	if (err)
+		return err;
+
+	cfg_mac.admin = true;
+	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		cfg_mac.speed = SPEED_10000;
+		cfg_mac.inband = 0;
+		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		cfg_mac.speed = SPEED_2500;
+		cfg_mac.duplex = DUPLEX_FULL;
+		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					  advertising);
+		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		cfg_mac.inband = 1;
+		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	default:
+		cfg_mac.speed = SPEED_1000;
+		cfg_mac.duplex = DUPLEX_FULL;
+		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					  advertising);
+		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
+		break;
+	}
+
+	err = prestera_port_cfg_mac_write(port, &cfg_mac);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void prestera_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	/*
+	 * TODO: add 100basex AN restart support
+	 * (Currently FW has no support for 1000baseX AN restart, but it will in the future,
+	 * so as for now the function would stay empty.)
+	 */
+}
+
+static const struct phylink_mac_ops prestera_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_select_pcs = prestera_mac_select_pcs,
+	.mac_config = prestera_mac_config,
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
+		port->phy_config.mac_capabilities =
+			MAC_1000 | MAC_2500FD | MAC_10000FD;
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
+	}
+
+out:
+	of_node_put(ports);
+	return err;
+}
+
+static int prestera_port_sfp_unbind(struct prestera_port *port)
+{
+	if (port->phy_link)
+		phylink_destroy(port->phy_link);
+
+	return 0;
+}
+
 static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -380,8 +624,10 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
+	SET_NETDEV_DEV(dev, sw->dev->dev);
 
-	netif_carrier_off(dev);
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP)
+		netif_carrier_off(dev);
 
 	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
 	dev->min_mtu = sw->mtu_min;
@@ -432,7 +678,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		cfg_mac.admin = false;
 		cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
 	}
-	cfg_mac.inband = false;
+	cfg_mac.inband = 0;
 	cfg_mac.speed = 0;
 	cfg_mac.duplex = DUPLEX_UNKNOWN;
 	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
@@ -474,8 +720,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
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
@@ -521,8 +772,10 @@ static int prestera_create_ports(struct prestera_switch *sw)
 	return 0;
 
 err_port_create:
-	list_for_each_entry_safe(port, tmp, &sw->port_list, list)
+	list_for_each_entry_safe(port, tmp, &sw->port_list, list) {
+		prestera_port_sfp_unbind(port);
 		prestera_port_destroy(port);
+	}
 
 	return err;
 }
@@ -530,25 +783,47 @@ static int prestera_create_ports(struct prestera_switch *sw)
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
-
-	prestera_ethtool_port_state_changed(port, &evt->port_evt);
-
 	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
+		pevt = &evt->port_evt;
+		port = prestera_find_port(sw, pevt->port_id);
+		if (!port || !port->dev)
+			return;
+
+		caching_dw = &port->cached_hw_stats.caching_dw;
+
+		if (port->phy_link) {
+			memset(&smac, 0, sizeof(smac));
+			smac.valid = true;
+			smac.oper = pevt->data.mac.oper;
+			if (smac.oper) {
+				smac.mode = pevt->data.mac.mode;
+				smac.speed = pevt->data.mac.speed;
+				smac.duplex = pevt->data.mac.duplex;
+				smac.fc = pevt->data.mac.fc;
+				smac.fec = pevt->data.mac.fec;
+				phylink_mac_change(port->phy_link, true);
+			} else {
+				phylink_mac_change(port->phy_link, false);
+			}
+			prestera_port_mac_state_cache_write(port, &smac);
+		}
+
 		if (port->state_mac.oper) {
-			netif_carrier_on(port->dev);
+			if (!port->phy_link)
+				netif_carrier_on(port->dev);
+
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
 		} else if (netif_running(port->dev) &&
 			   netif_carrier_ok(port->dev)) {
-			netif_carrier_off(port->dev);
+			if (!port->phy_link)
+				netif_carrier_off(port->dev);
+
 			if (delayed_work_pending(caching_dw))
 				cancel_delayed_work(caching_dw);
 		}
@@ -571,19 +846,20 @@ static void prestera_event_handlers_unregister(struct prestera_switch *sw)
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
@@ -1083,6 +1359,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 {
 	int err;
 
+	sw->np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+
 	err = prestera_hw_switch_init(sw);
 	if (err) {
 		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
@@ -1183,6 +1461,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_router_fini(sw);
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
+	of_node_put(sw->np);
 }
 
 int prestera_device_register(struct prestera_device *dev)
-- 
2.17.1

