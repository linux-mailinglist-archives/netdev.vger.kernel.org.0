Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883BB6D422E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjDCKfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjDCKfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:48 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D0530F5;
        Mon,  3 Apr 2023 03:35:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzM211MyUEIJSAGY6WIBrUIBbee1nd+/7x0zjghrURXh9rbB9x5j43wYi//Ua1Yo6mkYt04nYSbjEt7EsOuUHsAalWzJNyKcyaQz6oqq0vYFOUYdU8Slnr5SMZV7cafZg1h2iPb1fPmd5mFgI+Il7XUX4ng3YHNvsEdJwuo8XJ+T0Tq1lzCDr7nZiL+oSIpiV3AWxiXteQL7DIkDVY59Nxu++nTYawiNrO77SQ/VoFNJQjR6miH54qpAR1USEyQJcXeKDerCAImcb0RMBve2zB9A9Xi0OiWvJNgpB9FeoFL7taabb91NI7yvV+1u5mSDFgBICgcqGS0XM4a421RUNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNfbPUlIN6M3l2O1riS4BqLVSlYkxDQlrmGoDDa57Mk=;
 b=R5/P6q08Dj0W/JEHUi4FvJIr0wff35vNhVZPUNZTza37fbwu+i0qKe0moijLfA2PvY+bFgwOepjKQsXAWVfpJ1i1RN4I3+5x66RpzCrojYCU78hMQpmvNq53Yt7qS8wWSzZDHUGxmT7GPkW/CGkJv5vOXVi4sa4FYnCLMEjaV6bzZMCazTkRPwB5/ymv6n4qvUkQO+/hmRylJ0ycWIrE6YbArGzQNGycQUAt1c9bYtvKL6mkxFXlLrdW5RvZkxXJtx6Pgvu5sPQAbdMaTit0O0LZVtoMIY+ASMiZ7ePrj7bRM+l4sRB1Z/g+SmEszmUeH6r3EW86FQthpRPfC+Hiug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNfbPUlIN6M3l2O1riS4BqLVSlYkxDQlrmGoDDa57Mk=;
 b=rRcge7Mrl59SKP62D90nbSGvUVYkm2XOM2XLRZRl/GcEmXNgampvCT/hpDimkK+uaH5SjQkUr54Ec5nYhwwn0OSQlfBjG/LajApu4Khd42rEa2XDWbMOWMyfb15HJd8Urn0dG0lwGyFqmqKIbV8fS5jRB0Hpswzh6JriV7Y07vM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:05 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:05 +0000
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 5/9] net/sched: pass netlink extack to mqprio and taprio offload
Date:   Mon,  3 Apr 2023 13:34:36 +0300
Message-Id: <20230403103440.2895683-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9292:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc4e4db-dc1a-4668-f122-08db342f168d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkbNkRk5ieRsyM+TcgG06utf47Dot+c7USDJrJXggxRLFWjB4eVIZc3yL8qBhLCB1fWRGjqCXaTGLBlickqQGWWLCfTu592EQhbkBs+yTbGkuDobZnm4lBzLFbOE/iKex7pZCjLXBH3bbXmiKLrYOdD922/O3IBneqsZ3uYGsRy2j+/rF6RtoyNmDJ/Ynm7p92N0yhQSAI4ANRPmwlPV05l+31VpB2B6AOU2ESgfc8+7AeuPgmpERGYxzbwTh7DWtX8GRTlNq1oUFWD+itkTAThmWqiSC/qSysF1iq+sccBnwXxJvQHKpv7sCJ7pD2EX9Psmf2jNh80H3ZvroFVnQvOLjvHGUuyhgdYjaD+TB/lb2eb6Z2lnWhOf5m/95XEWI9jXcmR6O/KMGl5IXsAr1/Bz+Wu9ug8qktnEOoEqq99M5kVrrzxUitxzPNNwMJ0UJtJRsyeMVWy9uFX+7kXgDMa5J/rMbG4Ko6oShv8/q/3rZY0A6yiaR6PkAY8vVvAWcpKXs0cNEcIieJ8CslKlwZNv/4fqhVBylTtahqIdSkLhnuaQuKLHtuZic/qb8NFVbbVkC0PF5/5IjNVsrrznclSzLrfS8iscvZs9Di9jIKv51Lr1USFcV/9Fxi8a8mwe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8sZGKgQPZXswnc5gBby6QCJxVqlr24gWt0pb9/y51Tk8n4JwMq/XaAo6SqWF?=
 =?us-ascii?Q?h+tFx2OGpnMqjDpLLlu/Pduc/HN5ReY4SuPoet1gqoEvLeLTIjSj7r2kgmyj?=
 =?us-ascii?Q?nFw2jGqrKSnkksTWPOrH67A1VcVSspa+FkqW1ifCWOt9GA6KBUvIpopekZvU?=
 =?us-ascii?Q?vI477K1mL1NNrw+GZMBrQ00PsXmxOJb5iqkeGGohU4LdW7kHJoctXHSvwlGx?=
 =?us-ascii?Q?jcsBsRZoUQZlDbJSWbu570QXq7q/VrYOIjizkkAqD5phZzr3pRTvIfWCD41g?=
 =?us-ascii?Q?aQR+fEVoxoOcs+2Dx3AjsvF2xsp8ughj3ExZXA243hZ7e8M5hjKIBj1hQkTT?=
 =?us-ascii?Q?lpvPFLag+NeJmnRFinoTT00JhT6p+qPFUJqS6bMjaaRbva/ysk8YUdfsMfdk?=
 =?us-ascii?Q?g8A2DrB4aP7YwOeFLgl0/B1bnvptfkWQdGItRcaEnpXHvmnpeu7Qhzf8aeU8?=
 =?us-ascii?Q?dGZD7Qd9Plj/sZek/RO13X91bNHvS9vcoEGN5MCNhalNjUfbz20SFpjy79Ud?=
 =?us-ascii?Q?WwI8X33cYWLLojn+FTC/4+UbQHHifqDCbacrkcsV2ewCzs3lf4DlzgYiyrQF?=
 =?us-ascii?Q?K124X8O6Dn4mYaIlR60hdlApvwLO9T4+SsV9XbJbjPki4xuJn7op+ayuiDUa?=
 =?us-ascii?Q?Hrp0j8QWyfW311zMKS6M0hRgDZioa7557mBiYfCtEGqHRF1sIlZ5DCmXRuRy?=
 =?us-ascii?Q?DpO2GQ0AqzfYOKd9dppnJ4H1QTjV3sBCiIHnKiejqXxFy8Y0C/P0AmwfN9uj?=
 =?us-ascii?Q?e32hAkbET5cIsSEOws7s22QhKH8Q6c5AhaOBnnP12u6cLHBWyUxxOAb31516?=
 =?us-ascii?Q?XzE8BBFYq4Ns8XQUCjyOe91GwPmMqJrJt0Rnc2aIaFpEyOMA9/pL36QbqxUj?=
 =?us-ascii?Q?CdhoVDIryw6pbJqAiDAsfNLZURXxGi695HF5LZP9J7wYI8zIezjtwjfzpiB1?=
 =?us-ascii?Q?iMEuxMZdFcXzrVlKHLX7bmDOC3TBV62iuWp0VbcZzgMF2UV3V8Z8aMGLlpcZ?=
 =?us-ascii?Q?SdExtQk1I0QtWTp3TQ1glDJb/ht3i5APZF6JwMn+QDL8yeb+UqCqKL1i2CXo?=
 =?us-ascii?Q?y1hbTfwSp1vKH0KS5797Mjlr9sZm6ADNnK4rdELroRuTApj74mkyiG+t2mwL?=
 =?us-ascii?Q?Y0D+ZZlUijYSWta5g2fLAIGeH/fsxQ45fzMRrm+rrJUlepYGBrwgtrzV6GuM?=
 =?us-ascii?Q?+PLJ4FhU040n/7VWmFZnj4Jc1rrIjqAIciNCTOzmnNmCjFHs2fPOWrWVVT0G?=
 =?us-ascii?Q?PdO8UBKbYHVIRbTrwYEYGd0CqXbksLVviWADsYCmU+3INPAx/jc+H4T/Q10V?=
 =?us-ascii?Q?dkmibasZWRkk7fxwsamnvs4nEORe8el9L+t/ZH+lFLDwnTfxpXYc21Kgu2o/?=
 =?us-ascii?Q?kCTYYMY5UimeFUI+7UED4W8deRgdkrkOP9cz+yNLUImTX86uGRPeem36Z0E8?=
 =?us-ascii?Q?5MtY89eDT9rnzy/QDvG9/I4ziWYy4Dqgb8xD9Fk96x+Tw5fyQ5kUEU5hfDoX?=
 =?us-ascii?Q?Z2VCACowpcGz9Bjwp/pPjjADC4ybwnrstMOFysW1Ep6lok6PgfBkxC3q9L0n?=
 =?us-ascii?Q?L1KY/JfUPWf/nYvYkFj3ABKFv+tEMjsRm0+YOjbv0ieMj8yJNSoGy8NhE2jI?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc4e4db-dc1a-4668-f122-08db342f168d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:05.1768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjxjHhJnTitZk7VaAqqH9JP+5BkwTaJBKxZHuZeCIAN4ds8a3aEnvkOI/n/Ljbyvo1XPhG6hu6Mgz/im2If08Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the multiplexed ndo_setup_tc() model which lacks a first-class
