Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83656637E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiGEG40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 02:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGEG4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 02:56:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5F15FCC;
        Mon,  4 Jul 2022 23:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5hLcT9xMVVzWgNKqqBmeG2OD0SVhyFx7tF2XI4e10ho=; b=OrdoIFEWbb0n0hObbZmkM6rpUp
        WLOYx5hp+p4cM0Qcxla+JsBLLJczm+rRa/WFDJqsyh2YDJlMKGtbvx2yUbeyEeCVEBv0D/ynsvKh8
        r4PEQZpeLwnrzxGHrT6TVwpTBn3DIykpT/3eVQ9HYG89kREed5/Txlixcm1d0OgeHkWQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o8cTo-009LCx-PL; Tue, 05 Jul 2022 08:56:16 +0200
Date:   Tue, 5 Jul 2022 08:56:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH stable 4.9] net: dsa: bcm_sf2: force pause link settings
Message-ID: <YsPgkExHpr1NFdJw@lunn.ch>
References: <20220704153510.3859649-1-f.fainelli@gmail.com>
 <20220704233457.tgnenjn3ct6us75i@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704233457.tgnenjn3ct6us75i@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 02:34:57AM +0300, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Mon, Jul 04, 2022 at 08:35:07AM -0700, Florian Fainelli wrote:
> > From: Doug Berger <opendmb@gmail.com>
> > 
> > commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
> > 
> > The pause settings reported by the PHY should also be applied to the GMII port
> > status override otherwise the switch will not generate pause frames towards the
> > link partner despite the advertisement saying otherwise.
> > 
> > Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> > Signed-off-by: Doug Berger <opendmb@gmail.com>
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  drivers/net/dsa/bcm_sf2.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> > index 40b3adf7ad99..03f38c36e188 100644
> > --- a/drivers/net/dsa/bcm_sf2.c
> > +++ b/drivers/net/dsa/bcm_sf2.c
> > @@ -671,6 +671,11 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
> >  		reg |= LINK_STS;
> >  	if (phydev->duplex == DUPLEX_FULL)
> >  		reg |= DUPLX_MODE;
> > +	if (phydev->pause) {
> > +		if (phydev->asym_pause)
> > +			reg |= TXFLOW_CNTL;
> > +		reg |= RXFLOW_CNTL;
> > +	}
> 
> Is this correct? phydev->pause and phydev->asym_pause keep the Pause and
> Asym_Pause bits advertised by the link partner. In other words, in this
> manual resolution you are ignoring what the local switch port has
> advertised.

linkmode_resolve_pause() is not used yet outside of phylink, but
should help here.

       Andrew
