Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045D54793CD
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240273AbhLQSR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:58 -0500
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com ([104.47.58.105]:24917
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240317AbhLQSRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgoPROZMfjoePvbTya16OVF60kw7JIaD6dEkd1gjhYPFt/rAi8RskqqYvXFoMGE3iMWFBrRnXLUeUjORFr5uiRNpYfbcoI0CmKnMt0hN6UjcVB5bihFZVIz5tWqGBp62hAsuAj1ZnqtPIluC5iSEa9u42LX2ycxXI9uaM7aAx6nD5q/GxO8Z+xa6yXsm8dVjG0G1lHAmKl/U4bt/fSQnZ/9Zbg6Nu8sDWq/u2W2MGK2w4LbMnG7W2mPqi4TI0XxbYJXNbIARkAWjEa8OK0DNayGcCy0M9/4y40bYzeQDeZ6X0PVcpFlE8U9ZxtZNZfyHE9P/ym/ZLdJRtKkyYoabpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1i3cRCzaG6Z03nWMWmH6BmfZEsBQGcxj9lHRADtJ10=;
 b=KLhm5wGmi6WCYe+lr0ymvJL7eMnCCSMkzoW0PtjsgK4NbIlYd/MSRpM5pSjOGG42hmBlACH1u1xPD9yBhf7MJFkBb8KcijIsyapSfXYQkZXtttMG78is0lFYxL69N0CN0D9ryoKoqVfIuqGW2Vms8Yr7Xu31lKIYv7yoCt57Z4HxGScfWoD49kEq9VBJH1p4CQzH79FwxE3rbvK3w+uv4A06KuIBfSrJKsbNbq1efCJMGNbpZhmmNNlX0NpZPfOfBZOS1HuybLirBtph4k709ub13fcVsEdFxQSI2zTfFbY6HXmUU7ijCcmXhbjV9FWDaoSz3Az9OpKz5aq/wfYZWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1i3cRCzaG6Z03nWMWmH6BmfZEsBQGcxj9lHRADtJ10=;
 b=q/RWuzfY0ACrZ0ApMJF88NIJ/FdquEN4zcO3C/7JtJqa0lp3HqJyfyot4BxoEY4u3TN91kUA/Ove1SKTUyLY2x5rvY+tgukNUnCyV6T81hVjK8rD4cgTgbwxSd9B0hitYXoxHMZCaKnPKB4ISR8/4LZFO/xznoASDixYlWn/PaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:49 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 09/13] flow_offload: add process to update action stats from hardware
