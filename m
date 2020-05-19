Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF96E1D9D10
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgESQmm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 12:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgESQml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:42:41 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A35C08C5C0;
        Tue, 19 May 2020 09:42:41 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jb5K6-00009u-KC; Tue, 19 May 2020 18:42:34 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link support
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200518203447.GF624248@lunn.ch>
Date:   Tue, 19 May 2020 18:42:33 +0200
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F241F806-3A08-4086-9739-361538FD246B@berg-solutions.de>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
 <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
 <20200517235026.GD610998@lunn.ch>
 <EB9FB222-D08A-464F-93C0-5885C010D582@berg-solutions.de>
 <20200518203447.GF624248@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1589906561;db22fcd6;
X-HE-SMSGID: 1jb5K6-00009u-KC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

thank you for the example, your input got me further. Sorry if my e-mails made the impression that the MAC is sending MDIO on its own. It can issue MDIO but I assume it will do this only on request of the MCU.

I read the data sheets again and found what might have confused us. There is:
a) Auto Negotiation (Phy-Phy)
b) Automatic Speed Detection, ASD (Mac-Phy)
c) Automatic Duplex Detection, ADD (Mac-Phy)

My current hypothesis is: When Phy-Phy auto negotiation is done, the ASD and ADD of the MAC will implicitly catch up the new mode of the Phy on a low level (clocks, pins). A dumb silicon would need the MCU to re-configure the MAC after MDIO told the MCU about a change in the Phy mode. But this ultra smart silicon would neither need MDIO, nor an MCU to understand what’s going on on the busses :)

If this hypothesis is correct, I should change in the driver all comments that mention „auto negoriation“ to „ADD, ASD“, and future readers will not be confused anymore.

Conclusion:
- Maybe I can leave ASD and ADD even active in fixed-link scenarios, when in the device tree an empty fixed-link node is present.
- And I need to disable ASD and/or ADD only if speed and/or duplex is configured inside the fixed-link mode.

I need to verify this hypothesis.

Thank you for reviewing and sharing topics we need to consider,
Roelof

> Am 18.05.2020 um 22:34 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
>> I double checked the vendor documentation and according to the data
>> sheet in this device the MAC detects speed and duplex mode. It uses
>> PINs, traces clocks … Also according to an application note of the
>> vendor duplex and speed detection should be enabled in the MAC
>> registers.
> 
> In general, the MAC should not perform MDIO requests on the PHY.  The
> MAC has no access to the mutex which phylib users. So if the MAC
> directly accesses registers in the PHY, it could do it at the wrong
> time, when the PHY driver is active.
> 
> This can be particularly bad when Marvell PHYs are used. They have
> paged registers. One example is the page with the temperature sensor.
> This can be selected due to a read on the hwmon device. If the MAC
> tried to read the speed/duplex which the temperature sensor is
> selected, it would wrongly read the temperature sensor registers, not
> the link state.
> 
> There is no need for the MAC to directly access the PHY. It will get
> told what the result of auto-neg is. So please turn this off all the
> time.
> 
> 	Andrew
> 

