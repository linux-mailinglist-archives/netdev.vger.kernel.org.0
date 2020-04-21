Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E0D1B2A58
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgDUOnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbgDUOnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:43:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB49DC061A41;
        Tue, 21 Apr 2020 07:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dY79REsLwvs8M2Rkjsj0Kv3oPbcFcJ+41V7FNNmLGX0=; b=NdUIgbRV16Ex4LIOSDoUFWIvZ
        Qrit5lY9w/b9nPH0BzKucYkau8v8BZO66kQ6heEp6+gFPxFjjw5Ulf6HNDZrA7Fnd+mOPRjWlmP/h
        ybj9+N7kEQJpBz2G6pjWmv6qIuddsPJPSKY1B3dDpsShbivNRzT0r7PRQ3STQe/fi/KUVTh2l7mSp
        DIXs9SaMEmj1kP5S5tkSGSJpA0RA3cb2/j5C0B81CkMAImgjc+x2UI2GAvHUDKKPEPXLEWw0Cgivh
        n+snrn7u9TbIBv4SMnwzDd2fiUcENfABz0t8o2f6H1HWZEIh67xbBL/5nUGXeEg3QMahrPG1DOF4D
        Jo7yd6LNA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41618)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jQu79-00029h-LK; Tue, 21 Apr 2020 15:43:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jQu74-00076r-NY; Tue, 21 Apr 2020 15:43:02 +0100
Date:   Tue, 21 Apr 2020 15:43:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
Message-ID: <20200421144302.GD25745@shell.armlinux.org.uk>
References: <20200420232624.9127-1-michael@walle.cc>
 <20200421143455.GB933345@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421143455.GB933345@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 04:34:55PM +0200, Andrew Lunn wrote:
> > +static inline bool phy_package_init_once(struct phy_device *phydev)
> > +{
> > +	struct phy_package_shared *shared = phydev->shared;
> > +
> > +	if (!shared)
> > +		return false;
> > +
> > +	return !test_and_set_bit(PHY_SHARED_F_INIT_DONE, &shared->flags);
> > +}
> 
> I need to look at how you actually use this, but i wonder if this is
> sufficient. Can two PHYs probe at the same time? Could we have one PHY
> be busy setting up the global init, and the other thinks the global
> setup is complete? Do we want a comment like: 'Returns true when the
> global package initialization is either under way or complete'?

IIRC, probe locking in the driver model is by per-driver locks, so
any particular driver won't probe more than one device at a time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
