Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5CE611008
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJ1LvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJ1LvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:51:10 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140055.outbound.protection.outlook.com [40.107.14.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569D767178
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:51:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca6Nu2mohA48SGjhmPbD5uslbI3kw8UCc4OSfa7qcoG6QewZ//g+/mUc3Kw98fJfuCgd5nYVfwrLlRzL3ReSwW6p7a+h8nMuuxh/l0/VWvh0Zje6pRnYdg+necF0egxmDvagxuYu4iFlZYER3X9wWVz3jM0IbcB/HdeicE/8/PjSu8m7oZHBK1/bbTklovIjIB+4aQlJs2fqQcnj8bkKY4WzLyBJPkpl2dqoa7NVV99riho5gjQvBuNIMtaEvl9EuP8gcOnecYlq9I5zMgqLQNjtWtmmvnp7yoiOAZ9lrdBYKSy3MF92vExna9gcJWJ3pEnzRwrfxvoDzYvfBqxH/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEO2GuKJgllgDg+p62h+Icttrhh2suab7LnvjxwDyto=;
 b=D8rmf4pVdAFzdQzlF0O3r/E6YgGb6Exio7noSsl8uOv3McZzZqljszqiG5jKI+GFpe3pVTBS+YxJ5U+ENJ9Z5kPgSaNWXQz/ditURhVUQptn0JyqWDz71LO3NLNzfnqEv6BybOug7ynHcmM2tpEApBNShMOqhIAXwtEebGVackm4NcMogac2TvdW+ED5HbeTuzbpspSu6p5cyAzqjchkTx4bwW1kD2zgadwwhChE/vLYgldMB8SYPgOUZXkaREtxQjrNuVaOWULQEwv2ZcI2reH6I49HFSBfZntgK0ZAnNckziPyEPbAxQIKEyBgUjE5342LHfR4kD0g81e2aaKB1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEO2GuKJgllgDg+p62h+Icttrhh2suab7LnvjxwDyto=;
 b=dci3rS0UOjofJM1T2MfGT8RhAoRW2cZidl6TNz/CP1nUOYsPvVQpkJzi0iAQlv/pW6tuXfeDWUw8qN2h/yLgwWVJcr0D6pMwW+IgoZmrAROcFcfQxH8TC0VcUjK1IMIrVuabEROvYdZPXRjoMeEYUoRG07fIS7ChkVpSxT7FlgU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8381.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 11:51:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 11:51:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 iproute2-next] taprio: support dumping and setting per-tc max SDU
