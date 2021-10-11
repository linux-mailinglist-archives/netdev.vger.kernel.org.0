Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FAD4298DA
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbhJKV2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:46 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:23262
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235277AbhJKV2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5wKryjeTLoSliM/fWydzkp3n0b/8tq5UqKVzRfSCUH7mR7oa23BCTmOLEQqFClIlDhwF+ypm8JklztSx8MX8ryIT4IAjgq6XEdffp9c4Msx9WO90uhfNM54MqBJwPe0KwfjrErzmj9LkNUX6leXrG2ad6sktKzstqeYrVItivK+cB809HS9n2zhJfh3+J1+f+uuvXmq/P8cJSCN9IS8UjGW/FK7VLsB7J/leX+v85yD7aAKfniujMQjr46bP4ZAOHgs7hKGGXpJd7khwYATSx9ZN20ksuUVdJcMHJMTPJXCFbrVpG7P8vm+HEsyvg72fVJ5wTAr1zydxwcHj1m8pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyIyxquXfBU/O/cIIwDZEk1nWnfmn0Ref1uZ285fvxo=;
 b=ZnMi7GmS8hC9I2b9ObrwWtYBdzqUnWh7L1XRyxXlUDqZNLc/k6hfXkPnZbGwj+toNDfp+CUe3pAp5mygp1Pof53Put7h+9ZqFvoNOF3veyBLnwEqVro8PHO53VDzVSDD511dB/gUKSo9G/drrmprAG6cq1VbQuOJ7v761G9tsH2Wa5nIST7pseBZhFyez1Um1vwaSe3ic5jvNAShDUAR5uG0/3EVHmeqapayXjlsg4eh9T154tbZm+MRbrZJFo6fGshSjVDHGVub8DA9J/gVxxXyPFjAZHsxmQG1SnqDo1nYwHFVEQqkWH5TjPQok7hDCv0dY4hxo8WbLoUVg2k6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyIyxquXfBU/O/cIIwDZEk1nWnfmn0Ref1uZ285fvxo=;
 b=CU23kynyGPJXwKFZl4aJBwd8i7UoJkc4syOATkhXQzz3AlDx6tIjLi+FkN9Qo8R17CIb+rFg8eP9wLqU6WfeXo9htuSIA7RzkkGHwPHdeTQtmHCcOVyXXIW/CUJgrg0O/XpC76gjxXDsSyf+FCIqlFKelB1S4brsGYPot3UA+P0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 21:26:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 07/10] net: dsa: tag_ocelot_8021q: break circular dependency with ocelot switch lib
