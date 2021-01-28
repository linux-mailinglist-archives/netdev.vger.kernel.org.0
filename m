Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3003074F4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhA1LkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:40:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11212 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhA1Lj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:39:58 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DRJP26h74zl9l6;
        Thu, 28 Jan 2021 19:37:42 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 19:39:12 +0800
Subject: Re: KASAN: invalid-free in p9_client_create (2)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Dominique Martinet <asmadeus@codewreck.org>,
        David Miller <davem@davemloft.net>, <ericvh@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <lucho@ionkov.net>, Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        <v9fs-developer@lists.sourceforge.net>,
        Linux-MM <linux-mm@kvack.org>
References: <000000000000672eda05b9e291ff@google.com>
 <CAHk-=whCX0Ab=Z2N-zuKVv7BdBZAUGgP0jQqCg+OJjHmtaOkTA@mail.gmail.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <c4899073-b7a5-687d-f76f-dc0fd69c3a70@huawei.com>
Date:   Thu, 28 Jan 2021 19:39:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whCX0Ab=Z2N-zuKVv7BdBZAUGgP0jQqCg+OJjHmtaOkTA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/1/28 3:31, Linus Torvalds 写道:
> [ Participants list changed - syzbot thought this was networking and
> p9, but it really looks entirely like a slub internal bug. I left the
> innocent people on the list just to let them know they are innocent ]
>
> On Wed, Jan 27, 2021 at 6:27 AM syzbot
> <syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com> wrote:
>> The issue was bisected to:
>>
>> commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2
>> Author: Wang Hai <wanghai38@huawei.com>
>> Date:   Wed Jun 3 22:56:21 2020 +0000
>>
>>      mm/slub: fix a memory leak in sysfs_slab_add()
>>
>> BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3142 [inline]
>> BUG: KASAN: double-free or invalid-free in kmem_cache_free+0x82/0x350 mm/slub.c:3158
> The p9 part of this bug report seems to be a red herring.
>
> The problem looks like it's simply the kmem_cache failure case, ie:
>
>   - mm/slab_common.c: create_cache(): if the __kmem_cache_create()
> fails, it does:
>
>          out_free_cache:
>                  kmem_cache_free(kmem_cache, s);
>
>   - but __kmem_cache_create() - at least for slub() - will have done
>
>          sysfs_slab_add(s) .. fails ..
>              -> kobject_del(&s->kobj); .. which frees s ...
>
> so the networking and p9 are fine, and the only reason p9 shows up in
> the trace is that apparently it causes that failure in
> kobject_init_and_add() for whatever reason, and that then exposes the
> problem.
>
> So the added kobject_put() really looks buggy in this situation, and
> the memory leak that that commit dde3c6b72a16 ("mm/slub: fix a memory
> leak in sysfs_slab_add()") fixes is now a double free.
>
> And no, I don't think you can just remove the kmem_cache_free() in
> create_cache(), because _other_ error cases of __kmem_cache_create()
> do not free this.
>
> Wang Hai - comments? I'm inclined to revert that commit for now unless
> somebody can come up with a proper fix..
>
>                Linus
> .
Hi, Linus.
I'm sorry for introducing this bug, and I agree to revert it.
I've just sent the revert patch.
https://lore.kernel.org/patchwork/patch/1372475/

Thanks,
Wang Hai
