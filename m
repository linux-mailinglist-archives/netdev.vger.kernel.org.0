Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51F44F8580
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243266AbiDGRHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiDGRHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:07:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8722F427E2
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 10:05:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6C861445
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 17:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC39C385A4;
        Thu,  7 Apr 2022 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649351100;
        bh=9x2Qwn+KkffT2/fOlTButrqCW7RRJ5eciMtLxJT3BqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XTe96NSOFw+23bPXWcZgZJBQZsdUP0UIhG/kirTAzsDCmRdE542MiRKNRdsY2KSci
         xE2oNxnCOx5BEbnoAYytQX26LWKMybXwpPfISv7KJOwyxZX+MIbuP3wNcyB8A7p0yR
         tpd1bJgSzQKntREhZHdtnZMQfS7tJdnaV3aUibPg=
Date:   Thu, 7 Apr 2022 19:04:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Message-ID: <Yk8ZuSlhPJtAD9qi@kroah.com>
References: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407165538.4084809-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 07:55:38PM +0300, Vladimir Oltean wrote:
> When a driver for an interrupt controller is missing, of_irq_get()
> returns -EPROBE_DEFER ad infinitum, causing
> fwnode_mdiobus_phy_device_register(), and ultimately, the entire
> of_mdiobus_register() call, to fail. In turn, any phy_connect() call
> towards a PHY on this MDIO bus will also fail.
> 
> This is not what is expected to happen, because the PHY library falls
> back to poll mode when of_irq_get() returns a hard error code, and the
> MDIO bus, PHY and attached Ethernet controller work fine, albeit
> suboptimally, when the PHY library polls for link status. However,
> -EPROBE_DEFER has special handling given the assumption that at some
> point probe deferral will stop, and the driver for the supplier will
> kick in and create the IRQ domain.
> 
> Reasons for which the interrupt controller may be missing:
> 
> - It is not yet written. This may happen if a more recent DT blob (with
>   an interrupt-parent for the PHY) is used to boot an old kernel where
>   the driver didn't exist, and that kernel worked with the
>   vintage-correct DT blob using poll mode.
> 
> - It is compiled out. Behavior is the same as above.
> 
> - It is compiled as a module. The kernel will wait for a number of
>   seconds specified in the "deferred_probe_timeout" boot parameter for
>   user space to load the required module. The current default is 0,
>   which times out at the end of initcalls. It is possible that this
>   might cause regressions unless users adjust this boot parameter.
> 
> The proposed solution is to use the driver_deferred_probe_check_state()
> helper function provided by the driver core, which gives up after some
> -EPROBE_DEFER attempts, taking "deferred_probe_timeout" into consideration.
> The return code is changed from -EPROBE_DEFER into -ENODEV or
> -ETIMEDOUT, depending on whether the kernel is compiled with support for
> modules or not.
> 
> Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
> Suggested-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: export driver_deferred_probe_check_state, add driver core
>         maintainers

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

