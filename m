Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DED5A6DFA
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiH3UAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiH3UAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:01 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D332FD0D;
        Tue, 30 Aug 2022 12:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNNA2KaxIBNYNemTU1bTjfRRfX0B7b8JHqyEIw/H+gi11KvzzY1JnNnY2f0r1B/4LQXSZxH3Vx5nM5XWdkV3M6jXdu3c190guML2rvPtcGmuNyl/huPpu4UjoTZQV0NnpfOd6eyuF+HQ8ge5VZbEyBzXipnSKjJx3L3VUf+gBySBNUQf225ENb7afg6J00m+ggzW8iab+yx6wmURuc2WEYI4N+UqXY9h6wZlthVP1E76mq9LhIG+jUuwnvj6YVVBYSKvgc1f3XnjQCLRrPzptg5d/6xCC6R4qdrgUZV5AlY0sOCugiaaghWbbW1X0T5enHuLogDAFvSdT2YBaBdrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpbV+onS3SIe0zXprmypWJoVoKOayhcwhxLM/SdeX2g=;
 b=fB/BVPk9wJc+cfjaag0X4oyhk6v03awcILRrG5Q2GYRPr+lnOYqq6qXIvIp97UoAdsKeBwe4gZxT9wZyyMB0NQ3V8+I22/kNGxpM9Pb5wS/z2joYoTInOQ0fzF1+8o8h2V9kNtxXm0au41+LVjKFSfAYISQwYIvbO24OokbsNYQ+HYm6pRTSl9WufV9nFqetkFMkdWImJdeopb+mGskx41BoMB7atSbrbsXOta0BVJt6ShDDhG7kuzbm9GbFjUljdHHcAbstjt9g7hrXoVkcAZgWB/rfbgf9UuEtXT5/neIcad2+9cpljeoM9UzfQ8mGNQz93SFftkyvhI0UZvb5Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpbV+onS3SIe0zXprmypWJoVoKOayhcwhxLM/SdeX2g=;
 b=LXZGMs9Qs+qJReikVIY+NJTjA6JivI4bhvfUWVV9ChwzMXILkclAlY8LAkE4n+uSGbP4Ndpr8MpEPbR4GV0mjF6hu3vVJ3JWEkXmngPGnowhv7o26MBtNJ2bY4hOJ9MMkZcLYnTilJfNeS6njOVjuvB/nj6cxKvbg9ymT2WjQPs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 2/9] net: dsa: introduce dsa_port_get_master()