Date:   Fri, 17 Dec 2021 19:16:25 +0100
Message-Id: <20211217181629.28081-10-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2327938e-88af-4a66-7a8e-08d9c1898835
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB558936971368C23FFD615572E8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9oxojN0VN1wb2Jds7kLhtQG+TFSopzFGz0u2Q7Dc2j8vT91cXEZRYPbcP8r0R8xzVs/Yf70oL6bTlM9vY+sFvCJ6JHqTt3Yc5g8qPXUPMbrvo9BfNTaz85FO+oaVMHYUsWvhGdnpdDaPLaJhhW321DKlGxu+VT7PPg+54nnJSPDr3+uDmXhMbp5RRca1uGTqA2AyWmSFTJbYBV0t/QpMbMwOEO0XqG9mToIzl8o6JA7P2w43staL1P0R3tv7fk0VZhfszSXeyrq/kGb9XwxQcuFcfehk1AE2kTvt7kP1xO8PQZbn/vEiLOuFgGqGUp65TkHjWnm8JZ/uYa1VNnkMQDV5Z+bHcX5WVLVD9ECVF5Ptqbfq/g2HKypQBb5Rs/4JG58gNpvH7YItt/1xQdPvdI3reK3Y6a3dY38gjuaSkkwqj/EYyXma/oBaDIZziwF7P0x1AHSD7DCl5Gs7SpN9ckwdRLiww1RU34OZzRyhW7eKV1HEDrzVOUW/6jwTEitwMHkzixsp/lM+9SYvj3ecZx4RpNWdeI3q0a42OprH0UpJie7ViLxXrOyPvAnvS3g0sFEkpS2vtSDwlB/otQeHcumbPKF7f15FLsVql4Y92rvk+1UePTkXfesoiZhLhNUySYRRQ3miVOy1Lp1fX0O3JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(15650500001)(44832011)(110136005)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PiZJZ3c2/CUGZExFEBEK5NLCEth6xdRARRMxbmzZzO+4ZohekQFF7C8xgeT1?=
 =?us-ascii?Q?3Y0CtlyidZR23yYIe2XxdOeEiImh30RItn08jL4oCz1Who7fMiSSeSf95dXA?=
 =?us-ascii?Q?jfPwGNxW7ysNi8FcOYM6XMFo5fRXgRsipKtnx5EydJuAaexenQLExBwBdBQh?=
 =?us-ascii?Q?u529lU4y71PRTzXo9auKgqPCJGwm1TvGbKk0O4/OBMpu5ortKK1JKFK7Crvx?=
 =?us-ascii?Q?/dTwhEm/1ZySTAgcRqk3Vy1Kr0neG9GtpABAMt2FeDkv8GkSJ3phHoT0uqLe?=
 =?us-ascii?Q?PRtYkDvNd7FRjFvKCh1YZUkzEdcNB4qS0QFukO+oGDop/YuIFs/3ERwEe+II?=
 =?us-ascii?Q?VIawjOpNoor6yabGGD7UKRFGqgNS373UgVpyC7wTUTJflGV8ORuGDPiTDKp3?=
 =?us-ascii?Q?/Cr8zTp/J8fScS7NKnQebOsN14Oy5x/ROWUfN2RVH+6Nb4RpVaWYEhfDGT1d?=
 =?us-ascii?Q?Dle8cQwfGdo9C4cqI21zgbWIVd+DICOwvoyBlc1viWqe+z/JuP0i7KyrjY8k?=
 =?us-ascii?Q?T1cjHQ3CLUoEq9bmjKKFQS4rBe/bCo/ytJALT5+3a7sHCkAexXeAomigim5u?=
 =?us-ascii?Q?Nx2Gj/pI4Ivi9spOaL7V84zlvkLidSxE6mV8R5qGYnCCIGSaXbn0MRqGR2jh?=
 =?us-ascii?Q?FcJnC4S1cmv7MFPLn3l4oetXdNhpsjQMzYQlxTHEwvadLOeg2QsyCXAvprI4?=
 =?us-ascii?Q?71UJtDRsUTd62yFXbQzFIE/Vw9PpIYwoi3EWUH/cJ/rJ1FoCxdSwxLgbR6RL?=
 =?us-ascii?Q?nwgfAmm5jJHss7EQYucbf6+Xizh9TsNkytfaAVY4Tk2gkQmHMSWH7dirMkuc?=
 =?us-ascii?Q?UCtvwblRu1Vc3Hq4vvZai5hOtPObuCbUU9Y0MmVQYR5I2P1wxcFU4lJHNUMt?=
 =?us-ascii?Q?tQb6jRY47dcKYXRLHmSEVGnQNHYC56kiU0dCGTsejdk3+j1Ch6jyhLxmxmKV?=
 =?us-ascii?Q?InkOAv2hQw8kYLM+DXheeGrBD6zL2P4HTmtymexWyrcwuN50IX4Rvcmokrmq?=
 =?us-ascii?Q?xAx+q+FVwPb5zXiCLzkVSVZF0Z55Sk9w6MRl4HCHCsx8o3rR7K0lqKnYehWn?=
 =?us-ascii?Q?RxjbduudeucjOTMlQfKX+Yev7Scis6GiUHwRB4RtueZ+olWIywPkxPhGBpdz?=
 =?us-ascii?Q?KZS36cG7k/41rGgxQN6JMoVLYuMoOebyOFlRt79VYGWhp8FDPc4r0mghIzgf?=
 =?us-ascii?Q?PqQIIVvklrOlhOiiE99KAKBNJ7bYYsZDRcISV7OGB30rDl3PsKvxLGCxWUuQ?=
 =?us-ascii?Q?CFGZXOYJ4cxJBm3CFnLOt/gQU+zhZRDJEIQfLYvr4oymKV6fnLOrOxCqap+X?=
 =?us-ascii?Q?YfKnzWkVFAcyHyi2TtstPJtyZaXTy5DhYXX0pOesXO0xp3SEE8jtXMZ19OTx?=
 =?us-ascii?Q?OYdkEP4hv/mxePMHcPfZI6lgA8aqp9VsjKbU+mAVpi0TjmrMwqPf0GdSJDDv?=
 =?us-ascii?Q?mqbXXrZEl+a4/7KHPXi3+NzNvqlJQVNLdLKlu2SJQoZIovZ2hq6S+hXI79N5?=
 =?us-ascii?Q?8Y5p37ewMZceBLGUvMQCEnOlhgFEAHaijuU9XOQo7xCpExIQkGJjqdOXFvUF?=
 =?us-ascii?Q?mK1VzPwfhQccHLs8tl3d5BWTgSu6LgcpYuTZuo8BJrM9pp4cwDdud3Y+S4We?=
 =?us-ascii?Q?sFzy0HOO3WC41yWESgZFCqcGUnMA5qdHR4speCVewI57gfFlPp/CtqBSUy5t?=
 =?us-ascii?Q?FKSQ+OqXjOOxifyxZ2bOMXfNV6gwe9xLwL0Ot2xseYqJ0tIOlLE/3ynovLnp?=
 =?us-ascii?Q?6KU9ZHniEA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2327938e-88af-4a66-7a8e-08d9c1898835
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:49.2409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJIyznq0OCqtTGFemff7by17DKGIZbs6l5bLERB/k7m2ZwoO/SHvbEpX5Cfd9L6tO6881pVUoEQOPJvRaV1p/rVY2p1z0Fpyu9gJQLgvKHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

