Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9EF553E1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbfFYQAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:00:42 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:35294 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfFYQAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 12:00:42 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 12:00:39 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id 956861500322;
        Tue, 25 Jun 2019 17:55:11 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 6061A88D;
        Tue, 25 Jun 2019 17:55:11 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.50,VDF=8.16.17.142)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 829515EF;
        Tue, 25 Jun 2019 17:55:09 +0200 (CEST)
Date:   Tue, 25 Jun 2019 17:55:09 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Subject: 4.19: Traced deadlock during xfrm_user module load
Message-ID: <20190625155509.pgcxwgclqx3lfxxr@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

we're in the process of upgrading to kernel 4.19 and hit
a very rare lockup on boot during "xfrm_user" module load.
The tested kernel was 4.19.55.

When the strongswan IPsec service starts, it loads the xfrm_user module.
-> modprobe hangs forever. 

Also network services like ssh or apache stop responding,
ICMP ping still works.

By chance we had magic sysRq enabled and were able to get some meaningful stack 
traces. We've rebuilt the kernel with LOCKDEP + DEBUG_INFO + DEBUG_INFO_REDUCED, 
but so far failed to reproduce the issue even when hammering the suspected 
deadlock case. Though it's just hammering it for a few hours yet.

Preliminary analysis:

"modprobe xfrm_user":
    xfrm_user_init()
        register_pernet_subsys()
            -> grab pernet_ops_rwsem
                ..
                netlink_table_grab()
                    calls schedule() as "nl_table_users" is non-zero


conntrack netlink related program "info_iponline" does this in parallel:
    netlink_bind()
        netlink_lock_table() -> increases "nl_table_users"
            nfnetlink_bind()
            # does not unlock the table as it's locked by netlink_bind()
                __request_module()
                    call_usermodehelper_exec()
            

"modprobe nf_conntrack_netlink" runs and inits nf_conntrack_netlink:
    ctnetlink_init()
        register_pernet_subsys()
            -> blocks on "pernet_ops_rwsem" thanks to xfrm_user module
                -> schedule()
                    -> deadlock forever


Full stack traces:

strongswan starts on boot and loads "xfrm_user":

kernel: modprobe        D    0  3825   3762 0x80000080
kernel: Call Trace:
kernel: __schedule+0x188/0x4d0
kernel: ? add_wait_queue_exclusive+0x4d/0x60
kernel: schedule+0x21/0x70
kernel: netlink_table_grab+0x9a/0xf0
kernel: ? wake_up_q+0x60/0x60
kernel: __netlink_kernel_create+0x15f/0x1e0
kernel: xfrm_user_net_init+0x45/0x80 [xfrm_user]
kernel: ? xfrm_user_net_exit+0x60/0x60 [xfrm_user]
kernel: ops_init+0x68/0x100
kernel: ? vprintk_emit+0x9e/0x1a0
kernel: ? 0xf826c000
kernel: ? xfrm_dump_sa+0x120/0x120 [xfrm_user]
kernel: register_pernet_operations+0xef/0x1d0
kernel: ? 0xf826c000
kernel: register_pernet_subsys+0x1c/0x30
kernel: xfrm_user_init+0x18/0x1000 [xfrm_user]
kernel: do_one_initcall+0x44/0x190
kernel: ? free_unref_page_commit+0x6a/0xd0
kernel: do_init_module+0x46/0x1c0
kernel: load_module+0x1dc1/0x2400
kernel: sys_init_module+0xed/0x120
kernel: do_fast_syscall_32+0x7a/0x200
kernel: entry_SYSENTER_32+0x6b/0xbe


Another program triggers a conntrack netlink operation in parallel:

kernel: info_iponline   D    0  3787   3684 0x00000084
kernel: Call Trace:
kernel: __schedule+0x188/0x4d0
kernel: schedule+0x21/0x70
kernel: schedule_timeout+0x195/0x260
kernel: ? wake_up_process+0xf/0x20
kernel: ? insert_work+0x86/0xa0
kernel: wait_for_common+0xe2/0x190
kernel: ? wake_up_q+0x60/0x60
kernel: wait_for_completion_killable+0x12/0x30
kernel: call_usermodehelper_exec+0xda/0x170
kernel: __request_module+0x115/0x2e0
kernel: ? __wake_up_common_lock+0x7a/0xa0
kernel: ? __wake_up+0xd/0x20
kernel: nfnetlink_bind+0x28/0x53 [nfnetlink]
kernel: netlink_bind+0x138/0x300
kernel: ? netlink_setsockopt+0x320/0x320
kernel: __sys_bind+0x65/0xb0
kernel: ? __audit_syscall_exit+0x1fb/0x270
kernel: ? __audit_syscall_entry+0xad/0xf0
kernel: sys_socketcall+0x2f0/0x350
kernel: ? _cond_resched+0x12/0x40
kernel: do_fast_syscall_32+0x7a/0x200
kernel: entry_SYSENTER_32+0x6b/0xbe


This triggers a module load by the kernel:

kernel: modprobe        D    0  3827   1578 0x80000080
kernel: Call Trace:
kernel: __schedule+0x188/0x4d0
kernel: schedule+0x21/0x70
kernel: rwsem_down_write_failed+0xf5/0x210
kernel: ? 0xf8283000
kernel: call_rwsem_down_write_failed+0x9/0xc
kernel: down_write+0x18/0x30
kernel: register_pernet_subsys+0x10/0x30
kernel: ctnetlink_init+0x48/0x1000 [nf_conntrack_netlink]
kernel: do_one_initcall+0x44/0x190
kernel: ? free_unref_page_commit+0x6a/0xd0
kernel: do_init_module+0x46/0x1c0
kernel: load_module+0x1dc1/0x2400
kernel: sys_init_module+0xed/0x120
kernel: do_fast_syscall_32+0x7a/0x200
kernel: entry_SYSENTER_32+0x6b/0xbe


Other network related operations are deadlocked in netlink_table_grab():

kernel: ntpd            D    0  3831   3830 0x00000080
kernel: Call Trace:
kernel: __schedule+0x188/0x4d0
kernel: ? add_wait_queue_exclusive+0x4d/0x60
kernel: schedule+0x21/0x70
kernel: netlink_table_grab+0x9a/0xf0
kernel: ? wake_up_q+0x60/0x60
kernel: netlink_release+0x14e/0x460
kernel: __sock_release+0x2d/0xb0
kernel: sock_close+0xd/0x20
kernel: __fput+0x93/0x1c0
kernel: ____fput+0x8/0x10
kernel: task_work_run+0x82/0xa0
kernel: exit_to_usermode_loop+0x8d/0x90
kernel: do_fast_syscall_32+0x1a7/0x200
kernel: entry_SYSENTER_32+0x6b/0xbe


The easy workaround for us is to load the conntrack netlink
modules before starting strongswan. Since we use classic init,
this works. In parallel booting systemd world, people might
still hit the issue, so it's worth fixing.

The related function netlink_create() unlocks the table
before requesting modules and locks it afterwards again.

We guess it's racy to call netlink_unlock_table()
before doing the 
    
    err = nlk->netlink_bind(net, group + 1);
    
call in netlink_bind() ?


What would be the best fix here?

Best regards,
Thomas Jarosch and Juliana Rodrigueiro
