Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7570D33B204
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCOMDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:03:44 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:54494 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhCOMD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:03:28 -0400
X-Greylist: delayed 1969 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2021 08:03:27 EDT
Received: from cpc79921-stkp12-2-0-cust288.10-2.cable.virginm.net ([86.16.139.33] helo=[192.168.0.18])
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1lLlQc-00010L-7F; Mon, 15 Mar 2021 11:30:30 +0000
Subject: Re: [syzbot] BUG: unable to handle kernel access to user memory in
 sock_ioctl
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>
Cc:     andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
References: <00000000000096cdaa05bd32d46f@google.com>
 <CACT4Y+ZjdOaX_X530p+vPbG4mbtUuFsJ1v-gD24T4DnFUqcudA@mail.gmail.com>
 <CACT4Y+ZjVS+nOxtEByF5-djuhbCYLSDdZ7V04qJ0edpQR0514A@mail.gmail.com>
 <CACT4Y+YXifnCtEvLu3ps8JLCK9CBLzEuUAozfNR9v1hsGWspOg@mail.gmail.com>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <ed89390a-91e1-320a-fae5-27b7f3a20424@codethink.co.uk>
Date:   Mon, 15 Mar 2021 11:30:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YXifnCtEvLu3ps8JLCK9CBLzEuUAozfNR9v1hsGWspOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2021 11:03, Dmitry Vyukov wrote:
> On Sun, Mar 14, 2021 at 11:01 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>>> On Wed, Mar 10, 2021 at 7:28 PM syzbot
>>> <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
>>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=122c343ad00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e3c595255fb2d136
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c23c5421600e9b454849
>>>> userspace arch: riscv64
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com
>>>
>>> +riscv maintainers
>>>
>>> Another case of put_user crashing.
>>
>> There are 58 crashes in sock_ioctl already. Somehow there is a very
>> significant skew towards crashing with this "user memory without
>> uaccess routines" in schedule_tail and sock_ioctl of all places in the
>> kernel that use put_user... This looks very strange... Any ideas
>> what's special about these 2 locations?
> 
> I could imagine if such a crash happens after a previous stack
> overflow and now task data structures are corrupted. But f_getown does
> not look like a function that consumes way more than other kernel
> syscalls...

The last crash I looked at suggested somehow put_user got re-entered
with the user protection turned back on. Either there is a path through
one of the kernel handlers where this happens or there's something
weird going on with qemu.

I'll be trying to get this run up on real hardware this week, the nvme
with my debian install died last week so I have to go and re-install
the machine to get development work done on it.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
