Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDC27F4A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfEWOPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:15:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:56158 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbfEWOPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:15:04 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hToUn-0005Nf-OJ; Thu, 23 May 2019 16:15:01 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hToUn-0004fP-Cc; Thu, 23 May 2019 16:15:01 +0200
Subject: Re: [bpf PATCH] bpf: sockmap, restore sk_write_space when psock gets
 dropped
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
References: <20190522100142.28925-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6812dfb2-aa46-2dee-90c2-65644a1a6c8b@iogearbox.net>
Date:   Thu, 23 May 2019 16:15:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190522100142.28925-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22/2019 12:01 PM, Jakub Sitnicki wrote:
> Once psock gets unlinked from its sock (sk_psock_drop), user-space can
> still trigger a call to sk->sk_write_space by setting TCP_NOTSENT_LOWAT
> socket option. This causes a null-ptr-deref because we try to read
> psock->saved_write_space from sk_psock_write_space:
> 
> ==================================================================
> BUG: KASAN: null-ptr-deref in sk_psock_write_space+0x69/0x80
> Read of size 8 at addr 00000000000001a0 by task sockmap-echo/131
> 
> CPU: 0 PID: 131 Comm: sockmap-echo Not tainted 5.2.0-rc1-00094-gf49aa1de9836 #81
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> ?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
> Call Trace:
>  ? sk_psock_write_space+0x69/0x80
>  __kasan_report.cold.2+0x5/0x3f
>  ? sk_psock_write_space+0x69/0x80
>  kasan_report+0xe/0x20
>  sk_psock_write_space+0x69/0x80
>  tcp_setsockopt+0x69a/0xfc0
>  ? tcp_shutdown+0x70/0x70
>  ? fsnotify+0x5b0/0x5f0
>  ? remove_wait_queue+0x90/0x90
>  ? __fget_light+0xa5/0xf0
>  __sys_setsockopt+0xe6/0x180
>  ? sockfd_lookup_light+0xb0/0xb0
>  ? vfs_write+0x195/0x210
>  ? ksys_write+0xc9/0x150
>  ? __x64_sys_read+0x50/0x50
>  ? __bpf_trace_x86_fpu+0x10/0x10
>  __x64_sys_setsockopt+0x61/0x70
>  do_syscall_64+0xc5/0x520
>  ? vmacache_find+0xc0/0x110
>  ? syscall_return_slowpath+0x110/0x110
>  ? handle_mm_fault+0xb4/0x110
>  ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
>  ? trace_hardirqs_off_caller+0x4b/0x120
>  ? trace_hardirqs_off_thunk+0x1a/0x3a
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7f2e5e7cdcce
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b1 66 2e 0f 1f 84 00 00 00 00 00
> 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 8b 0d 8a 11 0c 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffed011b778 EFLAGS: 00000206 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2e5e7cdcce
> RDX: 0000000000000019 RSI: 0000000000000006 RDI: 0000000000000007
> RBP: 00007ffed011b790 R08: 0000000000000004 R09: 00007f2e5e84ee80
> R10: 00007ffed011b788 R11: 0000000000000206 R12: 00007ffed011b78c
> R13: 00007ffed011b788 R14: 0000000000000007 R15: 0000000000000068
> ==================================================================
> 
> Restore the saved sk_write_space callback when psock is being dropped to
> fix the crash.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

LGTM, applied thanks!
