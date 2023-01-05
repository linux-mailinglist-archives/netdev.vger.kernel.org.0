Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0C465E756
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjAEJHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjAEJGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:06:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEC64C736;
        Thu,  5 Jan 2023 01:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1426ECE19D2;
        Thu,  5 Jan 2023 09:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62384C433D2;
        Thu,  5 Jan 2023 09:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672909553;
        bh=baAOE4+yFIq/j4hki6KWlqPxYaH8DEklh/gqmV8KbDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uZ1klsaOLspBGhpGKcGUSpYyQKubmDeDTy59c8ONzNovpy3uEQHDlX8NdbOCfGWsg
         ezccQsk154UD2NLG/KiF1IY6Bb3y7gAe7XW877Gw6TjR2W0o0XID64kM0CwqGDaNe0
         BWVzrEiZw6uPSboewO3nbt+dAoWk6Nx4MjWaCMckXVL/Oenv1e3bxy0SDxkNyNml30
         QM/ffFR67IWIXGS6t4eqVnKEDsy0/XsORMkAYNn0C7n54oJqTLMyon74aJpAkQEazD
         VLN6DJ6ZlFWorloo4vHSvl4ZgRLgVnSwiDFfcjAxEJJiBSJJ/uvmhajLif5/nE/CXm
         PTQEHvfsOvfAA==
Date:   Thu, 5 Jan 2023 11:05:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y7aS7GrjFDauGm9u@unreal>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <d6ffe9c0296bc10c51068d3efaadd48e05561208.1672840326.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6ffe9c0296bc10c51068d3efaadd48e05561208.1672840326.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:07:05PM +0100, Piergiorgio Beruto wrote:
> This patch adds support for the onsemi NCN26000 10BASE-T1S industrial
> Ethernet PHY. The driver supports Point-to-Multipoint operation without
> auto-negotiation and with link control handling. The PHY also features
> PLCA for improving performance in P2MP mode.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  MAINTAINERS                |   7 ++
>  drivers/net/phy/Kconfig    |   7 ++
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/ncn26000.c | 171 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 186 insertions(+)
>  create mode 100644 drivers/net/phy/ncn26000.c

<...>

> +static int ncn26000_config_aneg(struct phy_device *phydev)
> +{
> +	// Note: the NCN26000 supports only P2MP link mode. Therefore, AN is not
> +	// supported. However, this function is invoked by phylib to enable the
> +	// PHY, regardless of the AN support.

Please use C-style comments for multi lines blocks.

> +	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +	phydev->mdix = ETH_TP_MDI;
> +
> +	// bring up the link

Thanks
