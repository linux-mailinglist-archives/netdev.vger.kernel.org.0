Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD765F56B0
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJEOs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 10:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJEOs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 10:48:57 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC507822A;
        Wed,  5 Oct 2022 07:48:56 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1og5hc-0004Wi-Sp; Wed, 05 Oct 2022 16:48:52 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1og5hc-000CZE-HC; Wed, 05 Oct 2022 16:48:52 +0200
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        sdf@google.com
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, joe@cilium.io,
        netdev@vger.kernel.org
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net> <YzzWDqAmN5DRTupQ@google.com>
 <878rluily2.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f920e8c7-b328-e74a-8f48-04744a572b55@iogearbox.net>
Date:   Wed, 5 Oct 2022 16:48:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <878rluily2.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26680/Wed Oct  5 09:55:19 2022)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/22 12:50 PM, Toke Høiland-Jørgensen wrote:
> sdf@google.com writes:
[...]
>>
>> The series looks exciting, haven't had a chance to look deeply, will try
>> to find some time this week.
>>
>> We've chatted briefly about priority during the talk, let's maybe discuss
>> it here more?
>>
>> I, as a user, still really have no clue about what priority to use.
>> We have this problem at tc, and we'll seemingly have the same problem
>> here? I guess it's even more relevant in k8s because internally at G we
>> can control the users.
>>
>> Is it worth at least trying to provide some default bands / guidance?
>>
>> For example, having SEC('tc/ingress') receive attach_priority=124 by
>> default? Maybe we can even have something like 'tc/ingress_first' get
>> attach_priority=1 and 'tc/ingress_last' with attach_priority=254?
>> (the names are arbitrary, we can do something better)
>>
>> ingress_first/ingress_last can be used by some monitoring jobs. The rest
>> can use default 124. If somebody really needs a custom priority, then they
>> can manually use something around 124/2 if they need to trigger before the
>> 'default' priority or 124+124/2 if they want to trigger after?
>>
>> Thoughts? Is it worth it? Do we care?
> 
> I think we should care :)
> 
> Having "better" defaults are probably a good idea (so not everything
> just ends up at priority 1 by default). However, I think ultimately the
> only robust solution is to make the priority override-able. Users are
> going to want to combine BPF programs in ways that their authors didn't
> anticipate, so the actual priority the programs run at should not be the
> sole choice of the program author.
> 
> To use the example that Daniel presented at LPC: Running datadog and
> cilium at the same time broke cilium because datadog took over the
> prio-1 hook point. With the bpf_link API what would change is that (a)
> it would be obvious that something breaks (that is good), and (b) it
> would be datadog that breaks instead of cilium (because it can no longer
> just take over the hook, it'll get an error instead). However, (b) means
> that the user still hasn't gotten what they wanted: the ability to run
> datadog and cilium at the same time. To do this, they will need to be
> able to change the priorities of one or both applications.

(Just for the record :) it was an oversight on datadog agent part and it
got fixed, somehow there was a corner-case race with device creation and
bpf attachment which lead to this, but 100% it would make it obvious that
something breaks which is already a good step forward - I just took this
solely as a real-world example that these things /can/ happen and are
/tricky/ to debug on top given the 'undefined' behavior resulting from
this; this can happen to anyone in general ofc. Both sides (cilium, dd)
are configurable to interoperate cleanly now through daemon config.)

> I know cilium at least has a configuration option to change this
> somewhere, but I don't think relying on every BPF-using application to
> expose this (each in their own way) is a good solution. I think of
> priorities more like daemon startup at boot: this is system policy,
> decided by the equivalent of the init system (and in this analogy we are
> currently at the 'rc.d' stage of init system design, with the hook
> priorities).
> 
> One way to resolve this is to have a central daemon that implements the
> policy and does all the program loading on behalf of the users. I think
> multiple such daemons exist already in more or less public and/or
> complete states. However, getting everyone to agree on one is also hard,
> so maybe the kernel needs to expose a mechanism for doing the actual
> overriding, and then whatever daemon people run can hook into that?

I think system policy but also user policy, kind of a mixed bag in the end.
Just take the policy bpf app vs introspection bpf app as an example: a user
might want to see either all traffic (thus before policy app), or just
traffic that policy let through (thus after policy app).

> Not sure what that mechanism would be? A(nother) BPF hook for overriding
> priority on load? An LSM hook that rewrites the system call? (can it
> already do that?) Something else?

Yeah, it could be a means to achieve that, some kind of policy agent which
has awareness of the installed programs and their inter-dependencies resp.
user intent where it then rewrites the prios dynamically.

> Oh, and also, in the case of TC there's also the additional issue that
> execution only chains to the next program if the current one returns
> TC_ACT_UNSPEC; this should probably also be overridable somehow, for the
> same reasons...

Same category as above, yes.

Thanks,
Daniel