Date:   Tue, 12 Oct 2021 00:26:13 +0300
Message-Id: <20211011212616.2160588-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8ac4183-fe4e-433d-70fe-08d98cfdcf2a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910F079BC2033997F494447E0B59@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PCRRzU7zCO6taFyIITSm1UaNN/jmxOtrzni2+Zt4tqGVIkrxyglfGZOr5s1EEXFsXVii7DI6nU68+tFeryx7e7dZ5ZvNl2yDHd5Icg8kpyl2dKVYlQrwmhx8vLrweQJo/gHtLvCYtLq/Rl2RMuEZrds7zVcIWjUkGKlwnHjpbpJdGrpfe2TGqWELk92LJXm+htvtu3/fG6GtFpaViInxVGAkQNsTIVMEmVM63avMTVCCRWbuQpjlw48eiJ5zIu5otGH8EHdZm9ODY4TtMklNBVLiaEH0VFNKtfL9EQVCcqrPYlQDLzro95e6muukuE24TRLRycsc/KLNUmG4hDiQBlJGPQBb0v2ns8VigAAvMS7KwP3Kt9ICrVIWgwPo3hCbUkRDdJvJS4YKWdAMXInlYHhSzEJOiweHr47L30gsb+0fpDBXfcApVlVXkvhdfQP5UvB1n7pJnpiClgC6mvvhKB5DqW5fmmjHfGWI6Dl1zoO0ftUID9Hpht1pR/uJ8X9mAIccb+d/GlpLijTy//e5SP8m/e8ZzIdfyRqa3zKCDFH1KnWfDHNXSPJjA51rd4MwoSsJUc6VeVwf2yRpw4uDhdB2FYnVXtieMLWEOuBTmbXYevyB5EuKJieFMxuwO2cHgsTBqZVo+rpQoXlx2hWJPqoBnbexGCPM6V3FqUBkNuDb6R950EN+OxCjoAcBpUbVAhLzsO0ffS0hz1HGjbJcD24zHXMfVkJ00V9MjmMEtehvhGziUyx4omTbec3ytTg5WLFOm3MsvV5qCjz+IJhiVTkjb6eVtSLDmjmHZoq1ws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(8936002)(8676002)(66476007)(44832011)(66556008)(66946007)(54906003)(110136005)(52116002)(26005)(6486002)(5660300002)(508600001)(4326008)(6506007)(956004)(38350700002)(1076003)(6666004)(36756003)(6512007)(86362001)(38100700002)(30864003)(6636002)(83380400001)(316002)(2616005)(7416002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PdmYXOCny/YCRzxBBcpUtq05+tFOU5+SML6ldXZtMJ+MMeN/xx64OLPHRLhK?=
 =?us-ascii?Q?33kWJ4Jivh3XcdUMkqkr6ygK0J3ourWRhKKiZ7TeFoeasTdTdE0uIN39QErw?=
 =?us-ascii?Q?AkHnxa8GNWElqXZWOAq41+5bxlgrisJd1g/Z6s3ZMWqZhCu2MS1lRUP3Qxqk?=
 =?us-ascii?Q?0M29Li2H3FAC3J/R+PWZ6uf8oWlqeWxfpIWXDcKjWY2o/CnTvuQc2imgVV14?=
 =?us-ascii?Q?HS+4KIRP+DD5Tp8p0+EoV/ghNnMsjG1cypNZ3afQpHBr/5FPEe6lb3/K9nFe?=
 =?us-ascii?Q?InNKAG/2mxhnlRXbNGfl68xa0Fi+rOfnSSHw0KpV/VikKHebWgBDD+IUpJUw?=
 =?us-ascii?Q?uZaQJtQQIXZdvr/sKvJZrSYAyiT5SdrV2px/biSKvPchB3CW6vnRUiII6rpO?=
 =?us-ascii?Q?u3EjM/44lpfw3WPx5lEc7LA1ixbe4WZ5rBB947bOKL24e3EUDJyFqWMNZVA7?=
 =?us-ascii?Q?YELzETFx4I4dQjCIpqaUaIdSu3DpkOBFMG79ENYZKWKazyZBaSngf+obZv2J?=
 =?us-ascii?Q?Uq2kl4TKdMzEe9Yueu2SbT7s85SFuu5E1syTeaM2Arm0Xa2j96+f31f4nVlP?=
 =?us-ascii?Q?G7/lSxfHYMqRt6W74gtTpbfV8Mb1kC2wyJHMMxMNr6sPh45v9hHOkgALoI9n?=
 =?us-ascii?Q?JUj+xYHdvqLTqJWQGE0r8I45EKB/KbNgYmQA5OHuMJcXUE0oBlEhmSJMmRa/?=
 =?us-ascii?Q?+BA27ROGukcDQdrK5SPVAWJFlA2fAs3d4xxJV8ECWAd43gLfWnfZt0ywANF7?=
 =?us-ascii?Q?sXygAmMJu2xwTqAMkCqfKDSTlVgwk9jpQckN/vOjam8/mkzkm/MTOEq4sywe?=
 =?us-ascii?Q?dzsCms/2g4IzKodYsNv49IVf50vGoxUDNpTM4E4zeqPkge5cxAJoJZ94zc8r?=
 =?us-ascii?Q?91OZGsS6QoUCLEHm/gSJ2SVm3hIUYMQAu6l0lZ6e/M2JOpuQC2BQEAiuMeYI?=
 =?us-ascii?Q?8xc4uH8cTc5r5XhgOFVrLpqB+0kOnjr/UVRTmBMvkZfE6u+pqdGms7jm+06M?=
 =?us-ascii?Q?KgXmBp8+OZF/j/iogt1v27w0QXwtxEKVNnn+7nhJr4ATBcvhYZpOyP6bq1FU?=
 =?us-ascii?Q?mM35MzYIsKfDjYIH5G6lw80SYQcb6OAJgrWxd8siERJ+M4cLBEt0NZKdui6f?=
 =?us-ascii?Q?Y4cHLH9MIfgPFie2zfo2jAe7GvFNqvG1C6N0UDI7yiIlrFuF+96Q6EvUr4pV?=
 =?us-ascii?Q?eBGaaUSyFyjhZG2UBhevsyV3ib+ewXI4Y+SQb6i5ddus3A0/kaFJUlXV2mLT?=
 =?us-ascii?Q?41jIMyUuFsAJqYJZmBlxfe1IHZrNuuNZC8JKJzNzPN3siIbN52/lOqZdIvqJ?=
 =?us-ascii?Q?jT4f9CHbou8v9uPhMZtR/jPb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ac4183-fe4e-433d-70fe-08d98cfdcf2a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:38.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OI+8uzQptxS0AClihMsXDraxCyR/ISa6NNXBC2DDVS4xvz7mfHypQtO/igsTRbCwoKtvNw7cxtLncL14Ti7+dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael reported that when using the "ocelot-8021q" tagging protocol,
