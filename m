Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2256D2126
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjCaNHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjCaNHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:07:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB625B9D;
        Fri, 31 Mar 2023 06:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dX3+b7a2mtO46tzZW0WpCYT+JGnzFjdHoWuKzr8mDGc=; b=rrGuzRFYsnrsLy+qaZsXgGfv9I
        YdG+uYn89vS8lLaeuGQvA+TjsJT2/y9E//EL1HDO0GIqmFestJaIOK9bzCeFepIffW/DoB8vUuN+d
        qGplyBpGd2QUPPcI7KpTJi5s9TYC3g8Y1WVumgh7j+GTob3iT9CGWOC0NGMkWkowRudQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1piETm-0091tW-Gq; Fri, 31 Mar 2023 15:07:42 +0200
Date:   Fri, 31 Mar 2023 15:07:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] net: phy: introduce phy_reg_field interface
Message-ID: <d001e708-b5ac-4aa5-9624-4d9ae375d282@lunn.ch>
References: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:32:59PM +0300, Radu Pirea (OSS) wrote:
> Some PHYs can be heavily modified between revisions, and the addresses of
> the registers are changed and the register fields are moved from one
> register to another.
> 
> To integrate more PHYs in the same driver with the same register fields,
> but these register fields were located in different registers at
> different offsets, I introduced the phy_reg_fied structure.

Maybe you are solving the wrong problem. Maybe you should be telling
the hardware/firmware engineers not to do this!

How many drivers can actually use this?	I don't	really want to
encourage vendors to make such a mess of their hardware, so i'm
wondering if this should be hidden away in the driver, if there	is
only one driver which needs it.	If there are multiple drivers which
can use this, please do	modify at least	one other driver to use	it,
hence showing it is generic.

> +int phy_read_reg_field(struct phy_device *phydev,
> +		       const struct phy_reg_field *reg_field)
> +{
> +	u16 mask;
> +	int ret;
> +
> +	if (reg_field->size == 0) {
> +		phydev_warn(phydev, "Trying to read a reg field of size 0.");
> +		return -EINVAL;
> +	}
> +
> +	phy_lock_mdio_bus(phydev);
> +	if (reg_field->mmd)
> +		ret = __phy_read_mmd(phydev, reg_field->devad,
> +				     reg_field->reg);
> +	else
> +		ret = __phy_read(phydev, reg_field->reg);
> +	phy_unlock_mdio_bus(phydev);
> +

Could you please explain the locking. It appears you are trying to
protect reg_field->mmd? Does that really change? Especially since you
have _const_ struct phy_reg_field *

      Andrew
