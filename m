Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6916D1D88B6
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgERUBV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 May 2020 16:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgERUBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:01:20 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB210C061A0C;
        Mon, 18 May 2020 13:01:19 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jalwm-0003jY-9K; Mon, 18 May 2020 22:01:12 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link support
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200517183710.GC606317@lunn.ch>
Date:   Mon, 18 May 2020 22:01:07 +0200
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <557C3EE7-72FE-455C-9BB8-1FFB635D89FA@berg-solutions.de>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589832079;5b270686;
X-HE-SMSGID: 1jalwm-0003jY-9K
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks a lot for guiding me. A thought on the transparency of fixed-phy regarding this section:

> 
>> +			/* Set duplex mode */
>> +			if (phydev->duplex)
>> +				data |= MAC_CR_DPX_;
>> +			else
>> +				data &= ~MAC_CR_DPX_;
>> +			/* Set bus speed */
>> +			switch (phydev->speed) {
>> +			case 10:
>> +				data &= ~MAC_CR_CFG_H_;
>> +				data &= ~MAC_CR_CFG_L_;
>> +				break;
>> +			case 100:
(…)
> 
> The current code is unusual, in that it uses
> phy_ethtool_get_link_ksettings(). That should do the right thing with
> a fixed-link PHY, although i don't know if anybody uses it like
> this. So in theory, the current code should take care of duplex, flow
> control, and speed for you. Just watch out for bug/missing features in
> fixed link.
> 
> 

I checked your recommendations and I really would have loved to find a transparent layer that hides the speed/duplex configuration. But unfortunately I found no place that would set above’s bits in the registers (it was me who introduced this bits to the header file in my patch, they are unknown to the kernel). But this register settings need to be done in fixed-link mode. (Fixed-Link => no auto-negotiation => driver has to configure this bits for speed and duplex.)

The working mode of this device is usually:
- Turn on auto-negotiation (by setting a register in the MAC from the MCU)
- Wait until auto-negotiation is completed
- The auto-negotiation can now read back (speed and duplex) from the MAC registers
- However also the PHYs can be enumerated indirectly via MAC registers, which is where the kernel today gets the auto negotiation result from

Example from the data sheet of the lan7431 MAC layer:
————————
Automatic Speed Detection (ASD)
When set, the MAC ignores the setting of the MAC Configuration (CFG) field
and automatically determines the speed of operation. The MAC samples the
RX_CLK input to accomplish speed detection and reports the last determined
speed via the MAC Configuration (CFG) field.
When reset, the setting of the MAC Configuration (CFG) field determines
operational speed.
————————

So regarding the last sentence the driver will have to configure speed (also duplex) in fixed link mode and because no part of the kernel accesses this bits up to now, I’m afraid to come to the conclusion that we probably  need above’s code.

Thanks for sparring our patch, highly appreciated. I’m sorry that there might be no better solution than the one provided, at least I found none.

