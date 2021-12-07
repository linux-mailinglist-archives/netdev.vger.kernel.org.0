Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1D946BD75
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbhLGOYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbhLGOYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:24:04 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F25C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:20:32 -0800 (PST)
Received: from [IPv6:2a00:23c6:c31a:b300:ef00:525b:f7cd:f7f8] (unknown [IPv6:2a00:23c6:c31a:b300:ef00:525b:f7cd:f7f8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 3B1381F452F0;
        Tue,  7 Dec 2021 14:20:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638886831; bh=nsaog4lDDDRPRLZs58G769nKLxRoZvUilAtsk2OKv1U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ceou6XQ9Rll3nNLYkZvXwy1vK3xfjng0UTtNlTkn5z3eO1R0KND1bPxLzlO7ifqIk
         QnO8be8vsjGi+28pQjskGE0avxSqKiwmMeiHMe5+dwW6w8ZlaRlN70l0cbI/R6dzJh
         /KC2k19ME5fK9UxoYoMm5DkKtiaWnWA9GqbjjRYWmOthsHQCQZLGfD8djjlWyCen0N
         bBUEc7hKnLnU7zEX4/wPmpL8uoZSaaHobMLuH6h1UO8vBy/NBsJyYfZjwQ+x72zJdv
         nPknuFrhPcPX82RRHVC/1AihOWpPhg/S3KfXNNOvokuRWNMFojS7D/oQR/Ge30hIit
         Jpcew5nhsqRyA==
Message-ID: <aa773849b84297679f4eb4b3743518856ca5b71a.camel@collabora.com>
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
From:   Martyn Welch <martyn.welch@collabora.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Date:   Tue, 07 Dec 2021 14:20:28 +0000
In-Reply-To: <Ya9abXJELHCaBE0k@shell.armlinux.org.uk>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
         <aa5e48e4b03eb9fd8eb6dacb439ef8e600245774.camel@collabora.com>
         <Ya9abXJELHCaBE0k@shell.armlinux.org.uk>
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-07 at 12:58 +0000, Russell King (Oracle) wrote:
> On Tue, Dec 07, 2021 at 12:47:35PM +0000, Martyn Welch wrote:
> > Sorry Russell, but unfortunately this patch doesn't seem to be
> > resolving the issue for me.
> > 
> > I've dumped in a bit of debug around this change to see if I could
> > determine what was going on here, it seems that in my case the
> > function
> > is being exited before this at:
> > 
> > /* FIXME: is this the correct test? If we're in fixed mode on an
> >  * internal port, why should we process this any different from
> >  * PHY mode? On the other hand, the port may be automedia between
> >  * an internal PHY and the serdes...
> >  */
> > if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
> >         return;
> 
> Oh, I was going to remove that, but clearly forgot, sorry. Please can
> you try again with that removed? Meanwhile, I'll update the patch at
> my end.
> 

Yes! That makes it work for me.

To be clear, the additional change I made was:


diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
b/drivers/net/dsa/mv88e6xxx/chip.c
index b033e653d3f4..14f87f6ac479 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -702,14 +702,6 @@ static void mv88e6xxx_mac_config(struct dsa_switch
*ds, int port,
 
        p = &chip->ports[port];
 
-       /* FIXME: is this the correct test? If we're in fixed mode on
an
-        * internal port, why should we process this any different from
-        * PHY mode? On the other hand, the port may be automedia
between
-        * an internal PHY and the serdes...
-        */
-       if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds,
port))
-               return;
-
        mv88e6xxx_reg_lock(chip);
 
        if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port))
{


Assuming that's also what you've done:

Tested-by: Martyn Welch <martyn.welch@collabora.com>

Thanks for your help!

Martyn
