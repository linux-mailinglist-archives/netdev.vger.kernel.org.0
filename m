Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F3C224C8
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfERUM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:12:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfERUM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:12:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3377814DF426D;
        Sat, 18 May 2019 13:12:58 -0700 (PDT)
Date:   Sat, 18 May 2019 13:12:57 -0700 (PDT)
Message-Id: <20190518.131257.1124207773533732758.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com,
        jon.maloy@ericsson.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
        dvyukov@google.com, edumazet@google.com, hujunwei4@huawei.com
Subject: Re: INFO: trying to register non-static key in
 rhashtable_walk_enter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+FuTSct1p1tYAWdsWOgQT7AHoFbdgoT=gA1tQ3nii_85k9bFA@mail.gmail.com>
References: <00000000000014e65905892486ab@google.com>
        <CA+FuTSeM5qzyf_D+70Xe5k=3d+dYp2WyVZC-YM=K4=9kCCst6A@mail.gmail.com>
        <CA+FuTSct1p1tYAWdsWOgQT7AHoFbdgoT=gA1tQ3nii_85k9bFA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 May 2019 13:12:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sat, 18 May 2019 14:19:07 -0400

> On Sat, May 18, 2019 at 2:09 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> On Sat, May 18, 2019 at 3:34 AM syzbot
>> <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com> wrote:
>> >
>> > Hello,
>> >
>> > syzbot found the following crash on:
>> >
>> > HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
>> > git tree:       net
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=15b7e608a00000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=1e8114b61079bfe9cbc5
>> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> >
>> > Unfortunately, I don't have any reproducer for this crash yet.
>> >
>> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> > Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
>> >
>> > INFO: trying to register non-static key.
>> > the code is fine but needs lockdep annotation.
>>
>> All these five rhashtable_walk_enter probably have the same root cause.
>>
>> Bisected to commit 7e27e8d6130c (" tipc: switch order of device
>> registration to fix a crash"). Reverting that fixes it.
>>
>> Before the commit, tipc_init succeeds. After the commit it fails at
>> register_pernet_subsys(&tipc_net_ops) due to error in
>>
>>   tipc_init_net
>>     tipc_topsrv_start
>>       tipc_topsrv_create_listener
>>         sock_create_kern
>>
>> On a related note, in tipc_topsrv_start srv is also not freed on later
>> error paths.
> 
> and tipc_topsrv_stop is not called in tipc_init_net on later error paths.

This was gonna get fixed by:

532b0f7ece4cb2ffd24dc723ddf55242d1188e5e
tipc: fix modprobe tipc failed after switch order of device registration

I think...

But I reverted because they were still fiddling around with the fix.

This looks really bad at this point and I'm likely to revert 7e27e8d6130c
because it creates so many more bugs than it fixes :-////
