Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056122F4907
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbhAMKwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbhAMKwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:52:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF7BD23122;
        Wed, 13 Jan 2021 10:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610535112;
        bh=rv/tsdtKvW3MWZIIVgy2/wfNFLHWLiNX8yhamCU6pnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dxrmy7pkSUkoR5i++ohP69LRCiZ5FfFLpBqtoD5QVkDwPk/pV1HIqLZmt31zxeh9L
         WtgxheI1UxPYqpcQP7JFa/ENFwxnbHPOhhSNxGUtxLy5nmHeaoEBQ7ThSPXB+31hO/
         z2mDLz3cam47EjppKV4+3zYdKrWsAn0hS/8E6DS5JAZml6PO0dqA9MqW2hHlb+aVv3
         dA7QpBD7RXNPRz9AQufX1/dckyv1ZIBjVHRNYN1woUHB9TBYlGpAGuwv1mAvGySH4W
         BkUoAJ0G5/Zxg1ZQ5JOdUHe3BOwgYgxUSd9st8RSAKqKD76wxmKKcmOxqRqmnsLsWQ
         meysBHgEeFTGQ==
Received: by pali.im (Postfix)
        id DBD9D76D; Wed, 13 Jan 2021 11:51:47 +0100 (CET)
Date:   Wed, 13 Jan 2021 11:51:47 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210113105147.rkz3abddkum7kxdf@pali>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <X/4MgF+n+jQZ11Gd@lunn.ch>
 <20210112220114.0f990cbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112220114.0f990cbe@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 12 January 2021 22:01:14 Marek Behún wrote:
> On Tue, 12 Jan 2021 21:54:24 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > +static int i2c_transfer_rollball(struct i2c_adapter *i2c,
> > > +				 struct i2c_msg *msgs, int num)
> > > +{
> > > +	u8 saved_page;
> > > +	int ret;
> > > +
> > > +	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
> > > +
> > > +	/* save original page */
> > > +	ret = __i2c_rollball_get_page(i2c, msgs->addr, &saved_page);
> > > +	if (ret)
> > > +		goto unlock;
> > > +
> > > +	/* change to RollBall MDIO page */
> > > +	ret = __i2c_rollball_set_page(i2c, msgs->addr, SFP_PAGE_ROLLBALL_MDIO);
> > > +	if (ret)
> > > +		goto unlock;
> > > +
> > > +	/* do the transfer */
> > > +	ret = __i2c_transfer_err(i2c, msgs, num);
> > > +	if (ret)
> > > +		goto unlock;  
> > 
> > If get page and set page worked, and you get an error in during the
> > actual data transfer, i wonder if you should try restoring the page
> > before returning with the error?
> 
> I don't know. Can i2c trasfer fail and the next one succeed?

I guess it can depend also on i2c driver. I'm for trying to restore
previous i2c page on failure. In the worst case also restoring fails...
