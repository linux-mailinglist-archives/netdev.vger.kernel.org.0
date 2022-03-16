Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D099F4DB99F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358044AbiCPUnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357969AbiCPUnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:14 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30072.outbound.protection.outlook.com [40.107.3.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC726E35E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:41:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwE8o2uhpmivNGsJjpJmuWEZTBnfcCrGQsIMUIFQSbOW00tfRf1J33hlDkYWa+sM/o/Cg8Pp2kDCHiypnYKkj03pV4HkXUuvhvAGPssfPdx52BmfvXaeVOTdF/7u+f9EQa4xwt9Rcbv+h2rSg6D6PF7ilbXKYPhKps1ljJk4Fvif2KoGclPksgf+v4kj9S/PsQqPz9JnBiJp7bs/oEYptfajygbT+OhOM8tVAcBYRubTjz5/GbC14v4zLwqGaV+w9QI3YrOl+/LyRdoTzS+xYWkasf/rr/KgkNjt9Q0YFvLdBDen4BfrcRDQzYA1B1ziFvdWOKfCDNlDOEZXltwflQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zkg3r5gCL+Me9G1/cwyESYVVCIjnNPZ2VHBzIX0pcCM=;
 b=f6a3dhhUdxtXNsWXo6xW9mn9im1SHXcrVW4SSnxMxI0ZNpoxPcrksnjtvySWwE/IN3Nt5KXGMGenfWVrwuFRmHtMICI2WeSpkjQluQAi+MH6JLNnRXD82Zefp1y453IpM5B1PZtW1K0QQAqc2SwJB9VbNXjT39HtBmm5qsyucG7PprDYbNHvv6bXV0aS09icF3kLV5vQ8mHEp1tQ8nqeRhgFwFhC58eThowxjzTZ/14qGzEemc0m7OBICRJlnyqoZPVQz9T37gkv0UEp+WiXiO5H83pX1PlZLwvMFG8chawyk5sdn3xkGPLbq6wE73vQDxIgmx5Qrt2TwqyTWp4xoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zkg3r5gCL+Me9G1/cwyESYVVCIjnNPZ2VHBzIX0pcCM=;
 b=Wro5tGopSp/8/D9ilf1jVE3RkxIAsG+nD0a5ZHYNlQpDI9Mvm9yqYx/jEMIaQ01rzlIU5jsnAjQGnB8r/qc8/CAK5b6aSq2XQ0lz2Ltmz30NWV5kubGJnmwyjj4b1eA0tTyZKjjnp7SSnUo+w0dQ7BAu8PZpgZRnmswFU3MrAnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8398.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 20:41:55 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:41:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/6] net: mscc: ocelot: add port mirroring support using tc-matchall
