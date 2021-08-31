Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E393FC806
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhHaNSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:18:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhHaNSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 09:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O0tbD+MhxYcxlWeFJDcgfYosGr5RiD+IdZLr5hwd1OI=; b=cVzPwALFENJsChIX2055ZXy1JL
        qt4lmrRBX8oXBiWXmBjYXg7ompSsfXwCclG/zP8Jcftu96My4+xefEuCxy+bpNoIfLKBCcClC9KEE
        2cXda4H4jA/Mxx+Ec6LONitWbtADK7mBLX0J99LaWXTT0KfqIiTB7sUIXRbayR4NLQKE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mL3dD-004ilj-3l; Tue, 31 Aug 2021 15:16:51 +0200
Date:   Tue, 31 Aug 2021 15:16:51 +0200
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
Message-ID: <YS4rw7NQcpRmkO/K@lunn.ch>
References: <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I must admit, my main problem at the moment is -rc1 in two weeks
> > time. It seems like a number of board with Ethernet switches will be
> > broken, that worked before. phy-handle is not limited to switch
> > drivers, it is also used for Ethernet drivers. So it could be, a
> > number of Ethernet drivers are also going to be broken in -rc1?
> 
> Again, in those cases, based on your FEC example, fw_devlink=on
> actually improves things.

Debatable. I did some testing. As expected some boards with Ethernet
switches are now broken. Without fw_devlink=on, some boards are not
optimal, but they actually work. With it, they are broken.

I did a bisect, and they have been broken since:

ea718c699055c8566eb64432388a04974c43b2ea is the first bad commit
commit ea718c699055c8566eb64432388a04974c43b2ea
Author: Saravana Kannan <saravanak@google.com>
Date:   Tue Mar 2 13:11:32 2021 -0800

    Revert "Revert "driver core: Set fw_devlink=on by default""
    
    This reverts commit 3e4c982f1ce75faf5314477b8da296d2d00919df.
    
    Since all reported issues due to fw_devlink=on should be addressed by
    this series, revert the revert. fw_devlink=on Take II.
    
    Signed-off-by: Saravana Kannan <saravanak@google.com>
    Link: https://lore.kernel.org/r/20210302211133.2244281-4-saravanak@google.com
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

So however it is fixed, it needs to go into stable, not just -rc1.

> Again, it's not a widespread problem as I explained before.
> fw_devlink=on has been the default for 2 kernel versions now. With no
> unfixed reported issues.

Given that some Ethernet switches have been broken all that time, i
wonder what else has been broken? Normally, the kernel which is
release in December becomes the next LTS. It then gets picked up by
the distros and more wide spread tested. So it could be, you get a
flood of reports in January and February about things which are
broken. This is why i don't think you should be relying on bug
reports, you should be taking a more proactive stance and trying to
analyse the DTB blobs.

I will spend some time trying out your proposed fix. See if they are a
quick fix for stable.

      Andrew

