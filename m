Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A6F234A82
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgGaRvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729646AbgGaRv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:51:29 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B022BC061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:51:28 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m20so13431566eds.2
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6vpglymf7RZEUEiG4RD7M2kj01Hx6dnOmn6sHKExOCE=;
        b=Fx4nuKm+HCsA2lOlyRmagx4942dMIaJA4RwSCJ8TSnPYEV1b7b+yU13MDO7NsLWcbO
         8ic5yHzO9Qeq7rAMyjW2kOO04tD+8GN2B3mNsBEKYrUFaI+9kpozJXESAUxPBOQ6He/A
         17apuv/dj4BiOpAZ16vVzo8NarMR10kiXxzFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6vpglymf7RZEUEiG4RD7M2kj01Hx6dnOmn6sHKExOCE=;
        b=TZqKi3aVxwiTb5vDaUAVlKLZxdAcnm0SG/e2qEtuhRVdigbd4H5k4ynr6UoLQF7/9n
         Sf98VaQfMJHcuPAY69beYJBFFTL0cSDe2rBA4ZQThOE8+lUmwcUTd1iucfvuKaFEiOfl
         nC07IV2ACaMkNxnEVdSsTkpcVX4uUXnDulqX169iiZEd2Zbw8YjQ9eDfNkk3AyAtkM3I
         i3RwHhbungnbJSUhdQ2zQsvrw0Rs4odPiuAnMQ9lhu88o88W92p/O80mwLub4U9h7tat
         1dqVkYDWS7j4SbWBSQh6h2qTqDfcuIaDn45IrZEBeMplmBOZggri/7j/SNsLohaFEo19
         oIJQ==
X-Gm-Message-State: AOAM532JYfZk81ozy9Qd9uPULQQ28zaJ13MPJG1wGWPaK4V6MK5Rpxko
        c6b+17rCzjTbjrzWWOp3TQwTYw==
X-Google-Smtp-Source: ABdhPJyoTKCXqyvqcjbGIteUeTNk0NV2vPGXysE+SXgPbMEh9TeBm3XA0kgDFirpgYcElBHX0gbcYg==
X-Received: by 2002:a50:f10c:: with SMTP id w12mr5033995edl.202.1596217887487;
        Fri, 31 Jul 2020 10:51:27 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i15sm2118797edu.54.2020.07.31.10.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:51:26 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: clear bridge's private skb space on xmit
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, roopa@cumulusnetworks.com,
        davem@davemloft.net
References: <20200731162616.345380-1-nikolay@cumulusnetworks.com>
 <07823615-29a8-9553-d56b-1beef55a07bc@gmail.com>
 <181931fb-dc60-7db6-60ac-b8ff1402efec@cumulusnetworks.com>
Message-ID: <2bdc90a2-834f-941d-fea7-04e3c8924f7b@cumulusnetworks.com>
Date:   Fri, 31 Jul 2020 20:51:25 +0300
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
> initialize each individual field separately as br_input does.
> 
> I don't want to waste flags on such thing, this makes it future-proof 
> and I'll remove the individual field zeroing later which will alleviate
> the cost further.
> 

Also note that we already do this on input for each packet since the
struct was reduced to 16 bytes. It's the safest way since every different
sub-part of the bridge uses some set of these private variables and
we've had many similar bugs where they were used stale or unintentionally
were not initialized for some path.


