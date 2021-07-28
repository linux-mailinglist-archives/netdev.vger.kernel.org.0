Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABBC3D97E3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhG1VzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:55:02 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:44933
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232105AbhG1Vy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 17:54:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuW9RDskP60anVIilVqb2vo5KvgVoJznRZDKMcXDhn6X9CDc1KF0EVdexEAlE5zCNud5VGgUe4tqueZCSW8cm1s5npdJunFmZQym2j/Ns2s/hNuQfI65jBEQoz0vUDReK7l7dtUHOWw+Td3DybnJJJsR5T7OUlAikj8pd8O/bbNwTM51vDFmaT86GO3/XpXA+TljbS8mWN8anDK+OAY67uvB30QDR/58/C2W+st52XsmwRoEOBtDzrfOTiOBNEPWiB1YS/7wTj79GTQmHjSMKi6CUBeB1bKdUW6i3bdbZJrHwK4IVJUUbDPbCmY5oX55Y/1ASRG/NuDwC92FtY+XiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMDe0WF+12KkAs+ITz58M23qo+Y+aiXpLm2Pmuk5eGM=;
 b=l7/bF8dvh1Gr0tqEcCf1cbXy3GUYsOy/n7fIP/Fsdjgpg6BPgbAFKa/RTCUV8lNWt8qYi/K9HXEkxZYFy0Mu/nmkGP0QNwtiAjv8iwT+1ezy1r7MdyPHmQ+yh/ok+KnUqspmuVRoRsrwrhas3W/AXG+uVvwPA/rO5SfzdaMGJdFTDL3DOOP1Mjfespl7G8tL/S+yeNMVPkyH1LVscsR9x8ayzQmfXgMzLnArwkTW8UegbGm/WWFn5c5/4i8NgRELPW9mKhVNaON1XGXxSOKKm3AioQ9obhMt1MGHciWnlCh64yJTBhDA2Jov4i08zopXbGBQqezoSYYfbfqJuANDrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMDe0WF+12KkAs+ITz58M23qo+Y+aiXpLm2Pmuk5eGM=;
 b=LKtqN0AJoYRWKnyuSM5/jnVWm69ihGHLjmjRTeTe+BHo174clehPfbjofAJxJwKXxZ5ziUcfATzBlC5eySSNSwExfMmysbLFVD7ufRVHDchlXgh5o9GhY94k6vEwPtIvcDHXAJlBboM1f4tn0B17X9w/OBX5LqEsO5RK/4adFhU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4564.eurprd04.prod.outlook.com (2603:10a6:208:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Wed, 28 Jul
 2021 21:54:54 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 21:54:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: sja1105: reset the port pvid when leaving a VLAN-aware bridge
Date:   Thu, 29 Jul 2021 00:54:27 +0300
Message-Id: <20210728215429.3989666-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
References: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::20) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM8P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Wed, 28 Jul 2021 21:54:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75feff23-ca97-43e1-506f-08d952125521
X-MS-TrafficTypeDiagnostic: AM0PR04MB4564:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4564BF714118F53693E586F6E0EA9@AM0PR04MB4564.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8urinc1vbC5nn76AD8MNKG7IYQGwyQ1utda16bRua5+V8fddAUixf2+3IyVOooodZ5YjiHFmxxsZpmQyqDSonRjsATNb1VS6LTAESQWy5jnTjV+DiokJeUtMBYsOaq1vTF4BnkRBWKVopejHzwIb/iBPTFrcaG1uc3vmj270Z1IHToYKwL904xxU3OvyhSt4OtI8XkcpIOpk0OVUGmEWn7Hbs13tuFijLmOAPKw5Xbt8HCaqyo/l6EmcrGRgTnl4FSSvfGegldWdUqrJ02zz2YDuWRUqB6bw6ROC2G9wyeJpX6OXCFaYek5GTCGPSzOdhFpfyt5LH0xudS2mNISM2cpfu01IN5j+auV+WEF52qwPI3rOx2Z3Te1jdwUQZgBG+rP/NLq285O9yjn3u6NPK7R8rkc3rjMNs0GwhAU8I47u5pQr4rAcUWsp37ea0ol6Jv7G6QJSOTR7KQVyJu+VdpBhqkFIrVI7tLgXEnLLFwbhX1McWetB4YC/rMYyLhuAGHAgMpx4xbrVjFbYW8i7IQMRX2MC76hfr8p8EjzeZU7wojznHTJch68ozvGKRl4nIOKBtIDWwQYbrrC2VqDfEMga7PSYpm88kJHuLvh9NLcBJW5MQPgSlUhX4Q1tjd3L79QingX7ErTCi7sC3fK35EjWw3k2xnXGs4M09e789Hy5rdT8vQiiWJYpd7ZbidrYJ3ZJp6/wkTuzsxQORmJTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(83380400001)(6486002)(86362001)(110136005)(36756003)(66946007)(4326008)(316002)(8676002)(54906003)(66476007)(66556008)(6512007)(2616005)(956004)(44832011)(2906002)(6506007)(1076003)(8936002)(186003)(38100700002)(38350700002)(508600001)(52116002)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f4i/2TENiIiB64NNKixVeu3AFTVEfGh6RLd6dzNOCzz/VICDYXN3xo50qe97?=
 =?us-ascii?Q?gUgP1rt7DMpbrVNepn5HFU2z00bKLluPlOskl/OFXdTO3PG6pDvNgDFvvMhe?=
 =?us-ascii?Q?wJo8nl9Jphzsf84G407BPbJFpQDtewNwwRNC3u6wrtSUGMqMRQkk06k5Lsde?=
 =?us-ascii?Q?s42QX/1AFI98xc2WLQiK+ICD0oLTiSTE6vjOe9k7nxgXGw39uFm92UbNncfR?=
 =?us-ascii?Q?cRoPWrUfLSnv4zaKVvMj9tCaKO38o7vOKxdsHDLxXn9ufaAdTV3byTJHEmQq?=
 =?us-ascii?Q?0OMxzXwx+JR5pgSpVinv1vCHPe8y/lZVMcvTihBWlYmR78mR38fcIlq3vP0S?=
 =?us-ascii?Q?WZcM7BohwEYd1OeMfS8rL+3t1fVtIBZ/g9KLM4PLBe1P6CIiDk128YrY9Bcr?=
 =?us-ascii?Q?qpJfkJ0n0P0GaUUvRFIh7quDREX8fRceG//O9/OG/W3/hxrmKSU1EYDbgWtc?=
 =?us-ascii?Q?Akdz+m5JKS67lk2a59BgEi7R3HibCZs7ZD352jyZEd+56wgOyFljmWECYXQr?=
 =?us-ascii?Q?I+a2842y+hm/62/ZD8kQp1l9Oodb64b6R/aJKrNwCruIMsqA4lVNhqyA1HJd?=
 =?us-ascii?Q?q4jj1quKTMxiKN4y98zyKB0V9YUmD5322gsFp60SSMg5n2QCKMVv8hji8bip?=
 =?us-ascii?Q?lAQgjWj4OMK2Cbn01FPz/ikzdkTDYvGssUozAc5JnuaEucGbSHtZ4alopC3p?=
 =?us-ascii?Q?AdkxGZGKmC8733YvM8h6ohG9Uxefr/2fThOuQjPIftyxtvUD+OaecsWs9AUk?=
 =?us-ascii?Q?pGlT2+aA2S5IfWcMLpsWHBkbcrUOgPiiubQtxq5L1AGbaNoCQuUE7O+kFVW1?=
 =?us-ascii?Q?yTBR8KOm/BsNM9WupHq3C87asjyfnd2yhryKc+yKGPhNeTCXzfVcD6a1Wmys?=
 =?us-ascii?Q?VCKlND5hzmCLQhrDqbSHxMkfgg63G6zIyzFpFmPC+ME2axofr/IwGOUq5uqh?=
 =?us-ascii?Q?WrVpHSxsGJF0pPIBYIIHyAV9IXW1wpKA8bQDX7KKd6mO4sW53wt4QGi8Fefa?=
 =?us-ascii?Q?CTThvqYaxPdEChLUKNkNrn17kx/TuWj41TAOiKopYrXEdTuAJrowrtZC6/FY?=
 =?us-ascii?Q?vQg367FKxnEkEZIgDczKjJ4PD4wzgtZTwbaympCKYnty+IFxLCuBE/Uq7+9j?=
 =?us-ascii?Q?L1Iia38G6NVZVJb4RoxF5GmTRI9V0DvHAV28CV/X63tfESrMu6cqDVQ+St1t?=
 =?us-ascii?Q?t4oe9yxCuWlsWKikKopJu7VqzjlH9S0fzEnWvO5b6udC5R5P6exvd3mEwFMl?=
 =?us-ascii?Q?Ph2DEH5T1GLWcCp3KcudcEb3/OI2lWCO2+I5CTGwmCvBat8BKQmOophQwW5A?=
 =?us-ascii?Q?Nv88j7nISllizbt6lLdU3Evi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75feff23-ca97-43e1-506f-08d952125521
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 21:54:54.2460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GggK3VLjk3lbNrcZPrua7nHT4kDM4j3UYxISiPtESSsPAh9Amxd4e1VoY2j6j+Tx7k3GOhhWtYru8rfOg51oTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we no longer have the ultra-central sja1105_build_vlan_table(),
we need to be more careful about checking all corner cases manually.

