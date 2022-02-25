Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A650F4C4154
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239027AbiBYJYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbiBYJXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:49 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FC51A8CBE
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jkw7L8H3vMYGdg8v8Vo9HQTfowOf/SljNY82USBaReSctZ1msGt0Zqy42uAfa7hTtdRlSEFDU3VPJVeJI5IDNPbYeLRQjqgfVmLjaOOGhvhjdaA3MwvYrAX7v2M0BEIHGunIbJxtACre4LJHJ34AzLPoFZYDqxf75rsBFxKE3hRn4f93RYcNRe8GTUhSADI0iE+laaD5xDPdbgOSG4DymchBAibBut1Z9mk8GpfIyFNgICHL8zdB/z+KYG+tzDZ2X5lIHBNEHbKZrEjmTlsk1JuQKMtCE1VX8IcPvqh8dVQ8hZ1T7plABAq58JeoVBixeVo/3tshhCZN+3uoz/S5+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iS+GqPr9I6WupT727uSxG2NUtd05u7iHRNLpXueVkTw=;
 b=E+hZXXEclaemLRS6fbopJEDpb9f2YE9XkGq4xP1khzsyN+RHmnrOtdLpx/+sVaWEfpVmM6+nKxRvBfa2XZPXv/DyXwOwGEFsUNpdqi2tvqUN5vNHoaL+XxuLGX000TWVs4KjOoHnhypgW3l2hmHwAFu47MB1tOGjm2LERrwmbsPdScPXBI+FuS3U6vcfILhVsbl3p8d43XY8rCzW8XFtdPzeFJ9oow5zRu2KVUF8mORkDHEJXZ77GpO2iK1NZVPBn67Xw0KiR2J9G/p+YG9aE6/D+nRU3qkf/3bIUKHKvnNgVp0DZpBCIpRub8mgbGxy9DSqlroNLMhGFx6AcrSKBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iS+GqPr9I6WupT727uSxG2NUtd05u7iHRNLpXueVkTw=;
 b=VDa52gmaSR5leeEOdbvXBGCFdvdhytFaupE8vgU60KVu0HjJ1HGGisLltB/mP93BOOfAksyhJAikCjM17bnaLSNZCXZUhGsrkZ5ei92W5lSyxpU07onUgNfcXzbzFca8dNoKCr9wj2hx1h+Rj5ZIWg9bDKIB0fKgPN7EZRTddUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 08/10] net: dsa: pass extack to .port_bridge_join driver methods
