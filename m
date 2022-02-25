Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BFD4C4152
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiBYJXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbiBYJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:43 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5726B1A904C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqWJm1Jkf/FRidEC9zdkK2FeJvVWUMj1gLM7CK/aFxFPS6Xy1QZjy3/E/XBfv3ALQ5zACC9vpQ4NfouWh61br8Nti7NXdbvMhJkljc2jq1VEVT78sQOXO2f5NA8YrdTqrXFptflx/OaoBffXDmbjnKXRCyqdlWDz14zDCsFqm/qbtz9u65m1N25O+3l8FqeAv+suNNi3o3Q3escgevTpJdzBDIuhWPXUU/7xTx0uCxo2dJRbLNI1nUE6xN4Q8FUVV2dNbnc6g1RsWa9uvcf2zEbesJZrxx6sFYEpFh6lGixOkShtUXVbJEYPlNCvoE45MPZH0Z3aXtj4UWus8JwYdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nsvHqsEiV8vldU03Knabg/vBn+KUjrijaXbHe8/7bc=;
 b=jpCqlElGaas4dO4nI9nou5oyraLz5z8JAWEzhKCnqvU9iz0DcsNe/jbnzJgTwS44UgAp2aEukuGHblt7/ZWmWddqB9kBP9kRRy+3bvUmJPBnCLcAYFpKXlxCsr3FKGsEBUX4qxl78yPC4Oo7g4lCY82phjuxsG6zAcU37VxJx10qLHPscVv1339MIOjKeAsPGnXlREHgzdd8BFGTJuQZQUispBB7zSa/NsUlHzQLc47NtopvJnnOakJms7v/wT5txTRUbD/4lj6kFbn3r+VaY05ezQ77yVq6pSv2OLUVx/ce5W9kw2DICqZiIAeMN8oQlPsT5xXwN3S8eQ9U9WnhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nsvHqsEiV8vldU03Knabg/vBn+KUjrijaXbHe8/7bc=;
 b=LfokulS26Tuw+h+3YzdMCOFguXhY4xWhyMpD/Ecw1wxG6W/HZnRZg5gfVJbKQhjWN64sxNHk1R2tcFHrIDU1n1MAmNqAh5rK/V3QI5qVUObKQvad7CeC+rb+YijValQeZwBYuUFh4iezBa2JGu6RDuP8ZIPqUbpta1soJNMMFQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:05 +0000
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
Subject: [PATCH v2 net-next 05/10] net: dsa: tag_8021q: merge RX and TX VLANs
Date:   Fri, 25 Feb 2022 11:22:20 +0200
Message-Id: <20220225092225.594851-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6e4d0348-6e78-463a-70b3-08d9f8406df7
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB765863DEAE00B027992E618DE03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cIwwT3PYj0xq2IxKCfXZ4UlAuoXfdCWMfMMTd0jv8IXpIq3bIycRxHPi2JHRhE2IZbmY5zQqJiT6JuE/6j6F9ALEolgPxMo29alIx9tZybmK0fJHedbh/DZwrgy7QjwFIypMpPNCdV2EEZw9to/2J8zTOc1n2pD5pKZJ5mSJepx4sse5hP4Qbm6VKEpwTu2M+nLMLH+fzKjVM/xRqwDSPWNnkBhczDGqMhepP/I4k2APq6Pr3tO1J18+lHiRJopGS/NPsESWgT+kdudE/M5OqzyeKya9l6WIO66X6Sfi+BB+qguEJveJWQitP0D18GDI7NirNdRLYBkLm+m2Hfn2Rytr48rLct998co+7CoUQJrX80ALDnHmlhEKLXLBSK67G594ZO9suX9uDUNGnremoveFRAcFmCZGnItnLKhJtWvF0ZGKcoqEBL3sb1O5HL0eKl25l45r/A5xj7CKRLECKhNjUPkKqb33KEirenPn+uePZ63HT69TGG07AGWvR116WjslGh4mttIZMFq25ZmBqodN30YZ04dfFahPyTZJdg9byqhsDKSpJ7RbcIz4UecATONo5EvK3V2axkzOxWiskVmuKFH1WAxiqygBzWu4YKC04LXXePbXY7I343MGC7I1HSwYYPl29/HpMDh4zawVHGyqrrL9UmUJpACesgeJ+KBJF3tZKOyfFCWRiJAJHeKN2BWAqMIIZWuClVnyPGxEyyc8qHdzlZp4S34L4Iqa+hM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(30864003)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005)(3714002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WcUUzwoR77LK1XDFf8ZZLdyB0FWngmmJ9nwG0IjkEzkISMkdPFJVviuBBT+u?=
 =?us-ascii?Q?C76Eq9b0L9xk4JfXa6enYu/pJu3XWuAJ7P/keWGWdJlVg/tHwW4LNgp4W8cV?=
 =?us-ascii?Q?sim2Pr4uvFimNhIsYaWx0Ai9Y6Wxjo404GIHuBGobiaV3uTXCaPhhm/Wx1te?=
 =?us-ascii?Q?gsDSqTSXbX1u8/tiVca1lSOwNbTP1YZaZpZA2WyQVXJMl04K1ICGzebfIyhX?=
 =?us-ascii?Q?3tFhcsr/9A63KPNUbZm0iCAHzgnOAlfeGs5E8zhpq/eusp5wXN3eoUv+HdjE?=
 =?us-ascii?Q?MIAS9XieS1Wpv0LxHa6CA6L5+f4eAFQUefkhSypYs3EvUL3mc8u/NGFiRE2N?=
 =?us-ascii?Q?pJbYaConxNto3Ddn+akDH3oIjUD9JGooP3/ZOJcDXyfpFH/Jq5360ve1iEO4?=
 =?us-ascii?Q?iE759J/OnT0tEp7qMTe3DTk2ZUF0NAqgZJz+ckxBD1Ef3dI5WUOKCUTi1V5/?=
 =?us-ascii?Q?Dc5zsbYs6mG6zmDpqH83mXbB6c5dBC47cUMvHxJRX2OO3aQB36e+KPxkNGwr?=
 =?us-ascii?Q?474h3LrRM3UepUL4w92Gm4l3ZzWIo3sBk0nDZTskKpgzCgtWmBEbuHtHPxQZ?=
 =?us-ascii?Q?iCtnC+Geva+XifEmq4JbzeSxDmuhp44SPqXvO4hLmq0GaqJFEu5TMw4iKh1D?=
 =?us-ascii?Q?dvB7Ol0zLkQWy34kfrT1PYCSeH2+pFk2fY/gI2oGemunl8VEMLY10nl8HLnn?=
 =?us-ascii?Q?K3iCq9VfT+GGVL5eW0mFUVnhfwQXAtVh1PPoziPA6qJJKlBrNskGxYWB940g?=
 =?us-ascii?Q?iSmXRgnrg+lHex/3iwTOYlTwLwBAEfLlS9AV4TF2iJ9WZXMm15bgSaG7RSEE?=
 =?us-ascii?Q?YMO0GJZZ5hk8J4Ch14C8JHLRgX3h6lsjm+HzkgzecACLBnU+6F69kp9oN+es?=
 =?us-ascii?Q?e8uHkL1RwldOMgE35yNQK0ZOj7VG1+ULlLZMgw4qPxs3IgCOXRc4wDNwJQ0F?=
 =?us-ascii?Q?z9Nd6T6tkaiNZ7jWYZzSZ4/ijyxubyewMmW7SltPItqpq8mfY48eR9iJx66Y?=
 =?us-ascii?Q?27QLp5omIiZOsdPmFJnp7ziIJ3uMyB07mQmT61RBSOMxUyIn6zRJgbAZ9v1j?=
 =?us-ascii?Q?hAx/U+VsfZJ1ljvnUZKIWmapCh6oKSsuZ+Xhmgfw4P9ZbXDxnr5P3dY6f1te?=
 =?us-ascii?Q?EEbfBJTJci3/eYE5dlAhJIPI2NfruTt7qHJYEJpjNQD9GcU0Sfd8OYSAIuPI?=
 =?us-ascii?Q?rSVF8b+CPwcojSdJkRyXTgxm8GA6IYDhFUXZlEgbNqbWmxM+josPWp/KZhwW?=
 =?us-ascii?Q?9F/kxKipToKDjxG0FsYpHlM2P1yXKWpCdmUm/0wmuxm88uQRnjqm/tk7XZLX?=
 =?us-ascii?Q?lJLLbULreS5lIqYhJawYH9bMZOJou21xSW2zv2eSp1az9I00KOXc4XGFkKZk?=
 =?us-ascii?Q?jtvHMl94bYwpuN/ILiPZqJHQK8zocoKVS5DYIqeusPvUaprt2vjsZGfm/Rrh?=
 =?us-ascii?Q?OXaDbeHlXVS8tEwvC/5RmCB8M/uKUShdZecEaAr31p6FXmyJZ/maSyBYPFCs?=
 =?us-ascii?Q?FwYb3HwkU7uZmbXrj8ZqX6OhM2mUVRIO1eF4x2e0mQ9PTOOYA4Dlh5goKib2?=
 =?us-ascii?Q?RXWt+9ILPabO2iqCt1A8r4QFXSHfpC1M60C9hUyXFaVd4AepXotSaL47yOs+?=
 =?us-ascii?Q?9voT0VVgH+khs2yNQsxZGzI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4d0348-6e78-463a-70b3-08d9f8406df7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:05.8195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNNoVGnn+TQiq2s53uKvne+wycHC0kA+ibJznKpxGNw6hhSDeatnfpvdnqXrfqFrIcXhi0jHNDBr9+osjIgkSw==
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

In the old Shared VLAN Learning mode of operation that tag_8021q
previously used for forwarding, we needed to have distinct concepts for
an RX and a TX VLAN.

An RX VLAN could be installed on all ports that were members of a given
bridge, so that autonomous forwarding could still work, while a TX VLAN
was dedicated for precise packet steering, so it just contained the CPU
port and one egress port.

Now that tag_8021q uses Independent VLAN Learning and imprecise RX/TX
all over, those lines have been blurred and we no longer have the need
to do precise TX towards a port that is in a bridge. As for standalone
ports, it is fine to use the same VLAN ID for both RX and TX.

This patch changes the tag_8021q format by shifting the VLAN range it
reserves, and halving it. Previously, our DIR bits were encoding the
VLAN direction (RX/TX) and were set to either 1 or 2. This meant that
tag_8021q reserved 2K VLANs, or 50% of the available range.

Change the DIR bits to a hardcoded value of 3 now, which makes tag_8021q
reserve only 1K VLANs, and a different range now (the last 1K). This is
done so that we leave the old format in place in case we need to return
to it.

In terms of code, the vid_is_dsa_8021q_rxvlan and vid_is_dsa_8021q_txvlan
functions go away. Any vid_is_dsa_8021q is both a TX and an RX VLAN, and
they are no longer distinct. For example, felix which did different
things for different VLAN types, now needs to handle the RX and the TX
logic for the same VLAN.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 120 ++++++++++--------
 drivers/net/dsa/sja1105/sja1105_main.c |   2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c   |   3 +-
 include/linux/dsa/8021q.h              |   8 +-
 net/dsa/tag_8021q.c                    | 169 +++++++------------------
 net/dsa/tag_ocelot_8021q.c             |   2 +-
 net/dsa/tag_sja1105.c                  |   4 +-
 7 files changed, 115 insertions(+), 193 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 39ff5d201262..04f5da33b944 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -25,8 +25,10 @@
 #include <net/dsa.h>
 #include "felix.h"
 
-static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
-				      bool pvid, bool untagged)
+/* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
+ * the tagger can perform RX source port identification.
+ */
+static int felix_tag_8021q_vlan_add_rx(struct felix *felix, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *outer_tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
@@ -64,21 +66,32 @@ static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
 	return err;
 }
 
