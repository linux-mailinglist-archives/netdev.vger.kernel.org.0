Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E9269CF3B
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjBTOVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjBTOVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:21:50 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979971EBFB;
        Mon, 20 Feb 2023 06:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+qVUmgcCaBamLllrVyeVUDdcp42vM49OudImsye5myQ=; b=a9tFi2ZLGHKCaDdI6tJloQ3mRf
        k53Tt50+EWnO4RCfYDrDmIq6HBQSswZimR/1ZMyQLnz6QWZT2LkrZwoBk/Ka94Yeqg1KOxUCIifA7
        4abppt+UtX39hehdWl1ilrX1UkyALVAx++XmwAq73BZaEel/opTgeJ2baeS8B0WRtBhO+sr6NFUJ4
        QCKCdLE+KDDYnJvpfEPGo+DBBZ0TXDj7NVxByK40yHpXevAgf1iFQG3W7YSjreBfG9nFWmLQAZuJX
        rTGv4deE5KuOGQhbJTc+pi8JIKaewsJlKUnY432DoD5CDfRoXRdbtRD+w1k2CsMYJVItWgLPrZuHg
        6SdM+a3A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33300)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pU731-0004bJ-1j; Mon, 20 Feb 2023 14:21:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pU730-0001HX-As; Mon, 20 Feb 2023 14:21:42 +0000
Date:   Mon, 20 Feb 2023 14:21:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220135605.1136137-4-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 02:56:04PM +0100, Oleksij Rempel wrote:
>  	if (data->eee_enabled) {
> +		phydev->eee_enabled = true;
>  		if (data->advertised)
> -			adv[0] = data->advertised;
> -		else
> -			linkmode_copy(adv, phydev->supported_eee);
> +			phydev->advertising_eee[0] = data->advertised;

There is a behavioural change here that isn't mentioned in the patch
description - if data->advertised was zero, you were setting the
link modes to the full EEE supported set. After this patch, you
appear to leave advertising_eee untouched (so whatever it was.)

Which is the correct behaviour for this interface?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
