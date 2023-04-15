Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5DB6E32B8
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjDORGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjDORGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A324699;
        Sat, 15 Apr 2023 10:06:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tp0/HPH1EM0r0/jySbR6FeV5JMnCcZTbk0NTRKJY4pTd2IJ2YejGZrhVQzjAAaou4BhmfP2guA7HvBMXd9BQR1cAFyM55ogVhmCdMnxGSgDRSXeyak6Assntog52VvlB+tni34vVreEJMO9XpId5i5zwzyiz1aLKekAboQ4PQiKb+CiS3QkAVcx4nnNibznOQ7//tvtNdoe9onWNfk3Rm1ACpF00DWds+YXWoOQoCkPKY02JdPUjvPzmluGm0hOxb2Ay2Gr105mqM9W2EpLvfKMSBxl7iC+zo93UKR4LnWferNdvoHESjD0HUIkguvgbgP0NQ+LKj7jnc2tEWOSjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgCyOYQFmM9Np22IINUAmAgxSSN36eM9uT4IG84zlGQ=;
 b=AWeHpuqRs1hlIy+IHx9G8w+SqdWWIM5LC8jhBLOL2RZaC4S1tiWW+QxZJeUXRlnSRKAJKo+WYdFo/ygTnKXWqaZFWTBm1xymGKF9R9nWmbLBqHJugGPlPGxqOn9bOsAuziDAR2RsnOyRuVMm0Z4cylh9SnmIYSAwwzHQQmxDijPgq9q6AP9S4Dw2Q3nLXC4wkQTXaqZTxUgZjZ4kjxWYMkJ379GyLIbIbpVffEFSs4XOEbjH75sG1bsg8GOfsAq1MvUvEiCcf05qWjOThiIpl1iszNVqvroyn4tjgjfL0RIx8r+sIjIFOK14fvR8iSlayYJ5q+H1hekcVnHY7rNFSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgCyOYQFmM9Np22IINUAmAgxSSN36eM9uT4IG84zlGQ=;
 b=ahJaEUS+vLPDynvkVTprg3uOxTrZXNAjMPM3t1RMBM+W3hNv87vm8YYrgkQ+RK7PdLmjnS75ni2Npj0bu1nxUUSVYVQZgQaKBoY1tXR+/dHkgST1CQI3frI4qHBn/c3Gg7bjLPfznbv8MEorzbPxRlBY7JjYyzbgJVOMr9QPRG8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/7] net: mscc: ocelot: add support for mqprio offload
