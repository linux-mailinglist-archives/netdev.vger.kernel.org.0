Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552AE1336F0
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 23:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgAGW7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 17:59:47 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:36336 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgAGW7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 17:59:47 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 9F8CE13C340;
        Tue,  7 Jan 2020 14:59:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9F8CE13C340
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1578437986;
        bh=CQUSDdosX+j3B4A+/8nNbwy5EJG+Jx7XT3wff41RTrs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=F2gKhYmAY2YuDV6NhQdWRX2F9wL+5I/HbJxrXZvTI8UntbPZ36Ap2cs+BODB8UGHh
         aqr1FoJR9/ZwRXcHug+F5eVeIBTFHWTTykkc2NSjHbWm8S02rfA4J24fGbVo4elJqY
         dwsrxFc9xKcc6IhgNxGmiH0lksgPrA344VzrSlM0=
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     Trev Larock <trev@larock.ca>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
 <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
 <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com>
 <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <9777beb0-0c9c-ef8b-22f0-81373b635e50@candelatech.com>
Date:   Tue, 7 Jan 2020 14:59:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/20 9:58 PM, Trev Larock wrote:
> On Sun, Jan 5, 2020 at 11:29 PM David Ahern <dsahern@gmail.com> wrote:
>> I was able to adapt your commands with the above and reproduced the
>> problem. I need to think about the proper solution.
>>
> Ok thanks for investigating.
> 
>> Also, I looked at my commands from a few years ago (IPsec with VRF) and
>> noticed you are not adding a device context to the xfrm policy and
>> state. e.g.,
>>
> Yes was part of my original query, that makes sense in order to be able to have
> multiple vrf each with their own xfrm policies.
> I will investigate further on it.  The oif passed to xfrm_lookup seemed to be
> enp0s8 oif rather than vrf0 oif, so I was observing just cleartext
> pings go out / policy wouldn't match.
> Perhaps I'm missing something to get vrf0 oif passed for the ping packet.

As luck would have it, I am investigating problems that sound very similar
today.

In my case, I'm not using network name spaces.  For instance:

eth1 is the un-encrypted interface
x_eth1 is the xfrm network device on top of eth1
both belong to _vrf1

What I see is that packets coming in eth1 from the VPN are encrypted and received
on x_eth1.

But, UDP frames that I am trying very hard to send on x_eth1 (SO_BINDTODEVICE is called)
are not actually sent from there but instead go out of eth1 un-encrypted.

David:  I'll be happy to test patches, and if you think it will be a while
before you can write them, if you want to point me to the likely problem places,
I can make an attempt at fixing it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

