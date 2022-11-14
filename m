Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066B56286BB
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbiKNRMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiKNRL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:11:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA031EF7
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lyf6xccXdatcijPwAUWt1NpAfeFk1lzqYgswZ+K8NIM=; b=SJII2BVaFMf12SVjsWPp6sVZRy
        wm1jdVwI6PXVEnUOLkwkaaxWsSZgSiEvBhiCWEIkbe1PUM9oUg4ZwZZ2Cz5n5J0vo7pmBRyyNMdrM
        LRPlHYY3zFrTojtj8WNwtqD+aLVrcjX0va38MTeRsysbiHJqiXrgPfXSuZgx/xazN63X9ZiuMMY5e
        HNHJvtSYFsgX5sFpdT3QGHDL7bIx37yyRN5fLn9Ahde78Yi036C1m4jXfUJJJ8SMOTUnTPkLeqIuA
        TBgDbudVtu6HftgLcHcg2ocyKbekV4RNBstMp7bI6FqYJgAjcj/zzXiwQizIagGa06Frv6QTAOuLe
        TvOTrXIg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35272)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ouczx-00019l-Sn; Mon, 14 Nov 2022 17:11:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ouczx-0003yt-2j; Mon, 14 Nov 2022 17:11:53 +0000
Date:   Mon, 14 Nov 2022 17:11:53 +0000
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
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: remove phylink_validate()
 method
Message-ID: <Y3J22TIKVAeipgsX@shell.armlinux.org.uk>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
 <20221114170730.2189282-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114170730.2189282-5-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 07:07:30PM +0200, Vladimir Oltean wrote:
> As of now, no DSA driver uses a custom link mode validation procedure
> anymore. So remove this DSA operation and let phylink determine what is
> supported based on config->mac_capabilities (if provided by the driver).
> Leave a comment why we left the code that we did, and that there is more
> work to do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Yay!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
