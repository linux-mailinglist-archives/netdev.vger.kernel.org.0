Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08E23D6508
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbhGZQTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:11 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:5443
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241839AbhGZQQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz0rSEEHqkKqY9/JeNnyvbD7BJig4JvinlyuODIVkg0VKqUhZVr17Pxsbp3Vbb3GtcD02lajOjdncHC4j6BgUEz6xEhsl0ieQqZGmoaoBURE7jOhFPgQBRTv/cJkk62eoc7gJxH4/ImPXrHXvCKa9bPrQgHdFcQtMayyiG9pbs+GLSg2wxRi7pq6LcwbNbSqNBre582Jh9x1Fasy4AqbeGHaxq+cCDkNdz/PbNje3rjHx5m4jZrsAFBBlZkXp+uWB6e+/sW87rgAmtPfJPNDM040dC0IfkksNlRzaQGM3m0wjNACDmNigxL9pcRwkYL75wvGwjlWmTp3rq26pGuFKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W908ID6VPihQTTGjLs9BiIidyZIXlXubCXtsHgpdGoE=;
 b=bUxl3z3DQ2GRpkg05WQM6Xb+JddqyQ+Q/DXeRgw/zuQyeXlYpTK3dI/uek1IJ43Ty+XkDbohO+nmdfpFKQf+UFXwkZP+W2qyYbiGeZToe3mZrDM/6rzz3BlH6tiA8rdBmoSrrZbVEp1//tv5P4LFGrApZDdoSt7kFwsIOlwSGoFhSrQoSVbkMDduqIMsVUWt4luiV7Q1C5lKuHM5raMAbunjzHBOKmpytpR6pdicHfPkupfbg/3NdjM0MPh47W3/QIGd/Sxmdu2W93bXhoBibfbG7X4/4gmePcBE+iTK55LyPHjP4WNRLBJx9IHsWP17g4jF2UHB0/f9LG2u4huObw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W908ID6VPihQTTGjLs9BiIidyZIXlXubCXtsHgpdGoE=;
 b=LUQhDLNQqcap/QfyqvDNx16UOjDAMg4MZNLMu8FzOKHIg1j0FCN/uMAT/bJLkVZxLmwsc1hJ8Hs9QGZrOpIRkdTMygaMqRA6OftoppV9RFIRdMpnFjTSYtPVT/3zYF8+MDEts7/jCdjQgkSB3Zo+CWTm5GhgaPcpEmKTZygklZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 4/9] net: dsa: sja1105: delete vlan delta save/restore logic
