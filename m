Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3DB34962D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCYPy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:54:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6F6C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 08:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gWMn7yci7LqeFqb9y1unE5cPZzZTY6okFaDcxWUko0U=; b=I8rGKkDbvRDgnBGoIgPe0ymZQ
        o21aM90AkcI/qZ/JHevam6/aTB4pzukygFUGm3/jEkk/uMdwtyfu9IsF+1Fna9vHlRqVI/IV4jdBi
        NV0EMR75pgxRk+G6ctHwJn39ja+cC7qtyX1Yumel8FJLG2HvhjlWfaipU1l7D0wML740wLNgbxXkr
        v6o5Uub43JvXABpQapQkrqrSeDzVks/R7tWFtISBa9tqlj80jlp9tuxOpt7y4ROm5TRUfaJb2M0nB
        dpuN54ptue0xF35agv5/EMf7rT2OGgyLCtGpg3vzEVB1E8KDzL72UJq2/qekNU4EV9VkMJAGEtwnI
        muwhelltA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51738)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lPSJy-0001zH-HY; Thu, 25 Mar 2021 15:54:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lPSJw-00068V-U5; Thu, 25 Mar 2021 15:54:52 +0000
Date:   Thu, 25 Mar 2021 15:54:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact model
Message-ID: <20210325155452.GO1463@shell.armlinux.org.uk>
References: <20210325131250.15901-1-kabel@kernel.org>
 <20210325131250.15901-12-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325131250.15901-12-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 02:12:49PM +0100, Marek Behún wrote:
> @@ -443,12 +446,24 @@ static int mv3310_probe(struct phy_device *phydev)
>  
>  	switch (phydev->drv->phy_id) {
>  	case MARVELL_PHY_ID_88X3310:
> +		ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_XGSTAT);
> +		if (ret < 0)
> +			return ret;
> +
> +		has_macsec = !(ret & MV_PMA_XGSTAT_NO_MACSEC);
> +
>  		if (nports == 4)
>  			priv->model = MV_MODEL_88X3340;
>  		else if (nports == 1)
>  			priv->model = MV_MODEL_88X3310;
>  		break;

The 88X3310 and 88X3340 can be differentiated by bit 3 in the revision.
In other words, 88X3310 is 0x09a0..0x09a7, and 88X3340 is
0x09a8..0x09af. We could add a separate driver structure, which would
then allow the kernel to print a more specific string via standard
methods, like we do for other PHYs. Not sure whether that would work
for the 88X21x0 family though.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
