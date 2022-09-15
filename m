Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E025B9880
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiIOKIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIOKIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:08:19 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851F786DE;
        Thu, 15 Sep 2022 03:08:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghzCn1H8+xk/pyGULErh0zW8JAU0cEfgDxxr9doWoNl//RTyog0QEjdXnPu0gGMjbCngoBW0oQ85h5iRcuz7/YuGWvDntsCu+rB+Ib4oROLSafwCLg3Xsx5BoWWkykImRrPJih8d4dqYHB1ylLNFOHBTpHaU1p4GDE8cCBR932W7VB7G+nGWSZep0gFNuJkIm+w82Q7nnkEb/Pk2jzEzVTM3wGZ0UyN7xQkuWYBYIi2+tuIG/vQQqTPGnCYT054/uDZn4/SHsZscJedLzLeH1XgRW5PkSWRdgnakdYWa3Pf+xCNHV8mllYW5Zjp6C1j4eZdvOzLZRJgXzNDMzgCb6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1cEpC7dI6MxexLrdDAp0QrohFnmK/Yl1Xip60t5zHc=;
 b=GkDbyfenCpX05LadljICha3MhTLXLA9/wGzTNhFG537Akov4YI1uqUJnTHsSRE4uDiTMrSlyTl7WWuOGCCPj0ygc1WXXuZC27WYrgcBngrt+RpQb1HiPK6iosYT6YpuuF3g+8mCiaY0KBgFYXPXOMhWPGaTu71KZ0/DAtAxmwLiXdiBlywZ0051Q0oaoVqHOfjMINdddd5fQ0hH5L/YGIriFTSnHd99F+okX5wwd92LzZyowgIoVPIsAZr51qtWFylkAl+D3Q6KcuL3Ps9iGoQHl0xyNA2X6E1pToPpkAx/FlyTpaq+xV7FI++mzCFS5X3cNHiZn3UZ76WNBzF7ZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1cEpC7dI6MxexLrdDAp0QrohFnmK/Yl1Xip60t5zHc=;
 b=AdjKjIMaijgN3PgsiTt3xGSsogIuYfxeafrGmpPzFJLjWbeH17V5FFt0qrXOMfIfi3CaPlsaGxN+bUo/uFOE6COQyu+BcVAKcQW/kwtaxrm4EWspuH8T1jrBzO9w5Kgy6aYNsRAFgE5yr71X6a+0R5r/YSNR7E8yJf+XIV5dh2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8457.eurprd04.prod.outlook.com (2603:10a6:102:1d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 10:08:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:08:14 +0000
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
Subject: [PATCH v2 net 1/2] net/sched: taprio: avoid disabling offload when it was never enabled
Date:   Thu, 15 Sep 2022 13:08:01 +0300
Message-Id: <20220915100802.2308279-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0044.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fe3bf46-6863-4062-5c9f-08da970233fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmhMtp5BO2wUsSiPfKVRiuFRk9XSeYwnGQ8qWO23wmoO33TvanUmjcymbd0zbfwkalUQCMIq0Cq3+6XZcvqHHfyh8jdAMMbzKhW8QSwmttOUMh36otT/+0lux0TOiMswVNAhb93WwQRzX4YHSY4OYPov6q32QgrC34dxBnxUhQtAcp3koQ80UNiaIYCUbWQc//cxCQAUjFIdiZC6q5BLvvfvBDuyw0eEQsTsqurdH3zCespXalF7Co8za0KKyBVER40pDRcwgDzd1EhYfuTXdBujZt5Sr1q6IvcWNLSSAHc7yLQqasoGaJkaP2WDv+rtLcWjPs6YPKa7uwMRPixgBeevOPmwJ+9iSqoCVPDCLi39UPACF8utS7xmzDB3+Ff8hC/4/yFhq6Bqz8IVma9oDuCaWqFLMmXsahFCv9jiXpbxc79rFYIDAlJ+XWQTizskl2642OlPWehJ6UuKw0OMCurHVhPHtouW1s1oNm+D2lz8v/4QbL3AbEbCrx5rPBFUvOygBI4ZvFpxGRxgXWlx/FfM6Btd1l2AzWJWH8BHm6nR2zoCE/0ttYFOw/MbC+h7meHiyB/YRvWWC//HcXDrI8C+7lormjlBjyABxgDpPNGFGnDn0qQVA5gocvhiAhxI6QrFQP2II7kMUyo0X/uMo2VaPB7Mc4CGgXM39p5nwAotYAf7IikQAyu/6c8+TDTXb6fr4zwaojfAtI9HnQygkyv3v4dfQPyNI0li+xfrFzz2ZxopmGQ1AdjPpiOiv3U+N/sAOqE9c7cwgWvjsk+L6nk6xt+19BvjaD6tw+cu7Jw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(6486002)(2906002)(478600001)(41300700001)(6666004)(8936002)(54906003)(38350700002)(6916009)(52116002)(66946007)(316002)(4326008)(66476007)(66556008)(8676002)(36756003)(38100700002)(7416002)(86362001)(5660300002)(1076003)(186003)(2616005)(83380400001)(26005)(6512007)(44832011)(6506007)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K6A7na6YnZviuTEwpx7FFVtJuHceq1fGNDBERcbTm+6Ar5Pr//g90H5d0KyO?=
 =?us-ascii?Q?KnovIvkvwMyCdQKH1Z84XIYnA5gF0wbO7UeCMDu9/vlvj93xdiXD4QXpxpox?=
 =?us-ascii?Q?IHgiCkD4ejI/lKvt0RR5Bu5uevI6QR0/nmES90HUMr+sF6N8kzZG2cBZeJSY?=
 =?us-ascii?Q?AihBZ/nqwXXUuuj9JRX0ZH8uMbu+UjWSXx1zddB10Do2+wpUaup5P0bdhjsj?=
 =?us-ascii?Q?7fa0nrc3Uu2X5ag/9WT9KsYRT+gUtoKClzLkV+BI+mqlJzhHuZVNNpeDN2y1?=
 =?us-ascii?Q?QvB3q1nCK7MFKBk6VELu2eJkAYq4eybzo2+9BG/k2w+q5PyKVs1vh25zqKJ1?=
 =?us-ascii?Q?/C4lX8bzZDWw2TP5EBhcWH4SkJoCk8/E9xc3EdP0yH51qGbnsWIzUKaiEl0c?=
 =?us-ascii?Q?LMNH/G4wWRRIuJRmXptI4HaajMtnqxHH7BCxgX13Fle+bMUiBEuVBxAeyASF?=
 =?us-ascii?Q?nDU2Aq9JERXNX26JYxlrxjbHimgPXaJUFdCYIgKNMYAqJdDfgSUtKp9N5mla?=
 =?us-ascii?Q?Lq6UvbFoAPKM71MitzBC24jCP0KxJGMO9O4goTrKW6JbGDTZLSMbLI4no8ZF?=
 =?us-ascii?Q?2hI5nHq5EbyM4RjWaltJn+r7MJ2TZShCUjbgWcuoh5tdpEQLd0hP4BnFvXR4?=
 =?us-ascii?Q?5W6ZHMdfEcrMnxfVtivtpgL+kVlJAqbmOYTB3NNyEEjqYXZoYIv5paA3rrAI?=
 =?us-ascii?Q?7VOjPI99VO9XjYW8n5JzTwK8k+0grgWD4db9egw7O4gvwgopLnheyRawikJ+?=
 =?us-ascii?Q?KAuoJ1duCK9NxHZ3OKNNLuFea2JNNcboA5W2Qmec3f24Ej6RH5Mz4L+J8kvv?=
 =?us-ascii?Q?UdOg65xA0+/roLATz8uKUkBdikikNIIBcutHMWuOzsph7iaf9i90kQRPD3er?=
 =?us-ascii?Q?P3lNJf5gaAmOOfY4Hp8kgpXLz6z86mOIs60YsJdpY6YTg9xoKWuVGNOcEjeK?=
 =?us-ascii?Q?sr56VMkc2WGw3Z8AYEvazpVSCaDXuNaJDuDm4WTA8ZrwCS54X9BOKxMNirmO?=
 =?us-ascii?Q?A6VCtkfXBgzV6sqTS96sqM5/GrDoZDeGUIm78RFiMCqqmU+2M8aBiJo2nXJV?=
 =?us-ascii?Q?cHmOgnqHB1TD530/C62nw1mQuZkozGXpeYzhha6mAamwIR1vNaOgxa8fzDhs?=
 =?us-ascii?Q?4kqIdGxUKUZWqfnpGjIAxrGV1gEJNyDGWd+IfzDFgCXdjd6cGjcn42jHfGGx?=
 =?us-ascii?Q?aeEe4lqDvfD7y33RwWbvZLrVMtoQaneeHjPsFFxbd7iq6oJBjjhQAoA2AdL4?=
 =?us-ascii?Q?b6aiuhTgMKMkIblmQRP9GqGAuAVabsGCQMyboubpX7FJ52tNCYcj+Lbz48F0?=
 =?us-ascii?Q?pzZnLe1rC98Qf4aTtIhBQFuzVlOfQTxdWVlMeMDJeUrD58HPZGx0ArotjFSh?=
 =?us-ascii?Q?yhKM3/BslMNoNOlNOqb3jpY8Nz7oOAP7zZDm/1I48rP/Qyou3fJ0QPsK4bHN?=
 =?us-ascii?Q?FD3T5Xh/b6FPT5nsfyFZ3gPM52kvEKKWqhCjo3bI9qOt4iNqhY93O5Eqhe90?=
 =?us-ascii?Q?cIqpF5VA6WWzz21/xZjX46nSSNobLsZWmIZ+U+sX3MxrqosoT5trlSQVzzPN?=
 =?us-ascii?Q?ZTxZXl9ZnHQDMcwb3r7kMSO5Qdu75lJmVsAEquEAWJatl0OO0j30D/+9crfI?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe3bf46-6863-4062-5c9f-08da970233fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:08:14.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wda5cdiWJMyDROCK4YdBsjvFh8JItaY7dkzCZBRD0gFEc+ESWjy+r+cdweTLFCudMRcLOYQDKBnrqUzcHdQ0cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
v1->v2: none

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

