Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55E546F786
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhLIXjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:39:00 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhLIXi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASVGf0QMJm/ZOqiIcDy2ZnZ1R95FZ9J9hYGw7AJ4maTDfbMlH3pXegurrbez2GFuF9pmNKysU4nDsZGdLZ+J489h+ZHpmaOcIpvnv9EkmpEOIP2Kfhn5o7rbLdYiSSuAvpr37bjiN4dGlfelUPw5Bc5xuew3s6gpjdd1dvMxV8VnF2kqrZ0bJiibsaSDq904FV3FEgCaQAVasShMdVe/IlM2xR6gv83p4ETjiUdstAZHAcwFpXKCzx/GISETleVEdC0/DMEm9fxdBC0aTnujUqWBlBscswMEs1AkO6pfirIG/Let14J1Cu+EoFKQEoqkmHViGD25RDUKxSqI/fccUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIFSW7urg/RXZkB1g8YM/8f4RpfkwyMQ+TPHUss3aLw=;
 b=eJOI+egjV4m/CCy2K3d6X5gAhO1qh2ozDggXyDr0zGYIfV3pckxQqjFheMOVX9mPyDaqT/U1gJ+gNpLrIQncl1uF+EqA0uM/e4XTSnWIMFjruSE+uhRgtxM5DVtDrAYAf3YS+ip7gJxbQyHb73psztnRD/j5Q2sxnOn7cWS+vtRLGexlQOjGJkf96i1yKnfdXLQQ9buxB4X1Fgu7nl7IqMJljUOH2UTswoONHrvJHCIsCic60N0CPn0CzMCTHCVuIvSrbBvRObSzkEcleaFn+h4DS4411T4BgQa4vCJ5o/3Wr8PdHOQm8spHMBS94x72PQsFtHEsYTtTjMLjC+gRlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIFSW7urg/RXZkB1g8YM/8f4RpfkwyMQ+TPHUss3aLw=;
 b=sjvRNa1kLHIbEaUY8TNhcd/mu7x62c/2mI2p5zskQG4DNA1yyefCrWk0KlVqnISMSztqssnJXZ9zidRD+rd0jslEf6Se91u4cbsc6ZhUobnrH55+N7DLo8leIDBWDfo89FITugOxPo9ptONun0ozSA093DlMX92+/y8rIE0insg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 08/11] net: dsa: tag_sja1105: convert to tagger-owned data
