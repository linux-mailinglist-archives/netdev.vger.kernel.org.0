Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3D464EFF0
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiLPRBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiLPRBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:01:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE16DFF8;
        Fri, 16 Dec 2022 09:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VulHPZjdideXJ2MoIe3TAQIC0Llz0yGDa0eRzLoIHH8=; b=nZ7j8WP5k/rmdFjogJDFQODTe0
        5DA91Yi36cWatusZerFBxrSxwspOQYrPugKOZWsIKTLmzdPaoq+HIqhITNXXkrL/KqXe95Vdkemfn
        E+xNNM8CxG5CvP5OYpP2BVMFig1z8QOj8GI9g60biZR8YfW3bdC4eUO90+XCvqI7K8yFWgBXe9IJ+
        /NKAaO1KB4GTk4igxO9EYlRxpgVitosU1WY11uc5IjOvSNsrxaxhoy1K+GWnm6g0//NXbr6TA/3NE
        EPGRnJh0WiSCeADnYjGwM4mS76JGW+2tc9MnIoW5piUa0r+yhsxWbVDwo17E4zbvlFnqLZuST5xQq
        XN+OIMnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35748)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p6E5c-0008CF-4u; Fri, 16 Dec 2022 17:01:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p6E5a-00012e-TD; Fri, 16 Dec 2022 17:01:38 +0000
Date:   Fri, 16 Dec 2022 17:01:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v4 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y5ykcmRUv22l7BRt@shell.armlinux.org.uk>
References: <20221216164851.2932043-1-sean.anderson@seco.com>
 <20221216164851.2932043-5-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216164851.2932043-5-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 11:48:51AM -0500, Sean Anderson wrote:
> When autonegotiation completes, the phy interface will be set based on
> the global config register for that speed. If the SERDES mode is set to
> something which the MAC does not support, then the link will not come
> up. To avoid this, validate each combination of interface speed and link
> speed which might be configured. This way, we ensure that we only
> consider rate adaptation in our advertisement when we can actually use
> it.
> 
> The API for get_rate_matching requires that PHY_INTERFACE_MODE_NA be
> handled properly.

This is no longer true. phy_get_rate_matching() used to be called with
PHY_INTERFACE_MODE_NA in phylink_bringup_phy(), but that no longer
happens as we need to know whether rate matching will be used to avoid
breaking stuff. See commit 7642cc28fd37 ("net: phylink: fix PHY
validation with rate adaption").

The purpose of PHY_INTERFACE_MODE_NA in phylink_bringup_phy() was to
deal with PHYs which switch their MAC-facing interface mode, but we
know that if a PHY uses rate adaption, the assumption now is that it
won't switch its MAC-facing interface, which fixes a problem that
Tim Harvey was having with the rate adaption code - and I believe
you agreed with.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
