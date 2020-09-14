Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE7269615
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgINULj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgINULi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:11:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979A9C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:11:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so472118pjb.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x1az+bGmO7noJQbXczwuZoBdL2CKusR2BvJ28X258Kk=;
        b=Uti51KDThnGGlwD+Hn0z+4s/IKFxJNN7XMsxa7f0wPri6yEmRtAXHumKwDDLgiY2Fe
         7FWfSavkpceYwBxx4B/IzdiKZEN6DL49dVNHj0sHQzhMqIsQYqhJIxhUx/RfYxfABanF
         KgzeU1cIEzXKSRsaW+tibY87EJdSETeEl7T2fAGd35DiEgc7RzezUUHT0Eh9Zr0/t087
         5JOkR/mtw9q4p4LOFQr+Y1+hT50RE05Kqw8TbSFQLqh05LkF2Hu+XdmS0EONRGG58rcP
         knCRgdN0nPaB+5S+bTi522NwLQVZyQ9HO8Qe88xQ0rAuq4jU7hcNKrZ1i+NJjQngaZJR
         czbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x1az+bGmO7noJQbXczwuZoBdL2CKusR2BvJ28X258Kk=;
        b=pUYJjxgSbXrpxqlCafTKTKKEuUBiEklLbJsacamBIiOQesICBx1jNGtC9HXbZyXlMv
         irY+ElxGyfABVqnaG+Ic0vmkTdr6N1fmdDQ0w3XXBzidhG3wq7fcFv9N97ItYL+nG8qD
         MG5r5cBhS9duka1dZrkM3Urke9BSYu/YnttC3ttA/jD/y+xAOK6bGJdw1aYEQbki9/SR
         OwL10Lv3UIVFxuc0rpvZWf26p/zO2Y3j7f50ockpE7G3z4PWbI81NmeIKMBV2c301DuU
         Phb24FWbZweIqgTrNcBY9EQ8ecowLoWhTimRR+SiLvxUr5T9wEREx7rpvCePL74GaOsG
         OIAA==
X-Gm-Message-State: AOAM532JaKUyboO6952luBhdRFj0NKIHu2Wp/tGgz5JBGwkWLmwAC99r
        9w1Jm+Uuk6sSww14cYoL5hzD8EjH5KVrng==
X-Google-Smtp-Source: ABdhPJyRCsLhhv+umqGLj/zO5z+Sn+aeJcwQ/Vsq1RBTcWOcdC2N6t62c1N9wl/So7NrP7ED4sZ2Dg==
X-Received: by 2002:a17:90a:d702:: with SMTP id y2mr965144pju.216.1600114296426;
        Mon, 14 Sep 2020 13:11:36 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g1sm9599118pjl.21.2020.09.14.13.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 13:11:35 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
 <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
 <315a6f2a1cec945eb35e69c6fdeaf3c2ab3cb25d.camel@nvidia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc20face-ec67-d444-1cf8-f4257dbe1e1c@gmail.com>