Date:   Tue, 30 Aug 2022 22:59:25 +0300
Message-Id: <20220830195932.683432-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a289791-d83e-4be0-6330-08da8ac22faa
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YLI25I/TVrPrmzYGsk03upnTHnbldoBsODOd5COtsg0hHHspQPT2cU/WQnqlB5uSX4itHbtDLjPOboI1YVaAToq0o6tkLmA3HEyOxr22GNpaa0FLHcKJ+LaTsg0vYGnHR+IYhbWfWkwDGaTmRjks52y4nBXDfTRICN650CVcv9OxvrVdhVIDm5XmSMTWy/5udDPRlN2Y1aBkAhAaa07+YFi80Dl9BSMc/gypfPJiCv+oTFxKs8t/Zm4ff3l5CSdOBPbZofjWoiySVwR4HdLzpsesladsy81rP3X3FcCLJLxClDBZm1/mCa6awNHQhoVuKAGeaX7J4naGBsYQVsZimbKeEfAdU5vqIHH8BcKeJ00maf4DEzkdlTZjahMKMc06+biu112PNqGK+eqChMe/RCQ4t6N9huPFrqnEH6m9YqxWBeIkIp5hgxSiCTewEqQUQmQmPHIyVUjhZnqhH/FScrsEyNXOJkzu7q4z17Pn3ba/FZT9G6RqHTTTJFORSTQRD3unwK9IWacHWkm1kjCo2qQg6tksY1AmtNbXf51zigZSGdBQWTfPHuBK3IaeqKKrBC+gTQX4/VjEcXMKCgDnZXJVdJWpM1xx+Om28u2xlbiPUx5ARi6wCOVgOzavIZ2RNfvwX/nQ+6GL5VrYoVZY9Dvtiwp+MEkvefomBi/5IrwQ6N3yrmlNPnA5NOxj3hZMQiZtnNwISB5HPbb1w8S3zaa1bzsntP+hL27KVYix+kgU/UZ1IM0pskw5H2BhnAE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(30864003)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DOntuzKZzn++EG7f9uoEiutnUs9EW/dZ3Nmi1l++495+wUEyw//doWg4gqrr?=
 =?us-ascii?Q?A+I8Hj2Wkdjcq/Op/MKrYkZ6CyNappMOMLC+xysJNdpVEyMIIPc9dxZ4XLq1?=
 =?us-ascii?Q?h0zoBM1TGZjyVtIDhKn0CjKN0VigK3fcYDAvmszdoyWKjVk49JMi4X82qhL7?=
 =?us-ascii?Q?oKb/YCggeG7ABKDMEL9YnIK1dYaLUqVa2Do3CIM9/2FXGaqPJiKdASKdG7cS?=
 =?us-ascii?Q?OqignbGVH0yi6PZ1T1K8+0qcsVO8XK61BF0E28ockqTL3T3Gwf4QSKfntWRs?=
 =?us-ascii?Q?uSKYd+kA9fR1PKnaZu3lQ6M1zVr1DAlHr983ntE60kPKXG3i2waoFVkJvZvy?=
 =?us-ascii?Q?gGC6Pl9xqo/cbQyGS3AEKjze74ai0HpbZ2+iv62iwTnemCj2TxTKpx8/kTfk?=
 =?us-ascii?Q?ENsYd7qDEKjz6XJhaOumFnOumpvK47szqttnEJjxmDcvfWlVM0u84m/vErH2?=
 =?us-ascii?Q?AsKW8RiDtDMe9Y9/6xD8E1WGGOUQW1VL/iWBWUU1ebN/r1rdIKfqjWgFd0LZ?=
 =?us-ascii?Q?W+EfOpre0DL93N4LTMHV6oHwqyYolFGEZouFGeuOhiFSYheU56tfk10kswc/?=
 =?us-ascii?Q?0Jb+IUzfTab734khqfkAxiBuKn6pTvtbj2XKws6ZatyxyKU8lOIQ/Xxic2sb?=
 =?us-ascii?Q?uGf9WjBKcCX38QjXoR+evc07QEb4I+AMsYgFQPTxu1LvAOZsHJlayEycQ1sT?=
 =?us-ascii?Q?KYyocMDSLLyCsdzMJS/YyieQmvk5shjnJusj0BgCSnZwcJIl3QWGMewHupO3?=
 =?us-ascii?Q?YY1E+pWnduhTf/kfl+vbiaG0IoZs2uevqnQsigcpQoeyADqBC6ZO/kIwkIwP?=
 =?us-ascii?Q?EUKqZFbVsxfeP66LFi3FOQpCldBGz5gclkHOmGclNon1eji51297G29cqf1b?=
 =?us-ascii?Q?pQhUD+rvAqATuhwbdQHWYfJxZ3a+eKsbd8vkXGqBZMnoyxOP//KjQ4ECXycA?=
 =?us-ascii?Q?rgzpR0nr+b8p39dJ99ZQwtmECTof2r9GACFpDQmQqloarsEwdQ0QqqUrZ+jL?=
 =?us-ascii?Q?yZy0dweDqSOW+LhGxRjpbTml2SvUXoCIQbPkuuJZU6y+XwFafrq7L59aCVYV?=
 =?us-ascii?Q?WTsClyvJB50CNe4rOfmu/mYN4F+U6BVcFG3YSAuer6UDdykvpYYZ3QDxUyzl?=
 =?us-ascii?Q?zw2XOtUL3/XnMoIVtJ8rf+tbNLHjFf9RkCHqlhOIQ55BCavmjd5hte35HmHq?=
 =?us-ascii?Q?81s70SydkSu3TO5k8jxB1IalAVaDNZ7ZsWlZVkbWeiqngtt3hMTtKHl2Y/pk?=
 =?us-ascii?Q?zjbf7XAShHN9ADV9BtggWBpRRHgj4JTXANp+PGpsRgmvEt9SQuJFB/HQP9Tb?=
 =?us-ascii?Q?igI9v8mh8VjEEH8xCSxD0HGja9w3/dUtP6upkBNnXvWoX864DtnHqVcFwi8v?=
 =?us-ascii?Q?6ocFVF8if0P6vb3lvZB7BV6VUyCVRdVQqXlRmEktI6jeER35SMkwUguxEOuw?=
 =?us-ascii?Q?2B1GOAeQ+Ocl9qeew8orxJM4ZhcKDy4H7tOUMfKiNPxCaajSYVqhoQz0Ur7L?=
 =?us-ascii?Q?TZRmIHmIQf5PTwuaPihjnSE/Nv7GazcdGpIZt2+BpUjdSqOY1JT9XhKiIdBn?=
 =?us-ascii?Q?MtdKpsL8E1Ydv/eEyndpIRFp12quUOt8Q/2u7+vywgPSESWrImwUIdXL+1c0?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a289791-d83e-4be0-6330-08da8ac22faa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:45.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/FplQVzqFxgYYkNPbWwqlMvSWNMBqj68N6fSc0xR3FawLctuQ7a5NtGyC4TzkloLq6Y5y+dbyOGgfcMIKhqBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a desire to support for DSA masters in a LAG.

