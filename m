Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEF05F4296
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 14:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJDMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 08:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiJDMA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 08:00:57 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7DB55092
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 05:00:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MB5CJ6kAsFlMGGOYrY5aAq7CFMj/grPHlbQHVwr7c0vNa7h3/DFRMsb08BGfnkfQ2OkE/g2EOzFGkj4jteUqJRVhqcmAMQtyUtMHktGPMSOFoBgI8KzXy+mlYdZsIwEe49yHip7DzTD6PSaHVIgKzv7UlTHhHxC2zPZhPPlo+6sjhUBq3S8zx5Nfcte1Xb0B7dUfJQ8SV+G0f3iGmIFAaMZ5gSkY0fHb3i+9D2jSTNLt9KJ9Ec8CseKcSGNfVR62Ux/vIJKORqj6fGKrtk50woLtkgsU6+I0I1wH0sgk8cEXqtjdxykjqMFkl7uofpeddTOcZJ4QMYoQTd+wgyxSag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhFMwXiYL0+XoPg6sAcQLTg9uy3JnPJrq8kImh4nZfI=;
 b=ffpqaIdC126/qQY/Oc5JyMfcmWgfuK//kwRCRWufAG2O1+z8BnZMDn6rOpkSP45UdZOVrQJPeeg3rvxFysgzuwQTBP+jYhi5aPRPfYPh9h/SXN8ZxCss9xleQ9LCKf10Zzju28vLP75+yNfvnkHMxE/Qj4icA6HV82NY7+iMyYt4RH7Vzi3P49GQQZ5vtemygAqqGmfEGLgnDyQaJXeSQUPs1rlYiFjSxV19ZLoH/7pF6MW8d4xO17sZMkQfXu6WSu2x85lzleqTSNa8BzklqVxH22kZsgCXz7T43Y+HIDvUP3AN4172scIXfWHi4vnZrzZmh9o757TaizI+vyOsXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhFMwXiYL0+XoPg6sAcQLTg9uy3JnPJrq8kImh4nZfI=;
 b=TqxEWKURyiSiXmYwdLijAYvi7eqXJoOfJFXnGzdajx6dO8ry5AnNHkr9dlm60vufCLmeHFE+Zyggn3FnV/ZGirHQbMIj5w37AHHzIrnJx8AGC8zhdl4xvKqQ2rdORLwlv4yfFm8r3RzG9eV3XEdTvoD6IigDX2QirZGbXcob/5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8454.eurprd04.prod.outlook.com (2603:10a6:20b:412::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 12:00:46 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::fd20:a2fe:1a4d:344f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::fd20:a2fe:1a4d:344f%4]) with mapi id 15.20.5676.028; Tue, 4 Oct 2022
 12:00:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v2 iproute2-next 2/2] taprio: support dumping and setting per-tc max SDU
