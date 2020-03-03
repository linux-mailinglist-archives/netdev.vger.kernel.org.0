Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77347177CB9
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgCCRDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:03:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730480AbgCCRDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KM9OJl55BEVnjPLYVRcGFR7GsAzMkUrF0mnoRkrL4b4=; b=xijrcFTt9+x1Vd1gSvCo+/DT9m
        3qZze8+BMmJ2P9afVKTHTTSCEp0MBh/ef4pA4fpqfyNDFxb4CbRSpFQEWlD77zwDivA/rGJ7JRoIu
        dxL5+/IZ2YN04IQkmnzLI7E0dYfFcg2fcwofWfDt7Q5QLSSdUcy7KmG3WrDXTu1VvFzY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9Awu-0007qM-UI; Tue, 03 Mar 2020 18:03:16 +0100
Date:   Tue, 3 Mar 2020 18:03:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200303170316.GJ24912@lunn.ch>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99s1-00011Q-RB@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j99s1-00011Q-RB@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv3310_reset(struct phy_device *phydev, u32 unit)
> +{
> +	int retries, val, err;
> +
> +	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
> +			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
> +	if (err < 0)
> +		return err;
> +
> +	retries = 20;
> +	do {
> +		msleep(5);
> +		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
> +		if (val < 0)
> +			return val;
> +	} while (val & MDIO_CTRL1_RESET && --retries);
> +
> +	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;

Hi Russell

I've often seen people get this sort of polling loop wrong. So i
generally point people towards include/linux/iopoll.h.

I wonder if it would be helpful to add phy_read_mmd_poll_timeout()
and maybe phy_read_poll_timeout() to phy-core.c?

Just an idea, not a blocker for the patch.

     Andrew
