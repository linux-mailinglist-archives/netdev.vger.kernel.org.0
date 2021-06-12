Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C4A3A501D
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFLSZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:25:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLSZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 14:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wPWBaV8IYJCZ83hJS663zBYMFbq7zkgEdloZ6L+4ZGc=; b=LTbA36Hqp87F1Tio/7Seq0kgBO
        DIHVmeBJlhJeFl5XASy7rzmBmaiw89KGbwNzQlZUMGGTgCMQdXe6z3KLr7QIPwO0gQHmk/sSd9qWk
        udz1yFCcg2FWPsBRQj2SSRbsR5QZWUZl0Md24CtiUaSRSz3833hTtLq2SN/bidVuzz4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ls8IT-0091Qp-F0; Sat, 12 Jun 2021 20:23:53 +0200
Date:   Sat, 12 Jun 2021 20:23:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 9/9] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <YMT7uSNXBA8/2r8C@lunn.ch>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-10-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-10-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ksz886x_cable_test_get_status(struct phy_device *phydev,
> +					 bool *finished)
> +{
> +	unsigned long pair_mask = 0x3;
> +	int retries = 20;
> +	int pair, ret;
> +
> +	*finished = false;
> +
> +	/* Try harder if link partner is active */
> +	while (pair_mask && retries--) {
> +		for_each_set_bit(pair, &pair_mask, 4) {
> +			ret = ksz886x_cable_test_one_pair(phydev, pair);
> +			if (ret == -EAGAIN)
> +				continue;
> +			if (ret < 0)
> +				return ret;
> +			clear_bit(pair, &pair_mask);
> +		}
> +		/* If link partner is in autonegotiation mode it will send 2ms
> +		 * of FLPs with at least 6ms of silence.
> +		 * Add 2ms sleep to have better chances to hit this silence.
> +		 */
> +		if (pair_mask)
> +			msleep(2);
> +	}
> +
> +	*finished = true;
> +
> +	return 0;

If ksz886x_cable_test_one_pair() returns -EAGAIN 20x and it gives up,
you end up returning 0. Maybe it would be better to return ret?

    Andrew
