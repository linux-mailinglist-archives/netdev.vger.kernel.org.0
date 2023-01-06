Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A7566019E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjAFN4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjAFNz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:55:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D116687B1;
        Fri,  6 Jan 2023 05:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vRe6UFQkbe43pVVwnShYMb3rFh8R0WSwAihI2zUUTrs=; b=AqhYRzo2jKPl5b1J+Wvk545wX7
        gphCsR8eivL7VCRo7FBIXzYCTewA86LPyCUY4NUQ8EHvbogTrjy4Kco8PkaCQvBoE08cmN9tF/aRn
        B0zlcNubhWWpedfwdout3768rEREWgfBgcEemfw2UGNgX1/4efOMnUFjCMQZOy3PB/ls=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDnC9-001KzV-SK; Fri, 06 Jan 2023 14:55:41 +0100
Date:   Fri, 6 Jan 2023 14:55:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Message-ID: <Y7goXXiRBE6XHuCc@lunn.ch>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
 <Y7bN4vJXMi66FF6v@lunn.ch>
 <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Why is this needed? When the MAC driver connects to the PHY, it passes
> > phy-mode. For RGMII, this is one of:
> 
> > linux/phy.h:	PHY_INTERFACE_MODE_RGMII,
> > linux/phy.h:	PHY_INTERFACE_MODE_RGMII_ID,
> > linux/phy.h:	PHY_INTERFACE_MODE_RGMII_RXID,
> > linux/phy.h:	PHY_INTERFACE_MODE_RGMII_TXID,
> > 
> > This tells you if you need to add a delay for the RX clock line, the
> > TX clock line, or both. That is all you need to know for basic RGMII
> > delays.
> > 
> 
> This basic delay can be controlled by hardware or the phy-mode which
> passes from MAC driver.
> Default value depends on power on strapping, according to the voltage
> of RXD0 pin (low = 0, turn off;   high = 1, turn on).
> 
> Add this for the case that This basic delay is controlled by hardware,
> and software don't change this.

You should always do what phy-mode contains. Always. We have had
problems in the past where a PHY driver ignored the phy-mode, and left
the PHY however it was strapped. Which worked. But developers put the
wrong phy-mode value in DT. Then somebody had a board which actually
required that the DT value really did work, because the strapping was
wrong. So the driver was fixed to respect the PHY mode, made that
board work, and broke all the other boards which had the wrong
phy-mode in DT.

If the user want the driver to leave the mode alone, use the
strapping, they should use PHY_INTERFACE_MODE_NA. It is not well
documented, but it is used in a few places. However, i don't recommend
it.

> >> +  motorcomm,tx-delay-fe-ps:
> > 
> > So you can only set the TX delay? What is RX delay set to? Same as 1G?
> > I would suggest you call this motorcomm,tx-internal-delay-fe-ps, so
> > that it is similar to the standard tx-internal-delay-ps.
> > 
> 
> TX delay has two type: tx-delay-ge-ps for 1G and tx-delay-fe-ps for 100M.
> 
> RX delay set for 1G and 100M, but it has two type, rx-delay-basic and
> rx-delay-additional-ps, RX delay = rx-delay-basic + rx-delay-additional-ps.
> 
> I will rename to  tx-internal-delay-fe-ps and  tx-internal-delay-ge-ps.

So you can set the TX delay for 1G and Fast, but RX delay has a single
setting for both 1G and Fast? Have you seen boards what actually need
different TX delays like this?

Just because the hardware supports something does not mean Linux needs
to support it. Unless there is a real need for it. So i would suggest
your drop this DT property, and set the Fast delay to the same as the
1G delay. If any board actually requires this in the future, the
property can be added then.

> 
> > These two i can see being useful. But everything afterwards seems like
> > just copy/paste from vendor SDK for things which the hardware can do,
> > but probably nobody ever uses. Do you have a board using any of the
> > following properties?
> > 
> 
> tx-clk-adj-enabled, tx-clk-10-inverted, tx-clk-100-inverted and
> tx-clk-1000-inverted is used and tested by  Yanhong
> Wang<yanhong.wang@starfivetech.com>. They used yt8531 on
> jh7110-starfive-visionfive-v2. This will provide an additional way to
> adjust the tx clk delay on yt8531.

O.K. So they are used with a real board. Can we reduce this down to
tx-clk-inverted? Have you ever seen a board which only needs the
invert for one speed and not the others? To me, that would be a very
odd design.

> sds-tx-amplitude can be tested on my yt8531s board.

Does the board break with the default value? Just because you can test
it on your RDK does not mean anybody will ever use it.

   Andrew