-static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
-				      bool pvid, bool untagged)
+static int felix_tag_8021q_vlan_del_rx(struct felix *felix, int port, u16 vid)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot_vcap_block *block_vcap_es0;
+	struct ocelot *ocelot = &felix->ocelot;
+
+	block_vcap_es0 = &ocelot->block[VCAP_ES0];
+
+	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
+								 port, false);
+	if (!outer_tagging_rule)
+		return -ENOENT;
+
+	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
+}
+
+/* Set up VCAP IS1 rules for stripping the tag_8021q VLAN on TX and VCAP IS2
+ * rules for steering those tagged packets towards the correct destination port
+ */
+static int felix_tag_8021q_vlan_add_tx(struct felix *felix, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
 	struct ocelot *ocelot = &felix->ocelot;
 	struct dsa_switch *ds = felix->ds;
 	int upstream, err;
 
-	/* tag_8021q.c assumes we are implementing this via port VLAN
-	 * membership, which we aren't. So we don't need to add any VCAP filter
-	 * for the CPU port.
-	 */
-	if (ocelot->ports[port]->is_dsa_8021q_cpu)
-		return 0;
-
 	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!untagging_rule)
 		return -ENOMEM;
@@ -135,41 +148,7 @@ static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
 	return 0;
 }
 
