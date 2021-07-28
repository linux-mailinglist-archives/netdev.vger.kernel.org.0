Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05C3D9618
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhG1ThT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhG1ThS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:37:18 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FD8C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 12:37:16 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242] (unknown [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id D617F20465;
        Wed, 28 Jul 2021 12:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627501036;
        bh=h+OyJi0QQTsDGYul/BKDbOIr6zCsSUHnqFNZp8FBDO8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=o5gmrTOz6cJX2rh+VHwZ14+dH5/40kKdpv7oj9XaLpVJz71iOIZR4pXBWq3XeNGMN
         M5jo4x30rdLHt04Mfw/fCy4fs1mM9K6iNJtsevNUqa0QZPRK5RcMUjHAS5nR+cCJ9N
         n5PTUHhYeDHuKC8rdkYRawDLGu5y00bo84uUYxd4=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
Date:   Wed, 28 Jul 2021 12:37:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQGu2r02XdMR5Ajp@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 12:24 PM, Andrew Lunn wrote:
> On Wed, Jul 28, 2021 at 11:33:35AM -0700, Dario Alcocer wrote:
>> On 7/28/21 11:23 AM, Andrew Lunn wrote:
>>> On Wed, Jul 28, 2021 at 11:07:37AM -0700, Dario Alcocer wrote:
>>>> It appears the port link-state issue is caused by the mv88e6xxx switch
>>>> driver. The function mv88e6xxx_mac_config identifies the PHY as internal and
>>>> skips the call to mv88e6xxx_port_setup_mac.
>>>>
>>>> It does not make sense to me why internal PHY configuration should be
>>>> skipped.
>>>
>>> The switch should do the configuration itself for internal PHYs. At
>>> least that works for other switches. What value does CMODE have for
>>> the port? 0xf?
>>>
>>>       Andrew
>>>
>>
>> Is CMODE available via the DSA debugfs? Here are the registers for port0,
>> which should be lan1:
>>
>> root@dali:~# ls /sys/kernel/debug/dsa/switch0/
>> port0/        port1/        port2/        port3/        port4/ port5/
>> port6/        tag_protocol  tree
>> root@dali:~# ls /sys/kernel/debug/dsa/switch0/port0/
>> fdb    mdb    regs   stats  vlan
>> root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/regs
>>   0: 100f
> 
> It is the lower nibble of this register. So 0xf.
> 
> Take a look at:
> 
> https://github.com/lunn/mv88e6xxx_dump/blob/master/mv88e6xxx_dump.c
> 

Many thanks for the link; I will build and install it on the target. 
Hope it will work with the older kernel (5.4.114) we're using.

> The 1 in 100f means it has found the PHY. But there is no link,
> 10/Half duplex, etc.
> 
>>   1: 0003
> 
> This at least looks sensible. Nothing is forced, normal speed
> detection should be performed. So what should happen is the link
> speed, duplex etc from the internal PHY should directly appear in
> register 0. There is no need for software to ask the PHY and then
> configure the MAC.
> 

Ok, so the internal PHY seems to be configured as expected.

Does this mean that the issue is caused by the link partner?

I did notice that the RJ45 link LED on each of the peer devices no 
longer light up. Previously, the LED was coming on. Perhaps it's time to 
check the following:

- confirm the network cable for each link peer is good
- confirm each link peer works by connecting to a 100baseT or 1000baseT 
switch

Thanks again for all of your feedback!
