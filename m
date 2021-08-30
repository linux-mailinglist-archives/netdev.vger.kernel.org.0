Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1173FBD35
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhH3T7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 15:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbhH3T7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 15:59:12 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15065C061575;
        Mon, 30 Aug 2021 12:58:18 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u6so12454828pfi.0;
        Mon, 30 Aug 2021 12:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jgTOuXMR/8EnbPDTCQwJ0RRzX/vDc1Edyp+hQN8fq8M=;
        b=GE3yFLkIPB+s8YZXQ2LPa5Qu3WWtDrRETTrgAWg++/liigUnwF8L9dxj+99IICp9wc
         8x7mpBzeyIfBtl7FZcrjnM6rWvU3WLgEgumsGxM+wwkNnC94RLVXmmVS4UnhSNF1rR1m
         25VfddLIfe+OpFWH32dgppjngT6WrAIJtQQuLj8pW2Hui+rHgzKMNsy07NB/l+kkeNdQ
         k7/g8qEKLIZUUNZ+1onhTmYNwY31lsqC9cD/HGZa6ZcKrdmfxx8izJupU3WPTkWXb4fD
         xtxtWRhobJOxm61qllj9LyGlKN104LvaIeGbFE3qbca081W9acEge2sqkIPwC4Diy+3K
         Jrpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jgTOuXMR/8EnbPDTCQwJ0RRzX/vDc1Edyp+hQN8fq8M=;
        b=gNVVIa/RLdgNgdQpM75Lby9tqWqS6xE31KawQxbJBx3IwaJgaOGfgRWOEaIekChNOj
         tUQs1U0p5hWJr3hPevYQi7XEMSmX9rYRwwdnSwnmWQ0VvyITO3xd83az8mdNELHBaoxl
         osV+R1nZ4TPgpitWdsep43m4ukUIX98k4G81gtouBLu1aB2kWgKK3Qvj9xfTc6DgbLum
         qyqWWOz+miEwguI4nqP7aMRmlztVhI64Rp4NUy7VMHyg1IUTy8WNy5OrFHL0bMa94QAF
         YsaFJjXJEHRRqxFAbe4R9v6R1ySHsNwehHdf3/sksJfGXXOc5SjMzr50ixJkz7sh6TSJ
         w1Wg==
X-Gm-Message-State: AOAM530CSBbWrgyIJxRS8KG602+AFD9fMlZyV8obeJWRqWPLikiyHp5g
        TPWcz0PB/p03npUqr8+cOCg=
X-Google-Smtp-Source: ABdhPJxv1n3rCdjGUIp+DNLSzGfp6bd3uUtrqxHP+yDYD1n8+38aKkq3yHBFjiuLmLADPtx5ScegXg==
X-Received: by 2002:a62:8287:0:b0:3ec:f6dc:9672 with SMTP id w129-20020a628287000000b003ecf6dc9672mr24581701pfd.65.1630353497619;
        Mon, 30 Aug 2021 12:58:17 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l75sm11841926pga.19.2021.08.30.12.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 12:58:17 -0700 (PDT)
Subject: Re: [PATCH v2] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <CALMXkpZYGC5HNkJAi4wCuawC-9CVNjN1LqO073YJvUF5ONwupA@mail.gmail.com>
 <860513d5-fd02-832b-1c4c-ea2b17477d76@virtuozzo.com>
 <9f0c5e45-ad79-a9ea-dab1-aeb3bc3730ae@gmail.com>
 <c4373bb7-bb4f-2895-c692-e61a1a89e21f@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8fd56805-2ac8-dcbe-1337-b20f91f759d6@gmail.com>
Date:   Mon, 30 Aug 2021 12:58:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c4373bb7-bb4f-2895-c692-e61a1a89e21f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/21 11:09 AM, Vasily Averin wrote:
> On 8/30/21 7:01 PM, Eric Dumazet wrote:
>> On 8/29/21 5:59 AM, Vasily Averin wrote:
>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>> after skb_expand_head() call in ip6_xmit.
>>> This may happen because of two reasons:
>>> - skb_set_owner_w() for newly cloned skb is called too early,
>>> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
>>> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
>>> In this case sk->sk_wmem_alloc should be adjusted too.
>>>
>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>> @@ -1756,9 +1756,13 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>>>  	 * For the moment, we really care of rx path, or
>>>  	 * when skb is orphaned (not attached to a socket).
>>>  	 */
>>> -	if (!skb->sk || skb->destructor == sock_edemux)
>>> -		skb->truesize += size - osize;
>>> -
>>> +	delta = size - osize;
>>> +	if (!skb->sk || skb->destructor == sock_edemux) {
>>> +		skb->truesize += delta;
>>> +	} else if (update_truesize) {
>>
>> Unfortunately we can not always do this sk_wmem_alloc change here.
>>
>> Some skb have skb->sk set, but the 'reference on socket' is not through sk_wmem_alloc
> 
> Could you please provide some example?
> In past in all handeled cases we have cloned original skb and then unconditionally assigned skb sock_wfree destructor.

In the past we ignored old value of skb->destructor,
since the clone got a NULL destructor.

In your patch you assumes it is sock_wfree, or other destructors changing sk_wmem_alloc


You need to make sure skb->destructor is one of the known destructors which 
will basically remove skb->truesize from sk->sk_wmem_alloc.

This will also make sure skb->sk is a 'full socket'

If not, you should not change sk->sk_wmem_alloc

> Do you want to say that it worked correctly somehow?

I am simply saying your patch adds a wrong assumption.

> 
> I expected if we set sock_wfree, we have guarantee that old skb adjusted sk_wmem_alloc.
> Am I wrong?
> Could you please point on such case?
> 
>> It seems you need a helper to make sure skb->destructor is one of
>> the destructors that use skb->truesize and sk->sk_wmem_alloc
>>
>> For instance, skb_orphan_partial() could have been used.
> 
> Thank you, will investigate.
> 	Vasily Averin
> 
