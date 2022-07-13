Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA67574028
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiGMXps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGMXpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:45:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FEA419BF;
        Wed, 13 Jul 2022 16:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 370B561B47;
        Wed, 13 Jul 2022 23:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF22C3411E;
        Wed, 13 Jul 2022 23:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657755945;
        bh=EVrjEqKWBDsWAGl8SZNcPub4UIoDCewTBWArMH4yHkY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qb0uqohBiKJ9u/DCEyPWejLejudk2uHDj1f9OuLNZVRX4NOJPUD1ucmXJ7+iF9mqs
         839/AnN1aqIW9E2jaGTbYdVkHGF6LI/2mKCSppcDIptnF4OJ1yyNhUVt97jjOpX7WL
         9NIvteh8P8v4OK702QDaLDXELrzhVOBVrKg9rGqMjffv3Usct43SC9bM97au1NFwub
         iFba/wTSQkyqWogm0qChvc/DMbp5PG/Ul5lcUBDy3tkudJe8XmTcodGRkjlyUrk3nV
         CHg4pqK+aiS5Mhq3gMn/4P5xhJcpVthjRdWh+P4qd6iRlb+XXX4j61Y45xpkv1k9ze
         lAHxYvKasR28Q==
Message-ID: <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
Date:   Wed, 13 Jul 2022 16:45:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
 <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/22 5:56 AM, Pavel Begunkov wrote:
> On 7/8/22 15:26, Pavel Begunkov wrote:
>> On 7/8/22 05:10, David Ahern wrote:
>>> On 7/7/22 5:49 AM, Pavel Begunkov wrote:
>>>> NOTE: Not be picked directly. After getting necessary acks, I'll be
>>>> working
>>>>        out merging with Jakub and Jens.
>>>>
>>>> The patchset implements io_uring zerocopy send. It works with both
>>>> registered
>>>> and normal buffers, mixing is allowed but not recommended. Apart
>>>> from usual
>>>> request completions, just as with MSG_ZEROCOPY, io_uring separately
>>>> notifies
>>>> the userspace when buffers are freed and can be reused (see API
>>>> design below),
>>>> which is delivered into io_uring's Completion Queue. Those
>>>> "buffer-free"
>>>> notifications are not necessarily per request, but the userspace has
>>>> control
>>>> over it and should explicitly attaching a number of requests to a
>>>> single
>>>> notification. The series also adds some internal optimisations when
>>>> used with
>>>> registered buffers like removing page referencing.
>>>>
>>>>  From the kernel networking perspective there are two main changes.
>>>> The first
>>>> one is passing ubuf_info into the network layer from io_uring
>>>> (inside of an
>>>> in kernel struct msghdr). This allows extra optimisations, e.g.
>>>> ubuf_info
>>>> caching on the io_uring side, but also helps to avoid cross-referencing
>>>> and synchronisation problems. The second part is an optional
>>>> optimisation
>>>> removing page referencing for requests with registered buffers.
>>>>
>>>> Benchmarking with an optimised version of the selftest (see [1]),
>>>> which sends
>>>> a bunch of requests, waits for completions and repeats. "+ flush"
>>>> column posts
>>>> one additional "buffer-free" notification per request, and just "zc"
>>>> doesn't
>>>> post buffer notifications at all.
>>>>
>>>> NIC (requests / second):
>>>> IO size | non-zc    | zc             | zc + flush
>>>> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
>>>> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
>>>> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
>>>> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
>>>>
>>>> dummy (requests / second):
>>>> IO size | non-zc    | zc             | zc + flush
>>>> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
>>>> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
>>>> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
>>>> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
>>>>
>>>> Previously it also brought a massive performance speedup compared to
>>>> the
>>>> msg_zerocopy tool (see [3]), which is probably not super interesting.
>>>>
>>>
>>> can you add a comment that the above results are for UDP.
>>
>> Oh, right, forgot to add it
>>
>>
>>> You dropped comments about TCP testing; any progress there? If not, can
>>> you relay any issues you are hitting?
>>
>> Not really a problem, but for me it's bottle necked at NIC bandwidth
>> (~3GB/s) for both zc and non-zc and doesn't even nearly saturate a CPU.
>> Was actually benchmarked by my colleague quite a while ago, but can't
>> find numbers. Probably need to at least add localhost numbers or grab
>> a better server.
> 
> Testing localhost TCP with a hack (see below), it doesn't include
> refcounting optimisations I was testing UDP with and that will be
> sent afterwards. Numbers are in MB/s
> 
> IO size | non-zc    | zc
> 1200    | 4174      | 4148
> 4096    | 7597      | 11228

I am surprised by the low numbers; you should be able to saturate a 100G
link with TCP and ZC TX API.

> 
> Because it's localhost, we also spend cycles here for the recv side.
> Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
> omitted optimisations will somewhat help. I don't consider it to be a
> blocker. but would be interesting to poke into later. One thing helping
> non-zc is that it squeezes a number of requests into a single page
> whenever zerocopy adds a new frag for every request.
> 
> Can't say anything new for larger payloads, I'm still NIC-bound but
> looking at CPU utilisation zc doesn't drain as much cycles as non-zc.
> Also, I don't remember if mentioned before, but another catch is that
> with TCP it expects users to not be flushing notifications too much,
> because it forces it to allocate a new skb and lose a good chunk of
> benefits from using TCP.

I had issues with TCP sockets and io_uring at the end of 2020:
https://www.spinics.net/lists/io-uring/msg05125.html

have not tried anything recent (from 2022).

