Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300C969CADB
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjBTMZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjBTMZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:25:36 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A951C5A8;
        Mon, 20 Feb 2023 04:25:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3VCmVzy7Vz9s/iynKVc79pF+tzv90ZgptYrfnswdsNerWOo2OACePcvcgFY8RAoHCvY/evboj1T3vzE6kXo/xyvdt6GKJk9vWRJnQ5imTvve7kgG9HPvEGinTX7REQWl+6vmubPCBJRPPIB+GumUeMBXS+LygnzGA2AbXo49C0fFdCnS1vJ/0uVyEtrhvlL5b+cs7rrIOQ5K63LB71E/LvmTS9/9zhtTfU3BpP7HlD8l15YkHLPqJ8dsTrwtQAH7uafBhU8eBlHr1IMFsxJfv/qXqSiSORePkTWDuNmoQPgBoEFHbUXU9b0yJ3gTFpo/AlXJGsWxqFnpzXrtQxg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ef+WqSHJ4A7CEjmveL5Kl3y8W8XRdCPHWrgCjRqbdP8=;
 b=TncbHhN9GQtpvxLvsAzyZZwgU/LUXWZ1HSRra/eSdd1EkG6wU3Xm+FTfrBwl0E9eWNyhvGVtcvuFfBzxdfeCTL6a3zrk80mVFnw7r0j9UGCimygkxJckOOF+/soYjtzHQaQIpsHIGqnDpeW+qj1wg9f4DZbhd908yrg5TcCJ9P5raiK5paxvW9xP+aALrB1zeJYNespP9OVnuWqUXsQsHctGw6pWow9KUv7km+SLr/nd9dw2iC2G+QHX8xe/8De9x88Z941qo/F4QBK7GKJoQ/etUgdME74bzlhqANgvjqQxIyLnOGMhJ04iZVr/f325KMFAxoWT5DPASm1jXqdUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef+WqSHJ4A7CEjmveL5Kl3y8W8XRdCPHWrgCjRqbdP8=;
 b=bk5wXCYMmLswigP7/zaP1C0oEYqUtCW+TEtC4ToK9fBmbO8HIT6jMkngJkMHwft92Z+GJznIVpWY1huYb0sEP8oFex3f85Jk2oAlAmwYx11Ejo0c/LvnA2Qd/S2oplEaF+p39QlbyR2u7eT4dIKQx4S5Daj9N8N7cyDaxwh15X4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:20 +0000
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
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 10/13] net: mscc: ocelot: add support for mqprio offload
Date:   Mon, 20 Feb 2023 14:23:40 +0200
Message-Id: <20230220122343.1156614-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 973680fb-9fc1-41f6-1074-08db133d6427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3m9dIuT0hnCQlt9Xz4vMcBcPC/ExRITjrENDFNHNoiBhsyISMc/ZDlk/gdjLOUmq617u2/dykgN8ZrBe5noPhDXRH13JHAwPef3Jb/j+IbId0VeTvkivnzlIUSGfZYWWWl5/3pmgCeLZ9qwh4GCwKOF12lxi5dm8OtQP7iV+TbJrwpcjbu/kCzGDLva8p0uHotBywmiBm2lBxri+NmSj9pxHp60wOEZc87FVB96o8SmO+OjsLCMeeG2I5iVbLnqH9H8ns9pOXnN/pFA5lO0zJd1F2qTozV447KGr+PVvmc5M8qi+oazAl5D8cBsM7vdwhUui5syUzILXMeTXPZGmxTEuRTLysnrDauYjY8j2Cs0gg/R4zNVpJbIChxCFpQJlIlvI2l1ngfyF5Wix+T/2JlA+2zTP7FRDESSCyduela8FvNTHG3Rfss5wLQvVIY0tzHIfdRgr5hJIaQ9FiXR+ipL34YtyHQXuSVRSJ8324IG7VhWGMt8kdAk94UW8XkyHltMgvP8eMIVu8yjyY8zlF48UdrcZaYx8jIjhRbLQH0F7iKWtnW/93RtiSN/Jp3cXCGYnPVunfw1PVR0UGECOYNKS6kWZZr7NnEiLtEKkrK79UeoL2pXsqNogkaPXVhsm+GFjKGE0OrcYgFUfXesbIFuSPsjQ8J4KkNXL5HaCJyb6mKQlDhi3e+TruqXMzO0jp9R8DR98n0YAjzjHSXIpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lE+PgYfMWX2Cphz4ywKte+BbxtpJvlDRUsVpl0DUVJkThbZt8Po/vLOx1PfQ?=
 =?us-ascii?Q?1mty1A+Uv0AkS/qpp51h2oBJgu2+N1SeLr5tGuISQYyHVwKldM/aMKjo48i7?=
 =?us-ascii?Q?r2EUTJlw0yWCDpmgExuU+sU3oVf8Fs5O80IEgy5MtjvPsxLx6APrSp5+cOc1?=
 =?us-ascii?Q?JyDc2cu4nxrCTg63217NYWLk5WgRP2oX+/KzmbLr5g/zXMZLtBni54+mQUe0?=
 =?us-ascii?Q?n20PINZLBnFOSFOFxn4MRM3iEk0D+Ofx+GhR15Wxapea3AFFRaIJvMulXLyN?=
 =?us-ascii?Q?F9FFAC3aCn5xhx0mfmMtFByY2BxbX4HPuigR9b6Zt4I0/AvYQY9wdsejKckG?=
 =?us-ascii?Q?e5/oudW70i9neXgmIS5dp8fstTvycaXtVIePNSYPlKPWVlRJ7sNzuEO04eQn?=
 =?us-ascii?Q?arnjA/hqiiS3izmaMYyLUA95HA8cl8TzIps8/WLrjgxjwgEh2dfL7RiD//h2?=
 =?us-ascii?Q?LUt+rMM1Ri4mljOEspRTmlt03qNTzSqwMtPPDw8HxBwqj1LazDEUZTiblS/Q?=
 =?us-ascii?Q?gImJoNRXbUH0Tg8vMR3P1MnIZjY7SBN5Th4hpdlW03ajSgAxk9ZwXFMY5hOH?=
 =?us-ascii?Q?qjMpPYEprAj25sYorK+Js7bMIlqfBBF3JXisrPlZL7y8V2/ngP9u4/Qb36V0?=
 =?us-ascii?Q?KM2is72G9eol2NYkJLKw3BV1aNIXQrGjnx5hkWV4tWMNd8fC3ZM2K6FC2R3r?=
 =?us-ascii?Q?L5sTo2rhA3IqKwFtdMc16CdDsSLqGrjU0eKJAUz5AELDrzzwvTeOhpwUoaX1?=
 =?us-ascii?Q?pCUg5Ys+Bf5daEeU1dqBFHYxXXNOzanLpYa9ERSuGg8WvBWeJ+BSd3NCQvNq?=
 =?us-ascii?Q?SO6eMEg+hdmoeqN0EzWiSeEXGBQmQ6+amXnJStawejJdhakKCCsglXqlpwfE?=
 =?us-ascii?Q?I2Yg7qFADVJ/0NUhlPKNaxK94i6Dm+5u8PluL6wdYkKnYiRMh7b5XaW/bc7F?=
 =?us-ascii?Q?M50w3tEfTYFTq50zT0AsnEoVzGJhinzcPdBZX7SiTG6w8yI9+vMNWrX06zdD?=
 =?us-ascii?Q?wbHZW5pl3gL+NUT8INxp6Qk62FIEs0gVPExFiiUjTuomgDLsj/ETv6MipftZ?=
 =?us-ascii?Q?8pAhRXUSNzYAYz7mXlmmLt/aPKVbuvEBQfdyS4g97yLrTP9y/LUACTGk86+T?=
 =?us-ascii?Q?PmNzR39GFLyvmSYI5D/UBLbGXjTHItD+qJCQbHxptKwkD8ozsYCs+s8sCgpN?=
 =?us-ascii?Q?OktIf+2y9O5P6bqohAq8Qt/DNF+LmalLGyaaL3B3/50UWPvW25Q8DzLzZKI4?=
 =?us-ascii?Q?JPLiKcUp7tsIPm2A0TmQWfrBlDAXwzt2C6ZFpJ+z9LOmB7EhA9zG7CVqPwDg?=
 =?us-ascii?Q?xGjfg1Bc7+Ksx6kcowXryuPLPRhSQSAWwP3w8H512YHf0FBAmemFp114EEoi?=
 =?us-ascii?Q?gASc/vIlxWL0PsyWy7UwBm/yqv22I/LnN/Q3mNBOsJffUgbGbMN7c+zvUKQ2?=
 =?us-ascii?Q?wJphZknz8lPR1VuUaOxp/PGdY9bwwVS/F55oa9ujRFFmh+e5c9MUtEeJjurG?=
 =?us-ascii?Q?Fy7OEz67c8+WqWoNEA3Yd/L7ckJAGDqZI6/2EiCDI38FBKKDREcr8qHPb1wf?=
 =?us-ascii?Q?91YouANb1/wfbxp/w11ye07NkqRx4Jp+oyxKxrR0n/dRuJD0cbI+ekCcJDa4?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973680fb-9fc1-41f6-1074-08db133d6427
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:20.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yr0ty8k/F3e0vhmnF05WzvoyxvmMuY5p5tP2sd1RBU7lTfYjtzQTiDr6bCXrCgasXFMUG4qNNRbTObyRENg79g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
---
v2->v3: use NL_SET_ERR_MSG_MOD() instead of netdev_err()
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c |  9 +++++
 drivers/net/ethernet/mscc/ocelot.c     | 50 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  4 +++
 3 files changed, 63 insertions(+)

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
index 08acb7b89086..8227d2027c94 100644
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
@@ -2602,6 +2603,55 @@ void ocelot_port_mirror_del(struct ocelot *ocelot, int from, bool ingress)
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

