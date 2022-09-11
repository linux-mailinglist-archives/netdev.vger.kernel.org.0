Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454215B4B17
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiIKBIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIKBHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:07:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6C94CA37;
        Sat, 10 Sep 2022 18:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfCwASIIR9r+e1f5EsLHTqRlKlUJn9T9sRNRM6rOjuHqwhexxkDsgrXsRLLbadm0TBN01sk6kpeDrVo6kOuXBkRFupXZsEx+fScgKOF1QLojDenJMyWpJdYvFhfer3dThuT3WitawW2ibHwzfzNbxjVrMB89GKhjq/Pint6e1hAM54RdGwPB9rXx/AbmClb0aESTlNgFIljOWkDvNXwUTkt0iLXjbn++2iOwmuTytpwVcgx2jg2O5Xbn8YPM1dX2xJ1JMp7JSw6R+8jY+3kXjF1Am3cvW48cQuTr/4ZysFj6xdAkwY57ftrpbLAAML4pRH/aUjaWUjRsq4hFG7HKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ToQqEcglcqjmZ173SM51jH0ErDb9r/d6eyJ1qJ0rJ4=;
 b=hCcYoWTEkBe5TF5Dz4OaYDXx0YX5WO5AAN9PpXWFas4lK41fw7JjHuHOraIgIhnSY0RQkVoL2mHEQ9/2vs75MQHHM7KdSPQxex4texqhms5lDiHQ36iiw+7RdpC5fPgHMSUTQiJv31+ul8Xfuoo2N5v7hfB2gYDyNLS749JDLUVAkOevx6pqTq5q9tRqoNeXKeDN66edUWfQG7RhB428wsGDHzGbKJ9KIxfgajk88EuIB40Q4DCn9uSq3NqksiXxDo0A6Vrpv4tule0l4qRQFR0uiu1BPGKTAnxRlysU6refctWFJXuJvFPp3Cr6oUq9uMSg6ih5VY6xuugQkA0uxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ToQqEcglcqjmZ173SM51jH0ErDb9r/d6eyJ1qJ0rJ4=;
 b=SFdl+bPtnb9zylT3F07i22ydceuXZac86XCBE3haBkMOya5xOZixXWu40Sr1gWLe8UxOOHA0hUQN5CwDYD2GQAgEG5EwuaFaR2iWheYKVhPEXRGqow3amuKx1jfpQZyLaCnY+G44P9PXBqaZKjcRPLSEg4zDTmlhz/U9E2IeWFs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:50 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:50 +0000
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
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 02/10] net: dsa: introduce dsa_port_get_master()
Date:   Sun, 11 Sep 2022 04:06:58 +0300
Message-Id: <20220911010706.2137967-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c0c902-d9fc-40a7-7264-08da93920bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfLaEvtmyKW5uybUoNh5bSkb5l2VTidhvEdv6+qlVN30Fvc1Gf70FHIGJ/0JswZSKJNTqfFqmN2evUitatEeY2Spy+prTS29kEjTcwrwR2EV2emsO5LrcT9kbkyFgJec4K4s2JeVVWIrPkFNk3PvYtrGkFU/g+TYMSpHj5qoMVvpBWiWMH5MDryuhL/XciKhCXITlokd2Z/6gFcvhx9ySVnIoe6fKgm8mtEw6esyYQBB/JHT4i9a1kjUWVkbuA8WhfBgE3VgKNzYjb85gDv/lMz0RCQNQ1+WRjYUw1fgyAiCckD+5gIYrNCglMl46TvS93eOsIhg2kV1+lKyZ3FWFh+XrAO7JGzfC9brpmuHZxEFu7WMamoeiIRbp0j8UbKDInGTtJvkUfNGtyTWGRUBAfoXkf6U0NHITn77SJ0w/SrYlbByXn0LVYag+TRrNH8OTRrk/CRfzL/xVaXPli2G8Kjr14d6A5Izo4H4nrpUxCj5KpZVq44Ck82yaXBfuNa2hn22coQnRFpNlatc/FoB/DPb+ydEwpfAmrdhqrTCNRs0pBPpvILR9xS+ApnNKN4PZEAIfcTDyI89pANx2KY5peUvzaAWW2VG76AIUVrrew7zNsoObKW3cTFhp7rWKb3XfJM44ePZ6ZLveY9JRUaTqifiAGp/fu6fehi+jGszsJgmMGM/nRn8cXxuSfo1q/aOxHHspEP60jjpFlavqJJ86HGh70EI80WqPqWl9R7H/JOW1vmzQwwDXF6+UwJpN3QRm7h7SFrJsSYGXRu4VcGCHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(30864003)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mL3CVN5t6IH/r/OvTRZM0nAaAqdlJKsedbyy8AX3Dz8OajGeZXOcVi1J1q7V?=
 =?us-ascii?Q?m0SEM9HUBhJicw5Im4GRKxeg0pfr5bn0PgHB7g/EDRzB20C3KCwznY1xt5Zb?=
 =?us-ascii?Q?OJOE7YbAO9ckKklr5eHCBot3eAytHByOUIyKoizYgIHqHCp1Vt8IDJIFhr2n?=
 =?us-ascii?Q?0UnIt7AG9QYnHuVNKS7wGU4ZY5H9tQTaIjKUe3EgE5a6t1bL9PMdLYp+CLBX?=
 =?us-ascii?Q?NzjGmvg9Evg9mZ/b4E2lira7A0XFwDgBmV0RcUgkNZGnHxlmqbpeTQu/OmwQ?=
 =?us-ascii?Q?o0B6hXfSThDmWLK8y+BcaYoVa9wBue2nEWIS6w96qon3lHlZhQSjWoVe11vQ?=
 =?us-ascii?Q?LAHTkVk4ExKrdAF0Jc2yaICJExyTOob34XBkHEtf5y5J/9KLrQaQWiMwnW+V?=
 =?us-ascii?Q?NK86qY7rnmxZfMVGe21ZSzmjC+iENwAVpX+xxnBdOEkY7EovPMhEEkd5N1OB?=
 =?us-ascii?Q?bRyrw/8WU9tiTj65rlBQ0KNjDMxaDwkOf9VJmfnIza+pC7dR0Q+TqpN5zAOz?=
 =?us-ascii?Q?z1xftoYsj8+AU8zbRwRB6Kvg55MLuLTfieuAItg30D3SOMSLWajZumtCnLo4?=
 =?us-ascii?Q?UK8/MeBDUwNFIOYx+5+9g44JGFNx9kHf66bZRXBj4KqXMwhxzs1RCb25Md0U?=
 =?us-ascii?Q?MwwLQvooDcOw2F/VRyWpDLwFExL2A5z0o/t1yKkFv8mUREZGQk7bRb+nw4xF?=
 =?us-ascii?Q?rE7zmnDUk6E6vTJ8h0ZtsSHN3lR5PcD297/ie4IbrvA1q0qFxXa0wvqeiCz4?=
 =?us-ascii?Q?nmCeeTIyvRQfc4FR/P7oVo34sqB7RFoAwo1vlTkx8Hfu9QvWyEXz469/iGMe?=
 =?us-ascii?Q?F58QuWZWNZDiseW8STAlSsJtb2u0L6eH+ilJxWnllXsWojHyysIG5LVOMUta?=
 =?us-ascii?Q?VcgYku/IEG1ThkWX4UnH2BlsOXSI12hERlYePLtsP9Px0iE8oqlttC/vU5dY?=
 =?us-ascii?Q?gqqNHSBwFtWwPFc9IaA9Ed1cuIeZb6KDh+CruMR0W7pDef5xbtX/wGFyP6Rr?=
 =?us-ascii?Q?68s0WGNKGVI+HK4kea2PyjvOE/R4i0kdchqQCCQPdTxnmjTsfadnqiYMbNKS?=
 =?us-ascii?Q?nv5/xk8sZcXHtonnVYi2p0GY/pQ1lPpMyDrF4VzC5EPDRwVZJrE2YiI+TUwX?=
 =?us-ascii?Q?EQbITz7qTEtvtGiCDbS4YqE+FisTw5NI13NdaLQdgDjKcRMuIG0Aj+lBvN6d?=
 =?us-ascii?Q?Drx9yliamqFBb/FXNk0DkOM5PCkjMroLOgDAsaaHmk8QZICKVRaOSSXvky9T?=
 =?us-ascii?Q?Ek4CGEqYGoRQ+OrBqGDNLfytmi8NiemU/wnWEa+p1afjWG7TEnfvTxIVOf8Q?=
 =?us-ascii?Q?eZZ3JxJ1RS4gHwDQfY535t58jbNrwn3G6zw6svDl5oLUmWuvIX+z74bkzAQW?=
 =?us-ascii?Q?REbp6qQV6ngqQtqaTOemmVToPORw2rWCix4XKldzqQDb0+W/yVh4UFxmiKMm?=
 =?us-ascii?Q?cnY42TZnBi7Jy5ZkMMRv9PQmzWfXIQmUGWqXaL8l9zqW66++uszb+qY+XwFe?=
 =?us-ascii?Q?smRg+LAuf1g9Dkb3O3arDus9DrJCw1Rq4ewSJkH8oMn0amuyB4Iw6qIwjxNc?=
 =?us-ascii?Q?83mB85ANrooHShI6NLvNiPOYCHkjxUGE4muxQMUKjmKck8JIShde0vKfGO+y?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c0c902-d9fc-40a7-7264-08da93920bbc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:49.9316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odbVhXvKMucUS63d5fbNILktzkhtQQP9cP36UbZGTgpIYprLs+Ez2N3s/3hKGqu9bQsXdfl1aENSVnUW6p1r4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
v1->v2: none

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
index 22bc295bebdb..c4010b7bf089 100644
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
index 9e04541c3144..438e46af03e9 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1092,7 +1092,7 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
 	if (!dsa_port_is_user(dp))
 		return 0;
 
-	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+	vlan_vid_add(dsa_port_to_master(dp), htons(ETH_P_8021Q), port);
 
 	return lan9303_enable_processing_port(chip, port);
 }
@@ -1105,7 +1105,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
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
index 4bb0a203b85c..db34240bd0c5 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1273,11 +1273,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
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
 
@@ -1807,7 +1807,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
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

