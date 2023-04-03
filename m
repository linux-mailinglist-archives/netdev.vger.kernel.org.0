Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0454E6D423A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjDCKg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDCKg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:36:29 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2055618814;
        Mon,  3 Apr 2023 03:35:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYBlyB3i1HnFhZB63iL4k17PCnjQMdw+6u6oETn47iVWcmiaae2F+1wmtYZh/ncur5V+rlSgkbzrHHMDtAvbKka6VnrmP/oLQ40xLWh0S0p+gRN8TEtAxDWdBAD37ZfoJ6gFrCOyBEVV+5B7fPJXi6q4bQX806RW1ljNZ8ccdsWTbwOzt7nYas+NGM+ZRgLeW6kDgTg3P6FWjnFsG5IBELZv6auoHopYEUsOKnDUsjMo5jrqarXNHrewez4MX1adTLwJFe1nP+6kE1MTCRQ17+IMGz8RuJggRgoI9kIiNchjRiHRLOKsUSWe4uxPUVm+Av6kiS9Kho9MgxtLeevwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xnn6SUEXvga/kGi9NL4C2sICKQm8Xp7hPuNKrgZf3Iw=;
 b=CFNg20lqjHIFlw/MB6yD1THmW/YktJy+62oizaiEpA9+Ky1YU2tL+Sg2IxklXl/IcMzAkLe30bKr6xjFxM0T8Wn5FQ+wjJz5sw7kbbDK/k53FA3bm22kIkPtnZigb+26ZM0cOotp5qaBmOBzW6XJB+nuXIFFwBR96dD8mpkGKW/aIyXkftw8yI7335/c0poVWxTejNavD+p1Mon9goRtm3rIMxpYlGG77t/DAMR1auxQ1YZ3gGNlNtT5k+ij0dlRKP5XILJAiqecJgeXhqjFZ7boq2OkUE+NJtSQgvQkMpxe44GuMexuTXfWY2A0amzsoI/3PLWnCG5EVR1+hmbJYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnn6SUEXvga/kGi9NL4C2sICKQm8Xp7hPuNKrgZf3Iw=;
 b=W/S2GHC+xwjpCtRjAPfdrCEwkf9JGpmQlD7ZKWf+vC37a+saNxkhYnjUhgMeY37jO8x+KwG/l8Ggue1OtEM6xcipFXGvi8297t6GnEEn/l2M/2lMmLXOG6Cm//4yL8muP7NZeBVKUOVQbxbBS10E3xoVk3nUD5PUMyifM0T9sLI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:08 +0000
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
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 7/9] net/sched: taprio: allow per-TC user input of FP adminStatus
Date:   Mon,  3 Apr 2023 13:34:38 +0300
Message-Id: <20230403103440.2895683-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 14d46c10-a1a8-4c13-e6b6-08db342f1890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OdIj2e0vqV38pZ3p0DDyK9BONOWRRoHmmGSyclCAesCi29apZvTecpXeo3gHYPeRBSsdXtXn/ZbPSpyF7jIHIt91TOIjabHHlx0OuSm8xNwwOW4ii6yz22UKc6C0pGuRIVYWJC9RcmTB4+e9HBoG6Zzkqk79ylP0WmtW3bYazV6POCJR7XFaNx/+suH32n1duMNbqaCuUIV41gtd753Ibb+sWkC+rcLyd2O0v8vld2McENN9ZK6qB35IHRO0s7+3LmV9xe4cBUhNO1E4bYRDy9NWwNf3Ac1bT6kIFBzqE9pTeslb3atvh+Gs6ool4y4sTsXujUchoVlci1GHKVvKtSUGuj8K2X4GqhsHCwWZ/pDA0G46DEoLZ9KgWrAz7ILrpB0vsymFtp9UXECca/2B6ZWic3IlenOmORlJITC7RSQCQfLQzbgSXgD8NOaIL/4hXi5h2i/JtrdPZhHPQhOTTyUp+jVQppdErfZiVgl3w+FD9SRb5GAkbTEUEr0Wjzpf4tihERySDzTCQ2t9vT3HkSflK64lFPGdq/38SkBX8RWcJmDZ4Iw4EqZpcuIl0IK5z7vY3gktF/AbaHzwoMZxS8vdb9vbesqi/c1ouCSCuWPSayq3JRdXRv+GWFd+rcOJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ULHkn15YaFLB0wjV7vVddJyEMHYGj/cJ8RrSGSjuP69tsGpIBHGD2M+MuxWm?=
 =?us-ascii?Q?/0oQb6VxmoCh/LzRvDwqCNqzrdavKjp7CxZyj/sSdZ1/CJPlWvBzso/Hx6oW?=
 =?us-ascii?Q?rXianxOfsn+AjY44vu0okeoElWEbJQH4bHt+Hu+FvgwOuh5MPgA5xKmbd+BS?=
 =?us-ascii?Q?PUly1WvuMVS0iWd8r4SzcIETcWz6otXHVR+Jjki8th/X0A8UI6NcuYpuyaL3?=
 =?us-ascii?Q?FleztRGRwD7t+hVdqtwO3yphkjGejj0rKCFZhV6xHwjdyVkT2rRUZZGE4l4D?=
 =?us-ascii?Q?Co9MGkp6+IONbB3CHqNFxGbquyHi2baRxgtLYPBH+zetlDTQ9jOA9j+j9seg?=
 =?us-ascii?Q?ftaooE/jP3bcNC2gQQIElmmwNL2gzrozKH/VIabjcVw/2+LigPWKhp20x3TE?=
 =?us-ascii?Q?nxhJlKurjrDhXzBCy90jM3v+PzHXpdX0XHjFmtRbJBH10RoRjwHZxoAAodp1?=
 =?us-ascii?Q?3wnFB75qVVFSMOeYR56JeG344KU5MGRXF05cETm12DY20KRU3EWZ6RomCEAE?=
 =?us-ascii?Q?AU0MjrK7ot9sRj2jcnkzfIGCZy2HuFYVcfHiE3vt3B/vmlj/1qm8clE7/jOa?=
 =?us-ascii?Q?jaEU9BH8KXdMU8sXQl6l4EzSj93t0g3j4r6mIsVz2A+AE33gBt1cRu+r2pou?=
 =?us-ascii?Q?SvrYCxG5QAUt85yLPZSKmdIRMHmBJSqSQ0JWiFHQaP4vqtyzLiNXmyYjhWU0?=
 =?us-ascii?Q?M5Q6UuC9ormjWdWYTMvboU5fBzes1H9uexrIvaA70Po1iqmsOQapkQndGUQq?=
 =?us-ascii?Q?XDIz8jt4DlDZGuWImh1QeIJpVBUOrE1L/ZEK89uLqj58dgf3KeBV5mxXfaE1?=
 =?us-ascii?Q?ZUyfjY09gLqzWuFDnWjHkWEu0/giKEYIDQZLCXQhEatye9yAFhHn1nODHcHG?=
 =?us-ascii?Q?/MooUnXJ9T3QQAUAdAl55nyaZ1cThRV9M1O6ZnJHN470z5ru4vIv9TA+pWRn?=
 =?us-ascii?Q?VKGX9xinmG2NGMrI0kdGxo3euoCC3vd9RH02lbyxcppBPvT856JeTVz/28Nc?=
 =?us-ascii?Q?D8u0u4ToxNOKrd8QLUf1+xyaHk6noiZBpAqCwU/x3tx7HhLPttzk0DdOuyuc?=
 =?us-ascii?Q?nflN7/T2LNT3pThArkN2qpMzJsv9kT/res5srw6NRc0xJXv/OihGeH+XRFAl?=
 =?us-ascii?Q?tg1NYB+nmpL96sgQzOq+uDClxEw8HbFMQCRD6DNGWFIAcWZ8O7AKq2QUwA6F?=
 =?us-ascii?Q?fadx5yzYBn7EDT56u+viXaW0CPotEEdnEyZLRfH/6QpHfpa1czQAgrNWVmSZ?=
 =?us-ascii?Q?YZtJVgdg0hRI1+UYnkKeZva2+EIk8u1IO5HbcAa/lhFG8vVWX14q8z8cu5Pq?=
 =?us-ascii?Q?7y+V5C1afvINoobDrjLJKy2QEk9WEvPdvdc5pXmDuC7cLyBHSC+5LVhK2msS?=
 =?us-ascii?Q?usx7lLUmFygtmepy4GAOSUfuUkyxKxr3BOkIIHp1rS4zEoD/VSRuqx6iZInm?=
 =?us-ascii?Q?lmAciyHsV0OoejCwg4KLlZuz3g6W3zee04nv/4gIbNttc/kwcZyiOgFTNAN8?=
 =?us-ascii?Q?q3q+Fm4/TIkZWlJAiW00W2Zk6/ceY1fq0+DSCkp3eH76NScUk4PHBG/qd6OI?=
 =?us-ascii?Q?5fiDIcwUPWbuj9lI1yXk+WPCL204g3rRgk5YqHQLP5oDyYirZRu29Lx59qt4?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d46c10-a1a8-4c13-e6b6-08db342f1890
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:08.5380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aPxr+1VvkEnu6hFdTy1Y2cx4xkNbIMhkeFS7OspXqfXxc6/nB7pNdhIdsyJM+akdkDx/WEcIztKagBJpwzUeA==
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
Set-And-Release-MAC gate operation. So within the tc-taprio UAPI space,
one can distinguish between the 2 use cases by choosing whether to use
the TC_TAPRIO_CMD_SET_AND_HOLD and TC_TAPRIO_CMD_SET_AND_RELEASE gate
operations within the schedule, or just TC_TAPRIO_CMD_SET_GATES.

