Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70721432024
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhJROt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJROt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:49:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10EBC06161C;
        Mon, 18 Oct 2021 07:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9iC152e1aDmgWA+aHHRHXqgiWkTrwFJBqqglF+YsoV0=; b=gHJxFdZpxImjujKrk8tlaAj20d
        +e4fdO08JlC1eoHubobQNZoIiy9k74GpWWZqPwl5EFYMOe0BRyKcvhPU07Qf6FcHPw0UywbkV22h2
        KFOxoDiFV9S/kqqzqOT2rf1vLwUZ6ZR96INicUDuJwX3fHpwhIyY09V0NJcB/bH0Vtycfh72zdvhT
        XC+ySVb0bFWlsSgP4aLKlvFXe0Y3ut+RJ63Iz2rVfCUBhWTCd/w+NdatUPLznRaYtGmkp8A29xPUj
        7Ei5IGK9t8xwqnVZn5qSrBstwfgMY8lUxbLe1u0W+TV7mFRYJ/03uJ234cIRimTrvacbGgRCSOMXh
        3wLNIChQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55174)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mcTur-00059X-Hd; Mon, 18 Oct 2021 15:47:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mcTuo-0005yw-PY; Mon, 18 Oct 2021 15:47:02 +0100
Date:   Mon, 18 Oct 2021 15:47:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: add quirk for Finisar FTLF8536P4BCL
Message-ID: <YW2I5qP0O4Pviia3@shell.armlinux.org.uk>
References: <20211013104542.14146-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013104542.14146-1-pmenzel@molgen.mpg.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:45:42PM +0200, Paul Menzel wrote:
> From: Taras Chornyi <taras.chornyi@plvision.eu>
> 
> Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR, but
> reports 25G & 100GBd SR in it's EEPROM.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> 
> [Upstream from https://github.com/dentproject/dentOS/pull/133/commits/b87b10ef72ea4638e80588facf3c9c2c1be67b40]
> 
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

Thanks Vadym for the eeprom dump.

> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index 7362f8c3271c..162b4030a863 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -55,6 +55,13 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
>  	phylink_set(modes, 1000baseX_Full);
>  }
>  
> +static void sfp_quirk_finisar_25g(const struct sfp_eeprom_id *id,
> +				  unsigned long *modes)
> +{
> +	phylink_set(modes, 1000baseX_Full);
> +	phylink_set(modes, 10000baseSR_Full);
> +}

I'd ask that this is named "sfp_quirk_1g10g()" please - it isn't
doing anything that is specific to Finisar, it is merely stating
that 1000base-X and 10000base-SR are supported.

> +	}, {
> +		// Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR,
> +		// but reports 25G & 100GBd SR in it's EEPROM

This file doesn't wrap over column 80, so please continue to keeping
it that way.

		// Finisar FTLF8536P4BCL can operate at 1000base-X and
		// 10000base-SR, but reports 25G & 100GBd SR in it's EEPROM

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
