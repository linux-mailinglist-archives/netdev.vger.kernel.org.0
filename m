Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E388F21AD18
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgGJCbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:05 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726945AbgGJCbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NB6VdEO+6abSBOM27eBouBu5cxut3p+rwm3v2FljgorBKW1neM1SDJzBMbpfHPTJEEl9dml91tkGoZZF0wfaju/I/i25SECJnPpfq6ZdZv0OE529BY7/YF31FAIKBoduA46F5pYQBjZvDu30GB4vi9YA8H9oRlY3U2H2Zl5G1KIUaAVIoYJkyNf+K+vqiMljbKSoeTyPx9o3wg9pjsYWEdGOXKS2xm2w/LndkOofmc445PHbCk4/7lM9TaGB//fZkMO8j7IQS9+lgip/O5QsD96a5XLUrnv90XQxqVXZt+wmK+Vl7tMVF6hjHwI6ZuWvJ8msBMw/K0aQyrA1i2UKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PLNHH4vKpKDJ03yy8uZp+/whE2W1IGyj6TBD0CbM2E=;
 b=S4ma4U/3OfM2eztx4nEcSp5p+FBOaQQyyEAZPj7NttlDMauDg+qKXuAlFKqPz1wsyvWIzB3gHQ/SVI6AzxImzAaW2gsbbZKZpuwOX4WFcoHoQ5xvYIvVlLMJcOf7i3rZ2vQgIqFTVX6mFoo5M+TUQ8fyorCVroQAkisCvAj3gYA2LsGAGBhObWf5RqeENUwIZqtm931g/mPmKAYXjhv21XgJfonk1Wrr3q6E8Be6sSB6GdoMM0nV7JIKsijBegKUWDauKF7G//9ArAO+dZJNb4tuuI7uYoIrJ8OY8y8w7XNNq9EhencBKnuhqgMNJAX2QzFfcWNiEcugCLmeeF/SgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PLNHH4vKpKDJ03yy8uZp+/whE2W1IGyj6TBD0CbM2E=;
 b=ZjwSR9rOy/7tu1NQglGZCQGNPB7MWZZLTkZ/1+5TL2DiiyB2M3MNnaEapOrlIbgqwV9/IZebj6TJG9Qi1pAPh0EqZCuvGCgJxvQ17APwSYviTE83dcWSehh5G0R6PPm3vJ/qwUmgDxzCzQpHkhecOCNY0h/X6iM7xUAvR0fzZG8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:30:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:30:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        David Ahern <dsahern@gmail.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 3/9] net/mxl5e: Verify that rpriv is not NULL
