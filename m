Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BCE519F1C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349363AbiEDMWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239708AbiEDMWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:22:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E7A2CC90;
        Wed,  4 May 2022 05:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vSnkOzTamab+eXjxj1X3aPRZXcm8ZuhJALY0cnMErbE=; b=4Gy6bDIGLdTxYCLaZ8leq+C62Q
        sFHHn1FJKTx7496YU51xQwksTkh/CpXHbQA8q5aeDWPFHVttMqWbiHWDWl/3+1efVp36xua/fuPHt
        COCYAki9BkfDm2c6If4azhSNFWWphr11IpXEsDHxaGnMpsbcgLkA2LLzQNHzidfp1xJY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmDy7-001CsL-FH; Wed, 04 May 2022 14:18:59 +0200
Date:   Wed, 4 May 2022 14:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        linux@armlinux.org.uk, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: Do not use kszphy_suspend/resume for
 KSZ8061
Message-ID: <YnJvM4YaQBR0VZqF@lunn.ch>
References: <20220504114703.1229615-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504114703.1229615-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:47:03AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit f1131b9c23fb ("net: phy: micrel: use
> kszphy_suspend()/kszphy_resume for irq aware devices") the following
> NULL pointer dereference is observed on a board with KSZ8061:
> 
>  # udhcpc -i eth0
> udhcpc: started, v1.35.0
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000008
> pgd = f73cef4e
> [00000008] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> PC is at kszphy_config_reset+0x10/0x114
> LR is at kszphy_resume+0x24/0x64
> ...
> 
> The KSZ8061 phy_driver structure does not have the .probe/..driver_data
> fields, which means that priv is not allocated.
> 
> This causes the NULL pointer dereference inside kszphy_config_reset().
> 
> Fix the problem by using the generic suspend/resume functions as before.

Hi Fabio

Thanks for the fix. What you fail to mention is why not call
kszphy_probe() to populate priv? What makes this PHY special that it
does not need the probe call?

Looking at the ksphy_driver structure, this seems to affect
PHY_ID_KS8737 and PHY_ID_KSZ8061

     Thanks
	Andrew