Date:   Mon, 26 Jul 2021 19:55:31 +0300
Message-Id: <20210726165536.1338471-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f1d1e8a-0714-4674-be78-08d950564063
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328D961904BF850BA13A707E0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3VweJ7Wu3XNwNEMPcy5oIa1VUcd/54D5qo55DHfn+etr6RZyuBAVU0KWvfvb+v9TS/tUwPmKaImmY+tIAAy9xmQ9ozCpeiCtcKCo0qTCPVyFNX9rJqFzblFYI4QzbPIsELm8A75aCzTEiLsaXIPSrePGeOVZgCXC9Tzbdsk/xCOw7yV2k6yOk39Km1rEUrupbKOHoXi3OsjGPXDAhHQx+sNcrfX6q8B//Ck/DQyXcre9VbFaP+4x93n1WbGOC6phIvJ5NklWNZo2rgaoU7TucKbFT4WP45SK/3LKwVx9uxK0NVwphfrxf04gsegkZzAbLcoX0XtY+papuwUl3musv8Fvit3B7lI3HqK0ntCs3iXCdVnfUG6bSn+Qe8usR2ZKpVCKnpEEX4xzp4ds4/+Ma8ceG7yTNJ2svIRHtxwveXau43dmvb9tXxrk6/0zsrPAbPaEW1UOTzeskEBuVnFUHB1+85XRHtHMpi1yVNUqFR0exxtADoH7f6jZhJieeQx7xLo9u8JfonUbiDgPwTTDwFZGXJJMTKLDkLJ24+XeeRkQzXm+FLeJjPaq7I+5Hy6w1qp1SANRPT8o7Eh99eA/OZRZeBsD0netkjMXxLgfmrouRZ8N5elZcMjrSmKzNO7qWf5yYhoNrcCr8OyOiwdb2zn6xnKU4sj2ztc+R10YlXwwS6fHjEKS3e50jatHI6OZvimn6KHdhnYqTm/BSGmGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(30864003)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?er5Bsyzosz590hzx6GZ8hKyOOZSlRTlkbGFDurw+dqD+jAakg5Qv50/2nF3B?=
 =?us-ascii?Q?0bKh/Ji9kmLneGXp8BtvQCGO9+Ik0Bj2gHfFXw3nQ0KmLeo02OMRtWZP6DJV?=
 =?us-ascii?Q?1J4O1OPVM0FxmR45nFdRWOcUxfxW0iZrgyvKHc1+BjpQ0p/6WwRNUwJotlm5?=
 =?us-ascii?Q?5Uo69DdsJLENECLfJjYTTsyq11omTftHuZbL7hzH66OR03NxtNx+s8h5WsOd?=
 =?us-ascii?Q?pcP1XWd6fnhhtOrRd8CKoy8McQUMTjtfygQsM/6r/IdqDq6PPYVY/MGuIQG0?=
 =?us-ascii?Q?uUUdnxPXP9r27su4CpJ6yP09upaabNAS4qXzLBiDKskilvf5GVYRVh4PCZU5?=
 =?us-ascii?Q?3W4d/SDrzRvi1nEzmVDRXrp5tvagIsKNqOvOxaZ1fMnOoCXNgbqtAA3ZAkZk?=
 =?us-ascii?Q?Xzx37FyMDb8/eyAgeHKl+j6F05vwpWMxkfNY4o/CD73q51f/7COoNnJpLH9H?=
 =?us-ascii?Q?JNnbccwHmIGDKrPS7MOZMz9jRsOk4So7l2TQaSsRao9c+b74BYW15/eB22+Y?=
 =?us-ascii?Q?V27FpgIHNhagDKXsPdn26853/dvCwAUW6BoNne9/mtv7UdyTBO4yaGqtvDLx?=
 =?us-ascii?Q?gaZOqQbmwQRW2iah1OjIF+S2W1CphT5LmKMXGNpZYG+vgxt4KFu5m55Z14om?=
 =?us-ascii?Q?0Og4JKgGauFhv7JZNX0MupcVQOMInuOPXn4TIglhLZ9XdaeHG9/g3pi7VtGF?=
 =?us-ascii?Q?klT8AqFWFcLzt64yZ3nhYYUo4GGxkzf0dmx0vDFFrCdRu9qKAbORoktnq7lN?=
 =?us-ascii?Q?S0qRJwBWOJFibkJY1CpNX40JuAGBEeChr7jtrR3NVFliVKQLz0qmURvi++ZV?=
 =?us-ascii?Q?8nwMnv2YA1PY0XAxSjBVSTu59wGDD7Ix/kazuFjpnN+CwnEfHPC3VEBnujpy?=
 =?us-ascii?Q?8+zIJD7pgqbv8AZiI3oKxgYb/J7n+SWwlBXiKLNnxDAhhHIsViu+ObOF+h9F?=
 =?us-ascii?Q?d2aBgXaqA9lj3aNkQnUo5csm8UJYrrcWwH7voRz+dHqvdb2PN9dHb7OJDWk3?=
 =?us-ascii?Q?3pL3JcffTzVVa+o2Uorhiq1PkFb97sRsXNyj/IXa4lM2dleQzYISHWdiBn32?=
 =?us-ascii?Q?SIJjXEhZSZzLc+0rdGfYHp0NfT3Di4+GJ9kSmEiLpq7f1Hl33tpq9xN2mAWo?=
 =?us-ascii?Q?Dgr+z3yeM2OaaXXAZF7Z6aorMApJddZHPh8nR32DRwBKEEUTfylWgx4zbmOn?=
 =?us-ascii?Q?bCcgesLJNcO2txi6XdeX9wgmRqdAJgyyRPtdzmTWlIyPfI5irrt/FO6LLZgy?=
 =?us-ascii?Q?7tafGpGK3sM5HUoYwYGLZFy4/RSMCoe0vX/jkRB3qjbPmAZWdC8g4KcmKNlQ?=
 =?us-ascii?Q?HLVFvB6kvnIE8WKbtsnonjMS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1d1e8a-0714-4674-be78-08d950564063
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:02.9242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Upmz0pY6uMfuVAhIHH1PY/8GbsJ7Yj1tE7mURHnvoyrejI505FvJiGAQKBvdrw3LiioC7wVsYHwCs0XYK4lXAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the best_effort_vlan_filtering mode now gone, the driver does not
have 3 operating modes anymore (VLAN-unaware, VLAN-aware and best effort),
but only 2.

