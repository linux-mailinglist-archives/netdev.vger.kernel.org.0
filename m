Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03766579805
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiGSK5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiGSK5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:57:33 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2100.outbound.protection.outlook.com [40.107.20.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DDD28718;
        Tue, 19 Jul 2022 03:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmeQDVjDtS31hq8CpyUVggF38QTMzKUsThbTd0oeGNkEBlekwJqV/eaXHpS3il+Yi2vR6HWFHRvNIeMylT2qtLz81IPRRDM+x2kow+ZpgZp+7dg+PXTYcbjcYxfJUOvOu2af2K5gGLT4yO8RQCKN89ram25phD5LqR624CBpOPxF0tXU637Mo4IoCJ7bFIotV2XfT31LvrHPRWKnfUVCG7HQq5MKFG4D8IpDajVBzKGlIXJV02tDFVDyuMzg1N3/CeKHXaDlzJiZfHxeCJdQLer5xTMqdJ92tD6HSzyzmBngxG9ckFRpJBOSAyf61fRFLXeupcuBYv/kT3aFntqe3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEFHPBAWoDzDyDb3s9Mg7xLudVhZzqUz611fM20Kwx8=;
 b=XtbMiBhVQIxrHn8+Mmt37EWdYQMd9N/YBt6JgLevyyNSPf3fRvW96LYSssMVEV6g8DnADIa7pt+XP8O7VZesnLHK99kSJjBMUX6OzS6/jAAPEDWxiX4RW00MgBt3j/xLPT51HKvymHCjRGTqa6CD7pgLQUK/WD6hl74MHppX59LuxcpuclyGDhNitltmITatZ3GSSYierUNYN0Rd0lSESk0gO3Fd1Btss1THQpbLSiw4Pc5suV58B7JFa48Eu7Z8unhqrXpIB3+6ZT4inW1akYJr6c61nlvof5OR1S7zhqKgSsqJgDb03muRFJdfJLngkSM66bvCUMuyYDrAQXO82A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEFHPBAWoDzDyDb3s9Mg7xLudVhZzqUz611fM20Kwx8=;
 b=PmH/Kai2NtuYuJVWhQY0Ut1Xcd+n0SS+YnnwEKCMyLy1GcIRIexOologgbPzB4rBQEaO3K7b1x1NWHbowopICfI1cfCsX29KVTLQU/piq3lJmwrZ7Akw69vRI/z2qCXGOpd9FFxDxcGhDVnpSax8IJgaIWaP4JjySqwg5JcpQmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by VI1P190MB0191.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 10:57:26 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9c9d:92b7:367d:e36e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9c9d:92b7:367d:e36e%9]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 10:57:25 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, linux@armlinux.org.uk, andrew@lunn.ch
