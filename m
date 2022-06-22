Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E900C556DC0
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 23:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356964AbiFVVM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344588AbiFVVMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 17:12:55 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96BAB4;
        Wed, 22 Jun 2022 14:12:51 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 1ABC64000B;
        Wed, 22 Jun 2022 21:12:47 +0000 (UTC)
Message-ID: <b89a4d69-9ec8-10f1-363a-523eb451ccf8@ovn.org>
Date:   Wed, 22 Jun 2022 23:12:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     i.maximets@ovn.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
References: <20220619003919.394622-1-i.maximets@ovn.org>
 <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc>
 <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
 <c7ab4a7b-a987-e74b-dd2d-ee2c8ca84147@ovn.org>
 <CANn89iLxqae9wZ-h5M-whSsmAZ_7hW1e_=krvSyF8x89Y6o76w@mail.gmail.com>
 <068ad894-c60f-c089-fd4a-5deda1c84cdd@ovn.org>
 <CANn89iJ=Xc57pdZ-NaRF7FXZnq2skh5MJ3aDtDCGp8RNG4oowA@mail.gmail.com>
 <CANn89i+yy3mL2BUT=uhhkACVviWXCA9fdE1mrG=ZMuSQKdK8SQ@mail.gmail.com>
 <CANn89iLVHAE5aMwo0dow14mdFK0JjokE9y5KV+67AxKJdSjx=w@mail.gmail.com>
 <CANn89i+5pWbXyFBnMqdfz6SqRV9enFNHbcd_2irJub1Ag7vxNw@mail.gmail.com>
 <673a6f2b-dab2-e00f-b37c-15f8775b2121@ovn.org>
 <CANn89i+a6nd=80X-7p+GLq9Tvx7QjRYHkHVJgrjJu_UO30+SDQ@mail.gmail.com>
 <CANn89i+en=eU3L1kCcn41+-MRuoge0KHwcLHY3ah8TRmLMaMvg@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
In-Reply-To: <CANn89i+en=eU3L1kCcn41+-MRuoge0KHwcLHY3ah8TRmLMaMvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 21:27, Eric Dumazet wrote:
> On Wed, Jun 22, 2022 at 9:04 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Wed, Jun 22, 2022 at 8:19 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>>>
>>> On 6/22/22 19:03, Eric Dumazet wrote:
>>>> On Wed, Jun 22, 2022 at 6:47 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>
>>>>> On Wed, Jun 22, 2022 at 6:39 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>
>>>>>> On Wed, Jun 22, 2022 at 6:29 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>>
>>>>>>> On Wed, Jun 22, 2022 at 4:26 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>>>>>>>>
>>>>>>>> On 6/22/22 13:43, Eric Dumazet wrote:
>>>>>>>
>>>>>>>>
>>>>>>>> I tested the patch below and it seems to fix the issue seen
>>>>>>>> with OVS testsuite.  Though it's not obvious for me why this
>>>>>>>> happens.  Can you explain a bit more?
>>>>>>>
>>>>>>> Anyway, I am not sure we can call nf_reset_ct(skb) that early.
>>>>>>>
>>>>>>> git log seems to say that xfrm check needs to be done before
>>>>>>> nf_reset_ct(skb), I have no idea why.
>>>>>>
>>>>>> Additional remark: In IPv6 side, xfrm6_policy_check() _is_ called
>>>>>> after nf_reset_ct(skb)
>>>>>>
>>>>>> Steffen, do you have some comments ?
>>>>>>
>>>>>> Some context:
>>>>>> commit b59c270104f03960069596722fea70340579244d
>>>>>> Author: Patrick McHardy <kaber@trash.net>
>>>>>> Date:   Fri Jan 6 23:06:10 2006 -0800
>>>>>>
>>>>>>     [NETFILTER]: Keep conntrack reference until IPsec policy checks are done
>>>>>>
>>>>>>     Keep the conntrack reference until policy checks have been performed for
>>>>>>     IPsec NAT support. The reference needs to be dropped before a packet is
>>>>>>     queued to avoid having the conntrack module unloadable.
>>>>>>
>>>>>>     Signed-off-by: Patrick McHardy <kaber@trash.net>
>>>>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>>>>
>>>>>
>>>>> Oh well... __xfrm_policy_check() has :
>>>>>
>>>>> nf_nat_decode_session(skb, &fl, family);
>>>>>
>>>>> This  answers my questions.
>>>>>
>>>>> This means we are probably missing at least one XFRM check in TCP
>>>>> stack in some cases.
>>>>> (Only after adding this XFRM check we can call nf_reset_ct(skb))
>>>>>
>>>>
>>>> Maybe this will help ?
>>>
>>> I tested this patch and it seems to fix the OVS problem.
>>> I did not test the xfrm part of it.
>>>
>>> Will you post an official patch?
>>
>> Yes I will. I need to double check we do not leak either the req, or the child.
>>
>> Maybe the XFRM check should be done even earlier, on the listening socket ?
>>
>> Or if we assume the SYNACK packet has been sent after the XFRM test
>> has been applied to the SYN,
>> maybe we could just call nf_reset_ct(skb) to lower risk of regressions.
>>
>> With the last patch, it would be strange that we accept the 3WHS and
>> establish a socket,
>> but drop the payload in the 3rd packet...
> 
> Ilya, can you test the following patch ?

Tested with OVS and it works fine, the issue doesn't appear.
Still didn't test the xfrm part, as I'm not sure how.

> I think it makes more sense to let XFRM reject the packet earlier, and
> not complete the 3WHS,
> if for some reason this happens.

OK.  However, now the patch looks more like two separate fixes.

> 
> Thanks !
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fe8f23b95d32ca4a35d05166d471327bc608fa91..da5a3c44c4fb70f1d3ecc596e694a86267f1c44a
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1964,7 +1964,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
>                 struct sock *nsk;
> 
>                 sk = req->rsk_listener;
> -               drop_reason = tcp_inbound_md5_hash(sk, skb,
> +               if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
> +                       drop_reason = SKB_DROP_REASON_XFRM_POLICY;
> +               else
> +                       drop_reason = tcp_inbound_md5_hash(sk, skb,
>                                                    &iph->saddr, &iph->daddr,
>                                                    AF_INET, dif, sdif);
>                 if (unlikely(drop_reason)) {
> @@ -2016,6 +2019,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
>                         }
>                         goto discard_and_relse;
>                 }
> +               nf_reset_ct(skb);
>                 if (nsk == sk) {
>                         reqsk_put(req);
>                         tcp_v4_restore_cb(skb);