Date:   Fri, 10 Dec 2021 01:34:44 +0200
Message-Id: <20211209233447.336331-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 171a9d92-1c3b-4d9a-6b74-08d9bb6c8eb9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408F15628CEB98E0A1E7BDAE0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTgPpW6gcnIKRHXTvjBGDIotoGOH++9oOfFl7q08aX+Zz1tVOUgRW7RfnbEl63JnXyjNnW5D1ch28mLoKZwxnQSaL2GQAKamDLch2GgLv2ABvn/5k566xkWTqh+qeV7tpFEvqcZXW1I3UdvOFr5iF6i2W8tcdKFcaW8UMMX3zX8anjIR1PVm1S7eakpDI0AoOawQcZDGK0GyUsc8X02gVv6wDsPez06M3Dbp8i+ALBHCFUl1GTiWXFvhhnMDdpqS0iXLCggMxu+saNEsxLisOwAzkit1zkSEy5w/6Op3TGCMzk2RBQ1eH8KnQxKXfw5cynLOjoZE0D0wIviK4p/cdabDe+hkvzcUZqj7b9m+upW1TODVt1tYkqbdQskQddCqYDCaw+QYw+i18/GyArGDI22Rlftq/q4CgtaU31o4E9J3y/TsJyjONJutUWJQR1NTa9NlT4sSpancoBUVtCkQucrP8Egx8b0k0iIwBHA0XIUXjuhsdQ39v9/zqjQxtWRZZC03qDUQy4u93qhyQ60IH15WgQG6TZ3IxsIrpjT8moRaAwAhZ+AVueXJUVEMyjd4Anr1VbZZFbN/TIdcU4Zx+3dZBslCeOlCJX/PKI/t1PkLCcnfHiuDI14j7VDSKJxrAJtRk0Xa909yUGV0iEPiyjx4G/BM2Ci/tk1qR4c9t3ekHwyQAq7si6K0PafbLboeEeUzs6CK6zh5gAFtc9kgtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(30864003)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yItH0sEWNzJUPQGK1BvEjhJqPVucecxTdHcdzJ2jwdXd8iz17XOIShRd3mm8?=
 =?us-ascii?Q?OAFKdJXeySlQiqv9Dek1/TAOor6wwKKyQXvZXy9QHaIUcm2+sYRVhQ0VLHvM?=
 =?us-ascii?Q?w8a2184NhjvEDSVWIXnhHexU87yTjD/eJUPRelGXnc8JSjw3LGKdKOUjoZxM?=
 =?us-ascii?Q?AEFMzkMundzmuDkJUJRyLuYBfySNcgZCwXg6nkw8cLEYx9lK65aQGQ3tkprS?=
 =?us-ascii?Q?9csBjgLwlWu403l2QxGUt6xWYF0TDq5fFnR8eSoiIp2sT0tPvZUSINUef1B/?=
 =?us-ascii?Q?DDMpulfWITv0R3AkEJkrg3LF9AihUZlyeEIj3Ndn7wvKaMi1b6G8bRAcqFoK?=
 =?us-ascii?Q?1hdBEO+FYgWwjpko8DUlIyCKSAtT2G74u2tsiGgFC7TyQqzeWlZRgsXX8U1x?=
 =?us-ascii?Q?KumJRmuH1y+4mGWvJJrAGjcmjubzp6lLUEfGEpFRWnQXv467pYWG018A6Csx?=
 =?us-ascii?Q?EIJJEvIG41cwZylFZS1bzMMqWVn9r8gIlUEcIhrsb7gTvEB5A0P5h/h35vGk?=
 =?us-ascii?Q?DjZrd58+jhnRU2Vr61Xkfq0FeTq5/zu4SoRFQdMiBB7KXSETRHoI5PHlKLpu?=
 =?us-ascii?Q?kmwFyXFf3kAhTVsk1nY5fgXJcd9SbnOc2HKUAZTz9T6Ic7fp9y4aPzEJteGx?=
 =?us-ascii?Q?F7f6NDs2HSez8HGa/Y5cZzlq7wnC796DFTYCn2fP6olvTl3KYjfGyKlPsLml?=
 =?us-ascii?Q?9xzq5N+T16YuLYmcdSHPM1q0FKpXSl0bCCiaWXZeU7WVN6aoihpj5QfN0etr?=
 =?us-ascii?Q?UvbMPjDdLA79o/HhZBCjBRkWB4ypbTHGP5c92rE9Loo+Rye6WuaGCZPgS2NT?=
 =?us-ascii?Q?Hv7uX1S/RP36Ui4NRNtHnZ8zhSmKtTps+W/+vtaKpzF51yOvl/hHHHK5p8tN?=
 =?us-ascii?Q?4MFrk4h2b0RyYoaWRb7Vg5rYxm6lR7oucrhwNpPfrTDB0YIq/EaW2evDz7KS?=
 =?us-ascii?Q?1UZVlmq0/7MtThZMbRKE+akFHY3u7ghszOuznglYONq2+t4U66gWeo1JRYAt?=
 =?us-ascii?Q?qAB+GdHbBcmW62a71H6n7GFPtLbFP1seqV7i+jXFla7z53Vq4zsevfOIO1Uz?=
 =?us-ascii?Q?+B9ee5+B5o76kgMDa1xKpYsHVxvCBDR+pM2kJJ2luIJApYrEbLzTX+DH1ySx?=
 =?us-ascii?Q?h3JLqQnWlD43LRvUAn9t3jn1zbLwZTW8Wk/TPPddNCbSJjyF2N4UKOIFL7z1?=
 =?us-ascii?Q?vw6d+1fOr6IhXrxtw5WsdxImzbIlimrW+VLxVxyeEBjc8bTNOMo+YLVKiwpN?=
 =?us-ascii?Q?Tj7wBoJFc2NW3CVku8E3rMo6o/wz3CCgIBjug+pyLHQAD4icof+i7i0Ib0Vz?=
 =?us-ascii?Q?nioDNgC9K3I1pdUhmc32Zkjf6iVeiMtPe2xODW93wHVqipBS1eE37irKH6tF?=
 =?us-ascii?Q?+9MePGgrQcmzd8c5mFAzBqBMpXRDK8q7XRAPYjjUacqWIKgfcqOl2q7S3qbD?=
 =?us-ascii?Q?xSppq5/eWfFMXKEfvHKXbGdjQC/Qf66YJES22BafP6WelyGCf0g8Kofaq/i4?=
 =?us-ascii?Q?B9Xvypi+WVG7nyvIfqTjb6G4Hc+x3IodkkcqBHhZnDgyyc3EvdX11T6hg+yA?=
 =?us-ascii?Q?JDhBp+SRmVTbnLPevWT6At+GKDd6x7g9c9wfvjdzWSlVwbpFGrGSUFPkAqKt?=
 =?us-ascii?Q?dYoE5itOCj+TFPc7hC5Ix/8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171a9d92-1c3b-4d9a-6b74-08d9bb6c8eb9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:17.7357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzidVWw1LWExPBM1LwWjEzUTL3bDU341e3kzVcj5wPlP0c4Ln0eurgbmHPWOGm7Bbnm4hTjtlYThSqoILcJcyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, struct sja1105_tagger_data is a part of struct
