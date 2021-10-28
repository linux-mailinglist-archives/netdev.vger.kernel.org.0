Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3132643DFC0
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhJ1LJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:48 -0400
Received: from mail-bn8nam11on2113.outbound.protection.outlook.com ([40.107.236.113]:43800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230225AbhJ1LJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQWtRViCWaYRncWQj488+5vnRu849kUnKkqAAVMeKSYYXjXKxaBEiLdhC0PvVfKtrBo2z3rx117MPWAUs0G4ujwjM/zhGguEjV9D/948blOGfeCo6zdm6RpGEFmzkhPbIJ9ltyQyIkjOxh2rjwb/95HunVzjcNA5vggMSO/Fra0x5R3I4JIR17/NqGnc1AfJ7lEEzEMFvUHPoO3oAXjH0Aarx6+ygM7551DdbEtle/wmQpA/mV7JTj6e4xblBxaheEImqs2o1EqMhJ7urJuGdtrVZ9TQYIgHMCrG7Ifk1EiWo2NhrlsvrhEML264RfNTkDg6d2xLcxW0/kY85V/Mwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BD4o+W79tZvEn30aZKKdm3MFBJ/CGhMx+A/vrHGWkrc=;
 b=exE5q0P2364i7hph4A0+s5bggCnjLGysp1JPUOffQu0L7dDM95pry35I5ywF2jd4Smg31COzZwMXpePvxqAbQ52YW8iU7lMZ33bdiIKGOf40sGa082xI1zwOglD+rRLEobyGA70R8EpxY9fkHVYbDP+3etUxQaL7Xazl06DIZCYPC/g+kdYlTUuOeUmt7DYNFY7f39xwZnbOxUUUDG5h3/7WANLBCGE+Aek2fgWovclHCb5BGky0dnuCh5hgI3Y8Uc8CGpfROA3M4y7PDjXhW0AIfiyOQBmo9Oo5viGdQiSwr01BYS6h4wrRqGUlhHvynlxtMWIWVZEEJGZ6IY7oWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BD4o+W79tZvEn30aZKKdm3MFBJ/CGhMx+A/vrHGWkrc=;
 b=NLd3bei/uD/pw7WuX+K4K9hneNnAAdz7pRWITNniLIqcCxNx5u+wxS3fwfmv9U0EZLSRrS4Fk4UA6MBhPl7SLX0ejW8d7ZqzPJQzYtaLmgoSBAsnapkk01DshItNurWbRqdOvqVu7p5GwLI9dp2WR3U/D25osjJOnNVbxSFX1eM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4956.namprd13.prod.outlook.com (2603:10b6:510:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Thu, 28 Oct
 2021 11:07:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:15 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 5/8] flow_offload: add process to update action stats from hardware
Date:   Thu, 28 Oct 2021 13:06:43 +0200
Message-Id: <20211028110646.13791-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a611a3b7-2338-4959-1bd0-08d99a03198a
X-MS-TrafficTypeDiagnostic: PH0PR13MB4956:
X-Microsoft-Antispam-PRVS: <PH0PR13MB495643EB2940F79703A4E9EDE8869@PH0PR13MB4956.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZB+kw5xF6+8OyW6BOAy25Z5kkg3AZkG3pfoc3T+wqF5R8WBzDCloIrqq2bqdpqVkiVuRtI7u7ilK2h2aTA999Qlbb3JpHa76bWcxdndBEjDK6OFdZ9Jz0nFrlIYLLLLw+vWRAJORR70lzK1p0Jgs28oSL4ILnuu/gUpJhskFltkTB7MG8ZnhPlRH0fvY9QP/pw47Zlr9PlKiMMvujCEkoar32gqywceDyoVs1X4DeQVa9eYL4urWgaB6Qo4q9lgBpZvL97jVrNB21sY1BlSrCmx9o5gpxGP3d5QnoWKkbzIUbjWGsCNMjuimTG30AAbrPUs/gNbqsb4MhljGa3ixXYuYYE7p4rYWkI0xWAbNqQOREVg/pamLmchDQ7LJljHeiSi1dthRMPAtWlU6uGhcgjWX0DSOnNGrBa3ukE6MsM5PHRdhx38SmiQyImb1Mt4VMA70EjGNIvrBPE8+9WcNlqVZgHWNp/KEcrnE0GWUKOluvpd0uYBgOC6F19XpEtfwzfKBJNWqh8QW43/VT/iMtxxxtxFBk5wbXbnzlCbUhfi+Wmb5ZJmO/e1M04YBhuPYjK8rfPkAyFVHBPnBbg2Bx8A8fZEO4MYKZ2yz5byUY1NrHlZ/MyGUOh2Qq70deAiTMGdJmVy32kw1I6M5kOWyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39840400004)(396003)(4326008)(83380400001)(316002)(36756003)(54906003)(44832011)(6512007)(8676002)(2616005)(2906002)(5660300002)(8936002)(6666004)(52116002)(186003)(66476007)(107886003)(66556008)(15650500001)(6916009)(508600001)(6486002)(1076003)(66946007)(6506007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?85Pt9C49P4d7z00g1yxb/Zhpar59wzAvhhLziqaekRdfzYVFTqw4sT7RUHop?=
 =?us-ascii?Q?nefhw8B4ucnMgGyTB5zFS0tWKItwqraCmFdMFIncYsaq+TahNXGUiitBXTsY?=
 =?us-ascii?Q?LEbv0Kthn8KLqQ1rpBA2LXmBM5DNBfCPqap8YBEJpw7211hFV0zpNMJjA8tc?=
 =?us-ascii?Q?O9dccPrL3k1RFugSeH6Eop+4EZqfd/euRGx4iasXZJ3M4TQpuZRNIbNy8tHH?=
 =?us-ascii?Q?17c/2sCO57jATXE0RS2wL36A8H6wlDbWyhi0u3psU7IW6D0CE3kP5622q9I1?=
 =?us-ascii?Q?VuVJr3RzKnw1MoQoMLQ/5Aeb0O2bR97p/4rtVmMUJ+enirWXXmI9s5J/CXv2?=
 =?us-ascii?Q?bWQ6AHtESfz2v4RU8Rn5Z1Oi/7CwXwdPWaJDj8Hbx4rUX68BupUumF5AiAeB?=
 =?us-ascii?Q?BbF1sTW5T9Vzzvf/WvpExqKaJ4//ID818/Xao7sjItdif1hMtWBlLTwWxp/9?=
 =?us-ascii?Q?yk/tGG3dhGIhL0ZmmvrY61AjbwegFuh++uuWcTspyArdIi9pBmz3txR9ERlh?=
 =?us-ascii?Q?fuRzAXhPkulxbPwMLbGIFowCT80T31K2M9oyJ9wBh/h1mB/y/BUFRvajcXqo?=
 =?us-ascii?Q?bvbaE+zCG0XeXd3smqHNaSG4IF7OQEKxcVa7gNN3XBvGAtW4GPr0FHyEZHzK?=
 =?us-ascii?Q?AijwEk+CD1oC9mdW4xV0LNRl4bRMqdxsHAgVatiL+ypTF5i80au5lQTdk7L+?=
 =?us-ascii?Q?8mpfWEZKsk1z/uwgt4q6JrFwXptA14pkLXqiAFgS1NMfDxCL24irViXdZQ+S?=
 =?us-ascii?Q?94554F8TBylgcDY+AM8kLLXuDw0FVPVOB42cM7wb/hKRbaBPlg3M7Vh73Dkm?=
 =?us-ascii?Q?xR4dt7Kdh1gwrtH2AkpLmyFMy3SqhJ2yzjvyJ0XQJgYO7+/nvT8hYD9Unpzn?=
 =?us-ascii?Q?9btJBNa35bF7xdpyMJGKB6xqBKUJcFrPwwE4AsQONIJdBrnLQwUy03J5a2UU?=
 =?us-ascii?Q?+9NFG8DF9QPbdRRm9HCV+kY7ShLOauTuDgs8iRyy2Maw2F75+HQkXDVhwIYy?=
 =?us-ascii?Q?6rGE3y6N9M3D/Xt4hl5xYyBICEV2P8IVt3YC3vI3C+IiHGeLhvHi4FE+37Hj?=
 =?us-ascii?Q?+/IgXQadIpPsc860YSt8+/buiDLu56Qwo5G+UJ6zz6MqSxl/d1UFIEwY4Mt4?=
 =?us-ascii?Q?hYrIw/cfhXTNP2yqC4dYcIEvy4MpB0Yf7VD0aBzheavUVlfN3MvyaCb2icEH?=
 =?us-ascii?Q?BVQKOVnm2r1sNDmyczPI5QGer1ge8LUCqLexRCg6nDQKhG/mqQzlBCxNnWVl?=
 =?us-ascii?Q?LeotQnoWUU0HAYM6rURU4qz26Efi6M/DiXw85FBt4PlXx7bc9T9OVL0W36WE?=
 =?us-ascii?Q?J1IU76G+PqfSiu3fKtm9C3VSY3LGWpxfPJajcNUJroWVqUqpclr9TCiDt5Up?=
 =?us-ascii?Q?fHPKUEeHLNBgHGM8agQW3Eltv4hEc5Whsk3yhX/xXEDX8C8jM3hxiN05pB2N?=
 =?us-ascii?Q?WERmSmeMEW7CqSIhyKACDPTCWzsJmcYc3lVK2Bf4oUMti6BiC4zKffrXYC8a?=
 =?us-ascii?Q?ApY78AXpl+rNH3AnFh4d1VNIT+G3RmRFpzKbyYjsxzU44ODHa84QIuMW9cBL?=
 =?us-ascii?Q?iywhyLrZFXm2TGvapQd6FuoEbisCeWxu00VpBuRUSaJSCBL2QiaeTUYys14d?=
 =?us-ascii?Q?BLZQcOH/tPEt2DRrP1Ex4RoN16VgFLJ7DEkXn/N4fHVWI4EsnhfNtp9Wowz5?=
 =?us-ascii?Q?FQGEnaAO2NCflJoiUn9U0cS+J74xJlByC2tQXMZGrmD5CvoHPq0GLZNixq0S?=
 =?us-ascii?Q?FHf+hS2623cZLtqD8pZIVKMf6oYD6gs=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a611a3b7-2338-4959-1bd0-08d99a03198a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:15.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vq93Gpns5p7dLrLKurhCzUFvtEesp5wFKFJhzsd1wCpBuBEg9cP0t4/lP035LBzwnIyFaTcDd8zPrIy6GEU0sWjbFZT2SCqMzVJwjAfGv+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

When collecting stats for actions update them using both
both hardware and software counters.

Stats update process should not in context of preempt_disable.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h |  1 +
 include/net/pkt_cls.h | 18 ++++++++++--------
 net/sched/act_api.c   | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 671208bd27ef..80a9d1e7d805 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -247,6 +247,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 int tcf_action_offload_del(struct tc_action *action);
+int tcf_action_update_hw_stats(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 44ae5182a965..88788b821f76 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -292,18 +292,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
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
index 604bf1923bcc..881c7ba4d180 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1238,6 +1238,40 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err = 0;
+
+	if (!tc_act_in_hw(action))
+		return -EOPNOTSUPP;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
+	if (err)
+		goto err_out;
+
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+
+	if (!err && fl_act.stats.lastused) {
+		preempt_disable();
+		tcf_action_stats_update(action, fl_act.stats.bytes,
+					fl_act.stats.pkts,
+					fl_act.stats.drops,
+					fl_act.stats.lastused,
+					true);
+		preempt_enable();
+		action->used_hw_stats = fl_act.stats.used_hw_stats;
+		action->used_hw_stats_valid = true;
+		err = 0;
+	} else {
+		err = -EOPNOTSUPP;
+	}
+
+err_out:
+	return err;
+}
+EXPORT_SYMBOL(tcf_action_update_hw_stats);
+
 int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act;
@@ -1362,6 +1396,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
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