-static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
-				    u16 flags)
-{
-	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
-	struct ocelot *ocelot = ds->priv;
-
-	if (vid_is_dsa_8021q_rxvlan(vid))
-		return felix_tag_8021q_rxvlan_add(ocelot_to_felix(ocelot),
-						  port, vid, pvid, untagged);
-
-	if (vid_is_dsa_8021q_txvlan(vid))
-		return felix_tag_8021q_txvlan_add(ocelot_to_felix(ocelot),
-						  port, vid, pvid, untagged);
-
-	return 0;
-}
-
-static int felix_tag_8021q_rxvlan_del(struct felix *felix, int port, u16 vid)
-{
-	struct ocelot_vcap_filter *outer_tagging_rule;
-	struct ocelot_vcap_block *block_vcap_es0;
-	struct ocelot *ocelot = &felix->ocelot;
-
-	block_vcap_es0 = &ocelot->block[VCAP_ES0];
-
-	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
-								 port, false);
-	if (!outer_tagging_rule)
-		return -ENOENT;
-
-	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
-}
-
-static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
+static int felix_tag_8021q_vlan_del_tx(struct felix *felix, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
 	struct ocelot_vcap_block *block_vcap_is1;
@@ -177,9 +156,6 @@ static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
 	struct ocelot *ocelot = &felix->ocelot;
 	int err;
 
-	if (ocelot->ports[port]->is_dsa_8021q_cpu)
-		return 0;
-
 	block_vcap_is1 = &ocelot->block[VCAP_IS1];
 	block_vcap_is2 = &ocelot->block[VCAP_IS2];
 
@@ -195,22 +171,54 @@ static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
 	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
 							    port, false);
 	if (!redirect_rule)
