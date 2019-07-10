Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B9564F24
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 01:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGJXPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 19:15:14 -0400
Received: from mail.us.es ([193.147.175.20]:55142 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbfGJXPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 19:15:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA68781402
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 01:15:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA388D190C
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 01:15:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BC7ADDA7B6; Thu, 11 Jul 2019 01:15:11 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D78CDA708;
        Thu, 11 Jul 2019 01:15:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jul 2019 01:15:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.194.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 68FA34265A31;
        Thu, 11 Jul 2019 01:15:09 +0200 (CEST)
Date:   Thu, 11 Jul 2019 01:15:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, saeedm@mellanox.com
Subject: Re: [PATCH net-next] net/mlx5e: Provide cb_list pointer when setting
 up tc block on rep
Message-ID: <20190710231507.oimiomtyby275yoz@salvia>
References: <20190710182554.2988-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710182554.2988-1-vladbu@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 09:25:54PM +0300, Vlad Buslov wrote:
> Recent refactoring of tc block offloads infrastructure introduced new
> flow_block_cb_setup_simple() method intended to be used as unified way for
> all drivers to register offload callbacks. However, commit that actually
> extended all users (drivers) with block cb list and provided it to
> flow_block infra missed mlx5 en_rep. This leads to following NULL-pointer
> dereference when creating Qdisc:
> 
> [  278.385175] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  278.393233] #PF: supervisor read access in kernel mode
> [  278.399446] #PF: error_code(0x0000) - not-present page
> [  278.405847] PGD 8000000850e73067 P4D 8000000850e73067 PUD 8620cd067 PMD 0
> [  278.414141] Oops: 0000 [#1] SMP PTI
> [  278.419019] CPU: 7 PID: 3369 Comm: tc Not tainted 5.2.0-rc6+ #492
> [  278.426580] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
> [  278.435853] RIP: 0010:flow_block_cb_setup_simple+0xc4/0x190
> [  278.442953] Code: 10 48 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 00 48 05 00 01 00 00 49 89 40 08 31 c0 c3 b8 a1 ff ff ff c3 f3 c3 <48> 8b 06 48 39 c6 75 0a eb 1a 48 8b 00 48 39 c6 74 12
>  48 3b 50 28
> [  278.464829] RSP: 0018:ffffaf07c3f97990 EFLAGS: 00010246
> [  278.471648] RAX: 0000000000000000 RBX: ffff9b43ed4c7680 RCX: ffff9b43d5f80840
> [  278.480408] RDX: ffffffffc0491650 RSI: 0000000000000000 RDI: ffffaf07c3f97998
> [  278.489110] RBP: ffff9b43ddff9000 R08: ffff9b43d5f80840 R09: 0000000000000001
> [  278.497838] R10: 0000000000000009 R11: 00000000000003ad R12: ffffaf07c3f97c08
> [  278.506595] R13: ffff9b43d5f80000 R14: ffff9b43ed4c7680 R15: ffff9b43dfa20b40
> [  278.515374] FS:  00007f796be1b400(0000) GS:ffff9b43ef840000(0000) knlGS:0000000000000000
> [  278.525099] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  278.532453] CR2: 0000000000000000 CR3: 0000000840398002 CR4: 00000000001606e0
> [  278.541197] Call Trace:
> [  278.545252]  tcf_block_offload_cmd.isra.52+0x7e/0xb0
> [  278.551871]  tcf_block_get_ext+0x365/0x3e0
> [  278.557569]  qdisc_create+0x15c/0x4e0
> [  278.562859]  ? kmem_cache_alloc_trace+0x1a2/0x1c0
> [  278.569235]  tc_modify_qdisc+0x1c8/0x780
> [  278.574761]  rtnetlink_rcv_msg+0x291/0x340
> [  278.580518]  ? _cond_resched+0x15/0x40
> [  278.585856]  ? rtnl_calcit.isra.29+0x120/0x120
> [  278.591868]  netlink_rcv_skb+0x4a/0x110
> [  278.597198]  netlink_unicast+0x1a0/0x250
> [  278.602601]  netlink_sendmsg+0x2c1/0x3c0
> [  278.608022]  sock_sendmsg+0x5b/0x60
> [  278.612969]  ___sys_sendmsg+0x289/0x310
> [  278.618231]  ? do_wp_page+0x99/0x730
> [  278.623216]  ? page_add_new_anon_rmap+0xbe/0x140
> [  278.629298]  ? __handle_mm_fault+0xc84/0x1360
> [  278.635113]  ? __sys_sendmsg+0x5e/0xa0
> [  278.640285]  __sys_sendmsg+0x5e/0xa0
> [  278.645239]  do_syscall_64+0x5b/0x1b0
> [  278.650274]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  278.656697] RIP: 0033:0x7f796abdeb87
> [  278.661628] Code: 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 80 00 00 00 00 8b 05 6a 2b 2c 00 48 63 d2 48 63 ff 85 c0 75 18 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 59 f3 c3 0f 1f 80 00 00 00 00 53
>  48 89 f3 48
> [  278.683248] RSP: 002b:00007ffde213ba48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [  278.692245] RAX: ffffffffffffffda RBX: 000000005d261e6f RCX: 00007f796abdeb87
> [  278.700862] RDX: 0000000000000000 RSI: 00007ffde213bab0 RDI: 0000000000000003
> [  278.709527] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000006
> [  278.718167] R10: 000000000000000c R11: 0000000000000246 R12: 0000000000000001
> [  278.726743] R13: 000000000067b580 R14: 0000000000000000 R15: 0000000000000000
> [  278.735302] Modules linked in: dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache bridge stp llc sunrpc mlx5_ib ib_uverbs intel_rapl ib_core sb_edac x86_pkg_temp_
> thermal intel_powerclamp coretemp kvm_intel kvm mlx5_core irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel igb ghash_clmulni_intel ses mei_me enclosure mlxfw ipmi_ssif intel_cstate iTCO_wdt ptp mei
> pps_core iTCO_vendor_support pcspkr joydev intel_uncore i2c_i801 ipmi_si lpc_ich intel_rapl_perf ioatdma wmi dca pcc_cpufreq ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad ast i2c_algo_bit drm_k
> ms_helper ttm drm mpt3sas raid_class scsi_transport_sas
> [  278.802263] CR2: 0000000000000000
> [  278.807170] ---[ end trace b1f0a442a279e66f ]---
> 
> Extend en_rep with new static mlx5e_rep_block_cb_list list and pass it to
> flow_block_cb_setup_simple() function instead of hardcoded NULL pointer.
> 
> Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

There's a similar patch from wenxu BTW.