Date:   Wed, 16 Mar 2022 22:41:40 +0200
Message-Id: <20220316204144.2679277-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ca1c419-b957-4900-0240-08da078d68b6
X-MS-TrafficTypeDiagnostic: AM9PR04MB8398:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB8398D574FCECE94AD010F512E0119@AM9PR04MB8398.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgcPAv9Hg6Owvl2N/SwSn4Z7rb/LxdCBOCnbRJGowu0fvyoS/HnBM2H///9BKVnxvIm+W98tikaJ5imehnjHJoA44SRg35gwxE+/4m6prT39POsUlvXVOk6/gP34W0cU0pQH3qD76ggRb1wraBkSQQac0oUO9Z8qO3YhAjC5B8K+j6vjmgMS0mze4B6qgTmKzphmzjVDbWNj/p5kP5A6USqUKVPe7hWbMDFsKa9sB95g8ir6XFOP4wtMz08ob+ZHu/80nMm+2vXME3VMX/lB/xmb7m1HVWS7xelRYOqFh8mgTuD9T3uVnUqrRSx5rHpCQ5segDVjJkGCXtDd5PHg/RBAdlfB5yADrU5BkIKKJFq5Emi8VkTTKG8oUalhtLt1XhaoqE6Qq3gmSti0zVITDRnvCT5M8ZmOesgcuAaItWLgIefqk0FdBe6Orohd1Sbjw6XOhxvmCl3GDw66ragW8VPsl0ZI5mRsz6WUd0rKrKSLYEixo5u0POud3nTMY6gKv7MSnkvPMWBFRB8k4L5ZQyeX4TzJq7MTa6X61FemAkzV7M9Q6V4pn92xgyaU8MIWNKLAVztwwyz+SVnBaJ+oz6Z6A3PglQXDVbPa9nZ4KH451bEJLHWXr8jlwMiTNFBHLbt9VIJYiSm6f6N91CnVnwYI0mDk4OWj3+kTIstCgyOgUfVX+gxTvc7V2xPmIF1VUIxozJjjkdP78QB8n1U6Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(6916009)(54906003)(4326008)(6666004)(8676002)(26005)(186003)(86362001)(316002)(44832011)(36756003)(6486002)(38350700002)(66556008)(5660300002)(83380400001)(66946007)(66476007)(2616005)(6512007)(1076003)(508600001)(52116002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2q43ToYZsE/kbhT1fGKkO6i6Lnzf7YbNGBPYxngDy4tINyq31ZlSW2dajs0G?=
 =?us-ascii?Q?LgAeueno5DK926lJMUF3c5a2bMUfZoAyx3fkwnUQtUhzBWTmDZb3cTVjVqvb?=
 =?us-ascii?Q?4i96TN3sFFvqmYF8doUh7FRLsYvOz59Sml2Myexlfq6vkcvV2c/iY9ohY4ry?=
 =?us-ascii?Q?fmzVp17MUlA16zMq87AXjqIWl03tdremSYs1c4KUYBYWe6N8fJT69Uk5iXuF?=
 =?us-ascii?Q?aLkGwChqp7AgSqpdlfMJ7vytOfmBl3TEY1s/WDaFUg4NgjF6V+8wUqcu/Fl2?=
 =?us-ascii?Q?HIGicgVUIPAh5IbpzKInVNyKtEDHhfmywkyLuuBfYBChFp5mlpCIL1K3Go8d?=
 =?us-ascii?Q?Bem37VyWLZsWecR1oAMAGuiI3oosWIokWUYbpS+D7T+JZpbSSdrFPY3Yq3qH?=
 =?us-ascii?Q?QDM2x7RE2RH9/KQNYDfhPHyCK34K6ZmMA+25V3emjFo71mXUdR8y/6pvjJm8?=
 =?us-ascii?Q?zK6IJ1of7rlHcz9l4yu6Pah/9eNbKXz8k4FGPnHHJ7wU7ba1OOi4k3RwJ+8k?=
 =?us-ascii?Q?ZE/3CklWtFLefrFPXsjnPx38Nclqsc7sl+/7P8Qf5kNo9xEAsCuo1Q/FtrEd?=
 =?us-ascii?Q?O+Y3IoaF42Z8MYKEi+zaVedPKo0l8RgcaAN49uRUaRr7RSN47uMzGAtONs5V?=
 =?us-ascii?Q?EATm5pugAU9ZDyhSzxZBb35UrP6b+V6QG+U2CiMTuqew3q1axDl3TAvlbJ0c?=
 =?us-ascii?Q?f62NXlFSP/pWbSKVolkLjsTaLUPN0EtAThFJjaizUTmDFDGvFPDIV7OKn+c3?=
 =?us-ascii?Q?b1IfL55dUDj4yR5B/90r4xzaoJU8/egBkT+ghFPs4OTL1qJuEqYTpo0Z76rU?=
 =?us-ascii?Q?9685+LpdopVnz4jyKLyxuVRKILxehSCFL9NYXTOzWX4W5msAzn855z2a8FfO?=
 =?us-ascii?Q?3NzW4C3QuP1SplPJ1QYmQpc0Y8GPcEV68PwpEeFe5RALCsonSR0EaeSz8G2I?=
 =?us-ascii?Q?Jo/SiWU9ALLltlkqy5oLEvx4LqDVsSFMsjyDSJWd9CHk3HifAu4TSSA1QiRZ?=
 =?us-ascii?Q?oCqv7UQjbfCadxY/USFNDgM1z4GwAR75bNj//SZIaVhuS90oMrHKF3ZSixal?=
 =?us-ascii?Q?VSN5tXPs7IlCi5h8C7PWrfF4oy3Q6J0KzkroJ5Gqfe4VEH9mRIWjn877eAPZ?=
 =?us-ascii?Q?67Woc7diLtCbiQFT95RByHZSbOAhDyktGfyJEIAMjaYxkhnc7mDAz9R7GAbg?=
 =?us-ascii?Q?B97T8TVbos7QfrWXN1FYIyXScNBqnduxiLWVBtgaO8kRuozcWrR4MSlLAHWb?=
 =?us-ascii?Q?yDaghyH1Fb4WP5un1Nvju1iN7jQT/U9EKdATzPCsSa9wr0ORvlhAaxftOo+Y?=
 =?us-ascii?Q?VRZBZWpR4bANf+k8RiFejEsRqE62CnQ75nOzC1N2QnMRvaGe3UkX1fP6JoGq?=
 =?us-ascii?Q?t6zngbRMK9GWf1zsCP8BqM1uZx8Y6EHVBKDhnunTCJAAT/F51TpqbgC9vf+j?=
 =?us-ascii?Q?0ku4AFc7FkPsDttQdCGMy+y1KviZEgJ06IZG9FR7uRe3LNX27ilgng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca1c419-b957-4900-0240-08da078d68b6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:55.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XenGyXoJlTpWMEftyXJDa3JRHieGA3PMX0tevGPK8QdWACPWDPvT53iBm/H2YjDR7R1Q6AejAXsRn9Vu9YbMQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches perform port-based ingress mirroring if
