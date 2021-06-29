Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE313B72E4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhF2NFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbhF2NFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:05:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5C2C061760;
        Tue, 29 Jun 2021 06:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5eW633CBtlNjJXdomlGqoeVgjzec3P9oExDdZMOf324=; b=LyTXxavTIzGMjVZLcnkS5+EE/
        Z4B4RC8w5fuYqBzcpxlQ3f5u2VkEPF/U10sJU1M29FctxCrNgGsmP4EIzy65AgKFSFJLYQ/FEbYc1
        oG5foRgYgsA77FZCUvcUj7fEXjACgvqKV+I/PLgmyOtKhuFbtz1HDVBMkV6aemLjnlk785cV8zjSJ
        IIwxcjNO2UGnLIq5iq/GZ1RKQuCqM4B7SDenuwlcuwzQyGde1g+fcCiW8uzcSuX2RgyfYVxSQe3Q4
        pvmzB5s3y11NrCa8mBTspyZ+kKYLiSvoUzIfgYKnp534s4jYxm0kXBYC6kkxHzT1Ih+1FCkj9JRDn
        PDfZl0SHQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45470)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lyDOV-0004f0-9z; Tue, 29 Jun 2021 14:03:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lyDOQ-00021q-Qg; Tue, 29 Jun 2021 14:03:10 +0100
Date:   Tue, 29 Jun 2021 14:03:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Behun <marek.behun@nic.cz>,
        weifeng.voon@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com
Subject: Re: [PATCH net-next V2] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210629130310.GC22278@shell.armlinux.org.uk>
References: <20210629105554.1443676-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629105554.1443676-1-pei.lee.ling@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 06:55:54PM +0800, Ling Pei Lee wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Basically it is just to enable to WoL interrupt and enable WoL detection.
> Then, configure the MAC address into address detection register.
> 
> Change Log:
>  V2:
>  (1) Reviewer Marek request to rorganize code to readable way.
>  (2) Reviewer Rusell request to put phy_clear_bits_mmd() outside of if(){}else{}
>      and modify return ret to return phy_clear_bits_mmd().
>  (3) Reviewer Rusell request to add return on phy_read_mmd() in set_wol().
>  (4) Reorganize register layout to be put before MV_V2_TEMP_CTRL.

I actually said:

"Please put these new register definitions in address order. This list
is first sorted by MMD and then by address. So these should be before
the definition of MV_V2_TEMP_CTRL."

Which you have partially done.

> @@ -99,6 +100,17 @@ enum {
>  	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN	= 0x5,
>  	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
>  	MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII			= 0x7,
> +	MV_V2_MAGIC_PKT_WORD0	= 0xf06b,
> +	MV_V2_MAGIC_PKT_WORD1	= 0xf06c,
> +	MV_V2_MAGIC_PKT_WORD2	= 0xf06d,
> +	/* Wake on LAN registers */
> +	MV_V2_WOL_CTRL		= 0xf06e,
> +	MV_V2_WOL_STS		= 0xf06f,
> +	MV_V2_WOL_CLEAR_STS	= BIT(15),
> +	MV_V2_WOL_MAGIC_PKT_EN	= BIT(0),
> +	MV_V2_PORT_INTR_STS	= 0xf040,
> +	MV_V2_PORT_INTR_MASK	= 0xf043,
> +	MV_V2_WOL_INTR_EN	= BIT(8),

Clearly MV_V2_PORT_INTR_STS is at a lower address than
MV_V2_MAGIC_PKT_WORD0, so the list is not sorted as it originally was.

Apart from that, the rest of the patch looks good, thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
