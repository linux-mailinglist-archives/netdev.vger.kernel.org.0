Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4547C381787
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhEOKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhEOKQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:16:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306DBC061573;
        Sat, 15 May 2021 03:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2PBgeHsoXGCvDlD0GS/BwaBaSsTzpzloPrgyfXRhmjk=; b=SptpJ/1TaW3YU510lhVFsI7S8
        HAwGT9i7IKhTTk5MGMIfLDcOzbdlf+9WO+/0kk9XY41f8n+ts423ikvlVkuknzGUTFVWi3FjoU5p6
        Frm8lLK8goe3xwxqU9ZRwaxkxrYAWlk6lgTLzumnPlT0hSth0LoqicadKCEUyfFq9pGRkcfTlM5NS
        JwWmw6DvQAyysirWaW7tFnIJEdvb2QaWmgo+CxTXTXs5mkyXaM9mG4cQDVkH40odW6flHTGlFEGnw
        bBntz1s8TWeVCn8iRdQcWxnai2OrQoY95HavEFFbZiaymv5onHZMWW/a1iuL4gRb7FDMRaQe9RVeM
        VLwTor4kw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44008)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhrKO-00018c-8n; Sat, 15 May 2021 11:15:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhrKM-0004uU-SE; Sat, 15 May 2021 11:15:22 +0100
Date:   Sat, 15 May 2021 11:15:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: mdiobus: get rid of a BUG_ON()
Message-ID: <20210515101522.GM12395@shell.armlinux.org.uk>
References: <YJ+b52c5bGLdewFz@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ+b52c5bGLdewFz@mwanda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 01:01:11PM +0300, Dan Carpenter wrote:
> We spotted a bug recently during a review where a driver was
> unregistering a bus that wasn't registered, which would trigger this
> BUG_ON().  Let's handle that situation more gracefully, and just print
> a warning and return.
> 
> Reported-by: Russell King <linux@armlinux.org.uk>

This probably ought to be updated to:

Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

now please.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> ---
>  drivers/net/phy/mdio_bus.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index dadf75ff3ab9..6045ad3def12 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -607,7 +607,8 @@ void mdiobus_unregister(struct mii_bus *bus)
>  	struct mdio_device *mdiodev;
>  	int i;
>  
> -	BUG_ON(bus->state != MDIOBUS_REGISTERED);
> +	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
> +		return;
>  	bus->state = MDIOBUS_UNREGISTERED;
>  
>  	for (i = 0; i < PHY_MAX_ADDR; i++) {
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
