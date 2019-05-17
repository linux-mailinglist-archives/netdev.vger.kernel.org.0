Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694EE2144C
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 09:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfEQHbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 03:31:16 -0400
Received: from ja.ssi.bg ([178.16.129.10]:39360 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727361AbfEQHbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 03:31:15 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x4H7UTUr005700;
        Fri, 17 May 2019 10:30:30 +0300
Date:   Fri, 17 May 2019 10:30:29 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     YueHaibing <yuehaibing@huawei.com>
cc:     davem@davemloft.net, wensong@linux-vs.org, horms@verge.net.au,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH] ipvs: Fix use-after-free in ip_vs_in
In-Reply-To: <20190515093614.21176-1-yuehaibing@huawei.com>
Message-ID: <alpine.LFD.2.21.1905171015040.2233@ja.home.ssi.bg>
References: <20190515093614.21176-1-yuehaibing@huawei.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 15 May 2019, YueHaibing wrote:

> BUG: KASAN: use-after-free in ip_vs_in.part.29+0xe8/0xd20 [ip_vs]
> Read of size 4 at addr ffff8881e9b26e2c by task sshd/5603
> 
> CPU: 0 PID: 5603 Comm: sshd Not tainted 4.19.39+ #30
> Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> Call Trace:
>  dump_stack+0x71/0xab
>  print_address_description+0x6a/0x270
>  kasan_report+0x179/0x2c0
>  ? ip_vs_in.part.29+0xe8/0xd20 [ip_vs]
>  ip_vs_in.part.29+0xe8/0xd20 [ip_vs]
>  ? tcp_in_window+0xfe0/0xfe0 [nf_conntrack]
>  ? ip_vs_in_icmp+0xcc0/0xcc0 [ip_vs]
>  ? ipt_do_table+0x4f1/0xad0 [ip_tables]
>  ? ip_vs_out+0x126/0x8f0 [ip_vs]
>  ? common_interrupt+0xa/0xf
>  ip_vs_in+0xd8/0x170 [ip_vs]
>  ? ip_vs_in.part.29+0xd20/0xd20 [ip_vs]
>  ? nf_nat_ipv4_fn+0x21/0xc0 [nf_nat_ipv4]
>  ? nf_nat_packet+0x4b/0x90 [nf_nat]
>  ? nf_nat_ipv4_local_fn+0xf9/0x160 [nf_nat_ipv4]
>  ? ip_vs_remote_request4+0x50/0x50 [ip_vs]
>  nf_hook_slow+0x5f/0xe0
>  ? sock_write_iter+0x121/0x1c0
>  __ip_local_out+0x1d5/0x250
>  ? ip_finish_output+0x430/0x430
>  ? ip_forward_options+0x2d0/0x2d0
>  ? ip_copy_addrs+0x2d/0x40
>  ? __ip_queue_xmit+0x2ca/0x730
>  ip_local_out+0x19/0x60
>  __tcp_transmit_skb+0xba1/0x14f0
>  ? __tcp_select_window+0x330/0x330
>  ? pvclock_clocksource_read+0xd1/0x180
>  ? kvm_sched_clock_read+0xd/0x20
>  ? sched_clock+0x5/0x10
>  ? sched_clock_cpu+0x18/0x100
>  tcp_write_xmit+0x41f/0x1ed0
>  ? _copy_from_iter_full+0xca/0x340
>  __tcp_push_pending_frames+0x52/0x140
>  tcp_sendmsg_locked+0x787/0x1600
>  ? __wake_up_common_lock+0x80/0x130
>  ? tcp_sendpage+0x60/0x60
>  ? remove_wait_queue+0x84/0xb0
>  ? mutex_unlock+0x1d/0x40
>  ? n_tty_read+0x4f7/0xd20
>  ? check_stack_object+0x21/0x60
>  ? inet_sk_set_state+0xb0/0xb0
>  tcp_sendmsg+0x27/0x40
>  sock_sendmsg+0x6d/0x80
>  sock_write_iter+0x121/0x1c0
>  ? sock_sendmsg+0x80/0x80
>  ? ldsem_up_read+0x13/0x40
>  ? iov_iter_init+0x77/0xb0
>  __vfs_write+0x23e/0x370
>  ? kernel_read+0xa0/0xa0
>  ? do_vfs_ioctl+0x134/0x900
>  ? __set_current_blocked+0x7e/0x90
>  ? __audit_syscall_entry+0x18e/0x1f0
>  ? ktime_get_coarse_real_ts64+0x51/0x70
>  vfs_write+0xe7/0x230
>  ksys_write+0xa1/0x120
>  ? __ia32_sys_read+0x50/0x50
>  ? __audit_syscall_exit+0x3ce/0x450
>  do_syscall_64+0x73/0x200
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7ff6f6147c60
> Code: 73 01 c3 48 8b 0d 28 12 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 5d 73 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83
> RSP: 002b:00007ffd772ead18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000034 RCX: 00007ff6f6147c60
> RDX: 0000000000000034 RSI: 000055df30a31270 RDI: 0000000000000003
> RBP: 000055df30a31270 R08: 0000000000000000 R09: 0000000000000000
> R10: 00007ffd772ead70 R11: 0000000000000246 R12: 00007ffd772ead74
> R13: 00007ffd772eae20 R14: 00007ffd772eae24 R15: 000055df2f12ddc0
> 
> Allocated by task 6052:
>  kasan_kmalloc+0xa0/0xd0
>  __kmalloc+0x10a/0x220
>  ops_init+0x97/0x190
>  register_pernet_operations+0x1ac/0x360
>  register_pernet_subsys+0x24/0x40
>  0xffffffffc0ea016d
>  do_one_initcall+0x8b/0x253
>  do_init_module+0xe3/0x335
>  load_module+0x2fc0/0x3890
>  __do_sys_finit_module+0x192/0x1c0
>  do_syscall_64+0x73/0x200
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 6067:
>  __kasan_slab_free+0x130/0x180
>  kfree+0x90/0x1a0
>  ops_free_list.part.7+0xa6/0xc0
>  unregister_pernet_operations+0x18b/0x1f0
>  unregister_pernet_subsys+0x1d/0x30
>  ip_vs_cleanup+0x1d/0xd2f [ip_vs]
>  __x64_sys_delete_module+0x20c/0x300
>  do_syscall_64+0x73/0x200
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff8881e9b26600 which belongs to the cache kmalloc-4096 of size 4096
> The buggy address is located 2092 bytes inside of 4096-byte region [ffff8881e9b26600, ffff8881e9b27600)
> The buggy address belongs to the page:
> page:ffffea0007a6c800 count:1 mapcount:0 mapping:ffff888107c0e600 index:0x0 compound_mapcount: 0
> flags: 0x17ffffc0008100(slab|head)
> raw: 0017ffffc0008100 dead000000000100 dead000000000200 ffff888107c0e600
> raw: 0000000000000000 0000000080070007 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8881e9b26d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881e9b26d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8881e9b26e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                   ^
>  ffff8881e9b26e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881e9b26f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> while unregistering ipvs module, ops_free_list calls
> __ip_vs_cleanup, then nf_unregister_net_hooks be called to
> do remove nf hook entries. It need a RCU period to finish,
> however net->ipvs is set to NULL immediately, which will
> trigger NULL pointer dereference when a packet is hooked
> and handled by ip_vs_in where net->ipvs is dereferenced.
> 
> Another scene is ops_free_list call ops_free to free the
> net_generic directly while __ip_vs_cleanup finished, then
> calling ip_vs_in will triggers use-after-free.

	OK, can you instead test and post a patch that moves
nf_unregister_net_hooks from __ip_vs_cleanup() to
__ip_vs_dev_cleanup()? You can add commit efe41606184e
in Fixes line. There is rcu_barrier() in unregister_pernet_device ->
unregister_pernet_operations that will do the needed grace
period.

	In a followup patch for net-next I'll drop the
ipvs->enable flag and will move the nf_register_net_hooks()
call to ip_vs_add_service() just before the 'svc = kzalloc'
part. So, for now you do not need to move nf_register_net_hooks.
As result, hooks will be registered when there are IPVS rules.

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: efe41606184e ("ipvs: convert to use pernet nf_hook api")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 1445755..33205db 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2320,6 +2320,7 @@ static void __net_exit __ip_vs_cleanup(struct net *net)
>  	ip_vs_control_net_cleanup(ipvs);
>  	ip_vs_estimator_net_cleanup(ipvs);
>  	IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
> +	synchronize_net();
>  	net->ipvs = NULL;
>  }

Regards

--
Julian Anastasov <ja@ssi.bg>
