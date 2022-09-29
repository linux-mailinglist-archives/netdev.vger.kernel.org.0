Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC395EEDC4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiI2GSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbiI2GSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:18:01 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5355E12968C;
        Wed, 28 Sep 2022 23:17:44 -0700 (PDT)
Message-ID: <4e6e14e4-7301-9981-c52f-7715f26f63f3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664432262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=leoja3tLYvuGjML3vnPhoqeOaWUjA8ZGSBxgJ7z0bZc=;
        b=eRkSpbv1JCEMJ29ENuARH50C63WgLKS0RxvCyY/UpeZFd14wvusG9LwyUKOAn1gPpG60Zi
        QRgaQWNWMoN0cMO08AnVSKfyDhfzIp7hpfPNfExtliLDAQjFudQCGadRlL+sz5Ns4vvOey
        iCErjpaNxLTnZyQVs9z39qD6+/7oDKo=
Date:   Wed, 28 Sep 2022 23:17:38 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 bpf-next 4/5] bpf: tcp: Stop
 bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>, Paolo Abeni <pabeni@redhat.com>
References: <20220923224453.2351753-1-kafai@fb.com>
 <20220923224518.2353383-1-kafai@fb.com>
 <CANn89iLf+=AmMntTqy0HyOfbv6PASLsT+E4PhXMAX+xU1Zh2Yg@mail.gmail.com>
 <e529a40f-4c77-834e-3ac8-b58763b58993@linux.dev>
 <CANn89i+7G7kkN5mG=tEOd4xHAV7LyLQ7yj2a4hjsGb1_gFQ82A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CANn89i+7G7kkN5mG=tEOd4xHAV7LyLQ7yj2a4hjsGb1_gFQ82A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 10:37 PM, Eric Dumazet wrote:
> On Wed, Sep 28, 2022 at 10:31 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 9/28/22 7:04 PM, Eric Dumazet wrote:
>>> On Fri, Sep 23, 2022 at 3:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>>
>>>> From: Martin KaFai Lau <martin.lau@kernel.org>
>>>>
>>>> When a bad bpf prog '.init' calls
>>>> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
>>>>
>>>> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
>>>> ... => .init => bpf_setsockopt(tcp_cc).
>>>>
>>>> It was prevented by the prog->active counter before but the prog->active
>>>> detection cannot be used in struct_ops as explained in the earlier
>>>> patch of the set.
>>>>
>>>> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
>>>> in order to break the loop.  This is done by using a bit of
>>>> an existing 1 byte hole in tcp_sock to check if there is
>>>> on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.
>>>>
>>>> Note that this essentially limits only the first '.init' can
>>>> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
>>>> does not support ECN) and the second '.init' cannot fallback to
>>>> another cc.  This applies even the second
>>>> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
>>>>
>>>> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
>>>> ---
>>>>    include/linux/tcp.h |  6 ++++++
>>>>    net/core/filter.c   | 28 +++++++++++++++++++++++++++-
>>>>    2 files changed, 33 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>>>> index a9fbe22732c3..3bdf687e2fb3 100644
>>>> --- a/include/linux/tcp.h
>>>> +++ b/include/linux/tcp.h
>>>> @@ -388,6 +388,12 @@ struct tcp_sock {
>>>>           u8      bpf_sock_ops_cb_flags;  /* Control calling BPF programs
>>>>                                            * values defined in uapi/linux/tcp.h
>>>>                                            */
>>>> +       u8      bpf_chg_cc_inprogress:1; /* In the middle of
>>>> +                                         * bpf_setsockopt(TCP_CONGESTION),
>>>> +                                         * it is to avoid the bpf_tcp_cc->init()
>>>> +                                         * to recur itself by calling
>>>> +                                         * bpf_setsockopt(TCP_CONGESTION, "itself").
>>>> +                                         */
>>>>    #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) (TP->bpf_sock_ops_cb_flags & ARG)
>>>>    #else
>>>>    #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>> index 96f2f7a65e65..ac4c45c02da5 100644
>>>> --- a/net/core/filter.c
>>>> +++ b/net/core/filter.c
>>>> @@ -5105,6 +5105,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
>>>>    static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
>>>>                                         int *optlen, bool getopt)
>>>>    {
>>>> +       struct tcp_sock *tp;
>>>> +       int ret;
>>>> +
>>>>           if (*optlen < 2)
>>>>                   return -EINVAL;
>>>>
>>>> @@ -5125,8 +5128,31 @@ static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
>>>>           if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
>>>>                   return -ENOTSUPP;
>>>>
>>>> -       return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
>>>> +       /* It stops this looping
>>>> +        *
>>>> +        * .init => bpf_setsockopt(tcp_cc) => .init =>
>>>> +        * bpf_setsockopt(tcp_cc)" => .init => ....
>>>> +        *
>>>> +        * The second bpf_setsockopt(tcp_cc) is not allowed
>>>> +        * in order to break the loop when both .init
>>>> +        * are the same bpf prog.
>>>> +        *
>>>> +        * This applies even the second bpf_setsockopt(tcp_cc)
>>>> +        * does not cause a loop.  This limits only the first
>>>> +        * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
>>>> +        * pick a fallback cc (eg. peer does not support ECN)
>>>> +        * and the second '.init' cannot fallback to
>>>> +        * another.
>>>> +        */
>>>> +       tp = tcp_sk(sk);
>>>> +       if (tp->bpf_chg_cc_inprogress)
>>>> +               return -EBUSY;
>>>> +
>>>
>>> Is the socket locked (and owned by current thread) at this point ?
>>> If not, changing bpf_chg_cc_inprogress would be racy.
>>
>> Yes, the socket is locked and owned.  There is a sock_owned_by_me check earlier
>> in _bpf_setsockopt().
> 
> Good to know. Note a listener can be cloned without socket lock being held.
> 
> In order to avoid surprises, I would clear bpf_chg_cc_inprogress in
> tcp_create_openreq_child()

Ah, make sense.  I will re-spin.
