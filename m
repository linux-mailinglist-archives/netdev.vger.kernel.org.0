Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBE85B1285
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiIHC1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiIHC1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:27:08 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337C8C59EE;
        Wed,  7 Sep 2022 19:26:40 -0700 (PDT)
Message-ID: <077d56ef-30cb-2d19-6f57-a92fd886b5f2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662603998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdJgxdOIy/U3ShStsNha7gzjlDjZFsC16duvvdJTQPk=;
        b=sqI6d/Vf97ScM9Na+cfTdaWibP4dNymNJeSSz1si0rBSkz6SDRnVRHIVlBvZevnjApzk3w
        XcpSU10C6rVHn0QOIRzD5eb5F4CohkaZK2jAIh6ejYid712hlWWGGwblI78HnHl/3DD+3S
        +mQhFG1dN6SppgmKxJ+tzuFPf5Ow8Yc=
Date:   Wed, 7 Sep 2022 19:26:34 -0700
MIME-Version: 1.0
Subject: Re: [RFC] Socket termination for policy enforcement and
 load-balancing
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Aditi Ghag <aditivghag@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
 <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
 <CABG=zsCQBVga6Tjcc-Y1x0U=0xAjYHH_j8ncFJPOG2XvxSP2UQ@mail.gmail.com>
 <CAP01T76ry6etJ2Zi02a2+ZtGJxrc=rky5gMqFE7on_fuOe8A8A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAP01T76ry6etJ2Zi02a2+ZtGJxrc=rky5gMqFE7on_fuOe8A8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/22 2:24 PM, Kumar Kartikeya Dwivedi wrote:
> On Sun, 4 Sept 2022 at 20:55, Aditi Ghag <aditivghag@gmail.com> wrote:
>>
>> On Wed, Aug 31, 2022 at 4:02 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>
>>> On Wed, Aug 31, 2022 at 09:37:41AM -0700, Aditi Ghag wrote:
>>>> - Use BPF (sockets) iterator to identify sockets connected to a
>>>> deleted backend. The BPF (sockets) iterator is network namespace aware
>>>> so we'll either need to enter every possible container network
>>>> namespace to identify the affected connections, or adapt the iterator
>>>> to be without netns checks [3]. This was discussed with my colleague
>>>> Daniel Borkmann based on the feedback he shared from the LSFMMBPF
>>>> conference discussions.
>>> Being able to iterate all sockets across different netns will
>>> be useful.
>>>
>>> It should be doable to ignore the netns check.  For udp, a quick
>>> thought is to have another iter target. eg. "udp_all_netns".
>>>  From the sk, the bpf prog should be able to learn the netns and
>>> the bpf prog can filter the netns by itself.
>>>
>>> The TCP side is going to have an 'optional' per netns ehash table [0] soon,
>>> not lhash2 (listening hash) though.  Ideally, the same bpf
>>> all-netns iter interface should work similarly for both udp and
>>> tcp case.  Thus, both should be considered and work at the same time.
>>>
>>> For udp, something more useful than plain udp_abort() could potentially
>>> be done.  eg. directly connect to another backend (by bpf kfunc?).
>>> There may be some details in socket locking...etc but should
>>> be doable and the bpf-iter program could be sleepable also.
>>
>> This won't be effective for connected udp though, will it? Interesting thought
>> around using bpf kfunchmm... why the bpf-prog doing the udp re-connect() won't be effective? 
I suspect we are talking about different thing.

Regardless, for tcp, I think the user space needs to handle the tcp 
aborted-error by redoing the connect().  Thus, lets stay with 
{tcp,udp}_abort() for now.  Try to expose {tcp,udp}_abort() as a kfunc 
instead of a new bpf_helper.

>>
>>> fwiw, we are iterating the tcp socket to retire some older
>>> bpf-tcp-cc (congestion control) on the long-lived connections
>>> by bpf_setsockopt(TCP_CONGESTION).
>>>
>>> Also, potentially, instead of iterating all,
>>> a more selective case can be done by
>>> bpf_prog_test_run()+bpf_sk_lookup_*()+udp_abort().
>>
>> Can you elaborate more on the more selective iterator approach?
If the 4 tuples (src/dst ip/port) is known, bpf_sk_lookup_*() can lookup 
a sk from the tcp_hashinfo or udp_table.  bpf_sk_lookup_*() also takes a 
netns_id argument.  However, yeah, it will still go back to the need to 
get all netns, so may not work well in the RFC case here.

>>
>> On a similar note, are there better ways as alternatives to the
>> sockets iterator approach.
>> Since we have BPF programs executed on cgroup BPF hooks (e.g.,
>> connect), we already know what client
>> sockets are connected to a backend. Can we somehow store these socket
>> pointers in a regular BPF map, and
>> when a backend is deleted, use a regular map iterator to invoke
>> sock_destroy() for these sockets? Does anyone have
>> experience using the "typed pointer support in BPF maps" APIs [0]?
> 
> I am not very familiar with how socket lifetime is managed, it may not
> be possible in case lifetime is managed by RCU only,
> or due to other limitations.
> Martin will probably be able to comment more on that.
sk is the usual refcnt+rcu_reader pattern.  afaik, the use case here is 
the sk should be removed from the map when there is a tcp_close() or 
udp_lib_close().  There is sock_map and sock_hash to store sk as the 
map-value.  iirc the sk will be automatically removed from the map 
during tcp_close() and udp_lib_close().  The sock_map and sock_hash have 
bpf iterator also.  Meaning a bpf-iter-prog can iterate the sock_map and 
sock_hash and then do abort on each sk, so it looks like most of the 
pieces are in place.

