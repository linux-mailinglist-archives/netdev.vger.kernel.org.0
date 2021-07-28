Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4568C3D958F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhG1Sxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:53:32 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63297
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229542AbhG1Sxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:53:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+j0jV8RFJ9QSjYunHzwZq8eAlfX/b3tRXebZHMdyWmKGMk9lpjBC+svZb2LaSbuANUjMHemQVhND0jZqwGF1KQajHME36uMei2+CD1Mg7S5/NBmzypPYZOJU16o5BLAsq7hDyoQqSVoM/AV906hvv2RwSXB5KCU6HhnGIM7B+YT/bRugTB0JSq/KuEHto+/xfngZyDhq4wYExZCc0XHRcy0r+hXV3TsZ4e/f4DU3VqOcIMoP/Pw309LpuboY3N7xCMKcbgrORk+nXo7I5IhenZafOFis58tDjqTV+qNm9ANIyMhGTezx6hVMJKz7inXM0B2S/F1hNbkME8AkcJk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yb1hed2zHYrBgJKDh/sxxNG8O345gAp1QjdbOxpk7c=;
 b=SwzdtQpKAxff5iNNTitlX6+Q0OOfwlq4YbBls/D84vevYllJejo6vujekRaAELmAR2KzPH7vFmD+vnfuYaf1nAYOrYbj4OSM415QX348oJhU8HIc7A6n4Ks6hgcScOP9KPb6+yQbpHNIP/rPyvL4EpE2qUwMwmQPrLNO5GzasPnP+ZgywrGnvhWcINm4yh3zsiFYJNZgYH8eYmjYMd+GRLqv0jBJ7LuioZRrRjNNDpY0LesGfGLZgGElh1BA1JQ369SmyyNrPFoYNi9Lx6Og/GVIS7HUadqp6JaPC/dQTGtyPsTrfk9++JD3bEcfyS4T2H5EopjvVkQRrcytZdfeLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yb1hed2zHYrBgJKDh/sxxNG8O345gAp1QjdbOxpk7c=;
 b=VwL0j2q16JQuRYIh/LMdcW4JiG3HXXMCm4lfx/fVwxhL8XjbQdcKTcSCn/y6guAOoB1K5KZw2vmA1AsYyRXv6jSQU/ZjE195R1RC0cQrCtrdu1CU9fu7rhb/B98HsqHrBh5aY+gY+B+MHKmiVAeGp9/3KB9OpUealtBwaqAg/u8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 18:53:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 18:53:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: be stateless when installing FDB entries