the switch driver module must be manually loaded before the tagging
protocol can be loaded/is available.

This appears to be the same problem described here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
where due to the fact that DSA tagging protocols make use of symbols
exported by the switch drivers, circular dependencies appear and this
breaks module autoloading.

The ocelot_8021q driver needs the ocelot_can_inject() and
ocelot_port_inject_frame() functions from the switch library. Previously
the wrong approach was taken to solve that dependency: shims were
provided for the case where the ocelot switch library was compiled out,
but that turns out to be insufficient, because the dependency when the
switch lib _is_ compiled is problematic too.

We cannot declare ocelot_can_inject() and ocelot_port_inject_frame() as
static inline functions, because these access I/O functions like
__ocelot_write_ix() which is called by ocelot_write_rix(). Making those
static inline basically means exposing the whole guts of the ocelot
switch library, not ideal...

We already have one tagging protocol driver which calls into the switch
driver during xmit but not using any exported symbol: sja1105_defer_xmit.
We can do the same thing here: create a kthread worker and one work item
per skb, and let the switch driver itself do the register accesses to
send the skb, and then consume it.

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 97 ++++++++++++++++++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h |  1 +
 include/linux/dsa/ocelot.h     | 12 +++++
 include/soc/mscc/ocelot.h      | 27 ----------
 net/dsa/Kconfig                |  2 -
 net/dsa/tag_ocelot_8021q.c     | 38 ++++++++-----
 6 files changed, 131 insertions(+), 46 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 50ef20724958..e885b166a3f8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1074,6 +1074,73 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
+#define work_to_xmit_work(w) \
+		container_of((w), struct felix_deferred_xmit_work, work)
+
+static void felix_port_deferred_xmit(struct kthread_work *work)
+{
+	struct felix_deferred_xmit_work *xmit_work = work_to_xmit_work(work);
+	struct dsa_switch *ds = xmit_work->dp->ds;
+	struct sk_buff *skb = xmit_work->skb;
+	u32 rew_op = ocelot_ptp_rew_op(skb);
+	struct ocelot *ocelot = ds->priv;
+	int port = xmit_work->dp->index;
+	int retries = 10;
+
+	do {
+		if (ocelot_can_inject(ocelot, 0))
+			break;
+
+		cpu_relax();
+	} while (--retries);
+
+	if (!retries) {
+		dev_err(ocelot->dev, "port %d failed to inject skb\n",
+			port);
+		kfree_skb(skb);
+		return;
+	}
+
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+
+	consume_skb(skb);
+	kfree(xmit_work);
+}
+
+static int felix_port_setup_tagger_data(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct felix_port *felix_port;
+
+	if (!dsa_port_is_user(dp))
+		return 0;
+
+	felix_port = kzalloc(sizeof(*felix_port), GFP_KERNEL);
+	if (!felix_port)
+		return -ENOMEM;
+
+	felix_port->xmit_worker = felix->xmit_worker;
+	felix_port->xmit_work_fn = felix_port_deferred_xmit;
+
+	dp->priv = felix_port;
+
+	return 0;
+}
+
+static void felix_port_teardown_tagger_data(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct felix_port *felix_port = dp->priv;
+
+	if (!felix_port)
+		return;
+
+	dp->priv = NULL;
+	kfree(felix_port);
+}
+
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -1102,6 +1169,13 @@ static int felix_setup(struct dsa_switch *ds)
 		}
 	}
 
+	felix->xmit_worker = kthread_create_worker(0, "%s_deferred_xmit",
+						   dev_name(ds->dev));
+	if (IS_ERR(felix->xmit_worker)) {
+		err = PTR_ERR(felix->xmit_worker);
+		goto out_deinit_timestamp;
+	}
+
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
@@ -1112,6 +1186,14 @@ static int felix_setup(struct dsa_switch *ds)
 		 * bits of vlan tag.
 		 */
 		felix_port_qos_map_init(ocelot, port);
