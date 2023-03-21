Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850DD6C3170
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjCUMUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCUMTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:19:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B283A864
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ElA6qLhNS3VR7AcrEFJ/HtgohrGfzckcBcX4VJm3vBY=; b=pGYqirDG2hnihyyFZHPSo6Du2Q
        zlEP2EheWG0ejZA5pf5+nUotRf4ChR092RUz1wFY5wNyHTATxGCgzqlCCbg9DAlTTzjX+V+AVRiWS
        ahmzs8d+D0qxTi8UaCgGuw0KpxmGUmFJy+FQtd26Bo+b7x+ozWKGmeXF0v8Dut/AKbt0qaosmhLgu
        JsK8iYMSxwe6P7nctgBhawXZFG5OsARl6NmGI2yyR3D6yZblhQhnvdDKUdDIvLtJKVvQVuBwTklH3
        ZF+Cz8mvZfkJZ2/G0PYKFdxM8tUTiMK7Zoq977Hzti/EO7WriFe15Xkf7QsgXF/dSeC4xLuPMijBo
        Oa4ZbPOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45534)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peaxU-00014M-Uo; Tue, 21 Mar 2023 12:19:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peaxT-0007j5-BQ; Tue, 21 Mar 2023 12:19:19 +0000
Date:   Tue, 21 Mar 2023 12:19:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: qca8k: remove assignment of
 an_enabled in pcs_get_state()
Message-ID: <ZBmgxwbsPwv1HUdP@shell.armlinux.org.uk>
References: <E1pdsE5-00Dl2l-8F@rmk-PC.armlinux.org.uk>
 <9c2a6d714969b0151da4e3aaaf4fa2b7c4e9f616.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c2a6d714969b0151da4e3aaaf4fa2b7c4e9f616.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 12:47:08PM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Sun, 2023-03-19 at 12:33 +0000, Russell King (Oracle) wrote:
> > pcs_get_state() implementations are not supposed to alter an_enabled.
> > Remove this assignment.
> > 
> > Fixes: b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB")
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Any special reason to target the net-next tree? the fixes commit is
> quite old, and this looks like a -net candidate to me?!?

It's a correctness issue rather than a bug fix, so I don't see why it
should be applied to a -rc kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
