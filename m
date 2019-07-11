Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363EA64F93
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 02:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfGKAfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 20:35:23 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47427 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfGKAfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 20:35:23 -0400
Received: from [192.168.1.3] (unknown [58.38.0.20])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D048E415FD;
        Thu, 11 Jul 2019 08:35:16 +0800 (CST)
Subject: Re: [PATCH net-next] net/mlx5e: Provide cb_list pointer when setting
 up tc block on rep
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, pablo@netfilter.org, saeedm@mellanox.com
References: <20190710182554.2988-1-vladbu@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <6465040c-d22f-f4b6-0232-11ff4af81753@ucloud.cn>
Date:   Thu, 11 Jul 2019 08:35:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190710182554.2988-1-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSElPS0tLSUhCSExJSU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjY6Lhw6NTg9FA0DHhEXFxI4
        LEIaCSxVSlVKTk1JQ0tOSEpDS09DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhD
        VUtVSUtZV1kIAVlBTEhKTzcG
X-HM-Tid: 0a6bde74adfc2086kuqyd048e415fd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/11 2:25, Vlad Buslov 写道:
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
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 10ef90a7bddd..7245d287633d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1175,6 +1175,8 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
>  	}
>  }
>  
> +static LIST_HEAD(mlx5e_rep_block_cb_list);
> +

I think it is not necessary needs a extra LIST_HEAD, the early mlx5e_block_cb_list is ok

The early patch  http://patchwork.ozlabs.org/patch/1130439/ is enough.

>  static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  			      void *type_data)
>  {
> @@ -1182,7 +1184,8 @@ static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
> -		return flow_block_cb_setup_simple(type_data, NULL,
> +		return flow_block_cb_setup_simple(type_data,
> +						  &mlx5e_rep_block_cb_list,
>  						  mlx5e_rep_setup_tc_cb,
>  						  priv, priv, true);
>  	default:
