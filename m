Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521312F3D5C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407032AbhALViC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437098AbhALVB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 16:01:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEDFE2311F;
        Tue, 12 Jan 2021 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610485279;
        bh=6OX2YZZ12NC0P+lQBpo1Yc5AucUm5+6j1P6oIiaY/YA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RGXA2hEJWxkQAphm/j8qRKHEb/3AwqADZeLqmsKLQzvehHXJPpULcmE1fi1gwvbPW
         DV2T5ntfq3h4NKGV2q/xfGBqGwOSLKrNaa0hQ8GGEm6UeQiCHfMx0eN8R4dtL0Ot81
         dOPEROwtmFwxmYZhTyVlPuum1x6BbavZapSz3/FrU8iK7Plvk2xIS8+BI+p59D83E3
         dqT4aHDUH71tIEPPLHudP8yCxnAlYvMhUAfhsM/IMhrU5QiB9GQdpIGygsKHuXI/sM
         uQmd5Wb+r8zvCyJ8xqsITWSXwTyX2nV8Rr2ZOzseckUomxQtCeuRcCPhk2bPAFM9Ft
         Mx+1utoKmDL2w==
Date:   Tue, 12 Jan 2021 22:01:14 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210112220114.0f990cbe@kernel.org>
In-Reply-To: <X/4MgF+n+jQZ11Gd@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
        <20210111050044.22002-2-kabel@kernel.org>
        <X/4MgF+n+jQZ11Gd@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 21:54:24 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

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

I don't know. Can i2c trasfer fail and the next one succeed?
