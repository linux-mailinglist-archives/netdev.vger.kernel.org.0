Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A000469A248
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBPXXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjBPXWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:22:53 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2089.outbound.protection.outlook.com [40.107.104.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037B65649A;
        Thu, 16 Feb 2023 15:22:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEMZcOzVKmNcmCDrlxVxu5mqgtaCMCVFDtzbtJO3SRRhCJ3lTsr/CJQ77P/I1z1hOK3Bbj8WFNPDCYPQRnh+c+cra3JWIHRn8imZ3ARnjiCB9qKeY+uX8pd3wS2ciqxuybq2XdxmAg3fbjbTq3xoZFLu60hkcYARvVL2qMC39fhwaFhEuwOKOQJxwqiLycV3uqUPJX0yZk/iAzC/OHl3SJbh7ZG0YhyvWzHDvmfJoZBxJtzvVFNgOXir7kIsZN8nK0bdu1DbmYAWTjRi1+QHBni5yVRNFSwYQfyLEQDf2tH05XvgOVe7xATOBB+yPgAq5vW58BWNrNnN1Ohg6e3LkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCvDGlqEhmhBrzdjS8pON7A+LMxlN3DCWgftb1a0e4c=;
 b=gv6HjnAL3bZ+fm/AsYlzgXrI3cII2KhDWWP9YnbblvF3ky7Y34ZoUA91AW9F7bxVCw/wU7h2Umt3BVR6pioLt5LjysaiwJUEsIXkDMpMGZ1kDWWF7aQu8jjP9JLjeF4c0hAhHB4jtWLy9kDnjVnuZSztQ0ktFFsJOnPFsJL/gdAMK0+vGfdj8Ybi4AWX5sBNaZxPvf9f7tjZ7blXfJp6tGNIvcbv2kXWzlSmrJTNgCa1nIxnXFgqJs5uIpJOnZhSW1tDM8WI1GoAWMV/zvxNtS4qXkvl9h+x8O7nQ5bXTmvpXK8ns8OQRcj3Ieg3aTLfi8P08MHwmnIV0JemUda88g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCvDGlqEhmhBrzdjS8pON7A+LMxlN3DCWgftb1a0e4c=;
 b=XMfhiQs+4xW4wgkK40Qes54uo6WI3v2+E79njHCEmLVXXiYc3jJIfz+qUB+Pt/XzjW+7YaNxj4psG7Z+1JWpjNT9q0abMYMsfdqZUDM83elSQTYZAXbFbyUZabcQdqWiRAW6kNCrWp9YNxO/0z3RpLIdNCVZB+KdLBWNqCX+5Ps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:51 +0000
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
Subject: [PATCH net-next 10/12] net/sched: taprio: allow per-TC user input of FP adminStatus
Date:   Fri, 17 Feb 2023 01:21:24 +0200
Message-Id: <20230216232126.3402975-11-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 866e3292-624f-4095-9b5e-08db1074958e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XTb/A/qxWQLqjJucye1ye2OAfzO5x3Xm2qlzhN1g4LB4EYpjgbnhH/Oqw2II71Y+IyDpb8iRxMQoeNF4wL+UP2zX6FG9ljrjNObUwYP2/AUVNDdI7f3Y9j+QSOtMk6nk1eUevP/RKNIG+zVGqQu7+cZjf/hwCGkwdV3vC2laDtqGAygl/jvadJW1M2ziQ5X1I4dJSnRDO61Loh47hn8VOFbWMKwAKVhL8E7k/h35QJvO04uza0bOQRABhx2/l+nPnnaKl90/RxeMaEiEtmzvmRIt6hyCDqaKgRhxCChIvo1hWwxy16E2JmFj/OghRidpJmz6tKLjBXkSZRRAaujPLkU1BnNQPb0pidaYvkjUtXezOkxusS13k1rSV/5/n1ihVDXVbNigg0F40e95oHQ5Gk5vpm8A+o0HWJYLT1jcZs+8zS9jFrD9E8djQ4YjGuGeW5bv2vCCnKd/beDTHeGjqUe/6P4+Gdt3Q/gypLLjoQ21Kn7dXaOMi/lpkl/v29Y8Z9kN9M81f9WKo3yX7WKU7P4VZbaSoxOBrFOZM7fW5EVSPQ3/NR9AWBKfN+WKccHl1v9AUU5WCu7z+Il3M3bKP1J69uQJ83zZDggXK9TGlN+IBWr//JVA0lDWOq9Ua1WUWCWvNqBZDgG5RAMvbLO3S6Ej20R1DKobwvq8xJDcZyPmJQ1bJ7ijwPNvdmxC9sgW8KswfTj0YiBmhtlFVB/XEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/I+1O/x6f5xpSBvZL1jxU4PmvaWlENKjdQXNrYTmp+pFlft5GwzVZnrLjy8N?=
 =?us-ascii?Q?l0uKGj2lpUtPD88ETJAKyHPHAHFaAWOGUdGz77b2S0P9+DxMLUBR+bU3AlMn?=
 =?us-ascii?Q?YJD/2FPyyLzEZke0KG3UPbVbKVJWinzxjjSqvqKQGJlDvVukQNpWccts/aFK?=
 =?us-ascii?Q?Jhv3wtR/u6RpUpDysBomUM7wX0kSToUck4ET5PHifXnqxSSgiNoERBysO+Qn?=
 =?us-ascii?Q?PvhfTDjVgnbBl8ni8fgCOvg54lmaEVV8x07ooBAMoWpvhXXBo9iwURHmWx2y?=
 =?us-ascii?Q?VZ/bcKE3mK1SnL2dvXJF0z1IoYpdPP2I7MREZCJnT1xsfDNEuA3Wz1UeORJJ?=
 =?us-ascii?Q?K0rxIj7LRJzHTxhRhvU+SxEN9uLWIXqpZHOANXAygbnr4RKxr5INpodinLCe?=
 =?us-ascii?Q?6Tf7bUV8CsxGJ06O2NJYVs9ecwA6YM+44i9s/2G8qvviZ1S+6KFBz+c5s2MY?=
 =?us-ascii?Q?amQt5AK0TcTiVtK/9TKJRa6HUr/17Yno3fkCj91p2RjpsceYFsdt1Esob3Hf?=
 =?us-ascii?Q?h/O7EH8Jnq15uEF3OjS+OEkoe0KWNrYSdHqn8GudVtq3QbGfk0ywJjSwc8al?=
 =?us-ascii?Q?Md5AvTv+18LkVVp+FWN8/rRwQYbZoyDLF7N8GvnTaLuxabS2H7GN6tBOxhtq?=
 =?us-ascii?Q?/lAAJl/RW00N69R8DddyyOU8XSkbO9ieQ7wke3jT/GvkVKk++uvFYjVsG+5g?=
 =?us-ascii?Q?qcd4dJtSe9BB+QknQGiHIANaj+adWv4uDSQEdxceSi3c+4iiUBuiSm4Vbgh1?=
 =?us-ascii?Q?9f0r2TE8rKVyEHAR7VwTrPST17z2rc7ZnSi7GZT4w6hWfUXwScUE8VUPDbna?=
 =?us-ascii?Q?iN/A/c9pSGxswkYsI05tcWyxd33Qxditdf6P/g+xQ5Ae+BPSayjsYSoW+kd2?=
 =?us-ascii?Q?mgjQXY6rymVGr8PCmjJ6FoVHO35KhWE+WjhCAPhlsjvut6oU65VF/CruVmNH?=
 =?us-ascii?Q?78tXkm50eLifKtexnBHoNPZT+m/gEEBIYKUx9UomC5e2oFfgBDlsRSN9kiV4?=
 =?us-ascii?Q?wBOyOxTVNKnil+FZ1lQ7rYrPnZh+Scu6NljwH+UsHf5XfgH0QMZ5M6+bse/W?=
 =?us-ascii?Q?ICwcr2FrkvjeWW+/7f3myrz+COrfqvcGJbvOsetx8f/nJDJlqEVG6ZjOe7yM?=
 =?us-ascii?Q?wY1c+IDYf1BTNpH5NUZrE0KEu+Nfbq7TSY06N4yCu54hrPVjQZOlniA8ecV6?=
 =?us-ascii?Q?rmpDKLF0KSkLUBaVrkZuom171wwn29L0SGVDbUL6Tr9X9KcuNsrjKGasLyI2?=
 =?us-ascii?Q?t1os8gTyV4xhWsJ+7hgxfbgsGvb4MH8IbKYlAVYVLdQVOgKkgzLX4Blgs+xG?=
 =?us-ascii?Q?rT3dhNDOA/qc0lsbqMRhnhXkj/HvfsLFmzvBJXlxG8Is7IFnJ/jI6It5uX7+?=
 =?us-ascii?Q?7TUASKcRXg/39VkG7x3pppUhSy6jMLEiobIsHMKV+O7z+bOwZ3sT+dWhht5P?=
 =?us-ascii?Q?Oeh27GNMBJ/jybLQeBQSLKSlzJhzFV7SDT3QieRuilWJgMG0B+CXYiScdMWw?=
 =?us-ascii?Q?L8l8SbzqI2N8NKO0IkJzfqdWyhoeU21MfCuE0KMdZDXCUW8JBsggR/mbHrWd?=
 =?us-ascii?Q?4p1CHTnF7Be0EFFOB/njwA5TsfIwTQhD8fOkFMXCfCH4gyoTpa3hl/ZjH7fG?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 866e3292-624f-4095-9b5e-08db1074958e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:51.7115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RZaXCZm0066613oHBlFoj1I3foNaWyJSzPsHbl4DcdO2e/ihSK0k6i9xC1zpQXdbQjl3L5Nx2a/nWpnHBF/uQ==
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

This is a duplication of the FP adminStatus logic introduced for
tc-mqprio. Offloading is done through the tc_mqprio_qopt_offload
structure embedded within tc_taprio_qopt_offload. So practically, if a
device driver is written to treat the mqprio portion of taprio just like
standalone mqprio, it gets unified handling of frame preemption.

I would have reused more code with taprio, but this is mostly netlink
attribute parsing, which is hard to transform into generic code without
having something that stinks as a result. We have the same variables
with the same semantics, just different nlattr type values
(TCA_MQPRIO_TC_ENTRY=5 vs TCA_TAPRIO_ATTR_TC_ENTRY=12;
TCA_MQPRIO_TC_ENTRY_FP=2 vs TCA_TAPRIO_TC_ENTRY_FP=3, etc) and
consequently, different policies for the nest.

Every time nla_parse_nested() is called, an on-stack table "tb" of
nlattr pointers is allocated statically, up to the maximum understood
nlattr type. That array size is hardcoded as a constant, but when
transforming this into a common parsing function, it would become either
a VLA (which the Linux kernel rightfully doesn't like) or a call to the
allocator.

Having FP adminStatus in tc-taprio can be seen as addressing the 802.1Q
Annex S.3 "Scheduling and preemption used in combination, no HOLD/RELEASE"
and S.4 "Scheduling and preemption used in combination with HOLD/RELEASE"
use cases. HOLD and RELEASE events are emitted towards the underlying
MAC Merge layer when the schedule hits a Set-And-Hold-MAC or a
Set-And-Release-MAC gate operation.

A small part of the change is dedicated to refactoring the max_sdu
nlattr parsing to put all logic under the "if" that tests for presence
of that nlattr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_taprio.c         | 65 +++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index b8d29be91b62..51a7addc56c6 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1252,6 +1252,7 @@ enum {
 	TCA_TAPRIO_TC_ENTRY_UNSPEC,
 	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
 	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_FP,			/* u32 */
 
 	/* add new constants above here */
 	__TCA_TAPRIO_TC_ENTRY_CNT,
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9781b47962bb..c799361adea4 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -96,6 +97,7 @@ struct taprio_sched {
 	struct list_head taprio_list;
 	int cur_txq[TC_MAX_QUEUE];
 	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
+	u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
 	u32 txtime_delay;
 };
 
@@ -994,6 +996,9 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
 	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_FP]	   = NLA_POLICY_RANGE(NLA_U32,
+							      TC_FP_EXPRESS,
+							      TC_FP_PREEMPTIBLE),
 };
 
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
@@ -1514,6 +1519,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	taprio_sched_to_offload(dev, sched, offload, &caps);
+	mqprio_fp_to_offload(q->fp, &offload->mqprio);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
@@ -1655,13 +1661,14 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 static int taprio_parse_tc_entry(struct Qdisc *sch,
 				 struct nlattr *opt,
 				 u32 max_sdu[TC_QOPT_MAX_QUEUE],
+				 u32 fp[TC_QOPT_MAX_QUEUE],
 				 unsigned long *seen_tcs,
 				 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
 	struct net_device *dev = qdisc_dev(sch);
-	u32 val = 0;
 	int err, tc;
+	u32 val;
 
 	err = nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
 			       taprio_tc_policy, extack);
@@ -1686,15 +1693,18 @@ static int taprio_parse_tc_entry(struct Qdisc *sch,
 
 	*seen_tcs |= BIT(tc);
 
-	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]) {
 		val = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+		if (val > dev->max_mtu) {
+			NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
+			return -ERANGE;
+		}
 
-	if (val > dev->max_mtu) {
-		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
-		return -ERANGE;
+		max_sdu[tc] = val;
 	}
 
-	max_sdu[tc] = val;
+	if (tb[TCA_TAPRIO_TC_ENTRY_FP])
+		fp[tc] = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_FP]);
 
 	return 0;
 }
