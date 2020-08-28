Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCE725635E
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgH1XOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 19:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgH1XOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 19:14:33 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078FBC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 16:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zbVs93AHemIWC2qXLyY1D/Kiw3dm5eJ6GlwiZwUkyAc=; b=OkUlCkWiS5RDNlfs0mcS27TE7f
        khrBPb0i89yuyBRv3Fh3/AvA/wLyhCKccXzBo3GC/YYJ7A7iyX7//GGI5dQWeAxh7fS+LqDilZX3l
        d/qWpDQ9H7py0xH1X10WhfK60Lsa0EktjYlJfnRgwCBxNfqNI1SNaDR2PtbKjOg79Gn0vFwo9wBuv
        sM4RO+WVdApM0riTkJ0gANygG4nJfpYIUA8uTluDWDUo//ZYSM4j7AiZVyw5PPR9UHk/hWuAsEZg6
        LVIdLSrgDxADdaHIcXxg0YGLkobSVoITIU7X9XqfCGOg6Hp+nTIdlESlyU41gM3fxiSvMq1Wxb3Fi
        5MNShRmw==;
Received: from [185.135.2.46] (helo=[172.20.10.2])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kBnZn-00GohN-EZ; Sat, 29 Aug 2020 01:14:31 +0200
Subject: Re: drivers/of/of_mdio.c needs a small modification
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, frowand.list@gmail.com, f.fainelli@gmail.com,
        netdev <netdev@vger.kernel.org>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
Date:   Sat, 29 Aug 2020 01:14:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200828225353.GB2403519@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2020-08-29 o 00:53, Andrew Lunn pisze:
> On Sat, Aug 29, 2020 at 12:34:05AM +0200, Adam Rudziński wrote:
>> Hi Andrew.
>>
>> W dniu 2020-08-29 o 00:28, Andrew Lunn pisze:
>>> Hi Adam
>>>
>>>> If kernel has to bring up two Ethernet interfaces, the processor has two
>>>> peripherals with functionality of MACs (in i.MX6ULL these are Fast Ethernet
>>>> Controllers, FECs), but uses a shared MDIO bus, then the kernel first probes
>>>> one MAC, enables clock for its PHY, probes MDIO bus tryng to discover _all_
>>>> PHYs, and then probes the second MAC, and enables clock for its PHY. The
>>>> result is that the second PHY is still inactive during PHY discovery. Thus,
>>>> one Ethernet interface is not functional.
>>> What clock are you talking about? Do you have the FEC feeding a 50MHz
>>> clock to the PHY? Each FEC providing its own clock to its own PHY? And
>>> are you saying a PHY without its reference clock does not respond to
>>> MDIO reads and hence the second PHY does not probe because it has no
>>> reference clock?
>>>
>>> 	  Andrew
>> Yes, exactly. In my case the PHYs are LAN8720A, and it works this way.
> O.K. Boards i've seen like this have both PHYs driver from the first
> MAC. Or the clock goes the other way, the PHY has a crystal and it
> feeds the FEC.
>
> I would say the correct way to solve this is to make the FEC a clock
> provider. It should register its clocks with the common clock
> framework. The MDIO bus can then request the clock from the second FEC
> before it scans the bus. Or we add the clock to the PHY node so it
> enables the clock before probing it. There are people who want this
> sort of framework code, to be able to support a GPIO reset, which
> needs releasing before probing the bus for the PHY.
>
> Anyway, post your patch, so we get a better idea what you are
> proposing.
>
> 	Andrew

Hm, this sounds reasonable, but complicated at the same time. I have 
spent some time searching for possible solution and never found anything 
teaching something similar, so I'd also speculate that it's kind of not 
very well documented. That doesn't mean I'm against these solutions, 
just that seems to be beyond capabilities of many mortals who even try 
to read.

OK, so a patch it is. Please, let me know how to make the patch so that 
it was useful and as convenient as possible for you. Would you like me 
to use some specific code/repo/branch/... as its base?

Best regards,
Adam