Date:   Tue,  4 Oct 2022 15:00:28 +0300
Message-Id: <20221004120028.679586-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221004120028.679586-1-vladimir.oltean@nxp.com>
References: <20221004120028.679586-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0021.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AM9PR04MB8454:EE_
X-MS-Office365-Filtering-Correlation-Id: e5df2a6c-dd8b-49f0-4617-08daa6001215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YLDboo6jDrEtbRVAou69kkYnFqgPVipv77k7/1dlzNfwhPgfQUY/CY5MAfl2y5KBGHGUVRolqCJl5DbgGXPaB+zPGP+zQ8fxCKbRjZ2PqGfzAOX5wQbz8UOJxFHSTBKCNGzYhAbo5CFk95HtnBz2WgFt6V9zgLsPbyiEX5joGkZ82cReHub3YA5dAfDvmvx6s9MCo9yLEXFLJxxDXewABnqI0SFkY3SmNnolmpQmc1S8/N/nZkErFOBnXtxUKiX40MJS7oPUbtokKNXo8eMF2CsLA+LoMWcuTMJYAuzM/y0N1JQTpVhPkp+Wx2HxRZngiROi/cJC4Iy20n3ZOJ4bTUFFOmh3MSyQ2VjD/P1PAmJ9LNC8l6YsueRrmbAD7lf0R43DjEWQNWqe2vxem4x+9ShJe3yb36WN8UF1dv/4hGhbzfb0XAsZenHE3C2RvMN23wdqDbCsn9YJW+ihTBLt3U7jkvNSMjqnqFOK7bfRNTKY+8fmwy/2vXHyqV7I/ECE1q55GBUgmgzHGU1emyhrv8mrKUp5AaFoURp5jlPMQebN88jfidSiJUwGSm/JFOSJ+fkBWA/oi1Sl+eaZvY0WmqKzcaVl/p+wrhl/Xt3BcB8jBmFdK3z0pnQH9bOgJVa6hWSWnIXRLnF4MT530JbUqlrKxG1aN92eoEEBlUhFWYxYlUp3B1rFd/ODhmrnisl16u5dDIp2fOGXwc6+ggBtLsUQbyITguwslxrY3VJJN/4HL2G+nWOAbru+Af/uNZD7KVBVoqTGdw+xB8iCpn54QZh0W57DXQyQ+yBTxAwEWQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199015)(41300700001)(6666004)(4326008)(66556008)(6506007)(38100700002)(66946007)(38350700002)(36756003)(2616005)(1076003)(8936002)(2906002)(66476007)(86362001)(83380400001)(6512007)(186003)(44832011)(6486002)(26005)(52116002)(5660300002)(478600001)(8676002)(966005)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xUblY/4hxcC054ZAw1/jyiX70nIQnLuxN+qfruLweZFzTNkeWPwNr6MNgs3Y?=
 =?us-ascii?Q?YvfJKpjuCpOe6F5pHyABNe766RdH3v5nnZHoItBP3TV7AyNhqQwoj29mQoUV?=
 =?us-ascii?Q?LmlqlGc2NsefavuOJ5K9EJxbTMEjFr0SA0g0GYfpcUaLZ/apNJgxpA9yCYCx?=
 =?us-ascii?Q?NLZgI0zIi0jn3qTjbk0/04j97EyyWvLv27Uwe86bwDtvJC/nPs44ntC7YtXf?=
 =?us-ascii?Q?cgndgS22KRHu+RfFTCqlZ3zk4EAOtcUtDkLPINh4GlVWxdolEkJJ4hqNc8wX?=
 =?us-ascii?Q?H5hrxuir412ooV0C0Y+qdRLEl6YaoSX6rOpYGNso/wjDOACcw/X/sSxJE9cu?=
 =?us-ascii?Q?WEdiEI+2+6/p7IOptmr5tBK5aYzpEYLj3qj7TCfU4a8AlpPKu+2Ud9+9PDIV?=
 =?us-ascii?Q?ytEKcwQitDVUWGqFsg6DMd/6IXhhblGS9BvE0F32IDxuDjMBLnZoMiVeVGg9?=
 =?us-ascii?Q?H8ecVuCVg3y82jHb9QEQaxg8LziZ507MI4Airv/G1ijnw1lisOyTd4uJzxgk?=
 =?us-ascii?Q?nClq9f9o5hQjZ062faIp2ylZr0zRBJb57F2hVo8VBi0CQ1hLk3C2wqdD0/DT?=
 =?us-ascii?Q?sDXVboBFi2lyXgC6uM00Nwo/8v7XCP4nhy2JSRR+uoywVd9XAIMK5V4PubFN?=
 =?us-ascii?Q?6JGQdWHNz83NT4mdTtFEGJQcVdgTTNDHpGC5j4By5erIw3yuEwN+Lh7o3Rv3?=
 =?us-ascii?Q?mSjdYW0UAMUp2466BhJfWck6yea443SmphrYLE5U6gGCCnOgWMfM8196O0o/?=
 =?us-ascii?Q?e8+Y5kYPvkVxSzrchSlMTKt6LuEn7yZPUwPJ1tkt1m+hVbeB08Tc6zhkiaBp?=
 =?us-ascii?Q?DaXh3SZpi96fhiCOosL9eX2HfWOXuOWeIk7GXlqIcS0vXd9ZeZEcpLtMUyoY?=
 =?us-ascii?Q?RPG/dAaG/U/nkYAdUpf4hwyaDMj5c5p4pB1ArUWgY/Lyo3tjUGY3AGIgfEAx?=
 =?us-ascii?Q?mhJwjAaMbZ/5Za2wgUGinTfHt4qj0Hs2oX3Gj4ldubDdQHjfjGu9Ri22vs2K?=
 =?us-ascii?Q?LN0piOvmBPiiv0Yw14QHM1DXr3eRbzfKPUL2l5vMsZ32w8mxdmyWsyAD76yh?=
 =?us-ascii?Q?NH4mfEiZtimd4ACny0uwTmGGcYGkjentvziPw6VZnkHN50DGCVIfW65ixSGg?=
 =?us-ascii?Q?V4jWK8dk+rbRaAaJ9QU5NNz+HMYPXLoUIcVwcT1qN33wIZj6zt6oVhmfNDgC?=
 =?us-ascii?Q?Jz5wqD/4CmAbDBdchgNc2ojHW0RuIYYOBHZBPDSv+6CpodjEj7OkB+0J47Gy?=
 =?us-ascii?Q?LWmYDHPd/CbNTuC1QmWiCvuvLFBMa+ytfu+BQjtQuL0kcJ6SZWusZ//iIn9C?=
 =?us-ascii?Q?2jM3m4wOIGQzX3iReOsIoobME+iCj8xeVz/SgYV0mzDM9DQDCWpdHWly6inz?=
 =?us-ascii?Q?4bAtojMshscZEeof+HHX1v1rlQ/GTv45AW8CBOFGDIVoRvpHZJ8QpdLC8h4x?=
 =?us-ascii?Q?YzzlE6cgSWCGzOJiZAigxpc6HA5w3fDb77M1SmtvxpoHp4fL3pf8YtrJJY6V?=
 =?us-ascii?Q?xARa0lETATpckh9Yh9T7PRZZRLaOFCRguDph5/GkMzKrrldBsMWkr+unJZvW?=
 =?us-ascii?Q?NbxZGQn0LAEQVw+i9Ufx8YrN2MkJpsZvDGiB403wBJ1BTbTtAb3VyqY9OWXB?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5df2a6c-dd8b-49f0-4617-08daa6001215
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 12:00:46.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXkOcnzza/4IDRKEzmu+37FWHhhJMomT2ueodes5JIvk8LRKQ8hQp+QzgIFiOmXtkci0Pd1gC+1BXtatk4JEUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8454
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
v1->v2:
- add info to man page
- expand documentation

