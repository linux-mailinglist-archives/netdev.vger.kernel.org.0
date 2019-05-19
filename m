Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB16522997
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 02:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfETAqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 20:46:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8213 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726923AbfETAqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 20:46:39 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D97A9D9289DAA879527E;
        Sun, 19 May 2019 16:55:46 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 May 2019
 16:55:43 +0800
Subject: Re: INFO: trying to register non-static key in rhashtable_walk_enter
To:     David Miller <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>
CC:     <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com>,
        <jon.maloy@ericsson.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <tipc-discussion@lists.sourceforge.net>, <ying.xue@windriver.com>,
        <dvyukov@google.com>, <edumazet@google.com>
References: <00000000000014e65905892486ab@google.com>
 <CA+FuTSeM5qzyf_D+70Xe5k=3d+dYp2WyVZC-YM=K4=9kCCst6A@mail.gmail.com>
 <CA+FuTSct1p1tYAWdsWOgQT7AHoFbdgoT=gA1tQ3nii_85k9bFA@mail.gmail.com>
 <20190518.131257.1124207773533732758.davem@davemloft.net>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <ad7739b9-0b90-d704-ebc0-08e77a1c7d5e@huawei.com>
Date:   Sun, 19 May 2019 16:55:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190518.131257.1124207773533732758.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/19 4:12, David Miller wrote:
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Sat, 18 May 2019 14:19:07 -0400
> 
>> On Sat, May 18, 2019 at 2:09 PM Willem de Bruijn
>> <willemdebruijn.kernel@gmail.com> wrote:
>>>
>>> On Sat, May 18, 2019 at 3:34 AM syzbot
>>> <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following crash on:
>>>>
>>>> HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
>>>> git tree:       net
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=15b7e608a00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=1e8114b61079bfe9cbc5
>>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>>
>>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>> Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
>>>>
>>>> INFO: trying to register non-static key.
>>>> the code is fine but needs lockdep annotation.
>>>
>>> All these five rhashtable_walk_enter probably have the same root cause.
>>>
>>> Bisected to commit 7e27e8d6130c (" tipc: switch order of device
>>> registration to fix a crash"). Reverting that fixes it.
>>>
>>> Before the commit, tipc_init succeeds. After the commit it fails at
>>> register_pernet_subsys(&tipc_net_ops) due to error in
>>>
>>>   tipc_init_net
>>>     tipc_topsrv_start
>>>       tipc_topsrv_create_listener
>>>         sock_create_kern
>>>
>>> On a related note, in tipc_topsrv_start srv is also not freed on later
>>> error paths.
>>
>> and tipc_topsrv_stop is not called in tipc_init_net on later error paths.
> 
> This was gonna get fixed by:
> 
> 532b0f7ece4cb2ffd24dc723ddf55242d1188e5e
> tipc: fix modprobe tipc failed after switch order of device registration
> 
> I think...
> 
> But I reverted because they were still fiddling around with the fix.
> 
> This looks really bad at this point and I'm likely to revert 7e27e8d6130c
> because it creates so many more bugs than it fixes :-////
> 
> .
> 
Hi, David
I am really sorry for this, just as you said, this bug fixed by:
532b0f7ece4cb2ffd24dc723ddf55242d1188e5e
tipc: fix modprobe tipc failed after switch order of device registration.

I verified the patch v2 works fine, inclue use namespaces together.
I will update syzbot report in patch v3.

Regards,
Junwei

