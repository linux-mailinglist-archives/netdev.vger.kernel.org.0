Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9EF69A237
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjBPXVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBPXVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:21:47 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C65474DA;
        Thu, 16 Feb 2023 15:21:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9ygkspCVpQqTvLoVIS09wJ30sXaq1apG4OphQ2IQWhW8L3TmW07R/IAMo4uDM5bs/2vMUYwTULAJ+c9AjQR3+VIr+7QzPMgmmrO3mwpNBfdhEe3fEcPv3SaXu46TFbW0v9fOFHNkiHo5xFY23tI09+4BbzeWIjcvygXLL2mkByI+TUeKdfjKEcUn6Pmc6jP0nevknnBK9v4VYNZUM3fVxfI1NPUtgPLrrZPV5+wWPQDzkGoELaLxLfcjnx9N0gia3ZbQqZHmuGd9VU2SZdNrYZC7xmtfBQD0F/g/LKc8hT/l46vSh3fp85r22mvWgDB8YL8TcFfErNgYc4lFofOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZfGR5HnJQknXuJLPXQXsF5f0S85/zl/e1YhKUiZDDM=;
 b=mEYLliYCa56TzNRimjGn9IB+wKHEVVgtG4OMg8o2GNgHvFlRp7qvS/XDb/VBTbLCDBocYfFZIeGMqzKNqOXvLjwEcZTTeYpHo8kVpgahP8BqdjOSbHeEhnkSgZtrhCZ8sTtFOF1t5+WGkct3q3MhnuOYXwLd0sWgnZ+rDdyHieVJn4rdkAQuneOcNZnFUYwfpwP3cZB5wjTv9bGbqF6xp6bHMCXVvwqjQDzsVXp2hguoz2tv6sCic4HjuoUWayU/PzXwxr9xK0ltvA4u27kX1sABsSYvl49ovz26wcJPUyHwt8C5JJzKFVQjMlDJF1s9mUbUnlikdraTklVpqoyHLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZfGR5HnJQknXuJLPXQXsF5f0S85/zl/e1YhKUiZDDM=;
 b=OQ6rZoNirx0Iq4Ks9bKRddzSkrifn4VIN94W6urUvfmGTQjrRaV/Q+O4AvWxSSftAXLh8CZIdaSE2r9LFptq3eGQGhgj1KQu1zD/kOFwsEkB0Ipq5HJmJ4gwcP8tJhcV9HPhXBM9mkZY592DDV6N1+1odfWT+jfl0rogAaa7M6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/12] net: mscc: ocelot: add support for mqprio offload
