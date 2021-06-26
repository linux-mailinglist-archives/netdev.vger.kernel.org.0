Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704193B4F0B
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhFZOlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 10:41:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhFZOlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 10:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lp48kfF78w3pyeDPlT6JtePXbX+mrDANUfVxDqDs4RI=; b=zRBxUeDMnlbUSnbVkYUXmhyb9o
        lpGjx5sN4iEW6LAD4aNV1Trk0dUhPWI1PGUOesB6bMXLXbbDkzhZ1frSTyJSGkCWFUrp3TDnSQX36
        H9s10qGTvyolt9dlsH0Op/ugPXSgNFLGIYBP1BmUAcFRvc2IlSP92NcrzReqwPr18Cq0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lx9SJ-00BE7l-Hg; Sat, 26 Jun 2021 16:38:47 +0200
Date:   Sat, 26 Jun 2021 16:38:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v8] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YNc790LXRWjFmT21@lunn.ch>
References: <20210625011146.18237-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625011146.18237-1-davthompson@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mlxbf_gige_get_regs(struct net_device *netdev,
> +				struct ethtool_regs *regs, void *p)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +
> +	regs->version = MLXBF_GIGE_REGS_VERSION;
> +
> +	/* Read entire MMIO register space and store results
> +	 * into the provided buffer. Each 64-bit word is converted
> +	 * to big-endian to make the output more readable.
> +	 *
> +	 * NOTE: by design, a read to an offset without an existing
> +	 *       register will be acknowledged and return zero.
> +	 */
> +	memcpy_fromio(p, priv->base, MLXBF_GIGE_MMIO_REG_SZ);

Is the big-endian comment correct? memcpy_fromio() appears to be
native endian.

> +static int mlxbf_gige_do_ioctl(struct net_device *netdev,
> +			       struct ifreq *ifr, int cmd)
> +{
> +	if (!(netif_running(netdev)))
> +		return -EINVAL;
> +
> +	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
> +}

You could use phy_do_ioctl_running() here.

For the MDIO, PHY and ethtool parts:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
