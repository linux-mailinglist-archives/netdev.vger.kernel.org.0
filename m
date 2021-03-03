Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6036332C43D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384832AbhCDAMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358030AbhCCLh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 06:37:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11965C061756;
        Wed,  3 Mar 2021 03:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1FV3ZGkSnvChQ9hiLsDKK3+19QF32E4LTbRqQq+C1WE=; b=m4XgKO682GJKx5Y56314sR+Lq
        6GY7iLtMFWYj4UZ8D/FPhbchTIm37L0WBKl0pYwDN90ExJmz8C91WTPYLcnNYEomjugMarixvJ5eY
        6+W/MuK2ypvdtOi3WXBSGePFi0xRYpzhWnxb26Sp3ucgUhF/bl696bIPBM/pnWcnZqZ0+JaxFFp35
        d2jyp7zyKmqez3sLMFpGtYGb6ef12iwDr2Xw1LuVi2U5s/gPLQHIoRqx79XPCyA/26J9aWAT8gfj9
        C7a7rg9DOkR2eSnT1yprqKR7whzIuXdbk+S5glq1w1SH4/HRciWEPxmXOMt3RVlhhTAi93wijmtrn
        lynld3bnw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48466)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lHPoI-0005nj-Em; Wed, 03 Mar 2021 11:36:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lHPoF-0002KK-IT; Wed, 03 Mar 2021 11:36:55 +0000
Date:   Wed, 3 Mar 2021 11:36:55 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210303113655.GA1463@shell.armlinux.org.uk>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <20210303105756.sdeiwg7hn3p4rtq4@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303105756.sdeiwg7hn3p4rtq4@dhcp-179.ddg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Mostly great, but just a couple more points.

On Wed, Mar 03, 2021 at 01:57:57PM +0300, Ivan Bornyakov wrote:
> +	adv = 0;
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> +			      priv->supported))
> +		adv |= ADVERTISE_1000XFULL;
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +			      priv->supported))
> +		adv |= ADVERTISE_1000XPAUSE;
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +			      priv->supported))
> +		adv |= ADVERTISE_1000XPSE_ASYM;

You could use the helper:

	adv = linkmode_adv_to_mii_adv_x(priv->supported,
					ETHTOOL_LINK_MODE_1000baseX_Full_BIT);

instead here. It's also a bit weird to set the advertisement based off
a "supported" mask.

> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, supported);

Does the PHY support backplane links?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