For example, when a port leaves a VLAN-aware bridge, it becomes
standalone so its pvid should become a tag_8021q RX VLAN again. However,
sja1105_commit_pvid() only gets called from sja1105_bridge_vlan_add()
and from sja1105_vlan_filtering(), and no VLAN awareness change takes
place (VLAN filtering is a global setting for sja1105, so the switch
remains VLAN-aware overall).

This means that we need to put another sja1105_commit_pvid() call in
sja1105_bridge_member().

Fixes: 6dfd23d35e75 ("net: dsa: sja1105: delete vlan delta save/restore logic")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 62 ++++++++++++++------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3047704c24d3..293c77622657 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -57,6 +57,35 @@ static bool sja1105_can_forward(struct sja1105_l2_forwarding_entry *l2_fwd,
 	return !!(l2_fwd[from].reach_port & BIT(to));
 }
 
+static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
+{
+	struct sja1105_mac_config_entry *mac;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	if (mac[port].vlanid == pvid)
+		return 0;
+
+	mac[port].vlanid = pvid;
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+					    &mac[port], true);
+}
+
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
 static int sja1105_init_mac_settings(struct sja1105_private *priv)
 {
 	struct sja1105_mac_config_entry default_mac = {
@@ -1656,6 +1685,10 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 	if (rc)
 		return rc;
 
+	rc = sja1105_commit_pvid(ds, port);
+	if (rc)
+		return rc;
+
 	return sja1105_manage_flood_domains(priv);
 }
 
@@ -1955,35 +1988,6 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	return rc;
 }
 
-static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
-{
-	struct sja1105_mac_config_entry *mac;
-
-	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
-
-	if (mac[port].vlanid == pvid)
-		return 0;
-
-	mac[port].vlanid = pvid;
-
-	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
-					   &mac[port], true);
-}
-
-static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct sja1105_private *priv = ds->priv;
-	u16 pvid;
-
-	if (dp->bridge_dev && br_vlan_enabled(dp->bridge_dev))
-		pvid = priv->bridge_pvid[port];
-	else
-		pvid = priv->tag_8021q_pvid[port];
-
-	return sja1105_pvid_apply(priv, port, pvid);
-}
-
 static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 			 enum dsa_tag_protocol mp)
-- 
2.25.1

