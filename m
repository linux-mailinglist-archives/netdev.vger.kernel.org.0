Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B15EED40
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiI2FbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiI2FbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:31:13 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1BCD589A;
        Wed, 28 Sep 2022 22:31:11 -0700 (PDT)
Message-ID: <e529a40f-4c77-834e-3ac8-b58763b58993@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664429469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEvqVlo0Zzjep4fx+xvVD56xNa3RFMj1Hz5Uj5KHcZQ=;
        b=jUr/e6rW3jlTd6rTkV6g855vqjGTCip91CTMu/MvSNMeafol8wDy//ZPMv6Hax8Qr9cquD
        XgCnwSx/+QYTeW4l5N62am77yMU9Q++S2JgThJHJyEFmJkm5vcWJWGQSmkvBweKB3t3L4q
        RL019u/jHcC5ebCiSdxBefdUHlaIOMk=
Date:   Wed, 28 Sep 2022 22:31:04 -0700
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
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <20220923224453.2351753-1-kafai@fb.com>
 <20220923224518.2353383-1-kafai@fb.com>
 <CANn89iLf+=AmMntTqy0HyOfbv6PASLsT+E4PhXMAX+xU1Zh2Yg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CANn89iLf+=AmMntTqy0HyOfbv6PASLsT+E4PhXMAX+xU1Zh2Yg@mail.gmail.com>
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

On 9/28/22 7:04 PM, Eric Dumazet wrote:
> On Fri, Sep 23, 2022 at 3:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> From: Martin KaFai Lau <martin.lau@kernel.org>
>>
>> When a bad bpf prog '.init' calls
>> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
>>
>> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
>> ... => .init => bpf_setsockopt(tcp_cc).
>>
>> It was prevented by the prog->active counter before but the prog->active
>> detection cannot be used in struct_ops as explained in the earlier
>> patch of the set.
>>
>> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
>> in order to break the loop.  This is done by using a bit of
>> an existing 1 byte hole in tcp_sock to check if there is
>> on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.
>>
>> Note that this essentially limits only the first '.init' can
>> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
>> does not support ECN) and the second '.init' cannot fallback to
>> another cc.  This applies even the second
>> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
>>
>> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
>> ---
>>   include/linux/tcp.h |  6 ++++++
>>   net/core/filter.c   | 28 +++++++++++++++++++++++++++-
>>   2 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>> index a9fbe22732c3..3bdf687e2fb3 100644
>> --- a/include/linux/tcp.h
>> +++ b/include/linux/tcp.h
>> @@ -388,6 +388,12 @@ struct tcp_sock {
>>          u8      bpf_sock_ops_cb_flags;  /* Control calling BPF programs
>>                                           * values defined in uapi/linux/tcp.h
>>                                           */
>> +       u8      bpf_chg_cc_inprogress:1; /* In the middle of
>> +                                         * bpf_setsockopt(TCP_CONGESTION),
>> +                                         * it is to avoid the bpf_tcp_cc->init()
>> +                                         * to recur itself by calling
>> +                                         * bpf_setsockopt(TCP_CONGESTION, "itself").
>> +                                         */
>>   #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) (TP->bpf_sock_ops_cb_flags & ARG)
>>   #else
>>   #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 96f2f7a65e65..ac4c45c02da5 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -5105,6 +5105,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
>>   static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
>>                                        int *optlen, bool getopt)
>>   {
>> +       struct tcp_sock *tp;
>> +       int ret;
>> +
>>          if (*optlen < 2)
>>                  return -EINVAL;
>>
>> @@ -5125,8 +5128,31 @@ static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
>>          if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
>>                  return -ENOTSUPP;
>>
>> -       return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
>> +       /* It stops this looping
>> +        *
>> +        * .init => bpf_setsockopt(tcp_cc) => .init =>
>> +        * bpf_setsockopt(tcp_cc)" => .init => ....
>> +        *
>> +        * The second bpf_setsockopt(tcp_cc) is not allowed
>> +        * in order to break the loop when both .init
>> +        * are the same bpf prog.
>> +        *
>> +        * This applies even the second bpf_setsockopt(tcp_cc)
>> +        * does not cause a loop.  This limits only the first
>> +        * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
>> +        * pick a fallback cc (eg. peer does not support ECN)
>> +        * and the second '.init' cannot fallback to
>> +        * another.
>> +        */
>> +       tp = tcp_sk(sk);
>> +       if (tp->bpf_chg_cc_inprogress)
>> +               return -EBUSY;
>> +
> 
> Is the socket locked (and owned by current thread) at this point ?
> If not, changing bpf_chg_cc_inprogress would be racy.

Yes, the socket is locked and owned.  There is a sock_owned_by_me check earlier 
in _bpf_setsockopt().

> 
> 
>> +       tp->bpf_chg_cc_inprogress = 1;
>> +       ret = do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
>>                                  KERNEL_SOCKPTR(optval), *optlen);
>> +       tp->bpf_chg_cc_inprogress = 0;
>> +       return ret;
>>   }
>>
>>   static int sol_tcp_sockopt(struct sock *sk, int optname,
>> --
>> 2.30.2
>>

