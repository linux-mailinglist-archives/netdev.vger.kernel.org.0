Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8922918B3
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 19:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgJRRwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 13:52:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33460 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJRRwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 13:52:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUCqw-002L6c-Mn; Sun, 18 Oct 2020 19:52:18 +0200
Date:   Sun, 18 Oct 2020 19:52:18 +0200
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
Message-ID: <20201018175218.GG456889@lunn.ch>
References: <20201018163625.2392-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018163625.2392-1-ardb@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
> +++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
> @@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt file in the same directory)
>  - max-frame-size: See ethernet.txt in the same directory.
>  
>  The MAC address will be determined using the optional properties
> -defined in ethernet.txt.
> +defined in ethernet.txt. The 'phy-mode' property is required, but may
> +be set to the empty string if the PHY configuration is programmed by
> +the firmware or set by hardware straps, and needs to be preserved.

In general, phy-mode is not mandatory. of_get_phy_mode() does the
right thing if it is not found, it sets &priv->phy_interface to
PHY_INTERFACE_MODE_NA, but returns -ENODEV. Also, it does not break
backwards compatibility to convert a mandatory property to
optional. So you could just do

	of_get_phy_mode(pdev->dev.of_node, &priv->phy_interface);

skip all the error checking, and document it as optional.

     Andrew