-		return 0;
+		return -ENOENT;
 
 	return ocelot_vcap_filter_del(ocelot, redirect_rule);
 }
 
+static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				    u16 flags)
+{
+	struct ocelot *ocelot = ds->priv;
+	int err;
+
+	/* tag_8021q.c assumes we are implementing this via port VLAN
+	 * membership, which we aren't. So we don't need to add any VCAP filter
+	 * for the CPU port.
+	 */
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	err = felix_tag_8021q_vlan_add_rx(ocelot_to_felix(ocelot), port, vid);
+	if (err)
+		return err;
+
+	err = felix_tag_8021q_vlan_add_tx(ocelot_to_felix(ocelot), port, vid);
+	if (err) {
+		felix_tag_8021q_vlan_del_rx(ocelot_to_felix(ocelot), port, vid);
+		return err;
+	}
+
+	return 0;
+}
+
 static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 {
 	struct ocelot *ocelot = ds->priv;
+	int err;
+
+	if (!dsa_is_user_port(ds, port))
+		return 0;
 
-	if (vid_is_dsa_8021q_rxvlan(vid))
-		return felix_tag_8021q_rxvlan_del(ocelot_to_felix(ocelot),
-						  port, vid);
+	err = felix_tag_8021q_vlan_del_rx(ocelot_to_felix(ocelot), port, vid);
+	if (err)
+		return err;
 
-	if (vid_is_dsa_8021q_txvlan(vid))
-		return felix_tag_8021q_txvlan_del(ocelot_to_felix(ocelot),
-						  port, vid);
+	err = felix_tag_8021q_vlan_del_tx(ocelot_to_felix(ocelot), port, vid);
+	if (err) {
+		felix_tag_8021q_vlan_add_rx(ocelot_to_felix(ocelot), port, vid);
+		return err;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1e43a7ef0f2e..dd89b077aae6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2525,7 +2525,7 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 	 */
 	if (vid_is_dsa_8021q(vlan->vid)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Range 1024-3071 reserved for dsa_8021q operation");
+				   "Range 3072-4095 reserved for dsa_8021q operation");
 		return -EBUSY;
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 14e6dd7fb103..1eef60207c6b 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -302,7 +302,7 @@ static u16 sja1105_port_get_tag_8021q_vid(struct dsa_port *dp)
 	unsigned long bridge_num;
 
 	if (!dp->bridge)
-		return dsa_tag_8021q_rx_vid(dp);
+		return dsa_tag_8021q_standalone_vid(dp);
 
 	bridge_num = dsa_port_bridge_num_get(dp);
 
@@ -407,6 +407,7 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				vl_lookup[k].vlanid = rule->key.vl.vid;
 				vl_lookup[k].vlanprior = rule->key.vl.pcp;
 			} else {
+				/* FIXME */
 				struct dsa_port *dp = dsa_to_port(priv->ds, port);
 				u16 vid = sja1105_port_get_tag_8021q_vid(dp);
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 92f5243b841e..b4e2862633f6 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -49,18 +49,12 @@ struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
-u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp);
-
-u16 dsa_tag_8021q_rx_vid(const struct dsa_port *dp);
+u16 dsa_tag_8021q_standalone_vid(const struct dsa_port *dp);
 
 int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
-bool vid_is_dsa_8021q_rxvlan(u16 vid);
-
-bool vid_is_dsa_8021q_txvlan(u16 vid);
-
 bool vid_is_dsa_8021q(u16 vid);
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 1cf245a6f18e..eac43f5b4e07 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -16,15 +16,11 @@
  *
  * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
  * +-----------+-----+-----------------+-----------+-----------------------+
- * |    DIR    | VBID|    SWITCH_ID    |   VBID    |          PORT         |
+ * |    RSV    | VBID|    SWITCH_ID    |   VBID    |          PORT         |
  * +-----------+-----+-----------------+-----------+-----------------------+
  *
- * DIR - VID[11:10]:
- *	Direction flags.
- *	* 1 (0b01) for RX VLAN,
- *	* 2 (0b10) for TX VLAN.
- *	These values make the special VIDs of 0, 1 and 4095 to be left
- *	unused by this coding scheme.
+ * RSV - VID[11:10]:
+ *	Reserved. Must be set to 3 (0b11).
  *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and 7.
@@ -38,12 +34,11 @@
  *	Index of switch port. Must be between 0 and 15.
  */
 
-#define DSA_8021Q_DIR_SHIFT		10
-#define DSA_8021Q_DIR_MASK		GENMASK(11, 10)
-#define DSA_8021Q_DIR(x)		(((x) << DSA_8021Q_DIR_SHIFT) & \
-						 DSA_8021Q_DIR_MASK)
-#define DSA_8021Q_DIR_RX		DSA_8021Q_DIR(1)
-#define DSA_8021Q_DIR_TX		DSA_8021Q_DIR(2)
+#define DSA_8021Q_RSV_VAL		3
+#define DSA_8021Q_RSV_SHIFT		10
+#define DSA_8021Q_RSV_MASK		GENMASK(11, 10)
+#define DSA_8021Q_RSV			((DSA_8021Q_RSV_VAL << DSA_8021Q_RSV_SHIFT) & \
+							       DSA_8021Q_RSV_MASK)
 
 #define DSA_8021Q_SWITCH_ID_SHIFT	6
 #define DSA_8021Q_SWITCH_ID_MASK	GENMASK(8, 6)
