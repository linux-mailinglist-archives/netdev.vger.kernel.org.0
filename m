Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21715298802
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771248AbgJZIKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:10:41 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19344 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771244AbgJZIKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:10:39 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9684840006>; Mon, 26 Oct 2020 01:10:44 -0700
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 26 Oct 2020 08:10:34 +0000
References: <20201026060407.583080-1-leon@kernel.org>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] net: use proper block lock instead of RTNL lock
In-Reply-To: <20201026060407.583080-1-leon@kernel.org>
Message-ID: <ygnhd015z9u0.fsf@nvidia.com>
Date:   Mon, 26 Oct 2020 10:10:31 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603699844; bh=DARsv+JgsJ9q8XHc3K2myeg1gi4RgWSQE/jBs3a0F2U=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=JNodiuzTlYAaCZ0CCcDmyo6oB5K+I1ZHsMP1IZu6mvy5zzhD22u+vML1v7VahR2Z3
         grm+hjHna7HbY543ZoaDETexUTlNSms2KAsZ9sz9RTOyCzbra25gJ4p/1KSSCrX/Wi
         GvWXL83Fi6b7MtjHOFTQJaipg11Dk4kG/ihllGExAzeaFNtqQZNYCR01udC+WjtSYt
         PJRCFcN/yuiN6dVwp42tN7EeDPqBeovgiQ+oChFoHzMSb9cHyEbFY4XODcJ06pZNpf
         ib38mlcyTOE7U/tEvnyCdvR3LzrDkJRqK9GVsT+XtzBd+Pj8W3zCHCsI4cBBqjbXvn
         l9vUGevMagZAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 26 Oct 2020 at 08:04, Leon Romanovsky <leon@kernel.org> wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The tcf_block_unbind() expects that the caller will take block->cb_lock
> before calling it, however the code took RTNL lock instead. This causes
> to the following kernel panic.
>
>  WARNING: CPU: 1 PID: 13524 at net/sched/cls_api.c:1488 tcf_block_unbind+0x2db/0x420
>  Modules linked in: mlx5_ib mlx5_core mlxfw ptp pps_core act_mirred act_tunnel_key cls_flower vxlan ip6_udp_tunnel udp_tunnel dummy sch_ingress openvswitch nsh xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad ib_ipoib rdma_cm iw_cm ib_cm ib_uverbs ib_core overlay [last unloaded: mlxfw]
>  CPU: 1 PID: 13524 Comm: test-ecmp-add-v Tainted: G        W         5.9.0+ #1
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>  RIP: 0010:tcf_block_unbind+0x2db/0x420
>  Code: ff 48 83 c4 40 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8d bc 24 30 01 00 00 be ff ff ff ff e8 7d 7f 70 00 85 c0 0f 85 7b fd ff ff <0f> 0b e9 74 fd ff ff 48 c7 c7 dc 6a 24 84 e8 02 ec fe fe e9 55 fd
>  RSP: 0018:ffff888117d17968 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff88812f713c00 RCX: 1ffffffff0848d5b
>  RDX: 0000000000000001 RSI: ffff88814fbc8130 RDI: ffff888107f2b878
>  RBP: 1ffff11022fa2f3f R08: 0000000000000000 R09: ffffffff84115a87
>  R10: fffffbfff0822b50 R11: ffff888107f2b898 R12: ffff88814fbc8000
>  R13: ffff88812f713c10 R14: ffff888117d17a38 R15: ffff88814fbc80c0
>  FS:  00007f6593d36740(0000) GS:ffff8882a4f00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00005607a00758f8 CR3: 0000000131aea006 CR4: 0000000000170ea0
>  Call Trace:
>   tc_block_indr_cleanup+0x3e0/0x5a0
>   ? tcf_block_unbind+0x420/0x420
>   ? __mutex_unlock_slowpath+0xe7/0x610
>   flow_indr_dev_unregister+0x5e2/0x930
>   ? mlx5e_restore_tunnel+0xdf0/0xdf0 [mlx5_core]
>   ? mlx5e_restore_tunnel+0xdf0/0xdf0 [mlx5_core]
>   ? flow_indr_block_cb_alloc+0x3c0/0x3c0
>   ? mlx5_db_free+0x37c/0x4b0 [mlx5_core]
>   mlx5e_cleanup_rep_tx+0x8b/0xc0 [mlx5_core]
>   mlx5e_detach_netdev+0xe5/0x120 [mlx5_core]
>   mlx5e_vport_rep_unload+0x155/0x260 [mlx5_core]
>   esw_offloads_disable+0x227/0x2b0 [mlx5_core]
>   mlx5_eswitch_disable_locked.cold+0x38e/0x699 [mlx5_core]
>   mlx5_eswitch_disable+0x94/0xf0 [mlx5_core]
>   mlx5_device_disable_sriov+0x183/0x1f0 [mlx5_core]
>   mlx5_core_sriov_configure+0xfd/0x230 [mlx5_core]
>   sriov_numvfs_store+0x261/0x2f0
>   ? sriov_drivers_autoprobe_store+0x110/0x110
>   ? sysfs_file_ops+0x170/0x170
>   ? sysfs_file_ops+0x117/0x170
>   ? sysfs_file_ops+0x170/0x170
>   kernfs_fop_write+0x1ff/0x3f0
>   ? rcu_read_lock_any_held+0x6e/0x90
>   vfs_write+0x1f3/0x620
>   ksys_write+0xf9/0x1d0
>   ? __x64_sys_read+0xb0/0xb0
>   ? lockdep_hardirqs_on_prepare+0x273/0x3f0
>   ? syscall_enter_from_user_mode+0x1d/0x50
>   do_syscall_64+0x2d/0x40
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> <...>
>
>  ---[ end trace bfdd028ada702879 ]---
>
> Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/sched/cls_api.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index faeabff283a2..fca147386ad2 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -655,10 +655,8 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
>  	down_write(&block->cb_lock);
>  	list_del(&block_cb->driver_list);
>  	list_move(&block_cb->list, &bo.cb_list);
> -	up_write(&block->cb_lock);
> -	rtnl_lock();
>  	tcf_block_unbind(block, &bo);
> -	rtnl_unlock();
> +	up_write(&block->cb_lock);

Hi Leon,

This fix probably breaks all other drivers besides mlx5 that require
rtnl lock on TC filter update path (called from tp->ops->reoffload()).
I suggest both rtnl lock and cb_lock are required here.

Regards,
Vlad

[...]