@@ -1704,29 +1714,51 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 				   struct netlink_ext_ack *extack)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
 	u32 max_sdu[TC_QOPT_MAX_QUEUE];
+	bool have_preemption = false;
 	unsigned long seen_tcs = 0;
+	u32 fp[TC_QOPT_MAX_QUEUE];
 	struct nlattr *n;
 	int tc, rem;
 	int err = 0;
 
-	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
 		max_sdu[tc] = q->max_sdu[tc];
+		fp[tc] = q->fp[tc];
+	}
 
 	nla_for_each_nested(n, opt, rem) {
 		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
 			continue;
 
-		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs,
+		err = taprio_parse_tc_entry(sch, n, max_sdu, fp, &seen_tcs,
 					    extack);
 		if (err)
-			goto out;
+			return err;
 	}
 
-	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
 		q->max_sdu[tc] = max_sdu[tc];
+		q->fp[tc] = fp[tc];
+		if (fp[tc] != TC_FP_EXPRESS)
+			have_preemption = true;
+	}
+
+	if (have_preemption) {
+		if (!FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+			NL_SET_ERR_MSG(extack,
+				       "Preemption only supported with full offload");
+			return -EOPNOTSUPP;
+		}
+
+		if (!ethtool_dev_mm_supported(dev)) {
+			NL_SET_ERR_MSG(extack,
+				       "Device does not support preemption");
+			return -EOPNOTSUPP;
+		}
+	}
 
