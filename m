Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B792B23063E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgG1JLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:47 -0400
Received: from mail-eopbgr10059.outbound.protection.outlook.com ([40.107.1.59]:13383
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728346AbgG1JLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkLMbnR4Knke4fL7Xy3GUJ+sj6CX1x6hUWffTb85iJDH5enN0Zxj6KwEVe/xS3CKLeAUoD3KJ55+2Ox8r8MWm4Fm52V1kY3+X1y82ZEQNyrA3UjXfTy4HT5yVdd8ZoOASeikqdeNWoUtFl4eOWA2OoBI/hKasK3WgESS3ptYwpSPRIqmySVVJQJl0nrdacIux1GeTSOgSgsN46KEnHKAmP/1e4TSFy+YgC7iIUsTIte4phh89oDFiGf4WThzlwyUJq3YSifFnk8uLglDM47VrBZVzs5pKRvxuPiHnTJ7ZPP2mOhgrq24KbL+qRO7e/U0DPExPgKUNwwR/S2/P6X81g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB6A7BOwlbghfua3HcZpWWj9Vo6t8AgAXCfLrMfdU6M=;
 b=kuvWQV4l4dWZrK6vvo7K4WZqfHFXSEVMMWG1JfMPR55N0duUR+zEYBgSv5a/uFNXzcLQiN9toXlFFVGY+8/IVMTCGDzGU30KXssOqjvov9L4ntGTexw/JNTaqA3CcWPN04uZEMXI524BvX+ILr+EFZfpuzyPpYRjYmsdcx6wssCJOz0CCMAswFCGDbT+WsB5FfS34R6WZJTJvydDiD8E0PJXmH4brM+KHwDJxRc1oe8tyMqPillDosW874D0brO+edW6orHNh1we3gy2zb9eO0qwL9dyqTu/8jNU6qzl5Y9stHzRhqAAYqK6AW0tlBoxMoS6v79TZ0yfTvV7GEk6Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB6A7BOwlbghfua3HcZpWWj9Vo6t8AgAXCfLrMfdU6M=;
 b=mm9uU1SfiS40dJPEmxBEc/IzXyfyWctFiaXPgaxD/BAuEKlhx8UPMBhLqWWpmUFa1L3CiJwo02IENWaX24E1iliKXyXvnaQH6DT0bNvJafwUXZzQZU9fUwx5mCUFQGzPElgr+b50BR1RxA+W18ySxngOQg562oVpNG+yuAhJmyM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 12/12] net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev
Date:   Tue, 28 Jul 2020 02:10:35 -0700
Message-Id: <20200728091035.112067-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:38 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56c6d048-5ffc-4e07-c926-08d832d63d02
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4638B483929A8BC2985A1265BE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VoE4HfVD/UU8PhlUXSRN+/gPOQwdVxFTNJ+wXSo3Nh9cDP6Nx+nKXwIJOZftHImNumndRCMEFWm3enzOnFxucMkYXCm+8DEQi953APRP5Hp62zIdXBSA8+nu38G0Y4C/2hK/e1EwxxWgyp2S93oGBGPSRx+KYzMtfPZ4XADl35xxbbtchN9UitO6TIMLBFRxNxnz+2OEUAjMT3ekJLFbO0/OJH1jNZw8S0bJlsn2Ychr5EyAUZZjvZ+DHfcZVCg+fgj7/n2dsQiowSbeX7iYh9K81JYNta1uLG22bBe3dOKST+893XsioPuq3ZG+DjRemjngoBs8menhQoqq9BzEW2mjYeG+ycAguZpt2SJ8dZcageL0FIAAHRhzbekn7z37
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4yeNpNbp9HoURg0t1VfhQ5UH2T0jO8QCJtrpQbmfFlgY9qspeyiZX4Akwr8wpF2HgghQz4GwL+sPwYDRIUn7fUw1yQK9MYdlknx7bFkfMW6EqYgHqP2ZHDquJYwPrOxA7BfAL3FxHGGF+TkUwouY74CSB8FehM1SQqyyLdJ5h/UiDl8A991KfLJ9Bal8ONQjCw+0HqtMVHPbjKrlBM7bLNof0F2tLq3Eg/+w+f1niEVgnj9nMaUoZMdN5cq1gjkh09MEmDwiJllSxOluJnWuQYAgmiEe7TphHmfoDVRi6KMb54U92ertJ/W0qwDLrhIIfhpKwKGAT/yBQlImLsy5U9AeRSwDN5ZotdLcrQbBPoC/FeUi3oXUEFjbUvTC1jrieven0Yx9SLse76bVjzUf5goKNngUTLK3NLRfAH3YrwuFERJf3thEttP2U6xPoGmnAK11H7pKXUF1O/7eZBf798iKDhWZWKbOpqrkg8G8hWc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c6d048-5ffc-4e07-c926-08d832d63d02
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:40.8189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBKXYnfvLPpSuQ6Xtl7KtIeRA34oa2IGstKhCGMtSw1SDYnZJkUfcVIo5pZagdidrd8SVja+dAh1tM8ASKb1mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
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

