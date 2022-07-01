Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA4562F9D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbiGAJOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiGAJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:14:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683C53ED20;
        Fri,  1 Jul 2022 02:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=myLZG8Fxe2O1i1vWy67IytiAd7jdr/N9oCZa6x7j0I0=; b=GP62mLwq01G1gJMQGK4N5R3ehZ
        dpxwXJclqNQfsMA+0LkxdldsKE2DPcyytkGkBrT/jaByY9FYa3mT2VVflo7pZ4iSWP0gJJhu6R/0N
        9ZGBNiEdtdbimqRi61aReO7rF+3UX6QIUY0Uzevp2ZdZ37bcXDWuVvhK6hgrCx7BZJ5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o7Cia-008v8d-Tw; Fri, 01 Jul 2022 11:13:40 +0200
Date:   Fri, 1 Jul 2022 11:13:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        saravanak@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@amd.com
Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Message-ID: <Yr66xEMB/ORr0Xcp@lunn.ch>
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 01:25:06AM +0530, Radhey Shyam Pandey wrote:
> In shared MDIO suspend/resume usecase for ex. with MDIO producer
> (0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
> constraint that ethernet interface(ff0c0000) MDIO bus producer
> has to be resumed before the consumer ethernet interface(ff0b0000).
> 
> However above constraint is not met when GEM0(ff0b0000) is resumed first.
> There is phy_error on GEM0 and interface becomes non-functional on resume.
> 
> suspend:
> [ 46.477795] macb ff0c0000.ethernet eth1: Link is Down
> [ 46.483058] macb ff0c0000.ethernet: gem-ptp-timer ptp clock unregistered.
> [ 46.490097] macb ff0b0000.ethernet eth0: Link is Down
> [ 46.495298] macb ff0b0000.ethernet: gem-ptp-timer ptp clock unregistered.
> 
> resume:
> [ 46.633840] macb ff0b0000.ethernet eth0: configuring for phy/sgmii link mode
> macb_mdio_read -> pm_runtime_get_sync(GEM1) it return -EACCES error.
> 
> The suspend/resume is dependent on probe order so to fix this dependency
> ensure that MDIO producer ethernet node is always probed first followed
> by MDIO consumer ethernet node.
> 
> During MDIO registration find out if MDIO bus is shared and check if MDIO
> producer platform node(traverse by 'phy-handle' property) is bound. If not
> bound then defer the MDIO consumer ethernet node probe. Doing it ensures
> that in suspend/resume MDIO producer is resumed followed by MDIO consumer
> ethernet node.

I don't think there is anything specific to MACB here. There are
Freescale boards which have an MDIO bus shared by two interfaces etc.

Please try to solve this in a generic way, not specific to one MAC and
MDIO combination.

     Andrew
