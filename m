Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941385F7E1D
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 21:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJGTh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 15:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJGThY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 15:37:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D835103D87;
        Fri,  7 Oct 2022 12:37:16 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogt9l-0003Kd-1A; Fri, 07 Oct 2022 21:37:13 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogt9k-000Gob-Jv; Fri, 07 Oct 2022 21:37:12 +0200
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net> <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com> <87tu4fczyv.fsf@toke.dk>
 <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net>
Date:   Fri, 7 Oct 2022 21:37:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26682/Fri Oct  7 09:58:07 2022)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
> On Fri, Oct 7, 2022 at 10:20 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
[...]
>>>> I was thinking a little about how this might work; i.e., how can the
>>>> kernel expose the required knobs to allow a system policy to be
>>>> implemented without program loading having to talk to anything other
>>>> than the syscall API?
>>>
>>>> How about we only expose prepend/append in the prog attach UAPI, and
>>>> then have a kernel function that does the sorting like:
>>>
>>>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, struct
>>>> bpf_prog *new_prog, bool append)
>>>
>>>> where the default implementation just appends/prepends to the array in
>>>> progs depending on the value of 'appen'.
>>>
>>>> And then use the __weak linking trick (or maybe struct_ops with a member
>>>> for TXC, another for XDP, etc?) to allow BPF to override the function
>>>> wholesale and implement whatever ordering it wants? I.e., allow it can
>>>> to just shift around the order of progs in the 'progs' array whenever a
>>>> program is loaded/unloaded?
>>>
>>>> This way, a userspace daemon can implement any policy it wants by just
>>>> attaching to that hook, and keeping things like how to express
>>>> dependencies as a userspace concern?
>>>
>>> What if we do the above, but instead of simple global 'attach first/last',
>>> the default api would be:
>>>
>>> - attach before <target_fd>
>>> - attach after <target_fd>
>>> - attach before target_fd=-1 == first
>>> - attach after target_fd=-1 == last
>>>
>>> ?
>>
>> Hmm, the problem with that is that applications don't generally have an
>> fd to another application's BPF programs; and obtaining them from an ID
>> is a privileged operation (CAP_SYS_ADMIN). We could have it be "attach
>> before target *ID*" instead, which could work I guess? But then the
>> problem becomes that it's racy: the ID you're targeting could get
>> detached before you attach, so you'll need to be prepared to check that
>> and retry; and I'm almost certain that applications won't test for this,
>> so it'll just lead to hard-to-debug heisenbugs. Or am I being too
>> pessimistic here?
> 
> I like Stan's proposal and don't see any issue with FD.
> It's good to gate specific sequencing with cap_sys_admin.
> Also for consistency the FD is better than ID.
> 
> I also like systemd analogy with Before=, After=.
> systemd has a ton more ways to specify deps between Units,
> but none of them have absolute numbers (which is what priority is).
> The only bit I'd tweak in Stan's proposal is:
> - attach before <target_fd>
> - attach after <target_fd>
> - attach before target_fd=0 == first
> - attach after target_fd=0 == last

I think the before(), after() could work, but the target_fd I have my doubts
that it will be practical. Maybe lets walk through a concrete real example. app_a
and app_b shipped via container_a resp container_b. Both want to install tc BPF
and we (operator/user) want to say that prog from app_b should only be inserted
after the one from app_a, never run before; if no prog_a is installed, we ofc just
run prog_b, but if prog_a is inserted, it must be before prog_b given the latter
can only run after the former. How would we get to one anothers target fd? One
could use the 0, but not if more programs sit before/after.
