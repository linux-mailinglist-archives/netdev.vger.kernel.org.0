Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538B863F722
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiLASJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLASJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:09:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D80EA1C0A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XPLY7tupp5FmzEvFMC2T9MaBtek19sKnDpmSiJnfvXI=; b=0hWnOzjOrJ/Z8wV1v8shYTGWgL
        nxevaWIf7Vs0zpwprusoAUW3KfXNDYnYAqj73knFcvWPL9K6oZjgVYrQf3I4XA1UinuVq5FSuDM32
        bOT9nhSQQeb1vSsHoKxx1UiLpBg5TxrCjXatxWmP9v8N5RciOMshYWrCrKZhgD+0mjuj7QYaymmSX
        EKLHByl0TuhQGR5XFooit16LiORdyPg0myRGgHItLf1ghMi00evMFGwuB0QvVOcu8p7bzCI8zaKiO
        2sa9NYabvWJCallAzHzshFVxMgzSKWsY4xm2uLmGP2rdCH7+T/IljzStFu9jzIyWbmZDprD7lhCEk
        JgUbddCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35514)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p0nzj-0003Df-Rz; Thu, 01 Dec 2022 18:09:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p0nzi-0003e6-Bd; Thu, 01 Dec 2022 18:09:10 +0000
Date:   Thu, 1 Dec 2022 18:09:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: Re: [PATCH] net: phylink: don't try to stop halted PHY
Message-ID: <Y4jtxg67HW80EXU2@shell.armlinux.org.uk>
References: <20221201175302.2732938-1-l.stach@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201175302.2732938-1-l.stach@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 06:53:02PM +0100, Lucas Stach wrote:
> When the PHY driver has encountered a non-recoverable error condition, e.g
> due to a failure in MDIO communication it may have already halted the PHY
> by calling phy_error(). If that is the case then phylink should not try to
> stop the PHY again.

No. phylib doesn't say this is necessary, and if you grep the many
network drivers, they don't do such a test.

If we want to do this then obviously all network drivers need to be
updated to do the same test before calling phy_stop()... but it would
be better if phylib avoided being rather silly in this case.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
