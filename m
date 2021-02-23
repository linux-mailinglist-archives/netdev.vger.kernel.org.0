Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D643323358
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 22:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhBWVfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 16:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhBWVfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 16:35:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0444E64E3F;
        Tue, 23 Feb 2021 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614116068;
        bh=CrBh/bcSKipv7Bd0fUrlGEVOH7Hw42RjBc6YJ+Bc+zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y+m5ywe9RO0wy9Q2Zt/15AkQJ1Zd7JdZf+93AlMTQP3Cx4rgURmAgsOAuesXCJvt/
         x9p5CLKrFvlz6VXm5OPosPPQ/PL8ICbAWwhvWg0lGiKZLqb/NoxDxVGDKIfAsBw9iN
         JqIjpZ5GEEjhVKgsrrUR8Xm8H6uQ2XgiEmPs4zzkFH39xMpbc4LqhQzyHWSf26+Q/U
         W8TXt8zJVLFjzekd2S/dKVUKOB2+HNS8RqIfHMAEZZZVNKg9fEXNPlFqrirlWw/ThH
         nyjiutRNdeGtWS4HmKs2z3SwMjEuJQVeuv17Lamg2amNl6fvOJ2MeuCw5x3EiuRP+t
         5ZjMiOmdTNx0g==
Date:   Tue, 23 Feb 2021 13:34:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, vvs@virtuozzo.com,
        fw@strlen.de
Subject: Re: [PATCH net] vxlan: move debug check after netdev unregister
Message-ID: <20210223133424.3a8a081f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210221154552.11749-1-ap420073@gmail.com>
References: <20210221154552.11749-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Feb 2021 15:45:52 +0000 Taehee Yoo wrote:
> The debug check must be done after unregister_netdevice_many() call --
> the hlist_del_rcu() for this is done inside .ndo_stop.
> 
> This is the same with commit 0fda7600c2e1 ("geneve: move debug check after
> netdev unregister")
> 
> Test commands:
>     ip netns del A
>     ip netns add A
>     ip netns add B
> 
>     ip netns exec B ip link add vxlan0 type vxlan vni 100 local 10.0.0.1 \
> 	    remote 10.0.0.2 dstport 4789 srcport 4789 4789
>     ip netns exec B ip link set vxlan0 netns A
>     ip netns exec A ip link set vxlan0 up
>     ip netns del B
> 
> Splat looks like:
> [   73.176249][    T7] ------------[ cut here ]------------
> [   73.178662][    T7] WARNING: CPU: 4 PID: 7 at drivers/net/vxlan.c:4743 vxlan_exit_batch_net+0x52e/0x720 [vxlan]
> [   73.182597][    T7] Modules linked in: vxlan openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 mlx5_core nfp mlxfw ixgbevf tls sch_fq_codel nf_tables nfnetlink ip_tables x_tables unix
> [   73.190113][    T7] CPU: 4 PID: 7 Comm: kworker/u16:0 Not tainted 5.11.0-rc7+ #838
> [   73.193037][    T7] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [   73.196986][    T7] Workqueue: netns cleanup_net
> [   73.198946][    T7] RIP: 0010:vxlan_exit_batch_net+0x52e/0x720 [vxlan]
> [   73.201509][    T7] Code: 00 01 00 00 0f 84 39 fd ff ff 48 89 ca 48 c1 ea 03 80 3c 1a 00 0f 85 a6 00 00 00 89 c2 48 83 c2 02 49 8b 14 d4 48 85 d2 74 ce <0f> 0b eb ca e8 b9 51 db dd 84 c0 0f 85 4a fe ff ff 48 c7 c2 80 bc
> [   73.208813][    T7] RSP: 0018:ffff888100907c10 EFLAGS: 00010286
> [   73.211027][    T7] RAX: 000000000000003c RBX: dffffc0000000000 RCX: ffff88800ec411f0
> [   73.213702][    T7] RDX: ffff88800a278000 RSI: ffff88800fc78c70 RDI: ffff88800fc78070
> [   73.216169][    T7] RBP: ffff88800b5cbdc0 R08: fffffbfff424de61 R09: fffffbfff424de61
> [   73.218463][    T7] R10: ffffffffa126f307 R11: fffffbfff424de60 R12: ffff88800ec41000
> [   73.220794][    T7] R13: ffff888100907d08 R14: ffff888100907c50 R15: ffff88800fc78c40
> [   73.223337][    T7] FS:  0000000000000000(0000) GS:ffff888114800000(0000) knlGS:0000000000000000
> [   73.225814][    T7] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   73.227616][    T7] CR2: 0000562b5cb4f4d0 CR3: 0000000105fbe001 CR4: 00000000003706e0
> [   73.229700][    T7] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   73.231820][    T7] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   73.233844][    T7] Call Trace:
> [   73.234698][    T7]  ? vxlan_err_lookup+0x3c0/0x3c0 [vxlan]
> [   73.235962][    T7]  ? ops_exit_list.isra.11+0x93/0x140
> [   73.237134][    T7]  cleanup_net+0x45e/0x8a0
> [ ... ]

Please trim the logs if possible, there is no need to list the time 
and thread ID in commit messages unless it adds to the information
somehow.

> Fixes: 0e4ec5acad8b ("vxlan: exit_net cleanup checks added")

The Fixes looks incorrect - I changed it to:

Fixes: 57b61127ab7d ("vxlan: speedup vxlan tunnels dismantle")

> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thanks!
