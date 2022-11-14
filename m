Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249F46286B4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbiKNRKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiKNRKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:10:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8685127B10
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7uz5eRlpf+wLDKLw3wVqRD1TcwiE+ljD2uRTK64mbOE=; b=psYMVfYneVikVwI8avsO6dMji4
        hkduGJrZwxQaAwdsQDHbdN92fH9op/Ry/ZxLAnd3lsl+TWGT01jPS00FU9FWruQXMgU86vb+g4li3
        L/52jc08ZLdzxXJWM63L0fqJ9+UQ9aXTQTU1w/UwuYhDJ6lCJRTw1ChoRqsVKEmOVyMgv3nl4/cjF
        252MS3fzNnStWvRe2Q+0gveryzK2tG6K48LcSo0szFUZEnbFh9CGdfrYODxoYHFaFYgXpr3p+u7zN
        X2CklGc9jA/zZWjsGlmFaHMyoGkPuc/x+wODD5JvjBMbpNLliwtzOhGt/QP5e7J/ULdvQcVAysWJC
        0vQ9Ac7w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35270)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oucys-00019K-G9; Mon, 14 Nov 2022 17:10:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oucyq-0003ym-V8; Mon, 14 Nov 2022 17:10:44 +0000
Date:   Mon, 14 Nov 2022 17:10:44 +0000
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
Subject: Re: [PATCH v2 net-next 3/4] net: mscc: ocelot: drop workaround for
 forcing RX flow control
Message-ID: <Y3J2lHuIlzRCyPTq@shell.armlinux.org.uk>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
 <20221114170730.2189282-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114170730.2189282-4-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 07:07:29PM +0200, Vladimir Oltean wrote:
> As phylink gained generic support for PHYs with rate matching via PAUSE
> frames, the phylink_mac_link_up() method will be called with the maximum
> speed and with rx_pause=true if rate matching is in use. This means that
> setups with 2500base-x as the SERDES protocol between the MAC/PCS and
> the PHY now work with no need for the driver to do anything special.
> 
> Tested with fsl-ls1028a-qds-7777.dts.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

LGTM.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
