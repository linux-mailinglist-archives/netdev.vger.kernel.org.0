Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE243CE891
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346193AbhGSQnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:43:25 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:25006
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355146AbhGSQf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLr0fvE/hUh6p0WioyqbKdI0SUWykbuNy0xioJOYBJJR9hDEN+ePNGboS20FAxmkcgcfm73T75pX+Utt4TwGR2pIwmBosLfIiiM1SQQar9re31vdBNfJ6+LVR2XhjvTRsBOj/U8O/94qED623Oesj0hXrqprJA5ZH0ZZL0kVfof79MYzLfKEZae4K/63PIX9CSyeA6tSCvk9ZfwpwlCxl7FwOkbHzoUtJfBUUKIhCiJamPddwMiluqc/znmMsSsb0+0B/cz5SVDt9bCGG4wl47/DATNS6e/T+je/yc+ZpXEYJvXvTC2U0TJZl6KTX+zk0SnCNbootb1nQFD8ZKX15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHYBsBCAgaiqdp7W5U2hsYTA+jRd5AgSicDx22hEKMI=;
 b=OqsaLlS9fmZYdtfFF0z/bM5udfuOE+wTfzk6xmGv2+UCTIV1XKdiZdUdluRA0Dv71eMJayUmNo6EszVzJ5UAREDzggbXB33qSsUHICKOD9aufHSbGLzB8lFqO+wavrZCJA4YveOGqwWzA1pq8sgrAt3hyyF3PLja/D0E/Hry+JWUWMtraRRPAFmRv6LuoQ7uEhg4UVDneug9BfwhaITaJFGNyIgHQ9eIBn+2lSUXJ6EugrRfLk8LDTgui5kyGfshbZXx5Q9i40MA0rjgSb98mhNmw1WRUJeKA9U+2dSSb55yg8lB0ultvYdRta+BN4MUZ9izlixCgm/rpS7UUyyEIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHYBsBCAgaiqdp7W5U2hsYTA+jRd5AgSicDx22hEKMI=;
 b=MKOu33dEhpuJB0lgWzZQVQS/nJ30SGTFS/YeJI6CxBikREDX+7fVse+E9WboTWnPMGoX6fBRodirFXimK4HC6Z5LwfL2ofQY1wZ4ih+Kj2ydvQPyZwD5v05OsCk5Ajm4WLgJcQZVjdUHLb/8+KOkk7DgwWwmuxQqtrhpzFlTGmM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 08/11] net: dsa: make tag_8021q operations part of the core
