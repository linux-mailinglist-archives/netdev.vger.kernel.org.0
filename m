Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5876BDCB5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCPXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCPXK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:10:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A402411B;
        Thu, 16 Mar 2023 16:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2BeCZSdN3o0+g9nGC8N+LpsPqap3J67+DNmxUtN89CI=; b=l7uBeCoiqmfiGlgs5kb3jYWIo+
        nL+f0+87aA+uQV8HUvu5Jr56NZER4f87EapO+uZrOepUl4sgLjh6OQuZHgwkyZe45wHlr5VWjRsJ1
        o0PmRt6gp19W7+i/ESzSg6Iy/lNQswMNacsYc+9USJEq1ldFVrea2rLLkma2N1ukgikGli4+KZrjO
        9XYys6FEpjyYZPCFEX9PMbVKovRAUWJ0sej6TYNvcQ1/sxuyOqw9a/3wbtreeYB/a8raS6wEngWqd
        ejTjMcc0SHXAm47+nYvoVjwmMHpqhDe3xpczgzAsVk9C2vuQEvKEQGaDHccirO90cBuLBUqFqCGwm
        MhW+egqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46154)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pcwjX-0001SC-CT; Thu, 16 Mar 2023 23:10:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pcwjT-0002qB-LM; Thu, 16 Mar 2023 23:10:03 +0000
Date:   Thu, 16 Mar 2023 23:10:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net V2] net: stmmac: Fix for mismatched host/device DMA
 address width
Message-ID: <ZBOhy02DFBlnIQR1@shell.armlinux.org.uk>
References: <20230316095306.721255-1-jh@henneberg-systemdesign.com>
 <20230316131503.738933-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316131503.738933-1-jh@henneberg-systemdesign.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 02:15:03PM +0100, Jochen Henneberg wrote:
> Currently DMA address width is either read from a RO device register
> or force set from the platform data. This breaks DMA when the host DMA
> address width is <=32it but the device is >32bit.
> 
> Right now the driver may decide to use a 2nd DMA descriptor for
> another buffer (happens in case of TSO xmit) assuming that 32bit
> addressing is used due to platform configuration but the device will
> still use both descriptor addresses as one address.
> 
> This can be observed with the Intel EHL platform driver that sets
> 32bit for addr64 but the MAC reports 40bit. The TX queue gets stuck in
> case of TCP with iptables NAT configuration on TSO packets.
> 
> The logic should be like this: Whatever we do on the host side (memory
> allocation GFP flags) should happen with the host DMA width, whenever
> we decide how to set addresses on the device registers we must use the
> device DMA address width.
> 
> This patch renames the platform address width field from addr64 (term
> used in device datasheet) to host_addr and uses this value exclusively
> for host side operations while all chip operations consider the device
> DMA width as read from the device register.
> 
> Fixes: 7cfc4486e7ea ("stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing")
> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
> ---
> V2: Fixes from checkpatch.pl for commit message
> 
>  drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  2 +-
>  .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  4 +--
>  .../ethernet/stmicro/stmmac/dwmac-mediatek.c  |  2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 30 ++++++++++---------
>  include/linux/stmmac.h                        |  2 +-
>  6 files changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
> index 6b5d96bced47..55a728b1b708 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/common.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/common.h
> @@ -418,6 +418,7 @@ struct dma_features {
>  	unsigned int frpbs;
>  	unsigned int frpes;
>  	unsigned int addr64;
> +	unsigned int host_addr;

Obvious question: is host_addr an address? From the above description it
sounds like this is more of a host address width indicator.

Maybe call these "dev_addr_width" and "host_addr_width" so it's clear
what each of these are?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
