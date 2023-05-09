Return-Path: <netdev+bounces-1238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D30D6FCD22
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 710D91C2091F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FF3182D8;
	Tue,  9 May 2023 18:00:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55BF9C9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:00:41 +0000 (UTC)
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC96140F4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:00:38 -0700 (PDT)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 98FA5206F1;
	Tue,  9 May 2023 20:00:35 +0200 (CEST)
Date: Tue, 9 May 2023 20:00:31 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Marek Vasut <marex@denx.de>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Eric Dumazet <edumazet@google.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Harald Seiler <hws@denx.de>, Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <joabreu@synopsys.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH] net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
Message-ID: <ZFqKPyCvFA7BD3y7@francesco-nb.int.toradex.com>
References: <20230506235845.246105-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506235845.246105-1-marex@denx.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 07, 2023 at 01:58:45AM +0200, Marek Vasut wrote:
> Initialize MAC_ONEUS_TIC_COUNTER register with correct value derived
> from CSR clock, otherwise EEE is unstable on at least NXP i.MX8M Plus
> and Micrel KSZ9131RNX PHY, to the point where not even ARP request can
> be sent out.
> 
> i.MX 8M Plus Applications Processor Reference Manual, Rev. 1, 06/2021
> 11.7.6.1.34 One-microsecond Reference Timer (MAC_ONEUS_TIC_COUNTER)
> defines this register as:
> "
> This register controls the generation of the Reference time (1 microsecond
> tic) for all the LPI timers. This timer has to be programmed by the software
> initially.
> ...
> The application must program this counter so that the number of clock cycles
> of CSR clock is 1us. (Subtract 1 from the value before programming).
> For example if the CSR clock is 100MHz then this field needs to be programmed
> to value 100 - 1 = 99 (which is 0x63).
> This is required to generate the 1US events that are used to update some of
> the EEE related counters.
> "
> 
> The reset value is 0x63 on i.MX8M Plus, which means expected CSR clock are
> 100 MHz. However, the i.MX8M Plus "enet_qos_root_clk" are 266 MHz instead,
> which means the LPI timers reach their count much sooner on this platform.
> 
> This is visible using a scope by monitoring e.g. exit from LPI mode on TX_CTL
> line from MAC to PHY. This should take 30us per STMMAC_DEFAULT_TWT_LS setting,
> during which the TX_CTL line transitions from tristate to low, and 30 us later
> from low to high. On i.MX8M Plus, this transition takes 11 us, which matches
> the 30us * 100/266 formula for misconfigured MAC_ONEUS_TIC_COUNTER register.
> 
> Configure MAC_ONEUS_TIC_COUNTER based on CSR clock, so that the LPI timers
> have correct 1us reference. This then fixes EEE on i.MX8M Plus with Micrel
> KSZ9131RNX PHY.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Verdin iMX8MP

I think this commit should have a fixes tag, what about

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")

> NOTE: I suspect this can help with Toradex ELB-3757, Marcel, can you please
>       test this patch on i.MX8M Plus Verdin ?
>       https://developer-archives.toradex.com/software/linux/release-details?module=Verdin+iMX8M+Plus&key=ELB-3757
I think you are right, your patch clearly makes a difference here.

Francesco


