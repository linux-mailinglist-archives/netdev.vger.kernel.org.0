Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BE952F24B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352417AbiETSOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350151AbiETSOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:14:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7770618FF1F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14BEA6179A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 18:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41054C385A9;
        Fri, 20 May 2022 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070448;
        bh=lVU0Y8SXkrX/4JMYZDPRrvh3mcLdI9ET53LSLhyTJ3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L1BPW/K4We/QaP5dvf2fZP3Vnohu6ha1rBVtWVNr9q6LzbJJB2EHpZSoM2uFrFpPU
         l8YEq8wRLVp+hRV/GpMwJSivqzJIbfSatf37jdiV8UPe7hPkT+d5E/8/EDh0lErrid
         C+UVNgZfUgPSOqyr6UWSBekQ987rR8UV7WvcoCJlTw9dhMiS6+z13P3h3om09IXdNB
         njbvMj45ZJdtuwGFKxqRRmGHItJPnezyg4F2wZBk0RBFX2EVJ4U8gzqikByOVL9BnR
         As3ATneDxHmCJK86J3l9T+9OcmQub2YjxFZTxrT10j12OYtE2WaZkCrREB6XCIjpB/
         lzNY/mFLe21hw==
Date:   Fri, 20 May 2022 11:14:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, olteanv@gmail.com,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220520111407.2bce7cb3@kernel.org>
In-Reply-To: <YoeIj2Ew5MPvPcvA@lunn.ch>
References: <20220520004500.2250674-1-kuba@kernel.org>
        <YoeIj2Ew5MPvPcvA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 14:24:47 +0200 Andrew Lunn wrote:
> > +/**
> > + * netif_carrier_local_changes_start() - enter local link reconfiguration
> > + * @dev: network device
> > + *
> > + * Mark link as unstable due to local administrative actions. This will
> > + * cause netif_carrier_off() to behave like netif_carrier_admin_off() until
> > + * netif_carrier_local_changes_end() is called.
> > + */
> > +static inline void netif_carrier_local_changes_start(struct net_device *dev)
> > +{
> > +	set_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
> > +}
> > +
> > +static inline void netif_carrier_local_changes_end(struct net_device *dev)
> > +{
> > +	clear_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
> > +}
> > +  
> 
> Since these don't perform reference counting, maybe a WARN_ON() if the
> bit is already set/not set.

Good idea.

> >  void netif_carrier_on(struct net_device *dev);
> >  void netif_carrier_off(struct net_device *dev);
> > +void netif_carrier_admin_off(struct net_device *dev);
> >  void netif_carrier_event(struct net_device *dev);  
> 
> I need some examples of how you see this used. I can see two ways:
> 
> At the start of a reconfigure, the driver calls
> netif_carrier_local_changes_start() and once it is all over and ready
> to do work again, it calls netif_carrier_local_changes_end().

I was looking at bnxt because it's relatively standard for DC NICs and
doesn't have 10M lines of code.. then again I could be misinterpreting
the code, I haven't tested this theory:

In bnxt_set_pauseparam() for example the driver will send a request to
the FW which will result in the link coming down and back up with
different settings (e.g. when pause autoneg was changed). Since the
driver doesn't call netif_carrier_off() explicitly as part of sending
the FW message but the link down gets reported thru the usual interrupt
(as if someone yanked the cable out) - we need to wrap the FW call with
the __LINK_STATE_NOCARRIER_LOCAL

> The driver has a few netif_carrier_off() calls changed to
> netif_carrier_admin_off(). It is then unclear looking at the code
> which of the calls to netif_carrier_on() match the off.

Right, for bnxt again the carrier_off in bnxt_tx_disable() would become
an admin_carrier_off, since it's basically part of closing the netdev.

> Please could you pick a few drivers, and convert them? 

Will do -- unless someone has concerns about this approach or a better
idea.

> Maybe include a driver which makes use of phylib, which should be
> doing control of the carrier based on the actual link status.

For phylib I was thinking of modifying phy_stop()... but I can't
grep out where carrier_off gets called. I'll take a closer look.
