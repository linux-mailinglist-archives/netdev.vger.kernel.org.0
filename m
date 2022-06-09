Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FF5545604
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiFIUw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbiFIUw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:52:56 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE472010CC;
        Thu,  9 Jun 2022 13:52:54 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzP95-000CoU-Ro; Thu, 09 Jun 2022 22:52:47 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzP95-0006w1-Bv; Thu, 09 Jun 2022 22:52:47 +0200
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
 <87tu8w6cqa.fsf@toke.dk> <YqAJeHAL57cB9qJk@Laptop-X1>
 <CAJ8uoz2g99N6HESyX1cGUWahSJRYQjXDG3m3f4_8APAvJNMHXw@mail.gmail.com>
 <CAEf4BzZsAqq4rOpE2FWA-GHB4OSntv9rMUvt=6sOj6+1wKMMZw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <59b8dda9-0cbb-4a70-2625-eaa8796ae5e5@iogearbox.net>
Date:   Thu, 9 Jun 2022 22:52:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZsAqq4rOpE2FWA-GHB4OSntv9rMUvt=6sOj6+1wKMMZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26567/Thu Jun  9 10:06:06 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/22 10:29 PM, Andrii Nakryiko wrote:
> On Wed, Jun 8, 2022 at 3:18 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
>> On Wed, Jun 8, 2022 at 9:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>>> On Tue, Jun 07, 2022 at 11:31:57AM +0200, Toke Høiland-Jørgensen wrote:
>>>> Hangbin Liu <liuhangbin@gmail.com> writes:
>>>>
>>>>> libbpf APIs for AF_XDP are deprecated starting from v0.7.
>>>>> Let's move to libxdp.
>>>>>
>>>>> The first patch removed the usage of bpf_prog_load_xattr(). As we
>>>>> will remove the GCC diagnostic declaration in later patches.
>>>>
>>>> Kartikeya started working on moving some of the XDP-related samples into
>>>> the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
>>>> programs into that instead of adding a build-dep on libxdp to the kernel
>>>> samples?
>>>
>>> OK, makes sense to me. Should we remove these samples after the xdp-tools PR
>>> merged? What about xdpxceiver.c in selftests/bpf? Should that also be moved to
>>> xdp-tools?
>>
>> Andrii has submitted a patch [1] for moving xsk.[ch] from libbpf to
>> the xsk selftests so it can be used by xdpxceiver. This is a good idea
>> since xdpxceiver tests the low level kernel interfaces and should not
>> be in libxdp. I can also use those files as a start for implementing
>> control interface tests which are in the planning stages. But the
>> xdpsock sample shows how to use libxdp to write an AF_XDP program and
>> belongs more naturally with libxdp. So good that Kartikeya is moving
>> it over. Thanks!
>>
>> Another option would be to keep the xdpsock sample and require libxdp
>> as in your patch set, but you would have to make sure that everything
>> else in samples/bpf compiles neatly even if you do not have libxdp.
>> Test for the presence of libxdp in the Makefile and degrade gracefully
>> if you do not. But we would then have to freeze the xdpsock app as all
>> new development of samples should be in libxdp. Or we just turn
>> xdpsock into a README file and direct people to the samples in libxdp?
>> What do you think?
> 
> I think adding libxdp dependency for samples/bpf is a bad idea. Moving
> samples to near libxdp makes more sense to me.

+1 on moving them out from samples/bpf/ to somewhere near libxdp repo given
it'll be usage example of libxdp.

More generally, the useful XDP-related things could migrate from samples/bpf/
over to either https://github.com/xdp-project/bpf-examples/ or
https://github.com/xdp-project/xdp-tools and then we could potentially toss
the samples/bpf/ dir from the kernel tree.

These days there are tons of howtos and example progs out in the wild and
better tooling/framework available for users to get started. Taking XDP
aside for a bit, a lot of stuff in samples/bpf/ is just outdated.

Brendan recently also started drafting guidelines (wip) for newbies getting
into development with pointers where to look [0]. So really, there's less and
less good reason for samples/bpf/ these days.

   [0] http://vger.kernel.org/bpfconf2022_material/lsfmmbpf2022-bpf-wip-guidelines.pdf

>> [1] https://lore.kernel.org/bpf/20220603190155.3924899-2-andrii@kernel.org/
>>
>>> Thanks
>>> Hangbin
