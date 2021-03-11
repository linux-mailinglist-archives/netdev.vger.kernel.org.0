Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193F3337AF0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhCKRfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:35:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229705AbhCKRfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 12:35:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKPDB-00AOKn-6Q; Thu, 11 Mar 2021 18:35:01 +0100
Date:   Thu, 11 Mar 2021 18:35:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: mt7530: use core_write wrapper
Message-ID: <YEpUxS055rIVJ6VH@lunn.ch>
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
 <20210310211420.649985-2-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310211420.649985-2-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:14:19PM -0800, Ilya Lipnitskiy wrote:
> When disabling PLL, there is no need to call core_write_mmd_indirect
> directly, use the core_write wrapper instead like the rest of the code
> in the function does. This change helps with consistency and
> readability.
> 
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e785f80f966b..b106ea816778 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -445,10 +445,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>  		 * provide our own core_write_mmd_indirect to complete this
>  		 * function.
>  		 */
> -		core_write_mmd_indirect(priv,
> -					CORE_GSWPLL_GRP1,
> -					MDIO_MMD_VEND2,
> -					0);
> +		core_write(priv, CORE_GSWPLL_GRP1, 0);

		/* Disable PLL, since phy_device has not yet been created
		 * provided for phy_[read,write]_mmd_indirect is called, we
		 * provide our own core_write_mmd_indirect to complete this
		 * function.
		 */
		core_write_mmd_indirect(priv,
					CORE_GSWPLL_GRP1,
					MDIO_MMD_VEND2,
					0);

What about the comment? Seems odd to reference
core_write_mmd_indirect() when it is not actually called here after
your change.

     Andrew
