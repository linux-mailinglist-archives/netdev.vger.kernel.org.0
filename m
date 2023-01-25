Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E0C67A8C5
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjAYCbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjAYCbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EB0E389
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A83956142A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E264FC433EF;
        Wed, 25 Jan 2023 02:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674613863;
        bh=5Wz9tTvwf2zBG4V/9ey62qsW+AajmFARDoshqYObUbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d/2x9N0cNCkzQTC3pS/tXu92fmJ41VMpGDe4QhHAyYPd2rRvDbsuu7x0c5yWzrisY
         +ns8QsF2v9olWHwwiHbZTK9bDjMIqfnE4vK/NoRVEtyjaHgXvTZ/5+OXaTdNNSUbFj
         K6RzYNat3dBdZ0kCG2cQzJg+Dls5GHkD8EcFamHxJY7mrgVb1ENfX3386g+piOVe03
         2UbQhBtx0pajnlftOf7bL4xv7s4YLkb5+bEfQYLHSUe6ed/Gc9C4+Zybjy6drM6XM0
         xIPSLkW5Jg4fMcnrLv60fdEZHedeZ24+im1aVa2rnpVgG6KDDGST3e10LziH20uR0/
         Pb2QCYDTbUCrA==
Date:   Tue, 24 Jan 2023 18:31:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net/ps3_gelic_net: Fix RX skbuff length
Message-ID: <20230124183102.44d015c3@kernel.org>
In-Reply-To: <c9a523347acc2d399b667472e158b5fdfbadc941.1674436603.git.geoff@infradead.org>
References: <cover.1674436603.git.geoff@infradead.org>
        <c9a523347acc2d399b667472e158b5fdfbadc941.1674436603.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patches didn't make it to patchwork or the lore archive.
Keep an eye for any irregularities when reposting.

On Mon, 23 Jan 2023 01:24:25 +0000 Geoff Levand wrote:
> The Gelic Etherenet device needs to have the RX skbuffs aligned to 128 bytes.
> The current Gelic Etherenet driver was not allocating skbuffs large enough to
> allow for this alignment.
> 
> This change adds a new local structure named aligned_buff to help calculate a
> buffer size large enough to allow for this alignment.
> 
> Fixes various randomly occurring runtime network errors.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

Please add a Fixes tag.

> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index cf8de8a7a8a1..43e438f8f595 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -366,50 +366,67 @@ static int gelic_card_init_chain(struct gelic_card *card,
>   * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
>   * Activate the descriptor state-wise
>   */
> +

Why this new line?

>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> -	int offset;
> -	unsigned int bufsize;
> +	struct device *dev = ctodev(card);
> +	struct aligned_buff {
> +		unsigned int total_bytes;
> +		unsigned int offset;
> +	};
> +	struct aligned_buff a_buf;

You can declare this as a anonymous struct:

	struct {
		unsigned int total_bytes;
		unsigned int offset;
	} a_buf;

> +	dma_addr_t cpu_addr;
> +
> +	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE) {
> +		dev_err(dev, "%s:%d: ERROR status\n", __func__, __LINE__);
> +	}

The fixes should be minimal, please don't change prints or reformat 
the code unless it makes it a lot easier to understand.

> +	a_buf.total_bytes = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN)
> +		+ GELIC_NET_RXBUF_ALIGN;
>  
> -	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
> -		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> +	descr->skb = dev_alloc_skb(a_buf.total_bytes);
>  
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);

So what did you change? This is hard to read.
Allocating ALIGN - 1 more space should be enough to align the pointer.

>  	if (!descr->skb) {
> -		descr->buf_addr = 0; /* tell DMAC don't touch memory */
> +		descr->buf_addr = 0;
>  		return -ENOMEM;
>  	}
> -	descr->buf_size = cpu_to_be32(bufsize);
> +
> +	a_buf.offset = PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN)
> +		- descr->skb->data;
> +
> +	if (a_buf.offset) {
> +		dev_dbg(dev, "%s:%d: offset=%u\n", __func__, __LINE__,
> +			a_buf.offset);
> +		skb_reserve(descr->skb, a_buf.offset);
> +	}
> +
> +	descr->buf_size = a_buf.total_bytes - a_buf.offset;
>  	descr->dmac_cmd_status = 0;
>  	descr->result_size = 0;
>  	descr->valid_size = 0;
>  	descr->data_error = 0;
>  
> -	offset = ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> -	/* io-mmu-map the skb */
> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
> -	if (!descr->buf_addr) {
> +	cpu_addr = dma_map_single(dev, descr->skb->data,
> +		descr->buf_size, DMA_FROM_DEVICE);
> +	descr->buf_addr = cpu_to_be32(cpu_addr);
> +
> +	if (unlikely(dma_mapping_error(dev, cpu_addr))) {

adding dma mapping error handling should be a separate fix

> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
> +
> +		descr->buf_addr = 0;
> +		descr->buf_size = 0;
> +
>  		dev_kfree_skb_any(descr->skb);
>  		descr->skb = NULL;
> -		dev_info(ctodev(card),
> -			 "%s:Could not iommu-map rx buffer\n", __func__);
> +
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> +
>  		return -ENOMEM;
> -	} else {
> -		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> -		return 0;
>  	}
> +
> +	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> +	return 0;
>  }
>  
>  /**

