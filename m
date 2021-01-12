Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2619C2F3D68
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407061AbhALVia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437155AbhALVXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:23:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1463DC061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q5b8jMAkKRAhOnGLVh/VJdovZLXQ8ePUSX0KZ6DgjFg=; b=D8Brr88bxFbHhFJyvwk8Ewn7Q
        P3IQUPrGNqr8jTVv5tBgRgVfXATaiNIhK5v2hDiySSdQJ+g0d2Jd/NpnCeLHMu2pAgoBDyRrWqm67
        ZHa20wHjBhPREXRLJHbOB9Y1C7DG/XAVdWv1R4gz4GKyNQ1cRbzwUMq66ISRqsgPw8KDTR10yPemn
        /JFiwm1JiEUKkx0+FjCPhgMm+iXePuIaGfHf1gvVJL5Iuj1r5PBzwMal4zbzcEEo/sNnwzaS3yplr
        fT58UQRW9ccEp1XbNnOkcybL45OaP+8ip2O4hwufC6UMTGUo/I1kJrKbtMqh/WA0bzUXTAeHQXLEE
        L+pFPMU0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47168)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzR7z-0000QY-5a; Tue, 12 Jan 2021 21:22:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzR7y-0006ck-92; Tue, 12 Jan 2021 21:22:58 +0000
Date:   Tue, 12 Jan 2021 21:22:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210112212258.GF1551@shell.armlinux.org.uk>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <X/4MgF+n+jQZ11Gd@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/4MgF+n+jQZ11Gd@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 09:54:24PM +0100, Andrew Lunn wrote:
> > +static int i2c_transfer_rollball(struct i2c_adapter *i2c,
> > +				 struct i2c_msg *msgs, int num)
> > +{
> > +	u8 saved_page;
> > +	int ret;
> > +
> > +	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
> > +
> > +	/* save original page */
> > +	ret = __i2c_rollball_get_page(i2c, msgs->addr, &saved_page);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	/* change to RollBall MDIO page */
> > +	ret = __i2c_rollball_set_page(i2c, msgs->addr, SFP_PAGE_ROLLBALL_MDIO);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	/* do the transfer */
> > +	ret = __i2c_transfer_err(i2c, msgs, num);
> > +	if (ret)
> > +		goto unlock;
> 
> If get page and set page worked, and you get an error in during the
> actual data transfer, i wonder if you should try restoring the page
> before returning with the error?

That's what we do with paged PHYs - if the access encounters an error,
we still attempt to restore the page and propagate the _original_ error.
We would only propagate the error from the page restore if it was the
only error.  See the logic and comments for phy_restore_page().

Note that phy_(save|select)_page()..phy_restore_page() deal with the
locking, which is why they always have to be paired (also means that
the user doesn't have to think too hard about error handling.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
