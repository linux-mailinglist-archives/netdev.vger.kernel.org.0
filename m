Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83913554F6C
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357141AbiFVPfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358743AbiFVPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AAA39B80
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A89E61722
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D621C34114;
        Wed, 22 Jun 2022 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655912122;
        bh=/jOi7KiGZDwEtWF9FKeJU9P05qm3tRmk8/rkxemnIiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mq8l+rg+Hk/7AtGOchN9cbmzafpcz+pS8trNnz6AbRUis52lnkO/qdX9S89f9C7lM
         T5J1bGCc+jdlV+1EkhgFFBPiQH3aHlF/O8coWmFHXRH5kW525gTc1DoOfcCzuQOMM3
         GQmB92UV/Vt2Sv+TOb6iELnNkjVvJgLNPc6Gfz0PiQ3c1MQhWYRgbgoFVaktqTTAs5
         dApZ8Gy/0EWhIlOQPBtJfAA32wpgbq5mxEhu9egD6zsS1lHc0kLv7i7FEYf8djyLFF
         76d7eI+3uUpxYniBluOCw9P9E56Mpnwr9XUPkoehUsk7DhRqYj/if0GoeBTIRurcVh
         2t766MJMuOs8Q==
Date:   Wed, 22 Jun 2022 08:35:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
Message-ID: <20220622083521.0de3ea5c@kernel.org>
In-Reply-To: <YrMkEp6EWDvd3GT/@shell.armlinux.org.uk>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
        <20220621125045.7e0a78c2@kernel.org>
        <YrMkEp6EWDvd3GT/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 15:15:46 +0100 Russell King (Oracle) wrote:
> > We can't use depends with PHYLINK, AFAIU, because PHYLINK is not 
> > a user-visible knob. Its always "select"ed and does not show up
> > in {x,n,menu}config.  
> 
> I'm not sure I understand the point you're making. You seem to be
> saying we can't use "depend on PHYLINK" for this PCS driver, but
> then you sent a patch doing exactly that.

Nuh uh, I sent a patch which does _select_ PHYLINK.

My concern is that since PHYLINK is not visible user will not be able
to see PCS_XPCS unless something else already enabled PHYLINK.

I may well be missing some higher level relations here, on the surface
"depending" on a symbol which is not user-visible seems.. unusual.

> As these PCS drivers are only usable if PHYLINK is already enabled,
> there is a clear dependency between them and phylink. The drivers
> that make use of xpcs are:
> 
> stmmac, which selects both PCS_XPCS and PHYLINK.
> sja1105 (dsa driver), which selects PCS_XPCS. All DSA drivers depend
> on NET_DSA, and NET_DSA selects PHYLINK.
> 
> So, for PCS_XPCS, PHYLINK will be enabled whenever PCS_XPCS is
> selected. No other drivers in drivers/net appear to make use of
> the XPCS driver (I couldn't find any other references to
> xpcs_create()) so using "depends on PHYLINK" for it should be safe.
> 
> Moreover, the user-visible nature of PCS_XPCS doesn't add anything
> to the kernel - two drivers require PCS_XPCS due to code references
> to the xpcs code, these two select that symbol. Offering it to the
> user just gives the user an extra knob to twiddle with no useful
> result (other than more files to be built.)
> 
> It could be argued that it helps compile coverage, which I think is
> the only reason to make PCS_XPCS visible... but then we get compile
> coverage when stmmac or sja1105 are enabled.

Interesting, hiding PCS_XPCS sounds good then. PCS_LYNX is not visible.

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..9eb32220efea 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -6,7 +6,7 @@
 menu "PCS device drivers"
 
 config PCS_XPCS
-	tristate "Synopsys DesignWare XPCS controller"
+	tristate
 	depends on MDIO_DEVICE && MDIO_BUS
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
