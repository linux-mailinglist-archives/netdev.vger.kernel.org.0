Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90746B6ED
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhLGJX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:23:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:47646 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbhLGJX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:23:27 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1muWde-00082g-Eg; Tue, 07 Dec 2021 10:19:54 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1muWdd-000SLZ-Uh; Tue, 07 Dec 2021 10:19:53 +0100
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>,
        akpm@linux-foundation.org
References: <000000000000a3571605d27817b5@google.com>
 <CAJ+HfNhyfsT5cS_U9EC213ducHs9k9zNxX9+abqC0kTrPbQ0gg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3f854ca9-f5d6-4065-c7b1-5e5b25ea742f@iogearbox.net>
Date:   Tue, 7 Dec 2021 10:19:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNhyfsT5cS_U9EC213ducHs9k9zNxX9+abqC0kTrPbQ0gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26375/Mon Dec  6 10:22:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +Andrew ]

On 12/7/21 9:49 AM, Björn Töpel wrote:
> On Mon, 6 Dec 2021 at 11:55, syzbot
> <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    a51e3ac43ddb Merge tag 'net-5.16-rc4' of git://git.kernel...
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17f04ebeb00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5b0eee8ab3ea1839
>> dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
>>
> 
> This warning stems from mm/utils.c:
>      /* Don't even allow crazy sizes */
>      if (WARN_ON_ONCE(size > INT_MAX))
>          return NULL;
> 
> The structure that is being allocated is the page-pinning accounting.
> AF_XDP has an internal limit of U32_MAX pages, which is *a lot*, but
> still fewer than what memcg allows (PAGE_COUNTER_MAX is a
> LONG_MAX/PAGE_SIZE on 64b systems).
> 
> The (imo hacky) workaround to silence the warning is to decrease the
> U32_MAX limit to something that is less than "sizeof householding
> struct".
> 
> Note that this is a warning, and not an oops/bug.
> 
> Thoughts?

This is coming from 7661809d493b ("mm: don't allow oversized kvmalloc() calls").
There was a recent discussion on this topic here [0]; this adds another instance.

Iff removal would not be an option, could we maybe add a __GFP_LARGE flag to tag
these instances that it is indeed intended that large allocs are allowed (and they
would thus bypass this warning)?

Thanks,
Daniel

   [0] https://lore.kernel.org/bpf/20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org/
