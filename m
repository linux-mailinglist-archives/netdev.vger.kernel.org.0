Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444A5231364
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgG1UA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:57 -0400
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:1413
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729300AbgG1UA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAhKcylsJCsfHdfDF49bPCNliInZsOgGme+MLIgn64jclxfICb/GcUbVDDLOm+SQ+62/ZPpUrnL/EZTqBV3o62IA9+9Lls7uGFHRjqv0qcDDCBXpj7E/lWjCQxvQU1P/n2JtIj0KVsxRmkSYe5AAa6np/VgRsNJblq8DecB/LDx0di3yYkK257Ql4FG2LXpI/wNjwFL/vPWSh8KKH+Y8pvFQl53bvODWi/XKEiGHIJdPCgnNSDJahXGWCqA3gG8x6eSAmrANu1JCaeXQA5OcbveSuAd/BnHYi3TNrYUVsLI5DQViAAq3LhinNLRxRlWepkqnkE0LnR9kQnlhJqgTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB6A7BOwlbghfua3HcZpWWj9Vo6t8AgAXCfLrMfdU6M=;
 b=byKSsi9SWf7X0DAeDaSk1VrUMSQlsPzhrVvz4ceHKbXBskB4bC4O1JomNAIXbUuaeB66MAwk3waNB1mMtGtEVBqw754SRrRZQlM4s4v4NN+iYN5wtK7ds4oeFIVDqym2MR0eHjLrZ3bjED/cUQFPzkrLbnH3Ma/Yv5DvNUioYJJLp4YPU3NrhoR9SdH7KAv/bMHMzNq6C8swRAvAGvopQ4huquGFvGCloUIwrMb5EXZVAqissTA8cGHCQCPEAQQLRi13CIdjMQb7DW9DDlrxlZd98LJXh8kR+I1Qk9+VXQ7RPniw9N8PtTandvxb9TC2kJecwPPek/6fE5OhFq8r/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB6A7BOwlbghfua3HcZpWWj9Vo6t8AgAXCfLrMfdU6M=;
 b=ho2OAxt8XvWk2Oh9XT9gbVZeSwVBFPScUIprl8HdCjrasl+eNWkv9XXdZWmN7lRO1q5gD5nVlXEzxJBCyOyd7CFxYNwMKBqXlavQMbwT7c1KByth51I6SbJ4K15qaMgwZCCx/xylc9PGV/ukymW3jn+veBfq46KFr5hrPfncLbw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 11/11] net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev
Date:   Tue, 28 Jul 2020 12:59:35 -0700
Message-Id: <20200728195935.155604-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:48 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84305557-ad00-42d7-76f0-08d83330ed38
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB259221BD539CB33B3459D574BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzDZPycnfHxeJB33Vvrb8buRuxLuQMU3fyBBfTUIgcCjmi1aVD5xHggaa3wOK/nvXTFyRPiELYpu7Nc6LHcRnnycVODSaZF87pEtkum4ZqWFAOc18gOvotAnctzcGZauBCVPMMJfRMQNYXBmKtk6M8wcte6mCjZack61MPxutRk/gGWg4XlNJs5Hd4E+IwAWHPdSIyxT5rSi8KoSh8PydXu+8ScSByJbQ/9sV6ShFDFpNK2Ov+BD4Q3b/f/ley5/ICu2BJv3iAA0Ey0SopNWm9NZAkMpIB3r0IybiOMBljfj8zPwWFP6J1MA+Y9Hwk82salPJibgR77nFtOM/S3zA4gwZo8FLIx0HvBKNSYeraprTjOttmC/6xv5kUYqKWT9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TMz2UrfqWnmkYimyx9bhyLwFcoOtHcmcBXwEdzHvQ0Lb0F81AHzGUznGsOeZcSgrF4GwCLwWCCpEnAHVapmfeyzjtuhyBpdIPQljzABO1Qn1jOkPBALc+iqSdjFFwEEVRdhybefgLr6PvzlomorVFhZN04TruY2uQRiLYaNrKGqUd2uCzCrx7Hu7/b5LGbH4WT6EmXum/KFVq6op1AN8KbdzfH+r7wXuxTP29qqtzYU/bOkRx8sCGmxOl3hHk6t1qSm1P+IUyrMitqc2YXYInBQq6D54x4N3Bxw0WXOHt8c63RbO2SlJ1O8JGwcsNiTBSOn4tI5Vfdvky4v0c1RaeCiZCljfoasgRBUpAU0ewn6fvTAWxYEoVKtBsaApZH5+P/HELXaLo1wHxhv1XfQ15UKSzF+k/y5xSTea4wBZi3XdVV9wXuYkjwXVhs02WFNUARIUR6RZoOt4OdMW1SGxa8TicRGnQG56idg7CevoK28=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84305557-ad00-42d7-76f0-08d83330ed38
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:51.6170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6X6FSwyWObGKxvjtuyGk/bl7BlVGuxpYQS+ey+w2iZo8E/RAQJE/wmZKCUgi+ojGiGCK0y7IUbxacrpDzjh+5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

After the cited commit, function 'mlx5_eswitch_set_vport_vlan' started
to acquire esw->state_lock.
However, esw is not defined for VF devices, hence attempting to set vf
VLANID on a VF dev will cause a kernel panic.

