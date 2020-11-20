Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E12BAF28
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgKTPjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgKTPjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:39:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E15822252;
        Fri, 20 Nov 2020 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605886749;
        bh=nrL5/QN1zKL1CEYhnNpAX3N/Z9W1tM0XxQ975msWw4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f3TsN2u8wuJJGaB2zPgdOkyV/2IIbRSxTieDEjOrIc5uGgdaEarKTh+LxMobzn8Ll
         1r+aL1cHxkGZMEI0KBa6zSLwFUUA4EL0PbJKIZnl0HpORZ3aH/DvYO7iTj9BOxTYie
         0mZZUnfD6/1RekSZJ/xtIhBUeQ2Xb0Znza6jM6EQ=
Date:   Fri, 20 Nov 2020 16:39:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jamie Iles <jamie@nuviainc.com>
Cc:     netdev@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCHv3] bonding: wait for sysfs kobject destruction before
 freeing struct slave
Message-ID: <X7fjR8ZB6BVwKS++@kroah.com>
References: <20201113171244.15676-1-jamie@nuviainc.com>
 <20201120142827.879226-1-jamie@nuviainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120142827.879226-1-jamie@nuviainc.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 02:28:27PM +0000, Jamie Iles wrote:
> syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
> struct slave device could result in the following splat:
> 
>   kobject: 'bonding_slave' (00000000cecdd4fe): kobject_release, parent 0000000074ceb2b2 (delayed 1000)
>   bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
>   ------------[ cut here ]------------
>   ODEBUG: free active (active state 0) object type: timer_list hint: workqueue_select_cpu_near kernel/workqueue.c:1549 [inline]
>   ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x98 kernel/workqueue.c:1600
>   WARNING: CPU: 1 PID: 842 at lib/debugobjects.c:485 debug_print_object+0x180/0x240 lib/debugobjects.c:485
>   Kernel panic - not syncing: panic_on_warn set ...
>   CPU: 1 PID: 842 Comm: kworker/u4:4 Tainted: G S                5.9.0-rc8+ #96
>   Hardware name: linux,dummy-virt (DT)
>   Workqueue: netns cleanup_net
>   Call trace:
>    dump_backtrace+0x0/0x4d8 include/linux/bitmap.h:239
>    show_stack+0x34/0x48 arch/arm64/kernel/traps.c:142
>    __dump_stack lib/dump_stack.c:77 [inline]
>    dump_stack+0x174/0x1f8 lib/dump_stack.c:118
>    panic+0x360/0x7a0 kernel/panic.c:231
>    __warn+0x244/0x2ec kernel/panic.c:600
>    report_bug+0x240/0x398 lib/bug.c:198
>    bug_handler+0x50/0xc0 arch/arm64/kernel/traps.c:974
>    call_break_hook+0x160/0x1d8 arch/arm64/kernel/debug-monitors.c:322
>    brk_handler+0x30/0xc0 arch/arm64/kernel/debug-monitors.c:329
>    do_debug_exception+0x184/0x340 arch/arm64/mm/fault.c:864
>    el1_dbg+0x48/0xb0 arch/arm64/kernel/entry-common.c:65
>    el1_sync_handler+0x170/0x1c8 arch/arm64/kernel/entry-common.c:93
>    el1_sync+0x80/0x100 arch/arm64/kernel/entry.S:594
>    debug_print_object+0x180/0x240 lib/debugobjects.c:485
>    __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
>    debug_check_no_obj_freed+0x200/0x430 lib/debugobjects.c:998
>    slab_free_hook mm/slub.c:1536 [inline]
>    slab_free_freelist_hook+0x190/0x210 mm/slub.c:1577
>    slab_free mm/slub.c:3138 [inline]
>    kfree+0x13c/0x460 mm/slub.c:4119
>    bond_free_slave+0x8c/0xf8 drivers/net/bonding/bond_main.c:1492
>    __bond_release_one+0xe0c/0xec8 drivers/net/bonding/bond_main.c:2190
>    bond_slave_netdev_event drivers/net/bonding/bond_main.c:3309 [inline]
>    bond_netdev_event+0x8f0/0xa70 drivers/net/bonding/bond_main.c:3420
>    notifier_call_chain+0xf0/0x200 kernel/notifier.c:83
>    __raw_notifier_call_chain kernel/notifier.c:361 [inline]
>    raw_notifier_call_chain+0x44/0x58 kernel/notifier.c:368
>    call_netdevice_notifiers_info+0xbc/0x150 net/core/dev.c:2033
>    call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
>    call_netdevice_notifiers net/core/dev.c:2059 [inline]
>    rollback_registered_many+0x6a4/0xec0 net/core/dev.c:9347
>    unregister_netdevice_many.part.0+0x2c/0x1c0 net/core/dev.c:10509
>    unregister_netdevice_many net/core/dev.c:10508 [inline]
>    default_device_exit_batch+0x294/0x338 net/core/dev.c:10992
>    ops_exit_list.isra.0+0xec/0x150 net/core/net_namespace.c:189
>    cleanup_net+0x44c/0x888 net/core/net_namespace.c:603
>    process_one_work+0x96c/0x18c0 kernel/workqueue.c:2269
>    worker_thread+0x3f0/0xc30 kernel/workqueue.c:2415
>    kthread+0x390/0x498 kernel/kthread.c:292
>    ret_from_fork+0x10/0x18 arch/arm64/kernel/entry.S:925
> 
> This is a potential use-after-free if the sysfs nodes are being accessed
> whilst removing the struct slave, so wait for the object destruction to
> complete before freeing the struct slave itself.
> 
> Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
> Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Qiushi Wu <wu000273@umn.edu>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Signed-off-by: Jamie Iles <jamie@nuviainc.com>
> ---
> v3:
>  - have a single object lifecycle in the struct slave and remove the
>    explicit deallocation and defer that to the kobject

Nice, it looks like it should have always been done this way!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
