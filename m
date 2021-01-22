Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1CB300189
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbhAVL1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:27:14 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:60985 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbhAVLVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 06:21:44 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6BF8023E55;
        Fri, 22 Jan 2021 12:20:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1611314428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N0jkU0A6+sRQTSTbqXmOfHIS/IFpKYV+/+z5rJ/xeBA=;
        b=ZfMHxkrJan8uxD2NBz35wsua6hbv8vOj+NC6uWxmbpGqf5Na9wjutQkkwPoBqT21QK/vPM
        TcSdLag1W8AKtV1j4L+HoEZpH/3uaDQvE21zDDFHq+c5p5z1OzaZhD2YYRQlut0pW3UkLd
        +lXKx0rOmkBrpSPAV8PT1C1KAYL7jG8=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 22 Jan 2021 12:20:27 +0100
From:   Michael Walle <michael@walle.cc>
To:     Claudiu.Beznea@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas.Ferre@microchip.com, davem@davemloft.net
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
In-Reply-To: <1bde9969-8769-726b-02cb-a1fcded0cd74@microchip.com>
References: <20210120194303.28268-1-michael@walle.cc>
 <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
 <bd029c647db42e05bf1a54d43d601861@walle.cc>
 <1bde9969-8769-726b-02cb-a1fcded0cd74@microchip.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <9737f7e5e53790ca5acbea8f07ddf1a4@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-01-22 10:10, schrieb Claudiu.Beznea@microchip.com:
> On 21.01.2021 11:41, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
>> the
>> content is safe
>> 
>> Hi Claudiu,
>> 
>> Am 2021-01-21 10:19, schrieb Claudiu.Beznea@microchip.com:
>>> On 20.01.2021 21:43, Michael Walle wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you 
>>>> know
>>>> the content is safe
>>>> 
>>>> If the MII interface is used, the PHY is the clock master, thus 
>>>> don't
>>>> set the clock rate. On Zynq-7000, this will prevent the following
>>>> warning:
>>>>   macb e000b000.ethernet eth0: unable to generate target frequency:
>>>> 25000000 Hz
>>>> 
>>> 
>>> Since in this case the PHY provides the TX clock and it provides the
>>> proper
>>> rate based on link speed, the MACB driver should not handle the
>>> bp->tx_clk
>>> at all (MACB driver uses this clock only for setting the proper rate 
>>> on
>>> it
>>> based on link speed). So, I believe the proper fix would be to not 
>>> pass
>>> the
>>> tx_clk at all in device tree. This clock is optional for MACB driver.
>> 
>> Thanks for looking into this.
>> 
>> I had the same thought. But shouldn't the driver handle this case
>> gracefully?
>> I mean it does know that the clock isn't needed at all.
> 
> Currently it may knows that by checking the bp->tx_clk. Moreover the 
> clock
> could be provided by PHY not only for MII interface.

That doesn't make this patch wrong, does it? It just doesn't cover
all use cases (which also wasn't covered before).

> Moreover the IP has the bit "refclk" of register at offset 0xc (userio)
> that tells it to use the clock provided by PHY or to use one internal 
> to
> the SoC. If a SoC generated clock would be used the IP logic may have 
> the
> option to do the proper division based on link speed (if IP has this 
> option
> enabled then this should be selected in driver with capability
> MACB_CAPS_CLK_HW_CHG).
> 
> If the clock provided by the PHY is the one to be used then this is
> selected with capability MACB_CAPS_USRIO_HAS_CLKEN. So, if the change 
> you
> proposed in this patch is still imperative then checking for this
> capability would be the best as the clock could be provided by PHY not 
> only
> for MII interface.

Fair enough, but this register doesn't seem to be implemented on
Zynq-7000. Albeit MACB_CAPS_USRIO_DISABLED isn't defined for the
Zynq MACB. It isn't defined in the Zynq-7000 reference manual and
you cannot set any bits:

=> mw 0xE000B00C 0xFFFFFFFF
=> md 0xE000B00C 1
e000b00c: 00000000

Also please note, that tx_clk may be an arbitrary clock which doesn't
necessarily need to be the clock which is controlled by CLK_EN. Or
am I missing something here?

-michael

>> Ususually that
>> clock
>> is defined in a device tree include. So you'd have to redefine that 
>> node
>> in
>> an actual board file which means duplicating the other clocks.
>> 
>> -michael