Date:   Fri, 17 Feb 2023 01:21:16 +0200
Message-Id: <20230216232126.3402975-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: fa3b7664-03be-419a-eae0-08db107490b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FzrY8w/pzbvGErFo98Y8jrq3IgTQFvzmAKXFaNjE+mMURbhL7NmZwjIboKkGlSc/DFDMyzjHGADA1yh1c2c9EmA/ANu9p4sBdB0jqgF4cw1XBgNDfKyxYoHcH6/u+PDJi87LbCay9GVUg0eyJxsahxXm8MmSg873BCajVPxpgdaFece/Fj70ukYunSSrAKI33Z/wsVz76gDx5+yTJOeziP/2SKJZSWW1GuBNU2b7AhwzStutA0v188+2G5+z7sJDrQ8Lw53KrTmzeIyJugEjFCDbEeO4Gf0/wBBSYr7CXHXPg50Pl/emIM+X5PVrC98Luflw59qlTfmut87bHDTiB6dkcoudA89Y17KWdBl17a2AQp2EboeQ3Tj/WqjxGVthqnedhh3r4YXe48M2qhfhgtl4H0wjEluIbBlH5XNSneT4Wz/vmP7eUbma3AqXHjugOuk2L59pNZ6iQJmCgouOa6h3dsRkAWKqS06ewfyE9zkZ9p1VbBDAIjcs1wi5G4A5gdg+BzfAnLQhO2FCJHdWgbnyMHAPq+o/dMOeiHJ+UbJEYB2y/jy/I7056+UBjqOYBbPMMZWtM3CUQke7gexjHDn5NLJQEmd5z/mVSD9yn7WDc67doOlIW9IWDq7gRIfwBw8bG2t5pKwxY5a8sstB84JaohnNtDkCkZqsZqF9p2Xx8LT35gaXmWgUvPVVLfCWGd/VmlZYjnb/Ub8nVl64cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vjtxKUDrDhMK+GOHDxFl5m+9H0oEo6ETw2Tl5Ra5HWv7EXbw4k0FZZPevuD9?=
 =?us-ascii?Q?5m617XCFIeNGbXFXdeSHdqL7E86DAeAK2AYSgeVEArNqR4W4fNclI3/e7r1H?=
 =?us-ascii?Q?O0UuPCbDx3NIwSA59UKlYztl4zBou4rFu5UIXipULsQuUOxBtXc2vnU7/ewa?=
 =?us-ascii?Q?4LzOqJViZIUyOTgyWNm+wAHKCvG7hC5uWqPf3qGo4zVI+tE8uu+GpbEsZlIL?=
 =?us-ascii?Q?CXi+A/4427Te7Uitzjix1Z271IKlERdpX0No/jm2ou4ZyuoWJky1bGO5pYj+?=
 =?us-ascii?Q?i30AJxLFSU3/C+arne1GhL44MI9o3pAU3kAqmcrz55XsATfZWNe9LAFKE+OY?=
 =?us-ascii?Q?/fk1CRlwZ2QERi4YF7iFThw86vYu5+ujtRyWqVs/AR3w/eeqw81YoqC1LefN?=
 =?us-ascii?Q?vZ255Tim3UqHWxTbg2/1eA+P5N5ZOBc4hjcI+n0NidQ4MULxnXye+LjW3AD2?=
 =?us-ascii?Q?+lg4m803dTFaui56Z0xWb9kfDAhq46umYUcoe5qrbnTEK/J7Nr+GJ2msTop3?=
 =?us-ascii?Q?dQIsnHrd5d+dAB2tg4613z3GsA8q+DcVDePbB7rxLSYrwDg/q1NS44pl+9q3?=
 =?us-ascii?Q?WWyo5yMHHjeDWlw//LxQgC7uQ57UN5yAf9wT3kQXD1cH0U4OKJU0QNqZzBcu?=
 =?us-ascii?Q?9ABIoLby64vB+bKeyNXs0LE3PWKgaTfbX0kJPAkEGxDOWa6z7jIvT+FrZLif?=
 =?us-ascii?Q?MWa7Q3B1/butiHzw2+AodGkNUowKqISK40sE5WHzxTyZRhfOzwT7gMPYpuwc?=
 =?us-ascii?Q?zpcAQv/hwTAeUfblPlYc2WJ1R+SfMky9iRCMkImYu2wGQ/UffnijifcLYWs2?=
 =?us-ascii?Q?WRLfua6G0F+/Fl45TblKDRaTIimDtCnAVqhaJQF4A6wcYad7Oiq14+oWiXkx?=
 =?us-ascii?Q?QZUo/r1YUMvxx7WxUkSvEooeXIIYZEP3YO1E4ah3sY/sn0ovhcy9Vkb/psw2?=
 =?us-ascii?Q?qfD/5XJ0UzLSF9gofMaTFSMRlFK7Uaf0JPw2bOd7q8baiCbA/u5hN8Hoo0gW?=
 =?us-ascii?Q?ACvicpGnKjyUVIIdDokXZOoF3I3YJ7w4AQ6rDfSdaXXGqB2cKP4v8xGX0BMg?=
 =?us-ascii?Q?eTg0cxI3KiC70P82/KXcLGYUOPY13C6r6HPfCE7B2oVqCVhq30772ZxwBfXy?=
 =?us-ascii?Q?5RpGgzOPzgcSjjTuUyaRYjwYcg8K0Nanb2clqLXFkAHZdWjRwqq7EtScTe+j?=
 =?us-ascii?Q?3jZL1fnowK4tJJ9GjVUcphpZMIYkwdv96Fl9G8heZfCCJVDd6PnJOX7s8Z6A?=
 =?us-ascii?Q?i+8JLbHuoddFl/ejGMqeF6slNMZwX7jMojxf475lf82i78mz1b4J0EY+PMy/?=
 =?us-ascii?Q?dPFNLAgsfN5u0PNGu/plWVHsaZNXTP7koj4gueSDwZOoxnTtMCXPTlOi9Scl?=
 =?us-ascii?Q?Jd+CWra/3KZ64reuo5kxlfPRzK3d/94ocK9FF7sRXxLrkecDHci5zFjt1bgK?=
 =?us-ascii?Q?2Muz8glBK5K+pUxyGyGvz+t8zEEqDLbUlQaxs96vPBFbp2oy67CCUWoUwcjr?=
 =?us-ascii?Q?ksNokE+EgvlpesLFoCyJ5u8ewJUWV2PaMNz5vZJ1KZ4IdOyyqx1HW5dKo2G0?=
 =?us-ascii?Q?uZmHV1tc7Hr8N0hY6qWDyW0NZltCrPkg4o7fUeJtzGjrnSPhd+N0NeJtKfsQ?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3b7664-03be-419a-eae0-08db107490b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:43.4777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vm7z3pB+nDBMPwXcl/cHoW81pEZNWk8nKJn0CwwjNU58shUwnUc3cunreGr6xkBM2FlpA/caX9qdkkTBsbwnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This doesn't apply anything to hardware and in general doesn't do
