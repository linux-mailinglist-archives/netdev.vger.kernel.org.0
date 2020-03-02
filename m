Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB41176025
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgCBQjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:39:03 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49192 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgCBQjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:39:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VoqJ7tey7oFKvyIeul8Bam7/qeXZ4Z399hkKoRr+pCk=; b=ppqKjB+3eAcq/BFjq6zicm1hm
        9LzRUUU18UFufQ/bKeOy6xE7+440AuPggoZ5rK0N7hKKT9BjcN5NzbRcvvfxnQWFpArFmRNXyLm99
        lwTlq9iRzpZsCyNvE8E9+FuAen6LWtctDkuPq7lTDgrAys9Ip9/uH8GIGNxoAmMXGlaI0S3aJIJmw
        Jaq2G/5J4jKL3vylC/bsS4gefzCBK78Q5/Q8JwehPR0IfP1SI9gRlXMJVwRAeM/oNefQR92ONBZRk
        lSwkLC1rx3LCKDgO7fWcDFI41t5w/ferJsdc4iUFQqdvvRTc2IYm0VyDFs7iFccPI9j9xJGWFCv4B
        whN1rP3/A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59448)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j8o5o-0002Vj-8L; Mon, 02 Mar 2020 16:38:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j8o5k-000536-VR; Mon, 02 Mar 2020 16:38:52 +0000
Date:   Mon, 2 Mar 2020 16:38:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH] phylink: Improve error message when validate failed
Message-ID: <20200302163852.GH25745@shell.armlinux.org.uk>
References: <20200301235502.17872-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301235502.17872-1-hauke@hauke-m.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 12:55:02AM +0100, Hauke Mehrtens wrote:
> This should improve the error message when the PHY validate in the MAC
> driver failed. I ran into this problem multiple times that I put wrong
> interface values into the device tree and was searching why it is
> failing with -22 (-EINVAL). This should make it easier to spot the
> problem.

Hi,

This will do as a stop-gap measure to make debugging of that easier,
but in the longer run I want MAC drivers to provide phylink with a
bitmap of the PHY_INTERFACE_MODE_*s they support.

So,

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/phy/phylink.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index b4367fab7899..5347275215be 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -797,8 +797,14 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
>  		config.interface = interface;
>  
>  	ret = phylink_validate(pl, supported, &config);
> -	if (ret)
> +	if (ret) {
> +		phylink_warn(pl, "validation of %s with support %*pb and advertisement %*pb failed: %d\n",
> +			     phy_modes(config.interface),
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS, phy->supported,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising,
> +			     ret);
>  		return ret;
> +	}
>  
>  	phy->phylink = pl;
>  	phy->phy_link_change = phylink_phy_change;
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