Fix it by moving up the (redundant) esw validation from function
'__mlx5_eswitch_set_vport_vlan' since the rest of the callers now have
and use a valid esw.

For example with vf device eth4:
 # ip link set dev eth4 vf 0 vlan 0

Trace of the panic:
 [  411.409842] BUG: unable to handle page fault for address: 00000000000011b8
 [  411.449745] #PF: supervisor read access in kernel mode
 [  411.452348] #PF: error_code(0x0000) - not-present page
 [  411.454938] PGD 80000004189c9067 P4D 80000004189c9067 PUD 41899a067 PMD 0
 [  411.458382] Oops: 0000 [#1] SMP PTI
 [  411.460268] CPU: 4 PID: 5711 Comm: ip Not tainted 5.8.0-rc4_for_upstream_min_debug_2020_07_08_22_04 #1
 [  411.462447] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 [  411.464158] RIP: 0010:__mutex_lock+0x4e/0x940
 [  411.464928] Code: fd 41 54 49 89 f4 41 52 53 89 d3 48 83 ec 70 44 8b 1d ee 03 b0 01 65 48 8b 04 25 28 00 00 00 48 89 45 c8 31 c0 45 85 db 75 0a <48> 3b 7f 60 0f 85 7e 05 00 00 49 8d 45 68 41 56 41 b8 01 00 00 00
 [  411.467678] RSP: 0018:ffff88841fcd74b0 EFLAGS: 00010246
 [  411.468562] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 [  411.469715] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000001158
 [  411.470812] RBP: ffff88841fcd7550 R08: ffffffffa00fa1ce R09: 0000000000000000
 [  411.471835] R10: ffff88841fcd7570 R11: 0000000000000000 R12: 0000000000000002
 [  411.472862] R13: 0000000000001158 R14: ffffffffa00fa1ce R15: 0000000000000000
 [  411.474004] FS:  00007faee7ca6b80(0000) GS:ffff88846fc00000(0000) knlGS:0000000000000000
 [  411.475237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  411.476129] CR2: 00000000000011b8 CR3: 000000041909c006 CR4: 0000000000360ea0
 [  411.477260] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [  411.478340] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [  411.479332] Call Trace:
 [  411.479760]  ? __nla_validate_parse.part.6+0x57/0x8f0
 [  411.482825]  ? mlx5_eswitch_set_vport_vlan+0x3e/0xa0 [mlx5_core]
 [  411.483804]  mlx5_eswitch_set_vport_vlan+0x3e/0xa0 [mlx5_core]
 [  411.484733]  mlx5e_set_vf_vlan+0x41/0x50 [mlx5_core]
 [  411.485545]  do_setlink+0x613/0x1000
 [  411.486165]  __rtnl_newlink+0x53d/0x8c0
 [  411.486791]  ? mark_held_locks+0x49/0x70
 [  411.487429]  ? __lock_acquire+0x8fe/0x1eb0
 [  411.488085]  ? rcu_read_lock_sched_held+0x52/0x60
 [  411.488998]  ? kmem_cache_alloc_trace+0x16d/0x2d0
 [  411.489759]  rtnl_newlink+0x47/0x70
 [  411.490357]  rtnetlink_rcv_msg+0x24e/0x450
 [  411.490978]  ? netlink_deliver_tap+0x92/0x3d0
 [  411.491631]  ? validate_linkmsg+0x330/0x330
 [  411.492262]  netlink_rcv_skb+0x47/0x110
 [  411.492852]  netlink_unicast+0x1ac/0x270
 [  411.493551]  netlink_sendmsg+0x336/0x450
 [  411.494209]  sock_sendmsg+0x30/0x40
 [  411.494779]  ____sys_sendmsg+0x1dd/0x1f0
 [  411.495378]  ? copy_msghdr_from_user+0x5c/0x90
 [  411.496082]  ___sys_sendmsg+0x87/0xd0
 [  411.496683]  ? lock_acquire+0xb9/0x3a0
 [  411.497322]  ? lru_cache_add+0x5/0x170
 [  411.497944]  ? find_held_lock+0x2d/0x90
 [  411.498568]  ? handle_mm_fault+0xe46/0x18c0
 [  411.499205]  ? __sys_sendmsg+0x51/0x90
 [  411.499784]  __sys_sendmsg+0x51/0x90
 [  411.500341]  do_syscall_64+0x59/0x2e0
 [  411.500938]  ? asm_exc_page_fault+0x8/0x30
 [  411.501609]  ? rcu_read_lock_sched_held+0x52/0x60
 [  411.502350]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [  411.503093] RIP: 0033:0x7faee73b85a7
 [  411.503654] Code: Bad RIP value.

Fixes: 0e18134f4f9f ("net/mlx5e: Eswitch, use state_lock to synchronize vlan change")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 71d01143c4556..43005caff09e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1887,8 +1887,6 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
-		return -EPERM;
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
 	if (vlan > 4095 || qos > 7)
@@ -1916,6 +1914,9 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	u8 set_flags = 0;
 	int err;
 
+	if (!ESW_ALLOWED(esw))
+		return -EPERM;
+
 	if (vlan || qos)
 		set_flags = SET_VLAN_STRIP | SET_VLAN_INSERT;
 
-- 
2.26.2

