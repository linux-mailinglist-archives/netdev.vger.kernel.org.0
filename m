Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584D763C1DF
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiK2OIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbiK2OH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:07:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FBE29CB3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=87VUQ394eDovEkxGBBd3pkvs/T9mI6sjKwjZhUY1p8I=; b=q5Ofp+Gt1/sb7N3OaNfsAM57v2
        +fkXUcHp/lrcra5NB1YTKz8NAoKmtu8RMOlmHOSWRbVFDWVgOgyJiEnTKPsZBb2yDjWkbGqKby62U
        VanXNAF8xiStd57HEimqnqriim79e05XEVi0cYYBAKu+1OijK34dVxiQCAikBoKXjpn8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p01Gz-003sME-6h; Tue, 29 Nov 2022 15:07:45 +0100
Date:   Tue, 29 Nov 2022 15:07:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y4YSMV3y6kA1VJ5F@lunn.ch>
References: <20221122175603.soux2q2cxs2wfsun@skbuf>
 <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
 <20221122193618.p57qrvhymeegu7cs@skbuf>
 <Y34NK9h86cgYmcoM@shell.armlinux.org.uk>
 <Y34b+7IOaCX401vR@shell.armlinux.org.uk>
 <20221125123022.cnqobhnuzyqb5ukw@skbuf>
 <Y4DGhv/6BHNaMEYQ@shell.armlinux.org.uk>
 <20221125153555.uzrl7j2me3lh2aeg@skbuf>
 <Y4PhVWmM6//kDoE/@shell.armlinux.org.uk>
 <Y4YL6oxIFvSMYaCl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4YL6oxIFvSMYaCl@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > However, I've just tripped over some information in the 88E1111
> > manual which states that in SGMII mode, if bypass mode is used, then
> > the PHY will apparently renegotiate on the copper side advertising
> > 1000baseT HD and FD only, no pause. So I checked what my link partner
> > is seeing, and it was seeing the original advertisement.
> > 
> > So I then triggered a renegotiate from the partner, and it now shows
> > only 1000baseT/Half 1000baseT/Full being advertised by the 88E1111.
> > Reading the advertisement register, it still contains 0x0d41, which
> > shows pause modes, 100FD, 10FD - so the advertisement register doesn't
> > reflect what was actually adfertised in this case.
> > 
> > Also, presumably, based on this observation, it will only renegotiate
> > if the copper side hadn't resolved to gigabit. If correct, what this
> > means is that when operating in SGMII mode, the the PHY becomes
> > gigabit-only if bypass mode gets used.
> > 
> > Given this behaviour, the fact that it switches to gigabit only when
> > the SGMII side enters bypass mode, I think we should _positively_ be
> > disabling inband bypass in SGMII mode. This change in advertisement
> > is not what phylib would expect, and I suspect could lead to surprises
> > e.g. if phylib was told to advertise non-gigabit speeds only.

Sorry, i've not been reading this thread.

This behaviour is not very nice. So i agree, it should be avoided if
possible.

> > Thanks for testing. So that means m88e1111_config_init_sgmii() will not
> > enable in-band if it was previously disabled. So we need to check the
> > fiber ANENABLE bit and unconditionally return PHY_AN_INBAND_OFF if it is
> > clear before evaluating anything else.
> > 
> > Also, given this behaviour of bypass mode, it seems it would only make
> > sense if the PHY were operating in 1000base-X mode, which we don't do
> > with SFPs, so maybe it makes no sense to support the ON_TIMEOUT as an
> > option right now - and as I say above, maybe we should be focing the
> > AN bypass allow bit to be clear in SGMII mode.
> > 
> > I think maybe Andrew needs to be involved in that last bit though.

As you say, 1000Base-X does not make much sense for a copper
SFP. SGMII does odd things, so just not supporting ON_TIMEOUT seems
reasonable.

	Andrew
