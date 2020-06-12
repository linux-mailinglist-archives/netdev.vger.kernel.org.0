Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3271F79C1
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgFLOZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 10:25:52 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:25825
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbgFLOZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 10:25:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWqQTUW2NM2cTg+mkU/w1p1nmAs0kwtHW4jrbX5S8QMfabdWEXu2dlRV9YvkUrUkTFU5iy1+QcgjQvqeH+DzYR7Y98oTuvzl2is9hAOGfkLDFTdqH12iWj4cZ+yDaCN9tuGxW4VRueH6jJPpx39zBgXl24+nSQqRCwHzOtE0bMEEoAMIAZKqF1tqbXPsKGJCK/2oeEO5tnJkM4RuzptrraQtBX4xaCovu4NjY1M1pRKVpMT5y8ZR/cNn06zl/8Uk/+6MBOI4HWi1kFAunV03Fpj+AE7YYLkTkZm/uh5JDlFf4EwagqgSUmr3XIRqKjJcMKkshOJY00Fzwf3hgKa5Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23xXz18IO9rmOvlxMz1f6PmHPG2WGifrMz1uQs7UA2c=;
 b=GbH9aO1Xs5K0rvd08/Qw1AiQF8p1Xwqkk6/5vrXVp9Rx1Xpd0Op2hJvXN/2+l38MCnnh1VQ+BP/ZgLyQg3kKZtONsigIPpHdKm2tXjBHT7MIZoGevRfi8qRpVjHxjnMxp1ni+UQDzEr9EGT5RbiLCOhiU/ihX/uVC2KUBlTzbj/vlFl4XhDDh3V+WRpuPbNu4AMFoqIvb74C0G42QsnZ6LJ/aVjZbK07NFoWEFAi46xfengEENPqzA+EZBrzDyUGAs3h88/OBNCelt7SWoLFiUHbwVjQA48XbyOsjr7PN63pLoHcLdo5cCR0C0F4slWo7YqYyOC/6yksd4Yk56ZdCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23xXz18IO9rmOvlxMz1f6PmHPG2WGifrMz1uQs7UA2c=;
 b=PzJxAfIUF/SfVvnTeV0U4moqDDhYdhd7ugQOD9drOwragrfIdKyQvyc8y2HskADgBlwswGzjQanclyBkpWG//r9KLv+2j6GAtIoLV55SoKXrClcBJD1/PqqqKb+Z8P+6ac7TaZKVSjHNdAigViTQr+Bfb0uTGbkVQhu4Q6ujtn4=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6882.eurprd05.prod.outlook.com (2603:10a6:20b:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Fri, 12 Jun
 2020 14:25:48 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724%3]) with mapi id 15.20.3088.025; Fri, 12 Jun 2020
 14:25:48 +0000
