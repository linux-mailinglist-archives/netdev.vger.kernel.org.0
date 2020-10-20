Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A76F293C30
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406672AbgJTMuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:50:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406594AbgJTMuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:50:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUr5V-002fTB-Rg; Tue, 20 Oct 2020 14:50:01 +0200
Date:   Tue, 20 Oct 2020 14:50:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     netdev@vger.kernel.org, Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI
 systems
Message-ID: <20201020125001.GX456889@lunn.ch>
References: <20201018163625.2392-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018163625.2392-1-ardb@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 06:36:25PM +0200, Ard Biesheuvel wrote:
> Since commit bbc4d71d63549bc ("net: phy: realtek: fix rtl8211e rx/tx
> delay config"), the Realtek PHY driver will override any TX/RX delay
> set by hardware straps if the phy-mode device property does not match.
> 
> This is causing problems on SynQuacer based platforms (the only SoC
> that incorporates the netsec hardware), since many were built with
> this Realtek PHY, and shipped with firmware that defines the phy-mode
> as 'rgmii', even though the PHY is configured for TX and RX delay using
> pull-ups.
> 
> >From the driver's perspective, we should not make any assumptions in
> the general case that the PHY hardware does not require any initial
> configuration. However, the situation is slightly different for ACPI
> boot, since it implies rich firmware with AML abstractions to handle
> hardware details that are not exposed to the OS. So in the ACPI case,
> it is reasonable to assume that the PHY comes up in the right mode,
> regardless of whether the mode is set by straps, by boot time firmware
> or by AML executed by the ACPI interpreter.
> 
> So let's ignore the 'phy-mode' device property when probing the netsec
> driver in ACPI mode, and hardcode the mode to PHY_INTERFACE_MODE_NA,
> which should work with any PHY provided that it is configured by the
> time the driver attaches to it. While at it, document that omitting
> the mode is permitted for DT probing as well, by setting the phy-mode
> DT property to the empty string.
> 
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Willy Liu <willy.liu@realtek.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Masahisa Kojima <masahisa.kojima@linaro.org>
> Cc: Serge Semin <fancer.lancer@gmail.com>
> Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
