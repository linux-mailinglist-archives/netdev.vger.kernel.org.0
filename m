Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFA6362A2E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244165AbhDPVXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236006AbhDPVXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 17:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A5356023F;
        Fri, 16 Apr 2021 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618608166;
        bh=bbnoIogpEqs7z4iGDVNSrQmuJDZ54RtiAQwXPkVJsZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YUEnQhg7Ah7JpzQkAy/oUqStsramtskjHIWlzm2JWjwQI3VyXfTIz7GmyLvOAD4h7
         qbh5k2hYv9zcdPoSxe9BZQxMLePS4DKu6VZU1sRKgIHB5fazIWrI7j2IjLeQF6yxkD
         MSfA4nwf3mpf6V+mxFsZELWqPl0QvKZGB4cAqjuvTOzVJ/s1skz69F3QhpKqpaZcR0
         Sx2tC3F5qI2jQYbX/JMAgQlotiwV2shEl3zoMX4GPPNl5rB/HpFzBeWrcTcYPaMEaP
         VaxQHmFZrAZXFm5dLqHZxqPCty/NdbRdrQRTGd9vM3qsYVGULTsLgEvg9dX6sphbOf
         S3M9NsMEUgKrg==
Date:   Fri, 16 Apr 2021 14:22:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next 03/10] net: sparx5: add hostmode with phylink
 support
Message-ID: <20210416142244.244656a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416131657.3151464-4-steen.hegelund@microchip.com>
References: <20210416131657.3151464-1-steen.hegelund@microchip.com>
        <20210416131657.3151464-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 15:16:50 +0200 Steen Hegelund wrote:
> +static int sparx5_set_mac_address(struct net_device *dev, void *p)
> +{
> +	const struct sockaddr *addr = p;
> +
> +	/* Record the address */
> +	ether_addr_copy(dev->dev_addr, addr->sa_data);

I think you need to validate that add is a valid ethernet address.
is_valid_ether_addr()

> +struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
> +{
> +	struct sparx5_port *spx5_port;
> +	struct net_device *ndev;
> +	u64 val;
> +
> +	ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
> +	if (!ndev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	SET_NETDEV_DEV(ndev, sparx5->dev);
> +	spx5_port = netdev_priv(ndev);
> +	spx5_port->ndev = ndev;
> +	spx5_port->sparx5 = sparx5;
> +	spx5_port->portno = portno;
> +	sparx5_set_port_ifh(spx5_port->ifh, portno);
> +	snprintf(ndev->name, IFNAMSIZ, "eth%d", portno);

Please don't try to name interfaces in the kernel.
