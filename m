Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCDE202A82
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 14:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgFUMdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 08:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgFUMdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 08:33:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E388FC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 05:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=75/APl/ljK4pEbemLI5+u9kq4Z+0D0zp9ub7K8eqL6Y=; b=WstwprQOrP0Wm8FT309GdTDwU
        zHSeuPzojC4f9XSGgm8mp73yjN8oV609upqsI+GOJGxQik82pEKDdKmqpx0CGqe3ng6yQDSdUVCdF
        6+Lev2c5Of+J39bp2rT8nLk3LF1YJS9fclMhCWteEjv0BRA/PRzFC5k0iALWRP3wmJjooKyMFF9IN
        tw34j9fOmdCSZYmhxQIR4AQgRxKQDoxZO6LIYNgYZslFyPv/i0uR8DpTktt4qzCm8Xk5rD0L2M2Xr
        HE/qN6MiOGlHra+zWo6+EmWW8EErAsnCAYy/svUwBzZ4jefn9TioHdyr/ddjcpeGFWkKWTwxwvdVe
        2m1k/j5Nw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58896)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jmz9X-0007wM-76; Sun, 21 Jun 2020 13:32:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jmz9Q-0007WL-VY; Sun, 21 Jun 2020 13:32:45 +0100
Date:   Sun, 21 Jun 2020 13:32:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200621123244.GS1551@shell.armlinux.org.uk>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621110005.23306-1-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 02:00:00PM +0300, Ioana Ciornei wrote:
> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> The advantage of this structure is that multiple ethernet or switch
> drivers used on NXP hardware (ENETC, Felix DSA switch etc) can share the
> same implementation of PCS configuration and runtime management.
> 
> The PCS is represented as an mdio_device and the callbacks exported are
> highly tied with PHYLINK and can't be used without it.
> 
> The first 3 patches add some missing pieces in PHYLINK and the locked
> mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> standalone module. The majority of the code is extracted from the Felix
> DSA driver. The last patch makes the necessary changes in the Felix
> driver in order to use the new common PCS implementation.
> 
> At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> SGMII, QSGMII (with and without in-band AN) and 2500Base-X (only w/o
> in-band AN) are supported by the Lynx PCS MDIO module since these were
> also supported by Felix and no functional change is intended at this
> time.
> 
> Changes in v2:
>  * got rid of the mdio_lynx_pcs structure and directly exported the
>  functions without the need of an indirection
>  * made the necessary adjustments for this in the Felix DSA driver
>  * solved the broken allmodconfig build test by making the module
>  tristate instead of bool
>  * fixed a memory leakage in the Felix driver (the pcs structure was
>  allocated twice)
> 
> At this moment in time, I do not feel like a major restructuring is
> needed (ie export directly a phylink_pcs_ops from the Lynx
> module). I feel like this would limit consumers (MAC drivers) to use
> all or nothing, with no option of doing any MDIO reads/writes of their
> own (not part of the common code). Also, there is already a precedent of
> a PCS module (mdio-xpcs.c, the model of which I have followed) and
> without also changing that (which I am not comfortable doing) there is
> no point of changing this one.

Please don't write off my suggestion to use phylink_pcs_ops so lightly.
I _need_ people to move over to it, so that the phylink code can be
cleaned up - or we're going to end up with phylink gradually turning
into an unmaintainable mess.  Having one way to do stuff is always
better than having multiple different backward compatible ways.

So, I /really/ want to push the phylink_pcs_ops forward, and get rid
of the ability to use the old "bolt everything into phylink_mac_ops"
approach.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
