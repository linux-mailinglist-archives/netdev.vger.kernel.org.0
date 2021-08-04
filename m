Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B612C3E0281
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbhHDNzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:35 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238522AbhHDNzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xc2Wt1rHVzmMvCcNVP/HgcQo+l2qIZkjSouttZO6u8gRBCZ00/tf9Rzu2OSPkgasJ+y88vw+VcU/qIWm4JStCFSiERH4Hi3PT/LW9H67wNa0qczUrPcBCkh5Z55AuqpOrJn4TF/9MfV0B+DQ67N1Kt8qQ9ndM96ebVxIuRjTRZQZOGEFGgqaTWC851wtQrYjcs7AyHMW1XGaiChuisXLuolNvNvMEQCHr9p13j2JG/KR1R6oNG3Zrs0NMN5JMf3b6b5wI3TUcZeZulcV0qyT8hyo7PssNLRKmTKcPTsN+c94XB97orlMbVTUhGlNpFA0gFt3p1+NNm8gpdfPXrV9Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FUbX4vC43iGoyFViHGeh8jv2RK37AK+Gwbm2JgVWoQ=;
 b=Er1tUy5ZeRpdMvu4EoHnHvPRpvK9AE0bF9/jDIAllUAeQRSSURaUm7UiLJPfnwTfG2gNYI/kF6BuaDMqK61KrIrrPEPR1uCTyvsdlqaZLIUUpUfpGPfu26NWdmnGCRN0yzxed5CWiaIfTWy61dSuxw8t7eB+Olfd4Rjoc3nZTQ8IhwePdkvoUUoG5V6xy5+KmhKKhgyhggA+mAlASPaZkqSnjamk3EuJ507gxKm5meR0wzTDUdSHcDRwNJu+E+zTedVSd7O+tSnxvWP4EsFFMlvY5qfpirlnElP8tOhwiXJPnfZQTpwr3A7I9gZ0uuPz84p84mPBvyJubzHtbuMHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FUbX4vC43iGoyFViHGeh8jv2RK37AK+Gwbm2JgVWoQ=;
 b=nlmJmBaX4mfJL8Cdpdu4VEefDY8Lhuf57ZCM9efZA2aH3ATA5MkUnah8fDXuzDyFnlKOzZKiDzCkUZPRD17ZBwLgS2fFiyhXJ4iDbkpCI50H39RHpUpVaZIDq8xIgHpfD24JhIpoTYtMj8KcsYmCYWE1o7mTB/stOXYnqxPtrYw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 4/8] net: dsa: sja1105: manage the forwarding domain towards DSA ports