sja1105_private, and is used by the sja1105 driver to populate dp->priv.

With the movement towards tagger-owned storage, the sja1105 driver
should not be the owner of this memory.

This change implements the connection between the sja1105 switch driver
and its tagging protocol, which means that sja1105_tagger_data no longer
stays in dp->priv but in ds->tagger_data, and that the sja1105 driver
now only populates the sja1105_port_deferred_xmit callback pointer.
The kthread worker is now the responsibility of the tagger.

The sja1105 driver also alters the tagger's state some more, especially
with regard to the PTP RX timestamping state. This will be fixed up a
bit in further changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 54 +++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 35 +++++-----
 include/linux/dsa/sja1105.h            |  7 +-
 net/dsa/tag_sja1105.c                  | 90 +++++++++++++++++++++-----
 5 files changed, 110 insertions(+), 77 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 850a7d3e69bb..9ba2ec2b966d 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -272,7 +272,6 @@ struct sja1105_private {
 	struct mii_bus *mdio_base_tx;
 	struct mii_bus *mdio_pcs;
 	struct dw_xpcs *xpcs[SJA1105_MAX_NUM_PORTS];
-	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
 };
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 880f28ea184f..4f5ea5d6a623 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2705,6 +2705,21 @@ static void sja1105_port_deferred_xmit(struct kthread_work *work)
 	kfree(xmit_work);
 }
 
+static int sja1105_connect_tag_protocol(struct dsa_switch *ds,
+					enum dsa_tag_protocol proto)
+{
+	struct sja1105_tagger_data *tagger_data;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_SJA1105:
+		tagger_data = sja1105_tagger_data(ds);
+		tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
+		return 0;
+	default:
+		return -EPROTONOSUPPORT;
+	}
+}
+
 /* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
  * which cannot be reconfigured at runtime. So a switch reset is required.
  */
@@ -3005,38 +3020,6 @@ static int sja1105_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void sja1105_teardown_ports(struct sja1105_private *priv)
-{
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
-
-	kthread_destroy_worker(tagger_data->xmit_worker);
-}
-
-static int sja1105_setup_ports(struct sja1105_private *priv)
-{
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
-	struct dsa_switch *ds = priv->ds;
-	struct kthread_worker *worker;
-	struct dsa_port *dp;
-
-	worker = kthread_create_worker(0, "dsa%d:%d_xmit", ds->dst->index,
-				       ds->index);
-	if (IS_ERR(worker)) {
-		dev_err(ds->dev,
-			"failed to create deferred xmit thread: %pe\n",
-			worker);
-		return PTR_ERR(worker);
-	}
-
-	tagger_data->xmit_worker = worker;
-	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
-
-	dsa_switch_for_each_user_port(dp, ds)
-		dp->priv = tagger_data;
-
-	return 0;
-}
-
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -3082,10 +3065,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 		}
 	}
 
-	rc = sja1105_setup_ports(priv);
-	if (rc)
-		goto out_static_config_free;
-
 	sja1105_tas_setup(ds);
 	sja1105_flower_setup(ds);
 
@@ -3142,7 +3121,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 out_flower_teardown:
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
-	sja1105_teardown_ports(priv);
 out_static_config_free:
 	sja1105_static_config_free(&priv->static_config);
 