That configuration is intended to work by simply enslaving the master to
a bonding/team device. But the physical DSA master (the LAG slave) still
has a dev->dsa_ptr, and that cpu_dp still corresponds to the physical
CPU port.

However, we would like to be able to retrieve the LAG that's the upper
of the physical DSA master. In preparation for that, introduce a helper
called dsa_port_get_master() that replaces all occurrences of the
dp->cpu_dp->master pattern. The distinction between LAG and non-LAG will
be made later within the helper itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c                     |  4 +--
 drivers/net/dsa/bcm_sf2_cfp.c                 |  4 +--
 drivers/net/dsa/lan9303-core.c                |  4 +--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  2 +-
 include/net/dsa.h                             |  5 ++++
 net/dsa/dsa2.c                                |  8 +++---
 net/dsa/dsa_priv.h                            |  2 +-
 net/dsa/port.c                                | 28 +++++++++----------
 net/dsa/slave.c                               | 11 ++++----
 net/dsa/tag_8021q.c                           |  4 +--
 10 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 572f7450b527..6507663f35e5 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -983,7 +983,7 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 static void bcm_sf2_sw_get_wol(struct dsa_switch *ds, int port,
 			       struct ethtool_wolinfo *wol)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_wolinfo pwol = { };
 
@@ -1007,7 +1007,7 @@ static void bcm_sf2_sw_get_wol(struct dsa_switch *ds, int port,
 static int bcm_sf2_sw_set_wol(struct dsa_switch *ds, int port,
 			      struct ethtool_wolinfo *wol)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	struct ethtool_wolinfo pwol =  { };
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index edbe5e7f1cb6..90636ae3db98 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -1102,7 +1102,7 @@ static int bcm_sf2_cfp_rule_get_all(struct bcm_sf2_priv *priv,
 int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret = 0;
 
@@ -1145,7 +1145,7 @@ int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 int bcm_sf2_set_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret = 0;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..181e082b0919 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1090,7 +1090,7 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
 	if (!dsa_port_is_user(dp))
 		return 0;
 
-	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+	vlan_vid_add(dsa_port_to_master(dp), htons(ETH_P_8021Q), port);
 
 	return lan9303_enable_processing_port(chip, port);
 }
@@ -1103,7 +1103,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return;
 
-	vlan_vid_del(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+	vlan_vid_del(dsa_port_to_master(dp), htons(ETH_P_8021Q), port);
 
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 25dc3c3aa31d..5a1fc4bcd7a5 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -173,7 +173,7 @@ mtk_flow_get_dsa_port(struct net_device **dev)
 	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
 		return -ENODEV;
 
-	*dev = dp->cpu_dp->master;
+	*dev = dsa_port_to_master(dp);
 
 	return dp->index;
 #else
diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..23eac1bda843 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -718,6 +718,11 @@ static inline bool dsa_port_offloads_lag(struct dsa_port *dp,
 	return dsa_port_lag_dev_get(dp) == lag->dev;
 }
 
+static inline struct net_device *dsa_port_to_master(const struct dsa_port *dp)
+{
+	return dp->cpu_dp->master;
+}
+
 static inline
 struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 {
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ed56c7a554b8..f1f96e2e56aa 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1263,11 +1263,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
 	 * restriction, there needs to be another mutex which serializes this.
 	 */
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp) && (dp->master->flags & IFF_UP))
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (dsa_port_to_master(dp)->flags & IFF_UP)
 			goto out_unlock;
 
-		if (dsa_port_is_user(dp) && (dp->slave->flags & IFF_UP))
+		if (dp->slave->flags & IFF_UP)
 			goto out_unlock;
 	}
 