Date:   Wed,  4 Aug 2021 16:54:32 +0300
Message-Id: <20210804135436.1741856-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4caf1cec-5f89-48e9-b59e-08d9574f79fe
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26877C80B9BF8439A2D3A90EE0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xq/4mclmAlbx5jCGlQz9N9CEnpxnG//0iPJlxL95SiSEBzz/NbWQVSDtH+xJVwRjjtiUqawsq+pH1R7PI7zDyEavW/hqLihYiACvryFMvVd1ZKGMmGw9xD77gG5N19jnXr5RLysMa5OFrwtyJCX/k5AYFi59CtZ7joCCc3Ck+m7ksrGnJiNCvIvTcp1lwfCzz4CJfElB7Mvol0FmRnEhnMKsXGf/Q5Bw4STFzUuynb8UEe9xm5gjF53SSlPoTmE1k0w6vIsf2qhClAMQDvGLj+R6h6vP5udq1wVOPI5OE5lGuvGCccft6P83roX2bMwMm6ucjvOTpYrwVUD+0n0xEN/yRw5nMmjyfm2Nn8+enOoSJLADgJglxrItc3DPIdTbFX+2Hzjss1Fc+9ba2C7iQlr+OKi9/eX6he4vAhjI+Ob4TLf803SBGecwkNSmKinYURURJdU0SRAFuIyk4mKhOdtMyGetAA+mu0wYwClQvui8LtWG1LTmHwwCEKZQPssSW9K33lKVmHOK/AKAR2f/nr/NNl5E7LXK7CCQAbx/BVfkWK6vzIsKzgmWoxqChqIFYZD90sNZn5wc0eeKd6SdvtCAuElRSqb/YAwZMvBNI4CovhqylZb3qTu5u7HGXIbQyswhsdSrwbSssf5ImTT9Y1/6ja9Qz7W3gTvJvRFmYaZpml8V1Uz2wMau/Q/Ey6sS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GlK0CTl28Qj8NU4sj3xYb5+ir2b0ajRVubkrPBqFSNo7+0A4NW6EUE7q3IKn?=
 =?us-ascii?Q?MlQ/GcZtSdNgYd2dFR25ptiuer45c7yuTHgawpgjobZ+4Ww8NifMI2VqdKOG?=
 =?us-ascii?Q?QI0FUnLjLKk1vytzgHl2hnxHSA7pV19zEkXWRnzYZgp5edb0+XrIFhcI5B67?=
 =?us-ascii?Q?nR4hKZLyyssy4npro3/FuHrFxQbPOiBOlBvMcSUWpicfw75jXcMtw3twSset?=
 =?us-ascii?Q?txMTt0yHz+Nek7owLQuKx0YkObu89Ln0aqecSwIZQ0ke0ZcASNnrlRdxdZDl?=
 =?us-ascii?Q?tiJdFQxEToOgNOYGNfZr3NITAun+pE5g3x3oXY1ovl8zNp11T4lA51EglvbP?=
 =?us-ascii?Q?u8yySq/YiNnvSdUODkw7qB2M9wmh8BpZHLf3XDFgRFYw0ZxHzp6FIReTxbGs?=
 =?us-ascii?Q?NnaQiaGqBpLg/0X96O1iuGZa7KldvZ1ZgMwuIuVQ4514Vu7hsJn9G8pSENww?=
 =?us-ascii?Q?59vhu51gxYT2gQn8MhFsR7fSESNW3ZsUnY8+81m7zYFyfj+6mVFXCtaS55nT?=
 =?us-ascii?Q?rAasHlvFkWYkGaVwH095mNDDv5cuWlcYAqPovmisOyylZiHpXc3go1+iP1dC?=
 =?us-ascii?Q?WsCLakFYJ7n1uW8UceGsGb2vNRm+LTA0PuOD8ugbsWaT4jxCKMuTOi8VgZYS?=
 =?us-ascii?Q?HLK9EA6zhZ5Fl/EJgm2H+szC3AKav4732kYWxCiZGVM9CkOtp+rmKg+AUop1?=
 =?us-ascii?Q?4ImoiE66Of/5tNbyQbBb9iy/fczJGrcQwthbTL5KQy7ViQHN8zc2+anqmbbG?=
 =?us-ascii?Q?ZnQchdAulNenirfnuKqRUhZ/a0a0jbaH4RbvLC1nHn2OlqYqNdpxOqRBbcs5?=
 =?us-ascii?Q?95jgWr3ng3Q3CDQDd+cMrkZtH+TL5JkBCT6DugSDS8FiZGaezNbqJZz311cB?=
 =?us-ascii?Q?Wo/h9CkzWPl8Hb/jWLyh2SuFwL06uASl9TRhYabWZTOeo46AQCwMuhlJcHge?=
 =?us-ascii?Q?gVKo5lFPalcwCjN0umTiQHfJZUSzdziF5rPPMCVK176/spab19sBNCxF3qx5?=
 =?us-ascii?Q?I5+pNztfy7kCetSkyDDsOKhGXs845wRuE/OsOU0M7xucwY4WKZvOrkvuHI2T?=
 =?us-ascii?Q?slQ1Yzu6pVJrEhHIlDilEf4hYP5TXkDnzj7LOJQE5U+s3jrdEHTo/UIQ27Zz?=
 =?us-ascii?Q?2fQCMFigJHcxCtfH7anBgK3iIdZIX4UK8I/1t/7Mip9/Kgqa0asGxmUk6NiK?=
 =?us-ascii?Q?NNjXyhbMTH7vtZDHa1GEvYeUr+ex5ejZLTRz4Tlu0/eWP2VpcpTXd/49rceV?=
 =?us-ascii?Q?3nCmq7cNj/vTeUgyFsa0TN42uGXndJ0mwnh6aLdML0OoASaJ6UbheXqAnhLu?=
 =?us-ascii?Q?bpEeUhNtGjlP1LSMGCs6Ja15?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4caf1cec-5f89-48e9-b59e-08d9574f79fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:11.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvtSgP5VWL18dEP2Deomz/yUmR08P9Vy3XTywfWwn17tExBabEC4XU99c0B9aPY01bcHIxWCeBdkcJFOXS5HHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manage DSA links towards other switches, be they host ports or cascade
ports, the same as the CPU port, i.e. allow forwarding and flooding
unconditionally from all user ports.

We send packets as always VLAN-tagged on a DSA port, and we rely on the
cross-chip notifiers from tag_8021q to install the RX VLAN of a switch
port only on the proper remote ports of another switch (the ports that
are in the same bridging domain). So if there is no cross-chip bridging
in the system, the flooded packets will be sent on the DSA ports too,
but they will be dropped by the remote switches due to either
(a) a lack of the RX VLAN in the VLAN table of the ingress DSA port, or
(b) a lack of valid destinations for those packets, due to a lack of the
    RX VLAN on the user ports of the switch

