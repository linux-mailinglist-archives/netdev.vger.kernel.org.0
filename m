Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C445BFDF6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiIUMdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiIUMd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:33:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E0997B1E;
        Wed, 21 Sep 2022 05:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=vu5ZCp69JdqfPWDAcJAXGIw2qHc/R/2VKv4uEZwfJN8=; b=2sAxY+anZZJIveEyE26DivaJpJ
        F1cVwdbGr+gh7NbBt8eUZXQcyGMNBCszM+kTydBAsDjt5kSCTjzV/mkeoOKWN/KXUVxQzl87vVr53
        OPnRHwkk6ZPcEFbw8xxvU8dNja1mfK7UIAfhgdn+PXqTYITA1XlpRFVvbPwcD7ECOGd1KMmErnfmI
        bMPoIpsIGFEnHsJntW756+9l7Uklx/uIU2i8ZlKrsAC6fDsmKSM0PdIi2ZLVF4J6ytjRa6U18GLhE
        8JGdIOmdTJDAxS1wT9rhVq93VZRJSgPIguDa61LUZXM9PuL1fPhyO1+YNf6hkpGzAd069E1JFRLyS
        PJiM5FYUiD/9ijk6ubpmfaTJW8MvjAT1iU6aS9l2mhbWNwuGpS2Fe89TKi1i/6OrVQWEOm3dJm+IG
        3WlwLZHj6WK2gewX1H19JFKJXiC17sL9lT+PKQHCeERu/JpuZfExQRrvA2G0+vSs3P+QZn/2R13WK
        Vwp0oZMQQLirpmghdrZ3/nNQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oayup-001Lce-03; Wed, 21 Sep 2022 12:33:23 +0000
Message-ID: <707e5141-aeeb-f54d-46d4-6a7575bfbc4d@samba.org>
Date:   Wed, 21 Sep 2022 14:33:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1663363798.git.metze@samba.org>
 <76cdd53f618e2793e1ec298c837bb17c3b9f12ee.1663363798.git.metze@samba.org>
 <5f4059ca-cec6-e44a-ac61-b9c034b1be77@gmail.com>
 <aa7d5f95-06d0-7e87-b41f-92fe07440b47@samba.org>
 <33fb5be7-6c79-46d9-ddf9-92071a5271c5@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 5/5] io_uring/notif: let userspace know how effective the
 zero copy usage was
In-Reply-To: <33fb5be7-6c79-46d9-ddf9-92071a5271c5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.09.22 um 14:04 schrieb Pavel Begunkov:
> On 9/17/22 11:24, Stefan Metzmacher wrote:
>> Am 17.09.22 um 11:22 schrieb Pavel Begunkov:
>>> On 9/16/22 22:36, Stefan Metzmacher wrote:
>>>> The 2nd cqe for IORING_OP_SEND_ZC has IORING_CQE_F_NOTIF set in cqe->flags
>>>> and it will now have the number of successful completed
>>>> io_uring_tx_zerocopy_callback() callbacks in the lower 31-bits
>>>> of cqe->res, the high bit (0x80000000) is set when
>>>> io_uring_tx_zerocopy_callback() was called with success=false.
>>>
>>> It has a couple of problems, and because that "simplify uapi"
>>> patch is transitional it doesn't go well with what I'm queuing
>>> for 6.1, let's hold it for a while.
>>
>> Once the current behavior gets released stable, we're no
>> longer able to change the meaning of cqe.res.
>>
>> As cqe.res == 0 would mean zero copy wasn't used at all,
>> which would be the indication for userspace to avoid using SEND_ZC.
>>
>> But if 6.0 would always return cqe.res = 0, there's no chance for
>> userspace to have a detection strategy.
>>
>> And I don't think it will cause a lot of trouble for your 6.1 stuff (assuming
>> you mean your SENDMSG_ZC code), I was already having that on top
>> of my test branches, the current one is:
>> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-6.0.0-rc5-metze.08
> 
> Not that one though, 1) I want to shrink ubuf_info as we're a bit out
> of space on the io_uring side and it prevents some embedding, so there
> won't be additional fields you used. And 2) we want to have a feature
> merging completion + notif CQEs into one (useful for UDP and some TCP
> cases), but that would mean we'll be using cqe->res for the normal
> return value.

But wouldn't that just don't have the MORE flag set, and be just
like IO_SEND?

> We can disable the success counting in this case, but it's not nice,
> and we can't actually count in io_uring_tx_zerocopy_callback() as in
> the patch (racy). Also, the callback will be called multiple times for
> a number of different reasons like io_uring flush or net splitting skbs.
> The number won't be much useful and unnecessary exposes internal details,
> so I think F_COPIED in cqe->flags is a better option.

Ok, that's better than nothing.

> It's a good question though whether we need more versatile reporting and
> how to do it right. Probably should be optional and not a part of IO path,
> e.g. send(MSG_PROBE) / ioctl / proc stats / etc.
> 
>> I plan to test SENDMSG_ZC with Samba next week.
> 
> Awesome

Currently I'm fighting with converting samba's libtevent to
use POLL_ADD and io_uring_submit_and_wait_timeout().
Which turns out to be much more complex that it should be.
And IORING_POLL_ADD_LEVEL doesn't seem to work at all...
But I'll write a separate mail about my findings in that area...

metze

