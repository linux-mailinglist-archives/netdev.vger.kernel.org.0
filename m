Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F845478DAB
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbhLQOWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:48 -0500
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com ([104.47.57.175]:23036
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237289AbhLQOWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCYdNwSuCazZgUBiOTh6QTwHbMx4chNr96IdBkLe04RQPZJzD/X5Whvq0Sx9MuEEDQyCGbm54uUr88fpcJAl4mPYTs7k6dOmw9N6sC5Lmiq1Vb0MppTiHiVP67UBYq7WcTfzELHErzswMmzS9+2dL1gX9uz8TOrP/cvJpVPXGQ+grVD6F80dHwh1/M8dGE1cjJfFYPiVGRBisztsMSby1GZRF4Rv/eOwNK3Vnv+7jMEtV0Hu4Ay0YcP3PAwZX0Ft76BATVILJ6PAnYRQCZHv8PAtg0xgN5ZnfH6DK4H4EoG6Orl8b0SqGYR9G+PlZSCU6nL7F9hav/ARM8rpUomIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QfSgnjsykgOtzdPL0C1gZtrHXn5Lvx8cmTtdYaeBzA=;
 b=I+uSUU2A11HNUgZxttPF6e2lW9pfu/nVwVWVnLIO3RnI7HbqbaKteR5ZquDMvDzfglZhL+/0J4E5sj2EKrBCEmRWQ5ERV/A7SKFAFtqrV6or0p+EBal8S8N6eZV7k+wW4IZwfokggacA98enPU+InN+F2yhEp64aWkzuedvMX4WZFyXnGIFYzhQWqEVm2SEGgCNb4Ev0JQ0/DuWfecwoM4ba6ZfP5df5zApidKdv/JXfZlIEPLQBrlIZ2OPuFzcGi0cILFhC+ZOqrX9yPrAm3A/Ks3umK5JhvnJs0N6uMDpachhckS1AkarrA2expXqOX6HXmt36VTAKx7fJrK/7pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QfSgnjsykgOtzdPL0C1gZtrHXn5Lvx8cmTtdYaeBzA=;
 b=bD8dbCA+6SiyZKJdzPsM9aN+7BH5KcyE45QKgBlRLi/22pHeMio3TMXpUTWstsJEkse3ZXv0suc0k6aq81VJxhIzpFTlMj8VpCreXDiKQQ/1rJwDAf5Gdl397cUcnBLwcD9MaYQE86z0jJpQrxfpAHKbG/hvI1aH2AU+E/mq/OE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:43 +0000
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
Subject: [PATCH v7 net-next 08/12] flow_offload: add process to update action stats from hardware
Date:   Fri, 17 Dec 2021 15:21:46 +0100
Message-Id: <20211217142150.17838-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 287b2464-5f2f-4cfe-438f-08d9c168b0a1
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5595FACC200529421B1487E5E8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HEhGSDXiPyB0goD5Xo3mep0N9cS2zYFl/wapPYa5gOKg0RrGPvvf5+OvJmIP+3Czfn9xnnr0VjsF3g6eYCy7DfX61tNrTLEYVKUDPlagAJHU6aellIiNhPyAQ9Nz3pR3mSRqF4e/FDo0Q9RJHa+Prs1hdQPfbddUObSMs9eUmxaxIO46Zj1goStpnbfio00XATfMoktiV3yYEKbNwk4r0o4ZOfO7GTCm6Rs+leNpcHpJ5g/GGbKTueWJz1JH4IakOE6QgJreN1Yhb2MG3CorEhRpcv8qvtRrFEoJHdeoilbXScKxeOTzDqibpPBbRG5BV1DplpfUYoIGRBzJbeMz44fa5z5ohipKO3nZ3hpuKt+wLqmxGf/2I7+I56S7OzppttnupkyNXhxEE4dZ/kn0o4HNjRUzkpqUQGdwMcnqdV/XSW9XAJIQm5GgKwYTvMmdhemRfKdIYl5+Qbys+UyIrzquKl9e42hp/n4YREJYcHy1yBGcVvyuPqc2t/4SgyAnHMkUMCxxfcN8B213wwtAsLjN/HX4mXcTn6uiIdIpYr6JiowxiI1tQ066WFQoKJnqjRyTrLI6FCj3VZOFDAwdYl6YDebecjomX0tpkPG67yQ/wWDTUwGodBELgqHbjYhxnTvyW8f5rYpInR3nV7QI9uFQOIjLsTdt5s0oELKaiPEOjSTnxs9DOaQqVW9Fu85
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(52116002)(5660300002)(15650500001)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?el1CtNWb95smwGVuNQpq4xtk3nvjrrk7pxl2EXu6v/xiIbaxg0ZNHm1hFyQh?=
 =?us-ascii?Q?L3nwYgn5gXdbzctSP3KO7m3WoBsK+tEeqFqEUNAufmC6mDX12y2FTqvzstgE?=
 =?us-ascii?Q?ev9qEt90DWRHvkVI4OLUJalBYi9mWtsKr0whKLpkIlf7GzVIRku2kza5+QTn?=
 =?us-ascii?Q?+A8IDtcD43MXXfMLIPvQW3IORKeZJN+u3ha6KdNpb5QidFLgUOmO28+YM3iV?=
 =?us-ascii?Q?I+RJxXtRzcuesqMj9+4WtQfkfLCLj+/C4ETp4njGxkIqZhnFXJ9rLgmBVlU0?=
 =?us-ascii?Q?sUlTaMfgQiNz8k02rHT9DAC8ucyHDuA0qpq46TM5FMn02vxUgE5ZmDtXn9oQ?=
 =?us-ascii?Q?agAmIZb8exsYIN6QfSDPVGg8TE82PRbAni2r4lyglfIgM2MQpPqzh8PmCzd7?=
 =?us-ascii?Q?m4KaFEda5WpPGLCN9ilENDXm/Jzgdl9otSO6zpsA61OxB1OG+vSZJMxYfQsE?=
 =?us-ascii?Q?zsge/DD/XK9noZFZSebtBMAVRHxJeZw3Ow2y32v7O1YYpeZTIksgWMdn1w7M?=
 =?us-ascii?Q?EbKxkpWUpl4zNQM5UGpB+Ln45LG6LV04DDHEu9psQz9pj0lfbf7LjtZgPogm?=
 =?us-ascii?Q?WzljdHF7CKmdtob3p+nlgBTPiR5yZafIRoD2NWv9M2lZ1Dyj8Z9OkeW4SZXU?=
 =?us-ascii?Q?1M6UwT/yxQr5Ueid2dqPOccnToO9/96Or2mbR7SOPGe3oVGqAZnIcQpfK03D?=
 =?us-ascii?Q?llmq2tCyOpfJctlXJ0JFpTgTEZm1Rw0DvSIn3LnrO/NrmBti+IspBk8ZpfPU?=
 =?us-ascii?Q?lehyDxWqPDuS32JJj/QjOgdpleFjBntkUP2Lp9sFNlbDf4hxHCuvZnewzk2a?=
 =?us-ascii?Q?399MF6LPb8CYmukdcL9zyK8pH2zuLOeHd6/AM3HLYFZRa7qL5Ylu+HobmJes?=
 =?us-ascii?Q?jvk10ygAsL23LIuQkItNRNbAnJ4qGAhnK2W4K/j7OhYZ4MfBmdB9phNhDK/2?=
 =?us-ascii?Q?Ne95hP63UiC1l8XmCcAteRZfahGy0c4I3XnTsQ7Oiu+CKh6Hpd3/27eDyDq9?=
 =?us-ascii?Q?0b0xKjy0cHS6JoErpTPV/35rTfEXkjx6cv1Fu3O7LOKbFXGqjcAT8zY7ZRz0?=
 =?us-ascii?Q?VaKBxGSHs7C8uh7Eg0i6UZh3PF29YE0qAM2l72ddTkyiFQRtwVNiQuBGUKoI?=
 =?us-ascii?Q?7L3VrAR3YDBcuHV/OeotapSJqSRxBE4m5q5JVxoZlbNXjO27hARgbi9GjTmp?=
 =?us-ascii?Q?hymFptzcWwrhXIPjurkW3pAsO/tOzlweNU7EdnnNjKyzY/D9yUxTeakQ0quw?=
 =?us-ascii?Q?E6z44LvUM2njYQO6+QKJZCaexGIvQ+qm6k323yKLD3tg0RVQN+pJ6hAycMwS?=
 =?us-ascii?Q?BbBagYMfqSGU4rGtnTpSCBm0oYuq8+piCjqdDNkx3tIfqD8b2I7N4AAH29NE?=
 =?us-ascii?Q?66SMSWeD0Xa26c3ytAtieKu3FqcfbYHcKDYfWo1tc8OjRokBj8Qq0VDQW04W?=
 =?us-ascii?Q?djt/g3rXdAzU3GamCrI/ftLGoiKrp9uStCZHPIVl8D0+AoP20XXETM/iE/IQ?=
 =?us-ascii?Q?2EAYK1eCZxCUjiVGBYbtGejlafQf4JBRTbRUN1GCEFhbmY74qJD/pX3MoqGS?=
 =?us-ascii?Q?YRuJMjMNJnhdidF0v3/2VQZoiNnQfNUmN/xLcp93yp7d4Y3f4JLRZLZ3NMQg?=
 =?us-ascii?Q?2232f1uHpX1/M+DishlOITn/8/xRkWB23HTumcqBgsfwKGW8IVsIpi00I5qM?=
 =?us-ascii?Q?4sDDrYof9kFy+PoR2AccE3UiiCQuXEo4EqNpnrXrQz8bUpMToX6eRcYtKWyu?=
 =?us-ascii?Q?5hMQ+jsI4Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 287b2464-5f2f-4cfe-438f-08d9c168b0a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:43.6701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktaG/Oti7tpJfXj8XF3gjC1MQ9b49xlv81MLEg+I1URSq0ozHZ0xoJH4r3NoY9PR91S/p2Brw6QcVsrPTzoEiZ5ECF5afusSO7xtzGMHxnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
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
index 1bfb616ea759..9021e29694c9 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -273,18 +273,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
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
index 073461d9eacf..ac6c2c396d4f 100644
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

