Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F84967F37B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjA1BII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjA1BIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:02 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827E14E530
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKFjtRltkobpjjFm0Wz5DDOpCfnCvDo+hNAxT79YRLos/uXlNRGm3Z1JO0loVsBWAtHYdN+jrI9Q5uOeT63f7iNvcnEDWMQAo5bSInXHDJ96lSEUW21JtnRRh18Igj1t4MQTnhfvT4PsDZGn0cDF504ju7uaUMmL9TxXmQ9g5L4oIQPez3B5G+8F1gCSyAbxSPct6S9hIdy60QnFB3TD98Qun8bz46QtDeeivYJSVZM+Jv00vF1iTa7f4yhh8ZOd5EUmurpbdeqPPNfSMnFpLgqopdigCXFx1uQXZU2W/RUxkZrgD4AAce/s6cPI/b8WZX+rf1imoAQ4FO/2b/DO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOqYcKIvUO2REZekzAq5XFnQe1lhVmnCay507mskTDA=;
 b=f+k69YvEWEUM0nV06v0s9RlmsdFqRe1VcRFxdGrDJjJ5zdHe7M5rq2KhcqQ6zT9WB3jI70OfQgP/0G+cZAvRwhBfVhLFPGzhzhDaRkt+fiyAhLO4WRa+qYdRKJKv2u6xR6WOjG/JeAW+Q3VQAaWlL7CupAX87LAaOjWxAq9221L7mY6iKzLeCLJ2WW/VsWav8Qg0pist4dKw1nqcMSNZtbt8quWDSMhq+qXY3wA0wc9a3SSg/HenyYnT+iQTKeoafxSRspSigTN8PcN43q180IszLQbxC1u6MuXI8hNnUEXTlPyY7brOBhrJ6lRCI/DbcKBmDhpCTyn2eSDmBTY3yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOqYcKIvUO2REZekzAq5XFnQe1lhVmnCay507mskTDA=;
 b=Ng0ur42a35wQu/vW4elTFCDXEc3ULeSDurA3GCgdFVuwT5x5r/kCFvpbwEEN1G4dP8TlkQfkJbQXNg2trRM95BZJtUChCPzbajVtwvzqn+M8DLP5ndubYOqW7drGXbTbU7n9DykVFIiIKPubWJkDP1nkhQRvNlaohfNcTMmiz8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 06/15] net/sched: taprio: calculate tc gate durations