The idea is that we will gain support for network stack I/O through a
VLAN-aware bridge, using the data plane offload framework (imprecise RX,
imprecise TX). So the VLAN-aware use case will be more functional.

But standalone ports that are part of the same switch when some other
ports are under a VLAN-aware bridge should work too. Termination on
those should work through the tag_8021q RX VLAN and TX VLAN.

This was not possible using the old logic, because:
- in VLAN-unaware mode, only the tag_8021q VLANs were committed to hw
- in VLAN-aware mode, only the bridge VLANs were committed to hw
- in best-effort VLAN mode, both the tag_8021q and bridge VLANs were
  committed to hw

The strategy for the new VLAN-aware mode is to allow the bridge and the
tag_8021q VLANs to coexist in the VLAN table at the same time.

[ yes, we need to make sure that the bridge cannot install a tag_8021q
  VLAN, but ]

This means that the save/restore logic introduced by commit ec5ae61076d0
("net: dsa: sja1105: save/restore VLANs using a delta commit method")
does not serve a purpose any longer. We can delete it and restore the
old code that simply adds a VLAN to the VLAN table and calls it a day.

Note that we keep the sja1105_commit_pvid() function from those days,
but adapt it slightly. Ports that are under a VLAN-aware bridge use the
bridge's pvid, ports that are standalone or under a VLAN-unaware bridge
use the tag_8021q pvid, for local termination or VLAN-unaware forwarding.

Now, when the vlan_filtering property is toggled for the bridge, the
pvid of the ports beneath it is the only thing that's changing, we no
longer delete some VLANs and restore others.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  12 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 402 +++++++------------------
 2 files changed, 114 insertions(+), 300 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 068be8afd322..9cd7dbdd7db9 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -226,14 +226,6 @@ struct sja1105_flow_block {
 	int num_virtual_links;
 };
 
-struct sja1105_bridge_vlan {
-	struct list_head list;
-	int port;
-	u16 vid;
-	bool pvid;
-	bool untagged;
-};
-
 struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
