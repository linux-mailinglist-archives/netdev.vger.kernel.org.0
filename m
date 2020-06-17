Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7C1FD23D
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgFQQdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgFQQdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:33:01 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7885206E2;
        Wed, 17 Jun 2020 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411581;
        bh=qJL7rVXvI3peFbGg/V3qdpawcNNdsGR1k6j1oztYM1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EpLAJTcN16TDjipZbpmGB3rUirGOy9dVdGa/nlKxBM0lv0sn+H1Ip6IeJrQ2kTAcA
         exig8INKhx9CNutzsY65DOXX+vmLkCr0aJRLL+AJVBPjqRY81e/vPzmbXfNSGN75V7
         houPxNH2qaR5Aou4vJJLmMvVOgQ05ZmOm5mvDrJs=
Date:   Wed, 17 Jun 2020 09:32:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net
Subject: Re: [PATCH net-next v2 5/8] net: phy: mscc: 1588 block
 initialization
Message-ID: <20200617093258.52614fd8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617133127.628454-6-antoine.tenart@bootlin.com>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com>
        <20200617133127.628454-6-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 15:31:24 +0200 Antoine Tenart wrote:
> +/* Two PHYs share the same 1588 processor and it's to be entirely configured
> + * through the base PHY of this processor.
> + */
> +/* phydev->bus->mdio_lock should be locked when using this function */
> +static inline int phy_ts_base_write(struct phy_device *phydev, u32 regnum,
> +				    u16 val)

Please don't use static inline outside of headers in networking code.
The compiler will know best what to inline and when.

> +{
> +	struct vsc8531_private *priv = phydev->priv;
> +
> +	WARN_ON_ONCE(!mutex_is_locked(&phydev->mdio.bus->mdio_lock));
> +	return __mdiobus_write(phydev->mdio.bus, priv->ts_base_addr, regnum,
> +			       val);
> +}
> +
> +/* phydev->bus->mdio_lock should be locked when using this function */
> +static inline int phy_ts_base_read(struct phy_device *phydev, u32 regnum)
> +{
> +	struct vsc8531_private *priv = phydev->priv;
> +
> +	WARN_ON_ONCE(!mutex_is_locked(&phydev->mdio.bus->mdio_lock));
> +	return __mdiobus_read(phydev->mdio.bus, priv->ts_base_addr, regnum);
> +}
