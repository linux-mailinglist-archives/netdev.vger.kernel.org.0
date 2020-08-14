Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B217244959
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgHNMFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 08:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgHNMFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 08:05:46 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AA1C061384;
        Fri, 14 Aug 2020 05:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SxvWcTY927ewF1xPVOlv2UOLzdlmd3CvesyQFMc5CJk=; b=IXWQsHgAPp3K1FKDNCG79SQaWt
        rrEau+1wFxL/oVTi+xTXEY/ZGlpyseO1jE2ENN+/oUe24ICxPPpmXiezv+bQiYDo1uraBFOzi/89t
        pJSIWGkXPBzDdLTiujZPR7vasLylpQA1klb9fZKStFh5f3wZy0CUkdgUe98/U8P71gQmLFvfdDvoC
        jfAvmIpIhe3o3y4sCzQUoPEAWoXcolcMHXG+WJqd8dQ7uLzKr55FHo1O9gJ7GcrogIquYwlnUnNyS
        svloYBeM51uvoEiAE6IyKiEVIQNJI8LCaEx7vRc73FpWqZt5aAyZKAZlDL/bviPKT40AO677ARIkW
        +MZV8IDQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1k6YSm-0000mc-88; Fri, 14 Aug 2020 13:05:36 +0100
Date:   Fri, 14 Aug 2020 13:05:36 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200814120536.GA26106@earth.li>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
 <20200814082054.GD17795@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814082054.GD17795@plvision.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 11:20:54AM +0300, Vadym Kochan wrote:
> On Thu, Aug 13, 2020 at 09:03:22AM +0100, Jonathan McDowell wrote:
> > On Mon, Jul 27, 2020 at 03:22:37PM +0300, Vadym Kochan wrote:
> > > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > > wireless SMB deployment.
> > > 
> > > The current implementation supports only boards designed for the Marvell
> > > Switchdev solution and requires special firmware.
> > > 
> > > The core Prestera switching logic is implemented in prestera_main.c,
> > > there is an intermediate hw layer between core logic and firmware. It is
> > > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > > related logic, in future there is a plan to support more devices with
> > > different HW related configurations.
> > 
> > The Prestera range covers a lot of different silicon. 98DX326x appears
> > to be AlleyCat3; does this driver definitely support all previous
> > revisions too? I've started looking at some 98DX4122 (BobCat+) hardware
> > and while some of the register mappings seem to match up it looks like
> > the DSA tagging has some extra information at least.
> > 
> > Worth making it clear exactly what this driver is expected to support,
> > and possibly fix up the naming/device tree compatibles as a result.
> > 
> Regarding "naming/device tree compatibles", do you mean to add
> compatible matching for particular ASIC and also for common ? 
> 
> Currently 
> 
>     compatible = "marvell,prestera"
> 
> is used as default, so may be
> 
> you mean to support few matching including particular silicon too, like ?
> 
> 
>     compatible = "marvell,prestera"
>     compatible = "marvell,prestera-ac3x"
> 
> Would you please give an example ?

AFAICT "Prestera" is the general name for the Marvell
enterprise/data-centre silicon, comparable to the "LinkStreet"
designation for their lower end switching. The mv88e* drivers do not
mention LinkStreet in their compatible strings at all, choosing instead
to refer to chip IDs (I see mv88e6085, mv88e6190 + mv88e6250).

I do not have enough familiarity with the Prestera range to be able to
tell what commonality there is between the different versions (it
appears you need an NDA to get hold of the programming references), but
even just looking at your driver and the vendor code for the BobCat it
seems that AlleyCat3 uses an extended DSA header format, and requires a
firmware with message based access, in comparison to the BobCat which
uses register poking.

Based on that I'd recommend not using the bare "marvell,prestera"
compatible string, but instead something more specific.
"marvell,prestera-ac3x" seems like a suitable choice, assuming that's
how these chips are named/generally referred to.

Also I'd expand your Kconfig information to actually include "Marvell
Prestera 98DX326x" as that's the only supported chip range at present.

J.

-- 
... "'And the beast shall come forth surrounded by a roiling cloud of
    vengeance. The house of the unbelievers shall be razed and they shall
    be scorched to the earth. Their tags shall blink until the end of
    days.' from The Book of Mozilla, 12:10" -- about:mozilla
