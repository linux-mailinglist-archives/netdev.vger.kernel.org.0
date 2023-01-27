Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7010167DA9D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjA0ATG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjA0ASo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:18:44 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2089.outbound.protection.outlook.com [40.107.21.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44E15EFB8
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:18:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeAB3rewskwWat7LX6vxUK1kLBg6lonplkK4kPFFFxyWjiIi67BFZzHijxj/qCZqYi/4t7rDEPf5EgDsNJWHm+izsR/2mP3NNCyColwPy7p4E1/liB3C0Dk28kD/D3Ne3FLarfzVA0Lt5jLxh3YH5c3oxITciv40xWSf9bEjzzTdz1CkVz4zaeMkBEae5dxdoCKn4ssk8aXgdfPUN5BjGw/He6i8DmnbrxZUsdZiXk5ps+c8YaE2cl/a53BfEzbNpOyvAUoG9cHgpBDRSmsDq6SD8aUj8egZjBpC9WeAkZd8QVT3TCHFrse7ifqa+9lloUBtRhoNFZSZB9m+UPtrzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XuYRVB2+UCt90eCqQPGy5Cf4IIfH5G27shNRf+h1Ow=;
 b=Ot/vRIjn8wpwXIhDOUfejpUZSgHEHVzka5JDQIEpy1uXymOC0qm0OB7h28y9VZT6EDmMui0TX52jyszWQUu0Cl/tW4eigdpnORztl5anobroo23Pdb3P3Y83rfIqnXg+jjU4ArDhworrjVVNKdrDmXTg/6855MNuFxEMV5EzlZ9ZXvdyuzYvghlacUz1iRDVDV5GelFumxP8YKh7Btlj1YWCi22vueTWwjuPpE5OT0ejls3TW9ErgqfgAhXhwMfHTii8DzBbHc8dZUiVTT3RyO6h7vcR0K8jkfQwMMebw4T6kqgGcPmdilJf/oTGDkI0xyXQlxI6oZAVJWBD4Ubpiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XuYRVB2+UCt90eCqQPGy5Cf4IIfH5G27shNRf+h1Ow=;
 b=IqbwbZdTYxs5GDsKxCRP0hmr0ioKjWq5TRTJ97iJ7aqQC07oGk6FMmu7fFUTUtBbUnzfrsC/ZJ7z/NRU+X/q+Gz7MKEyPzKj0wsll03mLOEjIGUDMknHYfoQxUd9njS2+8lDVazHGy5K5cdRmZlko0EClQ+t8WwPe/HzJe4NfCo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 14/15] net/sched: taprio: mask off bits in gate mask that exceed number of TCs