Date:   Thu,  9 Jul 2020 19:30:12 -0700
Message-Id: <20200710023018.31905-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 08d87f7c-7119-4a8d-765d-08d82479455b
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7120EC2CEE65CC8516E933D3BE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4M3QfVb3Eyuh6R9Eb8AD/4HX1Gr9IuMYa18kkhNWaZFFBSpy8u+9Ty9/L6TCcLkwIWud1HamoHwgvgTds4ZATYWqOoTSc4V2cRWv6qSHdYtCBYsiEX/YUyOqTBtz0Xj7Msbgd9+/G5pnFkfnjifGTa4GazZT0CQ2HsSqueqmJrA/yrON8TfaxKq3IyqG50P0OAJ5iy9Orp++9QuaZNtxE+DiQ4Ks8G3uBOgw/ElYneF0ZuafEFJpgz70NuqLu9AR36VbE5GUDg/mxMJpxVSsZX5CaOUGfuxzK9HNER9DtIGa4iURGVnxcViPCnbovb7JxKgpnzM94RVi0WvNwYG3vgWqqzon135rAEMFc7FEuIwtDkMP2z6MOGTZ3z6kPCp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(15650500001)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(45080400002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /8gZOKXvFIo+K05RgE8vFI4U3JJlDTZMrq65P0T/vEIeE9taInsglNB8QNw3Bbx2RnZ1Z3ovlKAbrcQ0wi4x2kXsYhhfg9CFfifjx4Mx1QMibo1E8bCaOIoj2+XQWEjuOnMJkk0qfcs6PxGVwlHznBP/lw3enkU/Xgpppw9DWVNxz80B/DcIqA2Z8899kgC8AzTFPR1yGAjJKtgjrrdjR6efvr8i3Ojh3FMQUYeO+6Xutk6M2iauDu5j7W1HwxP2OpviP6XB8xt5vddfZ/3+r0+wptDbNRv9Y3hL7BVOZ1TDNNrszCzk0HGU+Kggd7zQhEErsniePSGy4QzF/AcV2kTq2pF4fQPszxK1yYAclps20dYP2Ij6ZuWCR6RWLCClVNNh9jcXrJF5av+RyoXKQN/vsdMPQetTz02WTDbfGuMoquwb6W+uo8XwCKlAyHpepAhfwdosddtFWSIUqJsdptCFjh7UuPDxAzDrtj9MpNc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d87f7c-7119-4a8d-765d-08d82479455b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:30:54.7948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrC7VdX0ef8F+YGCrsjfA2le5EYRMwlv4yM+H49TB+Bv3yjL/R48UcBsHQKFJZmxbJzYfEi8/c+Aqt4vIu/hyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In helper function is_flow_rule_duplicate_allowed() verify that rpviv
pointer is not NULL before dereferencing it. This can happen when device is
in NIC mode and leads to following crash:

[90444.046419] BUG: kernel NULL pointer dereference, address: 0000000000000000
[90444.048149] #PF: supervisor read access in kernel mode
[90444.049781] #PF: error_code(0x0000) - not-present page
[90444.051386] PGD 80000003d35a4067 P4D 80000003d35a4067 PUD 3d35a3067 PMD 0
[90444.053051] Oops: 0000 [#1] SMP PTI
[90444.054683] CPU: 16 PID: 31736 Comm: tc Not tainted 5.8.0-rc1+ #1157
[90444.056340] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[90444.058079] RIP: 0010:mlx5e_configure_flower+0x3aa/0x9b0 [mlx5_core]
[90444.059753] Code: 24 50 49 8b 95 08 02 00 00 48 b8 00 08 00 00 04 00 00 00 48 21 c2 48 39 c2 74 0a 41 f6 85 0d 02 00 00 20 74 16 48 8b 44 24 20 <48> 8b 00 66 83 78 20 ff 74 07 4d 89 aa e0 00 00 00 48 83 7d 28 00
[90444.063232] RSP: 0018:ffffabe9c61ff768 EFLAGS: 00010246
[90444.065014] RAX: 0000000000000000 RBX: ffff9b13c4c91e80 RCX: 00000000000093fa
[90444.066784] RDX: 0000000400000800 RSI: 0000000000000000 RDI: 000000000002d5e0
[90444.068533] RBP: ffff9b174d308468 R08: 0000000000000000 R09: ffff9b17d63003f0
[90444.070285] R10: ffff9b17ea288600 R11: 0000000000000000 R12: ffffabe9c61ff878
[90444.072032] R13: ffff9b174d300000 R14: ffffabe9c61ffbb8 R15: ffff9b174d300880
[90444.073760] FS:  00007f3c23775480(0000) GS:ffff9b13efc80000(0000) knlGS:0000000000000000
[90444.075492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[90444.077266] CR2: 0000000000000000 CR3: 00000003e2a60002 CR4: 00000000001606e0
[90444.079024] Call Trace:
[90444.080753]  tc_setup_cb_add+0xca/0x1e0
[90444.082415]  fl_hw_replace_filter+0x15f/0x1f0 [cls_flower]
[90444.084119]  fl_change+0xa59/0x13dc [cls_flower]
[90444.085772]  ? wait_for_completion+0xa8/0xf0
[90444.087364]  tc_new_tfilter+0x3f5/0xa60
[90444.088960]  rtnetlink_rcv_msg+0xeb/0x360
[90444.090514]  ? __d_lookup_done+0x76/0xe0
[90444.092034]  ? proc_alloc_inode+0x16/0x70
[90444.093560]  ? prep_new_page+0x8c/0xf0
[90444.095048]  ? _cond_resched+0x15/0x30
[90444.096483]  ? rtnl_calcit.isra.0+0x110/0x110
[90444.097907]  netlink_rcv_skb+0x49/0x110
[90444.099289]  netlink_unicast+0x191/0x230
[90444.100629]  netlink_sendmsg+0x243/0x480
[90444.101984]  sock_sendmsg+0x5e/0x60
[90444.103305]  ____sys_sendmsg+0x1f3/0x260
[90444.104597]  ? copy_msghdr_from_user+0x5c/0x90
[90444.105916]  ? __mod_lruvec_state+0x3c/0xe0
[90444.107210]  ___sys_sendmsg+0x81/0xc0
[90444.108484]  ? do_filp_open+0xa5/0x100
[90444.109732]  ? handle_mm_fault+0x117b/0x1e00
[90444.110970]  ? __check_object_size+0x46/0x147
[90444.112205]  ? __check_object_size+0x136/0x147
[90444.113402]  __sys_sendmsg+0x59/0xa0
[90444.114587]  do_syscall_64+0x4d/0x90
[90444.115782]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[90444.116953] RIP: 0033:0x7f3c2393b7b8
[90444.118101] Code: Bad RIP value.
[90444.119240] RSP: 002b:00007ffc6ad8e6c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[90444.120408] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3c2393b7b8
[90444.121583] RDX: 0000000000000000 RSI: 00007ffc6ad8e740 RDI: 0000000000000003
[90444.122750] RBP: 000000005eea0c3a R08: 0000000000000001 R09: 00007ffc6ad8e68c
[90444.123928] R10: 0000000000404fa8 R11: 0000000000000246 R12: 0000000000000001
[90444.125073] R13: 0000000000000000 R14: 00007ffc6ad92a00 R15: 00000000004866a0
[90444.126221] Modules linked in: act_skbedit act_tunnel_key act_mirred bonding vxlan ip6_udp_tunnel udp_tunnel nfnetlink act_gact cls_flower sch_ingress openvswitch nsh nf_conncount nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_r
apl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mlxfw kvm act_ct nf_flow_table nf_nat nf_conntrack irqbypass crct10dif_pclmul nf_defrag_ipv6 igb ipmi_ssif libcrc32c crc32_pclmul crc32c_intel ipmi_si nf_defrag_ipv4 ptp ghash_clmulni_intel mei_me ses iTCO_wdt i2c_i801 pps_core
ioatdma iTCO_vendor_support joydev mei enclosure intel_cstate i2c_smbus wmi dca ipmi_devintf intel_uncore lpc_ich ipmi_msghandler pcspkr acpi_pad acpi_power_meter ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[90444.136253] CR2: 0000000000000000
[90444.137621] ---[ end trace 924af62aa2b151bd ]---

Fixes: 553f9328385d ("net/mlx5e: Support tc block sharing for representors")
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 7fc84f58e28a..75f169aef1cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4670,9 +4670,10 @@ static bool is_flow_rule_duplicate_allowed(struct net_device *dev,
 					   struct mlx5e_rep_priv *rpriv)
 {
 	/* Offloaded flow rule is allowed to duplicate on non-uplink representor
-	 * sharing tc block with other slaves of a lag device.
+	 * sharing tc block with other slaves of a lag device. Rpriv can be NULL if this
+	 * function is called from NIC mode.
 	 */
-	return netif_is_lag_port(dev) && rpriv->rep->vport != MLX5_VPORT_UPLINK;
+	return netif_is_lag_port(dev) && rpriv && rpriv->rep->vport != MLX5_VPORT_UPLINK;
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
-- 
2.26.2

