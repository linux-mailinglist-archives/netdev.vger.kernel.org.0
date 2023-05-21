Return-Path: <netdev+bounces-4114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC6270AEFD
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 18:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A89CE280EC1
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 16:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C0B63C3;
	Sun, 21 May 2023 16:16:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5AF63AB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 16:16:55 +0000 (UTC)
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FADCD;
	Sun, 21 May 2023 09:16:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id D39152066D;
	Sun, 21 May 2023 18:16:52 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OEh0cj1Q3MH7; Sun, 21 May 2023 18:16:52 +0200 (CEST)
Received: from nucnuc.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 1CD402041E;
	Sun, 21 May 2023 18:16:52 +0200 (CEST)
Date: Sun, 21 May 2023 18:16:50 +0200
From: David Epping <david.epping@missinglinkelectronics.com>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <20230521161650.GC2208@nucnuc.mle>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521134356.ar3itavhdypnvasc@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 04:43:56PM +0300, Vladimir Oltean wrote:
> Not only bit 11 is reserved for VSC8530, but it's also read-only, so it
> should not matter what is written there.

I agree and am ok with removing the PHY ID condition.

> Since vsc85xx_rgmii_enable_rx_clk() and vsc85xx_rgmii_set_skews() write
> to the same register, would it not make sense to combine the two into a
> single phy_modify_paged() call, and to zeroize bit 11 as part of that?

Since we found an explanation why the current driver works in some
setups (U-Boot), I would go with the Microchip support statement, that
writing bit 11 to 0 is required in all modes.
It would thus stay a separate function, called without a phy mode
condition, and not be combined with the RGMII skew setting function.

> The other caller of vsc85xx_rgmii_set_skews(), VSC8572, unfortunately
> does not document bit 11 at all - it doesn't say if it's read-only or not.
> We could conditionally include the VSC8502_RGMII_RX_CLK_DISABLE bit in the
> "mask" argument of phy_modify_paged() based on rgmii_cntl == VSC8502_RGMII_CNTL,
> such as to exclude VSC8572.

Because of the above, I would still call from vsc85xx_default_config(),
so not for the PHYs where bit 11 is not documented.

> What do you think?

If you agree to the above, should the function be named
vsc85xx_enable_rx_clk() or rather vsc8502_enable_rx_clk()?
It is called for more than just VSC8502, but not for all of the PHYs
the driver supports.
The same is true for the existing vsc85xx_default_config(), however.
I don't have a real preference.

