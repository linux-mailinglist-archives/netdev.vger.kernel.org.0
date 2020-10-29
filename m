Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD8429EC5C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgJ2NCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:02:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgJ2NCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 09:02:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY7Yp-0049ta-U1; Thu, 29 Oct 2020 14:01:47 +0100
Date:   Thu, 29 Oct 2020 14:01:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next] net: ethernet: mediatek: support setting MTU
Message-ID: <20201029130147.GL933237@lunn.ch>
References: <20201029063915.4287-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029063915.4287-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 02:39:15PM +0800, DENG Qingfang wrote:
> MT762x HW supports frame length up to 2048 (maximum length on GDM),
> so allow setting MTU up to 2030.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> 
> I only tested this on MT7621, no sure if it is applicable for other SoCs
> especially MT7628, which has an old IP.
> 
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 31 ++++++++++++++++++++-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 ++++++--
>  2 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 6d2d60675ffd..a0c56d9be1d5 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -353,7 +353,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
>  	/* Setup gmac */
>  	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>  	mcr_new = mcr_cur;
> -	mcr_new |= MAC_MCR_MAX_RX_1536 | MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
> +	mcr_new |= MAC_MCR_IPG_CFG | MAC_MCR_FORCE_MODE |
>  		   MAC_MCR_BACKOFF_EN | MAC_MCR_BACKPR_EN | MAC_MCR_FORCE_LINK;

Since you no longer set MAC_MCR_MAX_RX_1536, what does the hardware
default to?

>  	/* Only update control register when needed! */
> @@ -2499,6 +2499,34 @@ static void mtk_uninit(struct net_device *dev)
>  	mtk_rx_irq_disable(eth, ~0);
>  }
>  
> +static int mtk_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	struct mtk_mac *mac = netdev_priv(dev);
> +	u32 mcr_cur, mcr_new;
> +	int length;
> +
> +	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
> +	mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_LEN_MASK;
> +	length = new_mtu + MTK_RX_ETH_HLEN;
> +
> +	if (length <= 1518)
> +		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1518);
> +	else if (length <= 1536)
> +		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1536);
> +	else if (length <= 1552)
> +		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_1552);
> +	else
> +		mcr_new |= MAC_MCR_MAX_RX_LEN(MAC_MCR_MAX_RX_LEN_2048);

You should have another if here, and return -EIVAL is the user asked
for an MTU of 2049 of greater.

    Andrew
