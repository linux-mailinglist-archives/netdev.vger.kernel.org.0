Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EFA5E626B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiIVMbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIVMbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6814DED4D;
        Thu, 22 Sep 2022 05:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4627161173;
        Thu, 22 Sep 2022 12:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDDDC433D6;
        Thu, 22 Sep 2022 12:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663849874;
        bh=uFdz3JBOBz05qZff1RLKZhqaV67IWYBxo2ez8Z2CzOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qWrhEWR0UY4xaHYTV2EQ2Fs1kgSnoNZ3bPXvKLczegNIUkJ2a6d/H7+5/HAS67GuB
         0d3u+e4M+ovg3My/M9CjKN+CywDDZkDmft2jeDe+uNNe7IVjXOktppa1TOYwBRtcqz
         93GQviOnX2TXoijOwO3wgK6fuJt3xpJ+nj/PiBdWbNdcVRfgudRMuO6aq+W5PHiGji
         55GUP5MvZyFWOzVKaZRtcnG+Hz44QrAJFbUBBAdYxiOUo6uk7gOu2/5kwj6G2Pi0zC
         BNbKPlnxQfpL1zLka78PXsoRpY6OGXdAtIZfVpg2RuZ/ToLsoZOrtQ8SJ0RXD+Zvr1
         P5ogMkENr17Vw==
Date:   Thu, 22 Sep 2022 05:31:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net] net: phy: Warn about incorrect
 mdio_bus_phy_resume() state
Message-ID: <20220922053113.250dc095@kernel.org>
In-Reply-To: <20220801233403.258871-1-f.fainelli@gmail.com>
References: <20220801233403.258871-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Aug 2022 16:34:03 -0700 Florian Fainelli wrote:
> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
> that we can produce a race condition looking like this:
> 
> CPU0						CPU1
> bcmgenet_resume
>  -> phy_resume
>    -> phy_init_hw
>  -> phy_start
>    -> phy_resume  
>                                                 phy_start_aneg()
> mdio_bus_phy_resume
>  -> phy_resume
>     -> phy_write(..., BMCR_RESET)
>      -> usleep()                                  -> phy_read()  
> 
> with the phy_resume() function triggering a PHY behavior that might have
> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
> brcm_fet_config_init()") for instance) that ultimately leads to an error
> reading from the PHY.

Hi Florian! There were some follow ups on this one, were all the known
reports covered at this point or there are still platforms to tweak?
