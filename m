Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7995B8AAF
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiINOfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiINOfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:35:02 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20070.outbound.protection.outlook.com [40.107.2.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC721573D;
        Wed, 14 Sep 2022 07:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBGZ5KR9X97ClaYubKd3HFUtdFtizzOZHB3JgQHwyqQA/F7KiCtY6VKRpkhzexzmMeBefzCL5Ls8djJuAK4zbhwfYZq9EgRM8LBigMHl1wSqspPpUJCJR773+KKE4n4xqeVu2Y2Pul6dEKQneWrq9acJ8HIyqHT2Acd5WPBuWAYwqfxbEM3ZhtRTiiV4IEI6cw/mnM5293JoFwAZmBwdmNZ+Me9dGkPuO1wIL1c40Ao4ENiT5OCDc0+nWldnXLyZiet895HcavDJhPsdXQzYFzDgjLwx70f3UafUuUMZ9czowU5BsI/jucHdq0q1PvdzyHGxuRFTfzBQeZA0pZ2EJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kaw/TwpbWuqLR/n8jJbVh7aNWJ4BEk19ku3HInWWwA0=;
 b=N+EIwX1HDdX8g8q53L8wDupFNZH7mv88mnskhOBHQ5no7a21Fj8CVihF0kpZGqMP0W0ShHX7s690ScacrcIky6dod8ZBOpk3A6xQTSX95HvinY6fmO4VaBSJWPi4hXbirZ3QTjmX9WMdfDS9bVX5WINbN1b4QKrNOIKlUosx+F9thOPDQE/A6Vb52C5V5hgsV/X8Dq5WcCCb72JmVFl5VdnPL0xt0PIg/0wHH8PhvRH5r0hevppRZZrKeqWCXFPfTiOBFCwYELt2xeIQ58twJGv0BpVdeqf8q1CWd/++Ez6Xt3Bzjgyvdba1c6k8s7SmZI5IvUxaDEsQxLh1C4Bw0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaw/TwpbWuqLR/n8jJbVh7aNWJ4BEk19ku3HInWWwA0=;
 b=icq+R8agagIO/A3U57SATTTI7aq5zok4XMpWWvUGcR3Hf3H98Zxqg7TN76dnZT7ldyLUBK+5F12wVwh5a1w6BPn9ftOgyW1lm+1AhI1Wl8iY2Qb3DawQFmwUY9zAoroLcxspF5MSLCn64DF5+J4oYLCNzaL0x/GYnAJBAs248aA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6777.eurprd04.prod.outlook.com (2603:10a6:10:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 14:34:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 14:34:59 +0000
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
Subject: [PATCH net 1/3] net/sched: taprio: avoid disabling offload when it was never enabled
Date:   Wed, 14 Sep 2022 17:34:37 +0300
Message-Id: <20220914143439.1544363-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
References: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6777:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a62248-6897-4c1f-5124-08da965e4cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pu7SfbI68u/5pW/Ej8TjbHp6X6RnSMVZLIaS0ETeJNPdfap1hiCFZRpfDybCXVE58FYg4k/zhVz2Us0nEhRHAwp0Wq0ozaPoz002gokoQ2khfAMb973ZMye5aaAB3evMfSRkzJQFNKQzltKRL2EbWzbYOLJmZQ2lF9UpaCC3UaOHaTYb2tWRXmVi5wHzowUGlgZlq9Txm7yFj2VzwkfhuEdVYhT0NKBiTp3abXgn6hqrnDJ/FDlakGLpy+8g9wQsV5njnXkJ6oP9AX36yPxGXj6SkqGFR+NVj8+yg98tpSOYORTKJKEGfNaH/5Jd6rgyJoCjt6+r2weHqyCUUfggVyMtLBAudhK8AqvQWjX4qEb/pQZ9fseqXoCrW9TF2AKUAPaHZ7RXlh/RWz+uHTO3QEFl3eFwCwQc+H0ltw+Ktzod3G+YOzpRBMJOzU00zUU8/t5sVKBbI4vtdfhGW72evCo2+Cc/gT7rtzY8DRkgSRfaqSBlnJWC5GZPiIQdfIh9QYsRrqlJepBFYe8a3/eo6TA0JEf19okl14LTTU57Z9SsWmSVlG19lJc4aXAMuiDO8yb2UUoXiky3EMMX508VqR7/UrXbohgLyxKmG//ynrP5LFiY/Y5JMxIBI5H4YwMMy0NYJ3DD5da6boRVbNBP/am2yiCE3Z+CNEtvBbxRrSveEefxrj1I7zgN+EGRgyQf/zJcplnmGlOuL8If++ScaFdm9H6aUL7+4dsNUIDOx97ikWuMcD6eQe1G+EgfTw6vpU2wdGQAjAIdzy1ZfC4HGfTu+nQcbsvJXwYjJqM8ynE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(6486002)(4326008)(38350700002)(66946007)(5660300002)(6916009)(6512007)(7416002)(6506007)(2616005)(1076003)(66556008)(52116002)(36756003)(41300700001)(26005)(83380400001)(86362001)(66476007)(186003)(8936002)(44832011)(8676002)(38100700002)(2906002)(316002)(6666004)(478600001)(54906003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1BnE4FkYyGZ6RAIimw9c60DBX7CgnvOp0rKSP6LZjKW2YW/qzpx97h1KZ6Y/?=
 =?us-ascii?Q?TDPvatFAd3HlRnShtu3HV/ELs+Cnmor2s972PKZ9PSc8geabzPaEbTop5lkW?=
 =?us-ascii?Q?COOg0nQTtTGOq3Z/Ns55o5D6C8Tzg9DF0auFlxL/6M7sBqYnId94HzTyybwH?=
 =?us-ascii?Q?vm3wVWrid9+A506H/LjH5OBtEjSlBkfMNl+XUAG+mJNLGECfYh0aoCNhycXT?=
 =?us-ascii?Q?uq6m41I6gb+6tHnfwyP3Gvi/RJswcVACaQulx8moWpJp1tQKN3YXRMqsQlXw?=
 =?us-ascii?Q?lqfD293BfhLOD/Z+NVfLAcmkkunfL8tSacw7c84caYPlefvzC/evudSjcVNB?=
 =?us-ascii?Q?iZBl+aUzkBZzZ5ECXzZRB6h5hygY6cJOjohIFq2gO14nmg9aVa5PsZWCQRLV?=
 =?us-ascii?Q?2b7H+h4UIVNbg3aJ1bBnBMqtCIqsyJ3Ocv0Q8NgBtQzj+/trJ9uJQehV5K2N?=
 =?us-ascii?Q?rXjdXrnEBBoeh2dJzyE/I9r9mDP2kW+akwoXBbrM8U2BAZR7ts9aG7cjtS0U?=
 =?us-ascii?Q?jdK6v9QV539lpj7lOdU7YH1DGKNoXczTyToeQylcQQoD/oFWvZf7my4p/U8M?=
 =?us-ascii?Q?kVNHa9WH0mmcif1N6mbt3taETTOjDyhP9tXnYzPuuafEqPYSop3r5NzvNEpv?=
 =?us-ascii?Q?fEBQMNWJk0jUx99Wln+CSMayqDLgwtTnPY30PCYpXuz0aWckckq+t2zr8uho?=
 =?us-ascii?Q?JTSqMAtP2SWSfOnQZB8ZrMxcQqyzdizhcCGmilwJb8EWkzu03aGAf/vhC5Dq?=
 =?us-ascii?Q?iHO5aQJTLqEwX8fHStdflAfSMwFGvH3Q9g1jqcDNMP9FD5f3l8TI4iauYCBl?=
 =?us-ascii?Q?K/SCjnVV78bgcRQ3sYPh5u3zFauHKHELgru00TCFu0ahEDWNELKzJyYzbuA3?=
 =?us-ascii?Q?d6T8n6mjrynAlvTgHBfnxzAnd2Oak216HyUqhweAOU903ZA89p/tcLBNBFP1?=
 =?us-ascii?Q?KQo9TGXRdybdKy2z3PtpqiH3XZySocYjWWYWrEeNZ7GK2tPaMzYn8HQ7aela?=
 =?us-ascii?Q?0OAqyCtbeBdJz/9UR8h6TkwFgZgRon4zoBBzRdDX73riD3JYzozAzFey8KK9?=
 =?us-ascii?Q?eXst8gf5JMjlSeVJP+y4deg6qHhvq27OW0neS1LNKJ7Bm6wDrFm/z+pijonv?=
 =?us-ascii?Q?ccgvC34FtXfDg7XJ3wWNXkdjpmG0yIIN3xvQn0fOcF2T6qsPDAVX12LadlhM?=
 =?us-ascii?Q?YrHKdispkqmNlRG43VDjIEe8LssSBcw6VqZNn6UtHnixjb+b6BV9tdjd6wC/?=
 =?us-ascii?Q?C+BsMoiPPGK2XYKmd+R1C/04vZOyROZL3S77w9QkbX7l17asI/qIuX4JGWLD?=
 =?us-ascii?Q?PrKsnPL1nvYG2A0Yxb1dodENfEPZfPo8NPjT1dD3Sn74qqC4TtPFRfYiJgYL?=
 =?us-ascii?Q?f5Q5EIim+rOgZwdMJ1QWJ7g/e7GB+TPnEoYHbQinoHJhCd+usNghMLNFzeQ0?=
 =?us-ascii?Q?isXJilRdJEwSrYNS+bRs0Mi2YdCYKzQM/KjhSu68B1cP5gVY7S0aNZZ/HScj?=
 =?us-ascii?Q?aJN7kOu15gbGUF2onxdiupi9WtbD3OOHCjRWAdVxr9Ulu8Laiyurg+kacOYH?=
 =?us-ascii?Q?K9JN2zversnD14wOsJY9RwRMsmv8y/K1XxagHTT5yDWM4GVsPvuooGVCiJz/?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a62248-6897-4c1f-5124-08da965e4cda
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:34:58.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uTvK3i9Iyg86YpjPxlkjzxJCFVvZ9ezFVTl9Qj+11Al/JHK4TMabqgzLwSBZzWv6TxuHdQM4AEeBFglZAVMlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an incredibly strange API design decision, qdisc->destroy() gets
called even if qdisc->init() never succeeded, not exclusively since
commit 87b60cfacf9f ("net_sched: fix error recovery at qdisc creation"),
but apparently also earlier (in the case of qdisc_create_dflt()).

The taprio qdisc does not fully acknowledge this when it attempts full
offload, because it starts off with q->flags = TAPRIO_FLAGS_INVALID in
taprio_init(), then it replaces q->flags with TCA_TAPRIO_ATTR_FLAGS
parsed from netlink (in taprio_change(), tail called from taprio_init()).

But in taprio_destroy(), we call taprio_disable_offload(), and this
determines what to do based on FULL_OFFLOAD_IS_ENABLED(q->flags).

But looking at the implementation of FULL_OFFLOAD_IS_ENABLED()
(a bitwise check of bit 1 in q->flags), it is invalid to call this macro
on q->flags when it contains TAPRIO_FLAGS_INVALID, because that is set
to U32_MAX, and therefore FULL_OFFLOAD_IS_ENABLED() will return true on
an invalid set of flags.

As a result, it is possible to crash the kernel if user space forces an
error between setting q->flags = TAPRIO_FLAGS_INVALID, and the calling
of taprio_enable_offload(). This is because drivers do not expect the
offload to be disabled when it was never enabled.

The error that we force here is to attach taprio as a non-root qdisc,
but instead as child of an mqprio root qdisc:

$ tc qdisc add dev swp0 root handle 1: \
	mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc qdisc replace dev swp0 parent 1:1 \
	taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 \
	sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
Unable to handle kernel paging request at virtual address fffffffffffffff8
[fffffffffffffff8] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Call trace:
 taprio_dump+0x27c/0x310
 vsc9959_port_setup_tc+0x1f4/0x460
 felix_port_setup_tc+0x24/0x3c
 dsa_slave_setup_tc+0x54/0x27c
 taprio_disable_offload.isra.0+0x58/0xe0
 taprio_destroy+0x80/0x104
 qdisc_create+0x240/0x470
 tc_modify_qdisc+0x1fc/0x6b0
 rtnetlink_rcv_msg+0x12c/0x390
 netlink_rcv_skb+0x5c/0x130
 rtnetlink_rcv+0x1c/0x2c

Fix this by keeping track of the operations we made, and undo the
offload only if we actually did it.

I've added "bool offloaded" inside a 4 byte hole between "int clockid"
and "atomic64_t picos_per_byte". Now the first cache line looks like
below:

$ pahole -C taprio_sched net/sched/sch_taprio.o
struct taprio_sched {
        struct Qdisc * *           qdiscs;               /*     0     8 */
        struct Qdisc *             root;                 /*     8     8 */
        u32                        flags;                /*    16     4 */
        enum tk_offsets            tk_offset;            /*    20     4 */
        int                        clockid;              /*    24     4 */
        bool                       offloaded;            /*    28     1 */

        /* XXX 3 bytes hole, try to pack */

        atomic64_t                 picos_per_byte;       /*    32     0 */

        /* XXX 8 bytes hole, try to pack */

        spinlock_t                 current_entry_lock;   /*    40     0 */

        /* XXX 8 bytes hole, try to pack */

        struct sched_entry *       current_entry;        /*    48     8 */
        struct sched_gate_list *   oper_sched;           /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index db88a692ef81..a3b4f92a9937 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -67,6 +67,7 @@ struct taprio_sched {
 	u32 flags;
 	enum tk_offsets tk_offset;
 	int clockid;
+	bool offloaded;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
 				    */
@@ -1279,6 +1280,8 @@ static int taprio_enable_offload(struct net_device *dev,
 		goto done;
 	}
 
+	q->offloaded = true;
+
 done:
 	taprio_offload_free(offload);
 
@@ -1293,12 +1296,9 @@ static int taprio_disable_offload(struct net_device *dev,
 	struct tc_taprio_qopt_offload *offload;
 	int err;
 
-	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+	if (!q->offloaded)
 		return 0;
 
-	if (!ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
 	offload = taprio_offload_alloc(0);
 	if (!offload) {
 		NL_SET_ERR_MSG(extack,
@@ -1314,6 +1314,8 @@ static int taprio_disable_offload(struct net_device *dev,
 		goto out;
 	}
 
+	q->offloaded = false;
+
 out:
 	taprio_offload_free(offload);
 
-- 
2.34.1

