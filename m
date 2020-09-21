Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55137271E8E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIUJJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 05:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgIUJJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 05:09:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717FAC061755;
        Mon, 21 Sep 2020 02:09:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w5so11877762wrp.8;
        Mon, 21 Sep 2020 02:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gPm/DBJ/Ie3GtXrU6BYGUr91B6TnWE9naWQoSMM/miA=;
        b=LGVgJG9B8/B4qIYgVxOE7j2+jT9FP/FR7IQrRlK0Qi50kUHdFDdL9zbCzGgKUrjpaV
         GikC86hF0bB1kSCzP6zx0KIoiFDw2S96n8dTYbX3yfmOIrDKhXXqwvKJfcKxVUF2ohWg
         tUVmpc1tDVNfiY7qO6KKL7YEeoaw3s/BeNYXv7tGwGH1LJk/3kqsfAgf6RXZEiHPH2q2
         8ljp+fuHKrgk6y8JYWHcLkQ/f18G3xaf+4JG5xIb9+plOyjf4UFVcLy3SZVIriSWNv7F
         HDyodw7y+qA974ahOa4MerB61SHtW2xfw4rOjoY5Xzv85OVJaRyO+BPTzFB7BmqBAuSe
         lGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gPm/DBJ/Ie3GtXrU6BYGUr91B6TnWE9naWQoSMM/miA=;
        b=NcN75i+obg5t4q9rF4LOaGyPIlEw8KEi75zuf0xSoxfQeA9DUtX95rghB14gKQ8lDF
         YorQssFzLSlPPbQ0Lar2/oWnW9WHtQufEF4cyowbZD0EdGounOzU4FCgu+ZfVsbqoMCS
         R4AtgCgsUo+3SIXKuepxFo9WSbUHHGRYAAr1JBieFi6yxUFl59xZC7fjXEa1U75s9PvI
         zsS927LFiTRE9FdbrTY4e7CBG2YzpudJ2HTUZapY/7HG0eihGqhAx6ndku7FOchfFCA6
         nHZJSaQrTqIUp2X8acg/2YrElgIcE85v1B6AAeFTZU5qwTxV/jEiG8i9STQBQGY62ueY
         nT3A==
X-Gm-Message-State: AOAM533vEHYyfoF7ckE8l1YWZ6oekomjYKKjX3QxglJ5CnVY8xy9YUkU
        MdiXvRp5zpoJBwz3041W2fg=
X-Google-Smtp-Source: ABdhPJyN4JG0y/Qyd6zCVk68IpOQp8nNkexhM0PckQh9DIp+RNN7uXsut8sunKfk6wOQ3qE9u/mmDw==
X-Received: by 2002:a5d:50cd:: with SMTP id f13mr47192241wrt.211.1600679356948;
        Mon, 21 Sep 2020 02:09:16 -0700 (PDT)
Received: from [192.168.8.147] ([37.166.243.203])
        by smtp.gmail.com with ESMTPSA id k22sm20854757wrd.29.2020.09.21.02.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 02:09:16 -0700 (PDT)
Subject: Re: [PATCH net-next] net: use in_softirq() to indicate the NAPI
 context in napi_consume_skb()
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linmiaohe <linmiaohe@huawei.com>, martin.varghese@nokia.com,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>, kyk.segfault@gmail.com,
        Saeed Mahameed <saeed@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
References: <1600653893-206277-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iLHH=CRzz5tavy_KEg0mhgXkhD9DBfh9bhcqSkcZ2xaaA@mail.gmail.com>
 <2102eba1-eeea-bf95-2df5-7fcfa3141694@huawei.com>
 <CANn89i+ADkkEFDM=zpm3nHu6XjcACwPrhvG-eZ8GfWot9eo57w@mail.gmail.com>
 <a5ac987f-eac5-a8c6-59db-aa383eb82598@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0c3e9d4c-8560-4409-b3ac-dff991a6094a@gmail.com>
