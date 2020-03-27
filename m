Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56401958F5
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC0O21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:28:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbgC0O20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=91vFmOujJvnFyZJJw3/z6ZLRNZbjx0rid7LzKuPpj9M=; b=cMT3lcMIVv2wHhqodtNns7enSk
        5dPtgZZulwrRci5qDaAaOdkh8bdZH2E94uXINcOtDESluzNmjorjCuD4TOGs4j/KP8itITOPKtVbo
        t5VECz0fOQvaTOrwKlZl10xcvAVgQzE8D/YGVjR+sR10kU26fENAWfdAaAa91zn4y6wk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHpy3-0002F9-VB; Fri, 27 Mar 2020 15:28:15 +0100
Date:   Fri, 27 Mar 2020 15:28:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Message-ID: <20200327142815.GG11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Read AN Link Status */
> +static int is_an_link_up(struct phy_device *bpphy)
> +{
> +	struct backplane_phy_info *bp_phy = bpphy->priv;
> +	int ret, val = 0;
> +
> +	mutex_lock(&bp_phy->bpphy_lock);
> +
> +	/* Read twice because Link_Status is LL (Latched Low) bit */
> +	val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy->bp_dev.mdio.an_status);
> +	val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy->bp_dev.mdio.an_status);
> +
> +	mutex_unlock(&bp_phy->bpphy_lock);

How does this mutex interact with phydev->lock? It appears both are
trying to do the same thing, serialise access to the PHY hardware.

	 Andrew