Subject: [PATCH V5 net-next] net: marvell: prestera: add phylink support
Date:   Tue, 19 Jul 2022 13:57:16 +0300
Message-Id: <20220719105716.19692-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0068.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::45) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4af3083-f25d-4787-097c-08da69757719
X-MS-TrafficTypeDiagnostic: VI1P190MB0191:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdvlI0jm8UcRgLIy6G6gg87GjYSZwN8ab3usMoPJ522h409N5YRV0/upLtU6r/ynJKOrtoX4WI4Dk2Sl/v3yC74qv4iMPNJGXsX7lrNO0nCyAwasRrF002eb0uCiQ3jqR4fQpIrC82T1SdmNfEcewOGLelKzrL+H6DbEJXbimDzWV+hDV2JTopw6qmHcfxOgAuA6kId9SL73FHXtSRq2bMaC/brkUekR1H/MRiHU0I6+Zn5GMiyLPFvGOsu8yUZLJuiPygmy1Oi2CL3lJMmRsLK+owydK31/8cQvIvh8sfS239m21aEowjc86UIyP/ZcTOtw1nYaA4jdM4SUBj+01G8vrxNxdkpjBf4PhpFF+uXO/4TFpbewmW58an7Fyc8U8VmM1KU5KepkTbJGgo5CRGVISWjb1mFVCDoql6OS1DbkCfjLvS8fOYuvgS9IHERVmI79hhh0p274JCPJcWnT/rBuHO4oQpfzWSCGNg9k8QoHpV1xGlQkvG2gXewJksLoRk4UmjYCyWGaECyepj08B9nAqDTU69g7l44BJWlLej6EuGTWbnKEP8ev6KImt0qrGPfhvlT/81Qif3uoyC5b994mL+jJld8cl8rqOzDELZuD4IJv4mW5ZdxsRO/X7lN9mTx0k6nt28aftSGwrUK4hM7FyPrJLNv2lzWh+kF4XKCVdi5vXOOY9XpG3JqvntxER7ydoIq7P6qvRPXwIPSZxdqV+ikMnnzJSznkaXyaTtYpH7WdX/zpbIuQWWQPICfacFfJjSGVxxSId/0A4a+jGGZj8xKWBVzB1icvMliT6Qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(366004)(39830400003)(396003)(41300700001)(66946007)(186003)(2616005)(6666004)(6486002)(8676002)(83380400001)(478600001)(66476007)(316002)(66574015)(36756003)(66556008)(6916009)(5660300002)(30864003)(2906002)(8936002)(44832011)(6506007)(4326008)(6512007)(26005)(38350700002)(38100700002)(52116002)(1076003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z0eQ9sCdTkdRd940wxrNSwvfOwaO4lNY6YE1pPFtZGvx/WgxTybYNk0+LrMl?=
 =?us-ascii?Q?5VTjqBviGEvu36LkWWsbtyN/3PA3TIXVNuxHmhakfdy2MzV7i//etFlWK3fg?=
 =?us-ascii?Q?WCfJ0wiTAM1nxh4p61brhnwfN4+++ideWNM3bRfA2rA2gVlF2J+aHVOifkhr?=
 =?us-ascii?Q?wEtvBKJKVAOTHF5uKD+1oOK4Srq+y9WecHSvkywVzVsnYpUdbkqPlMezHVXL?=
 =?us-ascii?Q?cEB/HVPV92GzF2M5GU/4IoaaWFiMr4uNe4qWNjalfYHJ5XzbZW1qkq4pu7VQ?=
 =?us-ascii?Q?y+3gTLpjVcUyNMnSnaTqMH7XMb1G7iCfQHfmX4keEhWGuEAWTRu1e6aWq2DZ?=
 =?us-ascii?Q?28Nja0Njcv9VjNOSVLn47t48i8Vhh41yR74EbPm9yKCzrP0bg3OajAOVjNr7?=
 =?us-ascii?Q?fEOtDRgwok2qbCVsB9/8GT8pzA1Oy7RgONvMixCNvQbL8s3+lqQigc9bLayh?=
 =?us-ascii?Q?RLhMxIHihoMLHGV3GLPeFJETRI+jN/+gh7xqASunlnWcja+yWIcBwkqMcRXR?=
 =?us-ascii?Q?tKqd8jdxVgwUD0oUnNpNCJL7WOsO+7LIrx52svBQfu91ECVjAu/8LOwCRsbV?=
 =?us-ascii?Q?RnpvnhwlewgEffX39UGn1bYuoYudEmWM3geOUPxslbQMEv5VGC+S0CKKshtV?=
 =?us-ascii?Q?CiQZSK5hkD/K/kjmhcy40vW1rc/PCeleL5EcOcoAaV+VrIhbTe3IjD+DomPu?=
 =?us-ascii?Q?hbG0lFQkZph6oV20eWHGFPZjBjuontDIW86U1VPLqNYxOD9uO1uP492tU13m?=
 =?us-ascii?Q?ycaVmsrWQnfMcYG5thsMztqzUaHcwJBx+pLOw3kQizRDNFJ4+CchIGUxnMHu?=
 =?us-ascii?Q?uk3xW8nPZUA3izJLL33DFkcahphSx+bKMhle49qd0mv6tL+mS+gUOTBK0wyC?=
 =?us-ascii?Q?q5Ide3yxUHmro72DHD1U71sawtXfNgBbz8w8v1Zmuqx0o+pVJnHje/OuLjow?=
 =?us-ascii?Q?9cAiwUZ7cvxxkzYkcw8bpGkgNrCiPSnDHDz2FDgSEmYZYeMQUOEKOfdm1bHI?=
 =?us-ascii?Q?2Ig9ogiNOgMRFX/+4P6ppw4q+a4daF1CCEObe+z4P7exOk6vxT2aToS0IMZ7?=
 =?us-ascii?Q?RNSHSsjnPHWTmnz8xAM28SgO9vizD4gz27I9I5PB8mz1gHrh3qZ3RMZDpnnF?=
 =?us-ascii?Q?QcYjBunEU5MI3o6KbHeftT2zpdTUg5OadMhmb5jdTXfR5FNUW3hLLM0Ra/Ne?=
 =?us-ascii?Q?b+CoemuF+3VpDke61jpEKSHVC+JVxaUlEYvscGMeOEYWbGB60Z5VZmyMY5EL?=
 =?us-ascii?Q?a65/XEu3yyzvVs7QEIU2vubFRa1RXH2RCRiTZd3RDKEtlxDVXX/6FSHGdLeu?=
 =?us-ascii?Q?8mRDoRyoyydjNmXgEIlfajdsqg092fHS01qqKtZKsjPgXNI+7OXALrmM5Adg?=
 =?us-ascii?Q?JXtPwcuS8yFmIvvoJAJVSh8Qgk37cGFFisN4x4GRvZTbXFe0wU4rCk5gs/Kp?=
 =?us-ascii?Q?jZIxQsm2317Fye6VF7kGMMtV9mvRoIHbEsVfypxw5vpu5ac1lyu74HfSFN3L?=
 =?us-ascii?Q?Qnff0SvX4gyI1U33aE99sYN4cHzKlgzGpIuQGVdovO3kKaOR7pj7gj8tF9u8?=
 =?us-ascii?Q?3U7SQV3ony9MU43XrNeqX+++clo+obMcPFQFwUZZBznZedlAXWkmSaA5DdA6?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f4af3083-f25d-4787-097c-08da69757719
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 10:57:25.8908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDV5ks9+7p1/MfIi2AplaraqaF8f0+bn6Lv4V1Um/flpGXsR+vE6Nm30lK4K1Q5UtH3w0pcxGiYPq2WU8LYac2vGjvse9iRVdXK0GvicNoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0191
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
PATCH V5:
  - change rwlock to spinlock (state_mac read / write);
  - fix checkpatch warning 'networking block comments don't use an empty
    comment line..' (1000basex comment);
  - fix typo in comment (100basex -> 1000basex);
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
---
 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/prestera.h  |  10 +
 .../marvell/prestera/prestera_ethtool.c       |  28 +-
 .../marvell/prestera/prestera_ethtool.h       |   3 -
 .../ethernet/marvell/prestera/prestera_main.c | 354 ++++++++++++++++--
 5 files changed, 334 insertions(+), 62 deletions(-)

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
index bff9651f0a89..2f84d0fb4094 100644
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
@@ -151,6 +153,13 @@ struct prestera_port {
 	struct prestera_port_phy_config cfg_phy;
 	struct prestera_port_mac_state state_mac;
 	struct prestera_port_phy_state state_phy;
+
+	struct phylink_config phy_config;
+	struct phylink *phy_link;
+	struct phylink_pcs phylink_pcs;
+
+	/* protects state_mac */
+	spinlock_t state_mac_lock;
 };
 
 struct prestera_device {
@@ -291,6 +300,7 @@ struct prestera_switch {
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
index ea5bd5069826..c267ca1ccdba 100644
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
@@ -169,23 +176,259 @@ static int prestera_port_close(struct net_device *dev)
 
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
+	}
+
+	return err;
+}
+
+static void
+prestera_port_mac_state_cache_read(struct prestera_port *port,
+				   struct prestera_port_mac_state *state)
+{
+	spin_lock(&port->state_mac_lock);
+	*state = port->state_mac;
+	spin_unlock(&port->state_mac_lock);
+}
+
+static void
+prestera_port_mac_state_cache_write(struct prestera_port *port,
+				    struct prestera_port_mac_state *state)
+{
+	spin_lock(&port->state_mac_lock);
+	port->state_mac = *state;
+	spin_unlock(&port->state_mac_lock);
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
 	}
 
+	err = prestera_port_cfg_mac_write(port, &cfg_mac);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void prestera_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	/* TODO: add 1000basex AN restart support
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
 	return err;
 }
 
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
@@ -366,6 +609,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	port->id = id;
 	port->sw = sw;
 
+	spin_lock_init(&port->state_mac_lock);
+
 	err = prestera_hw_port_info_get(port, &port->dev_id, &port->hw_id,
 					&port->fp_id);
 	if (err) {
@@ -380,8 +625,10 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
+	SET_NETDEV_DEV(dev, sw->dev->dev);
 
-	netif_carrier_off(dev);
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP)
+		netif_carrier_off(dev);
 
 	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
 	dev->min_mtu = sw->mtu_min;
@@ -432,7 +679,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		cfg_mac.admin = false;
 		cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
 	}
-	cfg_mac.inband = false;
+	cfg_mac.inband = 0;
 	cfg_mac.speed = 0;
 	cfg_mac.duplex = DUPLEX_UNKNOWN;
 	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
@@ -474,8 +721,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
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
@@ -521,8 +773,10 @@ static int prestera_create_ports(struct prestera_switch *sw)
 	return 0;
 
 err_port_create:
-	list_for_each_entry_safe(port, tmp, &sw->port_list, list)
+	list_for_each_entry_safe(port, tmp, &sw->port_list, list) {
+		prestera_port_sfp_unbind(port);
 		prestera_port_destroy(port);
+	}
 
 	return err;
 }
@@ -530,25 +784,47 @@ static int prestera_create_ports(struct prestera_switch *sw)
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
@@ -571,19 +847,20 @@ static void prestera_event_handlers_unregister(struct prestera_switch *sw)
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
@@ -1083,6 +1360,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 {
 	int err;
 
+	sw->np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+
 	err = prestera_hw_switch_init(sw);
 	if (err) {
 		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
@@ -1183,6 +1462,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_router_fini(sw);
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
+	of_node_put(sw->np);
 }
 
 int prestera_device_register(struct prestera_device *dev)
-- 
2.17.1

