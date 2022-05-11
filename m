Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867F75230ED
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiEKKpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiEKKpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:45:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5ED25CE;
        Wed, 11 May 2022 03:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ynEFWcNLUbKhhfDP6Hof3WWOqulhkKgMvRGzqwxgZps=; b=fSj7/EtcmF5CUqcdvN0gELtZu2
        H7LEdtNoKGlPjH/A7Jq3gGJypW5FkAjJiX/BhxPfzC7KCarmeqo9VJKGrw1mcRsNvrsITAJmt8lpp
        awFjprOAKBKd45OFBxfJOfoOOygBkIqQPsGve1nwkgOCmNx3VTwUGpBcq9Hn03S3tNzdkB62aXYTH
        39GDBwmdO3BfHt6S8dZfBewlXqePvpsBO8LsEU/c2iz/jxIY3mgIOtq/6IxySYDknhzp7FI45STBW
        8bsHc8CZwFPjvmbjAGMfrZ5SO2Ae+Ra2zitTeZxtH8GfiFZAID3mWT8JgTBKXsdT/vSDs867SQxnD
        73g41yFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60680)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nojqQ-0006fL-Rg; Wed, 11 May 2022 11:45:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nojqO-00071x-IX; Wed, 11 May 2022 11:45:24 +0100
Date:   Wed, 11 May 2022 11:45:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: phy: mscc: Add error check when __phy_read()
 failed
Message-ID: <YnuTxAw06UHCY1mf@shell.armlinux.org.uk>
References: <20220510142247.16071-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510142247.16071-1-wanjiabing@vivo.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 10:22:45PM +0800, Wan Jiabing wrote:
> Calling __phy_read() might return a negative error code. Use 'int'
> to declare variables which call __phy_read() and also add error check
> for them.
> 
> The numerous callers of vsc8584_macsec_phy_read() don't expect it to
> fail. So don't return the error code from __phy_read(), but also don't
> return random values if it does fail.
> 
> Fixes: fa164e40c53b ("net: phy: mscc: split the driver into separate files")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> Changelog:
> v2:
> - Sort variable declaration and add a detailed comment.
> ---
>  drivers/net/phy/mscc/mscc_macsec.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
> index b7b2521c73fb..58ad11a697b6 100644
> --- a/drivers/net/phy/mscc/mscc_macsec.c
> +++ b/drivers/net/phy/mscc/mscc_macsec.c
> @@ -22,9 +22,9 @@
>  static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
>  				   enum macsec_bank bank, u32 reg)
>  {
> -	u32 val, val_l = 0, val_h = 0;
> +	int rc, val, val_l, val_h;
>  	unsigned long deadline;
> -	int rc;
> +	u32 ret = 0;
>  
>  	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
>  	if (rc < 0)
> @@ -47,15 +47,20 @@ static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
>  	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
>  	do {
>  		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
> +		if (val < 0)
> +			goto failed;
>  	} while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSEC_19_CMD));
>  
>  	val_l = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_17);
>  	val_h = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_18);
>  
> +	if (val_l > 0 && val_h > 0)
> +		ret = (val_h << 16) | val_l;
> +
>  failed:
>  	phy_restore_page(phydev, rc, rc);
>  
> -	return (val_h << 16) | val_l;
> +	return ret;
>  }

This is still wrong - phy_restore_page() can fail to retore the page.

It's rather unfortunate that you need to return a u32, where the
high values become negative ints, which means you can't use
phy_restore_page() as it's supposed to be used.

If you fail to read from the PHY, is returning zero acceptable?

I think what you should be doing at the very least is:

	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
	if (rc < 0)
		goto failed;

	rc = __phy_write(phydev, MSCC_EXT_PAGE_MACSEC_20, ...);
	if (rc < 0)
		goto failed;

	...

	rc = __phy_write(phydev, MSCC_EXT_PAGE_MACSEC_19, ...);
	if (rc < 0)
		goto failed;

	...
	do {
		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
		if (val < 0) {
			rc = val;
			goto failed;
		}
	} while (...);

	val_l = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_17);
	if (val_l < 0) {
		rc = val_l;
		goto failed;
	}

	val_h = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_18);
	if (val_h < 0)
		rc = val_h;

failed:
	rc = phy_restore_page(phgydev, rc, 0);

	return rc < 0 ? 0 : val_h << 16 | val_l;

Which means that if any of the PHY IO functions fail at any point, this
returns zero.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
