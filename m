Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C51C69C070
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjBSNxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjBSNxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:44 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2052.outbound.protection.outlook.com [40.107.104.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1910F0;
        Sun, 19 Feb 2023 05:53:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2MO8PiPthWBLh6a4SOjb5UZIANTW7KF9s8hcuIM50i4WK5Iqt6L3cbU6hpDQIYPPVN4+Mrlt9JPjw5FZY7VXE5v6jQY9rb4D1sEGX4bQ9NdQmIF7qTmqNNjR7TSLjVosDFh73DLOle1QKgQ4J5Mc8Yd8WNMsAly5FujqM2SB5uXerKWIEwp0HGeA4931cJKZKz3XQQqDYV7JMjmsP6Xg3GrBlpleKc2ejp57BgdglNiBeHiOikTFP/iMs/EHu4iNmKOaEhMH+znphQgpsSrkDizZkLl/Vj7SwZDCsiYLz/eKMWEuiFVXSsYgZv0x01gYGypvmrsWALbZjrS+hyV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hl7MclDXQJW4H3dwkVvndquCv9OyPf3JcRdtSaz4Ths=;
 b=DdSD0lpL5VkK+OzfNDkTfsbrueH1oi/+ZVxJNrNBU/e0jNE5KvA2HDQ1omGhwWdUcjQZ7Tq5Dt0ZHR7mgl4SG6W13hcuJHbepYdo50JmU9YG7wcntZRxTQFm299Vqza2Co+9ETR6U6+BtcS/ZI7zShysCX/LqQVFsIc3ot9QaRVFiG8ml8klYNcIrzYL3fIrg7fOHJ1fpZ41lBrOfE6WBAnFLxz30MailZss9nlAj5eIM88/YQgs8v6XlCJrvvZh5p0r3TjnzXoFqgMm+m8r8WOPBax+fIp/J2zyAW86qjUNqOEAp6uI7+ua8Sy3+WZGjW6Hiv31AfAF5jfDEpD/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hl7MclDXQJW4H3dwkVvndquCv9OyPf3JcRdtSaz4Ths=;
 b=Nd8RFfa2lLb/yA6mWlFo9+CrIdtX5TZoW6SVFRO0tDJtgfU55BzfHGRwuTPvjgpN4yx+qpqS8wBy8IRiNfGGsijctWnLtvfBC7BciRkVS3sZadIowpoQjShsrYnBfJcw361+n/JpqAZuOSd/Ov5P3/GaxY7XlALRn7Gyty/5AA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:41 +0000
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
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 02/12] net: mscc: ocelot: add support for mqprio offload
Date:   Sun, 19 Feb 2023 15:52:58 +0200
Message-Id: <20230219135309.594188-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 46cde5f2-fa84-405b-0ae3-08db1280b527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkXbG9ef/eYAcH1Iut2zpHs/5sj3onXJZBHw4R3A2QFeTKyyZW+6T3cXkgRiW/lFfNC7UzHGow2Tg3K8au8sBX/n/db7DY2vJ4AUfPdU0g2FgsmHbzHYZxj6AAdw9G/pbQYZrcU1eMwcqKNnYQm3WsYy5HURhNQJmEUU82E3A0N+EDCQJrXWJichOCyehYdSfK4TW5Fhq48Jyf0FasXunFfiBBxaA8Spv0qiOboIEacuxaqJO/Dgk2IyQmV78/a7+oqWalxy6gsKrJbhiqpXQpWxDqEUIMazsc2GXKnrElxGpQLDC7Upyxr+kj2OZQUhAkWV5SF4KcdL+EXZFZLgOhsDnqNyMkdWEFONI8C1jRKLhNpSxfStr9/Yff9qBPYjIQM20Zed6wWu0yps7V9jlN9W2RgYxAcqhKoFDCkHpHU0AhKfWjr7F0OyLmfXV3eq+IX0HPz6o3E0YJPmRa64tjYg1bpOSRRokHYSJhB6nQXeWPKz88qzpC8IyRH+47K5/rvQRPXLus7MJWncuOb4iFIC+9beTzXzp4THYpo53MU/Z1IssSY5bOGyqw33Y22RNoqK/aetckbkaBw2gWWMfsp97UWWD2VZXZTJk4Q5wDIyp7TFt0Sx+sB9ZS6B+iMOUiUxQYsgGaVfUVwe7i9SAXDhF8Cm2k5fewOi1767Ch6WPH0nGXh/SsrzM6l4KvQttp2G5K4NscUHN8nfBfDYmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aDBJSRvxdgWDK3r5GsKUMga64n1kH6m0/AV8a9MrvjS8do8AMRTbAhD5d4G9?=
 =?us-ascii?Q?NepEzKE+wV0CIhWZw4Pb/fA2os/JWOm+uHSl+oEj4EgHB7rAgF0Sb0Z2Gt3O?=
 =?us-ascii?Q?0hbAiOl3iLMGWC58Rg2wVCjmdr5f05vLLKwogZ0Ad/ChfmtBIV+9qW9+czuJ?=
 =?us-ascii?Q?Ou6shk0bVgyqrY2GrAg/7cnKi9eCD8O8+FDgUUDspGSvaDpM4+KE/0TqP/bf?=
 =?us-ascii?Q?UtlWxW3AyoQcy48INT3bZC+iCGI6p3Ngwl+cgAzgIr1xI08wpTKeiX1/ql3F?=
 =?us-ascii?Q?XmUJyArUc2Bdn6V2v0VCc3NFROHffmKZ+viL4eNcWjYMMw/+r1BIS8WAAcqG?=
 =?us-ascii?Q?f9jJdhaS58OAJtJkH0BzOQ8fyEkop9HHxuJ3NtpICNdTXDEVfu+v/d4RNtme?=
 =?us-ascii?Q?NslVDKqDNxTHd8eMmNbhpPFYqR299Gh8zvlbZVQDx+MX3iMwl17zQ4fRib5o?=
 =?us-ascii?Q?+NGe5fTrjFUgPTqxhg9NbIcm8GKGiB4PuZko1cqAO86oejVorXBH6zTK0eM5?=
 =?us-ascii?Q?6PP8KJQQKp7W/pdMojKCUjQWpa5EIg90EElId/vBirg7tPtznQQeTOh1ZpVk?=
 =?us-ascii?Q?X38Rk6ThLA992+NdkJ5QXKlVdLHFOzx/LYEHUgaDaoON1M8SVXAulJ2QxKEA?=
 =?us-ascii?Q?d3dGJvC+YOZE/EFyLkyDBa3Bz+RVG54xu6N/o1TWq0OiWNGpj4XPu8NbqbXx?=
 =?us-ascii?Q?FF/ReJeelnqmv6Iq4IlB25+Qk9jgTxygrKFL2n3lyD+TTHMU6HhBEoccWq3s?=
 =?us-ascii?Q?b4dMa2R1OcCFnjnfvJkg/UInGf6ygDl6E3/zx+JzJRvIMN41f/5qQaoLHlNH?=
 =?us-ascii?Q?RpOv7BeLKnFr7Ve/zIYtIuO52pDj+iFjgqP1JP8fV9fj0CjNO+HkskQ5G84h?=
 =?us-ascii?Q?LHUJpyrdFkfr8kM/PHl0pt5K6tXHU0M9ej9zY2fVjF24pYssi9ti5WAzZn6m?=
 =?us-ascii?Q?ru98YQ939ZHYps2hrRLi4szfa9xhQYpvD8IC1jJsqOs1mZEBtWXiCOAJ+WGZ?=
 =?us-ascii?Q?4Wxg8Z7d2FlTpgd1F8pJcSWRFflZYWkvKjmopFFWrclIvSdHZ2F9cIw62F6a?=
 =?us-ascii?Q?MvTzJIJTei9EbvRiIR4RBm3jen6QzJRoy4n8ayLmf8aNe4syrjjrT9PSSu+f?=
 =?us-ascii?Q?lE6E90XzJ7xeuOn+uk194AXuiLOF/+inr0XvFVGPF+4HP2blI4erjjgGtyJ3?=
 =?us-ascii?Q?3H6iUukOJ/OOzRFkgq3BxT08a2mKNFJHqGBqc0hSNzeVJQcEHrtNyFVSIU9T?=
 =?us-ascii?Q?QYUNOPNFB7jwh6L60fKHEkZRuzidP3TziVkgkSssUO+KCFvTRhdwkQhDYcA2?=
 =?us-ascii?Q?yzFudo3CobQQugJT/ynAApOKugdlyhXl/uBbnrSzmqc58I/X+XVKoIVptKvS?=
 =?us-ascii?Q?JP8MAmRhMcr9sdHA3Hg5tQvi8eBQddZn4TG65o1iGJtSbw8j/53X7C6hlWFp?=
 =?us-ascii?Q?dRw97BF83mf74woYmIYhFvj/LrLNn6M5/I4rpJeMDFDXzuMFQIuvVbQDoy7x?=
 =?us-ascii?Q?EASe9VgTJ12A1tkamqyyqOexe8wT5tLBJHsunB/RM79mSHCXW0/8vLQFgK23?=
 =?us-ascii?Q?2swJEihfXQ8EEnYLvpC5UCrbZHjuVp076nCDsmacBtquUjfGfJ4GJh31QBRD?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cde5f2-fa84-405b-0ae3-08db1280b527
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:40.9280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t5sjtOhkCTOpNmIJ+tlzZ3nKNBkWshgBHM5aJb1sXWvo785rgi8bHotH7i+L6ZjERx3dLCKM/rAnvbddid9WBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
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
v1->v2: none

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

