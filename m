Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3F4B7786
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbiBOSrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:47:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243253AbiBOSrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:47:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA813206E;
        Tue, 15 Feb 2022 10:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC3661719;
        Tue, 15 Feb 2022 18:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CEFC340EB;
        Tue, 15 Feb 2022 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644950823;
        bh=kscKovcHd2nlQ0B0p+OkiWybB5K6IGKqiw3FP0tR73g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bZgNh/7E+ij5VtobYi835qErjEZ5CZIIWSw+rLFCeGkBtalOcAGX3VuMfBGh8/Fpy
         Z+dPTdLQBOPRwhcKCCoYqjGG4zZEfkTzL47ixHBYj58eQou4DtJd0qCkgcBMWiRQmO
         s+t2Ogh4W/J8YGy7rgYOQgsqh8sLFq8UdZnshCvOhSzx0REVacxP+FYkTS/yr/KPlK
         oEABv+tD5xRtI86zL5WT8vKBHvIBOLUwYwDnq2jSXpqq+j1BM1uJanDvjnklImh6fZ
         zVg/gv30VM+NEH20toivT9Prlwo1a0HCEqtAXKCn5bEQsCbHbymf+9UkumvlQci/dB
         lhfydPN0JyW0A==
Message-ID: <f626571a-30de-5549-a73e-aaef874d3c36@kernel.org>
Date:   Tue, 15 Feb 2022 11:47:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 01/19] net: tcp: introduce tcp_drop_reason()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
References: <20220215112812.2093852-1-imagedong@tencent.com>
 <20220215112812.2093852-2-imagedong@tencent.com>
 <CANn89iLWOBy=X1CpY+gvukhQ-bb7hDWd5y+m46K7o5XR0Pbt_A@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iLWOBy=X1CpY+gvukhQ-bb7hDWd5y+m46K7o5XR0Pbt_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/22 10:34 AM, Eric Dumazet wrote:
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index af94a6d22a9d..e3811afd1756 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -4684,10 +4684,19 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
>>         return res;
>>  }
>>
>> -static void tcp_drop(struct sock *sk, struct sk_buff *skb)
>> +static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
>> +                           enum skb_drop_reason reason)
>>  {
>>         sk_drops_add(sk, skb);
>> -       __kfree_skb(skb);
>> +       /* why __kfree_skb() used here before, other than kfree_skb()?
>> +        * confusing......
> 
> Do not add comments like that if you do not know the difference...
> 
> __kfree_skb() is used by TCP stack because it owns skb in receive
> queues, and avoids touching skb->users
> because it must be one already.

and it bypasses kfree_skb tracepoint which seems by design.
