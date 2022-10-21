Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF57B607EE6
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJUTPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiJUTPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:15:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9319D253BCF
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wOs78wkzasX/DXA5fij9FjGUZbMlq/K0qB4VOk8q0X4=; b=hipesc9bZbw6+HROQvWVTU0Ykr
        LK+TB6tz7bUrzyT6W6vU5S0tXurrxa0RpDBgncAz0g9D0kjwwxQNkqdEaDqvjAejocKdf9HdKJZak
        Lbfjbas9EOwmKd+beWQVa81FE6ndBPzxOF8FSG8ZS+Dy0rC8CKxFYIY54D4i9+Nu4GiSRqXFssIv4
        gScuoaAOSFRLYhx18A9Uc4oM7ANtsXco0DQriMW7QxyBamuZkZlzT/7kJLp70qUcW/qNinj1j0hWd
        Q10s3/StT0YO0bIT6WVpBJKbPxkZgw6xsrJWkkPpoG135yCE4+/8YAMyZWrygAJf3AO4EILY/qTRd
        kASnkK2g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34878)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olxTM-0000cR-Ub; Fri, 21 Oct 2022 20:14:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olxTL-0004Ok-Gm; Fri, 21 Oct 2022 20:14:23 +0100
Date:   Fri, 21 Oct 2022 20:14:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: sfp: get rid of DM7052 hack when
 enabling high power
Message-ID: <Y1Lvj5vGL8/9Ojk+@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol98G-00EDT1-Q6@rmk-PC.armlinux.org.uk>
 <Y1LAVAUSQJrmO+63@lunn.ch>
 <20221021091618.30c27249@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021091618.30c27249@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:16:18AM -0700, Jakub Kicinski wrote:
> On Fri, 21 Oct 2022 17:52:52 +0200 Andrew Lunn wrote:
> > On Wed, Oct 19, 2022 at 02:29:16PM +0100, Russell King (Oracle) wrote:
> > > Since we no longer mis-detect high-power mode with the DM7052 module,
> > > we no longer need the hack in sfp_module_enable_high_power(), and can
> > > now switch this to use sfp_modify_u8().
> > > 
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>  
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> FWIW there is a v2 of this, somewhat mis-subjected (pw-bot's
> auto-Superseding logic missed it for example):
> https://lore.kernel.org/all/E1oltef-00Fwwz-3t@rmk-PC.armlinux.org.uk/

Yes, sadly I forgot to update the subject line prefix. Getting
everything correct every time is quite difficult.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
