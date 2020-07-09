Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D2021A110
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGINlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:41:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgGINlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 09:41:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtWnb-004L5F-7c; Thu, 09 Jul 2020 15:41:15 +0200
Date:   Thu, 9 Jul 2020 15:41:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200709134115.GK928075@lunn.ch>
References: <20200709055742.3425-1-frank-w@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200709055742.3425-1-frank-w@public-files.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 07:57:42AM +0200, Frank Wunderlich wrote:
> From: René van Dorst <opensource@vdorst.com>
> 
> in recent Kernel-Versions there are warnings about incorrect MTU-Size
> like these:
> 
> mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port x
> eth0: mtu greater than device maximum
> mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the MTU")
> Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> changes in v2:
>   Fixes: tag show 12-chars of sha1 and moved above other tags
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 85735d32ecb0..00e3d70f7d07 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2891,6 +2891,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  	eth->netdev[id]->irq = eth->irq[0];
>  	eth->netdev[id]->dev.of_node = np;
> 
> +	eth->netdev[id]->mtu = 1536;

Hi Frank

Don't change to MTU from the default. Anybody using this interface for
non-DSA traffic expects the default MTU. DSA will change it as needed.

> +	eth->netdev[id]->min_mtu = ETH_MIN_MTU;

No need to set the minimum. ether_setup() will initialize it.

> +	eth->netdev[id]->max_mtu = 1536;

I assume this is enough to make the DSA warning go away, but it is the
true max? I have a similar patch for the FEC driver which i should
post sometime. Reviewing the FEC code and after some testing, i found
the real max was 2K - 64.

     Andrew
