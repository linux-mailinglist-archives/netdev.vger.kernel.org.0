Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186D36286B1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbiKNRJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiKNRJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:09:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C77B1B1F1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lfkP0HdkPkQvBtRrPiRbkjHURYLcSLHYJdSisiKXmZ8=; b=02r0v8mzOF7OVld/dtPGgY7lR0
        Sql7/2JKijyHi4XMja/olmPWnD4vRXJn7zRZ/gXaZ4DLyaIv3zyCP/g8yO0csE+Jk7VpgzEUpfSXq
        DXXxHvk4mCfwsevM1azo6jH5X3gSzBJTsXdtG//6HFQB2G2ZIinT29kHL1kRqsnmCxaYh2FKiQSXR
        KE0Qc+SKMYbJIfwANSItQaIPXRJO27DypVSS1gWtQhI9wWsjAydTzoqXdNsjwCYsJguUg44VInDKx
        qjGFPsz0NnZ9IAe/R9DJ9WeoxMXTSClO0jQ/rjXR5qvSYEMcOqDQJ9q2Ot+aDDyArtAtqFo6dsd9U
        QeOd2QpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35268)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oucxx-00018t-Uh; Mon, 14 Nov 2022 17:09:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oucxu-0003yf-Na; Mon, 14 Nov 2022 17:09:46 +0000
Date:   Mon, 14 Nov 2022 17:09:46 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: felix: use
 phylink_generic_validate()
Message-ID: <Y3J2WojkiNzbOMY6@shell.armlinux.org.uk>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
 <20221114170730.2189282-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114170730.2189282-3-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 07:07:28PM +0200, Vladimir Oltean wrote:
> Drop the custom implementation of phylink_validate() in favor of the
> generic one, which requires config->mac_capabilities to be set.
> 
> This was used up until now because of the possibility of being paired
> with Aquantia PHYs with support for rate matching. The phylink framework
> gained generic support for these, and knows to advertise all 10/100/1000
> lower speed link modes when our SERDES protocol is 2500base-x
> (fixed speed).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

LGTM.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
