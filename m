Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF14B5E73
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiBNXw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:52:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBNXw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:52:28 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA642182A;
        Mon, 14 Feb 2022 15:52:19 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nJl8h-000Agx-Ve; Tue, 15 Feb 2022 00:52:16 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nJl8h-0005fN-Ix; Tue, 15 Feb 2022 00:52:15 +0100
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
To:     syzbot <syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000073b3e805d7fed17e@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
Date:   Tue, 15 Feb 2022 00:52:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <00000000000073b3e805d7fed17e@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26453/Mon Feb 14 10:29:35 2022)
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song, ptal.

On 2/14/22 7:45 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10baced8700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: vmalloc-out-of-bounds in bpf_jit_binary_pack_free kernel/bpf/core.c:1120 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in bpf_jit_free+0x2b5/0x2e0 kernel/bpf/core.c:1151
> Read of size 4 at addr ffffffffa0001a80 by task kworker/0:18/13642
> 
> CPU: 0 PID: 13642 Comm: kworker/0:18 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events bpf_prog_free_deferred
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_address_description.constprop.0.cold+0xf/0x336 mm/kasan/report.c:255
>   __kasan_report mm/kasan/report.c:442 [inline]
>   kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>   bpf_jit_binary_pack_free kernel/bpf/core.c:1120 [inline]
>   bpf_jit_free+0x2b5/0x2e0 kernel/bpf/core.c:1151
>   bpf_prog_free_deferred+0x5c1/0x790 kernel/bpf/core.c:2524
>   process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
>   worker_thread+0x657/0x1110 kernel/workqueue.c:2454
>   kthread+0x2e9/0x3a0 kernel/kthread.c:377
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>   </TASK>
> 
> 
> Memory state around the buggy address:
>   ffffffffa0001980: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>   ffffffffa0001a00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> ffffffffa0001a80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>                     ^
>   ffffffffa0001b00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>   ffffffffa0001b80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

