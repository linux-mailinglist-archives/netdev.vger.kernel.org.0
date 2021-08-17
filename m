Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD5F3EED84
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbhHQNeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:34:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236398AbhHQNeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=QUTwg1PYJ25ImTEHy3FkL3CVzBJV7BWBWBKF/Rs2oz0=; b=bI
        vYiBJoFc/Gu8qwH2Jmdd3bsepBoxpVN1tvw7m21aWmRpola4ahlPxou3edeUIWeQRcLzLAS9dfRe2
        rCaqFzto/uPQy1m9vFgJLMo8q4Fj0W2PU+sAmya2+HeZEBTl4Yu+UfUVDNVyD/tcAK49k1ly0POoZ
        iyHow95+DTot91U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFzDT-000Zqm-Da; Tue, 17 Aug 2021 15:33:19 +0200
Date:   Tue, 17 Aug 2021 15:33:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jie Luo <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
Message-ID: <YRu6n49p/Evecd8P@lunn.ch>
References: <20210816113440.22290-1-luoj@codeaurora.org>
 <YRpuhIcwN2IsaHzy@lunn.ch>
 <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 09:10:44PM +0800, Jie Luo wrote:
> 
> On 8/16/2021 9:56 PM, Andrew Lunn wrote:
> > On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
> > > qca8081 is industry’s lowest cost and power 1-port 2.5G/1G Ethernet PHY
> > > chip, which implements SGMII/SGMII+ for interface to SoC.
> > Hi Luo
> > 
> > No Marketing claims in the commit message please. Even if it is
> > correct now, it will soon be wrong with newer generations of
> > devices.
> > 
> > And what is SGMII+? Please reference a document. Is it actually
> > 2500BaseX?
> 
> Hi Andrew,
> 
> thanks for the comments, will remove the claims in the next patch.
> 
> SGMII+ is for 2500BaseX, which is same as SGMII, but the clock frequency of
> SGMII+ is 2.5 times SGMII.

25000BaseX is not SGMII over clocked at 2.5GHz.

If it is using 2500BaseX then call it 2500BaseX, because 2500BaseX is
well defined in the standards, and SGMII overclocked to 2.5G is not
standardised.

> > A lot of these registers look the same as the at803x. So i'm thinking
> > you should merge these two drivers. There is a lot of code which is
> > identical, or very similar, which you can share.
> 
> Hi Andrew,
> 
> qca8081 supports IEEE1588 feature, the IEEE1588 code may be submitted in the
> near future,
> 
> so it may be a good idea to keep it out from at803x code.

Please merge it. A lot of the code is the same, and a lot of the new
code you are adding will go away once you use the helpers. And
probably you can improve the features of the older PHYs at the same
time, where features are the same between them.

> > > +static int qca808x_phy_ms_seed_enable(struct phy_device *phydev, bool enable)
> > > +{
> > > +	u16 seed_enable = 0;
> > > +
> > > +	if (enable)
> > > +		seed_enable = QCA808X_MASTER_SLAVE_SEED_ENABLE;
> > > +
> > > +	return qca808x_debug_reg_modify(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
> > > +			QCA808X_MASTER_SLAVE_SEED_ENABLE, seed_enable);
> > > +}
> > This is interesting. I've not seen any other PHY does this. is there
> > documentation? Is the datasheet available?
> 
> this piece of code is for configuring the random seed to a lower value to
> make the PHY linked
> 
> as the SLAVE mode for fixing some IOT issue, for master/slave
> auto-negotiation, please refer to
> 
> https://www.ieee802.org/3/an/public/jul04/lynskey_2_0704.pdf.

And what happens when this device is used in an Ethernet switch? A
next generation of a qca8k? Take a look at
genphy_setup_master_slave().  Use MASTER_SLAVE_CFG_MASTER_PREFERRED or
MASTER_SLAVE_CFG_SLAVE_PREFERRED to decide how to bias the
master/slave decision.

     Andrew
