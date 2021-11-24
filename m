Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830B45B8D1
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbhKXLHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240458AbhKXLHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:07:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2813DC061574;
        Wed, 24 Nov 2021 03:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pyj1fWtFgdY2SPx+2ToK/2MB/f+/m0IgCdEcwNFLm0U=; b=z3t1ZwUeqNM7SClWfoktPlLOPS
        fgkGGgRhvhRw7dN77leLW7zhcbQ0sB2+DsSypT1x1Gm2sC2EUjXjJUumw4DkUEI4fkYd2wi7N4JgN
        4PUyXk+KmC+rIsT2prudxd4HkHyoGl2NzJsFHlc8GhHhJGwBfngW77n/iq2uaZfSpF1QpcM5C37cQ
        g40LRt1fzk33MmkS7AdEpYXfiEZzizmalLd+zu4EjiC5z0LqIKwHRJGHdr3pQhVYScsmrfS7/3fQ9
        7v26FsbqnlTc7Uh4GJRKVAARop0U+BDLZODB4lXDU2QTibw3Brkorvaw9AvW0NZXjGLI5hV/RlaJH
        4ySFI4AA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55836)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpq4s-0000Uk-Ui; Wed, 24 Nov 2021 11:04:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpq4r-00018T-CF; Wed, 24 Nov 2021 11:04:37 +0000
Date:   Wed, 24 Nov 2021 11:04:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-5-kabel@kernel.org>
 <20211123212441.qwgqaad74zciw6wj@skbuf>
 <20211123232713.460e3241@thinkpad>
 <20211123225418.skpnnhnrsdqrwv5f@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123225418.skpnnhnrsdqrwv5f@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 12:54:18AM +0200, Vladimir Oltean wrote:
> This implies that when you bring up a board and write the device tree
> for it, you know that PHY mode X works without ever testing it. What if
> it doesn't work when you finally add support for it? Now you already
> have one DT blob in circulation. That's why I'm saying that maybe it
> could be better if we could think in terms that are a bit more physical
> and easy to characterize.

However, it doesn't solve the problem. Let's take an example.

The 3310 supports a mode where it runs in XAUI/5GBASE-R/2500BASE-X/SGMII
depending on the negotiated media parameters.

XAUI is four lanes of 3.125Gbaud.
5GBASE-R is one lane of 5.15625Gbaud.

Let's say you're using this, and test the 10G speed using XAUI,
intending the other speeds to work. So you put in DT that you support
four lanes and up to 5.15625Gbaud.

Later, you discover that 5GBASE-R doesn't work because there's an
electrical issue with the board. You now have DT in circulation
which doesn't match the capabilities of the hardware.

How is this any different from the situation you describe above?
To me, it seems to be exactly the same problem.

So, I don't think one can get away from these kinds of issues - where
you create a board, do insufficient testing, publish a DT description,
and then through further testing discover you have to restrict the
hardware capabilities in DT. In fact, this is sadly an entirely normal
process - problems always get found after boards have been sent out
and initial DT has been created.

A good example is the 6th switch port on the original Clearfog boards.
This was connected to an external PHY at address 0 on the MDIO bus
behind the switch. However, the 88E6176 switch already has an internal
PHY at address 0, so the external PHY can't be accessed. Consequently,
port 6 is unreliable. That only came to light some time later, and
resulted in the DT needing to be modified.

There are always problems that need DT to be fixed - I don't think it's
possible to get away from that by changing what or how something is
described. In fact, I think trying to make that argument actually shows
a misunderstanding of the process of hardware bringup.

Just like software, hardware is buggy and takes time to be debugged,
and that process continues after the first version of DT for a board
has been produced, and there will always be changes required to DT.

I'm not saying that describing the maximum frequency and lanes doesn't
have merit, I'm merely taking issue with the basis of your argument.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
