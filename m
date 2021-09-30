Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D7641DAC5
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350302AbhI3NRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:17:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350073AbhI3NRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6PZ49cSEBhLem0jcEWWbaHG2DFFufyxYvXcOVSWTwNQ=; b=2TM7VCntIA9nq6dLq8rKJqwp6J
        YiJcyL1+ITpJL8GVCi2yTqCwmShQVOyTOpleGPYfeStm12QjEVV7OcEzN6d/SL1Zuh5/GmDA/pfTG
        nEI4tarqOQWErLTFNqPgX9chKwCCZTvA5xelZWGD2isjcDsTluWj0cOG7YA9FvuIZQ1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVvtx-008x3A-PZ; Thu, 30 Sep 2021 15:15:05 +0200
Date:   Thu, 30 Sep 2021 15:15:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YVW4WX9oq9o318Im@lunn.ch>
References: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 10:33:16PM -0700, Saravana Kannan wrote:
> On Tue, Aug 31, 2021 at 4:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > interrupt properties, so don't loop back to their parent device.
> >
> > This is interesting and not what I really expected to happen. It goes to
> > show that we really need more time to understand all the subtleties of
> > device dependencies before jumping on patching stuff.
> >
> > In case the DSA tree contains more than one switch, different things
> > will happen in dsa_register_switch().
> > The tree itself is only initialized when the last switch calls
> > dsa_register_switch(). All the other switches just mark themselves as
> > present and exit probing early. See this piece of code in dsa_tree_setup:
> >
> >         complete = dsa_tree_setup_routing_table(dst);
> >         if (!complete)
> >                 return 0;
> 
> Hi Vladimir,
> 
> Can you point me to an example dts file that has a DSA tree with more
> than one switch and also point me to the switches that form the tree?
> 
> I'm working on a RFC series that tries to improve some stuff and
> having an example DTS to look at would help.

Some of the Zodiac boards have multiple switches. They are all Marvell
switches, using the mv88e6xxx driver.

arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
arch/arm/boot/dts/vf610-zii-scu4-aib.dts

	Andrew
