Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616343F9220
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbhH0Bup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:50:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242698AbhH0Buo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 21:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CDvvNopGlofSlCZCEWgxk5YPTIzsFd1LZhIDbzDLDMM=; b=sqtlZ2Vxrgz5maABYKOyuKTF5v
        Y4TpnXAorq7GJ9B40FMRRHwSMKajU3+miT2cn+T/3lM8MKSoCOsf1G321VE1qmA0hp2R9n1YOW8kI
        QMsD5ASDguKyLK22mukEsFs1tKAffyfzKKOV7z1KompWbi24/xUA/SXucLQohxy/RpDY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJR0F-0042Wm-6n; Fri, 27 Aug 2021 03:49:55 +0200
Date:   Fri, 27 Aug 2021 03:49:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: fix broken PHY interrupts for
 anyone after us in the driver probe list
Message-ID: <YShEw9v55NZdUYQE@lunn.ch>
References: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the detailed description.

> (also, a bit frightening that drivers are permitted to bypass the MDIO
> bus matching in such a trivial way and perform PHY reads and writes from
> the .match_phy_device method, on devices that do not even belong to
> them.

Yes, but i don't think we can block it. We might want to extend the
comment a bit:

        /**
         * @match_phy_device: Returns true if this is a suitable
         * driver for the given phydev.  If NULL, matching is based on
         * phy_id and phy_id_mask.
         */
        int (*match_phy_device)(struct phy_device *phydev);

I guess we got into this situation because it was assumed that phy_id
and phy_id_mask matched and now we can refine it down further between
two devices which have identical IDs. Which is wrong.

    Andrew