Date:   Fri, 25 Feb 2022 11:22:23 +0200
Message-Id: <20220225092225.594851-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7c8a424-e9a3-4ea0-8c35-08d9f8406fe2
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB7658B87FEC2266D308FBA6CBE03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83BnTGwFh4r6PceZWbH2QcRy9FukV5qH6qGRquPBo7ajSDq4RRz/MQqECLdy8wXlodxH/L8ypIgrv1jpjXmHBnh7YvHWbsE1yKsP20pCskwcTTbcFH2Ih3v4tFGdBML5WxEE+nlwdKslJCxEo6HRYdwPx84eRr5uzPpU8xrfx7AfjXcIqLqTfYmJBP41XTUwlAFnyaIqQDGCJyfOwPFXtMkhddcULmDACd/ynTmdZk8bMrnEC7c69g4fLQNWfGk6XJsCbt3A/5oQzzeafBoJ6bbHaLraNH/Aj9QbwGIxaEdndzNSppSrkFRDNGOPWnN+ywz3tqwnYdMCjbIXHhWiIQ9MRktq99/MXPxIJXcOQ5gxCuhF/iD8EylV3jhg/H7W3JqNwfMyPp/0qgPe30l97AcoBL2tEkGznwerlIQKLuxB9fOWYwsaksJefiuc+41uQYNLoj27209c2cfjQEuZ9u5Y7P52i4ufzdcbTJ03BKvuDIxW+vEmV1NIGHoKdDSrNXoyp8H0ei3nh2HbnDSxlHO2vcxx5s7h+NTi5iVqm64NQGJZzpG0rTUnZXNtiadfQ6c80LKjkFlYSyETJi30QoGmAIKhnLFZDGu788VMfvMpyYaN0Q4drO+uR/fUoMtZqmXwD0mFenCM4eISFBXjVpCbF3h9efrmEEpvC10Yc+Y70sbE+vKfUrriOfDXS59Zvh1tHihDfz4NxG9K+hhb23Q6TtQ9jXMm/aGj9WchCyk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(30864003)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h/RyZ1drtcgJr4RR6wgZ2FieINEk7Z3JYQmaEBiHAXwwHNBxLNQQKwkLesQT?=
 =?us-ascii?Q?bgTRD2+I9oyTwlJvUd19EU08uxiEEGvVXJfjEcsoD0lY+yypSZ53/H8fOboj?=
 =?us-ascii?Q?fsP6oAaWAn9jXyn4nVFVS7OqFYPBX5IF7DvMeeJ8ovsqzed1IVjfquzqXASt?=
 =?us-ascii?Q?HDeBGOSwLmWpn36n2po+0DrgFI3J+X33PUKCpdRHx+2IkRAkRaflADnngAnG?=
 =?us-ascii?Q?R261r6oDRYEBjYlXTuce8hmgPfhnufOBRuNRRsLK40fUOIZWUXCEVDfBVK+B?=
 =?us-ascii?Q?OdFx3NeE6vbZi0Zk0QzfI5ooprjSdi5YpuOJEhDGBLsCfKJ2KmwqQhIwdCtt?=
 =?us-ascii?Q?s0wUGn7y21nXSpzETbhf+wHch0Xqz0ZdhmQJbDgjNzveSX2YCL6PwHjH9xyq?=
 =?us-ascii?Q?pviSK3jsPvogvlkYGHpfTS1jAntGo7gATvUsajg6l6Af6FLznXLg6pBZr/CA?=
 =?us-ascii?Q?eQZ7TO4cSIq1Lk4pUxt0DmiTN3WKty6zqgwuDKgtwkNvMf4RFVWOR0MAClZA?=
 =?us-ascii?Q?VJgk78gn0QacVGuFw2PYn0GM4b/KDj4Vl+x70yK+hUGtgEvWgG/sTwETUqnZ?=
 =?us-ascii?Q?x1LoA2nYif3Uq+LHUhr9IgJKrqDcgAMHFa/RMaWcSbTjhxwrk3cja8orHwCk?=
 =?us-ascii?Q?cL5WOsHcbZICciNEblXXyJW31PC52H0QdmMKFrm7J+JYrTYMlkMPFbGzrVeo?=
 =?us-ascii?Q?7msJTTVQCeiaG8rwV6QyvtgkoXAqMT8rybaVJ5vKHgn+c/TqjQCGfe7LLQZe?=
 =?us-ascii?Q?l6izFyi70IVng83UpjCfayDvqNvs5OdHM583QwNnCljW95WWUlpzVl+NAcqu?=
 =?us-ascii?Q?gOJwcsCEdt+WXeJo+pFw/ydy+uJDXIyrPl3Lm4ahJrQ7AxPg1lbfPRfY8GvM?=
 =?us-ascii?Q?hqA7EVWAQ0TmJpwkJ5WL08PQIXmeXPwbn16d1c908WQC4pM8kjFf/mtHv/mI?=
 =?us-ascii?Q?vWaZRT9ikKv5KhAxkEUaeQH9VAfN3yOO5X5dACZTIgQ2X+wmvztkRpDsreHl?=
 =?us-ascii?Q?IKlDu0kj+nRm4RC0Ax/N75IccWE7udL2uznVM0FprZrbgQpisVb3hcu/vvfX?=
 =?us-ascii?Q?XbN8xHvfmARFaoSG5YK95/Hf5LAVbx4daXi7rNWwnbJVL9jsFnkfqwO3hVmB?=
 =?us-ascii?Q?qxS0ip0RyCAEKjBgCe8yfpM/FKqBi+mQotzPCIO69VqC/Ns/bOLXX4GouCF8?=
 =?us-ascii?Q?9hIvelIHeOnxGDYLLmcwlryq6C2gxIcFTVo5em3rBBo+ONTLUaP93FWW6A87?=
 =?us-ascii?Q?AOe1YPW1xexXHPhfwfKMHY4RjaaE1FDTZ4m8hwiMOJSG1EAtZ2jbmbKM4FTM?=
 =?us-ascii?Q?3MSpL69/IEW6gYcDI0gDigpn8eL+B3yt2nAp19Jf1cxgOgbyRf/sCqLXgm0r?=
 =?us-ascii?Q?EVwgXf9ctMfzTZCmVQ29gGHUuTmD/FhtmOizpTLkYdHb1YoiRDvwoGb5Qvuk?=
 =?us-ascii?Q?V0/ZK+Zo/BLmH+ITJDEe88bZ0hF1M80eirC4uVrHsoT8XXva+9ZhalJkjN3T?=
 =?us-ascii?Q?TQVcW8LYi4OuWidKwX0WXaQeoEPmEjlXIBJeaJC3egq/LR0GJ0NBGH6e9cvf?=
 =?us-ascii?Q?vjbuTeTy8HBzTOUPqzUeGPaiHI7mEelqJr4wx8OyP4zSanUJCKAcgODlHn6C?=
 =?us-ascii?Q?QjVfLyHQU22956H/iRvjGXY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c8a424-e9a3-4ea0-8c35-08d9f8406fe2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:09.0067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0a6r9jK9OHAhkx7AusJIiU6D8cul2z7E/HN9bFzmCRKCoFf3O2RyB4qj224CFoH+ByTMEjgoQIBTL/NHhtkXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As FDB isolation cannot be enforced between VLAN-aware bridges in lack