struct netlink_ext_ack * argument, the only way to pass the netlink
extended ACK message down to the device driver is to embed it within the
offload structure.

Do this for struct tc_mqprio_qopt_offload and struct tc_taprio_qopt_offload.

Since struct tc_taprio_qopt_offload also contains a tc_mqprio_qopt_offload
structure, and since device drivers might effectively reuse their mqprio
implementation for the mqprio portion of taprio, we make taprio set the
extack in both offload structures to point at the same netlink extack
message.

In fact, the taprio handling is a bit more tricky, for 2 reasons.

First is because the offload structure has a longer lifetime than the
extack structure. The driver is supposed to populate the extack
synchronously from ndo_setup_tc() and leave it alone afterwards.
To not have any use-after-free surprises, we zero out the extack pointer
when we leave taprio_enable_offload().

The second reason is because taprio does overwrite the extack message on
ndo_setup_tc() error. We need to switch to the weak form of setting an
extack message, which preserves a potential message set by the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v4: none
v2->v3: patch is new

 include/net/pkt_sched.h |  2 ++
 net/sched/sch_mqprio.c  |  5 ++++-
 net/sched/sch_taprio.c  | 12 ++++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index bb0bd69fb655..b43ed4733455 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -166,6 +166,7 @@ struct tc_mqprio_caps {
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
+	struct netlink_ext_ack *extack;
 	u16 mode;
 	u16 shaper;
 	u32 flags;
@@ -193,6 +194,7 @@ struct tc_taprio_sched_entry {
 
 struct tc_taprio_qopt_offload {
 	struct tc_mqprio_qopt_offload mqprio;
+	struct netlink_ext_ack *extack;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 9ee5a9a9b9e9..5287ff60b3f9 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -33,9 +33,12 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_qopt_offload mqprio = {
+		.qopt = *qopt,
+		.extack = extack,
+	};
 	int err, i;
 
 	switch (priv->mode) {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1f469861eae3..cbad43019172 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1520,7 +1520,9 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	offload->extack = extack;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
+	offload->mqprio.extack = extack;
 	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
@@ -1528,14 +1530,20 @@ static int taprio_enable_offload(struct net_device *dev,
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
-		NL_SET_ERR_MSG(extack,
-			       "Device failed to setup taprio offload");
+		NL_SET_ERR_MSG_WEAK(extack,
+				    "Device failed to setup taprio offload");
 		goto done;
 	}
 
 	q->offloaded = true;
 
 done:
+	/* The offload structure may linger around via a reference taken by the
+	 * device driver, so clear up the netlink extack pointer so that the
+	 * driver isn't tempted to dereference data which stopped being valid
+	 */
+	offload->extack = NULL;
+	offload->mqprio.extack = NULL;
 	taprio_offload_free(offload);
 
 	return err;
-- 
2.34.1