Date:   Sat, 28 Jan 2023 03:07:10 +0200
Message-Id: <20230128010719.2182346-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a39277-07a2-4573-d48e-08db00cc14ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oCUTo6K5th1yNPc2BIkYmU133UQ/W8f1W749IIRPOFr2a1q3SQyuDUH2xxJKD/W7GM4Rv74sP5srseOcwJK5MRsQ8B5RBf+n9VL2Ij2um5YpnOLADNYaXU8F+Q25m8Moz2esxocx4osW5e6hrSThRE+jRmuKGu71fXf+g8g+iO42SbRcRzADbQUaMv6xKFnJLeRX/YKfk4dZPNRAE0MWIz8xbJQm0RptJdwl8sF6huDoS7EFK/5xMu2At8iD2ZxNHqbhn0I9+LMBg5e+L1rriRpeYdOCOaXu/ucqKzL+nbAb21wmg+OH6dwNXZixGfCgW6jmlsg1OlnwOUSYEyBRpf9caSMDtPjS1YjF5luEAE9V55oYscN5FDh6Fg930Rkey1BCuXqSTdv2S5gJRLPHn4bIFx+2H71Bhykykh+kEKoBUX+eppZlBkLmd8MFEyAgbYRiCK9jcYT9+h78vaXhmoKHVHJulh3l1nwNOwyPrhsiuloCMJEXDqNxcEvVu/vdU4aOOjsURkDmmtIUtLrJEgMO6FkdO4VjN3Mx+9sdJC4eUYcZNh1xByxxpL/dVpb7OoJWEc4BxEaGlWKSC2tDx3ZMH9wOwEBg2PpNxd+5Jd16GiFRbXiNLqeQuTaMOyuEF6SsoWMltcwVrcbl3AKrvdILB+5vCia9nnBFXyV9Jl2Or17ha4r+rzgRtYCzoQ+XMqKO451RSAogWKkaOSBWTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vjg1wq14o/NxSrzbOQKixayjhr4RxPQ4kYkgpfyQX4iiJoO/lYhxOaNti9i1?=
 =?us-ascii?Q?AntWU7dU69Foh/joSWAJnOA7FwdrQIp+3z+mgOQTYHFk9vwSmbgSW4xJlPj/?=
 =?us-ascii?Q?RYJFp0+HKVBLtl89VVs9SAycxTAcTFys0oLHZydap4ktQ01CFXCZKlabvo11?=
 =?us-ascii?Q?QBbWrX35hA9Qv9qadTxJt0uBiKOL5CAO42NdBF3BQ4HZ7fxh1oEA0DuSqbsf?=
 =?us-ascii?Q?sEhodSjoWkD0do+3Q4tqV/k41HVdhUasHDPDeRP+VAuk/rPwbGfEMkjZ8zBZ?=
 =?us-ascii?Q?IJY4BTboCrDElLYwY2LdV0M5W94NjxkYPjNiPv3TV5YQZV9icNKS+Sa2jSm+?=
 =?us-ascii?Q?fcqrwydvj8zL95XGOJB9j3OU1PVX/7H9AckJfXibO0C0dqWr8UAGS5AMPLEs?=
 =?us-ascii?Q?IT5sVqmxajyYIune8pVZFF2mtXAsiYOIsb3OSXzQ08562pehMHqIWcrV8ddH?=
 =?us-ascii?Q?+JGL48thxx+Hw5JDoDPUsl2/5I9xvVV7DojK2isymOyVKgCy/M+rvh/D31Yi?=
 =?us-ascii?Q?JF/BfBKSmouzKKCrI5D1Sy+Mhx6NeDw+qp4EDbhDDpLQcFJEHdQ2/oYMx4B3?=
 =?us-ascii?Q?XMqQu0E+uROo3MhSpMXFrugQGwK+z5yFhhWHvIfOIp/Yib0uRSOU3oYZz0AQ?=
 =?us-ascii?Q?u1ErmhOJlyK3tWY7QNX6ODivxTXJiNqDdXQ2FlPvN7XPet9TRnLDrSTBpSm9?=
 =?us-ascii?Q?goJOBzpGHx6VUBntz5G/6s5w7u5mVG8Q7IoGu++yCWaJST9uoW5AH71/VKkj?=
 =?us-ascii?Q?200zup+Ep8tlK9OUPT9wAX8yXHZLkSFyuXbjItLYFbIgOHOcZd6E8Ffw7LR9?=
 =?us-ascii?Q?eWWLfr+KoenSyWbZDVVnTfJ1P/m6Zj9xSdL3INpX01qUUFsMmCWAxHg3UWg4?=
 =?us-ascii?Q?yQR+YttHHZSI6Z/IIicD+vrNUnn1BQ90EqTBF1K3ue40Ul8H23hZzDOhOrr5?=
 =?us-ascii?Q?POXnLggz64qgsyj6OUitxwFovfw0+3QHUTBUeGvKpLOLacBSyDa240LKXSYu?=
 =?us-ascii?Q?nnbIcJEFnUsFA5jVec4Wj4chnE1ZiP2k9O0YE7ZFilWMCXf2xnGh1aNJaLRq?=
 =?us-ascii?Q?zoWWdWEpXFJ6mewxaGuSq0rMOdB8qw70Ip196ODnCddbasXDW57LflZGNtl9?=
 =?us-ascii?Q?n+kvgpup1Ykw33/Ul9ajuK6BxhN1rTBCnH1bb3mkIA0mZIJOoc78ziiHmHgY?=
 =?us-ascii?Q?uW+fbvoe5ZPPGNYozga58s+g3qscGN+UkDNODAYvWuk0JiYL93fiaiiJZsyL?=
 =?us-ascii?Q?iZnoxqDxV7tuw/1joJsAC92J64CgYfIFoiBBPUuvuKf+CrdI6V3uDvmO3MWF?=
 =?us-ascii?Q?kZgtwQZ91d1zMxMi3TLIZ7FK7vYKWFejTxaqSXH61uu9XKFP4LbdhWtt9qxE?=
 =?us-ascii?Q?0qoSJvgPmzQLpzoIyFe/TKU9fP3nhMmTERkpdCLTdHIVxssWJME6OT29X6su?=
 =?us-ascii?Q?Pv5ncMxwfxzUMeBW1EDABvF+P8ga6V/INOq6JXP4Ao6gG4E2O2ZP8lYyom73?=
 =?us-ascii?Q?+T7ECzcCR8xAudrbXzBAziNXHBl1jXlD4+AT2InRUn892jxPnZXEEdlrb80q?=
 =?us-ascii?Q?9czr/6FNm7S73orJfgqSY154vnFIm2OB+Kb11qWj9HqAwMGZT8XdLCzL9jFO?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a39277-07a2-4573-d48e-08db00cc14ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:52.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPwe86+6EVHh3onFHpmrC0iljaVG1SjNDv2+s+5JETYz+B6oyb9NagmOQ/xRqVb9op1LySs56Afmh5vjTKsQWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current taprio code operates on a very simplistic (and incorrect)