of hardware assistance like extra FID bits, it seems plausible that many
DSA switches cannot do it. Therefore, they need to reject configurations
with multiple VLAN-aware bridges from the two code paths that can
transition towards that state:

- joining a VLAN-aware bridge
- toggling VLAN awareness on an existing bridge

The .port_vlan_filtering method already propagates the netlink extack to
the driver, let's propagate it from .port_bridge_join too, to make sure
that the driver can use the same function for both.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 2 +-
 drivers/net/dsa/b53/b53_priv.h         | 2 +-
 drivers/net/dsa/dsa_loop.c             | 3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c | 3 ++-
 drivers/net/dsa/lan9303-core.c         | 3 ++-
 drivers/net/dsa/lantiq_gswip.c         | 3 ++-
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 drivers/net/dsa/microchip/ksz_common.h | 3 ++-
 drivers/net/dsa/mt7530.c               | 3 ++-
 drivers/net/dsa/mv88e6xxx/chip.c       | 6 ++++--
 drivers/net/dsa/ocelot/felix.c         | 3 ++-
 drivers/net/dsa/qca8k.c                | 3 ++-
 drivers/net/dsa/realtek/rtl8366rb.c    | 3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c | 3 ++-
 drivers/net/dsa/xrs700x/xrs700x.c      | 3 ++-
 include/net/dsa.h                      | 6 ++++--
 net/dsa/dsa_priv.h                     | 1 +
 net/dsa/port.c                         | 1 +
 net/dsa/switch.c                       | 6 ++++--
 19 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a8cc6e182c45..122e63762979 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1869,7 +1869,7 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_mdb_del);
 
 int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
-		bool *tx_fwd_offload)
+		bool *tx_fwd_offload, struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index d3091f0ad3e6..86e7eb7924e7 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -324,7 +324,7 @@ void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
-		bool *tx_fwd_offload);
+		bool *tx_fwd_offload, struct netlink_ext_ack *extack);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 33daaf10c488..263e41191c29 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -168,7 +168,8 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
 				     struct dsa_bridge bridge,
-				     bool *tx_fwd_offload)
+				     bool *tx_fwd_offload,
+				     struct netlink_ext_ack *extack)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge.dev->name);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index cb89be9de43a..ac1f3b3a7040 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -675,7 +675,8 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
 				      struct dsa_bridge bridge,
-				      bool *tx_fwd_offload)
+				      bool *tx_fwd_offload,
+				      struct netlink_ext_ack *extack)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index a21184e7fcb6..e03ff1f267bb 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1111,7 +1111,8 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
 				    struct dsa_bridge bridge,
-				    bool *tx_fwd_offload)
+				    bool *tx_fwd_offload,
+				    struct netlink_ext_ack *extack)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 3dfb532b7784..a8bd233f3cb9 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1152,7 +1152,8 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
 				  struct dsa_bridge bridge,
