Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE4DF7F5
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbfJUWVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 18:21:48 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:32994 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJUWVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 18:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6uc83vVbAQNL+hWSYNLKkGKf3OFD2g2M4EAFEdxCp8k=; b=036YnA8M35zh7oaZP5i2lrsye
        EB0cDqf3F8uePuPil4Bamdbm8KtNRvsBdq07e1aHHJgDobEYpDojY9mOeX8YPPd1J2sC+mh+6VDxc
        /V9CA6YUSYv9pEQ1D6eRYBtf0ymOBj8sxubqz1HIJtD2vM6dH1pOOQwIR9tY0McREESQviSLk1hDT
        9Aad+EJGZHzyyUWVCsvOL2mAZKl5VCw9Vi52BbeATUdSZaXmXoUrg26XhJ0lkzlnbH06WL0VYhCfN
        UvtH8sR/oeNe0DxU2hwkxapIuU4gWA+ug0hzwvSwDebQsKNrfX++HAyF36QsP7DTwur0NBbrWwgBa
        pjPKOdWUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57354)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iMg3O-0003H1-0z; Mon, 21 Oct 2019 23:21:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iMg3G-0003uw-Oy; Mon, 21 Oct 2019 23:21:22 +0100
Date:   Mon, 21 Oct 2019 23:21:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 1/5] net: ag71xx: port to phylink
Message-ID: <20191021222122.GM25745@shell.armlinux.org.uk>
References: <20191021053811.19818-1-o.rempel@pengutronix.de>
 <20191021053811.19818-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021053811.19818-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 07:38:07AM +0200, Oleksij Rempel wrote:
> +static void ag71xx_mac_validate(struct phylink_config *config,
> +			    unsigned long *supported,
> +			    struct phylink_link_state *state)
>  {
> -	struct ag71xx *ag = netdev_priv(ndev);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    state->interface != PHY_INTERFACE_MODE_GMII &&
> +	    state->interface != PHY_INTERFACE_MODE_MII) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> +
> +	phylink_set(mask, MII);
> +
> +	/* flow control is not supported */
> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
>  
> -	ag71xx_link_adjust(ag, true);
> +	if (state->interface == PHY_INTERFACE_MODE_NA &&
> +	    state->interface == PHY_INTERFACE_MODE_GMII) {

This is always false.

Apart from that, from just reading the patch I have no further concerns.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