@@ -3162,12 +3140,12 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_ptp_clock_unregister(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
-	sja1105_teardown_ports(priv);
 	sja1105_static_config_free(&priv->static_config);
 }
 
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
+	.connect_tag_protocol	= sja1105_connect_tag_protocol,
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 0904ab10bd2f..b34e4674e217 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -58,13 +58,13 @@ enum sja1105_ptp_clk_mode {
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
-/* Must be called only with priv->tagger_data.state bit
+/* Must be called only with the tagger_data->state bit
  * SJA1105_HWTS_RX_EN cleared
  */
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
+				      struct sja1105_tagger_data *tagger_data,
 				      bool on)
 {
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_table *table;
@@ -75,9 +75,9 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 	general_params->send_meta0 = on;
 
 	/* Initialize the meta state machine to a known state */
-	if (priv->tagger_data.stampable_skb) {
-		kfree_skb(priv->tagger_data.stampable_skb);
-		priv->tagger_data.stampable_skb = NULL;
+	if (tagger_data->stampable_skb) {
+		kfree_skb(tagger_data->stampable_skb);
+		tagger_data->stampable_skb = NULL;
 	}
 	ptp_cancel_worker_sync(ptp_data->clock);
 	skb_queue_purge(&tagger_data->skb_txtstamp_queue);
@@ -88,6 +88,7 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 
 int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct hwtstamp_config config;
 	bool rx_on;
@@ -116,17 +117,17 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		break;
 	}
 
-	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state)) {
-		clear_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state)) {
+		clear_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
 
-		rc = sja1105_change_rxtstamping(priv, rx_on);
+		rc = sja1105_change_rxtstamping(priv, tagger_data, rx_on);
 		if (rc < 0) {
 			dev_err(ds->dev,
 				"Failed to change RX timestamping: %d\n", rc);
 			return rc;
 		}
 		if (rx_on)
-			set_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+			set_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
@@ -136,6 +137,7 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct hwtstamp_config config;
 
@@ -144,7 +146,7 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
-	if (test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
+	if (test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -417,10 +419,11 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 
 bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	if (!test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
+	if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
@@ -459,13 +462,11 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
  */
 void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data;
 	u8 ts_id;
 
-	tagger_data = &priv->tagger_data;
-
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	spin_lock(&priv->ts_id_lock);
@@ -897,7 +898,6 @@ static struct ptp_pin_desc sja1105_ptp_pin = {
 int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	ptp_data->caps = (struct ptp_clock_info) {
@@ -919,9 +919,6 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 	/* Only used on SJA1105 */
 	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
-	/* Only used on SJA1110 */
-	skb_queue_head_init(&tagger_data->skb_txtstamp_queue);
-	spin_lock_init(&tagger_data->meta_lock);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
 	if (IS_ERR_OR_NULL(ptp_data->clock))
@@ -937,8 +934,8 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	if (IS_ERR_OR_NULL(ptp_data->clock))
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index d8ee53085c09..9f7d42cbbc08 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -84,9 +84,12 @@ static inline s64 sja1105_ticks_to_ns(s64 ticks)
 	return ticks * SJA1105_TICK_NS;
 }
 
-static inline bool dsa_port_is_sja1105(struct dsa_port *dp)
+static inline struct sja1105_tagger_data *
+sja1105_tagger_data(struct dsa_switch *ds)
 {
-	return true;
+	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_SJA1105);
+
+	return ds->tagger_data;
 }
 
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index fc2af71b965c..f3c1b31645f5 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -125,7 +125,7 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
-	struct sja1105_tagger_data *tagger_data = dp->priv;
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(dp->ds);
 	void (*xmit_work_fn)(struct kthread_work *work);
 	struct sja1105_deferred_xmit_work *xmit_work;
 	struct kthread_worker *xmit_worker;
@@ -368,10 +368,10 @@ static struct sk_buff
 	 */
 	if (is_link_local) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data = dp->priv;
+		struct sja1105_tagger_data *tagger_data;
+		struct dsa_switch *ds = dp->ds;
 
-		if (unlikely(!dsa_port_is_sja1105(dp)))
-			return skb;
+		tagger_data = sja1105_tagger_data(ds);
 
 		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 			/* Do normal processing. */
@@ -382,7 +382,7 @@ static struct sk_buff
 		 * that we were expecting?
 		 */
 		if (tagger_data->stampable_skb) {
-			dev_err_ratelimited(dp->ds->dev,
+			dev_err_ratelimited(ds->dev,
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
@@ -406,11 +406,11 @@ static struct sk_buff
 	 */
 	} else if (is_meta) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data = dp->priv;
+		struct sja1105_tagger_data *tagger_data;
+		struct dsa_switch *ds = dp->ds;
 		struct sk_buff *stampable_skb;
 
-		if (unlikely(!dsa_port_is_sja1105(dp)))
-			return skb;
+		tagger_data = sja1105_tagger_data(ds);
 
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
@@ -427,14 +427,14 @@ static struct sk_buff
 		 * that we were expecting?
 		 */
 		if (!stampable_skb) {
-			dev_err_ratelimited(dp->ds->dev,
+			dev_err_ratelimited(ds->dev,
 					    "Unexpected meta frame\n");
 			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
 		}
 
 		if (stampable_skb->dev != skb->dev) {
-			dev_err_ratelimited(dp->ds->dev,
+			dev_err_ratelimited(ds->dev,
 					    "Meta frame on wrong port\n");
 			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
@@ -543,20 +543,14 @@ static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 					u8 ts_id, enum sja1110_meta_tstamp dir,
 					u64 tstamp)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct sja1105_tagger_data *tagger_data;
 	struct skb_shared_hwtstamps shwt = {0};
 
-	if (!dsa_port_is_sja1105(dp))
-		return;
-
 	/* We don't care about RX timestamps on the CPU port */
 	if (dir == SJA1110_META_TSTAMP_RX)
 		return;
 
-	tagger_data = dp->priv;
-
 	spin_lock(&tagger_data->skb_txtstamp_queue.lock);
 
 	skb_queue_walk_safe(&tagger_data->skb_txtstamp_queue, skb, skb_tmp) {
@@ -737,11 +731,71 @@ static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	*proto = ((__be16 *)skb->data)[(VLAN_HLEN / 2) - 1];
 }
 
+static void sja1105_disconnect(struct dsa_switch_tree *dst)
+{
+	struct sja1105_tagger_data *tagger_data;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		tagger_data = dp->ds->tagger_data;
+
+		if (!tagger_data)
+			continue;
+
+		if (tagger_data->xmit_worker)
+			kthread_destroy_worker(tagger_data->xmit_worker);
+
+		kfree(tagger_data);
+		dp->ds->tagger_data = NULL;
+	}
+}
+
+static int sja1105_connect(struct dsa_switch_tree *dst)
+{
+	struct sja1105_tagger_data *tagger_data;
+	struct kthread_worker *xmit_worker;
+	struct dsa_port *dp;
+	int err;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
+		if (!tagger_data) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		/* Only used on SJA1110 */
+		skb_queue_head_init(&tagger_data->skb_txtstamp_queue);
+		spin_lock_init(&tagger_data->meta_lock);
+
+		xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
+						    dst->index, dp->ds->index);
+		if (IS_ERR(xmit_worker)) {
+			err = PTR_ERR(xmit_worker);
+			goto out;
+		}
+
+		tagger_data->xmit_worker = xmit_worker;
+		dp->ds->tagger_data = tagger_data;
+	}
+
+	return 0;
+
+out:
+	sja1105_disconnect(dst);
+	return err;
+}
+
 static const struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
 	.xmit = sja1105_xmit,
 	.rcv = sja1105_rcv,
+	.connect = sja1105_connect,
+	.disconnect = sja1105_disconnect,
 	.needed_headroom = VLAN_HLEN,
 	.flow_dissect = sja1105_flow_dissect,
 	.promisc_on_master = true,
@@ -755,6 +809,8 @@ static const struct dsa_device_ops sja1110_netdev_ops = {
 	.proto = DSA_TAG_PROTO_SJA1110,
 	.xmit = sja1110_xmit,
 	.rcv = sja1110_rcv,
+	.connect = sja1105_connect,
+	.disconnect = sja1105_disconnect,
 	.flow_dissect = sja1110_flow_dissect,
 	.needed_headroom = SJA1110_HEADER_LEN + VLAN_HLEN,
 	.needed_tailroom = SJA1110_RX_TRAILER_LEN + SJA1110_MAX_PADDING_LEN,
-- 
2.25.1

