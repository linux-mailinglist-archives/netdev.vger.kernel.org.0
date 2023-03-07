Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C8D6AE9E7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjCGR2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCGR22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:28:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4E592BF8;
        Tue,  7 Mar 2023 09:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QHT/sG0tYulDZEME/nn3zcV5E2UMMP9YFJ4HsO7eksE=; b=R9mJRGhBfgne9uXqvIkX2WD+GD
        KO7oz4+1AytsOFkoyGXhgypFjm2TisPXHT6A1nCOHW3N8/pzqqjU8KPSbz0sWw6q76vmpC7WHxy7q
        fwW6/sJqxCDjbXXMac1iddOx1HugH8ftYMLYHVVhQngQjQgSxq7uNF1rIAmp1aOMZ2Tk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZb2C-006gjT-9p; Tue, 07 Mar 2023 18:23:32 +0100
Date:   Tue, 7 Mar 2023 18:23:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <ae66193e-db1e-4883-bda1-2be5312630df@lunn.ch>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
 <f947e5e2-770e-4b12-67ae-8abf5866e250@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f947e5e2-770e-4b12-67ae-8abf5866e250@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, and I should probably have commented on this in the commit message.
> IMO the things you listed are... iffy but unlikely to cause a
> malfunction.

You consider a missed interrupt not a malfunction?

> >> +
> >> +	for (insn = xfer->prog, pc = 0;
> >> +	     pc < xfer->prog_len;
> >> +	     insn = &xfer->prog[++pc]) {
> >> +		if (time_after(jiffies, timeout)) {
> >> +			ret = -ETIMEDOUT;
> >> +			break;
> >> +		}
> >> +
> >> +		switch ((enum mdio_nl_op)insn->op) {
> >> +		case MDIO_NL_OP_READ:
> >> +			phy_id = __arg_ri(insn->arg0, regs);
> >> +			prtad = mdio_phy_id_prtad(phy_id);
> >> +			devad = mdio_phy_id_devad(phy_id);
> >> +			reg = __arg_ri(insn->arg1, regs);
> >> +
> >> +			if (mdio_phy_id_is_c45(phy_id))
> >> +				ret = __mdiobus_c45_read(xfer->mdio, prtad,
> >> +							 devad, reg);
> >> +			else
> >> +				ret = __mdiobus_read(xfer->mdio, phy_id, reg);
> > 
> > The application should say if it want to do C22 or C45.
> 
> The phy_id comes from the application. So it sets MDIO_PHY_ID_C45 if it wants
> to use C45.

Ah, i misunderstood what mdio_phy_id_is_c45() does.

Anyway, i don't like MDIO_PHY_ID_C45, it has been pretty much removed
everywhere with the refactoring of MDIO drivers to export read and
read_c45 etc. PHY drivers also don't use it, they use c22 or c45
specific methods. So i would prefer an additional attribute. That also
opens up the possibility of adding C45 over C22.

> As Russell noted, this is dangerous in the general case.

And Russell also agreed this whole module is dangerous in general.
Once you accept it is dangerous, its a debug tool only, why not allow
playing with a bit more fire? You could at least poke around the MDIO
bus structures and see if a PHY has been found, and it not, block C45
over C22.

> >> +			if (mdio_phy_id_is_c45(phy_id))
> >> +				ret = __mdiobus_c45_write(xfer->mdio, prtad,
> >> +							  devad, reg, val
> >> +			else
> >> +				ret = __mdiobus_write(xfer->mdio, dev, reg,
> >> +						      val);
> >> +#else
> >> +			ret = -EPERM;
> > 
> > EPERM is odd, EOPNOTSUPP would be better. EPERM suggests you can run
> > it as root and it should work.
> 
> Well, EPERM is what you get when trying to write a 444 file, which is
> effectively what we're enforcing here.

Does it change to 644 when write is enabled? But netlink does not even
use file access permissions. I would probably trap this earlier, where
you have a extack instance you can return a meaningful error message
string.

     Andrew
