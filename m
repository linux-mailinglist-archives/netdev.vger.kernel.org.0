Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1C38FCD9
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 10:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhEYIdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 04:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhEYIdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 04:33:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275CDC061574;
        Tue, 25 May 2021 01:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2Tbd9SAdqfznWwtvifNl7ucpqO0NCIjR2dWlrNyfo+U=; b=1HljjSmp7Ygdz+35kryD2Docd
        D+Jkj42s/l6RhTS67aeNr7O9w15ay5E2xamcrgUC6u/7EiQEkjtoshXDvBiObzk7QNszRyzxeI/gv
        6HZ5kh6aoDeET9BnoqQSk3tS30EkeK+bY6ihjddlQkrlh0AMIghhuX9T+dJjrEhImXFDKYu0UKi+c
        PmPEROGUtCezv3I7qyDXDDEV8ujMJHQ5OyUvI1FKXiZupqukCaCBVdz/HQq27eUk584g2kqoiX5/G
        +TzGwFt/PEgpx4rmshMXcr6scf6otQkSKGdYy+0iiaZl4apU2zQcF1d6gQZkUrPytbv9pmscpLAWS
        JcbkQG1Dg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44344)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1llST8-0003zS-GW; Tue, 25 May 2021 09:31:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1llST7-0001kB-IW; Tue, 25 May 2021 09:31:17 +0100
Date:   Tue, 25 May 2021 09:31:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: phy: allow mdio bus to probe for c45
 devices before c22
Message-ID: <20210525083117.GC30436@shell.armlinux.org.uk>
References: <20210525055839.22496-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525055839.22496-1-vee.khee.wong@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 01:58:39PM +0800, Wong Vee Khee wrote:
> Some MAC controllers that is able to pair with  external PHY devices
> such as the Synopsys MAC Controller (STMMAC) support both Clause-22 and
> Clause-45 access.
> 
> When paired with PHY devices that only accessible via Clause-45, such as
> the Marvell 88E2110, any attempts to access the PHY devices via
> Clause-22 will get a PHY ID of all zeroes.
> 
> To fix this, we introduce MDIOBUS_C45_C22 which the MAC controller will
> try with Clause-45 access before going to Clause-22.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  include/linux/phy.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 60d2b26026a2..9b0e2c76e19b 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -368,6 +368,7 @@ struct mii_bus {
>  		MDIOBUS_C22,
>  		MDIOBUS_C45,
>  		MDIOBUS_C22_C45,
> +		MDIOBUS_C45_C22,
>  	} probe_capabilities;
>  
>  	/** @shared_lock: protect access to the shared element */

The new definition doesn't seem to be used anywhere, so this patch
merely adds the definition. It doesn't do what it says in the subject
line. Any driver that sets the capabilities to MDIOBUS_C45_C22 will
end up not doing any probing of the PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
