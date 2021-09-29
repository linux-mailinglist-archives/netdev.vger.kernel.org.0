Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAD941BFFF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbhI2Hhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243109AbhI2Hhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:37:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8235FC06161C;
        Wed, 29 Sep 2021 00:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TzOk+Wz70ArZzrcR1eNSERfP7JI3vRiE+D6/GGEzaQ8=; b=UtYO6JmsxqallW5QbSQE/Ib/gZ
        5Ig8J0n7C1sGHBx+M8crNtQ6bzRP6Y7rgj1vIiqDD8CUh5oKNuJevGD5I16c5UKu5iGy/o2UonHED
        jNOLHAjhpfsEpL3idm4D8VoUzb3xpJda986YarPiDTaAuUh/bck1yLeH13BWU9VMoasPbyS5RXb//
        ry5bKTHxYz2mc3NKOh4gKWIlik9GLQTa+wFyZHuiWkJlO0eVLvDI8kBaRuckJg5QK8iaf6A52IC0R
        o74Z4LjTWGzl09Fld6TtCnUk6X31CBK8bMUnJs43lIQFvIqvKaVczvrjnZRe6G0+eXtkU9w/ka0Nx
        h/Wjs6TA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVU80-006fMA-P5; Wed, 29 Sep 2021 07:35:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F2BED30029A;
        Wed, 29 Sep 2021 09:35:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D9D002BBF8379; Wed, 29 Sep 2021 09:35:43 +0200 (CEST)
Date:   Wed, 29 Sep 2021 09:35:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, like.xu@linux.intel.com
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 12:04:21AM +0000, Song Liu wrote:
> Hi Peter, 
> 
> We have see the warning below while testing the new bpf_get_branch_snapshot 
> helper, on a QEMU vm (/usr/bin/qemu-system-x86_64 -enable-kvm -cpu host ...). 
> This issue doesn't happen on bare metal systems (no QEMU). 
> 
> We didn't cover this case, as LBR didn't really work in QEMU. But it seems to
> work after I upgrade the host kernel to 5.12. 
> 
> At the moment, we don't have much idea on how to debug and fix the issue. Could 
> you please share your thoughts on this? 

Well, that's virt, afaik stuff not working is like a feature there or
something, who knows. I've Cc'ed Like Xu who might have clue since he
did the patches.

Virt just ain't worth the pain if you ask me.

> 
> Thanks in advance!
> 
> Song
> 
> 
> 
> 
> ============================== 8< ============================
> 
> [  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)
> [  139.495587] Call Trace:
> [  139.495845]  bpf_get_branch_snapshot+0x17/0x40
> [  139.496285]  bpf_prog_35810402cd1d294c_test1+0x33/0xe6c
> [  139.496791]  bpf_trampoline_10737534536_0+0x4c/0x1000
> [  139.497274]  bpf_testmod_loop_test+0x5/0x20 [bpf_testmod]
> [  139.497799]  bpf_testmod_test_read+0x71/0x1f0 [bpf_testmod]
> [  139.498332]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
> [  139.498878]  ? sysfs_kf_bin_read+0xbe/0x110
> [  139.499284]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
> [  139.499829]  kernfs_fop_read_iter+0x1ac/0x2c0
> [  139.500245]  ? kernfs_create_link+0x110/0x110
> [  139.500667]  new_sync_read+0x24b/0x360
> [  139.501037]  ? __x64_sys_llseek+0x1e0/0x1e0
> [  139.501444]  ? rcu_read_lock_held_common+0x1a/0x50
> [  139.501942]  ? rcu_read_lock_held_common+0x1a/0x50
> [  139.502404]  ? rcu_read_lock_sched_held+0x5f/0xd0
> [  139.502865]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [  139.503294]  ? security_file_permission+0xe7/0x2c0
> [  139.503758]  vfs_read+0x1a4/0x2a0
> [  139.504091]  ksys_read+0xc0/0x160
> [  139.504413]  ? vfs_write+0x510/0x510
> [  139.504756]  ? ktime_get_coarse_real_ts64+0xe4/0xf0
> [  139.505234]  do_syscall_64+0x3a/0x80
> [  139.505581]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  139.506066] RIP: 0033:0x7fb8a05728b2
> [  139.506413] Code: 97 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b6 0f 1f 80 00 00 00 00 f3 0f 1e fa 8b 05 96 db 20 00 85 c0 75 12 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 41 54 49 89 d4 55 48 89
> [  139.508164] RSP: 002b:00007ffe66315a28 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [  139.508870] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8a05728b2
> [  139.509545] RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000010
> [  139.510225] RBP: 00007ffe66315a60 R08: 0000000000000000 R09: 00007ffe66315907
> [  139.510897] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040c8b0
> [  139.511570] R13: 00007ffe66315cc0 R14: 0000000000000000 R15: 0000000000000000 
