Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D5D3762FC
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhEGJpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 05:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhEGJpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 05:45:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324D1C061574;
        Fri,  7 May 2021 02:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YrH9BkDUf5uJUgqQ0KIi4R1B1HVNthp2JZogOagcDqU=; b=TJcFWHc0DcJH7ZXGQ1IXEDZS1
        gQgomF5rhfpOdQJArJRwxu7Vz/bDRPXAaLNC7S397y4dSR0IlSbNshzuWTL0Ap2PMW4ER09jRH1Nk
        5dhQqftcHZlSVIUwWuYftbUrE8g8f34PqB7RLd6p4b/y+qRtIixZDvbKQndRpT00h5ArqOzqBkV5W
        22u4JEmGKD8XZt7oq882xAYCZMY10zodYYndiu29XyTOvXBZlWIuk4VXhSRnN35HqkI4TxAI4Lvhw
        BGokVuB7ko7ljsKPQVCLUop8+ba3Jjgz7x2zZ2yee/e46znD0JUQYRUAA4kL+g15OEijo7trl2FcE
        H8awfqe3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43750)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lex20-0003LA-IZ; Fri, 07 May 2021 10:44:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lex1z-0005do-Ad; Fri, 07 May 2021 10:44:23 +0100
Date:   Fri, 7 May 2021 10:44:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <20210507094423.GC1336@shell.armlinux.org.uk>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-19-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:13AM +0200, Ansuel Smith wrote:
> +static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +
> +	pr_info("revision from phy %d", priv->switch_revision);

Should this be a "pr_info" ?

> +
> +	/* Communicate to the phy internal driver the switch revision.
> +	 * Based on the switch revision different values needs to be
> +	 * set to the dbg and mmd reg on the phy.
> +	 * The first 2 bit are used to communicate the switch revision
> +	 * to the phy driver.
> +	 */
> +	if (port > 0 && port < 6)
> +		return priv->switch_revision;

We had some discussion back in February about the PHY flags argument
("Rework of phydev->dev_flags") as there is a need to generically
identify whether a PHY is on a SFP module or not. This discussion
hasn't progressed to any changes (yet) but some of the points remain
valid: if we do go down the route of needing to have generic PHY flags
in dev_flags, then we need vendor specific stuff to avoid those bits.
So, rather than introduce a new case of passing some undefined data
through the flags argument, can we come up with some sort of proposal
for this.

It may also be a good idea if we document it. Maybe something like
"low 16 bits are free for driver use, upper 16 bits are reserved
for generic use"?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
