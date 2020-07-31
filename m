Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC44234A4D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbgGaRhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733055AbgGaRhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:37:54 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1ACC061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:37:54 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a21so32175608ejj.10
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DqOTbcHJa6iCOElcOD33JQpO8fLteWYi7HsjmMVd1Zw=;
        b=KG/aSQF57PreJuWc65lTW6PiL+C2vriQO062kCkUcMTx+hclSicWVKLXM+Zli9HO+s
         fF6Gssc14D1cXF7X/+fULIl4e9szLX3G82a4Pdd39MPPzgv3MkPzJ0sRtUcfbgsGlE49
         Z206UOX4fYospZk/udSPqU0mIYB9IUOnVFolE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DqOTbcHJa6iCOElcOD33JQpO8fLteWYi7HsjmMVd1Zw=;
        b=lhwmEZ2QGi3YsDofV9fT//k3NTut3BqldvdWnmFnaGfSQo65e4EHuHW2skqLkKcmfh
         7kGHU+n4mS8HeIUg64E7Im5uYWFflcfNDjONuwgePdQzQmGFd2YOb9ZNpbtKR8zsAx+O
         boiptgNQd6HJjUBQKFv6ggFR0HfXkSP5zF2NDJnbIQk7yWVzC7FZejT/FQP4LQ3GFXvC
         QUpTn5IyxaECBXYEygF2ntkuP/NuR3v/THCJIGH2VOgcA6rIWaoLV+/P4NUou03CW7wy
         C4FCVkcyUY7KDOxErQjS59E8ex+iS+CXBDCqSCQAs6HFQ2HIcJVlkRUP3zal3FxXXjf6
         pfCA==
X-Gm-Message-State: AOAM532OfFLh+4krovBnFwezkIofswWo7nCXDMAk12f0kqgebX47f1l9
        cYMCvRaSpfXdD95BAQBndlktrw==
X-Google-Smtp-Source: ABdhPJwDnc4mE4bpaa0vBl3g9OWxnq9rImzVI0ZW2D2NT2IQGPX9RVlidih0zUYmoaHJoJO0xFNOdQ==
X-Received: by 2002:a17:906:c0d9:: with SMTP id bn25mr5069638ejb.176.1596217072959;
        Fri, 31 Jul 2020 10:37:52 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v14sm9724457ejb.63.2020.07.31.10.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:37:52 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: clear bridge's private skb space on xmit
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, roopa@cumulusnetworks.com,
        davem@davemloft.net
References: <20200731162616.345380-1-nikolay@cumulusnetworks.com>
 <07823615-29a8-9553-d56b-1beef55a07bc@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <181931fb-dc60-7db6-60ac-b8ff1402efec@cumulusnetworks.com>
Date:   Fri, 31 Jul 2020 20:37:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <07823615-29a8-9553-d56b-1beef55a07bc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/07/2020 20:27, David Ahern wrote:
> On 7/31/20 10:26 AM, Nikolay Aleksandrov wrote:
>> We need to clear all of the bridge private skb variables as they can be
>> stale due to the packet being recirculated through the stack and then
>> transmitted through the bridge device. Similar memset is already done on
>> bridge's input. We've seen cases where proxyarp_replied was 1 on routed
>> multicast packets transmitted through the bridge to ports with neigh
>> suppress which were getting dropped. Same thing can in theory happen with
>> the port isolation bit as well.
>>
>> Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> ---
>>  net/bridge/br_device.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
>> index 8c7b78f8bc23..9a2fb4aa1a10 100644
>> --- a/net/bridge/br_device.c
>> +++ b/net/bridge/br_device.c
>> @@ -36,6 +36,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	const unsigned char *dest;
>>  	u16 vid = 0;
>>  
>> +	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
>> +
>>  	rcu_read_lock();
>>  	nf_ops = rcu_dereference(nf_br_ops);
>>  	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
>>
> 
> What's the performance hit of doing this on every packet?
> 
> Can you just set a flag that tells the code to reset on recirculation?
> Seems like br_input_skb_cb has space for that.
> 

Virtually non-existent, we had a patch that turned that field into a 16 byte
field so that is really 2 8 byte stores. It is already cache hot, we could
initialize each individual field separately as br_input does.

I don't want to waste flags on such thing, this makes it future-proof 
and I'll remove the individual field zeroing later which will alleviate
the cost further.


