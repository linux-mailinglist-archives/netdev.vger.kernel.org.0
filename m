Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ADE2A5CC7
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 03:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgKDCm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 21:42:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730153AbgKDCm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 21:42:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ka8kV-0058ru-C2; Wed, 04 Nov 2020 03:42:11 +0100
Date:   Wed, 4 Nov 2020 03:42:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201104024211.GS933237@lunn.ch>
References: <20201103151536.26472-1-l.stelmach@samsung.com>
 <CGME20201103151540eucas1p1d45bc7fdc9ddb07607b5268d50f567ca@eucas1p1.samsung.com>
 <20201103151536.26472-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103151536.26472-4-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config SPI_AX88796C_COMPRESSION
> +	bool "SPI transfer compression"
> +	default n
> +	depends on SPI_AX88796C
> +	help
> +	  Say Y here to enable SPI transfer compression. It saves up
> +	  to 24 dummy cycles during each transfer which may noticably
> +	  speed up short transfers. This sets the default value that is
> +	  inherited by network interfecase during probe. It can be

interface


> +	  changed in run time via spi-compression ethtool tunable.

changed _at_ run time...

> +static int
> +ax88796c_set_tunable(struct net_device *ndev, const struct ethtool_tunable *tuna,
> +		     const void *data)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +
> +	switch (tuna->id) {
> +	case ETHTOOL_SPI_COMPRESSION:
> +		if (netif_running(ndev))
> +			return -EBUSY;
> +		ax_local->capabilities &= ~AX_CAP_COMP;
> +		ax_local->capabilities |= *(u32 *)data ? AX_CAP_COMP : 0;

You should probably validate here that data is 0 or 1. That is what
ax88796c_get_tunable() will return.

It seems like this controls two hardware bits:

SPICR_RCEN | SPICR_QCEN

Maybe at some point it would make sense to allow these bits to be set
individually? If you never validate the tunable, you cannot make use
of other values to control the bits individually.

   Andrew