+
+		err = felix_port_setup_tagger_data(ds, port);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to set up tagger data: %pe\n",
+				port, ERR_PTR(err));
+			goto out_deinit_ports;
+		}
 	}
 
 	err = ocelot_devlink_sb_register(ocelot);
@@ -1138,9 +1220,13 @@ static int felix_setup(struct dsa_switch *ds)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
+		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
+	kthread_destroy_worker(felix->xmit_worker);
+
+out_deinit_timestamp:
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
@@ -1164,17 +1250,20 @@ static void felix_teardown(struct dsa_switch *ds)
 		felix_del_tag_protocol(ds, port, felix->tag_proto);
 	}
 
-	ocelot_devlink_sb_unregister(ocelot);
-	ocelot_deinit_timestamp(ocelot);
-	ocelot_deinit(ocelot);
-
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
+		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
+	kthread_destroy_worker(felix->xmit_worker);
+
+	ocelot_devlink_sb_unregister(ocelot);
+	ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
+
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 }
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 54024b6f9498..be3e42e135c0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -62,6 +62,7 @@ struct felix {
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
+	struct kthread_worker		*xmit_worker;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 50641a7529ad..8ae999f587c4 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -5,6 +5,7 @@
 #ifndef _NET_DSA_TAG_OCELOT_H
 #define _NET_DSA_TAG_OCELOT_H
 
+#include <linux/kthread.h>
 #include <linux/packing.h>
 #include <linux/skbuff.h>
 
@@ -160,6 +161,17 @@ struct ocelot_skb_cb {
  *         +------+------+------+------+------+------+------+------+
  */
 
+struct felix_deferred_xmit_work {
+	struct dsa_port *dp;
+	struct sk_buff *skb;
+	struct kthread_work work;
+};
+
+struct felix_port {
+	void (*xmit_work_fn)(struct kthread_work *work);
+	struct kthread_worker *xmit_worker;
+};
+
 static inline void ocelot_xfh_get_rew_val(void *extraction, u64 *rew_val)
 {
 	packing(extraction, rew_val, 116, 85, OCELOT_TAG_LEN, UNPACK, 0);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 66b2e65c1179..d7055b41982d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -737,8 +737,6 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset);
 
-#if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)
-
 /* Packet I/O */
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
@@ -746,31 +744,6 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-#else
-
-static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
-{
-	return false;
-}
-
-static inline void ocelot_port_inject_frame(struct ocelot *ocelot, int port,
-					    int grp, u32 rew_op,
-					    struct sk_buff *skb)
-{
-}
-
-static inline int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
-					struct sk_buff **skb)
-{
-	return -EIO;
-}
-
-static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
-{
-}
-
-#endif
-
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 208693161e98..31d056d56f87 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -112,8 +112,6 @@ config NET_DSA_TAG_OCELOT
 
 config NET_DSA_TAG_OCELOT_8021Q
 	tristate "Tag driver for Ocelot family of switches, using VLAN"
-	depends on MSCC_OCELOT_SWITCH_LIB || \
-	          (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	help
 	  Say Y or M if you want to enable support for tagging frames with a
 	  custom VLAN-based header. Frames that require timestamping, such as
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 1e4e66ea6796..d05c352f96e5 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -10,10 +10,31 @@
  */
 #include <linux/dsa/8021q.h>
 #include <linux/dsa/ocelot.h>
-#include <soc/mscc/ocelot.h>
-#include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
 
+static struct sk_buff *ocelot_defer_xmit(struct dsa_port *dp,
+					 struct sk_buff *skb)
+{
+	struct felix_deferred_xmit_work *xmit_work;
+	struct felix_port *felix_port = dp->priv;
+
+	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
+	if (!xmit_work)
+		return NULL;
+
+	/* Calls felix_port_deferred_xmit in felix.c */
+	kthread_init_work(&xmit_work->work, felix_port->xmit_work_fn);
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	xmit_work->dp = dp;
+	xmit_work->skb = skb_get(skb);
+
+	kthread_queue_work(felix_port->xmit_worker, &xmit_work->work);
+
+	return NULL;
+}
+
 static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
@@ -21,18 +42,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
-	struct ocelot *ocelot = dp->ds->priv;
-	int port = dp->index;
-	u32 rew_op = 0;
 
-	rew_op = ocelot_ptp_rew_op(skb);
-	if (rew_op) {
-		if (!ocelot_can_inject(ocelot, 0))
-			return NULL;
-
-		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
-		return NULL;
-	}
+	if (ocelot_ptp_rew_op(skb))
+		return ocelot_defer_xmit(dp, skb);
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
 			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
-- 
2.25.1