Date:   Mon, 14 Sep 2020 13:11:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <315a6f2a1cec945eb35e69c6fdeaf3c2ab3cb25d.camel@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2020 12:51 AM, Nikolay Aleksandrov wrote:
> On Sat, 2020-09-12 at 12:38 -0700, Florian Fainelli wrote:
>>
>> On 9/11/2020 11:56 PM, Nikolay Aleksandrov wrote:
>>> On Sat, 2020-09-12 at 02:16 +0300, Vladimir Oltean wrote:
>>>> Currently the bridge untags VLANs from its VLAN group in
>>>> __allowed_ingress() only when VLAN filtering is enabled.
>>>>
>>>> When installing a pvid in egress-tagged mode, DSA switches have a
>>>> problem:
>>>>
>>>> ip link add dev br0 type bridge vlan_filtering 0
>>>> ip link set swp0 master br0
>>>> bridge vlan del dev swp0 vid 1
>>>> bridge vlan add dev swp0 vid 1 pvid
>>>>
>>>> When adding a VLAN on a DSA switch interface, DSA configures the VLAN
>>>> membership of the CPU port using the same flags as swp0 (in this case
>>>> "pvid and not untagged"), in an attempt to copy the frame as-is from
>>>> ingress to the CPU.
>>>>
>>>> However, in this case, the packet may arrive untagged on ingress, it
>>>> will be pvid-tagged by the ingress port, and will be sent as
>>>> egress-tagged towards the CPU. Otherwise stated, the CPU will see a VLAN
>>>> tag where there was none to speak of on ingress.
>>>>
>>>> When vlan_filtering is 1, this is not a problem, as stated in the first
>>>> paragraph, because __allowed_ingress() will pop it. But currently, when
>>>> vlan_filtering is 0 and we have such a VLAN configuration, we need an
>>>> 8021q upper (br0.1) to be able to ping over that VLAN.
>>>>
>>>> Make the 2 cases (vlan_filtering 0 and 1) behave the same way by popping
>>>> the pvid, if the skb happens to be tagged with it, when vlan_filtering
>>>> is 0.
>>>>
>>>> There was an attempt to resolve this issue locally within the DSA
>>>> receive data path, but even though we can determine that we are under a
>>>> bridge with vlan_filtering=0, there are still some challenges:
>>>> - we cannot be certain that the skb will end up in the software bridge's
>>>>     data path, and for that reason, we may be popping the VLAN for
>>>>     nothing. Example: there might exist an 8021q upper with the same VLAN,
>>>>     or this interface might be a DSA master for another switch. In that
>>>>     case, the VLAN should definitely not be popped even if it is equal to
>>>>     the default_pvid of the bridge, because it will be consumed about the
>>>>     DSA layer below.
>>>
>>> Could you point me to a thread where these problems were discussed and why
>>> they couldn't be resolved within DSA in detail ?
>>>
>>>> - the bridge API only offers a race-free API for determining the pvid of
>>>>     a port, br_vlan_get_pvid(), under RTNL.
>>>>
>>>
>>> The API can be easily extended.
>>>
>>>> And in fact this might not even be a situation unique to DSA. Any driver
>>>> that receives untagged frames as pvid-tagged is now able to communicate
>>>> without needing an 8021q upper for the pvid.
>>>>
>>>
>>> I would prefer we don't add hardware/driver-specific fixes in the bridge, when
>>> vlan filtering is disabled there should be no vlan manipulation/filtering done
>>> by the bridge. This could potentially break users who have added 8021q devices
>>> as bridge ports. At the very least this needs to be hidden behind a new option,
>>> but I would like to find a way to actually push it back to DSA. But again adding
>>> hardware/driver-specific options should be avoided.
>>>
>>> Can you use tc to pop the vlan on ingress ? I mean the cases above are visible
>>> to the user, so they might decide to add the ingress vlan rule.
>>
>> We had discussed various options with Vladimir in the threads he points
>> out but this one is by far the cleanest and basically aligns the data
>> path when the bridge is configured with vlan_filtering=0 or 1.
>>
>> Some Ethernet switches supported via DSA either insist on or the driver
>> has been written in such a way that the default_pvid of the bridge which
>> is egress untagged for the user-facing ports is configured as egress
>> tagged for the CPU port. That CPU port is ultimately responsible for
>> bringing the Ethernet frames into the Linux host and the bridge data
>> path which is how we got VLAN tagged frames into the bridge, even if a
>> vlan_filtering=0 bridge is not supposed to.
>>
> 
> I read the thread and see your problem, but I still think that it must not be
> fixed in the bridge device, more below.
> 
>> We can solve this today by having a 802.1Q upper on top of the bridge
>> default to pop/push the default_pvid VLAN tag, but this is not obvious,
>> represents a divergence from a pure software bridge, and leads to
>> support questions. What is also utterly confusing for instance is that a
>> raw socket like one opened by a DHCP client will successfully allow br0
>> to obtain an IP address, but the data path still is not functional, as
>> you would need to use br0.1 to have a working data path taking care of
>> the VLAN tag.
>>
> 
> With this patch br0.1 won't work anymore for anyone having vlan_filtering=0.
> 
>> Vladimir had offered a DSA centric solution to this problem, which was
>> not that bad after all, but this one is also my favorite.
>>
> 
> I saw it, and it looks good. I saw the one of the main issues is not having an
> RCU get pvid helper. I can provide you with that to simplify the patch.
> 
>> Let us know when you are caught up on the thread and we can see how to
>> solve that the best way.
> 
> I'll start with why this patch is a non-starter, I'm guessing most of us already
> have guessed, but just to have them:
>   - the fix is DSA-specific, it must not reside in the bridge

Not necessarily any switch that forces egress tagging of a given PVID 
would fall in that category.

>   - vlan_filtering=0 means absolutely no vlan processing, that is what everyone
>     expects and breaking that expectation would break various use cases

OK

> 
> Less important, but still:
>   - it is in the fast path for everyone
>   - it can already be fixed by a tc action/8021q device

Sure, but the point is that it should be fixed in a way that is 
transparent to the user, as much as possible.

> 
> We can go into details but that would be a waste of time, instead I think we
> should focus on Vladimir's proposed DSA change.
> 
> Vladimir, I think with the right pvid helper the patch would reduce to
> dsa_untag_bridge_pvid() on the Rx path only. One thing that I'm curious about
> is shouldn't dsa_untag_bridge_pvid() check if the bridge pvid is == to the skb
> tag and the port's pvid?
> Since we can have the port's pvid different from the bridge's. That's for the
> case of vlan_filtering=1 and the port having that vlan, but not as pvid.
> 
> Thanks,
>   Nik
> 

-- 
Florian