Date:   Mon, 19 Jul 2021 20:14:49 +0300
Message-Id: <20210719171452.463775-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43b2d8d1-e544-4e22-b412-08d94ad8e7ef
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34079EE46ABC3C930197667EE0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5bN5Vwzi3/7FbnLZuh8SOcyzgGzR3yCay6su+31Cr3Eb7sAeTit/SgCYZtrjuy6RyunD7kod0TC5hbawqkaEU+J3dwOhReEJ/WNF6viY8YfvUfQh/3TUTz/VSogDrYD4oZlL+KIF/9MAePgg0VCtolLcoD2bmcJF8q4Q6epHCD8hl2s7tx2SBuYmq2xnGi+CQhqZcvZbg5INzJskflDWf7bxVy/7B7vc4YYeInrZGkRjGfqFlUU+QQn8N/SagVOgHq5s2N+W0dTBIQc8CId+dZudfIEcsxA9A+LdYN5mIvW+dk7f0ycj+3hD+yPupLNIQTZapNc6k6lFYJS2zbgehafos17rP3l7P+pyCVSKs4ZV493e8zZTtbUtX9lYpDRzJjc+ioBFmBW0CxlsaT+MxiYF8RfLij2v1024AL8hXOEVwFpAaPqaEXpMneIr9OXYyTu0skKol23lJ21QKNxtANV2IPCzXWppi1PY9JouknGUwMHL2CftwJhTjiz5PYOoVOmc5mKl+i6FFjneBxVtRCg9ntl/knbjznVyviEDX39nWGrUaEyNmjM1K7ATNxLnrZGoWq2RxfjYAWyCC+WDg2L0C6UqtQ02/lsLrlK+YxdvGZPjKYKjjw03+287m0uQEeyOg8yCC/5yNrYSJaK6CY017J+TRzEtJK8PLpS8IpwlY7nQ5PfHebkRYX5ej7qKNbnFfhrSxy1Yv4LEovAqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XCLZkgMWZi/AgSioLsvf+gxXdUWrg2QLbiy5/fD8JEISMk85BX4btUwPIJYO?=
 =?us-ascii?Q?wOMPqvSlpCSgaBFBhL2CFf99iEBFSZBNJTTEJ1YyGhF6RNsSOXvByja9Z+dC?=
 =?us-ascii?Q?0iU8ZjANLuTUjnWxUUcU/wnaDvHFO4RmYs/UUgXciUi/+4//N/DHg/r5XfKB?=
 =?us-ascii?Q?uv/pz+nAYEv1Dtqql6m+DCaHvmYBfPVqwdiGuO8IOco9tYY+61LuBJGh61fO?=
 =?us-ascii?Q?WSMFUpfO9ZAiC5SJatB97djqt4X7qCoKVzp2GWf1oG4sKLFO7IwDe+ODiomq?=
 =?us-ascii?Q?GZJuY8Dy9fkGEiA3hVhAnlVqsaFspy820pqowE2nfQtyd4UqHgcdKukkYd7T?=
 =?us-ascii?Q?7Cubuw7MDxDC4hY3Pq1/XA+4KS3uPkGHjZ5Z/QodTkW3jxC2DMBQt8xMnLL0?=
 =?us-ascii?Q?RmN45KEJ0YASEaXSahfxtSRSL5NI62Bagtjx8OiKvgk8DGoIC/dnsve+F7J5?=
 =?us-ascii?Q?Z1gKzQw5t0n4n/l3GOpeRv7ar52Nqt/tkzM0ukc78Hs3ssQHB40R65aS6j3G?=
 =?us-ascii?Q?G4UE3/CQX5yY4yEXjGV3D5vV9ZmZcKQO5MdS6M1zIP2mkMDve7CNkM6Xdr72?=
 =?us-ascii?Q?I1Nm3RnxDPm7NF9E/Yh6w9zWU7/+VGXz0aQ9QbrsAaGMNy6GOCiJxcGyxhc+?=
 =?us-ascii?Q?ahaIB1xhDyeaoId+c8iyAPqhe8JFRpgTAuQoOUIRszAdmVYUcO6DEvQaEyUC?=
 =?us-ascii?Q?JeMvLYMf0k7vKO66gJWrEZ53G/d1prhpbRwk7lfzwPoqxeqkLwxVCsFkx/p8?=
 =?us-ascii?Q?b3dwgwU6b01EcllM3j78D4wvUc/t8HoAwJNso68JijOMNGc/kNG9m0JrAZAN?=
 =?us-ascii?Q?GVGkcSXL27tlFXO9ImNd0W1yfevUKmRq+aTi7ox2pkgn1OIiygL/GlKuUy1+?=
 =?us-ascii?Q?wOqqmN3oj9lWV7JCJU/+mvZK8Bw3pxhb8ldEs7Y5bJhGpc5Wlv5wNbiPvXfX?=
 =?us-ascii?Q?Nq4CLP5SXScK8IQk77ZZtws6NLQ/FePpvcDqyzDwzvhPMnm02nQ6BvsiMMOD?=
 =?us-ascii?Q?l3mveiMdJ3YpO6hEywwlh0Sdh1xFd/lpNXuDsn2N1WA+PG0lP2Mzx1vIMZ9B?=
 =?us-ascii?Q?ZhOj4RTx7e5niuvwnPc101iMKKSlD3mg2Jt0CEdAPR1GnhnLZMjfGtvTRoQ4?=
 =?us-ascii?Q?tds+9WYzvgZwtZ5cTOdrNrcXMUnxZ1lkCvNWXh1FOz+PRcefu6h/hvAJU9s5?=
 =?us-ascii?Q?zBrBjQDsVGWHT8Map09a/ZLkQpS3L2XafLoIOhpLIRziQMq4VEMVV5XAxTun?=
 =?us-ascii?Q?a/yiErE6nRDJ9WfDhzFHvVjM11V8SkJMaBK4Id5bJiKv82c81t3O+9XxYwQe?=
 =?us-ascii?Q?DrY7Z7SepTZMZXgkp836nLdE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b2d8d1-e544-4e22-b412-08d94ad8e7ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:11.6102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nPQCjC+PS2rr5Ka7YgEkkUS96Ft59ayh5dxPX1YAcdyQaT2QqmbIgdEd3FHYIewatZ239flTo9vz83pbuJ00w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make tag_8021q a more central element of DSA and move the 2 driver
specific operations outside of struct dsa_8021q_context (which is
supposed to hold dynamic data and not really constant function
pointers).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 10 +++-------
 drivers/net/dsa/sja1105/sja1105_main.c | 10 +++-------
 include/linux/dsa/8021q.h              | 10 +---------
 include/net/dsa.h                      |  7 +++++++
 net/dsa/tag_8021q.c                    | 10 +++-------
 5 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9e4ae15aa4fb..b6ab28d2f155 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -231,11 +231,6 @@ static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 	return 0;
 }
 
