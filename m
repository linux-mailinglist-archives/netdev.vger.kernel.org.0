Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904706D20BE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjCaMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbjCaMqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:46:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D5A20C2C;
        Fri, 31 Mar 2023 05:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xEa6d5DG11fq8zHGlX4+tQCvlIKXaRBB6/hJnzxgpbA=; b=mPSJCFT3kAFwXmE2bTYa3CQztv
        bkehFNlYrnZbbny6oX5kQZECsIk0Ldrr7H2K3sVfGOdvcAdrcLtpjKiw2Iad9pQnS0lYShqTJx/3o
        PPe11JYWSnpUL8rZJauYKMaHRkjrPRYQphphWAkbWT6eikHsSUWKzkAd+wHeh+H7ntPyq+ZpjY4Va
        rtpcWIjSxGwQpkFPUSBcmNkhDAglp8UfimScpsdsngqcWmrZfB3silfnuJbu/yvwfxQ6goQb9WNih
        ReCQi8LOV5jEYXOgtTHbLmQKIb1cRkerNC2gGG2BMomLrpRCmlmq9yvFBLjvBcybIwiQyKSfLSJvZ
        4TsaHn9Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52770)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1piE8w-00057t-L2; Fri, 31 Mar 2023 13:46:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1piE8t-0001BE-SI; Fri, 31 Mar 2023 13:46:07 +0100
Date:   Fri, 31 Mar 2023 13:46:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] net: phy: introduce phy_reg_field interface
Message-ID: <ZCbWD7TiiCzxgWoI@shell.armlinux.org.uk>
References: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
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
> 
> phy_reg_fied structure abstracts the register fields differences.

Oh no, not more perliferation of different accessors...

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
> +	if (ret < 0)
> +		return ret;
> +
> +	mask = reg_field->size == 1 ? BIT(reg_field->offset) :
> +		GENMASK(reg_field->offset + reg_field->size - 1, reg_field->offset);
> +	ret &= mask;
> +	ret >>= reg_field->offset;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_read_reg_field);

I guess next we'll eventually see that we need __phy_read_reg_field
which doesn't take the lock, so that several accesses can be done
together. E.g. to access some form of paging mechanism.

> +/**
> + * phy_write_reg_field - Convenience function for writing a register field
> + * on a given PHY.
> + * @phydev: the phy_device struct
> + * @reg_field: the phy_reg_field structure to be written
> + * @val: value to write to @reg_field
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int phy_write_reg_field(struct phy_device *phydev,
> +			const struct phy_reg_field *reg_field, u16 val)
> +{
> +	u16 mask;
> +	u16 set;
> +	int ret;
> +
> +	if (reg_field->size == 0) {
> +		phydev_warn(phydev, "Trying to write a reg field of size 0.");
> +		return -EINVAL;
> +	}
> +
> +	mask = reg_field->size == 1 ? BIT(reg_field->offset) :
> +		GENMASK(reg_field->offset + reg_field->size - 1, reg_field->offset);
> +	set = val << reg_field->offset;
> +
> +	phy_lock_mdio_bus(phydev);
> +	if (reg_field->mmd)
> +		ret = __phy_modify_mmd_changed(phydev, reg_field->devad,
> +					       reg_field->reg, mask, set);
> +	else
> +		ret = __phy_modify_changed(phydev, reg_field->reg,
> +					   mask, set);
> +	phy_unlock_mdio_bus(phydev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_write_reg_field);

More or less the same for this too.

In order to properly review this, we need the patch which has the use
case for these new accessors.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
