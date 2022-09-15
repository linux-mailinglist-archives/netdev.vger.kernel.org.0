Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C305B991D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiIOKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIOKvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:02 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5CC4DB05;
        Thu, 15 Sep 2022 03:51:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMr5psWNVP4f0u5U6pvMFSRfECnJg7howY1eWe2botNJLV97ahfBvrtKTCi52qUonsr71EMW0KlzuKIsYO3b2l4fTpXo1dCyz3ptmjH11qVUWBYS6lZjhyymdTT1f5gaf1Nvux+t1qWz136K0ghn3XsZQ/wlQ5ooQpG4XAEz7ciYLgTkIYArcgxN2MHztsk5rTWVFwl6x+Ejk4dB1oljQCthoKfwIMXRCDq1BmE5vhlXcNpL8MiNu1/GSEBhg6FXTeFPgizst0meN+WqfVQYCbJjH4WSVtDlFmbKOPOAxfS4mMhY0NM+NyXPPUsSqFF7kt+HEuFwdds2Fi4W2d272A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QPYr3gi02pCxjw7Cn4QkinU+FClOZUJSPxpxxITibUw=;
 b=jfmFF9d0T1NLQps5MfxYTTDEH5tYvlBf/TJxgpygeax8xSi9NELUKiAPlu0skBpWv3tomlLJS7oz2kgioFAjdIW++q4w0AOLTZDJt4leRR/jgEiVwEArcv7xf3RvqVlczdeYSXsUMNzIbF0MTsRKWr8EcBBGAnTH8sJVC5OqLz/7juvgsux2Mk7SCEMzsBPXE/rF/ycmIGWlCOzJdKkE66C58t9LEFBiApvavkM6vO5zVJ1MK34SJo6ByyQzjS2HdkpBvarPfeASCd9B6Amg4tFM2vkTVVzD5DM8wU9yHWFTjNlsXh4mXE/LIXtLVt4fjPhwC7oRNoXah779kE7mDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPYr3gi02pCxjw7Cn4QkinU+FClOZUJSPxpxxITibUw=;
 b=qNoraUBLLQU8OvjwjCQuXPFV1Reojkras8wumIntNh2/C+WwcOAgpJZpp5pmLKuyKx3cjqoYwNMKLtAxqEDSKT1KHvZKV/OoW4fqR+kMrMMwdeM2WmtD3XQCgZHigQt7uvdVDFp3SRTOKMERQu6di83yPcWrFeS4z275oCzv9Z0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:50:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:50:57 +0000
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
Subject: [PATCH v2 net-next 1/7] net/sched: taprio: taprio_offload_config_changed() is protected by rtnl_mutex
Date:   Thu, 15 Sep 2022 13:50:40 +0300
Message-Id: <20220915105046.2404072-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a2538350-0e1b-4865-41ea-08da97082b64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZuHa5FC0q4iU+6Y2XqfUfVgEKMV8fg9t7rz7Y6Aj4xFkgrsxWxWqXpsRn9Wxp3JYigHNUiDVZ+ZSIDUIacBpqOy1l6sM70GhDQXlCtbBBLzV/THEEawFH9x7mIu9nj4s4roK7O43RhjYM/dbRcYf05aqJE4VUF0hfdmW62cjEQcgrBVwdcj4vjxG/SIbQ/FjwRaYEljvylUqXWZAJoP62s0UKFSBpt+86k/vWOD8nHAVbGKSazNNhV23ax7ZdHyzvHKUkaxaeykZjEfdOEsFap46jK95HnNdOBEN08+xW4myJstdLh4JpjkcqHp9Ij64I+0cJ4JXf8PwmVWH92m9IheJfYHbaezS57b0xTD7GSq4pqleZpSNlfgP7nOKt6JM/+wSnHH28UVwYrODj/RsgkLAJtA9oVWsrqEP5wPZIjmGq2X7VEE9xBAcM7sR++0ni+jSXXgRQa9J9cGcvtwAd58D9FQWudHEsK9WKa0SqEUKCj79tRI8yzVzYaMJCqj0EpUmabzhOIiW+Zw3PZUbtmcFZ+6H5DqwUM+CkzksrMAEjFU7+D6dl+LCoIQcRAo1AXnXrd2tYQo76QWwzpdPdTK2K/JH5s9SXB/JClbMta75JNRof3rwa+gWzGX1Piv+kNNcsDATQSwFJuhOwy0Ek7XMkDnvP+nTZpv0QlSXT6fgruTYi06QN4mAalJeIDi+MAwek9E/wZioQ/JtWfgzkSFm8HkNe892JfyaZ1cwd70QFbfg8zSGrLmem7mLlwhIcgzpJfdoqyKoaxqXpYtrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kvv1gZiJ5Hu/kBWb3tyhUqBGYCJQL8uJh96TgiCvKUvNDVEdMuRvUmED0zrt?=
 =?us-ascii?Q?0xx+d8bUwDnrLK36jSBfBPzMvRwwoMtGoCIBAXhgwq7Hi1AC0SWv8/ArcX+l?=
 =?us-ascii?Q?VZ/k8xO2v++6EPGaMLe7j0UUxPXl5VrBMzRR0mteKmtp8TyovBpw1rB5WLSO?=
 =?us-ascii?Q?7+a8znvlUOcRHFqLfqkPQ0LxdMmuAOVA4Wv/ez1tpKnGhaccrFQjoWRGsoEj?=
 =?us-ascii?Q?MsecQgVp6o4N1NI+qbGQskrOPJIOMnia5cg8+hq6gF6OOEpM4diTym7o59IR?=
 =?us-ascii?Q?9hF7+02o5SCfFh2zIJ2wCwux4iudqSrP1PDiu8u0X748MMV3OPzL4jqOkEHg?=
 =?us-ascii?Q?2kn307wzpk64jc24nuxvXEp9Qmll6PxbRz1JHjlXSTJZBPB7nE2VvsPaN/jI?=
 =?us-ascii?Q?T/rirg4KlmTmE/znbsahaiQEsGPeQk0w34zWaKqE6Hisp7D5XIDS+DQL60Rm?=
 =?us-ascii?Q?vqXODwJ55SyDrvsJubkJttAZCiVcsABh+v4s2DnlRewgCL8uC9ThoytRUuio?=
 =?us-ascii?Q?gXoKtwa8hXhGhn6WWpTCtZd1X9SMwd8HXjmkkMJhVnQ01BH5ABpAJq9tAqhz?=
 =?us-ascii?Q?U7aAQJ4nwccmgvMU9I7Faj4L+rd6hekCT8QvN9v7UWsn3P80+Q7C6cbWp3zN?=
 =?us-ascii?Q?cOecOQn/LpSR2rH/Y9treOS6++rALUPiTS8xB2R4lYIhudGExAmncOiDAK6V?=
 =?us-ascii?Q?q6Qv+mX66dP9J2/LMx7cfePaPp0c9FR/U3ummrfVzy9I0mE2swZFOxkQFXKT?=
 =?us-ascii?Q?HDlJ4c1BM/A0J9bHcq6Iu05YKuFarWURYEdoS3zpHlPcEczJwKSNoDEepQLy?=
 =?us-ascii?Q?pnyhcoQVtr6BT9wio62qPw+l+Kszy3yrFkyOt/zcoGQZiG3Ccg1tjQH2qG3Y?=
 =?us-ascii?Q?iaoVkVrS57lEssRP7KUQvTDha4IJF5lxuioFM2DSL7TR6uJPdXTyTSjONUeS?=
 =?us-ascii?Q?0bR05cDJJbHmcNoCIJnIm4spftDhAJrS0X79maUhsC6VLK27QDIuceOr3MjF?=
 =?us-ascii?Q?cw52zy8e6Yc97LJxLbCSlx64qO+xvG1YZjhd688c1TLq0zszjFMrfvonT5i5?=
 =?us-ascii?Q?qZWDprohyoP9+kgjSpGF5MzV7U1JKSzWj+uq/E4SZbFjy/1dFtRfnQvu8/HN?=
 =?us-ascii?Q?4mShRRjiP2ZGPmYNA24B0Bn8wXj6hBzaM2AqgTaPDNtXl4Q1jy/Z+Y7sizaw?=
 =?us-ascii?Q?GBiFv6CvRhMvuLVjMF4o498+uat9CQr9Kms6z3mld2GnYKWIEbk0MaY4GgxE?=
 =?us-ascii?Q?fEZkEF1g+dpH9D9SZFkF7qeYhtLMuM9M7f3hE1oQibHNnRomAjntQlYfY8Va?=
 =?us-ascii?Q?SG1NIGtZyX971I1rjHIExxNNTTNSTTeOs0ur+dNkqNrFxdqhaalQatyQSJ5M?=
 =?us-ascii?Q?CQ5/8lZp+2R1F1uciEUku3ZdUV1uKduBd3xJ1rQOu5sxqfM4QyIFBFCr7g8A?=
 =?us-ascii?Q?Wm9BNtQTUzrL6y4VJ0o2hSZmb38PR82M7n9vmcyVz9Tg1vBcBnxsjYEpLT7Q?=
 =?us-ascii?Q?Cq6TJswmymSCw4EKVbrZrdXPjQ3YqcW+qta77jPus431bwLHj3sL/nRR42zL?=
 =?us-ascii?Q?SbGHPb4SP5rB3lUE7XkNCVoTAqajTuT1Mil6yjRA1ikl1F4NhyOndi1Usae3?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2538350-0e1b-4865-41ea-08da97082b64
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:50:57.2213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CbxlJoORD2UQ4ZefAcfCKPjCV8W0gA9/zBAb5ibyV//q8PsRVOfoziFVGMb3Apap8wuouOd0LjJXkRD26o88Cw==
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

The locking in taprio_offload_config_changed() is wrong (but also
inconsequentially so). The current_entry_lock does not serialize changes
to the admin and oper schedules, only to the current entry. In fact, the
rtnl_mutex does that, and that is taken at the time when taprio_change()
is called.

Replace the rcu_dereference_protected() method with the proper RCU
annotation, and drop the unnecessary spin lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/sched/sch_taprio.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5bffc37022e0..550afbbae8bc 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1194,16 +1194,10 @@ static void taprio_offload_config_changed(struct taprio_sched *q)
 {
 	struct sched_gate_list *oper, *admin;
 
-	spin_lock(&q->current_entry_lock);
-
-	oper = rcu_dereference_protected(q->oper_sched,
-					 lockdep_is_held(&q->current_entry_lock));
-	admin = rcu_dereference_protected(q->admin_sched,
-					  lockdep_is_held(&q->current_entry_lock));
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
 
 	switch_schedules(q, &admin, &oper);
-
-	spin_unlock(&q->current_entry_lock);
 }
 
 static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
-- 
2.34.1

