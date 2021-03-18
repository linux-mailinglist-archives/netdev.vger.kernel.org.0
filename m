Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D515E3408FA
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhCRPfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:35:19 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:54624 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbhCRPfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 11:35:04 -0400
Received: from cpc79921-stkp12-2-0-cust288.10-2.cable.virginm.net ([86.16.139.33] helo=[192.168.0.18])
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1lMufp-0001x6-6R; Thu, 18 Mar 2021 15:34:57 +0000
Subject: Re: [syzbot] BUG: unable to handle kernel access to user memory in
 sock_ioctl
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
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
 <ed89390a-91e1-320a-fae5-27b7f3a20424@codethink.co.uk>
 <CACT4Y+a1pQ96UWEB3pAnbxPZ+6jW2tqSzkTMqJ+XSbZsKLHgAw@mail.gmail.com>
 <bf2e19a3-3e3a-0eb1-ae37-4cc3b1a7af42@codethink.co.uk>
 <CACT4Y+ZVaxQAnpy_bMGwviZMskD-fy1KgY7pbrjcCRXr24eu2Q@mail.gmail.com>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <8372d8e5-af6e-c851-a0ac-733e269102ce@codethink.co.uk>
Date:   Thu, 18 Mar 2021 15:34:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZVaxQAnpy_bMGwviZMskD-fy1KgY7pbrjcCRXr24eu2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2021 15:18, Dmitry Vyukov wrote:
> On Mon, Mar 15, 2021 at 3:41 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>>
>> On 15/03/2021 11:52, Dmitry Vyukov wrote:
>>> On Mon, Mar 15, 2021 at 12:30 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>>>>
>>>> On 14/03/2021 11:03, Dmitry Vyukov wrote:
>>>>> On Sun, Mar 14, 2021 at 11:01 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>>>>>>> On Wed, Mar 10, 2021 at 7:28 PM syzbot
>>>>>>> <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com> wrote:
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot found the following issue on:
>>>>>>>>
>>>>>>>> HEAD commit:    0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
>>>>>>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
>>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=122c343ad00000
>>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e3c595255fb2d136
>>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c23c5421600e9b454849
>>>>>>>> userspace arch: riscv64
>>>>>>>>
>>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>>>
>>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>>> Reported-by: syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com
>>>>>>>
>>>>>>> +riscv maintainers
>>>>>>>
>>>>>>> Another case of put_user crashing.
>>>>>>
>>>>>> There are 58 crashes in sock_ioctl already. Somehow there is a very
>>>>>> significant skew towards crashing with this "user memory without
>>>>>> uaccess routines" in schedule_tail and sock_ioctl of all places in the
>>>>>> kernel that use put_user... This looks very strange... Any ideas
>>>>>> what's special about these 2 locations?
>>>>>
>>>>> I could imagine if such a crash happens after a previous stack
>>>>> overflow and now task data structures are corrupted. But f_getown does
>>>>> not look like a function that consumes way more than other kernel
>>>>> syscalls...
>>>>
>>>> The last crash I looked at suggested somehow put_user got re-entered
>>>> with the user protection turned back on. Either there is a path through
>>>> one of the kernel handlers where this happens or there's something
>>>> weird going on with qemu.
>>>
>>> Is there any kind of tracking/reporting that would help to localize
>>> it? I could re-reproduce with that code.
>>
>> I'm not sure. I will have a go at debugging on qemu today just to make
>> sure I can reproduce here before I have to go into the office and fix
>> my Icicle board for real hardware tests.
>>
>> I think my first plan post reproduction is to stuff some trace points
>> into the fault handlers to see if we can get a idea of faults being
>> processed, etc.
>>
>> Maybe also add a check in the fault handler to see if the fault was
>> in a fixable region and post an error if that happens / maybe retry
>> the instruction with the relevant SR_SUM flag set.
>>
>> Hopefully tomorrow I can get a run on real hardware to confirm.
>> Would have been better if the Unmatched board I ordered last year
>> would turn up.
> 
> In retrospect it's obvious what's common between these 2 locations:
> they both call a function inside of put_user.
> 
> #syz dup:
> BUG: unable to handle kernel access to user memory in schedule_tail

I think so. I've posted a patch that you can test, which should force
the flags to be saved over switch_to(). I think the sanitisers are just
making it easier to see.

There is a seperate issue of passing complicated things to put_user()
as for security, the function may be executed with the user-space
protections turned off. I plan to raise this on the kernel list later
once I've done some more testing.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
