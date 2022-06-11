Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089E75477B4
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 23:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiFKVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 17:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFKVeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 17:34:01 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B89C68F91
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 14:33:59 -0700 (PDT)
Received: (qmail 49413 invoked by uid 89); 11 Jun 2022 21:33:56 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 11 Jun 2022 21:33:56 -0000
Date:   Sat, 11 Jun 2022 14:33:55 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <20220611213355.q4gtcglc5j3kmdek@bsd-mbp.dhcp.thefacebook.com>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-3-jonathan.lemon@gmail.com>
 <20220610180255.68586bd1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610180255.68586bd1@kernel.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 06:02:55PM -0700, Jakub Kicinski wrote:
> On Wed,  8 Jun 2022 13:44:50 -0700 Jonathan Lemon wrote:
> > +config BCM_NET_PHYPTP
> > +	tristate "Broadcom PHY PTP support"
> > +	depends on NETWORK_PHY_TIMESTAMPING
> > +	depends on PHYLIB
> > +	depends on PTP_1588_CLOCK
> > +	depends on BROADCOM_PHY
> > +	depends on NET_PTP_CLASSIFY
> > +	help
> > +	  Supports PTP timestamping for certain Broadcom PHYs.
> 
> This will not prevent:
> 
> CONFIG_BCM_NET_PHYLIB=y
> CONFIG_BCM_NET_PHYPTP=m
> 
> which fails to link:
> 
> ld: vmlinux.o: in function `bcm54xx_phy_probe':
> broadcom.c:(.text+0x155dd6a): undefined reference to `bcm_ptp_probe'
> ld: vmlinux.o: in function `bcm54xx_suspend':
> broadcom.c:(.text+0x155e203): undefined reference to `bcm_ptp_stop'
> ld: vmlinux.o: in function `bcm54xx_config_init':
> broadcom.c:(.text+0x155e8a6): undefined reference to `bcm_ptp_config_init'
> 
> Can we always build PTP support in when NETWORK_PHY_TIMESTAMPING is
> selected? Without adding an extra Kconfig, do:
>  
> +ifeq ($(CONFIG_NETWORK_PHY_TIMESTAMPING),)
>  obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
> +else
> +obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o bcm-phy-ptp.o
> +endif
> 
> or some form thereof ?

How about this?  Seems to work for my testing.  If this is ok, I'll
spin up (hopefully the last) patch on Monday.


diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9fee639ee5c8..2f299ef26a27 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -104,6 +104,7 @@ config AX88796B_PHY
 config BROADCOM_PHY
 	tristate "Broadcom 54XX PHYs"
 	select BCM_NET_PHYLIB
+	select BCM_NET_PHYPTP if NETWORK_PHY_TIMESTAMPING
 	help
 	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
 	  BCM5481, BCM54810 and BCM5482 PHYs.
@@ -160,6 +161,10 @@ config BCM_CYGNUS_PHY
 config BCM_NET_PHYLIB
 	tristate
 
+config BCM_NET_PHYPTP
+	tristate
+	depends on PTP_1588_CLOCK_OPTIONAL
+
 config CICADA_PHY
 	tristate "Cicada PHYs"
 	help