v1 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20220914200706.1961613-1-vladimir.oltean@nxp.com/

 man/man8/tc-taprio.8 | 18 ++++++++-
 tc/q_taprio.c        | 89 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 2 deletions(-)

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
index e3af3f3fa047..45f82be1f50a 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -151,13 +151,32 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
 	return e;
 }
 
+static void add_tc_entries(struct nlmsghdr *n,
+			   __u32 max_sdu[TC_QOPT_MAX_QUEUE])
+{
+	struct rtattr *l;
+	__u32 tc;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
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
 	struct rtattr *tail, *l;
 	__u32 taprio_flags = 0;
 	__u32 txtime_delay = 0;
@@ -211,6 +230,18 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
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
+				idx++;
+			}
+			for ( ; idx < TC_QOPT_MAX_QUEUE; idx++)
+				max_sdu[idx] = 0;
+			have_tc_entries = true;
 		} else if (strcmp(*argv, "sched-entry") == 0) {
 			uint32_t mask, interval;
 			struct sched_entry *e;
@@ -341,6 +372,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
 			  &cycle_time_extension, sizeof(cycle_time_extension));
 
+	if (have_tc_entries)
+		add_tc_entries(n, max_sdu);
+
 	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
 
 	err = add_sched_list(&sched_entries, n);
@@ -430,6 +464,59 @@ static int print_schedule(FILE *f, struct rtattr **tb)
 	return 0;
 }
 
+static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
+			  struct rtattr *item, bool *have_tc_entries)
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
+	bool have_tc_entries = false;
+	struct rtattr *i;
+	int tc, rem;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		max_sdu[tc] = 0;
+
+	rem = RTA_PAYLOAD(opt);
+
+	for (i = RTA_DATA(opt); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		if (i->rta_type != (TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED))
+			continue;
+
+		dump_tc_entry(max_sdu, i, &have_tc_entries);
+	}
+
+	if (!have_tc_entries)
+		return;
+
+	open_json_array(PRINT_ANY, "max-sdu");
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		print_uint(PRINT_ANY, NULL, " %u", max_sdu[tc]);
+	close_json_array(PRINT_ANY, "");
+
+	print_nl();
+}
+
 static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
@@ -503,6 +590,8 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		close_json_object();
 	}
 
+	dump_tc_entries(f, opt);
+
 	return 0;
 }
 
-- 
2.34.1