References: <1591956510-15051-1-git-send-email-wenxu@ucloud.cn> <1591956510-15051-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net 2/2] flow_offload: fix the list_del corruption in the driver list
In-reply-to: <1591956510-15051-2-git-send-email-wenxu@ucloud.cn>
Date:   Fri, 12 Jun 2020 17:25:46 +0300
Message-ID: <vbfsgf0icnp.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: GV0P278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::13) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by GV0P278CA0003.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Fri, 12 Jun 2020 14:25:47 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5532a1b8-7a75-44a2-f3ab-08d80edc808c
X-MS-TrafficTypeDiagnostic: AM7PR05MB6882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB688277ACFE9B1C3059FC7F36AD810@AM7PR05MB6882.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0432A04947
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uL/wgRzX4DWp3GEOgh97ZXGA/wBxe7cX7RTgFPUI0IotGb671QJJdFMJUHvRIXUiQFDQDChQRzS1gPRIRV45Yl2KHtPpYdNUfZS17D7txf+M3othM66ma5nVSbpC+JnfRsqTjcKaXj5p6bB2fl/Ig80Ugs/Noxii0RpLWrtmoD6Bb6rBubmyfLlm0taJ+cVDHbIbisPkexGBRfQRRVSaDnEWOOE4Ut8qUJrmHp/DSSeorFrbg9Qpf+dahii2kffr4rnzTT5bPZnkvMKOBvTm5VKN7l4SRWWP6musoHWdZsJTVnG51/pA51ZXhLxdHeOzb6q8NWjcAjAPk3V9aE98lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(52116002)(6486002)(16526019)(186003)(316002)(4326008)(107886003)(26005)(2616005)(7696005)(956004)(66946007)(86362001)(5660300002)(36756003)(83380400001)(8676002)(8936002)(2906002)(45080400002)(478600001)(66476007)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MUsmOvwv9thVVkW0N0pu1NDQCLpAivtRZug9DrJvGr8aegyWXor5g+Xhr+2zV4BuF4Go+g+b55C3AOHBukSqMiW6ImV/Kgp5VEQf4rYX6Syo+msi58uUR+8yaZEP/2ZNGfqe8R2JXEaM0zONVbSkA2TkPA5B95+KzU8HQrW7VKszEATmkQ1rxyyKWBw1wEjRp6w+YRIkq41iofu9+Bs1eT7aqfOhHkHcrepnzx/gseOWz+Tu/liDF7NjVyUMLCMHgBvz7Z8uuLYznBoyBfkEfemJDVwuGA0JL591RpNMibVsBoQeL1nSZUvaIPtvrG6G3hxmMiZ5Yyp7f5GF6TqnjkLJXk+SIEryix1fHZkwkaL2YMQ6+p9E1Q2v4iOdTypLz4IFyC3KkAlrPWURj2AAOmJJWeCh2nAKALa9XnQxsLMsTQLfKlRqFgKRlSzBih1zrfUlxKhtWyFjq69+g0cq7z+iWiPwavAkiZtAcQveUCY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5532a1b8-7a75-44a2-f3ab-08d80edc808c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2020 14:25:48.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: so4oxHU6Fim7walVPzYGnW5Y8cgmYcFWRfqrYSVwOnkYOpxvNtpIfUAdnJpZ47LSWUHdH3E6elEA3Xa6CzFINw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6882
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 12 Jun 2020 at 13:08, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> When a indr device add in offload success. After the representor
> go away. All the flow_block_cb cleanup but miss del form driver
> list.
>
> Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

Hi wenxu,

I applied this series on top of your other series of fixes that starts
with "[PATCH net v3 1/2] flow_offload: fix incorrect cleanup for
indirect flow_blocks" and get following list manipulation warnings in
most of our tests:

