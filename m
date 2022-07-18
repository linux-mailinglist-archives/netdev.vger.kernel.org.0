Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DAE577999
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 04:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiGRCTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 22:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiGRCTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 22:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F072DEA8;
        Sun, 17 Jul 2022 19:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA78A61117;
        Mon, 18 Jul 2022 02:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2160C3411E;
        Mon, 18 Jul 2022 02:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658110762;
        bh=1Xu5kv9Vaj48OhBfO2C5bpnImS1ZSkJcwzDbJu5BTDQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JxyKOmhuOVtfQWNQZYXQxBpgYR72OVijtbLe9Zuna3bNU3m/WjG21N7mPrNcUPZfQ
         WLfdEoxH7Z86Uv76fnH8lv0l4LJ9KlQNyXORyq+rLRgb3Y8zKHGjvU+beoxE22oUXe
         +HC57lY9CC9iHo/p2TLZKkYP9cjx0RrKPlasmctPfVHzg2gaNGu9fvAbyLj59piNoY
         SyEo1ODpgk8adT0DcXOvKgCKe4H5iBTjoYq4bJzcg6jdjcT0P2y0s/sTiChO7lxKRF
         U17n89cyO8GdBZDuZS3uchBopAhgR32rC4TfgcMV/+5TfN5hJzp2xn4MWDkSfGCHYB
         JJfifVQwP5r0A==
Message-ID: <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
Date:   Sun, 17 Jul 2022 20:19:20 -0600
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
 <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
 <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/22 12:55 PM, Pavel Begunkov wrote:
>>>>> You dropped comments about TCP testing; any progress there? If not,
>>>>> can
>>>>> you relay any issues you are hitting?
>>>>
>>>> Not really a problem, but for me it's bottle necked at NIC bandwidth
>>>> (~3GB/s) for both zc and non-zc and doesn't even nearly saturate a CPU.
>>>> Was actually benchmarked by my colleague quite a while ago, but can't
>>>> find numbers. Probably need to at least add localhost numbers or grab
>>>> a better server.
>>>
>>> Testing localhost TCP with a hack (see below), it doesn't include
>>> refcounting optimisations I was testing UDP with and that will be
>>> sent afterwards. Numbers are in MB/s
>>>
>>> IO size | non-zc    | zc
>>> 1200    | 4174      | 4148
>>> 4096    | 7597      | 11228
>>
>> I am surprised by the low numbers; you should be able to saturate a 100G
>> link with TCP and ZC TX API.
> 
> It was a quick test with my laptop, not a super fast CPU, preemptible
> kernel, etc., and considering that the fact that it processes receives
> from in the same send syscall roughly doubles the overhead, 87Gb/s
> looks ok. It's not like MSG_ZEROCOPY would look much different, even
> more to that all sends here will be executed sequentially in io_uring,
> so no extra parallelism or so. As for 1200, I think 4GB/s is reasonable,
> it's just the kernel overhead per byte is too high, should be same with
> just send(2).

?
It's a stream socket so those sends are coalesced into MTU sized packets.

> 
>>> Because it's localhost, we also spend cycles here for the recv side.
>>> Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
>>> omitted optimisations will somewhat help. I don't consider it to be a
>>> blocker. but would be interesting to poke into later. One thing helping
>>> non-zc is that it squeezes a number of requests into a single page
>>> whenever zerocopy adds a new frag for every request.
>>>
>>> Can't say anything new for larger payloads, I'm still NIC-bound but
>>> looking at CPU utilisation zc doesn't drain as much cycles as non-zc.
>>> Also, I don't remember if mentioned before, but another catch is that
>>> with TCP it expects users to not be flushing notifications too much,
>>> because it forces it to allocate a new skb and lose a good chunk of
>>> benefits from using TCP.
>>
>> I had issues with TCP sockets and io_uring at the end of 2020:
>> https://www.spinics.net/lists/io-uring/msg05125.html
>>
>> have not tried anything recent (from 2022).
> 
> Haven't seen it back then. In general io_uring doesn't stop submitting
> requests if one request fails, at least because we're trying to execute
> requests asynchronously. And in general, requests can get executed
> out of order, so most probably submitting a bunch of requests to a single
> TCP sock without any ordering on io_uring side is likely a bug.

TCP socket buffer fills resulting in a partial send (i.e, for a given
sqe submission only part of the write/send succeeded). io_uring was not
handling that case.

I'll try to find some time to resurrect the iperf3 patch and try top of
tree kernel.

> 
> You can link io_uring requests, i.e. IOSQE_IO_LINK, guaranteeing
> execution ordering. And if you meant links in the message, I agree
> that it was not the best decision to consider len < sqe->len not
> an error and not breaking links, but it was later added that
> MSG_WAITALL would also change the success condition to
> len==sqe->len. But all that is relevant if you was using linking.
> 

