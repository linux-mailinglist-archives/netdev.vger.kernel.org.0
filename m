Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127F4207111
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbgFXKWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:22:38 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:18326
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388095AbgFXKWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:22:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/nxXeKNyvl5OhkuP4ROKkFLfCpfP3ShNP2rB/wy9nKC71n0gknDiWDb4DVHIzh7C+vL9Jtt9oEsfnzcXQW2Gi1I5jCIu/X7N7h9EHJfmGHClN5chpbdAsTVaMH4fwWhC+xfdNjgDIOogZFBubPXSvkizD0urQJ8ef33QnXkjRGJAKERqgUvoglQmMHo56zrGKzqwCG+bas9fW9Q4MVeajiCOEVCgaPXKU89aY/6MNpfoYxx60XHpDTf5Af8n6hFGfAV0ofe7b/TPez+LRHtqE1QhYP+48mob0AaxCB6rOM0zS6T1fBoINKPOiMGpwXpqxA5R2F4lL3p+9xukOv3Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RTgy4J816EGdGyUfDNLMe0iKQ5XBMsu8h4pHPlytN4=;
 b=kTSuliuulHCm3D45CfBaWqZY3YEp0S0bbT4MWF7LlaeaL7IIjdqNw+D6oIxgiyGOeU0BkXAWU8r56JUWO086HwX8Mmx97/73+Z43OQ0UDDIpdemNsJn5zrB2MF4Z7pLFU7n5nnUzqJEKnX55jn4kgkarj8kIukQX66kUc1a4ZE5VpqPNNlPv+hrG9yVV/UURl9oJAaX92E9bE1+0kf7awEZI/yfXB538I0/YfzfRIngPkJAHa3XHP88Pp01poJqflP+CzfWMCy+2FbYGBqak9aFIaUxHHPpvd+eJiX2wZRwaYnXbVCMe/cGK7fXsyRWMOik23PipgyO20x6meObRQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RTgy4J816EGdGyUfDNLMe0iKQ5XBMsu8h4pHPlytN4=;
 b=afqioZfFG7j8Asw4NMmtJbcXWl2R9bFMXSChTsWLp+/NCfUpS2j0iD/nMbnQJvYioYWL7FF/PHH835Wc2sF+Z7s+3EsIaEapw3qJxs9Jl8jqoyP/44rfZ/ml05ibSOhHGJJSibCXUHvQLLqeael7hyGm0NR5avD8O7CtJsHIF0Q=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6759.eurprd05.prod.outlook.com (2603:10a6:20b:139::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 10:22:32 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab%6]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 10:22:32 +0000
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Maor Dickman <maord@mellanox.com>
Subject: Crash in indirect block infra after unloading driver module
Date:   Wed, 24 Jun 2020 13:22:29 +0300
Message-ID: <vbfbll8yd96.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0124.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::29) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM0PR01CA0124.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 10:22:31 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2f4b445-3363-43f4-c100-08d818288173
X-MS-TrafficTypeDiagnostic: AM7PR05MB6759:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB675923C3D6BD29226FE4B978AD950@AM7PR05MB6759.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwQkz/TVQ0iP+u7O1Ei5goPWnUZJI+9LrSEWJGVZlk0d48SlpV9+OgVDOdQj9MwErSIOUnGkPAuFvSv+2ey2k4DpyhxXOCvkJb8ZijdU32k0DDvpqVpHdTZISxhXLIT90U22joLet0BHMJTmGo22qqgbW2mU/2EWXvF0JeN2+S+i2DEdKDHwDK+tbUGnN+8QnmXVz0YTmfeid2m5pzf+d41wIGTkJGFz8vd6vbiyv1C1V8LSxiO4GPBxxxa/IaP3C6oIvT2WTJKWn6v1efvaVV8rDYCgoe9aCBKJBXTGnSyuUIiLs3thLgY6HFBz6EXg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(83380400001)(54906003)(6486002)(7696005)(8676002)(107886003)(26005)(316002)(2906002)(52116002)(186003)(16526019)(478600001)(5660300002)(4326008)(66946007)(86362001)(66556008)(956004)(2616005)(8936002)(36756003)(66476007)(6916009)(45080400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZmEPR7CX1t80Iin/X5dD1O5r/2CRlv3+F8v5gMTuYh30DPZY7DgB/zyLKVZy7kdZvuvj/cVPY5jPoy9coTSDFPMXADwi/vNrMJhnaiOH/Lnam9SocO5zW5R89ULo/w/NAq/B6v9vLUQzQZZnmF200gstkgE12A5A7NMvleaRf/rFtrFKlrdmQl3wP3SHYFK8j+AFJM+lghKgNRiwcjUXT4/ve8irP5c2pprN7IJSTzlBj4aypze5MOrPGz1+jE3VLgDrzw5+EhU98krzncMQVgg/I6yFcvEZqss79HnmNQ8ge4wwLlT+4KIoJCMyUNX0Pz/48QbiIrbeyACcpiJd0EQYdqJaDhcsV462+TpiD345BtAlLwTVSHe82+BM2nQ3Di+GwfGUK6+V3dYke1wWGB5QuLPZXssmbK537OE7dPFQRqeBQDLc/NEGnnB+3fChwli/lZfrMv2XcaRlVUVAVUhyjBEhxHW5EvKC22QbKXI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f4b445-3363-43f4-c100-08d818288173
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 10:22:32.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2gf/CAVXAM90e8Qq3b7ALms4UAcZ59D5cR1rPEomF4MVh2oP+VYINIPnk+u7t3W7kKVwdfQyX74X+DDhyuvUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

I've encountered a new issue with indirect offloads infrastructure. The
issue is that on driver offload its indirect callbacks are not removed
from blocks and any following offloads operations on block that has such
callback in its offloads cb list causes call to unmapped address.

Steps to reproduce:

echo 1 >/sys/class/net/ens1f0/device/sriov_numvfs
echo 0000:81:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
devlink dev eswitch set pci/0000:81:00.0 mode switchdev

ip link add vxlan1 type vxlan dstport 4789 external
ip addr add 192.168.1.1 dev ens1f0
link set up dev ens1f0
ip link set up dev ens1f0
tc qdisc add dev vxlan1 ingress
tc filter add dev vxlan1 protocol ip ingress flower enc_src_ip 192.168.1.2 enc_dst_ip 192.168.1.1 enc_key_id 42 enc_dst_port 4789 action tunnel_key unset action mirred egress redirect dev ens1f0_0
tc -s filter show dev vxlan1 ingress

rmmod mlx5_ib
rmmod mlx5_core
tc -s filter show dev vxlan1 ingress


Resulting dmesg:

[  153.747853] BUG: unable to handle page fault for address: ffffffffc114cee0
[  153.747975] #PF: supervisor instruction fetch in kernel mode
[  153.748071] #PF: error_code(0x0010) - not-present page
[  153.748189] PGD 5b6c12067 P4D 5b6c12067 PUD 5b6c14067 PMD 35b76b067 PTE 0
[  153.748328] Oops: 0010 [#1] SMP KASAN PTI
[  153.748403] CPU: 1 PID: 1909 Comm: tc Not tainted 5.8.0-rc1+ #1170
[  153.748507] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  153.748638] RIP: 0010:0xffffffffc114cee0
[  153.748709] Code: Bad RIP value.
[  153.748767] RSP: 0018:ffff88834895ef00 EFLAGS: 00010246
[  153.748858] RAX: 0000000000000000 RBX: ffff888330a30078 RCX: ffffffffb2da70ba
[  153.748975] RDX: ffff888333635d80 RSI: ffff88834895efa0 RDI: 0000000000000002
[  153.752948] RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed106614600c
[  153.759173] R10: ffff888330a3005f R11: ffffed106614600b R12: ffff88834895efa0
[  153.765419] R13: 0000000000000000 R14: ffffffffc114cee0 R15: ffff8883470efe00
[  153.771689] FS:  00007f6f6ac12480(0000) GS:ffff888362e40000(0000) knlGS:0000000000000000
[  153.777983] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  153.784187] CR2: ffffffffc114ceb6 CR3: 000000035eb9e005 CR4: 00000000001606e0
[  153.790567] Call Trace:
[  153.796844]  ? tc_setup_cb_call+0xd8/0x170
[  153.803164]  ? fl_hw_update_stats+0x117/0x280 [cls_flower]
[  153.809516]  ? 0xffffffffc1328000
[  153.815766]  ? _find_next_bit.constprop.0+0x3e/0xf0
[  153.822079]  ? __nla_reserve+0x4c/0x60
[  153.828283]  ? memcpy+0x39/0x60
[  153.834311]  ? fl_dump+0x335/0x350 [cls_flower]
[  153.840389]  ? fl_tmplt_dump+0x110/0x110 [cls_flower]
[  153.846483]  ? memcpy+0x39/0x60
[  153.852516]  ? tcf_fill_node+0x2ea/0x420
[  153.858564]  ? tcf_chain_tp_delete_empty+0x170/0x170
[  153.864558]  ? tcf_node_dump+0xf9/0x110
[  153.870481]  ? fl_walk+0xf6/0x240 [cls_flower]
[  153.876357]  ? fl_put+0x10/0x10 [cls_flower]
[  153.882173]  ? __mutex_lock_slowpath+0x10/0x10
[  153.887922]  ? tcf_chain_dump+0x237/0x450
[  153.893595]  ? tcf_block_release+0x50/0x50
[  153.899141]  ? tfilter_notify+0x160/0x160
[  153.904630]  ? tc_dump_tfilter+0x388/0x4a0
[  153.910024]  ? tcf_chain_dump+0x450/0x450
[  153.915390]  ? __mutex_lock_slowpath+0x10/0x10
[  153.920657]  ? netlink_dump+0x2ea/0x670
[  153.925851]  ? __netlink_sendskb+0x70/0x70
[  153.931028]  ? __mutex_lock_slowpath+0x10/0x10
[  153.936117]  ? __alloc_skb+0xc3/0x310
[  153.941199]  ? __netlink_dump_start+0x2f6/0x3c0
[  153.946247]  ? rtnetlink_rcv_msg+0x383/0x510
[  153.951222]  ? tcf_chain_dump+0x450/0x450
[  153.956124]  ? rtnl_calcit.isra.0+0x1c0/0x1c0
[  153.961010]  ? kmem_cache_free+0x84/0x2a0
[  153.965787]  ? skb_free_datagram+0x12/0x60
[  153.970576]  ? netlink_recvmsg+0x281/0x690
[  153.975256]  ? tcf_chain_dump+0x450/0x450
[  153.979861]  ? netlink_compare+0x53/0x70
[  153.984447]  ? netlink_rcv_skb+0xd0/0x200
[  153.988872]  ? rtnl_calcit.isra.0+0x1c0/0x1c0
[  153.993233]  ? netlink_ack+0x460/0x460
[  153.997573]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
[  154.001936]  ? netlink_deliver_tap+0x48/0x390
[  154.006298]  ? netlink_unicast+0x2d8/0x3d0
[  154.010553]  ? netlink_attachskb+0x3d0/0x3d0
[  154.014747]  ? __virt_addr_valid+0xbb/0x130
[  154.018886]  ? netlink_sendmsg+0x3af/0x690
[  154.022997]  ? netlink_unicast+0x3d0/0x3d0
[  154.026993]  ? import_iovec+0x135/0x1e0
[  154.030898]  ? netlink_unicast+0x3d0/0x3d0
[  154.034776]  ? sock_sendmsg+0x96/0xa0
[  154.038526]  ? ____sys_sendmsg+0x388/0x420
[  154.042282]  ? kernel_sendmsg+0x30/0x30
[  154.045980]  ? __copy_msghdr_from_user+0x260/0x260
[  154.049702]  ? kernel_recvmsg+0x60/0x60
[  154.053397]  ? copy_msghdr_from_user+0xa7/0x100
[  154.057097]  ? ___sys_sendmsg+0xe0/0x140
[  154.060807]  ? sendmsg_copy_msghdr+0x30/0x30
[  154.064517]  ? ___sys_recvmsg+0xdc/0x130
[  154.068198]  ? recvmsg_copy_msghdr+0x40/0x40
[  154.071852]  ? _raw_read_lock_irqsave+0x50/0x50
[  154.075540]  ? __count_memcg_events+0x33/0x100
[  154.079222]  ? handle_mm_fault+0x66d/0x1eb0
[  154.082884]  ? __fget_light+0x9e/0xf0
[  154.086533]  ? __sys_sendmsg+0xb3/0x130
[  154.090164]  ? __sys_sendmsg_sock+0x60/0x60
[  154.093768]  ? do_syscall_64+0x4d/0x90
[  154.097357]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  154.101006] Modules linked in: act_mirred act_tunnel_key cls_flower sch_ingress vxlan ip6_udp_tunnel udp_tunnel nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm ib_uverbs ib_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass igb crct10dif_pclmul crc32_pclmul mlxfw crc32c_intel ipmi_ssif ptp iTCO_wdt pps_core ses ioatdma ghash_clmulni_intel mei_me iTCO_vendor_suppo
rt enclosure i2c_i801 ipmi_si intel_cstate joydev mei i2c_smbus lpc_ich pcspkr intel_uncore dca wmi ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas [last unloaded: mlx5_core]
[  154.132864] CR2: ffffffffc114cee0
[  154.137879] ---[ end trace 1c03f81270107f93 ]---
[  154.162631] RIP: 0010:0xffffffffc114cee0
[  154.167703] Code: Bad RIP value.
[  154.172705] RSP: 0018:ffff88834895ef00 EFLAGS: 00010246
[  154.177817] RAX: 0000000000000000 RBX: ffff888330a30078 RCX: ffffffffb2da70ba
[  154.183006] RDX: ffff888333635d80 RSI: ffff88834895efa0 RDI: 0000000000000002
[  154.188259] RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed106614600c
[  154.193585] R10: ffff888330a3005f R11: ffffed106614600b R12: ffff88834895efa0
[  154.198928] R13: 0000000000000000 R14: ffffffffc114cee0 R15: ffff8883470efe00
[  154.204315] FS:  00007f6f6ac12480(0000) GS:ffff888362e40000(0000) knlGS:0000000000000000
[  154.209867] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  154.215417] CR2: ffffffffc114ceb6 CR3: 000000035eb9e005 CR4:
00000000001606e0


I can come up with something to fix mlx5 but it looks like all other
drivers that support indirect devices are also susceptible to similar
issue.

Regards,
Vlad