Date:   Fri, 28 Oct 2022 14:50:53 +0300
Message-Id: <20221028115053.3831884-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0125.eurprd05.prod.outlook.com
 (2603:10a6:207:2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8381:EE_
X-MS-Office365-Filtering-Correlation-Id: 4111a010-0e76-4a5d-a794-08dab8dab184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNYY9Tj/JzJ7T2h0y/M0kJSaWlwMCJeuliiHatK0OCAzSzqjQeRBxRJEjZPt+JzzTX1Vuw738M3aGJS3MHEDY2h93p10wzOefzFDGeNkoi/ZMDX5mtH5P0USpEdSO4klsnah4OUIDTo/7tqcawAZHw1DAPMGG2fVvFkYaZZaVrwqI0l/GajQbIEEXyMGB9EZ8SGAO8B1fDNSbi9ccbsueT/xjTsJZ6P9iVrDccWbraG0IJ+7KYEwzsBf2EKsfvIB8RruxzLtcEtAJSwu1pnCiPPtuMUN6PDUO1jKZW/BMNziXFQB5AnCjfwH/ErQr5OysNL0OXn3yyYebrz0A3WzBpt/v9vstrE+Z1fwx5N2YDzm+A4Xo1W3JR1K29t/jKKE6o1n+1KsLbqyC36nETX1MMtfAkTl8ECJdWcGQ0Ue2+D42AQnW//M5aVEMDwx9QuQC6mJgZ6MZ4LbHug0q+37fh1uD1JSUm2K2c/YWftrbcj1ysmt7v4BFECmW0Gi4IPgpQuWqf0gbIOQIvJiCxWhN5c5mjkvDIJccnvWrRpKbJR38PL8jISPr5cH5S2r2egW/QT16zlBbnwXJFoumRbN/5lqBTF32jmi6P0Zqdpjk1j3Fo25WQrNF45t+VZYBOKPozTQH+QYCD/8m6jwrkAHdcCiwcXXh2LlY7jCO+WqyDCppPynr9YAId8CJIdYo7RMy4IrEwccSm87hRyZQpwQsdu0bWnj5PW798VClQ0ooNoL+2CXGF255FCSC8UczbaFZdKDmkz8b8wqx+L/J6au9hszBY5hYdUmhpTJgDVWsvIDmjqBNQ1LKgucIEZBIuQdTjWe5SU56pVc7PefHOlCSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199015)(2616005)(478600001)(6666004)(6506007)(26005)(6512007)(52116002)(1076003)(186003)(83380400001)(2906002)(44832011)(316002)(6916009)(54906003)(966005)(6486002)(8936002)(5660300002)(66476007)(66556008)(4326008)(8676002)(41300700001)(66946007)(86362001)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ty5o80GQffP3xaY45gnI3xZvR/oiKis1m4U58bTfw4v/oQ8jRgVvmxgAVCGF?=
 =?us-ascii?Q?W+MSst0urqGVBPuxD/OixFZx/XBOQxvddaTqThEXeyFCN/sO14CGfiZju6Ve?=
 =?us-ascii?Q?bG76A35/HIYahu95TYzsYgSnT5dLtEhShOdlKyIEdqQF7yg0Zh6KzfKeAXNp?=
 =?us-ascii?Q?Wpa1sXjarRJ/qG7NJAcKHndkjFSf7mrmjRuZ3MNdwM52KERLlKZHSuT2NTud?=
 =?us-ascii?Q?yOB8ps3YPKBW70cfm4KLGw4RODd3V/orDNqodZMUvByaOcIO1gelgR2FbJ5J?=
 =?us-ascii?Q?LjgvCA/mgEM6MlOcUbsxbpaqlJCcS0UzOXbCYBJ0TwuK1wOOqtyRpLV4u+kR?=
 =?us-ascii?Q?Mj3XsrLTkxj6tdcKQKJ6m7SSHuqOvKkv/dU/3gSe8QRLCfCSM61Br5PFYYVu?=
 =?us-ascii?Q?IJKKi6aOYHNcZeDRU6V1zcyOU9yVWV/0WyRiPNfG0uXqR8i8AU7jwFHZX1Jc?=
 =?us-ascii?Q?Io4MTrxukJml7gix83hOhbm9lewTYZxcWHutt3/lGrbWu7nhkwYyHOMpn9vI?=
 =?us-ascii?Q?8Ym7/EGoSJp0fDhG9nwAAnaACFhds2uz4VPRAiiazI610UEY0gS+spIxAsAn?=
 =?us-ascii?Q?Isdm4NhReudDzGWUtO8fuNUOs25A8DvQuS7s5kpxCsv+av2erKVsnBOmRwX6?=
 =?us-ascii?Q?hRN/rzB/SIIzVCJf6S7tOqqDhCAJKJd2QUg2ITQV4tzNYB+Har0CRSJlSEPR?=
 =?us-ascii?Q?K4dmOxjjQtGj73nayh2lNo29jaSwvak/CZ17H5aFZ//xRZGP/slNGGIh4E/X?=
 =?us-ascii?Q?DkjczIyExQZIS6joIKoGJW+VjTlpSo4XEQpATylL9z6MKEQDR6+UtNxBFLp/?=
 =?us-ascii?Q?PUhmjWufFZ62i00zbJJ0al58NOs+tLabf8d5130yknVW5qnwolQmbeM+fBZp?=
 =?us-ascii?Q?ciDNZ0HcSU4wbe5gZhFYXrLL3jG3DuyOAKd/t4oLLhwyIWF/N8GPccmtMju9?=
 =?us-ascii?Q?foEv6toFWCMhvr/Q5Rgk85i90htk4R+pc5635Hsoh+jgGfHCBF0DTnmw9QG3?=
 =?us-ascii?Q?c4+jOH3fdMyQ8CFYTVuW69n861o8aIB5q/wZRIwoVxcrJDxDIiCnkh2gbGla?=
 =?us-ascii?Q?jXuhXz8co98dKFHdVm64RaUIGuyWSJYdGTwlRvgJNIYS3BowPd9uK4bG42YW?=
 =?us-ascii?Q?MgszxTdkJ1xURKBBdYrQuWQhcg7n0LZTSmiut8srsJGLNfpWkkaLpx/Q5oQ4?=
 =?us-ascii?Q?uXagX7wBDIh1CA2xiqvb5LK85sZ2p/MVnjb7evTbe/tjo/ZemQx8scbYBMIt?=
 =?us-ascii?Q?H0QVBuqmAOqH/ci6cZa+CFx7G0dN0OKuGOGF6OYaNR5FzMStVKa8sLKa5PtI?=
 =?us-ascii?Q?1OWyNFaMkYvOacTmlmTj7pOujLS0A6Vcs0nM6GPBKC86nm4j1YLvL/JS9BQl?=
 =?us-ascii?Q?LVUWYpTsoEpYxfod/InRz8k5PPrWxI7kBAIbp0pyQKtyICz5JrnwKzecf4pI?=
 =?us-ascii?Q?fz2ryC1Q3gYPw1n7CMZfhAJ6vklogOO7tu76BT5NVe3J3VoYhGdMQNsP1Omn?=
 =?us-ascii?Q?iMrKmLqZKrxT1zHywX3Bzs34fu7Mfy5ySm57PYma6DWRCulf/Vi9C077QpvS?=
 =?us-ascii?Q?9iuIppweoxJq58SI8BbO4h0TRvt0L33Givyi9iWeXxRF2vVLuau8OFcdgyTt?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4111a010-0e76-4a5d-a794-08dab8dab184
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 11:51:05.0269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eP2Cm8jf03qyLjf7uoJzs4m5M51QQ1QMH6MRzcLK7hyQMK9y4UZom9RigX3jQgF0Ohgkl7QPknxHAv9FsBLQFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8381
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 802.1Q queueMaxSDU table is technically implemented in Linux as
the TCA_TAPRIO_TC_ENTRY_MAX_SDU attribute of the TCA_TAPRIO_ATTR_TC_ENTRY
nest. Multiple TCA_TAPRIO_ATTR_TC_ENTRY nests may appear in the netlink
message, one per traffic class. Other configuration items that are per
traffic class are also supposed to go there.

This is done for future extensibility of the netlink interface (I have
the feeling that the struct tc_mqprio_qopt passed through
TCA_TAPRIO_ATTR_PRIOMAP is not exactly extensible, which kind of defeats
the purpose of using netlink). But otherwise, the max-sdu is parsed from
the user, and printed, just like any other fixed-size 16 element array.

I've modified the example for a fully offloaded configuration (flags 2)
to also show a max-sdu use case. The gate intervals were 0x80 (for TC 7),
0xa0 (for TCs 7 and 5) and 0xdf (for TCs 7, 6, 4, 3, 2, 1, 0).
I modified the last gate to exclude TC 7 (df -> 5f), so that TC 7 now
only interferes with TC 5.

Output after running the full offload command from the man page example
(the new attribute is "max-sdu"):

$ tc qdisc show dev swp0 root
qdisc taprio 8002: root tc 8 map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0
queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 1 offset 4 count 1 offset 5 count 1 offset 6 count 1 offset 7 count 1
 flags 0x2      base-time 200 cycle-time 100000 cycle-time-extension 0
        index 0 cmd S gatemask 0x80 interval 20000
        index 1 cmd S gatemask 0xa0 interval 20000
        index 2 cmd S gatemask 0x5f interval 60000
max-sdu 0 0 0 0 0 200 0 0 0 0 0 0 0 0 0 0

$ tc -j -p qdisc show dev eno0 root
[ {
        "kind": "taprio",
        "handle": "8002:",
        "root": true,
        "options": {
            "tc": 8,
            "map": [ 0,1,2,3,4,5,6,7,0,0,0,0,0,0,0,0 ],
            "queues": [ {
                    "offset": 0,
                    "count": 1
                },{
                    "offset": 1,
                    "count": 1
                },{
                    "offset": 2,
                    "count": 1
                },{
                    "offset": 3,
                    "count": 1
                },{
                    "offset": 4,
                    "count": 1
                },{
                    "offset": 5,
                    "count": 1
                },{
                    "offset": 6,
                    "count": 1
                },{
                    "offset": 7,
                    "count": 1
                } ],
            "flags": "0x2",
            "base_time": 200,
            "cycle_time": 100000,
            "cycle_time_extension": 0,
            "schedule": [ {
                    "index": 0,
                    "cmd": "S",
                    "gatemask": "0x80",
                    "interval": 20000
                },{
                    "index": 1,
                    "cmd": "S",
                    "gatemask": "0xa0",
                    "interval": 20000
                },{
                    "index": 2,
                    "cmd": "S",
                    "gatemask": "0x5f",
                    "interval": 60000
                } ],
            "max-sdu": [ 0,0,0,0,0,200,0,0,0,0,0,0,0,0,0,0 ]
        }
    } ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- pass to the kernel only as many TCA_TAPRIO_ATTR_TC_ENTRY nests as
  max-sdu array elements from the command line arguments
- only dump up to min(TC_QOPT_MAX_QUEUE=currently 16, # of max-sdu
  elements reported by kernel) elements, instead of always 16.
  No practical difference, as current kernels always report 16 max-sdu
  entries, and if that number ever increases in the future, today's
  iproute2 will still only print the first 16 of those, and warn about
  the rest. The limiting factor is the array representation as opposed
  to key/value, which OTOH I'd like to keep.
- stop initializing max_sdu array in dump_tc_entries() and in
  taprio_parse_opt()

Honestly I hope I covered everything, it's been a while since v2, any
omission is not deliberate...

v1->v2:
- add info to man page
- expand documentation

v1 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20220914200706.1961613-1-vladimir.oltean@nxp.com/
v2 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20221004120028.679586-2-vladimir.oltean@nxp.com/

 man/man8/tc-taprio.8 | 18 ++++++++-
 tc/q_taprio.c        | 95 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index d13c86f779b7..e1f32e73bab0 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -150,6 +150,15 @@ value should always be greater than the delta specified in the
 .BR etf(8)
 qdisc.
 
+.TP
+max-sdu
+.br
+Specifies an array containing at most 16 elements, one per traffic class, which
+corresponds to the queueMaxSDU table from IEEE 802.1Q-2018. Each array element
+represents the maximum L2 payload size that can egress that traffic class.
+Elements that are not filled in default to 0. The value 0 means that the
+traffic class can send packets up to the port's maximum MTU in size.
+
 .SH EXAMPLES
 
 The following example shows how an traffic schedule with three traffic
@@ -205,17 +214,22 @@ is implicitly calculated as the sum of all
 durations (i.e. 20 us + 20 us + 60 us = 100 us). Although the base-time is in
 the past, the hardware will start executing the schedule at a PTP time equal to
 the smallest integer multiple of 100 us, plus 200 ns, that is larger than the
-NIC's current PTP time.
+NIC's current PTP time. In addition, the MTU for traffic class 5 is limited to
+200 octets, so that the interference this creates upon traffic class 7 during
+the time window when their gates are both open is bounded. The interference is
+determined by the transmit time of the max SDU, plus the L2 header length, plus
+the L1 overhead.
 
 .EX
 # tc qdisc add dev eth0 parent root taprio \\
               num_tc 8 \\
               map 0 1 2 3 4 5 6 7 \\
               queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \\
+              max-sdu 0 0 0 0 0 200 0 0 \\
               base-time 200 \\
               sched-entry S 80 20000 \\
               sched-entry S a0 20000 \\
-              sched-entry S df 60000 \\
+              sched-entry S 5f 60000 \\
               flags 0x2
 .EE
 
diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index e3af3f3fa047..ded385caf964 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -151,13 +151,33 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
 	return e;
 }
 
+static void add_tc_entries(struct nlmsghdr *n, __u32 max_sdu[TC_QOPT_MAX_QUEUE],
+			   int num_max_sdu_entries)
+{
+	struct rtattr *l;
+	__u32 tc;
+
+	for (tc = 0; tc <= num_max_sdu_entries; tc++) {
+		l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED);
+
+		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_INDEX, &tc, sizeof(tc));
+		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
+			  &max_sdu[tc], sizeof(max_sdu[tc]));
+
+		addattr_nest_end(n, l);
+	}
+}
+
 static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
