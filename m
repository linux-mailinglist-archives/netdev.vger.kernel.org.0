Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BE218E75C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 08:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgCVHkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 03:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgCVHkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 03:40:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93C620753;
        Sun, 22 Mar 2020 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584862809;
        bh=6OTETLA2Lkag+u/aimImFI5ux+gfx2ImiFuEDDe3dk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e19y4T+ODpyqOzHH4FP8h8Ti2ztK3Ecj9Rk9WmTUNiSRMOc8sG7Ybn5g5Yibp2YxL
         tRUwMvufRiX0wSvfzGLI6GSJWvIupCFwJTREHuq7inZBAaTNk3h+HnsqM5fpZFZsXg
         1L93YSRZv4Iq897VWMOisEDBIfXwpnbg3KWlEo4Q=
Date:   Sun, 22 Mar 2020 08:40:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: phy: add marvell usb to mdio controller
Message-ID: <20200322074006.GB64528@kroah.com>
References: <20200321202443.15352-1-tobias@waldekranz.com>
 <20200321202443.15352-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321202443.15352-2-tobias@waldekranz.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 09:24:43PM +0100, Tobias Waldekranz wrote:
> An MDIO controller present on development boards for Marvell switches
> from the Link Street (88E6xxx) family.
> 
> Using this module, you can use the following setup as a development
> platform for switchdev and DSA related work.
> 
>    .-------.      .-----------------.
>    |      USB----USB                |
>    |  SoC  |      |  88E6390X-DB  ETH1-10
>    |      ETH----ETH0               |
>    '-------'      '-----------------'
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> Hi linux-usb,
> 
> This is my first ever USB driver, therefore I would really appreciate
> it if someone could have a look at it from a USB perspective before it
> is (hopefully) pulled into net-next.

From a USB point of view, it looks sane, only one question:

> +static int mvusb_mdio_probe(struct usb_interface *interface,
> +			    const struct usb_device_id *id)
> +{
> +	struct device *dev = &interface->dev;
> +	struct mvusb_mdio *mvusb;
> +	struct mii_bus *mdio;
> +
> +	mdio = devm_mdiobus_alloc_size(dev, sizeof(*mvusb));

You allocate a bigger buffer here than the original pointer thinks it is
pointing to?

> +	if (!mdio)
> +		return -ENOMEM;
> +
> +	mvusb = mdio->priv;

And then you set this pointer here?

If that's the way this is supposed to work, that's fine, just feels like
the math is wrong somewhere...

thanks,

greg k-h