Date:   Fri, 27 Jan 2023 02:15:15 +0200
Message-Id: <20230127001516.592984-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 5192e75e-d0b9-490d-1682-08dafffbb1ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +I3BVJzjFAf4MWI3HFwCk6qaMr71kyRhUNYzYSebBLZV5UeG+SJxkNVZgZXLFC+xE64G3/8jQFvQ7wJJysCcGyt348TGwVaReAT6h1qSiqpI7wemDRG5fo72tn7guGmwuRjLKgH3KHq48sf2uucD7HadWw3tGSSobUAPnhUUFJFRTmGTrs0HqLDqUdcjdSJm1sOu40oLgKeLj780rEQD5FWg/SFDmCi5RIVHM6GSNcARchUkgX2s/Jk2wdYZu9pVzhzm3c/7i1Ms81+6hbD6XYGGHLBzCQY55qrPUhmbsoccDYNNtByUtvQ9sy1fV8Itk3YX1eopQaDSwydzdyk5m0dniiCrG1KbnxjYR9/F0FIdLMK3L8FLAw2LFI4mD6HZoeBELdl+FBgGWd0buMPf9TFIAIgluvo3j114TSAXvwQdXl05UzjRDvJbt7pZvKUhrWQupEDVhNl67AVh0jGqtbKROoiBpKhev2PUwVflJlk1DvcURScxZ1u614j2u03CNzuZiaEuJIpcnFFfiHaRQlux3kZXvoDENSdd0Za3A87KE4buDE8j7WPDThApxIyaF5rK5x6EGu66nnf+HZYQ5H+uC09CiENSi1nEz6GIwjBimyisRrEEPJI3jedkfD3mRBchLoLQheN1+kKvNqF58wSCa+K36MVi+C75zh5iOVtmVkCpp2uEoRmdGPjesjWx5XRd3OrcqhZONduLtsMT8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jFWnz7jdKzdX6b+c+/4VquYwJ4NAuNc7FECOfj0GL62/dxUJtbWmn0YKRLeN?=
 =?us-ascii?Q?UqYfCTSyrCzXvDxE0H3+4WNFf52uguJ5q+RtbYeseJD3lzkKNWiVnbr4XbiE?=
 =?us-ascii?Q?axhkBGgood7QnpC/sgFtHcabgnWY5bYLIKr7nLL6AQhe/8I1Y8loxNis/ydw?=
 =?us-ascii?Q?GV+NRlBS3Q3V7LZdoIkmCp49F5NSUQ1jmSHLDCKxbrR/SVHuKM9pW3MYfVrm?=
 =?us-ascii?Q?9dUtHnE6qYw/QYsAyy7TRrnsN27n8Z50txKYCvhn+Pd5TLTPVlDBJIa1+Ir5?=
 =?us-ascii?Q?PuEPPwnM7ylvgkiBQJITixwopu28IJeGe89x8puMtp2+s+2RUUzTSUi/DTJC?=
 =?us-ascii?Q?G9vs0c52GFE3bu7cvkOnMnbwXdb44H3/XM3u/eA1TMifriLPXubYbcQGUTAY?=
 =?us-ascii?Q?PHibGNq0HJL4DRHA9yR387w7TYbPekXxyq2tFjywoBJwY+TgQAPPgBfvTHS2?=
 =?us-ascii?Q?ZADP0TWmX+KCdNpHycfJySlhA30Mrd7JLl0fscV5yTFCm3zZM0qfOMgneOEM?=
 =?us-ascii?Q?JDPGBjxHyGCf2m/CdnLZ160nQR0OtwlK/F7NUwcLSPmgd3G8iAoMo1iC7MY9?=
 =?us-ascii?Q?4t2s2sCG0fkqT9vK+HZHxRfnBmRlrSeVj8PjKAIUiz9myzofdNjMM3A/60mJ?=
 =?us-ascii?Q?dVyJDwm6pMmXcKOoMcKt9Dihexam5Dbc95VYg8bPfQOz97GqWMX53C4lKZfF?=
 =?us-ascii?Q?9hl5BZxppRePOYMg5Q/DS4vUhlhF5XUGKgTPoS+tB9r96hy991qsIfzpqi5U?=
 =?us-ascii?Q?hVvWxKUDeaQwwl33JnSsQntpd3DClhDWxDILMVLMsbq7a5iwhGpTAfESIR9x?=
 =?us-ascii?Q?8i6oKdXUGceyA1ERoCH//3nZluKbEdDAJ3iQdgdt0oV/lnAlwDMtIs8IwZMB?=
 =?us-ascii?Q?nKLJ7JAluJeGbIMyqKfFAiyeOvDQy9kHWbT2IrKv1vtqZJEpPPejmARhTy8r?=
 =?us-ascii?Q?AKnaT/hQW6g8d15Dr2h3Zx6frXwaE4HyFsey3xgWakuFGoiYSoa5sPk4ib9U?=
 =?us-ascii?Q?z1vSWKGmUr+qmUDUsNCiPoZQwqoC/AO7U89/NVLQJC6PfzDc/sILJHNgoalv?=
 =?us-ascii?Q?F1iSmF/SmeWyKF3GmuNAbAjmidvORz2GrJ98HAuO1HWGdMKOP5ZQ1Wyx1ruh?=
 =?us-ascii?Q?pvUGs5aeu8c90e+nxq0HWIPZVjxR2IhR1ezc2yMjTKyTLQ9iLXQQ8Ezv1Xgf?=
 =?us-ascii?Q?k8lr2ZORe0YYXeCuNw7rcdjXix+vl6gnv4r58mvsvFzv37+UqZyJLogGu3Aa?=
 =?us-ascii?Q?k76WGT7WJN47t5l+w6vAJMzPXghwDYSjpGiinQCG4ahgjO+hWuAsNkCHcXHZ?=
 =?us-ascii?Q?Zd4+sn0n2gj5QWYPfmSAORW/Iw8AOK45RqcCdV+gofTEUreFZ/WvbPYPDvzS?=
 =?us-ascii?Q?XILj7wJbOnBmLBH9ZG9rhKv/pXT939jJFE1FtntMarFJenvFSC0anklpw6tQ?=
 =?us-ascii?Q?6bvknXcsfBZkcKhePm0oqZ4D1VyIY3t4NvRvuzpf8j8wwuCWY2csSiE0sS8m?=
 =?us-ascii?Q?uHWrVowEeY2ipy0XmsTVcvVvnML5ss0BxqBU25x14HwA8tdckqOtcVoosfh0?=
 =?us-ascii?Q?IvPSWKjo+SuION3egaUISVjhBD3Q/b2bj1lDBnke7Fs16M8Z4jMU44c//WNv?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5192e75e-d0b9-490d-1682-08dafffbb1ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:11.6536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3grMX7rYbvpXWCvcdC1dFSbbzIAd1dSW2U5p7OEDheNAWEpBtsl7DOMvkjjtnJjgMYx2SgAnZU+kquje0FvDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"man tc-taprio" says:

