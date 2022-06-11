Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93205470D2
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 03:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbiFKBDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 21:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiFKBC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 21:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E352BC4EA
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 18:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6F2C61F13
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 01:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBA7C34114;
        Sat, 11 Jun 2022 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654909377;
        bh=QWvlHuKyajRCodKriIMCTihqrc8YD1wE6F53Qw49E/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l8sMIvj6D1VDx6X+2geFbjEaHYcPIAWXEDZUu5HypytT9xrcQUgHiY4LwPYbGDlIe
         sNVD4sFSa5zlPrwUdQ5JAjOStLUphi0xNDxcNOHcnijmB8EIY3djwjrDagp9ft26cX
         j7Cme8MUmR01DAIRaNj0jHFW8GhraNIkEgSYZy+xxEiMCNHkk7bJJ52RhatU4Zr6Cu
         gjVqcOmO5CpPO/IFCZDfMI6zay6KlmRGpk00ibgNiBTSbCFxHKkPnl5CS5rGP97HPQ
         v9WcizR44cZEQ/FElqlMxn14ieS2JC551esvOE8GWOz9fdH+mPgg7WlBkRZ/iT7ILa
         iperZFb/Gi1XQ==
Date:   Fri, 10 Jun 2022 18:02:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220610180255.68586bd1@kernel.org>
In-Reply-To: <20220608204451.3124320-3-jonathan.lemon@gmail.com>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
        <20220608204451.3124320-3-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jun 2022 13:44:50 -0700 Jonathan Lemon wrote:
> +config BCM_NET_PHYPTP
> +	tristate "Broadcom PHY PTP support"
> +	depends on NETWORK_PHY_TIMESTAMPING
> +	depends on PHYLIB
> +	depends on PTP_1588_CLOCK
> +	depends on BROADCOM_PHY
> +	depends on NET_PTP_CLASSIFY
> +	help
> +	  Supports PTP timestamping for certain Broadcom PHYs.

This will not prevent:

CONFIG_BCM_NET_PHYLIB=y
CONFIG_BCM_NET_PHYPTP=m

which fails to link:

ld: vmlinux.o: in function `bcm54xx_phy_probe':
broadcom.c:(.text+0x155dd6a): undefined reference to `bcm_ptp_probe'
ld: vmlinux.o: in function `bcm54xx_suspend':
broadcom.c:(.text+0x155e203): undefined reference to `bcm_ptp_stop'
ld: vmlinux.o: in function `bcm54xx_config_init':
broadcom.c:(.text+0x155e8a6): undefined reference to `bcm_ptp_config_init'

Can we always build PTP support in when NETWORK_PHY_TIMESTAMPING is
selected? Without adding an extra Kconfig, do:
 
+ifeq ($(CONFIG_NETWORK_PHY_TIMESTAMPING),)
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
+else
+obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o bcm-phy-ptp.o
+endif

or some form thereof ?