Date:   Mon, 21 Sep 2020 11:09:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <a5ac987f-eac5-a8c6-59db-aa383eb82598@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/20 10:40 AM, Yunsheng Lin wrote:
> On 2020/9/21 16:17, Eric Dumazet wrote:
>> On Mon, Sep 21, 2020 at 10:10 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>
>>> On 2020/9/21 15:19, Eric Dumazet wrote:
>>>> On Mon, Sep 21, 2020 at 4:08 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>
>>>>> When napi_consume_skb() is called in the tx desc cleaning process,
>>>>> it is usually in the softirq context(BH disabled, or are processing
>>>>> softirqs), but it may also be in the task context, such as in the
>>>>> netpoll or loopback selftest process.
>>>>>
>>>>> Currently napi_consume_skb() uses non-zero budget to indicate the
>>>>> NAPI context, the driver writer may provide the wrong budget when
>>>>> tx desc cleaning function is reused for both NAPI and non-NAPI
>>>>> context, see [1].
>>>>>
>>>>> So this patch uses in_softirq() to indicate the NAPI context, which
>>>>> doesn't necessarily mean in NAPI context, but it shouldn't care if
>>>>> NAPI context or not as long as it runs in softirq context or with BH
>>>>> disabled, then _kfree_skb_defer() will push the skb to the particular
>>>>> cpu' napi_alloc_cache atomically.
>>>>>
>>>>> [1] https://lkml.org/lkml/2020/9/15/38
>>>>>
>>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>>> ---
>>>>> note that budget parameter is not removed in this patch because it
>>>>> involves many driver changes, we can remove it in separate patch if
>>>>> this patch is accepted.
>>>>> ---
>>>>>  net/core/skbuff.c | 6 ++++--
>>>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>>> index e077447..03d0d28 100644
>>>>> --- a/net/core/skbuff.c
>>>>> +++ b/net/core/skbuff.c
>>>>> @@ -895,8 +895,10 @@ void __kfree_skb_defer(struct sk_buff *skb)
>>>>>
>>>>>  void napi_consume_skb(struct sk_buff *skb, int budget)
>>>>>  {
>>>>> -       /* Zero budget indicate non-NAPI context called us, like netpoll */
>>>>> -       if (unlikely(!budget)) {
>>>>> +       /* called by non-softirq context, which usually means non-NAPI
>>>>> +        * context, like netpoll.
>>>>> +        */
>>>>> +       if (unlikely(!in_softirq())) {
>>>>>                 dev_consume_skb_any(skb);
>>>>>                 return;
>>>>>         }
>>>>> --
>>>>
>>>>
>>>> I do not think we should add this kind of fuzzy logic, just because
>>>> _one_ driver author made a mistake.
>>>>
>>>> Add a disable_bh() in the driver slow path, and accept the _existing_
>>>> semantic, the one that was understood by dozens.
>>>
>>> As my understanding, this patch did not change _existing_ semantic,
>>> it still only call _kfree_skb_defer() in softirq context. This patch
>>> just remove the requirement that a softirq context hint need to be
>>> provided to decide whether calling _kfree_skb_defer().
>>
>> I do not want to remove the requirement.
>>
>>>
>>> Yes, we can add DEBUG_NET() clauses to catch this kind of error as
>>> you suggested.
>>>
>>> But why we need such a debug clauses, when we can decide if delaying
>>> skb freeing is possible in napi_consume_skb(), why not just use
>>> in_softirq() to make this API more easy to use? Just as __dev_kfree_skb_any()
>>> API use "in_irq() || irqs_disabled()" checking to handle the irq context
>>> and non-irq context.
>>
>>
>> I just do not like your patch.
>>
>> Copying another piece of fuzzy logic, inherited from legacy code is
>> not an excuse.
>>
>> Add a local_bh_disable() in the driver slow path to meet _existing_
>> requirement, so that we can keep the hot path fast.
> 
> "!in_softirq()" checking make the napi_consume_skb() slower than
> "!budget" checking? do I miss something?

Yes, you missed that we can _remove_ this condition completely, if drivers
make sure to always have BH disabled.

> 
> As a matter of fact, the hns3 driver has fixed this problem by
> passing zero-budget to napi_consume_skb() in non-NAPI context, this
> patch is more about how to avoid or catch this kind of error.

I think I understood this. Having one error in hns3 does not mean we are going
to slow down the stack.

> 
> So your opinion is still to catch this kind of error using something
> like DEBUG_NET() clauses?
> 

Yes.

Again, we want to keep fast path fast, not something that is an swiss army knife.




