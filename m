Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47319368029
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhDVMVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:21:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVMV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:21:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZYK8-000Ujw-Tx; Thu, 22 Apr 2021 14:20:48 +0200
Date:   Thu, 22 Apr 2021 14:20:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 14/14] net: ethernet: mtk_eth_soc: use iopoll.h
 macro for DMA init
Message-ID: <YIFqIJpAJKUrXQVS@lunn.ch>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
 <20210422040914.47788-15-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422040914.47788-15-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:09:14PM -0700, Ilya Lipnitskiy wrote:
> Replace a tight busy-wait loop without a pause with a standard
> readx_poll_timeout_atomic routine with a 5 us poll period.
> 
> Tested by booting a MT7621 device to ensure the driver initializes
> properly.
> 
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 29 +++++++++------------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
>  2 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 8c863322587e..720d73d0c007 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2037,25 +2037,22 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
>  /* wait for DMA to finish whatever it is doing before we start using it again */
>  static int mtk_dma_busy_wait(struct mtk_eth *eth)
>  {
> -	unsigned long t_start = jiffies;
> +	u32 val;
> +	int ret;
> +	unsigned int reg;

Nit:

Reverse christmass tree.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
