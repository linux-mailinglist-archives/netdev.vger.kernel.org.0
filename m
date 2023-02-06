Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F7968C27A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjBFQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjBFQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:07:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C588172F;
        Mon,  6 Feb 2023 08:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0yZyqa8cN33q2wshRD6t08U42KjC6hA9qW+HWH8pOwA=; b=Zp5zSX/BzQ9S2C0HJe9g5Oa3L0
        gWqgKEHPaXRtse9ZRtq+ppcmW3Evne7pxeAHPgZqA+sVTa6NZGjEouvfLMw8IjiyYTyLGrUlVX9YZ
        pZX5CWNXQj51GMjcW59sWAJsvkajI2KHB59VsvJmFAIj2n0wQrGkYvHgfRMegLNk+jwY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP3dx-004DVG-AC; Mon, 06 Feb 2023 16:42:57 +0100
Date:   Mon, 6 Feb 2023 16:42:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <Y+EgAZxcTVjYu8ew@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-3-o.rempel@pengutronix.de>
 <20230204005418.7ryb4ihuzxlbs2nl@skbuf>
 <20230206104955.GE12366@pengutronix.de>
 <20230206112246.pazwn7r75oru5iq3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206112246.pazwn7r75oru5iq3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 01:22:46PM +0200, Vladimir Oltean wrote:
> On Mon, Feb 06, 2023 at 11:49:55AM +0100, Oleksij Rempel wrote:
> > > Why stop at 10GBase-KR? Register 3.20 defines EEE abilities up to 100G
> > > (for speeds >10G, there seem to be 2 modes, "deep sleep" or "fast wake",
> > > with "deep sleep" being essentially equivalent to the only mode
> > > available for <=10G modes).
> > 
> > Hm,
> > 
> > If i take only deep sleep, missing modes are:
> > 3.20.13 100GBASE-R deep sleep
> >        family of Physical Layer devices using 100GBASE-R encoding:
> >        100000baseCR4_Full
> >        100000baseKR4_Full
> >        100000baseCR10_Full (missing)
> >        100000baseSR4_Full
> >        100000baseSR10_Full (missing)
> >        100000baseLR4_ER4_Full
> > 
> > 3.20.11 25GBASE-R deep sleep
> >        family of Physical Layer devices using 25GBASE-R encoding:
> >        25000baseCR_Full
> >        25000baseER_Full (missing)
> >        25000baseKR_Full
> >        25000baseLR_Full (missing)
> >        25000baseSR_Full
> > 
> > 3.20.9 40GBASE-R deep sleep
> >        family of Physical Layer devices using 40GBASE-R encoding:
> >        40000baseKR4_Full
> >        40000baseCR4_Full
> >        40000baseSR4_Full
> >        40000baseLR4_Full
> > 
> > 3.20.7 40GBASE-T
> >        40000baseT_Full (missing)
> > 
> > I have no experience with modes > 1Gbit. Do all of them correct? What
> > should we do with missing modes? Or may be it make sense to implement >
> > 10G modes separately?
> 
> Given the fact that UAPI needs an extension to cover supported/advertisement
> bits > 31, I think it makes sense to add these separately. I had not
> realized this when I commented on this patch. I don't think we want the
> kernel to advertise EEE for some link modes without user space seeing it.

We also don't currently support any PHYs which do more than 10G. So i
don't see any need for 40GB and above at the moment.

      Andrew