Date:   Wed, 28 Jul 2021 21:53:15 +0300
Message-Id: <20210728185315.3572464-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0023.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0902CA0023.eurprd09.prod.outlook.com (2603:10a6:200:9b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Wed, 28 Jul 2021 18:53:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4cf8ea1-cfed-4932-c71a-08d951f8fc57
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328314656B97CCECEB1C025E0EA9@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2x3NQH7fCcs+11NowmWi0kQqD7oJPdL6QKlbwP3ZzDiaLoX3cA7wPTbOZU+0bLpTW1V64GMHoGL9hGhc5J/uUjySv+GiL2WZZHXoB/LOSffy8LC+5XEdXYgUzWKIA6lKrruCL/s2q+kMZrgwq7HkIJuL/9yYIVydWzrjFGfUtP7Cd+X2hpM1S6ISOccHowUTTNqZlENEZQFp3AJLtMIFsM1QKkX2nX/wvC+JHEXZLPZnPgq1lLb4xovp0/B9u1TKjE7lCIeE/MyxZzmo5oYRyqayfI08MB/OqQektg0JZOspuAK9vlf6ph/Di5zMwCchr9yxIo1ginyhE9RwvNCjUb3i2UemZW+hW5CItZ3K3Tp2wN+mMHuox5Qnn/jmsLG8BhCq2otqfxeLIrDPcOvVAtn8pAXjZNTQf1Ivh1BlZ4vQooUMPboSNgvvVY7zBDUAtclfdrQ5/Y0lyQlOTLoH/OVtjISNXDKfLRWhuCZti1/hORLf90Ja3lStS4oTbQyIFgjVy6f73cNMHNprnYZEVtY4suRjjFgvBMDHN6+zRBLxa23aYSGH0VmlWiohezQ5LPvKpOKCUMOD/SXL8B+wmQfXbuIWsnYqlruvtf+vulq/dLvWCX1ubdb6CE905Hkj05zDgHgvLB47BAmEVz/KV/Hlmbv2woBhTZHnp0q4s2urZ3Cj138qDPsJ/vq4ligkEiI6j787orO+Nw12n7WbRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39850400004)(136003)(366004)(38350700002)(956004)(86362001)(38100700002)(2616005)(66476007)(6506007)(36756003)(44832011)(66556008)(66946007)(8936002)(316002)(186003)(4326008)(1076003)(26005)(54906003)(8676002)(83380400001)(110136005)(5660300002)(6666004)(478600001)(2906002)(6486002)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mYWxU2Skeu0g6JG5hOu4YQ29SnqC7MSdCjmP2W5NuHOhK7w70HGCa7XXvcEF?=
 =?us-ascii?Q?S82eoQ3QQUqNdKBPOUgOKJm+RloTNdFhqGHFt67yeHwLo3MG8htYbTk53p5U?=
 =?us-ascii?Q?QA21HYY/vCYgRhOM7arVMJyh+0gh+C7qn4oipETUF/wMrF9dxpWrWVuAUfh1?=
 =?us-ascii?Q?GKO26yl62Per7zMjYFuNZh/Slm2DGB0HxtwLopXuoWkYjmx96+qmJPEd8P/b?=
 =?us-ascii?Q?9PviXYGxaiYRGxCEE23qticMB2rZUmsuZONLliwojerdpqzgvA/Gyk8Ag5NR?=
 =?us-ascii?Q?YrNE5RG2PtMW4BjZqBT0JEUs6DV8DWJ1twK3EagDsh2SuGthRz33o2P58Ybp?=
 =?us-ascii?Q?tb0iWD0XnpjiHtg3U5ZKUPZoiOchzwQzfzNl2lelg1H0bPDLDSOqw1hcJJeG?=
 =?us-ascii?Q?SRe0rHlYzhaJnAni7juzSmiw2UET9ZMVFAr/g3I9BISOFleqasqmwmlrRAuu?=
 =?us-ascii?Q?yqvzbZDDuOSnf7Yj2rzPSC4Vl44O67T7DtHPef7cQuYO4aA9E+iFCmeYL3zl?=
 =?us-ascii?Q?sbifav2P6XHC0FJ4fAa8g73BEHGwHKXxLAn9gihDa88robzr8Dv8C6KxwmfG?=
 =?us-ascii?Q?0A+0d+L4c526bTuaNP0jH7Jzvze7+2cs63vb6BcOkH3I1vZ1TMFcLrS7ZdmU?=
 =?us-ascii?Q?dBAtUSA8335dcdSbNvRgv7RfUdz1+8hPwhBHNuzR543m5VVJvdlPNMvAtA4h?=
 =?us-ascii?Q?O2kXzmLqlufDoKjiyssqTU3SUl9bFgu4XV/+EagWoJQyTTZDYDPn8wOAtQ3h?=
 =?us-ascii?Q?Nm7Z4Rdkzhqy6aSBe9Xj9tJn777gPBQNFTI7iGbs9ZJVKGEUKiTytz7FEJNb?=
 =?us-ascii?Q?8FLAmy99+kycbS2Gs6nkxbdg+B4iR6kt9kAr/653TihcZgDjHJ/o6+0aDsHZ?=
 =?us-ascii?Q?x2qmJjKd8t1wm28xU60MCuUnZFKKS0xrEhgAgstgwTTnapsnzTsRv9jhOJrE?=
 =?us-ascii?Q?wQILqw/Vbfo0J6eSLn38JX/Z0Swl/ilQR2O7fPn+f1N7capGowOdQZx1kr81?=
 =?us-ascii?Q?kXAsouoo0C5bQ/TLjluTlZ4GSVstehdwn+OgP3M1o5j4IVJ6l3n78bTxBoE8?=
 =?us-ascii?Q?dKSUJi0McSNny/uuqG6htNVXNphhxoXGjd3M6BaXAdfBO7d7ixT7DwBvInFg?=
 =?us-ascii?Q?Ffs8NUYOyQkj0kUWZDOENB8s8ZVa4iEj9Dagda3S4ZotihohH/A7iaNFld31?=
 =?us-ascii?Q?h1SzqrDEjtG95+ZavFeOUpxkpe/K2GAD6+8L122l5KMcN3u39/nCe+XBdFsY?=
 =?us-ascii?Q?diTyO4Dj5yR1ZJ8+yd5E1xy/wMJJc2XavdN08GyBmx0FTI6NSEJMq0U6BdMu?=
 =?us-ascii?Q?VHjoTLV/6KhTxbKkkuPFtQEl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cf8ea1-cfed-4932-c71a-08d951f8fc57
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 18:53:27.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkowUF1vgqERaA/jj/XAbVy75XcKyy4CVSOHUYMmCoHay4iVmYtuGjxA3EIG0/xbzK/DlUO5QuZnS6fBY52cNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there are issues when adding a bridge FDB entry as VLAN-aware
and deleting it as VLAN-unaware, or vice versa.

