Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825F44B087F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiBJIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:35:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiBJIf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:35:27 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B717F204;
        Thu, 10 Feb 2022 00:35:28 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nI4v5-000E2A-Ja; Thu, 10 Feb 2022 09:35:15 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nI4v5-000DEK-0s; Thu, 10 Feb 2022 09:35:15 +0100
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
To:     Willy Tarreau <w@1wt.eu>,
        syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bjorn.topel@gmail.com, bjorn.topel@intel.com, bjorn@kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, fgheet255t@gmail.com,
        hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        magnus.karlsson@intel.com, mudongliangabcd@gmail.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        yhs@fb.com
References: <000000000000a3571605d27817b5@google.com>
 <0000000000001f60ef05d7a3c6ad@google.com> <20220210081125.GA4616@1wt.eu>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <359ee592-747f-8610-4180-5e1d2aba1b77@iogearbox.net>
Date:   Thu, 10 Feb 2022 09:35:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220210081125.GA4616@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26448/Wed Feb  9 10:31:19 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 9:11 AM, Willy Tarreau wrote:
> On Wed, Feb 09, 2022 at 10:08:07PM -0800, syzbot wrote:
>> syzbot has bisected this issue to:
>>
>> commit 7661809d493b426e979f39ab512e3adf41fbcc69
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Wed Jul 14 16:45:49 2021 +0000
>>
>>      mm: don't allow oversized kvmalloc() calls
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13bc74c2700000
>> start commit:   f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
>> git tree:       upstream
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=107c74c2700000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17bc74c2700000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
>> dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e514a4700000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcdf8a700000
>>
>> Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
>> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
>>
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> Interesting, so in fact syzkaller has shown that the aforementioned
> patch does its job well and has spotted a call path by which a single
> userland setsockopt() can request more than 2 GB allocation in the
> kernel. Most likely that's in fact what needs to be addressed.
> 
> FWIW the call trace at the URL above is:
> 
> Call Trace:
>   kvmalloc include/linux/mm.h:806 [inline]
>   kvmalloc_array include/linux/mm.h:824 [inline]
>   kvcalloc include/linux/mm.h:829 [inline]
>   xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
>   xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
>   xdp_umem_create+0x6a5/0xf00 net/xdp/xdp_umem.c:252
>   xsk_setsockopt+0x604/0x790 net/xdp/xsk.c:1068
>   __sys_setsockopt+0x1fd/0x4e0 net/socket.c:2176
>   __do_sys_setsockopt net/socket.c:2187 [inline]
>   __se_sys_setsockopt net/socket.c:2184 [inline]
>   __x64_sys_setsockopt+0xb5/0x150 net/socket.c:2184
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> and the meaningful part of the repro is:
> 
>    syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>    syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>    syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>    intptr_t res = 0;
>    res = syscall(__NR_socket, 0x2cul, 3ul, 0);
>    if (res != -1)
>      r[0] = res;
>    *(uint64_t*)0x20000080 = 0;
>    *(uint64_t*)0x20000088 = 0xfff02000000;
>    *(uint32_t*)0x20000090 = 0x800;
>    *(uint32_t*)0x20000094 = 0;
>    *(uint32_t*)0x20000098 = 0;
>    syscall(__NR_setsockopt, r[0], 0x11b, 4, 0x20000080ul, 0x20ul);

Bjorn had a comment back then when the issue was first raised here:

   https://lore.kernel.org/bpf/3f854ca9-f5d6-4065-c7b1-5e5b25ea742f@iogearbox.net/

There was earlier discussion from Andrew to potentially retire the warning:

   https://lore.kernel.org/bpf/20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org/

Bjorn / Magnus / Andrew, anyone planning to follow-up on this issue?

Thanks,
Daniel