-out:
 	return err;
 }
 
@@ -2007,7 +2039,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	int i;
+	int i, tc;
 
 	spin_lock_init(&q->current_entry_lock);
 
@@ -2064,6 +2096,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		q->qdiscs[i] = qdisc;
 	}
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		q->fp[tc] = TC_FP_EXPRESS;
+
 	taprio_detect_broken_mqprio(q);
 
 	return taprio_change(sch, opt, extack);
@@ -2207,6 +2242,7 @@ static int dump_schedule(struct sk_buff *msg,
 }
 
 static int taprio_dump_tc_entries(struct sk_buff *skb,
+				  struct taprio_sched *q,
 				  struct sched_gate_list *sched)
 {
 	struct nlattr *n;
@@ -2224,6 +2260,9 @@ static int taprio_dump_tc_entries(struct sk_buff *skb,
 				sched->max_sdu[tc]))
 			goto nla_put_failure;
 
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_FP, q->fp[tc]))
+			goto nla_put_failure;
+
 		nla_nest_end(skb, n);
 	}
 
@@ -2265,7 +2304,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
-	if (oper && taprio_dump_tc_entries(skb, oper))
+	if (oper && taprio_dump_tc_entries(skb, q, oper))
 		goto options_error;
 
 	if (oper && dump_schedule(skb, oper))
-- 
2.34.1

