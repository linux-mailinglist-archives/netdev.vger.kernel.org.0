Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20E529DE82
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbgJ1WSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731690AbgJ1WRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC3D22225C;
        Wed, 28 Oct 2020 01:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603848549;
        bh=Cots3/f76xKm1p8LO70eZ2F3GXe/8Lg6KZXXDkOuYjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xHIr5tzVXLnVJMm8QY89GwYP8ya4y/ivRM0t0msDLB5HeZAsMQvXH17GrjOxwjt6I
         6KcNWC3C4NBiChA9E43jxP4r+VyEh347v494NbaBvVo1ehqAkFRIfPVCMHJBVkuSFA
         5qQEK1cpamQzI9nrVQFXt7n843XZcU8D4UtLJ4Eg=
Date:   Tue, 27 Oct 2020 18:29:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: phy: marvell: add special handling of
 Finisar modules with 88E1111
Message-ID: <20201027182908.065db614@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026175714.1332354-1-robert.hancock@calian.com>
References: <20201026175714.1332354-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:57:14 -0600 Robert Hancock wrote:
> +	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled */
> +	if ((extsr & MII_M1111_HWCFG_MODE_MASK) ==
> +	    MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
> +		int err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
> +			  MII_M1111_HWCFG_MODE_MASK |
> +			  MII_M1111_HWCFG_SERIAL_AN_BYPASS,
> +			  MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
> +			  MII_M1111_HWCFG_SERIAL_AN_BYPASS);

Hm. Looks like checkpatch doesn't catch it, but this is at odds with
kernel coding style, isn't it?

1 - continuation lines need to be aligned to '('
2 - new line is required after a variable declaration

IOW:

       if ((extsr & MII_M1111_HWCFG_MODE_MASK) ==
           MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
               int err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
                                    MII_M1111_HWCFG_MODE_MASK |
                                    MII_M1111_HWCFG_SERIAL_AN_BYPASS,
                                    MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
                                    MII_M1111_HWCFG_SERIAL_AN_BYPASS);

               if (err < 0)
                       return err;
       }

Or:

       if ((extsr & MII_M1111_HWCFG_MODE_MASK) ==
           MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
               int err;

               err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
                                MII_M1111_HWCFG_MODE_MASK |
                                MII_M1111_HWCFG_SERIAL_AN_BYPASS,
                                MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
                                MII_M1111_HWCFG_SERIAL_AN_BYPASS);
               if (err < 0)
                       return err;
       }

Or better still:

       int err, mode;

       mode = extsr & MII_M1111_HWCFG_MODE_MASK;
       if (mode == MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
               err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
                                MII_M1111_HWCFG_MODE_MASK |
                                MII_M1111_HWCFG_SERIAL_AN_BYPASS,
                                MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
                                MII_M1111_HWCFG_SERIAL_AN_BYPASS);
               if (err < 0)
                       return err;
       }


> +		if (err < 0)
> +			return err;
> +	}