-static const struct dsa_8021q_ops felix_tag_8021q_ops = {
-	.vlan_add	= felix_tag_8021q_vlan_add,
-	.vlan_del	= felix_tag_8021q_vlan_del,
-};
-
 /* Alternatively to using the NPI functionality, that same hardware MAC
  * connected internally to the enetc or fman DSA master can be configured to
  * use the software-defined tag_8021q frame format. As far as the hardware is
@@ -425,8 +420,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
-	err = dsa_tag_8021q_register(ds, &felix_tag_8021q_ops,
-				     htons(ETH_P_8021AD));
+	err = dsa_tag_8021q_register(ds, htons(ETH_P_8021AD));
 	if (err)
 		return err;
 
@@ -1675,6 +1669,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_mrp_del			= felix_mrp_del,
 	.port_mrp_add_ring_role		= felix_mrp_add_ring_role,
 	.port_mrp_del_ring_role		= felix_mrp_del_ring_role,
+	.tag_8021q_vlan_add		= felix_tag_8021q_vlan_add,
+	.tag_8021q_vlan_del		= felix_tag_8021q_vlan_del,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ac4254690a8d..0c04f6caccdf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2543,11 +2543,6 @@ static int sja1105_dsa_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 	return sja1105_build_vlan_table(priv, true);
 }
 
-static const struct dsa_8021q_ops sja1105_dsa_8021q_ops = {
-	.vlan_add	= sja1105_dsa_8021q_vlan_add,
-	.vlan_del	= sja1105_dsa_8021q_vlan_del,
-};
-
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -3153,6 +3148,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
 	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 	.devlink_info_get	= sja1105_devlink_info_get,
+	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
+	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
 };
 
 static const struct of_device_id sja1105_dt_ids[];
@@ -3296,8 +3293,7 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	rc = dsa_tag_8021q_register(ds, &sja1105_dsa_8021q_ops,
-				    htons(ETH_P_8021Q));
+	rc = dsa_tag_8021q_register(ds, htons(ETH_P_8021Q));
 	if (rc)
 		return rc;
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 77939c0c8dd5..0bda08fb2f16 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -21,22 +21,14 @@ struct dsa_8021q_crosschip_link {
 	refcount_t refcount;
 };
 
-struct dsa_8021q_ops {
-	int (*vlan_add)(struct dsa_switch *ds, int port, u16 vid, u16 flags);
-	int (*vlan_del)(struct dsa_switch *ds, int port, u16 vid);
-};
-
 struct dsa_8021q_context {
-	const struct dsa_8021q_ops *ops;
 	struct dsa_switch *ds;
 	struct list_head crosschip_links;
 	/* EtherType of RX VID, used for filtering on master interface */
 	__be16 proto;
 };
 
-int dsa_tag_8021q_register(struct dsa_switch *ds,
-			   const struct dsa_8021q_ops *ops,
-			   __be16 proto);
+int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto);
 
 void dsa_tag_8021q_unregister(struct dsa_switch *ds);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e213572f6341..9e5593885357 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -872,6 +872,13 @@ struct dsa_switch_ops {
 					  const struct switchdev_obj_ring_role_mrp *mrp);
 	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
 					  const struct switchdev_obj_ring_role_mrp *mrp);
+
+	/*
+	 * tag_8021q operations
+	 */
+	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
+				      u16 flags);
+	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index de46a551a486..4a11c5004783 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -116,13 +116,12 @@ EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 			       u16 flags, bool enabled)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (enabled)
-		return ctx->ops->vlan_add(ctx->ds, dp->index, vid, flags);
+		return ds->ops->tag_8021q_vlan_add(ds, dp->index, vid, flags);
 
-	return ctx->ops->vlan_del(ctx->ds, dp->index, vid);
+	return ds->ops->tag_8021q_vlan_del(ds, dp->index, vid);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
@@ -413,9 +412,7 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_leave);
 
-int dsa_tag_8021q_register(struct dsa_switch *ds,
-			   const struct dsa_8021q_ops *ops,
-			   __be16 proto)
+int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 {
 	struct dsa_8021q_context *ctx;
 
@@ -423,7 +420,6 @@ int dsa_tag_8021q_register(struct dsa_switch *ds,
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->ops = ops;
 	ctx->proto = proto;
 	ctx->ds = ds;
 
-- 
2.25.1

