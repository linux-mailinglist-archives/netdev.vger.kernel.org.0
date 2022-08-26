Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961525A3020
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344598AbiHZTmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245076AbiHZTmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:42:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B32D571A;
        Fri, 26 Aug 2022 12:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h0e8hrYZfBnA260sHoSevKRKR3k7440CqGW7FeAzwLU=; b=Ak+dlcgwpEInjYw9VkXGNh0etu
        plTwstn1brCe1z2wG8gv5nNbIIZc7zXi9cS9AbsXa4y6FbcERoN0nYT+lKP4jJ+Q6kx2eVUHA1/nc
        OYu1ZuPriJ2ozCOZnVQNhVnitCGaufhg+R7170uzOFB5WmwQ5m6GFDB2MLFg9vYsgYZ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRfDy-00Eibg-8n; Fri, 26 Aug 2022 21:42:38 +0200
Date:   Fri, 26 Aug 2022 21:42:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <YwkiLoZkkl2cVcOT@lunn.ch>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <YwfvaSFejdtPtZgK@lunn.ch>
 <CO1PR11MB4771E1680E841F91411AE6DFE2759@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771E1680E841F91411AE6DFE2759@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I just took a quick look at the datasheet. It says:
> > 
> 
> I'm not sure the datasheet you looked into is the right one. Could you please crosscheck if its lan8814 or lan8841.
> Lan8814 is quad port phy where register access are of extended page. Lan8841 is 1 port phy where register access are mmd access.
> 
> > All registers references in this section are in MMD Device Address 1
> > 
> > So you should be using phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> > xxx) to read/write these registers. The datasheet i have however is missing
> > the register map, so i've no idea if it is still 0xe6.

https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/DS-LAN8814-00003592C.pdf

5.13.4 OPEN ALLIANCE TC1/TC12 DCQ SIGNAL QUALITY INDEX

Note: All registers references in this section are in MMD Device Address 1.

This section defines the implementation of section 6.1.2 of the TC1
and TC12 specifications. This mode builds upon the OPEN Alliance
TC1/TC12 DCQ Mean Square Error method by mapping the MSE value onto a
simple quality index. This mode is enabled by setting the sqi_enable
bit, in the DCQ Configuration register.

The MSE value is compared to the thresholds set in the DCQ SQI Table
Registers to provide an SQI value between 0 (worst value) and 7 (best
value) as follows:

In order to capture the SQI value, the DCQ Read Capture bit in the DCQ
Configuration register needs to be written as a high with the desired
cable pair specified in the DCQ Channel Number field of the same
register. The DCQ Read Capture bit will immediately self-clear and the
result will be available in the DCQ SQI register.  In addition to the
current SQI, the worst case (lowest) SQI since the last read is
available in the SQI Worst Case field.  The correlation between the
SQI values stored in the DCQ SQI register and an according Signal to
Noise Ratio (SNR) based on Additive White Gaussian (AWG) noise
(bandwidth of 80 MHz @ 100 Mbps / 550 MHz @ 1000 Mbps) is shown in
Table 5-5. The bit error rates to be expected in the case of white
noise as interference signal is shown in the table as well for
information purposes.

I had a quick look at OPEN ALLIANCE specification. It seems to specify
how each of these registers should look. It just failed to specify
where in the address map they are. So if you look at drivers
implementing SQI, you see most poke around in MDIO_MMD_VEND1.  I
wounder if we can actually share the implementation between drivers,
those that follow the standard, with some paramatirisation where the
registers are.

	  Andrew
