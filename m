Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8112E58717B
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiHATdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHATdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:33:16 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [IPv6:2a01:e0c:1:1599::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF0F273;
        Mon,  1 Aug 2022 12:33:15 -0700 (PDT)
Received: from [44.168.19.21] (unknown [86.242.59.24])
        (Authenticated sender: f6bvp@free.fr)
        by smtp3-g21.free.fr (Postfix) with ESMTPSA id 9AE2113F84C;
        Mon,  1 Aug 2022 21:33:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1659382393;
        bh=Z2KjtwsxMMfBTjzNhCjIjURQlfJlHVWS3ieXQoK/xxI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NXhRQVlORbhoJqDAcRpwI2RX1EYet3rhq1lr7ejJ50XE6NaXpcB8a2YFQ/Fwko1uF
         5dOyEDtqoYfJNYw11zn7ucluHM7EWFzfmDgEDr+R8zxbqTWmlBPnrbRaoFurhQg0MK
         Bi9TOvL6SKJrTpqRdeH6f4/09FL6c7kPTDIc5HOhPTWLfsS5pCBnWjyy5UyT0JV29H
         9UzCKDasklnkyvDz6o2O2Il/loCQvNP2q3WAmp1B1cqqww9Y/3Ur+XLGrN8XQBgQJZ
         FkmcgtEhNDmK+6F1y06G7GYXOZL35GYAYKmAquy9RimKuxBjk2VVsrNPs+f3WOhnO/
         7Fc5lZedQnJfg==
Message-ID: <3471ea58-4818-bff0-3d90-ecce2086c423@free.fr>
Date:   Mon, 1 Aug 2022 21:33:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: rose timer t error displayed in /proc/net/rose
Content-Language: en-US
To:     Francois Romieu <romieu@fr.zoreil.com>,
        Thomas Osterried <thomas@osterried.de>
Cc:     Eric Dumazet <edumazet@google.com>, linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
References: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
 <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
 <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
 <Yuf04XIsXrQMJuUy@electric-eye.fr.zoreil.com>
From:   Bernard f6bvp <f6bvp@free.fr>
Organization: Dimension Parabole
In-Reply-To: <Yuf04XIsXrQMJuUy@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

François, your new patch is working fine in both state 1 and 2 of rose.

Congrats and thanks !

By the way, it is a very old display issue... Already present in 5.4.79 
(32 bytes OS) for example and probably since much earlier.

Le 01/08/2022 à 17:44, Francois Romieu a écrit :
> Thomas Osterried <thomas@osterried.de> :
> [...]
>> 1. why do you check for pending timer anymore?
> s/do/don't/ ?
>
> I don't check for pending timer because:
> - the check is racy
> - jiffies_delta_to_clock_t maxes negative delta to zero
>
>> 2. I'm not really sure what value jiffies_delta_to_clock_t() returns. jiffies / HZ?
>>     jiffies_delta_to_clock_t() returns clock_t.
> I completely messed this part :o/
>
> clock_t relates to USER_HZ like jiffies does to HZ.
>
> [don't break the ax25]
>
> Sure, we are in violent agreement here.
>
> [...]
>> 1. I expect rose->timer to be restarted soon. If it does not happen, is there a bug?
> The relevant rose state in Bernard's sample was ROSE_STATE_2.
>
> net/rose/rose_timer.c::rose_timer_expiry would had called
> rose_disconnect(sk, ETIMEDOUT, -1, -1) so there should not
> be any timer restart (afaiu, etc.).
>
> [...]
>>     => Negative may be handled due to Francois' patch now correctly.
>> delta as signed long may be negative. max(0L, -nnnn) sould result to 0L.
>>     This would result to 0. Perhaps proven by Francois, because he used this function and achieved a correct display of that idle value. Francois, am I correct, is "0" really displayed?
> I must confess that I was not terribly professional this morning past 2AM.
>
> The attached snippet illustrates the behavior wrt negative values
> (make; insmod foo.ko ; sleep 1; rmmod foo.ko; dmesg | tail -n 2).
> It also illustrates that I got the unit wrong.
>
> This should be better:
>
> diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
> index 85865ebfdfa2..3c94e5a2d098 100644
> --- a/net/ax25/ax25_timer.c
> +++ b/net/ax25/ax25_timer.c
> @@ -108,10 +108,9 @@ int ax25_t1timer_running(ax25_cb *ax25)
>   
>   unsigned long ax25_display_timer(struct timer_list *timer)
>   {
> -	if (!timer_pending(timer))
> -		return 0;
> +	long delta = timer->expires - jiffies;
>   
> -	return timer->expires - jiffies;
> +	return max(0L, delta);
>   }
>   
>   EXPORT_SYMBOL(ax25_display_timer);
>
