Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0946A574B49
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiGNKzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiGNKzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:55:33 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130111.outbound.protection.outlook.com [40.107.13.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD0D558C6;
        Thu, 14 Jul 2022 03:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIHhSCgMbnYfX4R01xtZANiz/llH5UpADIBct6vmbXB3s0Dl5+yZHRBYbh7QfhahddxR3B1c9dL7ASaxL3nII8+M0JwRuLghGBxc8WPnV+ZvcXTFF6mxwkMaTL2s2Qp3KenXDB5YglbrHw9iziQis24cF1C6IaGhhUjOhy/7GANxj55wy1LfZMKuVVHgNeNsw93z5H0xfV6htPfkuxDUzAkUdktIzGbhrQhYpal0+HBuOzqAqRk26tetw7EsZfN8lVnTI2ECGT4rpPIItEDj0hOhlo3nc1z0wfRKd4NSie9sLTb4rGRzKY78bHLex7w1Fzs3ZZt8Uixxl6Fmnld3eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXQKides91maz7Nt3F8xw5UZBcuDkDH5ZXYjIxkuf7o=;
 b=OnTyo5eZXl/9jHUhPhLgt5C0V8vC7GsxVfuWe4btHtYEsm2jrMgHhe8eGsCilD34AOlO80REoivf5cocCUb2KRqDpf2WZ8RrmhEI5Q3juZn/GY3hTxohJWaIvu8D0sdZzmRpD6JEkgrqGu6cnHtsKH05YDES6t2yPlTWRK6BnJuadXdVAPSp0aoTyGIRy3zIPsdY2zABiLlJgs5H8pS35PVtPvKU+5mDA+o0I+RRzwvsQEIlRx6gGZLjt0/BuJUMm0lTvtfUcnGlSj8yz1Z2wy+8u0uBJFv67HkIY82wZe7+/cosHjBGL1bqRc6TaYDqdPKBk76vaA6XcUHY9VixFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXQKides91maz7Nt3F8xw5UZBcuDkDH5ZXYjIxkuf7o=;
 b=Ejkq91rs7K7NrB3pRNxhOP8gMHx4ucNi+VDqiFTdqIhGeWx/j1VmAoX9PUpZpHPztJuWJ/Znfw2MKLJiOi1oAb1XlkmEGN8RFdn/lrndr44OVACLL7C/0NcmLIDpEgXbKUgPI8eBON2ci7vKaCKsc2MIBbq6o3EQdFETmDvi+LQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM8P190MB0898.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 10:55:26 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Thu, 14 Jul 2022
 10:55:26 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, linux@armlinux.org.uk, andrew@lunn.ch
Subject: [PATCH V3 net-next] net: marvell: prestera: add phylink support
Date:   Thu, 14 Jul 2022 13:55:16 +0300
Message-Id: <20220714105516.14291-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0102.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::27) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15105d81-083c-4189-b5bb-08da65875b78
X-MS-TrafficTypeDiagnostic: AM8P190MB0898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juN4vYdyq+5H0y5L3+oOZRMpPDzl2kQu5Ts7lT//v5jCa8zXE92TgDu9hZCmdqzZ5+99znTE8xvTiSqiwzdqXS4iEt4blMreV192Eghh3Y62OP2KwbJVeTUw5q/mNK/m4191/I7k2pb6AZpy6r5d3vGCeXwJ3v3k4/IOCDPH0pohqybahKDZbiSt0SYgCzR/KueEqNwas9fQ/bW62Z6Fs1+9All4nHnvqNsbvEPbt8vJlqUXVVgGLBR98B2y2UTFg/fGpErMfsk+LjfoH0bEQW70UOko4Gusu9LWsoV93E7T59x8zRNaPX0EOgAVijDqU9GjrJKZhmzAbRAefK8mbdPiu10pFzQexHpV+iD49yrCyFj35y61QHJASmdd2k2zIT+UyggGsJPZZvZRQLuwOYkeA4vyNx8mbsEcToLYVrROTrAduuo7nrClZHiuDOS59/Bkhv9GltAsLH2Q1dQ3d812xcKGZnXvFXFgQzUp4dkq3nuxPqvFGKWZudAMOrsmAVQMmnbvxZUM1slHecolDlb/R/hp5CnNCFMjg2YITsa8hwyfGnHVLm20rgeAtz2PA+tYT5Em66r/auyMbZYO4eEqtfprX1Ov7RrgUeqTcjL7fucjpC9V9oj35FxYrevdhA6VW/hWeCz3s87l+RLXpSDYO2IiBH4Q32c1yMTZqoCkwTlscJwBr2gn0qt+Tp9fKYicw3cn/bhIEaJZ4OaxpZQ1NWIh4UM6BZ2+jh3GZnzAyWvjqhuTajmV4zi1Xj63PmCclK0mT+UFehR8IyhNjNW1TKFGBixB1LQs1h5oH89gmZ9WRhj/5angMj12Nxob
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39830400003)(396003)(136003)(366004)(376002)(36756003)(66556008)(4326008)(8676002)(186003)(83380400001)(66946007)(66476007)(66574015)(52116002)(316002)(6916009)(8936002)(38350700002)(26005)(5660300002)(6486002)(6512007)(30864003)(6666004)(1076003)(2906002)(41300700001)(2616005)(6506007)(38100700002)(86362001)(44832011)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AElW1x9j/NyZpuu3qDQE5gJGtNgFT638Nd2XzK2YeuXVT3Qk4Uz0DC6jsxkC?=
 =?us-ascii?Q?l5PfDn5uxNr/mp3GN4wCqXGhSRh0GVUg80WBKIIB3zWt+RQbF6Yd9lfNmY/t?=
 =?us-ascii?Q?ltULvSF1b9OurlVLyltzjlhcuCr+dASkuVYlz3VpbS3tz65XAc+XDStwszeB?=
 =?us-ascii?Q?AcCREpvacS/UBRQrQTbYandhDdPdQ+RzvPvrZtf5/MJftIl78P/f7zWQv4Bj?=
 =?us-ascii?Q?0t6foEbz9mmNn74z+QbjCeBVIRomxVaHhVgizkpjZE5ZIgB+nDPWJZNdCEq4?=
 =?us-ascii?Q?sYWkAajvVSoer3mKNw13MjABr492+lRNvft7+FvGRLeSQ1Jvem3THQ6bklIR?=
 =?us-ascii?Q?+cqPkVypEQSZpqFBNuN1iAvZDSo9u7dQWWzk67SKZd9cTT5C2v3udV+/mP+z?=
 =?us-ascii?Q?1ftfvWJvoqQAy0HEv4yRaGiTtzVLtikxtNsrB0wElhCqqGpQTNpfGr2GSvLH?=
 =?us-ascii?Q?Pw8yPxRUNaRjJt1C73f6WHrSMmQKflHuqd1wD8AQ6Z+mSkqH71JDZwfKS1GB?=
 =?us-ascii?Q?2FNvzxs81nZSaM+Uiy/49ExbSwPJD9CXsPwunN65ILRHLivohOovwIYrRU5C?=
 =?us-ascii?Q?BFG8if7BqXrO0XOTOYUbsacD+9qWnR/cgy+XkeSitLTHHNC0p2ppK4QPDVy+?=
 =?us-ascii?Q?YK9mtdsxpEczixUbis5oVZIOwhVaf9UZbHTGgKmYfXcBBhW7rGKSNPCyz5Wj?=
 =?us-ascii?Q?Ixx8oMctF79kq1FnDg8sOPCrSBD/P28U9ZnKJn8MA62PbJVvCAdDiJ+MLjDY?=
 =?us-ascii?Q?En9pJbZJNzdRfvewqbaBfFUIvUjkfss/JZ+Km+H4ZOKLmwXEBBcf/Eqk2hul?=
 =?us-ascii?Q?R1ruwyEC6fzyQX1bqeXesx+EOT0gzbGPH74EMyy/fy6D8Na5P8J/7DcFJK9I?=
 =?us-ascii?Q?opR8otJbc71io002q64c4P6RYn7j1HxinpQVfhynHMJ6T4sjYCdn8B3NXWWj?=
 =?us-ascii?Q?yVagUcYSa3v5PjOPvEFIH21T2dNISSokkw30yILna1TV6Cne4DzTYZ21Lhi/?=
 =?us-ascii?Q?EKSzzacRwuJn4y54OalK2z8uE8+ETAfmLrD0Iudt7GWY5Ww2wkFSCbvXiI9V?=
 =?us-ascii?Q?8koT2ajnVrfiQ0eezUyPgYWNv024EfQfWvNtpj96xub0gcXl+bZYxbOEqSoH?=
 =?us-ascii?Q?PQXxupQ2kyoIo/P8LzEKvp9rcqlPMBxJFCOJDYV9xgX7UBDU7tkHebyHPyzF?=
 =?us-ascii?Q?xgo3RnKf7hiocgLbhkyIpnqfdFoE58sq9/fZpjW4NMfKWnUGOtVkZ1ZqdvYa?=
 =?us-ascii?Q?isQvZWEpvJp8DH+6XbacZL7KQX2sk55vvDMNuffCKfdFyTc2hm7MGebPIXgt?=
 =?us-ascii?Q?dqtcIaLRyXT6z5ZoUaBmWMMDhaDz9LjHBuijZxCiRoDs6xTBL0G1/UvVYZ7j?=
 =?us-ascii?Q?uSzV/Kx5w0587mdIZvMvWTSvMBl4DTL4QjV8VP0pMyAf/sHClW8jAGpMRW4o?=
 =?us-ascii?Q?1rMdzwaxr7xdDGSyasUWmaC3CSmRf08y+eYLY2PjF/gXCFlKaM5TVnrLCIQQ?=
 =?us-ascii?Q?2bBJvwoamHd85gc36sBxrDMJGgrqmP/6J1wOw0lhFtwmTh1Ncip+QrkrLdVT?=
 =?us-ascii?Q?49mcFZgMvk087nvcA8UKm9daxGotFuOtR3Uw8dBsbuGB5QMpxGlFbWxNlQ3X?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 15105d81-083c-4189-b5bb-08da65875b78
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 10:55:25.8942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwV4XcCGCrRZLC9xGunAVYOKFXcUhOj3obonUJT4JRYyJi+4B31IQgGoEcr5BdadYTXRfQTzvzECfOFL1VsiSB8ud4CRTinw7YSwtOrxpUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0898
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
 .../net/ethernet/marvell/prestera/prestera.h  |   9 +
 .../marvell/prestera/prestera_ethtool.c       |  28 +-
 .../marvell/prestera/prestera_ethtool.h       |   3 -
 .../ethernet/marvell/prestera/prestera_main.c | 348 ++++++++++++++++--
 5 files changed, 327 insertions(+), 62 deletions(-)

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
index ea5bd5069826..65fded8c8f87 100644
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
@@ -169,23 +176,255 @@ static int prestera_port_close(struct net_device *dev)
 
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
+
 static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -380,8 +619,10 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
