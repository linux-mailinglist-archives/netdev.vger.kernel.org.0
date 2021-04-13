Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E901835D895
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhDMHOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:14:41 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:57094 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhDMHOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=pd1fHE23NfZnQxckUIslFHR/YDaX2qQtIgwkeLQlW58=;
        b=tnao5w7c9/I5l1BAlRvwEibBaCdse6jXQD2iKfsWWLWt+MmKLCgmiCoexYEMA9EtQ1THmrZL0R0TU
         ni/LXp1IiY9WvPJSLarXfAHr5tlB+Zc3XSiuz6ahgK2AVtwNspbRKH120MIPGm++2j+iKgx7GFeWrY
         ez+wMr31yLn7KRDsyhcBbk5rrBf6647SC6UgmEO3jSHDnaoqjShuGblYZA7iLnjhG3LRImo5Q+1kC4
         OzsParxeeq8+Vczj3xqcVE/cyM8zJYwj6KgST4+qWdzEpLXgFeD9eF13LHkvnYytCXi8zQeJAxcWaG
         A0hdQRs8JO6WxTRcw0QLcL7FskCmIdA==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 10:14:03 +0300
Date:   Tue, 13 Apr 2021 10:13:49 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     system@metrotek.ru, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <20210413071349.r374hxctgboj7l5a@dhcp-179.ddg>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <20210413013122.7fa0195f@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210413013122.7fa0195f@thinkpad>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 01:32:12AM +0200, Marek Behún wrote:
> On Mon, 12 Apr 2021 15:16:59 +0300
> Ivan Bornyakov <i.bornyakov@metrotek.ru> wrote:
> 
> > Some SFP modules uses RX_LOS for link indication. In such cases link
> > will be always up, even without cable connected. RX_LOS changes will
> > trigger link_up()/link_down() upstream operations. Thus, check that SFP
> > link is operational before actual read link status.
> > 
> > Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> > ---
> >  drivers/net/phy/marvell-88x2222.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
> > index eca8c2f20684..fb285ac741b2 100644
> > --- a/drivers/net/phy/marvell-88x2222.c
> > +++ b/drivers/net/phy/marvell-88x2222.c
> > @@ -51,6 +51,7 @@
> >  struct mv2222_data {
> >  	phy_interface_t line_interface;
> >  	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
> > +	bool sfp_link;
> >  };
> >  
> >  /* SFI PMA transmit enable */
> > @@ -148,6 +149,9 @@ static int mv2222_read_status(struct phy_device *phydev)
> >  	phydev->speed = SPEED_UNKNOWN;
> >  	phydev->duplex = DUPLEX_UNKNOWN;
> >  
> > +	if (!priv->sfp_link)
> > +		return 0;
> > +
> 
> So if SFP is not used at all, if this PHY is used in a different
> usecase, this function will always return 0? Is this correct?
> 

Yes, probably. The thing is that I only have hardware with SFP cages, so
I realy don't know if this driver work in other usecases. The good thing
about open source is that other developers with different hardware
configurations can rework here and there and contribute back. Right?

> >  	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
> >  		link = mv2222_read_status_10g(phydev);
> >  	else
> > @@ -446,9 +450,31 @@ static void mv2222_sfp_remove(void *upstream)
> >  	linkmode_zero(priv->supported);
> >  }
> >  
> > +static void mv2222_sfp_link_up(void *upstream)
> > +{
> > +	struct phy_device *phydev = upstream;
> > +	struct mv2222_data *priv;
> > +
> > +	priv = (struct mv2222_data *)phydev->priv;
> > +
> > +	priv->sfp_link = true;
> > +}
> > +
> > +static void mv2222_sfp_link_down(void *upstream)
> > +{
> > +	struct phy_device *phydev = upstream;
> > +	struct mv2222_data *priv;
> > +
> > +	priv = (struct mv2222_data *)phydev->priv;
> 
> This cast is redundant since the phydev->priv is (void*). You can cast
> (void*) to (struct ... *).
> 
> You can also just use
> 	struct mv2222_data *priv = phydev->priv;
>

Yeah, I know, but reverse XMAS tree wouldn't line up.

> > +
> > +	priv->sfp_link = false;
> > +}
> > +
> >  static const struct sfp_upstream_ops sfp_phy_ops = {
> >  	.module_insert = mv2222_sfp_insert,
> >  	.module_remove = mv2222_sfp_remove,
> > +	.link_up = mv2222_sfp_link_up,
> > +	.link_down = mv2222_sfp_link_down,
> >  	.attach = phy_sfp_attach,
> >  	.detach = phy_sfp_detach,
> >  };
> 