-				  bool *tx_fwd_offload)
+				  bool *tx_fwd_offload,
+				  struct netlink_ext_ack *extack)
 {
 	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 104458ec9cbc..8014b18d9391 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -217,7 +217,8 @@ EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 			 struct dsa_bridge bridge,
-			 bool *tx_fwd_offload)
+			 bool *tx_fwd_offload,
+			 struct netlink_ext_ack *extack)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * appropriate state so there is no need to do anything.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 66933445a447..4ff0a159ce3c 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,7 +159,8 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge, bool *tx_fwd_offload);
+			 struct dsa_bridge bridge, bool *tx_fwd_offload,
+			 struct netlink_ext_ack *extack);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index abe63ec05066..66b00c19ebe0 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,8 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct dsa_bridge bridge, bool *tx_fwd_offload)
+			struct dsa_bridge bridge, bool *tx_fwd_offload,
+			struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d79c65bb227e..84b90fc36c58 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2618,7 +2618,8 @@ static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 				      struct dsa_bridge bridge,
-				      bool *tx_fwd_offload)
+				      bool *tx_fwd_offload,
+				      struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2684,7 +2685,8 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 					   int tree_index, int sw_index,
-					   int port, struct dsa_bridge bridge)
+					   int port, struct dsa_bridge bridge,
+					   struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d92feee97c63..0b1bcbd230ee 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -674,7 +674,8 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct dsa_bridge bridge, bool *tx_fwd_offload)
+			     struct dsa_bridge bridge, bool *tx_fwd_offload,
+			     struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7189fd8120d7..4585332aa7a8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2246,7 +2246,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 
 static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
 				  struct dsa_bridge bridge,
-				  bool *tx_fwd_offload)
+				  bool *tx_fwd_offload,
+				  struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask, cpu_port;
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index fb6565e68401..1a3406b9e64c 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1189,7 +1189,8 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge,
-			   bool *tx_fwd_offload)
+			   bool *tx_fwd_offload,
+			   struct netlink_ext_ack *extack)
 {
 	struct realtek_priv *priv = ds->priv;
 	unsigned int port_bitmap = 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 91b0e636d194..13bb05241d53 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2087,7 +2087,8 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
 			       struct dsa_bridge bridge,
-			       bool *tx_fwd_offload)
+			       bool *tx_fwd_offload,
+			       struct netlink_ext_ack *extack)
 {
 	int rc;
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index bc06fe6bac6b..3887ed33c5fe 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -534,7 +534,8 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge, bool *tx_fwd_offload)
+			       struct dsa_bridge bridge, bool *tx_fwd_offload,
+			       struct netlink_ext_ack *extack)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 87c5f18eb381..cfedcfb86350 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -937,7 +937,8 @@ struct dsa_switch_ops {
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
 				    struct dsa_bridge bridge,
-				    bool *tx_fwd_offload);
+				    bool *tx_fwd_offload,
+				    struct netlink_ext_ack *extack);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
@@ -1021,7 +1022,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int tree_index,
 					 int sw_index, int port,
-					 struct dsa_bridge bridge);
+					 struct dsa_bridge bridge,
+					 struct netlink_ext_ack *extack);
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
 					  struct dsa_bridge bridge);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 27575fc3883e..07c0ad52395a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -59,6 +59,7 @@ struct dsa_notifier_bridge_info {
 	int sw_index;
 	int port;
 	bool tx_fwd_offload;
+	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_FDB_* */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 7af44a28f032..d9da425a17fb 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -328,6 +328,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
+		.extack = extack,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 1d3c161e3131..327d66bf7b47 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -96,7 +96,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 			return -EOPNOTSUPP;
 
 		err = ds->ops->port_bridge_join(ds, info->port, info->bridge,
-						&info->tx_fwd_offload);
+						&info->tx_fwd_offload,
+						info->extack);
 		if (err)
 			return err;
 	}
@@ -105,7 +106,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	    ds->ops->crosschip_bridge_join) {
 		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
 						     info->sw_index,
-						     info->port, info->bridge);
+						     info->port, info->bridge,
+						     info->extack);
 		if (err)
 			return err;
 	}
-- 
2.25.1