| each gate state allows outgoing traffic for a subset (potentially
| empty) of traffic classes.

So it makes sense to not allow gate actions to have bits set for traffic
classes that exceed the number of TCs of the device (according to the
mqprio configuration).

Validating precisely that would risk introducing breakage in commands
that worked (because taprio ignores the upper bits). OTOH, the user may
not immediately realize that taprio ignores the upper bits (may confuse
the gate mask to be per TXQ rather than per TC). So at least warn to
dmesg, mask off the excess bits and continue.

For this patch to work, we need to move the assignment of the mqprio
queue configuration to the netdev above the parse_taprio_schedule()
call, because we make use of netdev_get_num_tc().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v2->v3: warn and mask off instead of failing
v1->v2: none

 net/sched/sch_taprio.c | 46 +++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6533200c5962..0415f0dbfcc8 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -789,15 +789,29 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct netlink_ext_ack *extack)
 {
 	int min_duration = length_to_duration(q, ETH_ZLEN);
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
+	u32 max_gate_mask = 0;
 	u32 interval = 0;
 
+	if (num_tc)
+		max_gate_mask = GENMASK(num_tc - 1, 0);
+
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
 
-	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK])
+	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]) {
 		entry->gate_mask = nla_get_u32(
 			tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]);
+		if (entry->gate_mask & ~max_gate_mask) {
+			netdev_warn(dev,
+				    "Gate mask 0x%x contains bits for non-existent TCs (device has %d), truncating to 0x%x",
+				    entry->gate_mask, num_tc,
+				    entry->gate_mask & max_gate_mask);
+			entry->gate_mask &= max_gate_mask;
+		}
+	}
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL])
 		interval = nla_get_u32(
@@ -1605,6 +1619,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	if (mqprio) {
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
+		for (i = 0; i < mqprio->num_tc; i++)
+			netdev_set_tc_queue(dev, i,
+					    mqprio->count[i],
+					    mqprio->offset[i]);
+
+		/* Always use supplied priority mappings */
+		for (i = 0; i <= TC_BITMASK; i++)
+			netdev_set_prio_tc_map(dev, i,
+					       mqprio->prio_tc_map[i]);
+	}
+
 	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -1621,21 +1650,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	taprio_set_picos_per_byte(dev, q);
 
-	if (mqprio) {
-		err = netdev_set_num_tc(dev, mqprio->num_tc);
-		if (err)
-			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
-			netdev_set_tc_queue(dev, i,
-					    mqprio->count[i],
-					    mqprio->offset[i]);
-
-		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
-			netdev_set_prio_tc_map(dev, i,
-					       mqprio->prio_tc_map[i]);
-	}
-
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
-- 
2.34.1