A small part of the change is dedicated to refactoring the max_sdu
nlattr parsing to put all logic under the "if" that tests for presence
of that nlattr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v4: none
v2->v3: none
v1->v2: slightly reword commit message

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
index cbad43019172..76db9a10ef50 100644
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
 
@@ -1002,6 +1004,9 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
 	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_FP]	   = NLA_POLICY_RANGE(NLA_U32,
+							      TC_FP_EXPRESS,
+							      TC_FP_PREEMPTIBLE),
 };
 
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
@@ -1524,6 +1529,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	offload->mqprio.extack = extack;
 	taprio_sched_to_offload(dev, sched, offload, &caps);
+	mqprio_fp_to_offload(q->fp, &offload->mqprio);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
@@ -1671,13 +1677,14 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
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
@@ -1702,15 +1709,18 @@ static int taprio_parse_tc_entry(struct Qdisc *sch,
 
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
@@ -1720,29 +1730,51 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
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
 
@@ -2023,7 +2055,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	int i;
+	int i, tc;
 
 	spin_lock_init(&q->current_entry_lock);
 
@@ -2080,6 +2112,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		q->qdiscs[i] = qdisc;
 	}
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		q->fp[tc] = TC_FP_EXPRESS;
+
 	taprio_detect_broken_mqprio(q);
 
 	return taprio_change(sch, opt, extack);
@@ -2223,6 +2258,7 @@ static int dump_schedule(struct sk_buff *msg,
 }
 
 static int taprio_dump_tc_entries(struct sk_buff *skb,
+				  struct taprio_sched *q,
 				  struct sched_gate_list *sched)
 {
 	struct nlattr *n;
@@ -2240,6 +2276,9 @@ static int taprio_dump_tc_entries(struct sk_buff *skb,
 				sched->max_sdu[tc]))
 			goto nla_put_failure;
 
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_FP, q->fp[tc]))
+			goto nla_put_failure;
+
 		nla_nest_end(skb, n);
 	}
 
@@ -2281,7 +2320,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
-	if (oper && taprio_dump_tc_entries(skb, oper))
+	if (oper && taprio_dump_tc_entries(skb, q, oper))
 		goto options_error;
 
 	if (oper && dump_schedule(skb, oper))
-- 
2.34.1