anything that the software variant doesn't do, except for checking that
there isn't more than 1 TXQ per TC (TXQs for a DSA switch are a dubious
concept anyway). The reason we add this is to be able to parse one more
field added to struct tc_mqprio_qopt_offload, namely preemptible_tcs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |  9 +++++
 drivers/net/ethernet/mscc/ocelot.c     | 48 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  4 +++
 3 files changed, 61 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 354aa3dbfde7..3df71444dde1 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1612,6 +1612,13 @@ static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
 static int vsc9959_qos_query_caps(struct tc_query_caps_base *base)
 {
 	switch (base->type) {
+	case TC_SETUP_QDISC_MQPRIO: {
+		struct tc_mqprio_caps *caps = base->caps;
+
+		caps->validate_queue_counts = true;
+
+		return 0;
+	}
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
@@ -1635,6 +1642,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 		return vsc9959_qos_query_caps(type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
+	case TC_SETUP_QDISC_MQPRIO:
+		return ocelot_port_mqprio(ocelot, port, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return vsc9959_qos_port_cbs_set(ds, port, type_data);
 	default:
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 08acb7b89086..20557a9c46e6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <linux/iopoll.h>
+#include <net/pkt_sched.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
@@ -2602,6 +2603,53 @@ void ocelot_port_mirror_del(struct ocelot *ocelot, int from, bool ingress)
 }
 EXPORT_SYMBOL_GPL(ocelot_port_mirror_del);
 
+static void ocelot_port_reset_mqprio(struct ocelot *ocelot, int port)
+{
+	struct net_device *dev = ocelot->ops->port_to_netdev(ocelot, port);
+
+	netdev_reset_tc(dev);
+}
+
+int ocelot_port_mqprio(struct ocelot *ocelot, int port,
+		       struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct net_device *dev = ocelot->ops->port_to_netdev(ocelot, port);
+	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
+	int num_tc = qopt->num_tc;
+	int tc, err;
+
+	if (!num_tc) {
+		ocelot_port_reset_mqprio(ocelot, port);
+		return 0;
+	}
+
+	err = netdev_set_num_tc(dev, num_tc);
+	if (err)
+		return err;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (qopt->count[tc] != 1) {
+			netdev_err(dev, "Only one TXQ per TC supported\n");
+			return -EINVAL;
+		}
+
+		err = netdev_set_tc_queue(dev, tc, 1, qopt->offset[tc]);
+		if (err)
+			goto err_reset_tc;
+	}
+
+	err = netif_set_real_num_tx_queues(dev, num_tc);
+	if (err)
+		goto err_reset_tc;
+
+	return 0;
+
+err_reset_tc:
+	ocelot_port_reset_mqprio(ocelot, port);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_mqprio);
+
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2080879e4134..27ff770a6c53 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -11,6 +11,8 @@
 #include <linux/regmap.h>
 #include <net/dsa.h>
 
+struct tc_mqprio_qopt_offload;
+
 /* Port Group IDs (PGID) are masks of destination ports.
  *
  * For L2 forwarding, the switch performs 3 lookups in the PGID table for each
@@ -1145,6 +1147,8 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 		       struct netlink_ext_ack *extack);
 int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 		       struct ethtool_mm_state *state);
+int ocelot_port_mqprio(struct ocelot *ocelot, int port,
+		       struct tc_mqprio_qopt_offload *mqprio);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
-- 
2.34.1

