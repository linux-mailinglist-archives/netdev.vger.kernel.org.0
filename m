Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEEF4AC7C6
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiBGRlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384425AbiBGRkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50738C0401DA;
        Mon,  7 Feb 2022 09:40:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1436BB80D3C;
        Mon,  7 Feb 2022 17:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0A5C004E1;
        Mon,  7 Feb 2022 17:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644255640;
        bh=KAxjunFgwNR4WL2HyqkAIrFtJZKYBhaVQTI5UOHggI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SVU0U0Cn5X/zuO3OIIqYJ5g/syZyxnLrppTn7AQS/m7z6ZQwAcn2wsX0AULnIecQ3
         hXVIOyTLToDEzF8cUaXm3R+NJIpOiZTjQMggQZtvV9r4RHe6FjCrSQxLiNvWIOoqiz
         xJu5uqm7yRNDmVgkB9Q0TO9yDyhmas8vSsvF8LNTYawNczqndq0UMl+Oz1LSVnnecT
         KefJSYw3dk7jlKh02vsqHwvw3yTQBaqkPrpTE0Yv0ivGkDXdNsD0drRZVkx3kgCMEx
         2PcTkQTOxVUiJMO3XVbecwvqPj1xzTahKnpsHeQzlSFn44ZfxZH317SOORUH3WUD32
         ptefOa1OmuNMQ==
Date:   Mon, 7 Feb 2022 09:40:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        <stable@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays
 setting in 88e1121-compatible PHYs
Message-ID: <20220207094039.6a2b34df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
        <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Feb 2022 23:39:32 +0300 Pavel Parkhomenko wrote:
> It is mandatory for a software to issue a reset upon modifying RGMII
> Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> Specific Control register 2 (page 2, register 21) otherwise the changes
> won't be perceived by the PHY (the same is applicable for a lot of other
> registers). Not setting the RGMII delays on the platforms that imply it'
> being done on the PHY side will consequently cause the traffic loss. We
> discovered that the denoted soft-reset is missing in the
> m88e1121_config_aneg() method for the case if the RGMII delays are
> modified but the MDIx polarity isn't changed or the auto-negotiation is
> left enabled, thus causing the traffic loss on our platform with Marvell
> Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> method.
> 
> Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
> Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
> Cc: stable@vger.kernel.org
> 
> ---
> 
> Link: https://lore.kernel.org/netdev/96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru/
> Changelog v2:
> - Add "net" suffix into the PATCH-clause of the subject.
> - Cc the patch to the stable tree list.
> - Rebase onto the latset netdev/net branch with the top commit 59085208e4a2
> ("net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP")

This patch is valid and waiting to be reviewed & applied, right?
I see it's marked as Superseded in patchwork, but can't track down a v3.
