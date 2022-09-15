Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC13C5B9927
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIOKwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiIOKvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:51 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7C9910B7;
        Thu, 15 Sep 2022 03:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSii4I9/Ck0OE3fm2fcI8pVPA5CUioRIh88Hr7LondvYrk5otrl1+sdrG2n8cC6M/apPEmwpC8fHMTXTPYrXooo1W/yLb0C/EyFCF7zQyfR7EkFAKgLpqvBuVkPmHjQV6TJ7RHEiKb/9MNOqAEMueOOd5t5jEbWvYucYf9jkD5Xt6YL3sciNhYQZOXL5OcK8JfJcAIL6gbuPRYKus1hvG62pXf0djhmI0/oKvXvG0C+SYjC5XkaeSuuv24UdR3IpyCAkKzNWY9QIRDYGyP/u0qCRwnL6UjXmcF6FwDktd77Wt2FLGObb2njdT/tVnHfEzLGQCrtIlBFddxnZaZMgOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW9ktne2TZBssJRUu9LXBfJO23SUlEmnNozeqIhBq3s=;
 b=f/hoCfzJLSg2I1IWwxr9J+Kx4kDm/9fm90XcI9dRkB6w5Gj5r9j+9m8cMzvU0kA/uFivLIF0ySNZvA9EG6Q20gdC/j94ZRO9dwRL+ooOyf2m681ZEfcWdvaHc75R/pcmEuLpNI3pccpdwbStrRiKM6eBDRIRsWLJvN1OFHrF8SCyJzC+jaR5WtMgFoFe7If0PzmJ2mmaz0LzgnUGH8QfNhcKc3zdKFSfFhZEMF6hWtMFNN7ALy+PACd6T8UqNjLLsBvImDYuLnY9ZP1ftmQBiJYDjrz6yJRTN7ORXLLg/ggEbIo1CTkicW4fp0im0Tk8i5ci1+BAJ8guwJX5GGB96w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW9ktne2TZBssJRUu9LXBfJO23SUlEmnNozeqIhBq3s=;
 b=oWwppnwkFxYJUnV1d+r5PX7nUdhfsRWK1cRwXCvoDGWthElrldhau2jnDSd2BJg12bCHzR2eu+q51J51BEqVFSXLyu7QJDV9d1+wDT1KxMOidFm5paX/qOImQi2vuhU+DOd4XCdCeEBhaiaGputg/9fzUsMJGb48pq36ddeDVSM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:51:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:51:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 7/7] net/sched: taprio: replace safety precautions with comments
