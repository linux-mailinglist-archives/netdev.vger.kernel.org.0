Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2573154D9B
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBFU5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:57:44 -0500
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:22890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727843AbgBFU5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 15:57:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Om0DlsTRHLvzSCYUmEB2ODGya8Xep9yQHgiWD4rywAH+NCMiDPbT2MPFMson2Z+1tzrmqa8kr5WU8pbY3wYyeiSgH2CWOD4eACDRduFyHuQ8IM/EEZqfC9DqD1F8Zk/DafLZ3b/OIRa7hBCaBU7ww66qhjpjY3JiUW8Jv5Xpf4oqCRl/v1KsH6+Qbzu2IVz34dUN6qNJXcO3ndO1SYygidSAk6OG+4I0EIZuVCUxtEbzkbRZxtQtHPaH1J6UE6nqZgwxlXcAttoyQzelZJXh8/aPTdOWumZEyx6ZJqs9GJT4NcTMQVfOlIXUUdQDjdEDAUy8JIp+Nto/nkP48kny+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pt4OTgyZoqwbPYBlv/HKI64IwXtnsHuGRB3zbyhO5nU=;
 b=VtypZk2j1fltIQO5EdxbRjcA61/5oaek7+VFqdJVYh/CWB7Fkpnlk8nUsMRoeMQWwi/AUqUd9iIsahQtRpg77FKqcAIuYVCPEUxNORC+jmMdz9GhKYIYUndmAsNa39+SyWyWFTte+v7uxUcGgq3juZw7AAYO0GsNHkXyL4hszI7xkj69AWuVAhtXpzrwPXh0NN17OFsSg1SskK3DZcke3FXvsiPOTklOAot8yQTn8p7az6egNN0KOqSTjmwooF126OedZOqhyw7Ck4b1EwcYYNkNuU82+/3fiGsaXghSVi8oI1yaN73D6d2Gc+CrFPOAU5h/qRkwUoraRf0DdatgRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pt4OTgyZoqwbPYBlv/HKI64IwXtnsHuGRB3zbyhO5nU=;
 b=Hg9u/mMwexWW6CqifB9FrfrwXLHdoD/yyqUnrT7Eg1ntP0uk5g5WxHdZh92PCweydA3lltJJyWK5fQntq25kLHvWSGk2NMQsGhH4z+XoqQy3cEDBorebrqD7Aqj0mkhpcSLfecAGYgVATIeD/oXdBLls5s8QyJWcwmDIJYo7AWk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3280.eurprd05.prod.outlook.com (10.175.243.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 20:57:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.024; Thu, 6 Feb 2020
 20:57:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Alaa Hleihel <alaa@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/5] net/mlx5: Fix deadlock in fs_core
