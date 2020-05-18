Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A141D883D
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgERTbG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 May 2020 15:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgERTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:31:06 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F32C061A0C;
        Mon, 18 May 2020 12:31:06 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jalTY-0005X0-Ml; Mon, 18 May 2020 21:31:00 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link support
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200517235026.GD610998@lunn.ch>
Date:   Mon, 18 May 2020 21:31:00 +0200
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EB9FB222-D08A-464F-93C0-5885C010D582@berg-solutions.de>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
 <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
 <20200517235026.GD610998@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589830266;97f21411;
X-HE-SMSGID: 1jalTY-0005X0-Ml
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks a lot for going into detail. I also want to make sure that everything will be right.

> Am 18.05.2020 um 01:50 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
>>>> +			/* Configure MAC to fixed link parameters */
>>>> +			data = lan743x_csr_read(adapter, MAC_CR);
>>>> +			/* Disable auto negotiation */
>>>> +			data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
>>> 
>>> Why does the MAC care about autoneg? In general, all the MAC needs to
>>> know is the speed and duplex.
>>> 
>> 
> 
>> My assumption is, that in fixed-link mode we should switch off the
>> autonegotiation between MAC and remote peer (e.g. a switch). I
>> didn’t test, if it would also wun with the hardware doing
>> auto-negotiation, however it feels cleaner to me to prevent the
>> hardware from initiating any auto-negotiation in fixed-link mode.
> 
> The MAC is not involved in autoneg. autoneg is between two PHYs. They
> talk with each other, and then phylibs sees the results and tells the
> MAC the results of the negotiation. That happens via this call
> back. So i have no idea what this is doing in general in the MAC. And
> in your setup, you don't have any PHYs at all. So there is no
> auto-neg. You should read the datasheet and understand what this is
> controlling. It might need to be disabled in general.

Thanks for making sure we’re doing things right.

I double checked the vendor documentation and according to the data sheet in this device the MAC detects speed and duplex mode. It uses PINs, traces clocks … Also according to an application note of the vendor duplex and speed detection should be enabled in the MAC registers. The current driver version (which is not fixed-link capable) does this. However, in a fixed-link scenario I don’t think that the autodetection, that the vendor recommends to turn on, of speed and duplex would solve problems, it rather likely introduces problems when the auto-detection from the MAC (yes, the MAC) yields different results than configured in the device tree.

So I think we should:
a) Keep the behavior to activate auto detection in the MAC in normal cases, as recommended by the data sheet. (And ensure backwards compatibility this way as well.)
b) But add the behavior to deactivate this kind of MAC auto detection in fixed link cases.

I found no documentation for fixed link operation in the data sheets, so a statement from the Vendor could give us higher confidence here. Unfortunately I have no access to the Vendor’s specialists (also not via the Microchip customer support for some reasons), but I think the vendor is on CC on this thread ;)

> 
>> Using get_phy_mode() in all cases is not possible on a PC as it
>> returns SGMII on a standard PC.
> 
> Why do you think that?

printk made me think so :) But I printk’ed without checking the error return value, so that was maybe just invalid or even random data.

> 
>>> I don't understand this comment.
>>> 
>> 
>> See above the lengthy section. On a PC SGMII is returned when I call of_get_phy_mode(phynode, &phyifc);
> 
> There are two things possible here:
> 
> A PC has no OF support, so you are using:
> 
> https://elixir.bootlin.com/linux/latest/source/include/linux/of_net.h#L19
> 
> So you get the error code -ENODEV, and phyifc is not changed.
> 
> Or you are using:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/of/of_net.c#L25
> 
> There is unlikely to be a device node, so phyifc is set to
> PHY_INTERFACE_MODE_NA and -ENODEV is returned.
> 
> So if of_get_phy_mode() returns an error, use RMII. Otherwise use what
> value it set phyifc to.
> 
>      Andrew
> 

Ok, consider it done, thanks :)

