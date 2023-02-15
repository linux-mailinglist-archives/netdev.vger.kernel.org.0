Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D3469880E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBOWqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBOWqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:46:52 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DD123850;
        Wed, 15 Feb 2023 14:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmpVpZsk8L3hT/ieEaxXUbbcEmhjzmGtkkvo9lCBBeQz0g3cjFMIbcx5xMhHqjCxIXdjPNAojp2peBk0FVOGrhZ1TzlbvNGjHrdGIJez/86GgPp6Lz69jBVB3tlJdSA2Vv+PjA9nugbUgev7pp0ChPk2JtsAnEwcTNOtCEVvfJXLrRjEESg0qEJnoJjqP8ytrmIPwWOe/yuVzMMP7mbW5G6RnmHtU2BBZ41hL3ECTuCOdO5Pq8rZZYrhbTs8MzFHG5zpH2Dh4Q1IzArcCMo+DOE1t1URIhgYQXS29CAzDDgv/mdhOO9CjPyXZezus5Bl/xAUwWE+aZds+xLrWYaq8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcfqCb+n5sNTVWdr3UHmaLjGSkxj7vmXWvMcpPgUSrs=;
 b=DpIqziKH14d64d96MM1FWRLY/eJkCtgHcB92/ISJr96Ju2QoLCXxxOoKzwlxK9v0YHE5xhzRXeAcZabp876kG4OGHPH3gdND4apoAJrqckKT31IpVBt1hxTSJQ/GFar4eohNU2/Wqq7Ejw6CW7M//7k/CShZEoR0QB4/PhecxLFZ/CAfiW33zQDAebkjs0AIY13ggkHTaU3oOxb6/CHObRxs6g6C5V3KNWW02qHAJlXvNlUII7dKrCmM4RKshfA+rHAtmKnA+Ur6/MRX9J8eHB28v8VfKaDYniaQ7mjwl3/vp152QKf4H20l2F2o1GwUup15tLhrBvJWDYZ87t4U/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcfqCb+n5sNTVWdr3UHmaLjGSkxj7vmXWvMcpPgUSrs=;
 b=DmDvYyxNKG3dcyd9JOjJ2aVPVJgupDOc7mBnP9XzJ0nB8hhzyKzl2rp60cF2i0bBRb6xFruhBxZLv02y9W3pjJR8ugKgDuJUKVbskp1HDeZmfcSILgbpSl9LsWhSoyfFW9v452MLTrqZ4nbgD2KV4a5VNtOpPmG/TuG6iwo0wMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8748.eurprd04.prod.outlook.com (2603:10a6:20b:409::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 22:46:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 22:46:48 +0000
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
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net/sched: taprio: fix calculation of maximum gate durations
Date:   Thu, 16 Feb 2023 00:46:30 +0200
Message-Id: <20230215224632.2532685-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 429af7f4-87f4-4883-034f-08db0fa685c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8CvxwKzVmIXjlT3NTI8VB4u62/EgOmLE4lVot9nbOs+bgB1aWlfvu0tjM/DYcmw+kVVTG+qDP8g9eSffh8tMu0VIci/9CWLw5cqmebOEqH+/mfUdw4ebVWSh1O1g7x4jQdyOYUJp8yLbsMAJKSDJO+IQMq2RP2cAtU8Lhc9nxny7e4EIIZ98GBD5waDDq7QZiRTdbw5YUzE16ZstR2w7LPxVW+Be4noAeFaObpodWu98d1feHKNTr/k3Pa21NTCmtkDKaQbLKBp/NhrjfTs9OcNZgqU9BmIUDxxlku3be33okZ6xR5K1BgF4KvMIhlUDEC6gmxp8SuPxy56hd4HInejDXGSwH5s7YlBXDOROHXxjbXyYUDtHXNWm6P4np0Xjhi0er+qKYphh7MeU+r2ENAlPC6lEYW7dRBPs70RPqWqp77/2HQQ9lpDC87ZWY1jFt/w6LwuyjeZw+f2dqdAQtqOwUhCkygS9ubWFfxsuDt/rmKjbtbXGI+3tx8ZtJa/KKL84r9Kijw9GnJv3JCObu0wher80lTs1lLTmovO4G/khzSdUR23qOMzQW+M9Z2i3CjGuqbBbnmminPqIvS+IXoEsijuNLubiOkE7qURlIhVBWOVhtT6cDGFnCjbtXYjpSZfG1Xai/SxHNTu77KBcwiB1V4MxBmwpKXZM1FMfUTw64N89JZaV/XHRvYNi9JWu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(478600001)(6666004)(6512007)(26005)(966005)(38100700002)(1076003)(186003)(6506007)(54906003)(6486002)(83380400001)(38350700002)(52116002)(41300700001)(2616005)(2906002)(86362001)(36756003)(4326008)(8676002)(6916009)(66476007)(66946007)(66556008)(316002)(44832011)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PKYFKPMhNBaybkRFSUZbGEN5R6uLKoA1HsnLEn1W1Em9mGHecAWeZ+jFJz2v?=
 =?us-ascii?Q?+spdl7ZuTWqltFYha+w2iRleyG4F7FaLWoGb9GE7ZHBoWpjEbytj5lUNzLSH?=
 =?us-ascii?Q?dyMz+y1cNYIb60jeDWCc5eVF5wf3HeyaTbUu07J8ZTddgKHqtRNcaI5PFPDG?=
 =?us-ascii?Q?yhOW/+C9NfAeiN+pYkoHyW0IaF5hIqG7NPxWkS45I3RwvwSL01orNcheVuOu?=
 =?us-ascii?Q?erdaSzbTHdT1x3kwh+p4keDtO15UYJG10DJS16JiVdA7WOql7fcZZP5YjIvL?=
 =?us-ascii?Q?sdGcJIc/iBVvKxGFtF5UiVxCzj0VoU3FDBlRUm/2Szc7y6BTWRkLZde482ne?=
 =?us-ascii?Q?l8LdzxcTCSU1w0HFbdyS2oJN0LU+/WBctrsD58wJMMXnKKpJIKSCRBI1UWZ+?=
 =?us-ascii?Q?6ekQgpeAFFjUaRD5G7AL2IHkL5KorCoRFaGjjsnXeIEj0cowClJxkmuN+0I6?=
 =?us-ascii?Q?LuFSm1L5SR9e+yoESWGYqmV6txTC97kulk7nmPubPVaEpUMMLkYThdlegQlC?=
 =?us-ascii?Q?t547HsAlyXmNMcF0uwM4GXyeNBtZiFTEdm+TZom/qOW9SGXkrprkj57585ke?=
 =?us-ascii?Q?H0mD8Fn1Gl+WEVoMJcdcdYg930Z4YIzge1alopx/j1ZsRthNVW16IHbkZOxo?=
 =?us-ascii?Q?jq5x0XyyPUzdqxknGm17/s1PV6qUDgrqjfAsDD2ELkS+2QEoQBoiMpGlspcu?=
 =?us-ascii?Q?ri1j/y40ePE3wD2yc0mi4uBTc8LxZkA1qSYb9BUj2OmDTZH3hHakBnzaHpoM?=
 =?us-ascii?Q?HrHgfa4NUpFfdk43ni+3V8NLklyzb+TciQq7A0o+IPob0OCSgL/tti3KQKxF?=
 =?us-ascii?Q?rsXScZO3v2MpB05eYZ4zvo/pzQkwbhyvSz8P6nC0GEWRttcr717e/yORWUP8?=
 =?us-ascii?Q?udYE2/2JTEnkIBEFmb/JJstTGs4C5dlrXgRmSHhy1AGcZue6zJyu/vaxV4Ex?=
 =?us-ascii?Q?AfdgaR7zLXP29dC+IBReOlMTJOEOK/NT8t8E1A9MEe5IjhVG93sWWhDjlPoz?=
 =?us-ascii?Q?PGf1ZOS2MvmHw/gD8kTosvKPZ9dTLQWZG7REix/rK8Yz6V761Avvqe8uqBmi?=
 =?us-ascii?Q?zBO6WOu8OqyHgADL0XX40p+vmVjnNokC/+k6r5HMge/rnXt70H+3iTah1ol8?=
 =?us-ascii?Q?t7LMHHwUAQ5BK5kWTYNQH3yCCnXiXovOCufUz/WwJbQiSOBaWBMCvSwdXO31?=
 =?us-ascii?Q?PJXhHYpgATPJs8hWLUeeCp2Vifg9D0R9cjp0CPXhpUkKar4TM8BHroyXz9TM?=
 =?us-ascii?Q?GTg+ZEUEfL91kbKVAYFyVDV7+TaYph4E/Bxv/f0oxUcCmmwXLB0c63TMYwmN?=
 =?us-ascii?Q?hNQNIhOxqlI8M4N9Zq+DytaQSU6rYqTWAEQeGyHOYq1zLzuTITCTV4kKsR4O?=
 =?us-ascii?Q?laz/TC8lzd0AwCoesoi+8ooIrDfNkUo+E1tASfVABGURMeJGoj6evAYCffRK?=
 =?us-ascii?Q?S5cK84kX7K8ovalTCONj5f+78g7HukoUXDr/N4Bct50Nb3JUr4NAB2jz+QkB?=
 =?us-ascii?Q?c9zHaT7Cuu8YW2swFFLk2e12d/DFAdvX1xRIpOO3HkPWbSGj8f4JK+S8mLor?=
 =?us-ascii?Q?uhxXJz4RQZaiu4FLlLrrn3TCnCiAK7FTJ2m+I1fTviKBtPNtU7B+u7uNCaz1?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429af7f4-87f4-4883-034f-08db0fa685c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 22:46:48.8382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3f+6eotfawQy/x38LiU7m0vQiqtiFmSBput6NxttyHZp8VBnt70RLCCQG+pbUWAA+Dmf5ujL7i2yKCQQuHYmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8748
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio_calculate_gate_durations() depends on netdev_get_num_tc() and
this returns 0. So it calculates the maximum gate durations for no
traffic class.

I had tested the blamed commit only with another patch in my tree, one
which in the end I decided isn't valuable enough to submit ("net/sched:
taprio: mask off bits in gate mask that exceed number of TCs").

The problem is that having this patch threw off my testing. By moving
the netdev_set_num_tc() call earlier, we implicitly gave to
taprio_calculate_gate_durations() the information it needed.

Extract only the portion from the unsubmitted change which applies the
mqprio configuration to the netdev earlier.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230130173145.475943-15-vladimir.oltean@nxp.com/
Fixes: a306a90c8ffe ("net/sched: taprio: calculate tc gate durations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9781b47962bb..556e72ec0f38 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1833,23 +1833,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
-	err = parse_taprio_schedule(q, tb, new_admin, extack);
-	if (err < 0)
-		goto free_sched;
-
-	if (new_admin->num_entries == 0) {
-		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
-		err = -EINVAL;
-		goto free_sched;
-	}
-
-	err = taprio_parse_clockid(sch, tb, extack);
-	if (err < 0)
-		goto free_sched;
-
-	taprio_set_picos_per_byte(dev, q);
-	taprio_update_queue_max_sdu(q, new_admin, stab);
-
 	if (mqprio) {
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
 		if (err)
@@ -1867,6 +1850,23 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
+	err = parse_taprio_schedule(q, tb, new_admin, extack);
+	if (err < 0)
+		goto free_sched;
+
+	if (new_admin->num_entries == 0) {
+		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
+		err = -EINVAL;
+		goto free_sched;
+	}
+
+	err = taprio_parse_clockid(sch, tb, extack);
+	if (err < 0)
+		goto free_sched;
+
+	taprio_set_picos_per_byte(dev, q);
+	taprio_update_queue_max_sdu(q, new_admin, stab);
+
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
-- 
2.34.1

