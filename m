Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ADE63D466
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbiK3LZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiK3LYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:24:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4B01019;
        Wed, 30 Nov 2022 03:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6301NlmXCNSuGpCf/dSPGEa9RRPWwBQpP9USBwW/W3w=; b=ZxodPxa0H9FYjpkK5W+h5nwe4k
        OnGIlGaXgUjCNF1ESuXI213S7MG/j0h/6QJqt0JhSC+s5f/6hWPJoUQbC8+yc5UHVV4Pb5Y5Jz5ul
        sRTKIYanacZtUuy2gQD7+QBFIn1xxej8FFFP/aPxXtNk5fSPyXmYb86ndLM742OLUi7YWeKTgBNLJ
        hzirRHzwLlRvI5G56896hxWj0o4KWFA7My5lgI2MQU2y+HxXQzJj1cnn3hIo/3qDIrOk+GpwzYGUn
        5Khv5vjKcvFHk+JjKTJzYBi9tNFt1E/qmcFaxm3mF4pmmC7vMR0zBMdCd/2feVUTaNdHHLxgxy3Dk
        HN13xWvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35492)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p0LBp-0001di-Kx; Wed, 30 Nov 2022 11:23:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p0LBm-0002Rv-CO; Wed, 30 Nov 2022 11:23:42 +0000
Date:   Wed, 30 Nov 2022 11:23:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Message-ID: <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
 <20221130111148.1064475-2-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130111148.1064475-2-xiaoning.wang@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 07:11:47PM +0800, Clark Wang wrote:
> Issue we met:
> On some platforms, mac cannot work after resumed from the suspend with WoL
> enabled.
> 
> The cause of the issue:
> 1. phylink_resolve() is in a workqueue which will not be executed immediately.
>    This is the call sequence:
>        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
>    For stmmac driver, mac_link_up() will set the correct speed/duplex...
>    values which are from link_state.
> 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
>    phylink_resume(). stmmac_core_init() is called in function stmmac_hw_setup(),

... and that is where the problem is. Don't call phylink_resume() before
your hardware is ready to see a link-up event.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