However this is an unneeded complication, since the bridge always
installs its default FDB entries in VLAN 0 to match on VLAN-unaware
ports, and in the default_pvid (VLAN 1) to match on VLAN-aware ports.
So instead of trying to outsmart the bridge, just install all entries it
gives us, and they will start matching packets when the vlan_filtering
mode changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c |  6 +++---
 drivers/net/dsa/sja1105/sja1105_main.c           | 15 ---------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 56fead68ea9f..bd3ad18c150e 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -1354,14 +1354,14 @@ u8 sja1105et_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid)
 {
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params =
 		priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS].entries;
-	u64 poly_koopman = l2_lookup_params->poly;
+	u64 input, poly_koopman = l2_lookup_params->poly;
 	/* Convert polynomial from Koopman to 'normal' notation */
 	u8 poly = (u8)(1 + (poly_koopman << 1));
-	u64 vlanid = l2_lookup_params->shared_learn ? 0 : vid;
-	u64 input = (vlanid << 48) | ether_addr_to_u64(addr);
 	u8 crc = 0; /* seed */
 	int i;
 
+	input = ((u64)vid << 48) | ether_addr_to_u64(addr);
+
 	/* Mask the eight bytes starting from MSB one at a time */
 	for (i = 56; i >= 0; i -= 8) {
 		u8 byte = (input & (0xffull << i)) >> i;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index da042e211dda..3047704c24d3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1501,18 +1501,6 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	/* dsa_8021q is in effect when the bridge's vlan_filtering isn't,
-	 * so the switch still does some VLAN processing internally.
-	 * But Shared VLAN Learning (SVL) is also active, and it will take
-	 * care of autonomous forwarding between the unique pvid's of each
-	 * port.  Here we just make sure that users can't add duplicate FDB
-	 * entries when in this mode - the actual VID doesn't matter except
-	 * for what gets printed in 'bridge fdb show'.  In the case of zero,
-	 * no VID gets printed at all.
-	 */
-	if (!priv->vlan_aware)
-		vid = 0;
-
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
 }
 
@@ -1521,9 +1509,6 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (!priv->vlan_aware)
-		vid = 0;
-
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
 }
 
-- 
2.25.1

