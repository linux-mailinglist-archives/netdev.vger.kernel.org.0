Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44A23E381C
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 05:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhHHD21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 23:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHD21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 23:28:27 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FE0C061760;
        Sat,  7 Aug 2021 20:28:08 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1mCZTk-0000zx-Ny; Sun, 08 Aug 2021 05:28:00 +0200
Date:   Sun, 8 Aug 2021 04:27:49 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ARM: kirkwood: add missing <linux/if_ether.h> for
 ETH_ALEN
Message-ID: <YQ9PNeka8VhZqxGR@makrotopia.org>
References: <YQxk4jrbm31NM1US@makrotopia.org>
 <cde9de20efd3a75561080751766edbec@walle.cc>
 <YQ6WCK0Sytb0nxj9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQ6WCK0Sytb0nxj9@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Aug 07, 2021 at 04:17:44PM +0200, Andrew Lunn wrote:
> > What kernel is this? I've just tested with this exact commit as
> > base and it compiles just fine.
> > 
> > I'm not saying including the file is wrong, but it seems it isn't
> > needed in the upstream kernel and I don't know if it qualifies for
> > the stable queue therefore.
> 
> I would like to see a reproducer for mainline. Do you have a kernel
> config which generates the problem.

I encountered the problem when building the 'kirkwood' target in
OpenWrt. I have now tried building vanilla, and the problem indeed
doesn't exist. After tracing the header includes with the precompiler
for some time I concluded that <linux/of_net.h> included in kirkwood.c
includes <linux/phy.h> which includes <linux/ethtool.h> which includes
<uapi/linux/ethtool.h> which includes <uapi/linux/if_ether.h> which
includes <linux/if_ether.h> which defined ETH_ALEN.

When building OpenWrt kernel which includes a backport of
"of: net: pass the dst buffer to of_get_mac_address()", this is not the
same as <linux/of_net.h> doesn't include <linux/phy.h> yet. This is
because we miss commit 0c65b2b90d13c1 ("net: of_get_phy_mode: Change
API to solve int/unit warnings") which has been in mainline for a long
time.

> The change itself does seems reasonable, so if we can reproduce it, i
> would be happy to merge it for stable.

Sorry for the noise caused, I'm not sure what the policy is in this
case, but certainly this is *not* a regression which should make it to
stable asap. The long and confusing chain of includes which lead to the
ETH_ALEN macro being defined in arch/arm/mach-mvebu/kirkwood.c is
certainly not ideal, and in case you still consider this patch worth
merging, I will post v2 with re-written commit description.
