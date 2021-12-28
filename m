Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973B54805C0
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 03:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhL1Cfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 21:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhL1Cfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 21:35:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56CBC06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 18:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC5561165
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 02:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91957C36AEA;
        Tue, 28 Dec 2021 02:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640658942;
        bh=q8nzCZYDl7ghNkaaf1MV36AL6x4tL6y1eda/VKJrtFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cA/dr4ChZzA6+CWgeJUr6s3EcVC6IKXPuHuTywZmWaUmvZ7fbL+nek63ku1qR5ylY
         s2yvcDG48DAYLjfcezXb7fl+5z0Z5V1ONPjmq6ZPcAjJtztgw1R9PJtXZ9S5i03+cL
         glSGlhLdHw6tBV7HD3YDbmSJZSNei3HTm6kRpQx93SCZpCfm7hNKexDFokN9By+Wfo
         uTWD8dktZjKJ2F/SbJwoMYHxA88NayjGbjV5TcTvEzKs9aITBL1UB6uqAlkthyeMBi
         mziiSvB1/0XinVoYaJq5jzvVMq7VoDKhbU4HpRY6ZZ0Uua1gMf2vcmSE9kHKLR3UAK
         vn4MpMi99VODw==
Date:   Mon, 27 Dec 2021 18:35:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] sun4i-emac.c: add dma support
Message-ID: <20211227183541.3a9f2963@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <tencent_95A0609A0DC523F7DDAE60A8746EABAA8905@qq.com>
References: <tencent_95A0609A0DC523F7DDAE60A8746EABAA8905@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 22:44:31 +0800 conleylee@foxmail.com wrote:
> From: Conley Lee <conleylee@foxmail.com>
> 
> This patch adds support for the emac rx dma present on sun4i.
> The emac is able to move packets from rx fifo to RAM by using dma.
> 
> Signed-off-by: Conley Lee <conleylee@foxmail.com>
> ---
>  drivers/net/ethernet/allwinner/sun4i-emac.c | 209 +++++++++++++++++++-
>  1 file changed, 200 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
> index cccf8a3ead5e..b17d2df17335 100644
> --- a/drivers/net/ethernet/allwinner/sun4i-emac.c
> +++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
> @@ -29,6 +29,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/phy.h>
>  #include <linux/soc/sunxi/sunxi_sram.h>
> +#include <linux/dmaengine.h>
>  
>  #include "sun4i-emac.h"
>  
> @@ -86,6 +87,16 @@ struct emac_board_info {
>  	unsigned int		duplex;
>  
>  	phy_interface_t		phy_interface;
> +	struct dma_chan	*rx_chan;
> +	phys_addr_t emac_rx_fifo;
> +};
> +
> +struct emac_dma_req {
> +	struct emac_board_info *db;
> +	struct dma_async_tx_descriptor *desc;
> +	struct sk_buff *sbk;

sbk -> skb ?

> +	dma_addr_t rxbuf;
> +	int count;
>  };
>  
>  static void emac_update_speed(struct net_device *dev)
> @@ -205,6 +216,113 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
>  	readsl(reg, data, round_up(count, 4) / 4);
>  }
>  
> +static struct emac_dma_req *
> +alloc_emac_dma_req(struct emac_board_info *db,

nit: please use "emac" as a prefix of the name, instead of putting it
     inside the name.

> +		   struct dma_async_tx_descriptor *desc, struct sk_buff *skb,
> +		   dma_addr_t rxbuf, int count)
> +{
> +	struct emac_dma_req *req =
> +		kzalloc(sizeof(struct emac_dma_req), GFP_KERNEL);

Please don't put complex initializers inline, also missing an empty
line between variable declaration and code. Should be:

	struct emac_dma_req *req;

	req = kzalloc(...);
	if (!req)
		...

You seem to call this from an IRQ handler, shouldn't the flags be
GFP_ATOMIC? Please test with CONFIG_DEBUG_ATOMIC_SLEEP=y.

> +	if (!req)
> +		return NULL;
> +
> +	req->db = db;
> +	req->desc = desc;
> +	req->sbk = skb;
> +	req->rxbuf = rxbuf;
> +	req->count = count;
> +	return req;
> +}
> +
> +static void free_emac_dma_req(struct emac_dma_req *req)
> +{
> +	kfree(req);
> +}
> +
> +static void emac_dma_done_callback(void *arg)
> +{
> +	struct emac_dma_req *req = arg;
> +	struct emac_board_info *db = req->db;
> +	struct sk_buff *skb = req->sbk;
> +	struct net_device *dev = db->ndev;
> +	int rxlen = req->count;
> +	u32 reg_val;
> +
> +	dma_unmap_single(db->dev, req->rxbuf, rxlen, DMA_FROM_DEVICE);
> +
> +	skb->protocol = eth_type_trans(skb, dev);
> +	netif_rx(skb);
> +	dev->stats.rx_bytes += rxlen;
> +	/* Pass to upper layer */
> +	dev->stats.rx_packets++;
> +
> +	//re enable cpu receive

Please use the /**/ comment style consistently

> +	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> +	reg_val &= ~EMAC_RX_CTL_DMA_EN;
> +	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
> +
> +	//re enable interrupt
> +	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> +	reg_val |= (0x01 << 8);
> +	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> +
> +	db->emacrx_completed_flag = 1;
> +	free_emac_dma_req(req);
> +}
> +
> +static void emac_dma_inblk_32bit(struct emac_board_info *db,
> +				 struct sk_buff *skb, int count)
> +{
> +	struct dma_async_tx_descriptor *desc;
> +	dma_cookie_t cookie;
> +	dma_addr_t rxbuf;
> +	void *rdptr;
> +	struct emac_dma_req *req;
> +
> +	rdptr = skb_put(skb, count - 4);

The skb_put can be factored out from both branches it seems.

> +	rxbuf = dma_map_single(db->dev, rdptr, count, DMA_FROM_DEVICE);
> +
> +	if (dma_mapping_error(db->dev, rxbuf)) {
> +		dev_err(db->dev, "dma mapping error.\n");
> +		return;

You seem to leak the skb if this function fails, no?

> +	}
> +
> +	desc = dmaengine_prep_slave_single(db->rx_chan, rxbuf, count,
> +					   DMA_DEV_TO_MEM,
> +					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!desc) {
> +		dev_err(db->dev, "prepare slave single failed\n");
> +		goto prepare_err;
> +	}
> +
> +	req = alloc_emac_dma_req(db, desc, skb, rxbuf, count);
> +	if (!req) {
> +		dev_err(db->dev, "alloc emac dma req error.\n");
> +		goto alloc_req_err;
> +	}
> +
> +	desc->callback_param = req;
> +	desc->callback = emac_dma_done_callback;
> +
> +	cookie = dmaengine_submit(desc);
> +	if (dma_submit_error(cookie)) {
> +		dev_err(db->dev, "dma submit error.\n");
> +		goto submit_err;
> +	}
> +
> +	dma_async_issue_pending(db->rx_chan);
> +	return;
> +
> +submit_err:
> +	free_emac_dma_req(req);
> +
> +alloc_req_err:
> +	dmaengine_desc_free(desc);
> +
> +prepare_err:
> +	dma_unmap_single(db->dev, rxbuf, count, DMA_FROM_DEVICE);
> +}

