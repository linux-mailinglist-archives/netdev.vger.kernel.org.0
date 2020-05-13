Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049C61D1670
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbgEMNuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgEMNuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:50:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F88C061A0C;
        Wed, 13 May 2020 06:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rmFtybRSzQV/G7/nr7MA3/8FLcWMgEZwUIGVF0JGFLs=; b=l7LK5rCX6XHbaBWnVB43mqWFk
        muALyeuUGgdE2knZPA1TMbJcYUVjy/H+sHlGgOwPc8XUg31W0lXnWAXxRmjv+tqSeEEKuDKM0aHNf
        anZ/gcv6X1Vt9bReU4Ir40HX2cq+SV8oFGewJsHyV8CyMBM+0NLIQRzpKuGIYyH9p+itDdeXb5ZGb
        dLOfN9QRSHlgtbXN0RTnQ5UhOauIvcpwlsbTcxIDydLxS9B4ttQ3tRztUElw0g7EqZ/VcXa91H0Vn
        1uZgovObk1LJYvJCkdJN3CVBrufW/048C0JKWGoLT4+aMmfIwGozUNs0GFun6BxfOHg1XdDztDupy
        iaGURYThA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57504)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYrlt-0004nY-F2; Wed, 13 May 2020 14:50:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYrls-0007po-BD; Wed, 13 May 2020 14:50:04 +0100
Date:   Wed, 13 May 2020 14:50:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
Message-ID: <20200513135004.GK1551@shell.armlinux.org.uk>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
 <20200513133209.GC499265@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513133209.GC499265@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 03:32:09PM +0200, Andrew Lunn wrote:
> On Wed, May 13, 2020 at 02:06:48PM +0200, Oleksij Rempel wrote:
> > The cable test seems to be support by all of currently support Atherso
> > PHYs, so add support for all of them. This patch was tested only on
> > AR9331 PHY with following results:
> > - No cable is detected as short
> > - A 15m long cable connected only on one side is detected as 9m open.
> 
> That sounds wrong. What about a shorted 15m cable? Is it also 9m?  Do
> you have any other long cables you can test with? Is it always 1/2 the
> cable length?

I had similar inaccuracies with my recent faulty cable when testing
with a Marvell PHY as I mentioned.

"Using the VCT in the Marvell PHY points to it being pair 3, at a
distance of 0x190 or 0x50 depending on which way round the cable is
connected.  That's in cm.  The cable isn't 480cm long, it's 278cm
long, and the problem is up by one of the connectors."

0x190 = 400cm, 0x50 = 80cm.

Given that the issue was at one of the connectors on the cable, and
I tried VCT with it plugged into the same port, you can't even say
"well, if we define the start of the cable at 80cm, then that works
for the cable connected the other way around" - it gets us closer
but it's still about 30cm wrong.

It doesn't even work if you think maybe the figures have forgotten
to take into account the fact that the TDR pulse has to go out and
then return (so travel twice the distance, so maybe the figures are
doubled.)

So, it seems we have more than one PHY that produces only wildly
inaccurate guesses at the distance to the fault.

I'd say this technology is a "it would be nice if we could" but the
results can not be relied upon.  It may be grounded in hard physics,
but there's clearly something causing incorrect results.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