Date:   Sat, 15 Apr 2023 20:05:49 +0300
Message-Id: <20230415170551.3939607-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 53eb5c32-c312-4484-574a-08db3dd3b496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JocOFekizOhj6F79a4r1sZFncBc/uehgiMOM8Spv72Wq0QoKV41MvbxiUz1eE7ffUuE7pIbm20su/MzoGTuB7Ve8utkXofc+8iGU3saZW5FRqRRastyYKZgHZ6Ucagx6+O6JNR7akStY38md+nswXf4BbVjIYKKXI4V8x9/EBIhFJ2+KrPXhxRbvsYN+CPR9RQLStc4pj15rRz4O2ktkJ8k3hVdUm0cNi73/+E3vJcQrh7+Ybf/a2PMICS/VPhAAEShh/YY8M7/nFL9AfK6HLB4lo+04D029hyBSvY1aNDF7H17eQ+pfHD3rGy2CHH/o981r2M0yfiSOSdA00//9A7nJPYxsHxzUBuQzsoY/JUAzMUmIWlFpon3B36i8PxoHn9r9WpfScosU6KKOS/7sTyUZFF0B4F57S9ZWGPGEsL2+rgcbitqVFfJPC9KVe9FXYk0K5VI8deutDBhyFdLYoY+bGv6kfDyjlYw4EF27Tif8E/sBhCfedineFmqTgM5JSPgZeObUqVxKUUnZdRIDeH84mHD4Ck1FgbOEnhNRhGWuiky1AuB2R1WetHeoIa/yOXjhO6B1wktbB58nmAKGAxf8mXFpWN6besmOkapx7Ik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(966005)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e6q71KhNoVcsh2y2I0BZEXrs/cQ+7XGM5PpSdggBcrv141MQW/keksZzF1Mx?=
 =?us-ascii?Q?1NrCHz5EgEnH/TyddpnjMErXxFHWR+DKaLenATX/XrCTlHaOShrmMdaNkvWa?=
 =?us-ascii?Q?/iZCNB+4RoIvSvAxSeEIlImaQvpYpTEMWu9ZKhxsmJ+lUI7iE82Ec6crs9HS?=
 =?us-ascii?Q?Gq9OriD6ibth9gEF2/DHAXlRnGr+jEQ45gBuHJPwbp2aojK9aSQPC1v7z4Gs?=
 =?us-ascii?Q?kEcqoVmUC7c/7EoI4J3i3Tvv8f0fWurzLm51af2Vd9U2rGHSHJqR6XWFy2y8?=
 =?us-ascii?Q?UPJtKL5oFqJhkSxl5zyF4tXfZEZhp8UCdRD3lfH7t2RrH6D54mX6SON0jq+4?=
 =?us-ascii?Q?JNzQtf0PvYm+Z9A8iXdz17iYPlN+D2ZCTkaS0nVhGENlxmrHJBtJtuEFsWV/?=
 =?us-ascii?Q?7MzbLrlOjaL637svmuEgAd1sSG5r7YA02rWixM0Pm3gmMtM9101z00xqTqLo?=
 =?us-ascii?Q?xarsAwJ8EU41TAbwqwonNd4jt9+pJ3cQNVybcUeDlmFFgDTmd3/UwVJHPCJZ?=
 =?us-ascii?Q?8RyoeoJnY6Scwou7Zg0/hEmHzcU7zmeYUK3PXBwgoBvIEd1mQZ8iQV5UNdwu?=
 =?us-ascii?Q?41RXByrqmEm2+mCvTgcGS/eVFI/L5LgmzgI4xjgR1CtuUWDXoLNZNe6ogOwo?=
 =?us-ascii?Q?ZVbp6yHkJBqwD+ooF6BZLro/2/JLWXPBYq9qx4GMxRksk65O+PvzWjwSm2Yf?=
 =?us-ascii?Q?WOwBiZdKIqZ8vA/DnXjQ9S+E2CsIUVY9KFI6X4NhIIATYfIpkXd1lpDzcdmU?=
 =?us-ascii?Q?FA8bjQM6M23bnHge5Q7Xf+yDIaTvXm+FQCTUeFrGHas/k+HgdIuH6EfN8yj4?=
 =?us-ascii?Q?pSwBYYmlgCi0+xDX7Ilc2OIAe9YvMeTZL17vZ7F3xypjQGGvaVB3039kuCYu?=
 =?us-ascii?Q?xKM0KTO8/d4eJR0u9hWwGKMLaq01b2rY6NvJ8ILyqls+yXbWvaQTLEb18hKw?=
 =?us-ascii?Q?6gt6fO5pXLtnrIa3bjPG6xlTIjJhEy/Qx+TQz/Q4VXyyH5bxslm55sKy11gB?=
 =?us-ascii?Q?U/nQrmBJRNQw6OQnCq+lfPlpx3l/kfugsYiL+mnnOUvPYSDZGnJIGXL4DOt6?=
 =?us-ascii?Q?uhRTsvo65zA9K+2L1qK0YlpdSTbSmxyW1ua04DCWONHNOeX5x2lUZWwGx2FN?=
 =?us-ascii?Q?1/wF/RnfL/gRWbkzJY+xIEBzo5sKtPdI4IBFLDNelkqlk3gxs03jgW7ouXzA?=
 =?us-ascii?Q?Nu10s4EO05RtN9OwsTZ8CVpy7k3hm958F271yt6QLfb3gdOMHt5zsVSwGG4c?=
 =?us-ascii?Q?QNp0T69pbuVbGmkPWqWyJ6XroNzoNf70/lyiqKCtuwKJuYvv1pt3R1h/DRqm?=
 =?us-ascii?Q?jiQCq9okdlkI8AwvYZeHHPave8bhNdXhbBWmdlBeO8MlMMTuxppvdFx2t3Du?=
 =?us-ascii?Q?AN8k6GtxHe3v02owEF5bIvHVxMvpzSanhFa3DiOKHyY7ufXKTko6rdBr0w+O?=
 =?us-ascii?Q?SW6XWrWk9yru5Viy3l/QYKKKj/HLFDKoMKcuNoU/O9nK2yD+8UJiIv2w8k8i?=
 =?us-ascii?Q?5kUhEl9YUgx4d2+5W17wjELK/uYcHFodlG8CwXU5iftL8z1uJc9Qj1bC9TV8?=
 =?us-ascii?Q?8x7SElfGEflCFrn4eQW9L+ntuetEecfGd1ZntAIFTPpLaxPqfWm1qpyX65VJ?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53eb5c32-c312-4484-574a-08db3dd3b496
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:08.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCCg1w/q3l7foMaXNNCb0CROXMnUanr2YdfaJ642f7CPSRNG0IVtfQ+W3C9BbrhkKagJTjRHh8aYzTRO10hKsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Diff vs
https://lore.kernel.org/netdev/20230220122343.1156614-11-vladimir.oltean@nxp.com/:
none.

 drivers/net/dsa/ocelot/felix_vsc9959.c |  9 +++++
 drivers/net/ethernet/mscc/ocelot.c     | 50 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  4 +++
 3 files changed, 63 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 478893c06f56..66ec2740e3cb 100644
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
index 1502bb2c8ea7..8dc5fb1bc61b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -8,6 +8,7 @@
 #include <linux/if_bridge.h>
 #include <linux/iopoll.h>
 #include <linux/phy/phy.h>
+#include <net/pkt_sched.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
@@ -2699,6 +2700,55 @@ void ocelot_port_mirror_del(struct ocelot *ocelot, int from, bool ingress)
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
+	struct netlink_ext_ack *extack = mqprio->extack;
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
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one TXQ per TC supported");
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
index ee8d43dc5c06..9596c79e9223 100644
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
@@ -1154,6 +1156,8 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 		       struct netlink_ext_ack *extack);
 int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 		       struct ethtool_mm_state *state);
+int ocelot_port_mqprio(struct ocelot *ocelot, int port,
+		       struct tc_mqprio_qopt_offload *mqprio);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
-- 
2.34.1