+	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = { };
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
 	__s64 cycle_time_extension = 0;
 	struct list_head sched_entries;
+	bool have_tc_entries = false;
+	int num_max_sdu_entries = 0;
 	struct rtattr *tail, *l;
 	__u32 taprio_flags = 0;
 	__u32 txtime_delay = 0;
@@ -211,6 +231,17 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				free(tmp);
 				idx++;
 			}
+		} else if (strcmp(*argv, "max-sdu") == 0) {
+			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
+				NEXT_ARG();
+				if (get_u32(&max_sdu[idx], *argv, 10)) {
+					PREV_ARG();
+					break;
+				}
+				num_max_sdu_entries++;
+				idx++;
+			}
+			have_tc_entries = true;
 		} else if (strcmp(*argv, "sched-entry") == 0) {
 			uint32_t mask, interval;
 			struct sched_entry *e;
@@ -341,6 +372,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
 			  &cycle_time_extension, sizeof(cycle_time_extension));
 
+	if (have_tc_entries)
+		add_tc_entries(n, max_sdu, num_max_sdu_entries);
+
 	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
 
 	err = add_sched_list(&sched_entries, n);
@@ -430,6 +464,65 @@ static int print_schedule(FILE *f, struct rtattr **tb)
 	return 0;
 }
 
