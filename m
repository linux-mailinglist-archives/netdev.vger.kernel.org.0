Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EC32871CB
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgJHJrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHJrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:47:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAC6C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 02:47:03 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e2so5841013wme.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tnyJtZWB/849Iu1W7i4nRtPfi4erjYR23is3KbtCKRY=;
        b=IBwyjxkA6HtkGKLfGY9Am8ckyoaxgHoQXbOp8in1VtcypuL49xA1LJncF7sxL73lBw
         VO0rLbn05sElPef7R0q7UGil39WqMYGR020pKrYzPset3wMNVssjQdwlBRSajJ0Ei1cJ
         voWw0Y48VenwkVDJfqDBxp07l9gTDG40N8OS7qClfK5XSzZNS0tY52d8qFAcs3cDr+cc
         rIHtgajFAgN1Eqh6z8FLRdbaXsmtyXgVeTutprmbXnX7+K4R7J7e7nTTZv2afn5FCbSd
         CoFvluAM6M7c3CJ+DA0KV8Gdk2CYy1FM/IIf+PSiAeS3AWTceI+/bk0TZNlqH59jG0Kz
         7n8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tnyJtZWB/849Iu1W7i4nRtPfi4erjYR23is3KbtCKRY=;
        b=Ta6k0xy5yFGrLdDS7I4I9uhnpWRiRo3/KEjzxZ2mLFnqA3KbHfPWsWL1K91B7aqqli
         HPIeJNYQyDpgyNKRxq26kvu85mJUQeXSHB0iJE+JGpiKLnRQxDLlzLo5BHDCwzViJRv1
         WfZd03kRs6X1815nDRjKNaekovIZaP1SPfYasnRbC0GhckWlpXYa4+nqvPQS8JkRt/Mn
         b4bqjUr8PKyg5y13tmm9dDvJ9+yAPOMOa3u2/kTQL6rnDH3T68B1KEwJgP3yZmVaSyIZ
         q5m/PQTo9dsFWOz/raNUMy1HyUVtftWDpdvkxOYTK0CRNrBp14WZ4wuGy9wVoxVaBbp0
         73bA==
X-Gm-Message-State: AOAM533Zu8dXPC69fb7MgaOnpVbWyLUvRUCEGjpjqsFPa8PwIONZNToJ
        hHknylUUP0MzDtlkXxNvOiE=
X-Google-Smtp-Source: ABdhPJxr8YqjX2F79ClYSOFEQ8J5QlUhFDI5YeCTYbTETwVHByGyttibQI3ldqkN3TKh8K9UaJpAxQ==
X-Received: by 2002:a1c:9ec1:: with SMTP id h184mr7941730wme.180.1602150422079;
        Thu, 08 Oct 2020 02:47:02 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.145.65])
        by smtp.gmail.com with ESMTPSA id w7sm6031255wmc.43.2020.10.08.02.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:47:01 -0700 (PDT)
Subject: Re: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201007035502.3928521-3-liuhangbin@gmail.com>
 <91f5b71e-416d-ebf1-750b-3e1d5cf6b732@gmail.com>
 <20201008083034.GI2531@dhcp-12-153.nay.redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f7272dda-0383-c7d0-1a8a-4a70a1aadb77@gmail.com>
Date:   Thu, 8 Oct 2020 11:47:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201008083034.GI2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 10:30 AM, Hangbin Liu wrote:
> Hi Eric,
> 
> Thanks for the comments. I should add "RFC" in subject next time for the
> uncertain fix patch.
> 
> On Wed, Oct 07, 2020 at 11:35:41AM +0200, Eric Dumazet wrote:
>>
>>
>> On 10/7/20 5:55 AM, Hangbin Liu wrote:
>>
>>>  		kfree_skb(skb);
>>> @@ -282,6 +285,21 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>>>  		}
>>>  	}
>>>  
>>> +	/* RFC 8200, Section 4.5 Fragment Header:
>>> +	 * If the first fragment does not include all headers through an
>>> +	 * Upper-Layer header, then that fragment should be discarded and
>>> +	 * an ICMP Parameter Problem, Code 3, message should be sent to
>>> +	 * the source of the fragment, with the Pointer field set to zero.
>>> +	 */
>>> +	nexthdr = hdr->nexthdr;
>>> +	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
>>> +	if (frag_off == htons(IP6_MF) && !pskb_may_pull(skb, offset + 1)) {
>>> +		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
>>> +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
>>> +		rcu_read_unlock();
>>> +		return NULL;
>>> +	}
>>> +
>>>  	rcu_read_unlock();
>>>  
>>>  	/* Must drop socket now because of tproxy. */
>>>
>>
>> Ouch, this is quite a buggy patch.
>>
>> I doubt we want to add yet another ipv6_skip_exthdr() call in IPv6 fast path.
>>
>> Surely the presence of NEXTHDR_FRAGMENT is already tested elsewhere ?
> 
> Would you like to help point where NEXTHDR_FRAGMENT was tested before IPv6
> defragment?
I think we have to ask the question : Should routers enforce the rule, or
only end points ?

End points must handle NEXTHDR_FRAGMENT, in ipv6_frag_rcv()


> 
>>
>> Also, ipv6_skip_exthdr() does not pull anything in skb->head, it would be strange
>> to force a pull of hundreds of bytes just because you want to check if an extra byte is there,
>> if the packet could be forwarded as is, without additional memory allocations.
>>
>> Testing skb->len should be more than enough at this stage.
> 
> Ah, yes, I shouldn't call pskb_may_pull here.
>>
>> Also ipv6_skip_exthdr() can return an error.
> 
> it returns -1 as error, If we tested it by (offset + 1 > skb->len), does
> that count as an error handler?

If there is an error, then you want to send the ICMP, right ?

The (offset + 1) expression will become 0, and surely the test will be false,
so you wont send the ICMP...

> 
> Thanks
> Hangbin
> 