ANA:PORT:PORT_CFG field SRC_MIRROR_ENA is set, and egress mirroring if
the port is in ANA:ANA:EMIRRORPORTS.

Both ingress-mirrored and egress-mirrored frames are copied to the port
mask from ANA:ANA:MIRRORPORTS.

So the choice of limiting to a single mirror port via ocelot_mirror_get()
and ocelot_mirror_put() may seem bizarre, but the hardware model doesn't
map very well to the user space model. If the user wants to mirror the
ingress of swp1 towards swp2 and the ingress of swp3 towards swp4, we'd
have to program ANA:ANA:MIRRORPORTS with BIT(2) | BIT(4), and that would
make swp1 be mirrored towards swp4 too, and swp3 towards swp2. But there
are no tc-matchall rules to describe those actions.

Now, we could offload a matchall rule with multiple mirred actions, one
per desired mirror port, and force the user to stick to the multi-action
rule format for subsequent matchall filters. But both DSA and ocelot
have the flow_offload_has_one_action() check for the matchall offload,
plus the fact that it will get cumbersome to cross-check matchall
mirrors with flower mirrors (which will be added in the next patch).

As a result, we limit the configuration to a single mirror port, with
the possibility of lifting the restriction in the future.

Frames injected from the CPU don't get egress-mirrored, since they are
sent with the BYPASS bit in the injection frame header, and this
bypasses the analyzer module (effectively also the mirroring logic).
I don't know what to do/say about this.

Functionality was tested with:

tc qdisc add dev swp3 clsact
tc filter add dev swp3 ingress \
	matchall skip_sw \
	action mirred egress mirror dev swp1

and pinging through swp3, while seeing that the ICMP replies are
mirrored towards swp1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 76 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h     |  3 +-
 drivers/net/ethernet/mscc/ocelot_net.c | 73 ++++++++++++++++++++++++-
 include/soc/mscc/ocelot.h              |  9 +++
 4 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a26d613088ef..d38a9b498490 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -3023,6 +3023,82 @@ int ocelot_port_del_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio)
 }
 EXPORT_SYMBOL_GPL(ocelot_port_del_dscp_prio);
 
+static struct ocelot_mirror *ocelot_mirror_get(struct ocelot *ocelot, int to,
+					       struct netlink_ext_ack *extack)
+{
+	struct ocelot_mirror *m = ocelot->mirror;
+
+	if (m) {
+		if (m->to != to) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Mirroring already configured towards different egress port");
+			return ERR_PTR(-EBUSY);
+		}
+
+		refcount_inc(&m->refcount);
+		return m;
+	}
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+
+	m->to = to;
+	refcount_set(&m->refcount, 1);
+	ocelot->mirror = m;
+
+	/* Program the mirror port to hardware */
+	ocelot_write(ocelot, BIT(to), ANA_MIRRORPORTS);
+
+	return m;
+}
+
+static void ocelot_mirror_put(struct ocelot *ocelot)
+{
+	struct ocelot_mirror *m = ocelot->mirror;
+
+	if (!refcount_dec_and_test(&m->refcount))
+		return;
+
+	ocelot_write(ocelot, 0, ANA_MIRRORPORTS);
+	ocelot->mirror = NULL;
+	kfree(m);
+}
+
+int ocelot_port_mirror_add(struct ocelot *ocelot, int from, int to,
+			   bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ocelot_mirror *m = ocelot_mirror_get(ocelot, to, extack);
+
+	if (IS_ERR(m))
+		return PTR_ERR(m);
+
+	if (ingress) {
+		ocelot_rmw_gix(ocelot, ANA_PORT_PORT_CFG_SRC_MIRROR_ENA,
+			       ANA_PORT_PORT_CFG_SRC_MIRROR_ENA,
+			       ANA_PORT_PORT_CFG, from);
+	} else {
+		ocelot_rmw(ocelot, BIT(from), BIT(from),
+			   ANA_EMIRRORPORTS);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_mirror_add);
+
+void ocelot_port_mirror_del(struct ocelot *ocelot, int from, bool ingress)
+{
+	if (ingress) {
+		ocelot_rmw_gix(ocelot, 0, ANA_PORT_PORT_CFG_SRC_MIRROR_ENA,
+			       ANA_PORT_PORT_CFG, from);
+	} else {
+		ocelot_rmw(ocelot, 0, BIT(from), ANA_EMIRRORPORTS);
+	}
+
+	ocelot_mirror_put(ocelot);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_mirror_del);
+
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index f8dc0d75eb5d..d5bd525e7ec2 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -38,7 +38,8 @@
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
-
+	unsigned long ingress_mirred_id;
+	unsigned long egress_mirred_id;
 	unsigned long police_id;
 };
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index a95e2fbbb975..247bc105bdd2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -20,6 +20,8 @@
 
 #define OCELOT_MAC_QUIRKS	OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
 
