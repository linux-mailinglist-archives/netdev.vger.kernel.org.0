Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B2C3CFC6B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbhGTN5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:57:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239631AbhGTNrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mNxdUD/o8/ICtj1ZRvzkUEYCwryGQsn6hD53RwzQcA8=; b=IGgdZsJlsJRSqUL6GE00vXElJe
        AKdEIGforYAKa51m/3JwpBKDB9PPHwKgU7wNSnWBGHbDfj/QmNCGQv9rzRB/r2AGMfOkbSQI7b0Sg
        10sQtxYknv5rK9JyOhPIerRikvngEuqFd8wbe7H3tnkH1JxA3d6Elav/orqYwdYj+4wU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5qjE-00E46z-NG; Tue, 20 Jul 2021 16:28:12 +0200
Date:   Tue, 20 Jul 2021 16:28:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YPbdfBqjgHzM+6+Z@lunn.ch>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> +{
> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> +	u16 val;
> +	int err;
> +
> +	/* Fails to downshift with v0.3.5.0 and earlier */
> +	if (priv->firmware_ver < MV_VERSION(0,3,5,0))
> +		return -EOPNOTSUPP;
> +
> +	if (ds == DOWNSHIFT_DEV_DISABLE)
> +		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
> +					  MV_PCS_DSC1_ENABLE);
> +
> +	/* FIXME: The default is disabled, so should we disable? */
> +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> +		ds = 2;

Interesting question.

It is a useful feature, so i would enable it by default.

Is it possible to read the actual speed via some vendor register?  The
phy-core might then give a warning, but it is 50/50 since the link
peer might perform the downshift.

   Andrew
