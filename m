Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC823692B8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhDWNIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:08:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37968 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242646AbhDWNId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 09:08:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZvXD-000elp-OF; Fri, 23 Apr 2021 15:07:51 +0200
Date:   Fri, 23 Apr 2021 15:07:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45-tja11xx: add interrupt support
Message-ID: <YILGp+LdyxsRhkb2@lunn.ch>
References: <20210423124329.993850-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423124329.993850-1-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
> +{
> +	irqreturn_t ret = IRQ_NONE;
> +	int irq;
> +
> +	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
> +	if (irq & PHY_IRQ_LINK_EVENT) {
> +		phy_trigger_machine(phydev);
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_ACK,
> +			      PHY_IRQ_LINK_EVENT);

The ordering here is interesting. Could phy_trigger_machine() cause a
second interrupt? Which you then clear without acting upon before
exiting the interrupt handler? I think you should ACK the interrupt
before calling phy_trigger_machine().

       Andrew
