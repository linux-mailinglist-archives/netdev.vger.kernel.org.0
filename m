Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB6E2F3D54
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407025AbhALVhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437063AbhALUzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:55:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzQgK-000EIw-4Q; Tue, 12 Jan 2021 21:54:24 +0100
Date:   Tue, 12 Jan 2021 21:54:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <X/4MgF+n+jQZ11Gd@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111050044.22002-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int i2c_transfer_rollball(struct i2c_adapter *i2c,
> +				 struct i2c_msg *msgs, int num)
> +{
> +	u8 saved_page;
> +	int ret;
> +
> +	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
> +
> +	/* save original page */
> +	ret = __i2c_rollball_get_page(i2c, msgs->addr, &saved_page);
> +	if (ret)
> +		goto unlock;
> +
> +	/* change to RollBall MDIO page */
> +	ret = __i2c_rollball_set_page(i2c, msgs->addr, SFP_PAGE_ROLLBALL_MDIO);
> +	if (ret)
> +		goto unlock;
> +
> +	/* do the transfer */
> +	ret = __i2c_transfer_err(i2c, msgs, num);
> +	if (ret)
> +		goto unlock;

If get page and set page worked, and you get an error in during the
actual data transfer, i wonder if you should try restoring the page
before returning with the error?

> +
> +	/* restore original page */
> +	ret = __i2c_rollball_set_page(i2c, msgs->addr, saved_page);
> +
> +unlock:
> +	i2c_unlock_bus(i2c, I2C_LOCK_SEGMENT);
> +
> +	return ret;
> +}
