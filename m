Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02F593466
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 20:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiHOSBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiHOSAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:00:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964C3BC18;
        Mon, 15 Aug 2022 11:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/1Bx4HDcIyS39X1ZLODVkDqCVJcvom8FSa7thBn5AsE=; b=mENEtynCU/ALxF5w4Q0Ehssk5Q
        O5IupNEBxUgN7s73l+WpbLWR7KJDJaAjc/w01JiKOQUfUUGGi8AapQHL0Sf76sM3jAz7nm6amNxmK
        TAo5EfGIS0GpbTQpicxWprZ+iNJX4vFkTUfGuCjdBtjGYmyNcAMe61WRzJD8wPC9Sm1oZ0FgD+MEA
        H9gA5RUix9i25JSNE8mDv4y+iR/pEkC5Io094XmSiz61hdyh+XOizyPeQdU4fES4cprdAx114605i
        tXSIBiSoKYTRADPVzdrlPQosCEccXopfGXUDuik+l8aY4QKpq0sC5VBWz1rramrs1l1sioy08lUKn
        MAgr9C4w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33802)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oNeOL-0003TT-Hg; Mon, 15 Aug 2022 19:00:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oNeOI-00041h-LD; Mon, 15 Aug 2022 19:00:42 +0100
Date:   Mon, 15 Aug 2022 19:00:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: broadcom: Implement suspend/resume
 for AC131 and BCM5241
Message-ID: <YvqJyg3eUusc8jkC@shell.armlinux.org.uk>
References: <20220815174356.2681127-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815174356.2681127-1-f.fainelli@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 10:43:56AM -0700, Florian Fainelli wrote:
> +	/* We cannot use a read/modify/write here otherwise the PHY continues
> +	 * to drive LEDs which defeats the purpose of low power mode.
> +	 */
...
> +	/* Set standby mode */
> +	reg = phy_read(phydev, MII_BRCM_FET_SHDW_AUXMODE4);
> +	if (reg < 0) {
> +		err = reg;
> +		goto done;
> +	}
> +
> +	reg |= MII_BRCM_FET_SHDW_AM4_STANDBY;
> +
> +	err = phy_write(phydev, MII_BRCM_FET_SHDW_AUXMODE4, reg);

Does the read-modify-write problem extend to this register? Why would
the PHY behave differently whether you used phy_modify() here or not?
On the mdio bus, it should be exactly the same - the only difference
is that we're guaranteed to hold the lock over the sequence whereas
this drops and re-acquires the lock.

If it's sensitive to the timing of the read and the write, it suggests
the above code is fragile - maybe there needs to be a minimum delay
inserted between the read and the write?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
