Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2FC5F59C8
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJESV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiJESV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:21:26 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF5E79EED;
        Wed,  5 Oct 2022 11:21:24 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1og91F-000Cse-PZ; Wed, 05 Oct 2022 20:21:21 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1og91F-000Ury-DV; Wed, 05 Oct 2022 20:21:21 +0200
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net> <YzzWDqAmN5DRTupQ@google.com>
 <dd7b7afd-755b-e980-02b1-cfde0dad1236@iogearbox.net>
 <Yz3FW/H06XS5toBo@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <768c85a3-d307-28bb-761f-9cda9b414aae@iogearbox.net>
Date:   Wed, 5 Oct 2022 20:21:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Yz3FW/H06XS5toBo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

On 10/5/22 7:56 PM, sdf@google.com wrote:
> On 10/05, Daniel Borkmann wrote:
>> On 10/5/22 2:55 AM, sdf@google.com wrote:
>> > On 10/05, Daniel Borkmann wrote:
>> [...]
>> >
>> > The series looks exciting, haven't had a chance to look deeply, will try
>> > to find some time this week.
> 
>> Great, thanks!
> 
>> > We've chatted briefly about priority during the talk, let's maybe discuss
>> > it here more?
>> >
>> > I, as a user, still really have no clue about what priority to use.
>> > We have this problem at tc, and we'll seemingly have the same problem
>> > here? I guess it's even more relevant in k8s because internally at G we
>> > can control the users.
>> >
>> > Is it worth at least trying to provide some default bands / guidance?
>> >
>> > For example, having SEC('tc/ingress') receive attach_priority=124 by
>> > default? Maybe we can even have something like 'tc/ingress_first' get
>> > attach_priority=1 and 'tc/ingress_last' with attach_priority=254?
>> > (the names are arbitrary, we can do something better)
>> >
>> > ingress_first/ingress_last can be used by some monitoring jobs. The rest
>> > can use default 124. If somebody really needs a custom priority, then they
>> > can manually use something around 124/2 if they need to trigger before the
>> > 'default' priority or 124+124/2 if they want to trigger after?
>> >
>> > Thoughts? Is it worth it? Do we care?
> 
>> I think guidance is needed, yes, I can add a few paragraphs to the libbpf
>> header file where we also have the tc BPF link API. I had a brief discussion
>> around this also with developers from datadog as they also use the infra
>> via tc BPF. Overall, its a hard problem, and I don't think there's a good
>> generic solution. The '*_last' is implied by prio=0, so that kernel auto-
>> allocates it, and for libbpf we could add an API for it where the user
>> does not need to specify prio specifically. The 'appending' is reasonable
>> to me given if an application explicitly requests to be added as first
>> (and e.g. enforces policy through tc BPF), but some other 3rd party application
>> prepends itself as first, it can bypass the former, which would be too easy
>> to shoot yourself in the foot. Overall the issue in tc land is that ordering
>> matters, skb packet data could be mangled (e.g. IPs NATed), skb fields can
>> be mangled, and we can have redirect actions (dev A vs. B); the only way I'd
>> see were this is possible if somewhat verifier can annotate the prog when
>> it didn't observe any writes to skb, and no redirect was in play. Then you've
>> kind of replicated the constraints similar to tracing where the attachment
>> can say that ordering doesn't matter if all the progs are in same style.
>> Otherwise, explicit corporation is needed as is today with rest of tc (or
>> as Toke did in libxdp) with multi-attach. In the specific case I mentioned
>> at LPC, it can be made to work given one of the two is only observing traffic
>> at the layer, e.g. it could get prepended if there is guarantee that all
>> return codes are tc_act_unspec so that there is no bypass and then you'll
>> see all traffic or appended to see only traffic which made it past the
>> policy. So it all depends on the applications installing programs, but to
>> solve it generically is not possible given ordering and conflicting actions.
>> So, imho, an _append() API for libbpf can be added along with guidance for
>> developers when to use _append() vs explicit prio.
> 
> Agreed, it's a hard problem to solve, especially from the kernel side.
> Ideally, as Toke mentions on the side thread, there should be some kind
> of system daemon or some other place where the ordering is described.
> But let's start with at least some guidance on the current prio.
> 
> Might be also a good idea to narrow down the prio range to 0-65k for
> now? Maybe in the future we'll have some special PRIO_MONITORING_BEFORE_ALL
> and PRIO_MONITORING_AFTER_ALL that trigger regardless of TC_ACT_UNSPEC?
> I agree with Toke that it's another problem with the current action based
> chains that's worth solving somehow (compared to, say, cgroup programs).

Makes sense, I'll restrict the range so there's headroom for future
extensions, the mentioned 0-65k looks very reasonable to me.

Thanks,
Daniel
