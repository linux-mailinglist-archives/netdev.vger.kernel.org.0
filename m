Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A297F479751
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhLQWp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:45:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:37644 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhLQWp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 17:45:59 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1myLz7-0002Xb-L4; Fri, 17 Dec 2021 23:45:53 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1myLz7-000Hsd-Eb; Fri, 17 Dec 2021 23:45:53 +0100
Subject: Re: [PATCH] bpf: check size before calling kvmalloc
To:     George Kennedy <george.kennedy@oracle.com>, sdf@google.com,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1639766884-1210-1-git-send-email-george.kennedy@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <395e51ca-2274-26ea-baf5-6353b0247214@iogearbox.net>
Date:   Fri, 17 Dec 2021 23:45:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1639766884-1210-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26390/Fri Dec 17 10:20:34 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 7:48 PM, George Kennedy wrote:
> ZERO_SIZE_PTR ((void *)16) is returned by kvmalloc() instead of NULL
> if size is zero. Currently, return values from kvmalloc() are only
> checked for NULL. Before calling kvmalloc() check for size of zero
> and return error if size is zero to avoid the following crash.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 1030bd067 P4D 1030bd067 PUD 103497067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 1 PID: 15094 Comm: syz-executor344 Not tainted 5.16.0-rc1-syzk #1
> Hardware name: Red Hat KVM, BIOS
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff888017627b78 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
> RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
> RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
> R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
> R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
> FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
> Call Trace:
>   <TASK>
>   map_get_next_key kernel/bpf/syscall.c:1279 [inline]
>   __sys_bpf+0x384d/0x5b30 kernel/bpf/syscall.c:4612
>   __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
>   __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4720
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>

Could you provide some more details, e.g. which map type is this where we
have to assume zero-sized keys everywhere?

(Or link to syzkaller report could also work alternatively if public.)

Thanks,
Daniel
