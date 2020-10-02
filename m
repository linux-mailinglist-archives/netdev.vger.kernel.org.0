Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F323281EE2
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJBXJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:09:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:41658 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:09:18 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kOUAt-0004Lt-Sd; Sat, 03 Oct 2020 01:09:15 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kOUAt-000Ipc-Lp; Sat, 03 Oct 2020 01:09:15 +0200
Subject: Re: [PATCH bpf-next] bpf: use raw_spin_trylock() for
 pcpu_freelist_push/pop in NMI
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200926000756.893078-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b2be5bfd-4df6-0047-a32a-cd2f93d44555@iogearbox.net>
Date:   Sat, 3 Oct 2020 01:09:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200926000756.893078-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25945/Fri Oct  2 15:54:22 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/20 2:07 AM, Song Liu wrote:
> Recent improvements in LOCKDEP highlighted a potential A-A deadlock with
> pcpu_freelist in NMI:
> 
> ./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi
> 
> [   18.984807] ================================
> [   18.984807] WARNING: inconsistent lock state
> [   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
> [   18.984809] --------------------------------
> [   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> [   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
> [   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at:
> __pcpu_freelist_pop+0xe3/0x180
> [   18.984813] {INITIAL USE} state was registered at:
> [   18.984814]   lock_acquire+0x175/0x7c0
> [   18.984814]   _raw_spin_lock+0x2c/0x40
> [   18.984815]   __pcpu_freelist_pop+0xe3/0x180
> [   18.984815]   pcpu_freelist_pop+0x31/0x40
> [   18.984816]   htab_map_alloc+0xbbf/0xf40
> [   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
> [   18.984817]   do_syscall_64+0x2d/0x40
> [   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   18.984818] irq event stamp: 12
> [ ... ]
> [   18.984822] other info that might help us debug this:
> [   18.984823]  Possible unsafe locking scenario:
> [   18.984823]
> [   18.984824]        CPU0
> [   18.984824]        ----
> [   18.984824]   lock(&head->lock);
> [   18.984826]   <Interrupt>
> [   18.984826]     lock(&head->lock);
> [   18.984827]
> [   18.984828]  *** DEADLOCK ***
> [   18.984828]
> [   18.984829] 2 locks held by test_progs/1990:
> [ ... ]
> [   18.984838]  <NMI>
> [   18.984838]  dump_stack+0x9a/0xd0
> [   18.984839]  lock_acquire+0x5c9/0x7c0
> [   18.984839]  ? lock_release+0x6f0/0x6f0
> [   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
> [   18.984840]  _raw_spin_lock+0x2c/0x40
> [   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
> [   18.984841]  __pcpu_freelist_pop+0xe3/0x180
> [   18.984842]  pcpu_freelist_pop+0x17/0x40
> [   18.984842]  ? lock_release+0x6f0/0x6f0
> [   18.984843]  __bpf_get_stackid+0x534/0xaf0
> [   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
> [   18.984844]  bpf_overflow_handler+0x12f/0x3f0
> 
> This is because pcpu_freelist_head.lock is accessed in both NMI and
> non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.
> 
> For systems with only one cpu, there is a trickier scenario with
> pcpu_freelist_push(): if the only pcpu_freelist_head.lock is already
> locked before NMI, raw_spin_trylock() will never succeed. Unlike,
> _pop(), where we can failover and return NULL, failing _push() will leak
> memory. Fix this issue with an extra list, pcpu_freelist.extralist. The
> extralist is primarily used to take _push() when raw_spin_trylock()
> failed on all the per cpu lists. It should be empty most of the time.
> The following table summarizes the behavior of pcpu_freelist in NMI
> and non-NMI:
> 
> non-NMI pop(): 	use _lock(); check per cpu lists first;
>                  if all per cpu lists are empty, check extralist;
>                  if extralist is empty, return NULL.
> 
> non-NMI push(): use _lock(); only push to per cpu lists.
> 
> NMI pop():    use _trylock(); check per cpu lists first;
>                if all per cpu lists are locked or empty, check extralist;
>                if extralist is locked or empty, return NULL.
> 
> NMI push():   use _trylock(); check per cpu lists first;
>                if all per cpu lists are locked; try push to extralist;
>                if extralist is also locked, keep trying on per cpu lists.

Code looks reasonable to me, is there any practical benefit to keep the
extra list around for >1 CPU case (and not just compile it out)? For
example, we could choose a different back end *_freelist_push/pop()
implementation depending on CONFIG_SMP like ...

ifeq ($(CONFIG_SMP),y)
obj-$(CONFIG_BPF_SYSCALL) += percpu_freelist.o
else
obj-$(CONFIG_BPF_SYSCALL) += onecpu_freelist.o
endif

... and keep the CONFIG_SMP simplified in that we'd only do the trylock
iteration over CPUs under NMI with pop aborting with NULL in worst case
and push keep looping, whereas for the single CPU case, all the logic
resides in onecpu_freelist.c and it has a simpler two list implementation?

Thanks,
Daniel