Note that switches which only transport packets in a cross-chip bridge,
but have no user ports of their own as part of that bridge, such as
switch 1 in this case:

                    DSA link                   DSA link
  sw0p0 sw0p1 sw0p2 -------- sw1p0 sw1p2 sw1p3 -------- sw2p0 sw2p2 sw2p3

ip link set sw0p0 master br0
ip link set sw2p3 master br0

will still work, because the tag_8021q cross-chip notifiers keep the RX
VLANs installed on all DSA ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 84 ++++++++++++++++++--------
 1 file changed, 60 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 74cd5bf7abc6..66a54defde18 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -475,7 +475,8 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	struct sja1105_l2_forwarding_entry *l2fwd;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int i, j;
+	int port, tc;
+	int from, to;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING];
 
@@ -493,47 +494,82 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 
 	l2fwd = table->entries;
 
-	/* First 5 entries define the forwarding rules */
-	for (i = 0; i < ds->num_ports; i++) {
-		unsigned int upstream = dsa_upstream_port(priv->ds, i);
+	/* First 5 entries in the L2 Forwarding Table define the forwarding
+	 * rules and the VLAN PCP to ingress queue mapping.
+	 * Set up the ingress queue mapping first.
+	 */
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
 
-		if (dsa_is_unused_port(ds, i))
+		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
+			l2fwd[port].vlan_pmap[tc] = tc;
+	}
+
+	/* Then manage the forwarding domain for user ports. These can forward
+	 * only to the always-on domain (CPU port and DSA links)
+	 */
+	for (from = 0; from < ds->num_ports; from++) {
+		if (!dsa_is_user_port(ds, from))
 			continue;
 
-		for (j = 0; j < SJA1105_NUM_TC; j++)
-			l2fwd[i].vlan_pmap[j] = j;
+		for (to = 0; to < ds->num_ports; to++) {
+			if (!dsa_is_cpu_port(ds, to) &&
+			    !dsa_is_dsa_port(ds, to))
+				continue;
 
-		/* All ports start up with egress flooding enabled,
-		 * including the CPU port.
-		 */
-		priv->ucast_egress_floods |= BIT(i);
-		priv->bcast_egress_floods |= BIT(i);
+			l2fwd[from].bc_domain |= BIT(to);
+			l2fwd[from].fl_domain |= BIT(to);
+
+			sja1105_port_allow_traffic(l2fwd, from, to, true);
+		}
+	}
 
-		if (i == upstream)
+	/* Then manage the forwarding domain for DSA links and CPU ports (the
+	 * always-on domain). These can send packets to any enabled port except
+	 * themselves.
+	 */
+	for (from = 0; from < ds->num_ports; from++) {
+		if (!dsa_is_cpu_port(ds, from) && !dsa_is_dsa_port(ds, from))
 			continue;
 
-		sja1105_port_allow_traffic(l2fwd, i, upstream, true);
-		sja1105_port_allow_traffic(l2fwd, upstream, i, true);
+		for (to = 0; to < ds->num_ports; to++) {
+			if (dsa_is_unused_port(ds, to))
+				continue;
+
+			if (from == to)
+				continue;
 
-		l2fwd[i].bc_domain = BIT(upstream);
-		l2fwd[i].fl_domain = BIT(upstream);
+			l2fwd[from].bc_domain |= BIT(to);
+			l2fwd[from].fl_domain |= BIT(to);
 
-		l2fwd[upstream].bc_domain |= BIT(i);
-		l2fwd[upstream].fl_domain |= BIT(i);
+			sja1105_port_allow_traffic(l2fwd, from, to, true);
+		}
+	}
+
+	/* Finally, manage the egress flooding domain. All ports start up with
+	 * flooding enabled, including the CPU port and DSA links.
+	 */
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		priv->ucast_egress_floods |= BIT(port);
+		priv->bcast_egress_floods |= BIT(port);
 	}
 
 	/* Next 8 entries define VLAN PCP mapping from ingress to egress.
 	 * Create a one-to-one mapping.
 	 */
-	for (i = 0; i < SJA1105_NUM_TC; i++) {
-		for (j = 0; j < ds->num_ports; j++) {
-			if (dsa_is_unused_port(ds, j))
+	for (tc = 0; tc < SJA1105_NUM_TC; tc++) {
+		for (port = 0; port < ds->num_ports; port++) {
+			if (dsa_is_unused_port(ds, port))
 				continue;
 
-			l2fwd[ds->num_ports + i].vlan_pmap[j] = i;
+			l2fwd[ds->num_ports + tc].vlan_pmap[port] = tc;
 		}
 
-		l2fwd[ds->num_ports + i].type_egrpcp2outputq = true;
+		l2fwd[ds->num_ports + tc].type_egrpcp2outputq = true;
 	}
 
 	return 0;
-- 
2.25.1

