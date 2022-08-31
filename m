Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B6A5A8864
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiHaVuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiHaVtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:49:55 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADDB7679;
        Wed, 31 Aug 2022 14:49:51 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oTVai-000FnW-A8; Wed, 31 Aug 2022 23:49:44 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oTVai-000NY6-0s; Wed, 31 Aug 2022 23:49:44 +0200
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc>
 <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net>
Date:   Wed, 31 Aug 2022 23:49:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26644/Wed Aug 31 09:53:02 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/22 7:26 PM, Alexei Starovoitov wrote:
> On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>>> 1 and 2 have the upside that its easy to handle a 'file not found'
>>>> error.
>>>
>>> I'm strongly against calling into bpf from the inner guts of nft.
>>> Nack to all options discussed in this thread.
>>> None of them make any sense.
>>
>> -v please.  I can just rework userspace to allow going via xt_bpf
>> but its brain damaged.
> 
> Right. xt_bpf was a dead end from the start.
> It's time to deprecate it and remove it.
> 
>> This helps gradually moving towards move epbf for those that
>> still heavily rely on the classic forwarding path.
> 
> No one is using it.
> If it was, we would have seen at least one bug report over
> all these years. We've seen none.
> 
> tbh we had a fair share of wrong design decisions that look
> very reasonable early on and turned out to be useless with
> zero users.
> BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
> are in this category. > All this code does is bit rot.

+1

> As a minimum we shouldn't step on the same rakes.
> xt_ebpf would be the same dead code as xt_bpf.

+1, and on top, the user experience will just be horrible. :(

>> If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
>> as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
>> but it will take significantly longer to get there.
>>
>> It involves reviving
>> https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> 
> I missed it earlier. What is the end goal ?
> Optimize nft run-time with on the fly generation of bpf byte code ?

Or rather to provide a pendant to nft given existence of xt_bpf, and the
latter will be removed at some point? (If so, can't we just deprecate the
old xt_bpf?)

Thanks,
Daniel