[  538.776527] ######################################
[  538.776848] ## TEST test-devlink-inline-mode.sh ##
[  538.777158] ######################################
[  539.548708] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  539.784948] :test: Fedora 30 (Thirty)
[  539.787047] :test: Linux reg-r-vrt-018-180 5.7.0+
[  539.827011] :test: NIC ens1f0 FW 16.27.6008 PCI 0000:81:00.0 DEVICE 0x1019 ConnectX-5 Ex
[  539.832092] ------------[ cut here ]------------
[  539.832120] list_del corruption, ffff968f138f8280->next is LIST_POISON1 (dead000000000100)
[  539.832179] WARNING: CPU: 2 PID: 2712 at lib/list_debug.c:45 __list_del_entry_valid+0x4b/0x90
[  539.832216] Modules linked in: sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mlxfw act_ct nf_flow_table kvm nf_nat nf_conntrack igb irqbypass nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 crct10dif_pclmul ptp crc32_pclmul ses crc32c_intel pps_core ghash_clmulni_intel iTCO_wdt mei_me joydev ipmi_ssif iTCO_vendor_support intel_cstate mei ipmi_si ioatdma pcsp
kr wmi enclosure lpc_ich intel_uncore dca i2c_i801 acpi_power_meter ipmi_devintf ipmi_msghandler acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  539.832506] CPU: 2 PID: 2712 Comm: tc Not tainted 5.7.0+ #1153
[  539.832532] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  539.832569] RIP: 0010:__list_del_entry_valid+0x4b/0x90
[  539.832594] Code: 39 c0 74 2b 49 8b 30 48 39 fe 75 3a 48 8b 52 08 48 39 f2 75 48 b8 01 00 00 00 c3 48 89 fe 48 c7 c7 50 b2 19 ab e8 47 b3 bd ff <0f> 0b 31 c0 c3 48 89 fe 4c 89 c2 48 c7 c7 88 b2 19 ab e8 30 b3 bd
[  539.832669] RSP: 0018:ffffb132041e3878 EFLAGS: 00010286
[  539.833836] RAX: 0000000000000000 RBX: ffffb132041e38d8 RCX: 0000000000000027
[  539.834960] RDX: 0000000000000027 RSI: 0000000000000092 RDI: ffff968f2fa99d88
[  539.836082] RBP: ffff968f10722000 R08: ffff968f2fa99d80 R09: 00000000000005b3
[  539.837213] R10: 0000000000000001 R11: ffffffffaaedecc0 R12: dead000000000122
[  539.838317] R13: dead000000000100 R14: ffff968f138f8280 R15: ffff968f138f8290
[  539.839397] FS:  00007f6d641b3480(0000) GS:ffff968f2fa80000(0000) knlGS:0000000000000000
[  539.840481] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  539.841565] CR2: 0000000000480360 CR3: 000000044fbfe003 CR4: 00000000001606e0
[  539.842671] Call Trace:
[  539.843787]  tcf_block_unbind+0xad/0x110
[  539.844891]  tcf_block_offload_cmd.isra.0+0x105/0x280
[  539.845995]  tcf_block_offload_unbind.isra.0+0x36/0x60
[  539.847087]  __tcf_block_put+0x84/0x150
[  539.848178]  ingress_destroy+0x1b/0x20 [sch_ingress]
[  539.849266]  qdisc_destroy+0x3e/0xc0
[  539.850346]  qdisc_graft+0x415/0x510
[  539.851426]  tc_get_qdisc+0x1c9/0x300
[  539.852508]  rtnetlink_rcv_msg+0x2b0/0x360
[  539.853599]  ? copyout+0x22/0x30
[  539.854680]  ? _copy_to_iter+0xa1/0x410
[  539.855742]  ? _cond_resched+0x15/0x30
[  539.856784]  ? rtnl_calcit.isra.0+0x110/0x110
[  539.857818]  netlink_rcv_skb+0x49/0x110
[  539.858842]  netlink_unicast+0x191/0x230
[  539.859857]  netlink_sendmsg+0x243/0x480
[  539.860870]  sock_sendmsg+0x5e/0x60
[  539.861875]  ____sys_sendmsg+0x1f3/0x260
[  539.862881]  ? copy_msghdr_from_user+0x5c/0x90
[  539.863889]  ? ____sys_recvmsg+0xa7/0x180
[  539.864887]  ___sys_sendmsg+0x81/0xc0
[  539.865875]  ? ___sys_recvmsg+0x8d/0xc0
[  539.866860]  ? handle_mm_fault+0x117b/0x1e00
[  539.867837]  __sys_sendmsg+0x59/0xa0
[  539.868813]  do_syscall_64+0x5b/0x1d0
[  539.869754]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  539.870686] RIP: 0033:0x7f6d643797b8
[  539.871591] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  539.873428] RSP: 002b:00007ffdc0eb23e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  539.874325] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6d643797b8
[  539.875202] RDX: 0000000000000000 RSI: 00007ffdc0eb2460 RDI: 0000000000000003
[  539.876057] RBP: 000000005ee37948 R08: 0000000000000001 R09: 0000000000d5c9c0
[  539.876889] R10: 0000000000404fa8 R11: 0000000000000246 R12: 0000000000000001
[  539.877704] R13: 00007ffdc0ec26b0 R14: 0000000000000000 R15: 00000000004866a0
[  539.878527] ---[ end trace 046f2dd1361dc9d6 ]---
[  539.901351] ------------[ cut here ]------------
[  539.901946] list_del corruption, ffff968f0467ef00->next is LIST_POISON1 (dead000000000100)
[  539.902535] WARNING: CPU: 13 PID: 2717 at lib/list_debug.c:45 __list_del_entry_valid+0x4b/0x90
[  539.903119] Modules linked in: sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mlxfw act_ct nf_flow_table kvm nf_nat nf_conntrack igb irqbypass nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 crct10dif_pclmul ptp crc32_pclmul ses crc32c_intel pps_core ghash_clmulni_intel iTCO_wdt mei_me joydev ipmi_ssif iTCO_vendor_support intel_cstate mei ipmi_si ioatdma pcsp
kr wmi enclosure lpc_ich intel_uncore dca i2c_i801 acpi_power_meter ipmi_devintf ipmi_msghandler acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  539.907012] CPU: 13 PID: 2717 Comm: tc Tainted: G        W         5.7.0+ #1153
[  539.907695] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  539.908382] RIP: 0010:__list_del_entry_valid+0x4b/0x90
[  539.909068] Code: 39 c0 74 2b 49 8b 30 48 39 fe 75 3a 48 8b 52 08 48 39 f2 75 48 b8 01 00 00 00 c3 48 89 fe 48 c7 c7 50 b2 19 ab e8 47 b3 bd ff <0f> 0b 31 c0 c3 48 89 fe 4c 89 c2 48 c7 c7 88 b2 19 ab e8 30 b3 bd
[  539.910524] RSP: 0018:ffffb1320421b878 EFLAGS: 00010286
[  539.911261] RAX: 0000000000000000 RBX: ffffb1320421b8d8 RCX: 0000000000000027
[  539.912010] RDX: 0000000000000027 RSI: 0000000000000092 RDI: ffff968f2fbd9d88
[  539.912759] RBP: ffff968f17325000 R08: ffff968f2fbd9d80 R09: 00000000000005e8
[  539.913533] R10: 0000000000000001 R11: ffffffffaaedecc0 R12: dead000000000122
[  539.914296] R13: dead000000000100 R14: ffff968f0467ef00 R15: ffff968f0467ef10
[  539.915063] FS:  00007ff65a1d6480(0000) GS:ffff968f2fbc0000(0000) knlGS:0000000000000000
[  539.915841] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  539.916625] CR2: 0000000000480360 CR3: 000000044f852005 CR4: 00000000001606e0
[  539.917422] Call Trace:
[  539.918221]  tcf_block_unbind+0xad/0x110
[  539.919023]  tcf_block_offload_cmd.isra.0+0x105/0x280
[  539.919828]  tcf_block_offload_unbind.isra.0+0x36/0x60
[  539.920635]  __tcf_block_put+0x84/0x150
[  539.921446]  ingress_destroy+0x1b/0x20 [sch_ingress]
[  539.922259]  qdisc_destroy+0x3e/0xc0
[  539.923068]  qdisc_graft+0x415/0x510
[  539.923891]  tc_get_qdisc+0x1c9/0x300
[  539.924699]  rtnetlink_rcv_msg+0x2b0/0x360
[  539.925509]  ? copyout+0x22/0x30
[  539.926314]  ? _copy_to_iter+0xa1/0x410
[  539.927119]  ? _cond_resched+0x15/0x30
[  539.927923]  ? rtnl_calcit.isra.0+0x110/0x110
[  539.928726]  netlink_rcv_skb+0x49/0x110
[  539.929524]  netlink_unicast+0x191/0x230
[  539.930301]  netlink_sendmsg+0x243/0x480
[  539.931058]  sock_sendmsg+0x5e/0x60
[  539.931801]  ____sys_sendmsg+0x1f3/0x260
[  539.932537]  ? copy_msghdr_from_user+0x5c/0x90
[  539.933283]  ? ____sys_recvmsg+0xa7/0x180
[  539.934013]  ___sys_sendmsg+0x81/0xc0
[  539.934743]  ? ___sys_recvmsg+0x8d/0xc0
[  539.935473]  ? handle_mm_fault+0x117b/0x1e00
[  539.936194]  __sys_sendmsg+0x59/0xa0
[  539.936915]  do_syscall_64+0x5b/0x1d0
[  539.937618]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  539.938317] RIP: 0033:0x7ff65a39c7b8
[  539.938994] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  539.940367] RSP: 002b:00007fffba61c6a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  539.941038] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff65a39c7b8
[  539.941694] RDX: 0000000000000000 RSI: 00007fffba61c720 RDI: 0000000000000003
[  539.942331] RBP: 000000005ee37949 R08: 0000000000000001 R09: 00000000012b89c0
[  539.942951] R10: 0000000000404fa8 R11: 0000000000000246 R12: 0000000000000001
[  539.943576] R13: 00007fffba62c970 R14: 0000000000000000 R15: 00000000004866a0
[  539.944179] ---[ end trace 046f2dd1361dc9d7 ]---
