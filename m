Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C76389CE2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 07:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhETFEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 01:04:15 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54300 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhETFEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 01:04:14 -0400
Received: from fsav107.sakura.ne.jp (fsav107.sakura.ne.jp [27.133.134.234])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 14K5228p049599;
        Thu, 20 May 2021 14:02:02 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav107.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav107.sakura.ne.jp);
 Thu, 20 May 2021 14:02:02 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav107.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 14K522Xq049596
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 20 May 2021 14:02:02 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [syzbot] BUG: MAX_LOCKDEP_KEYS too low! (2)
To:     Dmitry Vyukov <dvyukov@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Miller <davem@davemloft.net>
Cc:     syzbot <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
References: <0000000000003687bd05c2b2401d@google.com>
 <CACT4Y+YJDGFN4q-aTPritnjjHEXiFovOm9eO6Ay4xC1YOa5z3w@mail.gmail.com>
 <c545268c-fe62-883c-4c46-974b3bb3cea1@infradead.org>
 <CACT4Y+aEtYPAdrU7KkE303yDw__QiG7m1tWVJewV8C_Mt9=1qg@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <208cd812-214f-ef2f-26ec-cc7a73953885@i-love.sakura.ne.jp>
Date:   Thu, 20 May 2021 14:02:00 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+aEtYPAdrU7KkE303yDw__QiG7m1tWVJewV8C_Mt9=1qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/05/20 5:09, Dmitry Vyukov wrote:
> On Wed, May 19, 2021 at 9:58 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> On 5/19/21 12:48 PM, Dmitry Vyukov wrote:
>>> On Wed, May 19, 2021 at 7:35 PM syzbot
>>> <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    b81ac784 net: cdc_eem: fix URL to CDC EEM 1.0 spec
>>>> git tree:       net
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=15a257c3d00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5b86a12e0d1933b5
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a70a6358abd2c3f9550f
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com
>>>>
>>>> BUG: MAX_LOCKDEP_KEYS too low!
>>>
>>
>> include/linux/lockdep.h
>>
>> #define MAX_LOCKDEP_KEYS_BITS           13
>> #define MAX_LOCKDEP_KEYS                (1UL << MAX_LOCKDEP_KEYS_BITS)
> 
> Ouch, so it's not configurable yet :(

I didn't try to make this value configurable, for

> Unless, of course, we identify the offender that produced thousands of
> lock classes in the log and fix it.

number of currently active locks should decrease over time.
If this message is printed, increasing this value unlikely helps.

We have https://lkml.kernel.org/r/c099ad52-0c2c-b886-bae2-c64bd8626452@ozlabs.ru
which seems to be unresolved.

Regarding this report, cleanup of bonding device is too slow to catch up to
creation of bonding device?

We might need to throttle creation of BPF, bonding etc. which involve WQ operation for clean up ?
