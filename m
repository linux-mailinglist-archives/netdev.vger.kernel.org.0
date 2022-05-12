Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D627C524C7B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353585AbiELMPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352872AbiELMPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:15:08 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFA5FD35E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 05:15:05 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id E089230002505;
        Thu, 12 May 2022 14:15:03 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D32352E9DBE; Thu, 12 May 2022 14:15:03 +0200 (CEST)
Date:   Thu, 12 May 2022 14:15:03 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 4/7] usbnet: smsc95xx: Avoid link settings
 race on interrupt reception
Message-ID: <20220512121503.GC4703@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <9891d6dab3ad4a77add7b4833e9cf202da71d059.1652343655.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9891d6dab3ad4a77add7b4833e9cf202da71d059.1652343655.git.lukas@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:42:04AM +0200, Lukas Wunner wrote:
> When a PHY interrupt is signaled, the SMSC LAN95xx driver updates the
> MAC full duplex mode and PHY flow control registers based on cached data
> in struct phy_device:
> 
>   smsc95xx_status()                 # raises EVENT_LINK_RESET
>     usbnet_deferred_kevent()
>       smsc95xx_link_reset()         # uses cached data in phydev
> 
> Simultaneously, phylib polls link status once per second and updates
> that cached data:
> 
>   phy_state_machine()
>     phy_check_link_status()
>       phy_read_status()
>         lan87xx_read_status()
>           genphy_read_status()      # updates cached data in phydev
> 
> If smsc95xx_link_reset() wins the race against genphy_read_status(),
> the registers may be updated based on stale data.
> 
> E.g. if the link was previously down, phydev->duplex is set to
> DUPLEX_UNKNOWN and that's what smsc95xx_link_reset() will use, even
> though genphy_read_status() may update it to DUPLEX_FULL afterwards.
> 
> PHY interrupts are currently only enabled on suspend to trigger wakeup,
> so the impact of the race is limited, but we're about to enable them
> perpetually.
> 
> Avoid the race by delaying execution of smsc95xx_link_reset() until
> phy_state_machine() has done its job and calls back via
> smsc95xx_handle_link_change().
> 
> Signaling EVENT_LINK_RESET on wakeup is not necessary because phylib
> picks up link status changes through polling.  So drop the declaration
> of a ->link_reset() callback.
> 
> Note that the semicolon on a line by itself added in smsc95xx_status()
> is a placeholder for a function call which will be added in a subsequent
> commit.  That function call will actually handle the INT_ENP_PHY_INT_
> interrupt.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Andrew kindly provided this tag here:
https://lore.kernel.org/netdev/YnGrUdmqtzt3Ogn+@lunn.ch/

Forgot to add it to the commit.
Sending it in separately so patchwork picks it up.
My apologies for the inconvenience.