@@ -72,29 +67,19 @@ u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num)
 	/* The VBID value of 0 is reserved for precise TX, but it is also
 	 * reserved/invalid for the bridge_num, so all is well.
 	 */
-	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num);
+	return DSA_8021Q_RSV | DSA_8021Q_VBID(bridge_num);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
 
-/* Returns the VID to be inserted into the frame from xmit for switch steering
- * instructions on egress. Encodes switch ID and port ID.
- */
-u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp)
-{
-	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(dp->ds->index) |
-	       DSA_8021Q_PORT(dp->index);
-}
-EXPORT_SYMBOL_GPL(dsa_tag_8021q_tx_vid);
-
 /* Returns the VID that will be installed as pvid for this switch port, sent as
  * tagged egress towards the CPU port and decoded by the rcv function.
  */
-u16 dsa_tag_8021q_rx_vid(const struct dsa_port *dp)
+u16 dsa_tag_8021q_standalone_vid(const struct dsa_port *dp)
 {
-	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(dp->ds->index) |
+	return DSA_8021Q_RSV | DSA_8021Q_SWITCH_ID(dp->ds->index) |
 	       DSA_8021Q_PORT(dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_tag_8021q_rx_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_standalone_vid);
 
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
@@ -119,21 +104,11 @@ static int dsa_tag_8021q_rx_vbid(u16 vid)
 	return (vbid_hi << 2) | vbid_lo;
 }
 