+static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
+			  struct rtattr *item, bool *have_tc_entries,
+			  int *max_tc_index)
+{
+	struct rtattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1];
+	__u32 tc, val = 0;
+
+	parse_rtattr_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, item);
+
+	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
+		fprintf(stderr, "Missing tc entry index\n");
+		return;
+	}
+
+	tc = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
+	/* Prevent array out of bounds access */
+	if (tc >= TC_QOPT_MAX_QUEUE) {
+		fprintf(stderr, "Unexpected tc entry index %d\n", tc);
+		return;
+	}
+
+	if (*max_tc_index < tc)
+		*max_tc_index = tc;
+
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+		val = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+
+	max_sdu[tc] = val;
+
+	*have_tc_entries = true;
+}
+
+static void dump_tc_entries(FILE *f, struct rtattr *opt)
+{
+	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = {};
+	int tc, rem, max_tc_index = 0;
+	bool have_tc_entries = false;
+	struct rtattr *i;
+
+	rem = RTA_PAYLOAD(opt);
+
+	for (i = RTA_DATA(opt); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		if (i->rta_type != (TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED))
+			continue;
+
+		dump_tc_entry(max_sdu, i, &have_tc_entries, &max_tc_index);
+	}
+
+	if (!have_tc_entries)
+		return;
+
+	open_json_array(PRINT_ANY, "max-sdu");
+	for (tc = 0; tc <= max_tc_index; tc++)
+		print_uint(PRINT_ANY, NULL, " %u", max_sdu[tc]);
+	close_json_array(PRINT_ANY, "");
+
+	print_nl();
+}
+
 static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
@@ -503,6 +596,8 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		close_json_object();
 	}
 
+	dump_tc_entries(f, opt);
+
 	return 0;
 }
 
-- 
2.34.1