Date:   Thu, 15 Sep 2022 13:50:46 +0300
Message-Id: <20220915105046.2404072-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: d0cfe20c-a5b5-4897-d0f5-08da97082ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfiWG5A4fsMD/Deeke+nwEtEmNZrnMz79V7zkilepT7ouCezMW0gbMhQ9GCf5sjY5qGS0ST0K83BtCkqvCMukAT61OJoJ+cOYuCscCCMaqm1/iMR+o7a4nFtPYMaz/ddBOfjNpAGwi2FLy8y9URun1OzQC+Yqt1gG+ZBmZ1Y5y/It3lTEtuCi0KJzN3ofb5t8KXlFC1WWyq/Q2UQOcVLJYCEOWZaGHq9oCgg5gcUm37XzYL2LA0a9W1HVm1GW1PbUOT0o4lkkjqInqzBkIF96KUScYPoNGpM3g0bAARZWtQVVnWKWltQ1UnRqikaygY6AfUE5kxjnn5bwPIXMb0XwYr7P8HXbLYUpx6m4VS2nSPmgBpc66Qs4yy46hA/kDnz65rzZiAfF1nduZFuw/Y+lc0wPbjBc/tqK5FvIcR6+jkO8s3R0t1dfHfMPUC2knl8qYH4MijJLgH6clapdvnFnuJWtu/IVI8CuCdBNH7QVPUDGZAlQx8swAGxv/vyyRSRBHaCtc6WVD3O1yV0AK58teovnPDvBzgqW8HoTDQ81tO6AXIzHJvuOE3SHEvyvHjsIBYWyAAHngVgIVBjmHiV7nqZ5UUm4+2nKMVQQfE/g+tCbXRbmv6FUUFYLFkz4pDpc4LAjws3jeygRiAZjPl/gN5ff+5sgEeWFfv2aS8HL3dhTDDzASLw8mtl6qxA8130d3be9WvvxX+u5wOrY+ESbdGmX01Knk1HD77rKsj3jxdzvJOVDPWJDWfrA6Vokuk0Fj78rLWVOoV/WCE8R6ci2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZiIIunfDhheC4nEi6l+M1hqOmqmzNZmzVpI8Ej38+v2DN/sITgY6GJ8N8x1/?=
 =?us-ascii?Q?MdkyAj93Sb+KmaEf2gONn9fQoy78cQlyBAqzQI2q6SI8VCGRZr+b5XsUbh9w?=
 =?us-ascii?Q?JtO3VDID8Ctw6CwIHyS50d3M2EosCl+gW/+oJt9g7dG40S1q3bjS0Xd3ct5o?=
 =?us-ascii?Q?q5y1lAnVMKrtcaurQblyYtlU4thFSrn8LIsgPXfCPFpBFRE8cj6CqANUnYAK?=
 =?us-ascii?Q?2wdMXdge/XKyG+e0d3j7S6FFGAll/V6Owro0tFeiZo3E0jOTyw1ybwyM3XKs?=
 =?us-ascii?Q?Rrtb4wlhtF1jCJSP5nTq2DHdv6hn9rj0nlIHWx1Xxb0P6CV7G6EaR4nneAoq?=
 =?us-ascii?Q?d9xNTEBDmhoS213uux+b6+SR6tDA20bd+2DITFB+UexwiOQI90/Yh3UotBEf?=
 =?us-ascii?Q?r5LmRS+Uz2CqV2SaROBm2wseghTdZJZeLzWxYYHOeDYnff8SaJJufI/KIjKg?=
 =?us-ascii?Q?5M1Qw41j6zs4AHCmQhbtuizx3R+v14ug7/ilHM1RO/rPyWk3zdgVyYSqlyfZ?=
 =?us-ascii?Q?qaY61b70vYg0RLOcswV9uAS0skQy861lcnKKB459I+i0LiBLN1JvaNgDKmbS?=
 =?us-ascii?Q?UTYnrKJvmPoNwGZ2HkEzyIokQV5gfom56JYE0Eh4HtXW6vnFOFt4wVgquv2k?=
 =?us-ascii?Q?6IWrY/CkQ1iGEvVr97G5c0doizIZBw2cYpb0yC1vEtkLIhCNvI40LS/Mk2Z/?=
 =?us-ascii?Q?CnFlPq+JoUPb/fJx0QZh6XBQLZAZz0oKuPGscG0L/k0gepXjWv0PWUf5nHNt?=
 =?us-ascii?Q?FnDsn5luIR1DpuY6n4dt2iMMwt48rtmU7WNcnJNCTnnstNHjuOaoIG4ABRPC?=
 =?us-ascii?Q?9QqaSyqn4j9rjBWey9EnbspJyPFweXdfGykQMRTrxJOILFDorVp+JkHdbxtY?=
 =?us-ascii?Q?UAOsrwU+EzA6vAswXH7pmFWbP/d+5x/n/undfktSQlpRws99LNxzCxFFiByz?=
 =?us-ascii?Q?75fuBwih2j6hDLxsTxv5XqoaOJLT1I/h/c23/ylMNcBK42XQ5/2+gWN9qQXp?=
 =?us-ascii?Q?MWg6rfJQWPlM+T+I6WRvcXzgEO4KkVlLx8VHC3HysVQHQBdYyhJt4Y1EzAy6?=
 =?us-ascii?Q?hYhmzx1xLBI9a1KUoEj5+wD6szMYzCkzsKleiZlaskRf4Li0ZVVAAlM+QFI1?=
 =?us-ascii?Q?GYIbZ8XvThhLd1AIClJ92Rd0oWFZRekeYj2JwRpeGqLT44GePBAYP+bErsff?=
 =?us-ascii?Q?TTMAFcu4xO+ifMb3wRpg3p9RvEj0P6CKM9t4IKa1Y+l/ZcpZ3rdtVhRYfN9Q?=
 =?us-ascii?Q?X5FuZOAoVSV1wpcMtS3m+Ug9POk8wGMbDIicuhdc/UOTSDITXZjzemEFKdHM?=
 =?us-ascii?Q?mPNqbLRLKa+STauOtyMPDCCzB3QlNXbe55qRYWoXsJfb9Z5gk4JzsU6SeYc9?=
 =?us-ascii?Q?UlsiPKcUTra72DhU3OYJ5OpJLoX5JNe8FNJNJuecBh/jX0nOjzRb8cVEDVyC?=
 =?us-ascii?Q?rOooIY/VZLp+E45mZdFXmjBoGp1l3vS/rD/JqgONNStPoavxaS4qrORarGVF?=
 =?us-ascii?Q?Mm1mMKv3Pkd0EsMn6t/WwqUFK7zDtEfca0vaV8md8GJ/Q0muHW77Orktfl5H?=
 =?us-ascii?Q?xI8QupwmW4KJFbEaz9fQuqHancP8kbY0xTjF27Lq3rRhKm25XdpAEqWt4b+6?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0cfe20c-a5b5-4897-d0f5-08da97082ead
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:51:02.7521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CxonATBTueT+K2MVQdWosPMQJ+34bM3+V7qCapqzMCN3tAXBPRwTEFxeHHQKT+YmO7pTej1y5EXoWELBRAAsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WARN_ON_ONCE() checks introduced in commit 13511704f8d7 ("net:
taprio offload: enforce qdisc to netdev queue mapping") take a small
toll on performance, but otherwise, the conditions are never expected to
happen. Replace them with comments, such that the information is still
conveyed to developers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/sched/sch_taprio.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index bc93f709d354..8ae454052201 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -433,6 +433,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
+/* Will not be called in the full offload case, since the TX queues are
+ * attached to the Qdisc created using qdisc_create_dflt()
+ */
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
@@ -440,11 +443,6 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct Qdisc *child;
 	int queue;
 
-	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
-		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc configured with full offload\n");
-		return qdisc_drop(skb, sch, to_free);
-	}
-
 	queue = skb_get_queue_mapping(skb);
 
 	child = q->qdiscs[queue];
@@ -490,6 +488,9 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
 
+/* Will not be called in the full offload case, since the TX queues are
+ * attached to the Qdisc created using qdisc_create_dflt()
+ */
 static struct sk_buff *taprio_peek(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -499,11 +500,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
-	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
-		WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
-		return NULL;
-	}
-
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
@@ -546,6 +542,9 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
+/* Will not be called in the full offload case, since the TX queues are
+ * attached to the Qdisc created using qdisc_create_dflt()
+ */
 static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -555,11 +554,6 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
-	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
-		WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
-		return NULL;
-	}
-
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	/* if there's no entry, it means that the schedule didn't
-- 
2.34.1