-bool vid_is_dsa_8021q_rxvlan(u16 vid)
-{
-	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
-}
-EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
-
-bool vid_is_dsa_8021q_txvlan(u16 vid)
-{
-	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
-}
-EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
-
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
+	u16 rsv = (vid & DSA_8021Q_RSV_MASK) >> DSA_8021Q_RSV_SHIFT;
+
+	return rsv == DSA_8021Q_RSV_VAL;
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
@@ -251,18 +226,8 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 			u16 flags = 0;
 
 			if (dsa_port_is_user(dp))
-				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
-
-			/* Standalone VLANs are PVIDs */
-			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
-			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
-			    dsa_8021q_rx_source_port(info->vid) == dp->index)
-				flags |= BRIDGE_VLAN_INFO_PVID;
-
-			/* And bridging VLANs are PVIDs too on user ports */
-			if (dsa_tag_8021q_rx_vbid(info->vid) &&
-			    dsa_port_is_user(dp))
-				flags |= BRIDGE_VLAN_INFO_PVID;
+				flags |= BRIDGE_VLAN_INFO_UNTAGGED |
+					 BRIDGE_VLAN_INFO_PVID;
 
 			err = dsa_port_do_tag_8021q_vlan_add(dp, info->vid,
 							     flags);
@@ -294,52 +259,24 @@ int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
 	return 0;
 }
 
-/* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
- * front-panel switch port (here swp0).
+/* There are 2 ways of offloading tag_8021q VLANs.
  *
- * Port identification through VLAN (802.1Q) tags has different requirements
- * for it to work effectively:
- *  - On RX (ingress from network): each front-panel port must have a pvid
- *    that uniquely identifies it, and the egress of this pvid must be tagged
- *    towards the CPU port, so that software can recover the source port based
- *    on the VID in the frame. But this would only work for standalone ports;
- *    if bridged, this VLAN setup would break autonomous forwarding and would
- *    force all switched traffic to pass through the CPU. So we must also make
- *    the other front-panel ports members of this VID we're adding, albeit
- *    we're not making it their PVID (they'll still have their own).
- *  - On TX (ingress from CPU and towards network) we are faced with a problem.
- *    If we were to tag traffic (from within DSA) with the port's pvid, all
- *    would be well, assuming the switch ports were standalone. Frames would
- *    have no choice but to be directed towards the correct front-panel port.
- *    But because we also want the RX VLAN to not break bridging, then
- *    inevitably that means that we have to give them a choice (of what
- *    front-panel port to go out on), and therefore we cannot steer traffic
- *    based on the RX VID. So what we do is simply install one more VID on the
- *    front-panel and CPU ports, and profit off of the fact that steering will
- *    work just by virtue of the fact that there is only one other port that's
- *    a member of the VID we're tagging the traffic with - the desired one.
+ * One is to use a hardware TCAM to push the port's standalone VLAN into the
+ * frame when forwarding it to the CPU, as an egress modification rule on the
+ * CPU port. This is preferable because it has no side effects for the
+ * autonomous forwarding path, and accomplishes tag_8021q's primary goal of
+ * identifying the source port of each packet based on VLAN ID.
  *
- * So at the end, each front-panel port will have one RX VID (also the PVID),
- * the RX VID of all other front-panel ports that are in the same bridge, and
- * one TX VID. Whereas the CPU port will have the RX and TX VIDs of all
- * front-panel ports, and on top of that, is also tagged-input and
- * tagged-output (VLAN trunk).
+ * The other is to commit the tag_8021q VLAN as a PVID to the VLAN table, and
+ * to configure the port as VLAN-unaware. This is less preferable because
+ * unique source port identification can only be done for standalone ports;
+ * under a VLAN-unaware bridge, all ports share the same tag_8021q VLAN as
+ * PVID, and under a VLAN-aware bridge, packets received by software will not
+ * have tag_8021q VLANs appended, just bridge VLANs.
  *
- *               CPU port                               CPU port
- * +-------------+-----+-------------+    +-------------+-----+-------------+
- * |  RX VID     |     |             |    |  TX VID     |     |             |
- * |  of swp0    |     |             |    |  of swp0    |     |             |
- * |             +-----+             |    |             +-----+             |
- * |                ^ T              |    |                | Tagged         |
- * |                |                |    |                | ingress        |
- * |    +-------+---+---+-------+    |    |    +-----------+                |
- * |    |       |       |       |    |    |    | Untagged                   |
- * |    |     U v     U v     U v    |    |    v egress                     |
- * | +-----+ +-----+ +-----+ +-----+ |    | +-----+ +-----+ +-----+ +-----+ |
- * | |     | |     | |     | |     | |    | |     | |     | |     | |     | |
- * | |PVID | |     | |     | |     | |    | |     | |     | |     | |     | |
- * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
- *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
+ * For tag_8021q implementations of the second type, this method is used to
+ * replace the standalone tag_8021q VLAN of a port with the tag_8021q VLAN to
+ * be used for VLAN-unaware bridging.
  */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
 			      struct dsa_bridge bridge)