When collecting stats for actions update them using both
hardware and software counters.

Stats update process should not run in context of preempt_disable.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h |  1 +
 include/net/pkt_cls.h | 18 ++++++++++--------
 net/sched/act_api.c   | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 15c6a881817d..20104dfdd57c 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -253,6 +253,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
+int tcf_action_update_hw_stats(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index efdfab8eb00c..337a3ebb4666 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -273,18 +273,20 @@ tcf_exts_hw_stats_update(const struct tcf_exts *exts,
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
 
-	preempt_disable();
-
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, drops,
-					lastuse, true);
-		a->used_hw_stats = used_hw_stats;
-		a->used_hw_stats_valid = used_hw_stats_valid;
-	}
+		/* if stats from hw, just skip */
+		if (tcf_action_update_hw_stats(a)) {
+			preempt_disable();
+			tcf_action_stats_update(a, bytes, packets, drops,
+						lastuse, true);
+			preempt_enable();
 
-	preempt_enable();
+			a->used_hw_stats = used_hw_stats;
+			a->used_hw_stats_valid = used_hw_stats_valid;
+		}
+	}
 #endif
 }
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index d446e89ececc..f9186f283488 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -246,6 +246,37 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err;
+
+	if (!tc_act_in_hw(action))
+		return -EOPNOTSUPP;
+
+	err = offload_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
+	if (err)
+		return err;
+
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	if (!err) {
+		preempt_disable();
+		tcf_action_stats_update(action, fl_act.stats.bytes,
+					fl_act.stats.pkts,
+					fl_act.stats.drops,
+					fl_act.stats.lastused,
+					true);
+		preempt_enable();
+		action->used_hw_stats = fl_act.stats.used_hw_stats;
+		action->used_hw_stats_valid = true;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tcf_action_update_hw_stats);
+
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -1318,6 +1349,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 	if (p == NULL)
 		goto errout;
 
+	/* update hw stats for this action */
+	tcf_action_update_hw_stats(p);
+
 	/* compat_mode being true specifies a call that is supposed
 	 * to add additional backward compatibility statistic TLVs.
 	 */
-- 
2.20.1