@@ -1797,7 +1797,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	rtnl_lock();
 
 	dsa_switch_for_each_user_port(dp, ds) {
-		master = dp->cpu_dp->master;
+		master = dsa_port_to_master(dp);
 		slave_dev = dp->slave;
 
 		netdev_upper_dev_unlink(master, slave_dev);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 614fbba8fe39..c48c5c8ba790 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -322,7 +322,7 @@ dsa_slave_to_master(const struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	return dp->cpu_dp->master;
+	return dsa_port_to_master(dp);
 }
 
 /* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 7afc35db0c29..4183e60db4f9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1026,7 +1026,7 @@ int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
 int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 				 const unsigned char *addr, u16 vid)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
@@ -1037,8 +1037,8 @@ int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 	 * requires rtnl_lock(), since we can't guarantee that is held here,
 	 * and we can't take it either.
 	 */
-	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
-		err = dev_uc_add(cpu_dp->master, addr);
+	if (master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_add(master, addr);
 		if (err)
 			return err;
 	}
@@ -1077,15 +1077,15 @@ int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
 int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
 				 const unsigned char *addr, u16 vid)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
 	int err;
 
-	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
-		err = dev_uc_del(cpu_dp->master, addr);
+	if (master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_del(master, addr);
 		if (err)
 			return err;
 	}
@@ -1208,14 +1208,14 @@ int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
 int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
 	int err;
 
-	err = dev_mc_add(cpu_dp->master, mdb->addr);
+	err = dev_mc_add(master, mdb->addr);
 	if (err)
 		return err;
 
@@ -1252,14 +1252,14 @@ int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
 int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
 	int err;
 
-	err = dev_mc_del(cpu_dp->master, mdb->addr);
+	err = dev_mc_del(master, mdb->addr);
 	if (err)
 		return err;
 
@@ -1294,19 +1294,19 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 			   const struct switchdev_obj_port_vlan *vlan,
 			   struct netlink_ext_ack *extack)
 {
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_notifier_vlan_info info = {
 		.dp = dp,
 		.vlan = vlan,
 		.extack = extack,
 	};
-	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+	vlan_vid_add(master, htons(ETH_P_8021Q), vlan->vid);
 
 	return err;
 }
@@ -1314,18 +1314,18 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 int dsa_port_host_vlan_del(struct dsa_port *dp,
 			   const struct switchdev_obj_port_vlan *vlan)
 {
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_notifier_vlan_info info = {
 		.dp = dp,
 		.vlan = vlan,
 	};
-	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+	vlan_vid_del(master, htons(ETH_P_8021Q), vlan->vid);
 
 	return err;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 345106b1ed78..55094b94a5ae 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1503,8 +1503,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 static int dsa_slave_setup_ft_block(struct dsa_switch *ds, int port,
 				    void *type_data)
 {
-	struct dsa_port *cpu_dp = dsa_to_port(ds, port)->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	struct net_device *master = dsa_port_to_master(dsa_to_port(ds, port));
 
 	if (!master->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
@@ -2147,13 +2146,14 @@ static int dsa_slave_fill_forward_path(struct net_device_path_ctx *ctx,
 				       struct net_device_path *path)
 {
 	struct dsa_port *dp = dsa_slave_to_port(ctx->dev);
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 
 	path->dev = ctx->dev;
 	path->type = DEV_PATH_DSA;
 	path->dsa.proto = cpu_dp->tag_ops->proto;
 	path->dsa.port = dp->index;
-	ctx->dev = cpu_dp->master;
+	ctx->dev = master;
 
 	return 0;
 }
@@ -2271,9 +2271,9 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 void dsa_slave_setup_tagger(struct net_device *slave)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave);
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_slave_priv *p = netdev_priv(slave);
 	const struct dsa_port *cpu_dp = dp->cpu_dp;
-	struct net_device *master = cpu_dp->master;
 	const struct dsa_switch *ds = dp->ds;
 
 	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
@@ -2330,8 +2330,7 @@ int dsa_slave_resume(struct net_device *slave_dev)
 
 int dsa_slave_create(struct dsa_port *port)
 {
-	const struct dsa_port *cpu_dp = port->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	struct net_device *master = dsa_port_to_master(port);
 	struct dsa_switch *ds = port->ds;
 	const char *name = port->name;
 	struct net_device *slave_dev;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b5f80bc45ceb..34e5ec5d3e23 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -330,7 +330,7 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return 0;
 
-	master = dp->cpu_dp->master;
+	master = dsa_port_to_master(dp);
 
 	err = dsa_port_tag_8021q_vlan_add(dp, vid, false);
 	if (err) {
@@ -359,7 +359,7 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return;
 
-	master = dp->cpu_dp->master;
+	master = dsa_port_to_master(dp);
 
 	dsa_port_tag_8021q_vlan_del(dp, vid, false);
 
-- 
2.34.1

