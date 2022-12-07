Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2546462FA
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLGVIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLGVIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:08:44 -0500
Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183A2716E7
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:08:42 -0800 (PST)
Message-ID: <dbf316a8-7a26-c161-4009-fd0528fbf6f2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670447320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1Z1+SgkfL777/y/++qbqNSavwo8xO4iHJsNFFTO5NA=;
        b=T8mBvK7npvO07cUxkVfk2RSJYLG8m2t/0MhW80kknb5s20/bhsguHbVjPPTviBzQ1EnEyt
        KH/L7Laaulxx5fM1bVXqdW/OsdjkJlXeeDq8Qpmq0E2/2XaEXMj1qvH9Oi3qxwT9ovhrOZ
        0QAwr/hQTXWg/pZHToUdFhPh/UYuFIE=
Date:   Wed, 7 Dec 2022 13:08:27 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
Content-Language: en-US
To:     Ji Rongfeng <SikoJobs@outlook.com>
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
 <deb77161-3091-a134-4b82-78fef06efe85@linux.dev>
 <DU0P192MB1547DA9F22139A0B09FF5877D61A9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <DU0P192MB1547DA9F22139A0B09FF5877D61A9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/22 3:19 AM, Ji Rongfeng wrote:
> On 2022/12/7 2:36, Martin KaFai Lau wrote:
>> On 12/2/22 9:39 AM, Ji Rongfeng wrote:
>>> Returning -EINVAL almost all the time when error occurs is not very
>>> helpful for the bpf prog to figure out what is wrong. This patch
>>> upgrades some return values so that they will be much more helpful.
>>>
>>> * return -ENOPROTOOPT when optname is unsupported
>>>
>>>    The same as {g,s}etsockopt() syscall does. Before this patch,
>>>    bpf_setsockopt(TCP_SAVED_SYN) already returns -ENOPROTOOPT, which
>>>    may confuse the user, as -EINVAL is returned on other unsupported
>>>    optnames. This patch also rejects TCP_SAVED_SYN right in
>>>    sol_tcp_sockopt() when getopt is false, since do_tcp_setsockopt()
>>>    is just the executor and it's not its duty to discover such error
>>>    in bpf. We should maintain a precise allowlist to control whether
>>>    an optname is supported and allowed to enter the executor or not.
>>>    Functions like do_tcp_setsockopt(), their behaviour are not fully
>>>    controllable by bpf. Imagine we let an optname pass, expecting
>>>    -ENOPROTOOPT will be returned, but someday that optname is
>>>    actually processed and unfortunately causes deadlock when calling
>>>    from bpf. Thus, precise access control is essential.
>>
>> Please leave the current -EINVAL to distinguish between optnames rejected by 
>> bpf and optnames rejected by the do_*_{get,set}sockopt().
> 
> To reach that goal, it would be better for us to pick a value other than 
> -ENOPROTOOPT or -EINVAL. This patch actually makes sk-related errors, 
> level-reletad errors, optname-related errors and opt{val,len}-related errors 
> distinguishable, as they should be, by leaving -EINVAL to opt{val,len}-related 
> errors only. man setsockopt:
> 
>  > EINVAL optlen invalid in setsockopt().  In some cases this error
>  >        can also occur for an invalid value in optval (e.g., for
>  >        the IP_ADD_MEMBERSHIP option described in ip(7)).
> 
> With an unique return value, the bpf prog developer will be able to know that 
> the error is "unsupported or unknown optname" for sure, saving time on figuring 
> the actual cause of the error. In production environment, the bpf prog will be 
> able to test whether an optname is available in current bpf env and decide what 
> to do next also, which is very useful.

It should be a non-goal for bpf_{set,get}sockopt to provide this level of 
granularity (optlevel vs optname vs optlen) at this point when it requires this 
kind of churns on the existing return values.  It is not like there is a lot of 
optname that supports non integer optlen.  This should not be a limit factor if 
the userspace wants to probe what optname is supported.  Hence, not convinced it 
is needed.  I would like to hear how others think.

If optname is not something that bpf_{set,get}sockopt rejects, it should then 
rely on the do_*_{get,set}sockopt for handling which includes the error value.

For TCP_SAVED_SYN, tbh, it is too hypothetical that the do_tcp_setsockopt will 
have a reasonable use case to ever support it.  If it did, we would make it 
available to the bpf also because the bpf_getsockopt(TCP_SAVED_SYN) has already 
been supported instead of now worrying about blacklisting it for the future.

-EBADFD will be useful because the same level, optname, optval, and optlen will 
fail because of different sk.