> -			/* Pass to upper layer */
> -			skb->protocol = eth_type_trans(skb, dev);
> -			netif_rx(skb);
> -			dev->stats.rx_packets++;
> +			if (rxlen < dev->mtu || !db->rx_chan) {
> +				rdptr = skb_put(skb, rxlen - 4);
> +				emac_inblk_32bit(db->membase + EMAC_RX_IO_DATA_REG,
> +						rdptr, rxlen);
> +				dev->stats.rx_bytes += rxlen;
> +
> +				/* Pass to upper layer */
> +				skb->protocol = eth_type_trans(skb, dev);
> +				netif_rx(skb);
> +				dev->stats.rx_packets++;
> +			} else {
> +				reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> +				reg_val |= EMAC_RX_CTL_DMA_EN;
> +				writel(reg_val, db->membase + EMAC_RX_CTL_REG);
> +				emac_dma_inblk_32bit(db, skb, rxlen);
> +				break;
> +			}
>  		}

> +static int emac_configure_dma(struct emac_board_info *db)
> +{
> +	struct platform_device *pdev = db->pdev;
> +	struct net_device *ndev = db->ndev;
> +	struct dma_slave_config conf = {};
> +	struct resource *regs;
> +	int err = 0;
> +
> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!regs) {
> +		netdev_err(ndev, "get io resource from device failed.\n");
> +		err = -ENOMEM;
> +		goto out_clear_chan;
> +	}
> +
> +	netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
> +		    regs->start, resource_size(regs));
> +	db->emac_rx_fifo = regs->start + EMAC_RX_IO_DATA_REG;
> +
> +	db->rx_chan = dma_request_chan(&pdev->dev, "rx");
> +	if (IS_ERR(db->rx_chan)) {
> +		netdev_err(ndev,
> +			   "failed to request dma channel. dma is disabled");

nit: this message lacks '\n' at the end

> +		err = PTR_ERR(db->rx_chan);
> +		goto out_clear_chan;
> +	}