assumption: that egress scheduling for a traffic class can only take
place for the duration of the current interval, or i.o.w., it assumes
that at the end of each schedule entry, there is a "gate close" event
for all traffic classes.

As an example, traffic sent with the schedule below will be jumpy, even
though all 8 TC gates are open, so there is absolutely no "gate close"
event (effectively a transition from BIT(tc)==1 to BIT(tc)==0 in
consecutive schedule entries):

tc qdisc replace dev veth0 parent root taprio \
	num_tc 2 \
	map 0 1 \
	queues 1@0 1@1 \
	base-time 0 \
	sched-entry S 0xff 4000000000 \
	clockid CLOCK_TAI \
	flags 0x0

This qdisc simply does not have what it takes in terms of logic to
*actually* compute the durations of traffic classes. Also, it does not
recognize the need to use this information on a per-traffic-class basis:
it always looks at entry->interval and entry->close_time.

This change proposes that each schedule entry has an array called
tc_gate_duration[tc]. This holds the information: "for how long will
this traffic class gate remain open, starting from *this* schedule
entry". If the traffic class gate is always open, that value is equal to
the cycle time of the schedule.

We'll also need to keep track, for the purpose of queueMaxSDU[tc]
calculation, what is the maximum time duration for a traffic class
having an open gate. This gives us directly what is the maximum sized
packet that this traffic class will have to accept. For everything else
it has to qdisc_drop() it in qdisc_enqueue().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7dbb09b87bc5..fe92a75701bd 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -35,6 +35,10 @@ static LIST_HEAD(taprio_list);
 #define TAPRIO_FLAGS_INVALID U32_MAX
 
 struct sched_entry {
+	/* Durations between this GCL entry and the GCL entry where the
+	 * respective traffic class gate closes
+	 */
+	u64 tc_gate_duration[TC_MAX_QUEUE];
 	struct list_head list;
 
 	/* The instant that this entry "closes" and the next one
@@ -51,6 +55,10 @@ struct sched_entry {
 };
 
 struct sched_gate_list {
+	/* Longest non-zero contiguous gate durations per traffic class,
+	 * or 0 if a traffic class gate never opens during the schedule.
+	 */
+	u64 max_open_tc_gate_duration[TC_MAX_QUEUE];
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
@@ -89,6 +97,51 @@ struct __tc_taprio_qopt_offload {
 	struct tc_taprio_qopt_offload offload;
 };
 
+static void taprio_calculate_tc_gate_durations(struct taprio_sched *q,
+					       struct sched_gate_list *sched)
+{
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
+	struct sched_entry *entry, *cur;
+	int tc;
+
+	list_for_each_entry(entry, &sched->entries, list) {
+		u32 gates_still_open = entry->gate_mask;
+
+		/* For each traffic class, calculate each open gate duration,
+		 * starting at this schedule entry and ending at the schedule
+		 * entry containing a gate close event for that TC.
+		 */
+		cur = entry;
+
+		do {
+			if (!gates_still_open)
+				break;
+
+			for (tc = 0; tc < num_tc; tc++) {
+				if (!(gates_still_open & BIT(tc)))
+					continue;
+
+				if (cur->gate_mask & BIT(tc))
+					entry->tc_gate_duration[tc] += cur->interval;
+				else
+					gates_still_open &= ~BIT(tc);
+			}
+
+			cur = list_next_entry_circular(cur, &sched->entries, list);
+		} while (cur != entry);
+
+		/* Keep track of the maximum gate duration for each traffic
+		 * class, taking care to not confuse a traffic class which is
+		 * temporarily closed with one that is always closed.
+		 */
+		for (tc = 0; tc < num_tc; tc++)
+			if (entry->tc_gate_duration[tc] &&
+			    sched->max_open_tc_gate_duration[tc] < entry->tc_gate_duration[tc])
+				sched->max_open_tc_gate_duration[tc] = entry->tc_gate_duration[tc];
+	}
+}
+
 static ktime_t sched_base_time(const struct sched_gate_list *sched)
 {
 	if (!sched)
@@ -907,6 +960,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
+	taprio_calculate_tc_gate_durations(q, new);
+
 	return 0;
 }
 
-- 
2.34.1

