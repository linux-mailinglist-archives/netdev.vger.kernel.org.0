Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7B5F5F7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfGDJsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbfGDJsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 05:48:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3064A859FB;
        Thu,  4 Jul 2019 09:48:17 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3643E1001DC8;
        Thu,  4 Jul 2019 09:48:05 +0000 (UTC)
Date:   Thu, 4 Jul 2019 11:48:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     brouer@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190704114804.10c38b42@carbon>
In-Reply-To: <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
        <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 04 Jul 2019 09:48:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jul 2019 12:37:50 +0200
Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1197,26 +1197,14 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
>  				  int i, gfp_t flags, u32 queue)
>  {
>  	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
> -	struct sk_buff *skb;
> +	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
>  
> -	skb = __netdev_alloc_skb_ip_align(priv->dev, priv->dma_buf_sz, flags);
> -	if (!skb) {
> -		netdev_err(priv->dev,
> -			   "%s: Rx init fails; skb is NULL\n", __func__);
> +	buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
> +	if (!buf->page)
>  		return -ENOMEM;
> -	}
> -	rx_q->rx_skbuff[i] = skb;
> -	rx_q->rx_skbuff_dma[i] = dma_map_single(priv->device, skb->data,
> -						priv->dma_buf_sz,
> -						DMA_FROM_DEVICE);
> -	if (dma_mapping_error(priv->device, rx_q->rx_skbuff_dma[i])) {
> -		netdev_err(priv->dev, "%s: DMA mapping error\n", __func__);
> -		dev_kfree_skb_any(skb);
> -		return -EINVAL;
> -	}
> -
> -	stmmac_set_desc_addr(priv, p, rx_q->rx_skbuff_dma[i]);
>  
> +	buf->addr = buf->page->dma_addr;

We/Ilias added a wrapper/helper function for accessing dma_addr, as it
will help us later identifying users.

 page_pool_get_dma_addr(page)

> +	stmmac_set_desc_addr(priv, p, buf->addr);
>  	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
>  		stmmac_init_desc3(priv, p);
>  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
