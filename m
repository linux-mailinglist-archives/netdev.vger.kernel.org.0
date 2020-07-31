Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F4234A53
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387593AbgGaRii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387429AbgGaRih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:38:37 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2CC061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:38:37 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id di22so15718951edb.12
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EVbdnM3VWE8j0IwvbJMEc4diNGnNb/B1uyEmvQtSeCE=;
        b=Hnj4coJ1kihuonOox3v5ubtJyIKCGYcpnUSMN34Prm+Zx/o6YUVk+HXGTaTaU1h2Bf
         0FyLpWhWQWOxGp3ML7sD1vIHO1ELDM8iC2r07cSKN+NZSQKUrbATt1QiNhbeegDW6eiT
         Ltbc/MskAF960te2RlFIxEnLrVoWRx2mYvaOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVbdnM3VWE8j0IwvbJMEc4diNGnNb/B1uyEmvQtSeCE=;
        b=bjfvfFTdKyxVhDd4+8bj0bcCrDkz8gQAMBssLLRiEKzH8kIEZVuX3fHwtJYyvLnAqO
         QSIzWp6seaD2pWyEHGJDTf9xM7gJrxftg+MTcHQG7ZQniHr4n0kZBJzVzJFgDdTG7IZL
         Cr6ze2vxc1+etkQi+z8FmbMYJk1tp4oY6z/06wMUaA1L762jtfaNnwwWtipvxvI1eqi0
         NJjb9/AuR+APBNUE17P54dpYvGXxF9d42HR6X7A7YIBzyQyHhzjDASBhI62xNDfRsh+a
         /ARk1/6+BbGB2Tuf2mUgm8pDYJpm1yoXB2NCu8f2SpZUxZPMQeHYShS+cV9MC08rx4Dd
         NljA==
X-Gm-Message-State: AOAM532SZ7/BtUCOyO6sP6uRKr37KZzWNIEgHg3WWNZTputCnsyGfkY5
        lKubEsGe1Yl85Fa1AOsZWwGIvA==
X-Google-Smtp-Source: ABdhPJwwuic0MpECXVNB43X574zTf0G/mNEH5QgAY73b/KLLLetJSS6eMhzJRtnO+Dg/UZ3756Bd0A==
X-Received: by 2002:a05:6402:12d0:: with SMTP id k16mr5013989edx.199.1596217116339;
        Fri, 31 Jul 2020 10:38:36 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id br25sm9740551ejb.25.2020.07.31.10.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:38:33 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: clear bridge's private skb space on xmit
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, roopa@cumulusnetworks.com,
        davem@davemloft.net
References: <20200731162616.345380-1-nikolay@cumulusnetworks.com>
 <07823615-29a8-9553-d56b-1beef55a07bc@gmail.com>
 <181931fb-dc60-7db6-60ac-b8ff1402efec@cumulusnetworks.com>
Message-ID: <968147d8-616d-364f-cf03-55bb7b08a518@cumulusnetworks.com>
Date:   Fri, 31 Jul 2020 20:38:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <181931fb-dc60-7db6-60ac-b8ff1402efec@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/07/2020 20:37, Nikolay Aleksandrov wrote:
> On 31/07/2020 20:27, David Ahern wrote:
>> On 7/31/20 10:26 AM, Nikolay Aleksandrov wrote:
>>> We need to clear all of the bridge private skb variables as they can be
>>> stale due to the packet being recirculated through the stack and then
>>> transmitted through the bridge device. Similar memset is already done on
>>> bridge's input. We've seen cases where proxyarp_replied was 1 on routed
>>> multicast packets transmitted through the bridge to ports with neigh
>>> suppress which were getting dropped. Same thing can in theory happen with
>>> the port isolation bit as well.
>>>
>>> Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
>>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>> ---
>>>  net/bridge/br_device.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
>>> index 8c7b78f8bc23..9a2fb4aa1a10 100644
>>> --- a/net/bridge/br_device.c
>>> +++ b/net/bridge/br_device.c
>>> @@ -36,6 +36,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>>>  	const unsigned char *dest;
>>>  	u16 vid = 0;
>>>  
>>> +	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
>>> +
>>>  	rcu_read_lock();
>>>  	nf_ops = rcu_dereference(nf_br_ops);
>>>  	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
>>>
>>
>> What's the performance hit of doing this on every packet?
>>
>> Can you just set a flag that tells the code to reset on recirculation?
>> Seems like br_input_skb_cb has space for that.
>>
> 
> Virtually non-existent, we had a patch that turned that field into a 16 byte
> field so that is really 2 8 byte stores. It is already cache hot, we could

err, s/field/struct/

> initialize each individual field separately as br_input does.
> 
> I don't want to waste flags on such thing, this makes it future-proof 
> and I'll remove the individual field zeroing later which will alleviate
> the cost further.
> 
> 

