Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8724F546E83
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348347AbiFJUf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347158AbiFJUfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:35:55 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDADE347875;
        Fri, 10 Jun 2022 13:35:53 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzlME-0008Pn-Ar; Fri, 10 Jun 2022 22:35:50 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzlME-000NnL-0C; Fri, 10 Jun 2022 22:35:50 +0200
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev <netdev@vger.kernel.org>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion> <87h74s2s19.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2f98188b-813b-e226-4962-5c2848998af2@iogearbox.net>
Date:   Fri, 10 Jun 2022 22:35:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87h74s2s19.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26568/Fri Jun 10 10:06:23 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 10:16 PM, Toke Høiland-Jørgensen wrote:
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> 
>> On Sat, Jun 11, 2022 at 12:37:50AM IST, Joanne Koong wrote:
>>> On Fri, Jun 10, 2022 at 10:23 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>>>>
>>>> On Fri, Jun 10, 2022 at 5:58 AM Kumar Kartikeya Dwivedi
>>>> <memxor@gmail.com> wrote:
>>>>>
>>>>> On Fri, Jun 10, 2022 at 05:54:27AM IST, Joanne Koong wrote:
>>>>>> On Thu, Jun 3, 2021 at 11:31 PM Kumar Kartikeya Dwivedi
>>>>>> <memxor@gmail.com> wrote:
>>>>>>>
>>>>>>> This is the second (non-RFC) version.
>>>>>>>
>>>>>>> This adds a bpf_link path to create TC filters tied to cls_bpf classifier, and
>>>>>>> introduces fd based ownership for such TC filters. Netlink cannot delete or
>>>>>>> replace such filters, but the bpf_link is severed on indirect destruction of the
>>>>>>> filter (backing qdisc being deleted, or chain being flushed, etc.). To ensure
>>>>>>> that filters remain attached beyond process lifetime, the usual bpf_link fd
>>>>>>> pinning approach can be used.
>>>>>>>
>>>>>>> The individual patches contain more details and comments, but the overall kernel
>>>>>>> API and libbpf helper mirrors the semantics of the netlink based TC-BPF API
>>>>>>> merged recently. This means that we start by always setting direct action mode,
>>>>>>> protocol to ETH_P_ALL, chain_index as 0, etc. If there is a need for more
>>>>>>> options in the future, they can be easily exposed through the bpf_link API in
>>>>>>> the future.
>>>>>>>
>>>>>>> Patch 1 refactors cls_bpf change function to extract two helpers that will be
>>>>>>> reused in bpf_link creation.
>>>>>>>
>>>>>>> Patch 2 exports some bpf_link management functions to modules. This is needed
>>>>>>> because our bpf_link object is tied to the cls_bpf_prog object. Tying it to
>>>>>>> tcf_proto would be weird, because the update path has to replace offloaded bpf
>>>>>>> prog, which happens using internal cls_bpf helpers, and would in general be more
>>>>>>> code to abstract over an operation that is unlikely to be implemented for other
>>>>>>> filter types.
>>>>>>>
>>>>>>> Patch 3 adds the main bpf_link API. A function in cls_api takes care of
>>>>>>> obtaining block reference, creating the filter object, and then calls the
>>>>>>> bpf_link_change tcf_proto op (only supported by cls_bpf) that returns a fd after
>>>>>>> setting up the internal structures. An optimization is made to not keep around
>>>>>>> resources for extended actions, which is explained in a code comment as it wasn't
>>>>>>> immediately obvious.
>>>>>>>
>>>>>>> Patch 4 adds an update path for bpf_link. Since bpf_link_update only supports
>>>>>>> replacing the bpf_prog, we can skip tc filter's change path by reusing the
>>>>>>> filter object but swapping its bpf_prog. This takes care of replacing the
>>>>>>> offloaded prog as well (if that fails, update is aborted). So far however,
>>>>>>> tcf_classify could do normal load (possibly torn) as the cls_bpf_prog->filter
>>>>>>> would never be modified concurrently. This is no longer true, and to not
>>>>>>> penalize the classify hot path, we also cannot impose serialization around
>>>>>>> its load. Hence the load is changed to READ_ONCE, so that the pointer value is
>>>>>>> always consistent. Due to invocation in a RCU critical section, the lifetime of
>>>>>>> the prog is guaranteed for the duration of the call.
>>>>>>>
>>>>>>> Patch 5, 6 take care of updating the userspace bits and add a bpf_link returning
>>>>>>> function to libbpf.
>>>>>>>
>>>>>>> Patch 7 adds a selftest that exercises all possible problematic interactions
>>>>>>> that I could think of.
>>>>>>>
>>>>>>> Design:
>>>>>>>
>>>>>>> This is where in the object hierarchy our bpf_link object is attached.
>>>>>>>
>>>>>>>                                                                              ┌─────┐
>>>>>>>                                                                              │     │
>>>>>>>                                                                              │ BPF │
>>>>>>>                                                                              program
>>>>>>>                                                                              │     │
>>>>>>>                                                                              └──▲──┘
>>>>>>>                                                        ┌───────┐                │
>>>>>>>                                                        │       │         ┌──────┴───────┐
>>>>>>>                                                        │  mod  ├─────────► cls_bpf_prog │
>>>>>>> ┌────────────────┐                                    │cls_bpf│         └────┬───▲─────┘
>>>>>>> │    tcf_block   │                                    │       │              │   │
>>>>>>> └────────┬───────┘                                    └───▲───┘              │   │
>>>>>>>           │          ┌─────────────┐                       │                ┌─▼───┴──┐
>>>>>>>           └──────────►  tcf_chain  │                       │                │bpf_link│
>>>>>>>                      └───────┬─────┘                       │                └────────┘
>>>>>>>                              │          ┌─────────────┐    │
>>>>>>>                              └──────────►  tcf_proto  ├────┘
>>>>>>>                                         └─────────────┘
>>>>>>>
>>>>>>> The bpf_link is detached on destruction of the cls_bpf_prog.  Doing it this way
>>>>>>> allows us to implement update in a lightweight manner without having to recreate
>>>>>>> a new filter, where we can just replace the BPF prog attached to cls_bpf_prog.
>>>>>>>
>>>>>>> The other way to do it would be to link the bpf_link to tcf_proto, there are
>>>>>>> numerous downsides to this:
>>>>>>>
>>>>>>> 1. All filters have to embed the pointer even though they won't be using it when
>>>>>>> cls_bpf is compiled in.
>>>>>>> 2. This probably won't make sense to be extended to other filter types anyway.
>>>>>>> 3. We aren't able to optimize the update case without adding another bpf_link
>>>>>>> specific update operation to tcf_proto ops.
>>>>>>>
>>>>>>> The downside with tying this to the module is having to export bpf_link
>>>>>>> management functions and introducing a tcf_proto op. Hopefully the cost of
>>>>>>> another operation func pointer is not big enough (as there is only one ops
>>>>>>> struct per module).
>>>>>>>
>>>>>> Hi Kumar,
>>>>>>
>>>>>> Do you have any plans / bandwidth to land this feature upstream? If
>>>>>> so, do you have a tentative estimation for when you'll be able to work
>>>>>> on this? And if not, are you okay with someone else working on this to
>>>>>> get it merged in?
>>>>>>
>>>>>
>>>>> I can have a look at resurrecting it later this month, if you're ok with waiting
>>>>> until then, otherwise if someone else wants to pick this up before that it's
>>>>> fine by me, just let me know so we avoid duplicated effort. Note that the
>>>>> approach in v2 is dead/unlikely to get accepted by the TC maintainers, so we'd
>>>>> have to implement the way Daniel mentioned in [0].
>>>>
>>>> Sounds great! We'll wait and check back in with you later this month.
>>>>
>>> After reading the linked thread (which I should have done before
>>> submitting my previous reply :)),  if I'm understanding it correctly,
>>> it seems then that the work needed for tc bpf_link will be in a new
>>> direction that's not based on the code in this v2 patchset. I'm
>>> interested in learning more about bpf link and tc - I can pick this up
>>> to work on. But if this was something you wanted to work on though,
>>> please don't hesitate to let me know; I can find some other bpf link
>>> thing to work on instead if that's the case.
>>
>> Feel free to take it. And yes, it's going to be much simpler than this. I think
>> you can just add two bpf_prog pointers in struct net_device, use rtnl_lock to
>> protect the updates, and invoke using bpf_prog_run in sch_handle_ingress and
>> sch_handle_egress.
> 
> Except we'd want to also support multiple programs on different
> priorities? I don't think requiring a libxdp-like dispatcher to achieve
> this is a good idea if we can just have it be part of the API from the
> get-go...

Yes, it will be multi-prog to avoid a situation where dispatcher is needed.
