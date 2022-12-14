Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DC864D35B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLNX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiLNXZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:25:56 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457E4532CD;
        Wed, 14 Dec 2022 15:23:56 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p5b6D-000FQx-Kx; Thu, 15 Dec 2022 00:23:41 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1p5b6D-0002pw-1z; Thu, 15 Dec 2022 00:23:41 +0100
Subject: Re: [PATCH net] filter: Account for tail adjustment during pull
 operations
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>,
        ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
        john.fastabend@gmail.com, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Sean Tranchetti <quic_stranche@quicinc.com>
References: <1670906381-25161-1-git-send-email-quic_subashab@quicinc.com>
 <4d598e55-0366-5a27-2dd5-d7b59758b5fc@iogearbox.net>
 <38c438ca-2a3f-18d0-03eb-1fa846e2075e@quicinc.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7bacb02c-659c-7921-a15d-8c758bb49156@iogearbox.net>
Date:   Thu, 15 Dec 2022 00:23:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <38c438ca-2a3f-18d0-03eb-1fa846e2075e@quicinc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26750/Wed Dec 14 09:15:48 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/22 7:32 AM, Subash Abhinov Kasiviswanathan (KS) wrote:
> On 12/13/2022 3:42 PM, Daniel Borkmann wrote:
>> On 12/13/22 5:39 AM, Subash Abhinov Kasiviswanathan wrote:
>>> Extending the tail can have some unexpected side effects if a program is
>>> reading the content beyond the head skb headlen and all the skbs in the
>>> gso frag_list are linear with no head_frag -
>>>
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index bb0136e..d5f7f79 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -1654,6 +1654,20 @@ static DEFINE_PER_CPU(struct bpf_scratchpad, bpf_sp);
>>>   static inline int __bpf_try_make_writable(struct sk_buff *skb,
>>>                         unsigned int write_len)
>>>   {
>>> +    struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
>>> +
>>> +    if (skb_is_gso(skb) && list_skb && !list_skb->head_frag &&
>>> +        skb_headlen(list_skb)) {
>>> +        int headlen = skb_headlen(skb);
>>> +        int err = skb_ensure_writable(skb, write_len);
>>> +
>>> +        /* pskb_pull_tail() has occurred */
>>> +        if (!err && headlen != skb_headlen(skb))
>>> +            skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
>>> +
>>> +        return err;
>>> +    }
>>
>> __bpf_try_make_writable() does not look like the right location to me
>> given this is called also from various other places. bpf_skb_change_tail
>> has skb_gso_reset in there, potentially that or pskb_pull_tail itself
>> should mark it?
> 
> Actually the program we used had BPF_FUNC_skb_pull_data and we put this check in __bpf_try_make_writable so that it would help out BPF_FUNC_skb_pull_data & other users of __bpf_try_make_writable. Having the check in __pskb_pull_tail seems preferable though. Could you tell if the following is acceptable as this works for us -

Ah okay, that is good to know. The Fixes tag might have been misleading in that
case. From what you describe it sounds like a generic __pskb_pull_tail() issue
then? If so I'd go with the below for -net tree as a generic fix, yes.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index dfc14a7..0f60abb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2263,6 +2263,9 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
>                                  insp = list;
>                          } else {
>                                  /* Eaten partially. */
> +                               if (skb_is_gso(skb) && !list->head_frag &&
> +                                   skb_headlen(list))
> +                                       skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
> 
>                                  if (skb_shared(list)) {
>                                          /* Sucks! We need to fork list. :-( */
> 
>>
>>>       return skb_ensure_writable(skb, write_len);
>>>   }
>>>
>>

