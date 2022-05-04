Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B227051B15F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbiEDVzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDVzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:55:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869F550066;
        Wed,  4 May 2022 14:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3y9j8dX7DqQtw2AwMUgeK6pQJ/tWlNq2gUboEv9Ir24=; b=TBzPONHsZYX7vfy+FpCnz8t27p
        Ts5ESA8SCTq65NjpalmkX49HSPxSsecP8gQC3JiWqKbB21DWJnWGNfLPvHsfIu3kMU6tpGQIUYElF
        4Wjx6t31DRIuj5+D+D+9fJHJLsQ6s9f1FKwX08jd1n5lHJWYg58RuM/6PzzdtXTqsxu0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMtu-001GeY-2D; Wed, 04 May 2022 23:51:14 +0200
Date:   Wed, 4 May 2022 23:51:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        linux@armlinux.org.uk, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: phy: micrel: Do not use
 kszphy_suspend/resume for KSZ8061
Message-ID: <YnL1Ugno+jk990ru@lunn.ch>
References: <20220504143104.1286960-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504143104.1286960-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 11:31:03AM -0300, Fabio Estevam wrote:
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
> 
> Another alternative would be to provide the .probe and .driver_data
> information into the structure, but to be on the safe side, let's
> just restore Ethernet functionality by using the generic suspend/resume.
> 
> Cc: stable@vger.kernel.org
> Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