Date:   Thu,  6 Feb 2020 12:57:06 -0800
Message-Id: <20200206205710.26861-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206205710.26861-1-saeedm@mellanox.com>
References: <20200206205710.26861-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BY5PR20CA0005.namprd20.prod.outlook.com (2603:10b6:a03:1f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 20:57:38 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: afaef28d-0ed4-45c3-e263-08d7ab4733bc
X-MS-TrafficTypeDiagnostic: VI1PR05MB3280:|VI1PR05MB3280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32801EDA42BFC37298A82E2BBE1D0@VI1PR05MB3280.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(4326008)(6512007)(107886003)(26005)(5660300002)(16526019)(186003)(6506007)(8676002)(81156014)(6916009)(81166006)(8936002)(2906002)(478600001)(36756003)(52116002)(6486002)(316002)(54906003)(1076003)(6666004)(956004)(66476007)(2616005)(66556008)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3280;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVQRxns8vukCUsuRiyKOXz5hDi+KvwgeZ56LOxhKRayTUTD9a7/pqpat9aEVdmr34Fd2zt2+gCCuAMVcHq5P4SGffdjRWkswUc+7KoRfLfVFFSN1zWvXxzrLD3yav5sSlLYB68GqiTpF8MehIO6adD1EDMyu6CGHiTPEuEaVRVJ5/rD54c2KLRxG9t/Olz2CEdfMXt8Rl+4hTv8qhLc6P9LM61P19xkbazoPNgcxkp4jthCAbOhqMuHgiivmRlKX34d1qtDDSOGngJgZRkd9/vnkqL2pOTXmXCs7G0h+svkaGDormnOK6e+j3S34OIu3WnExo32CwyLDu9JA+x6PF3/lBeUp2/EtCB+DEwlE1sVsXL3mDc8AzB1VaZ6Vhfv9zMG2Jw/gzPk2G1P9Ajk07ALCD8LMOZW3cDmcM+coTU6JBYmnlf/ADmZUqqL172MX1rUuqEekebPFVVaTFARb8PdJJej3FKoNgYcDiC4QrJKaVE4BkrjFF6BpEg1UN0X0g4Zp1x6mF9bZmfy8DZyNiTrX6Eh7alke7VMAoOkgLMs=
X-MS-Exchange-AntiSpam-MessageData: uTYKRuwGn8c92E53oT4GUpeZIZBSKJSXsKt2hMXXZcSr2u42sxAK768LUs6r8HeUswDtmfO2RnwBSzBwl6kJNKxNLTmVfN7XI4pgRMAJOgcK2RLlw2aaNaH1Wjg5YSJL0c5WBr1C2o3/NQaxouW74w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afaef28d-0ed4-45c3-e263-08d7ab4733bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 20:57:39.6878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaJ7jWoNEcLH1l68UG/+HdKmhDJ57cO4CX+bqTxO7WUZLOMsNKrGl6GNxI7oYgAA202INlIUIxJpHVjkES3a6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

free_match_list could be called when the flow table is already
locked. We need to pass this notation to tree_put_node.

It fixes the following lockdep warnning:

[ 1797.268537] ============================================
[ 1797.276837] WARNING: possible recursive locking detected
[ 1797.285101] 5.5.0-rc5+ #10 Not tainted
[ 1797.291641] --------------------------------------------
[ 1797.299917] handler10/9296 is trying to acquire lock:
[ 1797.307885] ffff889ad399a0a0 (&node->lock){++++}, at:
tree_put_node+0x1d5/0x210 [mlx5_core]
[ 1797.319694]
[ 1797.319694] but task is already holding lock:
[ 1797.330904] ffff889ad399a0a0 (&node->lock){++++}, at:
nested_down_write_ref_node.part.33+0x1a/0x60 [mlx5_core]
[ 1797.344707]
[ 1797.344707] other info that might help us debug this:
[ 1797.356952]  Possible unsafe locking scenario:
[ 1797.356952]
[ 1797.368333]        CPU0
[ 1797.373357]        ----
[ 1797.378364]   lock(&node->lock);
[ 1797.384222]   lock(&node->lock);
[ 1797.390031]
[ 1797.390031]  *** DEADLOCK ***
[ 1797.390031]
[ 1797.403003]  May be due to missing lock nesting notation
[ 1797.403003]
[ 1797.414691] 3 locks held by handler10/9296:
[ 1797.421465]  #0: ffff889cf2c5a110 (&block->cb_lock){++++}, at:
tc_setup_cb_add+0x70/0x250
[ 1797.432810]  #1: ffff88a030081490 (&comp->sem){++++}, at:
mlx5_devcom_get_peer_data+0x4c/0xb0 [mlx5_core]
[ 1797.445829]  #2: ffff889ad399a0a0 (&node->lock){++++}, at:
nested_down_write_ref_node.part.33+0x1a/0x60 [mlx5_core]
[ 1797.459913]
[ 1797.459913] stack backtrace:
[ 1797.469436] CPU: 1 PID: 9296 Comm: handler10 Kdump: loaded Not
tainted 5.5.0-rc5+ #10
[ 1797.480643] Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS
2.4.3 01/17/2017
[ 1797.491480] Call Trace:
[ 1797.496701]  dump_stack+0x96/0xe0
[ 1797.502864]  __lock_acquire.cold.63+0xf8/0x212
[ 1797.510301]  ? lockdep_hardirqs_on+0x250/0x250
[ 1797.517701]  ? mark_held_locks+0x55/0xa0
[ 1797.524547]  ? quarantine_put+0xb7/0x160
[ 1797.531422]  ? lockdep_hardirqs_on+0x17d/0x250
[ 1797.538913]  lock_acquire+0xd6/0x1f0
[ 1797.545529]  ? tree_put_node+0x1d5/0x210 [mlx5_core]
[ 1797.553701]  down_write+0x94/0x140
[ 1797.560206]  ? tree_put_node+0x1d5/0x210 [mlx5_core]
[ 1797.568464]  ? down_write_killable_nested+0x170/0x170
[ 1797.576925]  ? del_hw_flow_group+0xde/0x1f0 [mlx5_core]
[ 1797.585629]  tree_put_node+0x1d5/0x210 [mlx5_core]
[ 1797.593891]  ? free_match_list.part.25+0x147/0x170 [mlx5_core]
[ 1797.603389]  free_match_list.part.25+0xe0/0x170 [mlx5_core]
[ 1797.612654]  _mlx5_add_flow_rules+0x17e2/0x20b0 [mlx5_core]
[ 1797.621838]  ? lock_acquire+0xd6/0x1f0
[ 1797.629028]  ? esw_get_prio_table+0xb0/0x3e0 [mlx5_core]
[ 1797.637981]  ? alloc_insert_flow_group+0x420/0x420 [mlx5_core]
[ 1797.647459]  ? try_to_wake_up+0x4c7/0xc70
[ 1797.654881]  ? lock_downgrade+0x350/0x350
[ 1797.662271]  ? __mutex_unlock_slowpath+0xb1/0x3f0
[ 1797.670396]  ? find_held_lock+0xac/0xd0
[ 1797.677540]  ? mlx5_add_flow_rules+0xdc/0x360 [mlx5_core]
[ 1797.686467]  mlx5_add_flow_rules+0xdc/0x360 [mlx5_core]
[ 1797.695134]  ? _mlx5_add_flow_rules+0x20b0/0x20b0 [mlx5_core]
[ 1797.704270]  ? irq_exit+0xa5/0x170
[ 1797.710764]  ? retint_kernel+0x10/0x10
[ 1797.717698]  ? mlx5_eswitch_set_rule_source_port.isra.9+0x122/0x230
[mlx5_core]
[ 1797.728708]  mlx5_eswitch_add_offloaded_rule+0x465/0x6d0 [mlx5_core]
[ 1797.738713]  ? mlx5_eswitch_get_prio_range+0x30/0x30 [mlx5_core]
[ 1797.748384]  ? mlx5_fc_stats_work+0x670/0x670 [mlx5_core]
[ 1797.757400]  mlx5e_tc_offload_fdb_rules.isra.27+0x24/0x90 [mlx5_core]
[ 1797.767665]  mlx5e_tc_add_fdb_flow+0xaf8/0xd40 [mlx5_core]
[ 1797.776886]  ? mlx5e_encap_put+0xd0/0xd0 [mlx5_core]
[ 1797.785562]  ? mlx5e_alloc_flow.isra.43+0x18c/0x1c0 [mlx5_core]
[ 1797.795353]  __mlx5e_add_fdb_flow+0x2e2/0x440 [mlx5_core]
[ 1797.804558]  ? mlx5e_tc_update_neigh_used_value+0x8c0/0x8c0
[mlx5_core]
[ 1797.815093]  ? wait_for_completion+0x260/0x260
[ 1797.823272]  mlx5e_configure_flower+0xe94/0x1620 [mlx5_core]
[ 1797.832792]  ? __mlx5e_add_fdb_flow+0x440/0x440 [mlx5_core]
[ 1797.842096]  ? down_read+0x11a/0x2e0
[ 1797.849090]  ? down_write+0x140/0x140
[ 1797.856142]  ? mlx5e_rep_indr_setup_block_cb+0xc0/0xc0 [mlx5_core]
[ 1797.866027]  tc_setup_cb_add+0x11a/0x250
[ 1797.873339]  fl_hw_replace_filter+0x25e/0x320 [cls_flower]
[ 1797.882385]  ? fl_hw_destroy_filter+0x1c0/0x1c0 [cls_flower]
[ 1797.891607]  fl_change+0x1d54/0x1fb6 [cls_flower]
[ 1797.899772]  ? __rhashtable_insert_fast.constprop.50+0x9f0/0x9f0
[cls_flower]
[ 1797.910728]  ? lock_downgrade+0x350/0x350
[ 1797.918187]  ? __radix_tree_lookup+0xa5/0x130
[ 1797.926046]  ? fl_set_key+0x1590/0x1590 [cls_flower]
[ 1797.934611]  ? __rhashtable_insert_fast.constprop.50+0x9f0/0x9f0
[cls_flower]
[ 1797.945673]  tc_new_tfilter+0xcd1/0x1240
[ 1797.953138]  ? tc_del_tfilter+0xb10/0xb10
[ 1797.960688]  ? avc_has_perm_noaudit+0x92/0x320
[ 1797.968721]  ? avc_has_perm_noaudit+0x1df/0x320
[ 1797.976816]  ? avc_has_extended_perms+0x990/0x990
[ 1797.985090]  ? mark_lock+0xaa/0x9e0
[ 1797.991988]  ? match_held_lock+0x1b/0x240
[ 1797.999457]  ? match_held_lock+0x1b/0x240
[ 1798.006859]  ? find_held_lock+0xac/0xd0
[ 1798.014045]  ? symbol_put_addr+0x40/0x40
[ 1798.021317]  ? rcu_read_lock_sched_held+0xd0/0xd0
[ 1798.029460]  ? tc_del_tfilter+0xb10/0xb10
[ 1798.036810]  rtnetlink_rcv_msg+0x4d5/0x620
[ 1798.044236]  ? rtnl_bridge_getlink+0x460/0x460
[ 1798.052034]  ? lockdep_hardirqs_on+0x250/0x250
[ 1798.059837]  ? match_held_lock+0x1b/0x240
[ 1798.067146]  ? find_held_lock+0xac/0xd0
[ 1798.074246]  netlink_rcv_skb+0xc6/0x1f0
[ 1798.081339]  ? rtnl_bridge_getlink+0x460/0x460
[ 1798.089104]  ? netlink_ack+0x440/0x440
[ 1798.096061]  netlink_unicast+0x2d4/0x3b0
[ 1798.103189]  ? netlink_attachskb+0x3f0/0x3f0
[ 1798.110724]  ? _copy_from_iter_full+0xda/0x370
[ 1798.118415]  netlink_sendmsg+0x3ba/0x6a0
[ 1798.125478]  ? netlink_unicast+0x3b0/0x3b0
[ 1798.132705]  ? netlink_unicast+0x3b0/0x3b0
[ 1798.139880]  sock_sendmsg+0x94/0xa0
[ 1798.146332]  ____sys_sendmsg+0x36c/0x3f0
[ 1798.153251]  ? copy_msghdr_from_user+0x165/0x230
[ 1798.160941]  ? kernel_sendmsg+0x30/0x30
[ 1798.167738]  ___sys_sendmsg+0xeb/0x150
[ 1798.174411]  ? sendmsg_copy_msghdr+0x30/0x30
[ 1798.181649]  ? lock_downgrade+0x350/0x350
[ 1798.188559]  ? rcu_read_lock_sched_held+0xd0/0xd0
[ 1798.196239]  ? __fget+0x21d/0x320
[ 1798.202335]  ? do_dup2+0x2a0/0x2a0
[ 1798.208499]  ? lock_downgrade+0x350/0x350
[ 1798.215366]  ? __fget_light+0xd6/0xf0
[ 1798.221808]  ? syscall_trace_enter+0x369/0x5d0
[ 1798.229112]  __sys_sendmsg+0xd3/0x160
[ 1798.235511]  ? __sys_sendmsg_sock+0x60/0x60
[ 1798.242478]  ? syscall_trace_enter+0x233/0x5d0
[ 1798.249721]  ? syscall_slow_exit_work+0x280/0x280
[ 1798.257211]  ? do_syscall_64+0x1e/0x2e0
[ 1798.263680]  do_syscall_64+0x72/0x2e0
[ 1798.269950]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: bd71b08ec2ee ("net/mlx5: Support multiple updates of steering rules in parallel")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c7a16ae05fa8..9dc24241dc91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1582,16 +1582,16 @@ struct match_list_head {
 	struct match_list first;
 };
 
-static void free_match_list(struct match_list_head *head)
+static void free_match_list(struct match_list_head *head, bool ft_locked)
 {
 	if (!list_empty(&head->list)) {
 		struct match_list *iter, *match_tmp;
 
 		list_del(&head->first.list);
-		tree_put_node(&head->first.g->node, false);
+		tree_put_node(&head->first.g->node, ft_locked);
 		list_for_each_entry_safe(iter, match_tmp, &head->list,
 					 list) {
-			tree_put_node(&iter->g->node, false);
+			tree_put_node(&iter->g->node, ft_locked);
 			list_del(&iter->list);
 			kfree(iter);
 		}
@@ -1600,7 +1600,8 @@ static void free_match_list(struct match_list_head *head)
 
 static int build_match_list(struct match_list_head *match_head,
 			    struct mlx5_flow_table *ft,
-			    const struct mlx5_flow_spec *spec)
+			    const struct mlx5_flow_spec *spec,
+			    bool ft_locked)
 {
 	struct rhlist_head *tmp, *list;
 	struct mlx5_flow_group *g;
@@ -1625,7 +1626,7 @@ static int build_match_list(struct match_list_head *match_head,
 
 		curr_match = kmalloc(sizeof(*curr_match), GFP_ATOMIC);
 		if (!curr_match) {
-			free_match_list(match_head);
+			free_match_list(match_head, ft_locked);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -1805,7 +1806,7 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	version = atomic_read(&ft->node.version);
 
 	/* Collect all fgs which has a matching match_criteria */
-	err = build_match_list(&match_head, ft, spec);
+	err = build_match_list(&match_head, ft, spec, take_write);
 	if (err) {
 		if (take_write)
 			up_write_ref_node(&ft->node, false);
@@ -1819,7 +1820,7 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 
 	rule = try_add_to_existing_fg(ft, &match_head.list, spec, flow_act, dest,
 				      dest_num, version);
-	free_match_list(&match_head);
+	free_match_list(&match_head, take_write);
 	if (!IS_ERR(rule) ||
 	    (PTR_ERR(rule) != -ENOENT && PTR_ERR(rule) != -EAGAIN)) {
 		if (take_write)
-- 
2.24.1