@@ -351,7 +288,7 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
 	/* Delete the standalone VLAN of the port and replace it with a
 	 * bridging VLAN
 	 */
-	standalone_vid = dsa_tag_8021q_rx_vid(dp);
+	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
 	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
 	err = dsa_port_tag_8021q_vlan_add(dp, bridge_vid, true);
@@ -374,7 +311,7 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 	/* Delete the bridging VLAN of the port and replace it with a
 	 * standalone VLAN
 	 */
-	standalone_vid = dsa_tag_8021q_rx_vid(dp);
+	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
 	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
 	err = dsa_port_tag_8021q_vlan_add(dp, standalone_vid, false);
@@ -388,13 +325,12 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_leave);
 
-/* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
+/* Set up a port's standalone tag_8021q VLAN */
 static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
-	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
+	u16 vid = dsa_tag_8021q_standalone_vid(dp);
 	struct net_device *master;
 	int err;
 
@@ -406,30 +342,16 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 
 	master = dp->cpu_dp->master;
 
-	/* Add this user port's RX VID to the membership list of all others
-	 * (including itself). This is so that bridging will not be hindered.
-	 * L2 forwarding rules still take precedence when there are no VLAN
-	 * restrictions, so there are no concerns about leaking traffic.
-	 */
-	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid, false);
+	err = dsa_port_tag_8021q_vlan_add(dp, vid, false);
 	if (err) {
 		dev_err(ds->dev,
-			"Failed to apply RX VID %d to port %d: %pe\n",
-			rx_vid, port, ERR_PTR(err));
+			"Failed to apply standalone VID %d to port %d: %pe\n",
+			vid, port, ERR_PTR(err));
 		return err;
 	}
 
-	/* Add @rx_vid to the master's RX filter. */
-	vlan_vid_add(master, ctx->proto, rx_vid);
-
-	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid, false);
-	if (err) {
-		dev_err(ds->dev,
-			"Failed to apply TX VID %d on port %d: %pe\n",
-			tx_vid, port, ERR_PTR(err));
-		return err;
-	}
+	/* Add the VLAN to the master's RX filter. */
+	vlan_vid_add(master, ctx->proto, vid);
 
 	return err;
 }
@@ -438,8 +360,7 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
-	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
+	u16 vid = dsa_tag_8021q_standalone_vid(dp);
 	struct net_device *master;
 
 	/* The CPU port is implicitly configured by
@@ -450,11 +371,9 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 
 	master = dp->cpu_dp->master;
 
-	dsa_port_tag_8021q_vlan_del(dp, rx_vid, false);
-
-	vlan_vid_del(master, ctx->proto, rx_vid);
+	dsa_port_tag_8021q_vlan_del(dp, vid, false);
 
-	dsa_port_tag_8021q_vlan_del(dp, tx_vid, false);
+	vlan_vid_del(master, ctx->proto, vid);
 }
 
 static int dsa_tag_8021q_setup(struct dsa_switch *ds)
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 1144a87ad0db..37ccf00404ea 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -62,7 +62,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_standalone_vid(dp);
 	struct ethhdr *hdr = eth_hdr(skb);
 
 	if (ocelot_ptp_rew_op(skb) || is_link_local_ether_addr(hdr->h_dest))
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 9c5c00980b06..f3832ac54098 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -267,7 +267,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_standalone_vid(dp);
 
 	if (skb->offload_fwd_mark)
 		return sja1105_imprecise_xmit(skb, netdev);
@@ -295,7 +295,7 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_standalone_vid(dp);
 	__be32 *tx_trailer;
 	__be16 *tx_header;
 	int trailer_pos;
-- 
2.25.1