@@ -249,8 +241,8 @@ struct sja1105_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
-	struct list_head dsa_8021q_vlans;
-	struct list_head bridge_vlans;
+	u16 bridge_pvid[SJA1105_MAX_NUM_PORTS];
+	u16 tag_8021q_pvid[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_flow_block flow_block;
 	struct sja1105_port ports[SJA1105_MAX_NUM_PORTS];
 	/* Serializes transmission of management frames so that
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4f1331ff5053..309e6a933df7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -378,8 +378,6 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 	table->entry_count = 1;
 
 	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_bridge_vlan *v;
-
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
@@ -387,22 +385,10 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		v = kzalloc(sizeof(*v), GFP_KERNEL);
-		if (!v)
-			return -ENOMEM;
-
-		v->port = port;
-		v->vid = SJA1105_DEFAULT_VLAN;
-		v->untagged = true;
-		if (dsa_is_cpu_port(ds, port))
-			v->pvid = true;
-		list_add(&v->list, &priv->dsa_8021q_vlans);
-
-		v = kmemdup(v, sizeof(*v), GFP_KERNEL);
-		if (!v)
-			return -ENOMEM;
-
-		list_add(&v->list, &priv->bridge_vlans);
+		if (dsa_is_cpu_port(ds, port)) {
+			priv->tag_8021q_pvid[port] = SJA1105_DEFAULT_VLAN;
+			priv->bridge_pvid[port] = SJA1105_DEFAULT_VLAN;
+		}
 	}
 
 	((struct sja1105_vlan_lookup_entry *)table->entries)[0] = pvid;
@@ -1990,12 +1976,29 @@ static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
+	if (mac[port].vlanid == pvid)
+		return 0;
+
 	mac[port].vlanid = pvid;
 
 	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
 					   &mac[port], true);
 }
 
+static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct sja1105_private *priv = ds->priv;
+	u16 pvid;
+
+	if (dp->bridge_dev && br_vlan_enabled(dp->bridge_dev))
+		pvid = priv->bridge_pvid[port];
+	else
+		pvid = priv->tag_8021q_pvid[port];
+
+	return sja1105_pvid_apply(priv, port, pvid);
+}
+
 static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 			 enum dsa_tag_protocol mp)
@@ -2021,179 +2024,6 @@ static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
 	return -1;
 }
 
-static int sja1105_commit_vlans(struct sja1105_private *priv,
-				struct sja1105_vlan_lookup_entry *new_vlan)
-{
-	struct sja1105_vlan_lookup_entry *vlan;
-	struct sja1105_table *table;
-	int num_vlans = 0;
-	int rc, i, k = 0;
-
-	/* VLAN table */
-	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
-	vlan = table->entries;
-
-	for (i = 0; i < VLAN_N_VID; i++) {
-		int match = sja1105_is_vlan_configured(priv, i);
-
-		if (new_vlan[i].vlanid != VLAN_N_VID)
-			num_vlans++;
-
-		if (new_vlan[i].vlanid == VLAN_N_VID && match >= 0) {
-			/* Was there before, no longer is. Delete */
-			dev_dbg(priv->ds->dev, "Deleting VLAN %d\n", i);
-			rc = sja1105_dynamic_config_write(priv,
-							  BLK_IDX_VLAN_LOOKUP,
-							  i, &vlan[match], false);
-			if (rc < 0)
-				return rc;
-		} else if (new_vlan[i].vlanid != VLAN_N_VID) {
-			/* Nothing changed, don't do anything */
-			if (match >= 0 &&
-			    vlan[match].vlanid == new_vlan[i].vlanid &&
-			    vlan[match].tag_port == new_vlan[i].tag_port &&
-			    vlan[match].vlan_bc == new_vlan[i].vlan_bc &&
-			    vlan[match].vmemb_port == new_vlan[i].vmemb_port)
-				continue;
-			/* Update entry */
-			dev_dbg(priv->ds->dev, "Updating VLAN %d\n", i);
-			rc = sja1105_dynamic_config_write(priv,
-							  BLK_IDX_VLAN_LOOKUP,
-							  i, &new_vlan[i],
-							  true);
-			if (rc < 0)
-				return rc;
-		}
-	}
-
-	if (table->entry_count)
-		kfree(table->entries);
-
-	table->entries = kcalloc(num_vlans, table->ops->unpacked_entry_size,
-				 GFP_KERNEL);
-	if (!table->entries)
-		return -ENOMEM;
-
-	table->entry_count = num_vlans;
-	vlan = table->entries;
-
-	for (i = 0; i < VLAN_N_VID; i++) {
-		if (new_vlan[i].vlanid == VLAN_N_VID)
-			continue;
-		vlan[k++] = new_vlan[i];
-	}
-
-	return 0;
-}
-
-static int sja1105_commit_pvid(struct sja1105_private *priv)
-{
-	struct sja1105_bridge_vlan *v;
-	struct list_head *vlan_list;
-	int rc = 0;
-
-	if (priv->vlan_aware)
-		vlan_list = &priv->bridge_vlans;
-	else
-		vlan_list = &priv->dsa_8021q_vlans;
-
-	list_for_each_entry(v, vlan_list, list) {
-		if (v->pvid) {
-			rc = sja1105_pvid_apply(priv, v->port, v->vid);
-			if (rc)
-				break;
-		}
-	}
-
-	return rc;
-}
-
-static int
-sja1105_build_bridge_vlans(struct sja1105_private *priv,
-			   struct sja1105_vlan_lookup_entry *new_vlan)
-{
-	struct sja1105_bridge_vlan *v;
-
-	if (!priv->vlan_aware)
-		return 0;
-
-	list_for_each_entry(v, &priv->bridge_vlans, list) {
-		int match = v->vid;
-
-		new_vlan[match].vlanid = v->vid;
-		new_vlan[match].vmemb_port |= BIT(v->port);
-		new_vlan[match].vlan_bc |= BIT(v->port);
-		if (!v->untagged)
-			new_vlan[match].tag_port |= BIT(v->port);
-		new_vlan[match].type_entry = SJA1110_VLAN_D_TAG;
-	}
-
-	return 0;
-}
-
-static int
-sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
-			      struct sja1105_vlan_lookup_entry *new_vlan)
-{
-	struct sja1105_bridge_vlan *v;
-
-	list_for_each_entry(v, &priv->dsa_8021q_vlans, list) {
-		int match = v->vid;
-
-		new_vlan[match].vlanid = v->vid;
-		new_vlan[match].vmemb_port |= BIT(v->port);
-		new_vlan[match].vlan_bc |= BIT(v->port);
-		if (!v->untagged)
-			new_vlan[match].tag_port |= BIT(v->port);
-		new_vlan[match].type_entry = SJA1110_VLAN_D_TAG;
-	}
-
-	return 0;
-}
-
-static int sja1105_build_vlan_table(struct sja1105_private *priv)
-{
-	struct sja1105_vlan_lookup_entry *new_vlan;
-	struct sja1105_table *table;
-	int rc, i;
-
-	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
-	new_vlan = kcalloc(VLAN_N_VID,
-			   table->ops->unpacked_entry_size, GFP_KERNEL);
-	if (!new_vlan)
-		return -ENOMEM;
-
-	for (i = 0; i < VLAN_N_VID; i++)
-		new_vlan[i].vlanid = VLAN_N_VID;
-
-	/* Bridge VLANs */
-	rc = sja1105_build_bridge_vlans(priv, new_vlan);
-	if (rc)
-		goto out;
-
-	/* VLANs necessary for dsa_8021q operation, given to us by tag_8021q.c:
-	 * - RX VLANs
-	 * - TX VLANs
-	 * - Crosschip links
-	 */
-	rc = sja1105_build_dsa_8021q_vlans(priv, new_vlan);
-	if (rc)
-		goto out;
-
-	rc = sja1105_commit_vlans(priv, new_vlan);
-	if (rc)
-		goto out;
-
-	rc = sja1105_commit_pvid(priv);
-	if (rc)
-		goto out;
-
-out:
-	kfree(new_vlan);
-
-	return rc;
-}
-
 /* The TPID setting belongs to the General Parameters table,
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
@@ -2275,9 +2105,14 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	l2_lookup_params = table->entries;
 	l2_lookup_params->shared_learn = !priv->vlan_aware;
 
-	rc = sja1105_build_vlan_table(priv);
-	if (rc)
-		return rc;
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		rc = sja1105_commit_pvid(ds, port);
+		if (rc)
+			return rc;
+	}
 
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
@@ -2286,71 +2121,86 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	return rc;
 }
 
-/* Returns number of VLANs added (0 or 1) on success,
- * or a negative error code.
- */
-static int sja1105_vlan_add_one(struct dsa_switch *ds, int port, u16 vid,
-				u16 flags, struct list_head *vlan_list)
-{
-	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
-	struct sja1105_bridge_vlan *v;
-
-	list_for_each_entry(v, vlan_list, list) {
-		if (v->port == port && v->vid == vid) {
-			/* Already added */
-			if (v->untagged == untagged && v->pvid == pvid)
-				/* Nothing changed */
-				return 0;
-
-			/* It's the same VLAN, but some of the flags changed
-			 * and the user did not bother to delete it first.
-			 * Update it and trigger sja1105_build_vlan_table.
-			 */
-			v->untagged = untagged;
-			v->pvid = pvid;
-			return 1;
-		}
-	}
+static int sja1105_vlan_add(struct sja1105_private *priv, int port, u16 vid,
+			    u16 flags)
+{
+	struct sja1105_vlan_lookup_entry *vlan;
+	struct sja1105_table *table;
+	int match, rc;
 
-	v = kzalloc(sizeof(*v), GFP_KERNEL);
-	if (!v) {
-		dev_err(ds->dev, "Out of memory while storing VLAN\n");
-		return -ENOMEM;
+	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+
+	match = sja1105_is_vlan_configured(priv, vid);
+	if (match < 0) {
+		rc = sja1105_table_resize(table, table->entry_count + 1);
+		if (rc)
+			return rc;
+		match = table->entry_count - 1;
 	}
 
-	v->port = port;
-	v->vid = vid;
-	v->untagged = untagged;
-	v->pvid = pvid;
-	list_add(&v->list, vlan_list);
+	/* Assign pointer after the resize (it's new memory) */
+	vlan = table->entries;
+
+	vlan[match].type_entry = SJA1110_VLAN_D_TAG;
+	vlan[match].vlanid = vid;
+	vlan[match].vlan_bc |= BIT(port);
+	vlan[match].vmemb_port |= BIT(port);
+	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
+		vlan[match].tag_port &= ~BIT(port);
+	else
+		vlan[match].tag_port |= BIT(port);
 
-	return 1;
+	return sja1105_dynamic_config_write(priv, BLK_IDX_VLAN_LOOKUP, vid,
+					    &vlan[match], true);
 }
 
-/* Returns number of VLANs deleted (0 or 1) */
-static int sja1105_vlan_del_one(struct dsa_switch *ds, int port, u16 vid,
-				struct list_head *vlan_list)
+static int sja1105_vlan_del(struct sja1105_private *priv, int port, u16 vid)
 {
-	struct sja1105_bridge_vlan *v, *n;
+	struct sja1105_vlan_lookup_entry *vlan;
+	struct sja1105_table *table;
+	bool keep = true;
+	int match, rc;
 
-	list_for_each_entry_safe(v, n, vlan_list, list) {
-		if (v->port == port && v->vid == vid) {
-			list_del(&v->list);
-			kfree(v);
-			return 1;
-		}
-	}
+	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+
+	match = sja1105_is_vlan_configured(priv, vid);
+	/* Can't delete a missing entry. */
+	if (match < 0)
+		return 0;
+
+	/* Assign pointer after the resize (it's new memory) */
+	vlan = table->entries;
+
+	vlan[match].vlanid = vid;
+	vlan[match].vlan_bc &= ~BIT(port);
+	vlan[match].vmemb_port &= ~BIT(port);
+	/* Also unset tag_port, just so we don't have a confusing bitmap
+	 * (no practical purpose).
+	 */
+	vlan[match].tag_port &= ~BIT(port);
+
+	/* If there's no port left as member of this VLAN,
+	 * it's time for it to go.
+	 */
+	if (!vlan[match].vmemb_port)
+		keep = false;
+
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_VLAN_LOOKUP, vid,
+					  &vlan[match], keep);
+	if (rc < 0)
+		return rc;
+
+	if (!keep)
+		return sja1105_table_delete_entry(table, match);
 
 	return 0;
 }
 
-static int sja1105_vlan_add(struct dsa_switch *ds, int port,
-			    const struct switchdev_obj_port_vlan *vlan,
-			    struct netlink_ext_ack *extack)
+static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
+				   const struct switchdev_obj_port_vlan *vlan,
+				   struct netlink_ext_ack *extack)
 {
 	struct sja1105_private *priv = ds->priv;
-	bool vlan_table_changed = false;
 	int rc;
 
 	/* Be sure to deny alterations to the configuration done by tag_8021q.
@@ -2361,34 +2211,22 @@ static int sja1105_vlan_add(struct dsa_switch *ds, int port,
 		return -EBUSY;
 	}
 
-	rc = sja1105_vlan_add_one(ds, port, vlan->vid, vlan->flags,
-				  &priv->bridge_vlans);
-	if (rc < 0)
+	rc = sja1105_vlan_add(priv, port, vlan->vid, vlan->flags);
+	if (rc)
 		return rc;
-	if (rc > 0)
-		vlan_table_changed = true;
 
-	if (!vlan_table_changed)
-		return 0;
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
+		priv->bridge_pvid[port] = vlan->vid;
 
-	return sja1105_build_vlan_table(priv);
+	return sja1105_commit_pvid(ds, port);
 }
 
-static int sja1105_vlan_del(struct dsa_switch *ds, int port,
-			    const struct switchdev_obj_port_vlan *vlan)
+static int sja1105_bridge_vlan_del(struct dsa_switch *ds, int port,
+				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
-	bool vlan_table_changed = false;
-	int rc;
-
-	rc = sja1105_vlan_del_one(ds, port, vlan->vid, &priv->bridge_vlans);
-	if (rc > 0)
-		vlan_table_changed = true;
-
-	if (!vlan_table_changed)
-		return 0;
 
-	return sja1105_build_vlan_table(priv);
+	return sja1105_vlan_del(priv, port, vlan->vid);
 }
 
 static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
@@ -2397,23 +2235,21 @@ static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
 	struct sja1105_private *priv = ds->priv;
 	int rc;
 
-	rc = sja1105_vlan_add_one(ds, port, vid, flags, &priv->dsa_8021q_vlans);
-	if (rc <= 0)
+	rc = sja1105_vlan_add(priv, port, vid, flags);
+	if (rc)
 		return rc;
 
-	return sja1105_build_vlan_table(priv);
+	if (flags & BRIDGE_VLAN_INFO_PVID)
+		priv->tag_8021q_pvid[port] = vid;
+
+	return sja1105_commit_pvid(ds, port);
 }
 
 static int sja1105_dsa_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 {
 	struct sja1105_private *priv = ds->priv;
-	int rc;
-
-	rc = sja1105_vlan_del_one(ds, port, vid, &priv->dsa_8021q_vlans);
-	if (!rc)
-		return 0;
 
-	return sja1105_build_vlan_table(priv);
+	return sja1105_vlan_del(priv, port, vid);
 }
 
 /* The programming model for the SJA1105 switch is "all-at-once" via static
@@ -2531,7 +2367,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_bridge_vlan *v, *n;
 	int port;
 
 	rtnl_lock();
@@ -2553,16 +2388,6 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
 	sja1105_static_config_free(&priv->static_config);
-
-	list_for_each_entry_safe(v, n, &priv->dsa_8021q_vlans, list) {
-		list_del(&v->list);
-		kfree(v);
-	}
-
-	list_for_each_entry_safe(v, n, &priv->bridge_vlans, list) {
-		list_del(&v->list);
-		kfree(v);
-	}
 }
 
 static void sja1105_port_disable(struct dsa_switch *ds, int port)
@@ -3002,8 +2827,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_bridge_flags	= sja1105_port_bridge_flags,
 	.port_stp_state_set	= sja1105_bridge_stp_state_set,
 	.port_vlan_filtering	= sja1105_vlan_filtering,
-	.port_vlan_add		= sja1105_vlan_add,
-	.port_vlan_del		= sja1105_vlan_del,
+	.port_vlan_add		= sja1105_bridge_vlan_add,
+	.port_vlan_del		= sja1105_bridge_vlan_del,
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_hwtstamp_get	= sja1105_hwtstamp_get,
@@ -3164,9 +2989,6 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	INIT_LIST_HEAD(&priv->bridge_vlans);
-	INIT_LIST_HEAD(&priv->dsa_8021q_vlans);
-
 	sja1105_tas_setup(ds);
 	sja1105_flower_setup(ds);
 
-- 
2.25.1

