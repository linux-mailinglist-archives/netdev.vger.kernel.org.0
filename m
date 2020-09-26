Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E68D279A2D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 16:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgIZOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 10:45:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbgIZOpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 10:45:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMBRp-00GHdg-P1; Sat, 26 Sep 2020 16:45:13 +0200
Date:   Sat, 26 Sep 2020 16:45:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        alexandre.torgue@st.com, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, joabreu@synopsys.com, kuba@kernel.org,
        peppe.cavallaro@st.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
Message-ID: <20200926144513.GD3850848@lunn.ch>
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
 <20200925221403.GE3856392@lunn.ch>
 <CAFBinCC4VuLJDLqQb+m+h+qnh6fAK2aBLVtQaE15Tc-zQq=KSg@mail.gmail.com>
 <20200926004129.GC3850848@lunn.ch>
 <CAFBinCAc2-QV3E8P4gk+7Lq0ushH08UoZ0tQ8ACEoda-D8oaWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCAc2-QV3E8P4gk+7Lq0ushH08UoZ0tQ8ACEoda-D8oaWg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I checked this again for the vendor u-boot (where Ethernet is NOT
> working) as well as the Android kernel which this board was shipped
> with (where Ethernet is working)
> - in u-boot the MAC side adds a 2ns TX delay and the PHY side adds a
> 2ns RX delay

So that suggest there is nothing on the PCB. It is all down to MAC and
PHY adding delays.

> yes, there's only one calibration value
> the reference code is calculating the calibration setting for four
> configuration variants:
> - 2ns TX delay on the MAC side, no RX or TX delay on the PHY side, RGMII RX_CLK not inverted
> - 2ns TX delay on the MAC side, no RX or TX delay on the PHY side, RGMII RX_CLK inverted
> - 2ns TX delay on the MAC side, 2ns RX delay on the PHY side, RGMII RX_CLK not inverted
> - 2ns TX delay on the MAC side, 2ns RX delay on the PHY side, RGMII RX_CLK inverted
> 
> now that I'm writing this, could it be a calibration of the RX_CLK
> signal?

Yes, seems like it. Which of these four does it end up using? I'm
guessing the 3rd?

So i would forget about configuration clock inversion. Hard code it to
whatever works. It is not something you see other MAC/PHY combinations
allow to configure.

I think you said a value of 0x2 works. I wonder if that corresponds to
something slightly larger than 0ns if option 3 is being used?

> In the meantime Amlogic's "hacked" PHY driver is also using these registers: [0]
> So I assume that I'm doing the right thing in the Realtek PHY driver

Thanks for confirming this. No need to check for the resistors.

       Andrew