+static bool ocelot_netdevice_dev_check(const struct net_device *dev);
+
 static struct ocelot *devlink_port_to_ocelot(struct devlink_port *dlp)
 {
 	return devlink_priv(dlp->devlink);
@@ -257,6 +259,49 @@ static int ocelot_setup_tc_cls_matchall_police(struct ocelot_port_private *priv,
 	return 0;
 }
 
+static int ocelot_setup_tc_cls_matchall_mirred(struct ocelot_port_private *priv,
+					       struct tc_cls_matchall_offload *f,
+					       bool ingress,
+					       struct netlink_ext_ack *extack)
+{
+	struct flow_action *action = &f->rule->action;
+	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port_private *other_priv;
+	const struct flow_action_entry *a;
+	int err;
+
+	if (f->common.protocol != htons(ETH_P_ALL))
+		return -EOPNOTSUPP;
+
+	if (!flow_action_basic_hw_stats_check(action, extack))
+		return -EOPNOTSUPP;
+
+	a = &action->entries[0];
+	if (!a->dev)
+		return -EINVAL;
+
+	if (!ocelot_netdevice_dev_check(a->dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Destination not an ocelot port");
+		return -EOPNOTSUPP;
+	}
+
+	other_priv = netdev_priv(a->dev);
+
+	err = ocelot_port_mirror_add(ocelot, priv->chip_port,
+				     other_priv->chip_port, ingress, extack);
+	if (err)
+		return err;
+
+	if (ingress)
+		priv->tc.ingress_mirred_id = f->cookie;
+	else
+		priv->tc.egress_mirred_id = f->cookie;
+	priv->tc.offload_cnt++;
+
+	return 0;
+}
+
 static int ocelot_del_tc_cls_matchall_police(struct ocelot_port_private *priv,
 					     struct netlink_ext_ack *extack)
 {
@@ -277,6 +322,24 @@ static int ocelot_del_tc_cls_matchall_police(struct ocelot_port_private *priv,
 	return 0;
 }
 
+static int ocelot_del_tc_cls_matchall_mirred(struct ocelot_port_private *priv,
+					     bool ingress,
+					     struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_port_mirror_del(ocelot, port, ingress);
+
+	if (ingress)
+		priv->tc.ingress_mirred_id = 0;
+	else
+		priv->tc.egress_mirred_id = 0;
+	priv->tc.offload_cnt--;
+
+	return 0;
+}
+
 static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 					struct tc_cls_matchall_offload *f,
 					bool ingress)
@@ -294,7 +357,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 
 		if (priv->tc.block_shared) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Rate limit is not supported on shared blocks");
+					   "Matchall offloads not supported on shared blocks");
 			return -EOPNOTSUPP;
 		}
 
@@ -306,6 +369,10 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 								   ingress,
 								   extack);
 			break;
+		case FLOW_ACTION_MIRRED:
+			return ocelot_setup_tc_cls_matchall_mirred(priv, f,
+								   ingress,
+								   extack);
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			return -EOPNOTSUPP;
@@ -317,6 +384,10 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 
 		if (f->cookie == priv->tc.police_id)
 			return ocelot_del_tc_cls_matchall_police(priv, extack);
+		else if (f->cookie == priv->tc.ingress_mirred_id ||
+			 f->cookie == priv->tc.egress_mirred_id)
+			return ocelot_del_tc_cls_matchall_mirred(priv, ingress,
+								 extack);
 		else
 			return -ENOENT;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4d51e2a7120f..9b4e6c78d0f4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -642,6 +642,11 @@ struct ocelot_lag_fdb {
 	struct list_head list;
 };
 
+struct ocelot_mirror {
+	refcount_t refcount;
+	int to;
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -723,6 +728,7 @@ struct ocelot {
 	struct ocelot_vcap_block	block[3];
 	struct ocelot_vcap_policer	vcap_pol;
 	struct vcap_props		*vcap;
+	struct ocelot_mirror		*mirror;
 
 	struct ocelot_psfp_list		psfp;
 
@@ -908,6 +914,9 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
 int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 			    struct ocelot_policer *pol);
 int ocelot_port_policer_del(struct ocelot *ocelot, int port);
+int ocelot_port_mirror_add(struct ocelot *ocelot, int from, int to,
+			   bool ingress, struct netlink_ext_ack *extack);
+void ocelot_port_mirror_del(struct ocelot *ocelot, int from, bool ingress);
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
-- 
2.25.1

