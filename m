Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F353FCF6C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 00:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbhHaWHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 18:07:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhHaWHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 18:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nvErR40qfu1kFHYvqRKQ6/X+/HW+U8tJ8ybWTvE/KVQ=; b=pwBjBgmSmIucoQsPZR0eQWjlXc
        n1WHhMUfOJJghCBhuolPMcyhyzDZaBjgufGu8tvEU+7H92a3OhbuTs38SwifTtFq7pZs8I7NW7kGg
        dnG+v+mHgmGIoL+eHjwCoqDKFrh7AO5mXKS/lx7dMHRpZVtZooAy1+m/R6iuw0bf2AQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLBtE-004lbS-9m; Wed, 01 Sep 2021 00:05:56 +0200
Date:   Wed, 1 Sep 2021 00:05:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YS6nxLp5TYCK+mJP@lunn.ch>
References: <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 12:26:30PM -0700, Saravana Kannan wrote:
> On Tue, Aug 31, 2021 at 6:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > > I must admit, my main problem at the moment is -rc1 in two weeks
> > > > time. It seems like a number of board with Ethernet switches will be
> > > > broken, that worked before. phy-handle is not limited to switch
> > > > drivers, it is also used for Ethernet drivers. So it could be, a
> > > > number of Ethernet drivers are also going to be broken in -rc1?
> > >
> > > Again, in those cases, based on your FEC example, fw_devlink=on
> > > actually improves things.
> >
> > Debatable. I did some testing. As expected some boards with Ethernet
> > switches are now broken.
> 
> To clarify myself, I'm saying the patch to parse "ethernet" [8] will
> make things better with fw_devlink=on for FEC. Not sure if you tested
> that patch or not.

Yes and no. I was tested with the FEC, but because of fw_devlink=on,
the switches don't probe correctly. So it is not possible to see if it
helped or not, since its plain broken.

> Not sure what was the tip of the tree with which you bisected.

I manually tested linux-next, v5.14, v5.13 and v5.12 and then
bisected:

$ git bisect log
git bisect start
# good: [9f4ad9e425a1d3b6a34617b8ea226d56a119a717] Linux 5.12
git bisect good 9f4ad9e425a1d3b6a34617b8ea226d56a119a717
# bad: [62fb9874f5da54fdb243003b386128037319b219] Linux 5.13

So well away from linux-next which contains the phy-handle parser.

I will try to give the two patches a try today or tomorrow.

> Thanks for testing it out. And worst case, we'll revert phy-handle
> support.

Which is not enough to fix these Ethernet switches.

      Andrew
