Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6405A6315
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiH3MRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiH3MRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:17:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A24AB41E;
        Tue, 30 Aug 2022 05:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aIP+WVaMc1nJy/asMHv8LFrhhyHBgcCdUD1nWkCarDY=; b=jRAgsNifyCmFk62Jvng7ixAvg8
        MyaTIB0XbeZftng3h67Jl4PHyE+37F9JMw2mG++qrI4Ex2a/mFVUxpXeBer066eqE8A3R6Aifp2WB
        vnn2etoh/Yoq6H5uzR5YbS7lXoOvHCduPqVsqGS4+y+K/ty+BcEX6gXXS+yb+6ZFLfv4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oT0Au-00F4O3-1P; Tue, 30 Aug 2022 14:17:00 +0200
Date:   Tue, 30 Aug 2022 14:17:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Message-ID: <Yw3/vIDAr9W7zZwv@lunn.ch>
References: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
 <Ywd4oUPEssQ+/OBE@lunn.ch>
 <DM6PR11MB43480C1D3526031F79592A7F81799@DM6PR11MB4348.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB43480C1D3526031F79592A7F81799@DM6PR11MB4348.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -2015,14 +2016,23 @@ static int m88e1510_loopback(struct
> > phy_device *phydev, bool enable)
> > >  		if (err < 0)
> > >  			return err;
> > >
> > > -		/* FIXME: Based on trial and error test, it seem 1G need to
> > have
> > > -		 * delay between soft reset and loopback enablement.
> > > -		 */
> > > -		if (phydev->speed == SPEED_1000)
> > > -			msleep(1000);
> > > +		if (phydev->speed == SPEED_1000) {
> > > +			err = phy_read_poll_timeout(phydev, MII_BMSR,
> > val, val & BMSR_LSTATUS,
> > > +						    PHY_LOOP_BACK_SLEEP,
> > > +
> > PHY_LOOP_BACK_TIMEOUT, true);
> > 
> > Is this link with itself?
>  
> Its required cabled plug in, back to back connection.

Loopback should not require that. The whole point of loopback in the
PHY is you can do it without needing a cable.

> > 
> > Have you tested this with the cable unplugged?
> 
> Yes we have and its expected to have the timeout. But the self-test required the link
> to be up first before it can be run.

So you get an ETIMEDOUT, and then skip the code which actually sets
the LOOPBACK bit?

Please look at this again, and make it work without a cable.

Maybe you are addressing the wrong issue? Is the PHY actually
performing loopback, but reporting the link is down? Maybe you need to
fake a link up? Maybe you need the self test to not care about the
link state, all it really needs is that packets get looped?

       Andrew