+	SET_NETDEV_DEV(dev, sw->dev->dev);
 
-	netif_carrier_off(dev);
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP)
+		netif_carrier_off(dev);
 
 	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
 	dev->min_mtu = sw->mtu_min;
@@ -432,7 +673,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		cfg_mac.admin = false;
 		cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
 	}
-	cfg_mac.inband = false;
+	cfg_mac.inband = 0;
 	cfg_mac.speed = 0;
 	cfg_mac.duplex = DUPLEX_UNKNOWN;
 	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
@@ -474,8 +715,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
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
@@ -521,8 +767,10 @@ static int prestera_create_ports(struct prestera_switch *sw)
 	return 0;
 
 err_port_create:
-	list_for_each_entry_safe(port, tmp, &sw->port_list, list)
+	list_for_each_entry_safe(port, tmp, &sw->port_list, list) {
+		prestera_port_sfp_unbind(port);
 		prestera_port_destroy(port);
+	}
 
 	return err;
 }
@@ -530,25 +778,47 @@ static int prestera_create_ports(struct prestera_switch *sw)
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
@@ -571,19 +841,20 @@ static void prestera_event_handlers_unregister(struct prestera_switch *sw)
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
@@ -1083,6 +1354,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 {
 	int err;
 
+	sw->np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
+
 	err = prestera_hw_switch_init(sw);
 	if (err) {
 		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
@@ -1183,6 +1456,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
 	prestera_router_fini(sw);
 	prestera_netdev_event_handler_unregister(sw);
 	prestera_hw_switch_fini(sw);
+	of_node_put(sw->np);
 }
 
 int prestera_device_register(struct prestera_device *dev)
-- 
2.17.1

