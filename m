Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD26D47CC17
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbhLVE0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:26:05 -0500
Received: from mail-mw2nam10on2111.outbound.protection.outlook.com ([40.107.94.111]:53446
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242366AbhLVE0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 23:26:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVuE57GuZpu0PcoNDJ9Jw5viteTNJPG8fZXCXZAaBA7tdvnXCtrMsIKrWUnNy0zrHjZgRqzNLf9Pv8KMZIZAEZA3NtA/9eC6pj6tLeWiaHB4VCljF3b9PebUdhdPutjbPe35gXwyV9RjQmDc2bkXW24TU8nDsH5DpUxTCyncr01RROHRiXHlafq548iXjpAowkVeAJIRP7wCDENUG1y9UsYxG6fOysRhuNkD1Oe6i2RFFYgdhzV115uCrhEwiGJZzgM3bQpCkbqJnU6nInohZcwumH6lpeRgCn4IpSMznG4YzkgfBr4nFgSGtWvXUzADbLOSleheRoFul/gzLR8wSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFfrY2/rVSGSyevDFGiT+2M2NlcGD8ZcZmowqnkbxjw=;
 b=bbz3zNNw95HvNpcu9AERR3FlnTZm4pB93Pik338w2nLl49m+DIiOBMPLVKnoMpWcB1CL8TdX+gaHmRRQbmwo65NV4HYX7x0v1tSKRaMDNMvYUzeHrdhfdn2bjrgWgviZ297lGTKVwBzx429ZxS5JEPErC0TtwbEVNrNafaPIsguMyK4NJ/l8EWlHxlqKReG9LM1mKfhwZbiMeUETFE+SAHm99TVC5NJBa66DW7qA2Kn7Q3R2doZj0J88SYFuUS8a+yaqP8rQYrpnXlFodvpNDN7mDm6JLA8Kb0uWdEVrayx28H9wSRehqQM2URuQtynJpE2h5lj0gm7idEaPY9+GkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFfrY2/rVSGSyevDFGiT+2M2NlcGD8ZcZmowqnkbxjw=;
 b=sm2GVCz9wOMzLAGcVu3RfnPQDOHNDi99vvs5CBnlWpRMD4fuHRhj4+950Q3DG6o4ZQsCj9a4c5oQtrUgf0GODgs5sK5QgDiXk7pCaZ2P4ChCb8SSVvkRIjLL5EZ+IzRdh/gPTw9buT8f2/yDfv79UAWUNxE1bnAS8PQs8wBFkZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BN6PR1301MB2050.namprd13.prod.outlook.com (2603:10b6:405:33::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Wed, 22 Dec
 2021 04:25:58 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4823.016; Wed, 22 Dec 2021
 04:25:58 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, louis.peens@corigine.com,
        oss-drivers@corigine.com, eric.dumazet@gmail.com,
        simon.horman@corigine.com
Subject: [PATCH net-next v1] flow_offload: fix suspicious RCU usage when offloading tc action
Date:   Wed, 22 Dec 2021 12:25:46 +0800
Message-Id: <1640147146-4294-1-git-send-email-baowen.zheng@corigine.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0054.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::18) To DM5PR1301MB2172.namprd13.prod.outlook.com
 (2603:10b6:4:2d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a71d6b4a-e336-4d5d-b3b8-08d9c50326d7
X-MS-TrafficTypeDiagnostic: BN6PR1301MB2050:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1301MB2050625F923A45F2C7FA9FBFE77D9@BN6PR1301MB2050.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:337;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqYzKgo3jiRK1ZerfJizIXSbWKZniM3wnvv+2BQKVgq7g2T+Uj1SUtKSet2tX9AwwXL2e5iyrCR/OtjT9+JUp1NEt227HTcYI6E8t45vikuiJ3Mh7Bmia+kHVRrznOGe9a7xzZ9VDFrWikv0AAoWDWlL20v2+NBqcyOK8n09zuLp2pAtjuLiGxi9cgZJ5G2p0zu6FLKZfBybbZojWelKINveiGsKKQT9u6cWRCZaGlVVRx6Ei1QsTeO+MxFNKk1/OVmaY5/pFXEzMmW+hGL+FbzXQB27bPxSIRxUylAX8qpPtfRA6LWTOSmye265QrYNK4M/18nzOQZ6QvxqZO4vheyDmOll6Htyl5UpY9g7ibLqKI6FNzUTe8uHegt/868gzYWWQ5lUPHCnXD6OG9t2+YJM3VLkW6PiH3n6TojOR1mEtTzfUnjtBNO75GjGsAqGJH7eVJuAWSKbU4l63bkPOjWFMOE5yY4TAaZs0RMMX5kTJ779xLtfWd5VcJxDp934tFYmCKqMnu1sQO5q/P/sblRhAYEdr3rnSpUaio0Ai/8Z3gIVO4laddn6S4Hb/RC1Rvx/ZYFgPoycgfB3VOWcWkYetF4r7xfsbZKujdY2KAQ25KlBTa2aXaq8Esnjl1x+JecSELBKpD5ATqnHzugvvV6ANlx7nn6iO4D0idEWWex0AZm05OPoLDbcrPJK3ICC3z2f29wVlAYVk3aWLy4QAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(396003)(346002)(376002)(39830400003)(5660300002)(316002)(8676002)(8936002)(66556008)(4326008)(66476007)(2906002)(44832011)(66946007)(86362001)(36756003)(38100700002)(6666004)(38350700002)(508600001)(6512007)(6506007)(6486002)(52116002)(83380400001)(2616005)(107886003)(186003)(26005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C7sMt52QDxm4VXE5TdOxvGSoHcg9eq7bwivqh21aUfXcs3fWzGNK9d4uwXYq?=
 =?us-ascii?Q?T5+0W2q3fbpwAqvp5P9Vzm8bS39inE8YvgAOcP1AkRWtSbnRhyQK1TQ1D7P6?=
 =?us-ascii?Q?oyQZTUehcMxZmRKdqE7R5XPGH/Yxz03qlKmVYrU/nU6TERioULCvQiS5i6Sx?=
 =?us-ascii?Q?XlIWpPVVWhXNJyxuOuE3y1NeAF12K6ipJd2Xe4V2eR0/9QKsUOCoJ+cBgwOa?=
 =?us-ascii?Q?Til+CNAJbHyCSICQagFpY7gzeT+KrqVjNPxs3S6/XMAieutZF8w2hKuJKZoX?=
 =?us-ascii?Q?fpC5A83u4P8j1W/H4gCAm3tv/252FL2lYPf696WneDPrK4vf2a/O+L9r+hcE?=
 =?us-ascii?Q?bN44ZuDHRW+02nWb3DCWZx7le5PjiN8lOuK0MHkfiWAN82iCjsAFgPKQQNd8?=
 =?us-ascii?Q?HF2D0lgeAf4n6yB9ueT3lDLbonc8g2XTGu5dsI8AS96p3UtW1/pumHgrnQJQ?=
 =?us-ascii?Q?1aMh/cbirW4BQMsy3pY8lvuTKGWWnBRFQ2lcIm4p5gfIywz2GauPIacVxh3I?=
 =?us-ascii?Q?BxyYvBZD34AFjjFJRwtMlYXe9GAXVMcBb8KkEjLRfW2l533mZTUTk/UXZrZS?=
 =?us-ascii?Q?XEfTIsICZUECO6zGe/+BI6YKutcnUOikzww9lUZ25YQKhZhbWfO53Q2y+7Le?=
 =?us-ascii?Q?TngbNhCJnBP4piI+cMduu8e24qLGOV0oe2KoKDDJyNes/1AL4MF7/6zWYYji?=
 =?us-ascii?Q?vsDA5BdFolxsHnULk41AYouTUSjte4UAWh7bjWcvThvYjGVbsr6lkd9d9kLZ?=
 =?us-ascii?Q?Fu7RWwq79vIV6hokxkDRMJRsvxAPabnLCt5J7FEclqunL6PWs2a7FpJrrYl4?=
 =?us-ascii?Q?wFyq6YdJaazXmpXRFvl064HWZJubU7FHgyj85ox6QEy41Qf7TWUzJvV0+9pr?=
 =?us-ascii?Q?+J+IuUim7uwRcCIGztKOtH2ORTJQ8vS6FS5k0lnHoKBnMleQWp0GfjMo2lxP?=
 =?us-ascii?Q?TbF+vJH1FCmcqwEY7BJsbg1SeOH7UH4MUJl8U/9VAgElOV2ZaUcn8WEhzaUS?=
 =?us-ascii?Q?giIaEKXQj8cNzSCQBkCzBO+tKX0xxYM0S+BKes7aWCHrNtbwqnIGnrRiLzTU?=
 =?us-ascii?Q?gSvPGGWpuwomF45U7BHCUPABNp0WQsmnbA4R1MRodR8MEuwpo3AtttanIeCw?=
 =?us-ascii?Q?Z6UiFjIVit6M0gdDiiaiU/oa/D/+QOSfXhOfyWBLNhKRsuKsKgjP5AG/a3/w?=
 =?us-ascii?Q?9KV0ZLJkhHrpAK2cQCF2iOGVNmU4HRm7R/cwG4Ud3kQdKDix5U2f7eBMZ1Qa?=
 =?us-ascii?Q?qHF68/wo6aJId/8TozOliqVI7ODEQXlQn01F8mUzIQDThQY08arprhpqN8Aq?=
 =?us-ascii?Q?uQ/u3rGz0JzOdouyqssx+nESTTK+slj3rYTC6E1WWeJ55M9/IUE9WRWcGBJm?=
 =?us-ascii?Q?7CZC7QdZ5JsyEhiFv14u8BVnpwuJzTG1GdTYPZZ1qaTVMpy8al9L+p5MsgwO?=
 =?us-ascii?Q?t9P4b85VJnIn1mLDfciW5+A5uBIcEOczkGtTM+Aq5csQNFBCy6BFMt33WrF6?=
 =?us-ascii?Q?RxvRhHHZ+pB8FDy3+IzU63gqQnf3wap9PwGKRtKpm4MTr4Dv619sc+MG7HrO?=
 =?us-ascii?Q?YB0a8A0M21UI1pVgSEEsAI+cUIkFyGS0X4gkeeqZtEpMa3hdqPflA3MlGAOg?=
 =?us-ascii?Q?DJYxQgwj4Da0/EasAV/C3Sqpqh2WPud1XXX31q7hXS0yeIPbzagNOYIKL41C?=
 =?us-ascii?Q?BrX1lKyVoiLLT7TdOWP2cxPKy9E=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71d6b4a-e336-4d5d-b3b8-08d9c50326d7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 04:25:58.0648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogLbKKA74mu526Vxl3F9Jz3LzLIAUk8neq0dzJd7iGv/24p7BP33yClJoPscmHYoYaPv9EjpOT96ulWJNgq4uQ3j2u1EFYLfUaL9D/badzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1301MB2050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix suspicious rcu_dereference_protected() usage when offloading tc action.

We should hold tcfa_lock to offload tc action in action initiation.

Without these changes, the following warning will be observed:

WARNING: suspicious RCU usage
5.16.0-rc5-net-next-01504-g7d1f236dcffa-dirty #50 Tainted: G          I
-----------------------------
include/net/tc_act/tc_tunnel_key.h:33 suspicious rcu_dereference_protected() usage!
1 lock held by tc/12108:
CPU: 4 PID: 12108 Comm: tc Tainted: G
Hardware name: Dell Inc. PowerEdge R740/07WCGN, BIOS 1.6.11 11/20/2018
Call Trace:
<TASK>
dump_stack_lvl+0x49/0x5e
dump_stack+0x10/0x12
lockdep_rcu_suspicious+0xed/0xf8
tcf_tunnel_key_offload_act_setup+0x1de/0x300 [act_tunnel_key]
tcf_action_offload_add_ex+0xc0/0x1f0
tcf_action_init+0x26a/0x2f0
tcf_action_add+0xa9/0x1f0
tc_ctl_action+0xfb/0x170
rtnetlink_rcv_msg+0x169/0x510
? sched_clock+0x9/0x10
? rtnl_newlink+0x70/0x70
netlink_rcv_skb+0x55/0x100
rtnetlink_rcv+0x15/0x20
netlink_unicast+0x1a8/0x270
netlink_sendmsg+0x245/0x490
sock_sendmsg+0x65/0x70
____sys_sendmsg+0x219/0x260
? __import_iovec+0x2c/0x150
___sys_sendmsg+0xb7/0x100
? __lock_acquire+0x3d5/0x1f40
? __this_cpu_preempt_check+0x13/0x20
? lock_is_held_type+0xe4/0x140
? sched_clock+0x9/0x10
? ktime_get_coarse_real_ts64+0xbe/0xd0
? __this_cpu_preempt_check+0x13/0x20
? lockdep_hardirqs_on+0x7e/0x100
? ktime_get_coarse_real_ts64+0xbe/0xd0
? trace_hardirqs_on+0x2a/0xf0
__sys_sendmsg+0x5a/0xa0
? syscall_trace_enter.constprop.0+0x1dd/0x220
__x64_sys_sendmsg+0x1f/0x30
do_syscall_64+0x3b/0x90
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4db7bb7a60

Fixes: 8cbfe939abe9 ("flow_offload: allow user to offload tc action to net device")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 net/sched/act_api.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b2f8a39..32563ce 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -186,12 +186,19 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 			       enum offload_act_command  cmd,
 			       struct netlink_ext_ack *extack)
 {
+	int err;
+
 	fl_action->extack = extack;
 	fl_action->command = cmd;
 	fl_action->index = act->tcfa_index;
 
-	if (act->ops->offload_act_setup)
-		return act->ops->offload_act_setup(act, fl_action, NULL, false);
+	if (act->ops->offload_act_setup) {
+		spin_lock_bh(&act->tcfa_lock);
+		err = act->ops->offload_act_setup(act, fl_action, NULL,
+						  false);
+		spin_unlock_bh(&act->tcfa_lock);
+		return err;
+	}
 
 	return -EOPNOTSUPP;
 }
-- 
1.8.3.1

