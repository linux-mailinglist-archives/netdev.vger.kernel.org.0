Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC9A267C13
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgILTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgILTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 15:38:26 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718FC061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 12:38:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o20so9520643pfp.11
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hqii6yfP17uL4wRhtOa/HXv1wxcxHEBzDQhvhCAz+j0=;
        b=rasymW6WYB841uv2f36d4Zomso7IuSy26iDLQ9Yu+CoSy3YmozeWD2ZpD3Q708+tvH
         M3hTHg4bu+SQzJasUOcyzpTLzXrMDdGCalJKWzbOABYNoCVBTFZGV8tQ6AniPJFUvTiW
         c2VlVgRd9bx96FkEBCBkuc8BUFDaeQF13XrfR/GpXfdg18iqSWUkAbCO2N1j4BWFR/I6
         UjFcVknWG+0QROYb14TKQMkP2QhSM1S1usORcXXSecDc86mRIXerhxATmo09kIpjJ4TC
         BfbybJ6+gZuJORFiGOfIoIHZSLDzFJFAeeSdLjWqbYnjJJ0aFE1TIBQuEFs1oRto+5W7
         QbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hqii6yfP17uL4wRhtOa/HXv1wxcxHEBzDQhvhCAz+j0=;
        b=KerIivgFXJ3cz7FApHjfRgdFLPMijgiHj18teYJZfss9EAWfW3kvxJs6GbExQbPJDt
         ue4iIEjEg9pUx9u9o+oJBx6wsEHx0GN/hzBQdtlVM2axleZX8/v74aPsjQm7/jKqkQDY
         UneuMbTvdXAfcemySdtgEDYRVKWn3qFDXAqb0XRVAdR6nlQBQaeLe36hSnvnuqnwnNu1
         se1i8jHNZYGtbQHh3UbOX2Ui6tbaiLQvgU94idcFQUwRf8Dn9lmkd0FeMw+6OI7Dp8xw
         nRldRYXlh9JT+ApZwvPB1XmXs8/vauxLpr4eBP8qYg0LqgxOLKnKYMb/3gdJ79SQkgbE
         qo6A==
X-Gm-Message-State: AOAM533FQ0znGtmi7rupwfxO3dyljkns9NK5B2bg3PKpeHuqaku18hwq
        WZffeuONtimX4ofBACG1QoA=
X-Google-Smtp-Source: ABdhPJzBLReLDd5rKWfomDDkoTOjXFuzgIJ+xEmA9DVHgUKJ+SWWqkqL+MVqfFMIXN0mY6FtRXoFGQ==
X-Received: by 2002:a63:d25:: with SMTP id c37mr5536232pgl.403.1599939505420;
        Sat, 12 Sep 2020 12:38:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q190sm6071312pfc.176.2020.09.12.12.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 12:38:24 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
Date:   Sat, 12 Sep 2020 12:38:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2020 11:56 PM, Nikolay Aleksandrov wrote:
> On Sat, 2020-09-12 at 02:16 +0300, Vladimir Oltean wrote:
>> Currently the bridge untags VLANs from its VLAN group in
>> __allowed_ingress() only when VLAN filtering is enabled.
>>
>> When installing a pvid in egress-tagged mode, DSA switches have a
>> problem:
>>
>> ip link add dev br0 type bridge vlan_filtering 0
>> ip link set swp0 master br0
>> bridge vlan del dev swp0 vid 1
>> bridge vlan add dev swp0 vid 1 pvid
>>
>> When adding a VLAN on a DSA switch interface, DSA configures the VLAN
>> membership of the CPU port using the same flags as swp0 (in this case
>> "pvid and not untagged"), in an attempt to copy the frame as-is from
>> ingress to the CPU.
>>
>> However, in this case, the packet may arrive untagged on ingress, it
>> will be pvid-tagged by the ingress port, and will be sent as
>> egress-tagged towards the CPU. Otherwise stated, the CPU will see a VLAN
>> tag where there was none to speak of on ingress.
>>
>> When vlan_filtering is 1, this is not a problem, as stated in the first
>> paragraph, because __allowed_ingress() will pop it. But currently, when
>> vlan_filtering is 0 and we have such a VLAN configuration, we need an
>> 8021q upper (br0.1) to be able to ping over that VLAN.
>>
>> Make the 2 cases (vlan_filtering 0 and 1) behave the same way by popping
>> the pvid, if the skb happens to be tagged with it, when vlan_filtering
>> is 0.
>>
>> There was an attempt to resolve this issue locally within the DSA
>> receive data path, but even though we can determine that we are under a
>> bridge with vlan_filtering=0, there are still some challenges:
>> - we cannot be certain that the skb will end up in the software bridge's
>>    data path, and for that reason, we may be popping the VLAN for
>>    nothing. Example: there might exist an 8021q upper with the same VLAN,
>>    or this interface might be a DSA master for another switch. In that
>>    case, the VLAN should definitely not be popped even if it is equal to
>>    the default_pvid of the bridge, because it will be consumed about the
>>    DSA layer below.
> 
> Could you point me to a thread where these problems were discussed and why
> they couldn't be resolved within DSA in detail ?
> 
>> - the bridge API only offers a race-free API for determining the pvid of
>>    a port, br_vlan_get_pvid(), under RTNL.
>>
> 
> The API can be easily extended.
> 
>> And in fact this might not even be a situation unique to DSA. Any driver
>> that receives untagged frames as pvid-tagged is now able to communicate
>> without needing an 8021q upper for the pvid.
>>
> 
> I would prefer we don't add hardware/driver-specific fixes in the bridge, when
> vlan filtering is disabled there should be no vlan manipulation/filtering done
> by the bridge. This could potentially break users who have added 8021q devices
> as bridge ports. At the very least this needs to be hidden behind a new option,
> but I would like to find a way to actually push it back to DSA. But again adding
> hardware/driver-specific options should be avoided.
> 
> Can you use tc to pop the vlan on ingress ? I mean the cases above are visible
> to the user, so they might decide to add the ingress vlan rule.

We had discussed various options with Vladimir in the threads he points 
out but this one is by far the cleanest and basically aligns the data 
path when the bridge is configured with vlan_filtering=0 or 1.

Some Ethernet switches supported via DSA either insist on or the driver 
has been written in such a way that the default_pvid of the bridge which 
is egress untagged for the user-facing ports is configured as egress 
tagged for the CPU port. That CPU port is ultimately responsible for 
bringing the Ethernet frames into the Linux host and the bridge data 
path which is how we got VLAN tagged frames into the bridge, even if a 
vlan_filtering=0 bridge is not supposed to.

We can solve this today by having a 802.1Q upper on top of the bridge 
default to pop/push the default_pvid VLAN tag, but this is not obvious, 
represents a divergence from a pure software bridge, and leads to 
support questions. What is also utterly confusing for instance is that a 
raw socket like one opened by a DHCP client will successfully allow br0 
to obtain an IP address, but the data path still is not functional, as 
you would need to use br0.1 to have a working data path taking care of 
the VLAN tag.

Vladimir had offered a DSA centric solution to this problem, which was 
not that bad after all, but this one is also my favorite.

Let us know when you are caught up on the thread and we can see how to 
solve that the best way.
-- 
Florian
