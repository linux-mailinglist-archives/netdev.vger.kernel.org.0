Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B304E38AD
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiCVGDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiCVGCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:02:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9831027;
        Mon, 21 Mar 2022 23:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E007F613FB;
        Tue, 22 Mar 2022 06:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A40C340EC;
        Tue, 22 Mar 2022 06:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647928885;
        bh=IbCALyMlWWD8W/zLhk4Uo0JEiK1YwcDWLeBZE7QMjkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pyDNoI8jiilGA10HJWMydQ+z42A3w8ooNf2DRawiTA4D1rctHyWBnnxhMY4uYoMJo
         s9aHCeLd/2F43OkVo1MnPS6xrrnDkHpNM8cVUcWdnxBU2DFrWYKGMo8K5PPvPzjse3
         ecKjBivt8x9hfer4eLcEehunDIfZj81rebDoSVAE5HpQ6oxo7UR6aj9wTrhS0RLGnf
         bNz5z6rxLGZPPGSIMJrGfjO3RppacfEjA3JIfN/H42tTByM3OQdlpUIMjdFq33FFOc
         h9hurg86jctMMjYMyRPvnDc2mHIg3mSv8n3FAtsbo/QgyoruANwY+mLPaLooDWAVTq
         pAL+n6AHMcpUg==
Date:   Mon, 21 Mar 2022 23:01:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 3/4] net: lan966x: Add FDMA functionality
Message-ID: <20220321230123.4d38ad5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220318204750.1864134-4-horatiu.vultur@microchip.com>
References: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
        <20220318204750.1864134-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 21:47:49 +0100 Horatiu Vultur wrote:
> Ethernet frames can be extracted or injected to or from the device's
> DDR memory. There is one channel for injection and one channel for
> extraction. Each of these channels contain a linked list of DCBs which
> contains DB. The DCB for injection contains only 1 DB and the DCB for
> extraction contains 3 DBs. Each DB contains a frame. Everytime when a
> frame is received or transmitted an interrupt is generated.
> 
> It is not possible to use both the FDMA and the manual
> injection/extraction of the frames. Therefore the FDMA has priority over
> the manual because of better performance values.


> +static struct sk_buff *lan966x_fdma_rx_alloc_skb(struct lan966x_rx *rx,
> +						 struct lan966x_db *db)
> +{
> +	struct lan966x *lan966x = rx->lan966x;
> +	struct sk_buff *skb;
> +	dma_addr_t dma_addr;
> +	struct page *page;
> +	void *buff_addr;
> +
> +	page = dev_alloc_pages(rx->page_order);
> +	if (unlikely(!page))
> +		return NULL;
> +
> +	dma_addr = dma_map_page(lan966x->dev, page, 0,
> +				PAGE_SIZE << rx->page_order,
> +				DMA_FROM_DEVICE);
> +	if (unlikely(dma_mapping_error(lan966x->dev, dma_addr))) {
> +		__free_pages(page, rx->page_order);
> +		return NULL;
> +	}
> +
> +	buff_addr = page_address(page);
> +	skb = build_skb(buff_addr, PAGE_SIZE << rx->page_order);
> +

spurious new line

> +	if (unlikely(!skb)) {
> +		dev_err_ratelimited(lan966x->dev,
> +				    "build_skb failed !\n");

a statistic for that would be better than prints
kernel will already do some printing if it goes oom

> +		dma_unmap_single(lan966x->dev, dma_addr,
> +				 PAGE_SIZE << rx->page_order,
> +				 DMA_FROM_DEVICE);

why unmap_single if you used map_page for mapping?

> +		__free_pages(page, rx->page_order);
> +		return NULL;

please move the error handling to the end of the function and use goto
to jump into the right spot

> +	}
> +
> +	db->dataptr = dma_addr;
> +	return skb;
> +}

> +static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
> +{
> +	struct lan966x *lan966x = rx->lan966x;
> +	struct lan966x_rx_dcb *dcb;
> +	struct lan966x_db *db;
> +	struct sk_buff *skb;
> +	int i, j;
> +	int size;
> +
> +	/* calculate how many pages are needed to allocate the dcbs */
> +	size = sizeof(struct lan966x_rx_dcb) * FDMA_DCB_MAX;
> +	size = ALIGN(size, PAGE_SIZE);
> +
> +	rx->dcbs = dma_alloc_coherent(lan966x->dev, size, &rx->dma, GFP_ATOMIC);

Why ATOMIC? This seems to be called from the probe path.
Error checking missing.

> +	rx->last_entry = rx->dcbs;
> +	rx->db_index = 0;
> +	rx->dcb_index = 0;

> +static void lan966x_fdma_rx_start(struct lan966x_rx *rx)
> +{
> +	struct lan966x *lan966x = rx->lan966x;
> +	u32 mask;
> +
> +	/* When activating a channel, first is required to write the first DCB
> +	 * address and then to activate it
> +	 */
> +	lan_wr(((u64)rx->dma) & GENMASK(31, 0), lan966x,

lower_32_bits()

> +	       FDMA_DCB_LLP(rx->channel_id));
> +	lan_wr(((u64)rx->dma) >> 32, lan966x, FDMA_DCB_LLP1(rx->channel_id));

upper_32_bits()

> +	lan_wr(FDMA_CH_CFG_CH_DCB_DB_CNT_SET(FDMA_RX_DCB_MAX_DBS) |
> +	       FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_SET(1) |
> +	       FDMA_CH_CFG_CH_INJ_PORT_SET(0) |
> +	       FDMA_CH_CFG_CH_MEM_SET(1),
> +	       lan966x, FDMA_CH_CFG(rx->channel_id));

> +static int lan966x_fdma_tx_alloc(struct lan966x_tx *tx)
> +{
> +	struct lan966x *lan966x = tx->lan966x;
> +	struct lan966x_tx_dcb *dcb;
> +	struct lan966x_db *db;
> +	int size;
> +	int i, j;
> +
> +	tx->dcbs_buf = kcalloc(FDMA_DCB_MAX, sizeof(struct lan966x_tx_dcb_buf),
> +			       GFP_ATOMIC);
> +	if (!tx->dcbs_buf)
> +		return -ENOMEM;
> +
> +	/* calculate how many pages are needed to allocate the dcbs */
> +	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
> +	size = ALIGN(size, PAGE_SIZE);
> +	tx->dcbs = dma_alloc_coherent(lan966x->dev, size, &tx->dma, GFP_ATOMIC);

same comments re: atomic and error checking as on rx

> +	/* Now for each dcb allocate the db */
> +	for (i = 0; i < FDMA_DCB_MAX; ++i) {
> +		dcb = &tx->dcbs[i];
> +
> +		for (j = 0; j < FDMA_TX_DCB_MAX_DBS; ++j) {
> +			db = &dcb->db[j];
> +			db->dataptr = 0;
> +			db->status = 0;
> +		}
> +
> +		lan966x_fdma_tx_add_dcb(tx, dcb);
> +	}
> +
> +	return 0;
> +}

> +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> +{
> +	struct lan966x *lan966x = rx->lan966x;
> +	u64 src_port, timestamp;
> +	struct sk_buff *new_skb;
> +	struct lan966x_db *db;
> +	struct sk_buff *skb;
> +
> +	/* Check if there is any data */
> +	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
> +	if (unlikely(!(db->status & FDMA_DCB_STATUS_DONE)))
> +		return NULL;
> +
> +	/* Get the received frame and unmap it */
> +	skb = rx->skb[rx->dcb_index][rx->db_index];
> +	dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
> +			 FDMA_DCB_STATUS_BLOCKL(db->status),
> +			 DMA_FROM_DEVICE);
> +
> +	/* Allocate a new skb and map it */
> +	new_skb = lan966x_fdma_rx_alloc_skb(rx, db);
> +	if (unlikely(!new_skb))
> +		return NULL;

So how is memory pressure handled, exactly? Looks like it's handled 
the same as if the ring was empty, so the IRQ is going to get re-raise
immediately, or never raised again?

> +	rx->skb[rx->dcb_index][rx->db_index] = new_skb;
> +
> +	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
> +
> +	lan966x_ifh_get_src_port(skb->data, &src_port);
> +	lan966x_ifh_get_timestamp(skb->data, &timestamp);
> +
> +	WARN_ON(src_port >= lan966x->num_phys_ports);
> +
> +	skb->dev = lan966x->ports[src_port]->dev;
> +	skb_pull(skb, IFH_LEN * sizeof(u32));
> +
> +	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
> +		skb_trim(skb, skb->len - ETH_FCS_LEN);
> +
> +	lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
> +	skb->protocol = eth_type_trans(skb, skb->dev);
> +
> +	if (lan966x->bridge_mask & BIT(src_port)) {
> +		skb->offload_fwd_mark = 1;
> +
> +		skb_reset_network_header(skb);
> +		if (!lan966x_hw_offload(lan966x, src_port, skb))
> +			skb->offload_fwd_mark = 0;
> +	}
> +
> +	skb->dev->stats.rx_bytes += skb->len;
> +	skb->dev->stats.rx_packets++;
> +
> +	return skb;
> +}
> +
> +static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
> +{
> +	struct lan966x *lan966x = container_of(napi, struct lan966x, napi);
> +	struct lan966x_rx *rx = &lan966x->rx;
> +	struct list_head rx_list;
> +	int counter = 0;
> +
> +	lan966x_fdma_tx_clear_buf(lan966x, weight);
> +
> +	INIT_LIST_HEAD(&rx_list);
> +
> +	while (counter < weight) {
> +		struct lan966x_rx_dcb *old_dcb;
> +		struct sk_buff *skb;
> +		u64 nextptr;
> +
> +		skb = lan966x_fdma_rx_get_frame(rx);
> +		if (!skb)
> +			break;
> +		list_add_tail(&skb->list, &rx_list);
> +
> +		rx->db_index++;
> +		counter++;
> +
> +		/* Check if the DCB can be reused */
> +		if (rx->db_index != FDMA_RX_DCB_MAX_DBS)
> +			continue;
> +
> +		/* Now the DCB  can be reused, just advance the dcb_index
> +		 * pointer and set the nextptr in the DCB
> +		 */
> +		rx->db_index = 0;
> +
> +		old_dcb = &rx->dcbs[rx->dcb_index];
> +		rx->dcb_index++;
> +		rx->dcb_index &= FDMA_DCB_MAX - 1;
> +
> +		nextptr = rx->dma + ((unsigned long)old_dcb -
> +				     (unsigned long)rx->dcbs);
> +		lan966x_fdma_rx_add_dcb(rx, old_dcb, nextptr);
> +		lan966x_fdma_rx_reload(rx);
> +	}
> +
> +	if (counter < weight) {
> +		napi_complete_done(napi, counter);

You should check the return value of napi_complete_done().
busy polling or something else may want the IRQ to stay
disabled.

> +		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
> +	}
> +
> +	netif_receive_skb_list(&rx_list);

Why not GRO?

> +	return counter;
> +}
> +
> +irqreturn_t lan966x_fdma_irq_handler(int irq, void *args)
> +{
> +	struct lan966x *lan966x = args;
> +	u32 db, err, err_type;
> +
> +	db = lan_rd(lan966x, FDMA_INTR_DB);
> +	err = lan_rd(lan966x, FDMA_INTR_ERR);

Hm, IIUC you request a threaded IRQ for this. Why?
The register accesses can't sleep because you poke
them from napi_poll as well...

> +	if (db) {
> +		lan_wr(0, lan966x, FDMA_INTR_DB_ENA);
> +		lan_wr(db, lan966x, FDMA_INTR_DB);
> +
> +		napi_schedule(&lan966x->napi);
> +	}
> +
> +	if (err) {
> +		err_type = lan_rd(lan966x, FDMA_ERRORS);
> +
> +		WARN(1, "Unexpected error: %d, error_type: %d\n", err, err_type);
> +
> +		lan_wr(err, lan966x, FDMA_INTR_ERR);
> +		lan_wr(err_type, lan966x, FDMA_ERRORS);
> +	}
> +
> +	return IRQ_HANDLED;
> +}

> +int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> +{
> +	struct lan966x_port *port = netdev_priv(dev);
> +	struct lan966x *lan966x = port->lan966x;
> +	struct lan966x_tx_dcb_buf *next_dcb_buf;
> +	struct lan966x_tx_dcb *next_dcb, *dcb;
> +	struct lan966x_tx *tx = &lan966x->tx;
> +	struct lan966x_db *next_db;
> +	int needed_headroom;
> +	int needed_tailroom;
> +	dma_addr_t dma_addr;
> +	int next_to_use;
> +	int err;
> +
> +	/* Get next index */
> +	next_to_use = lan966x_fdma_get_next_dcb(tx);
> +	if (next_to_use < 0) {
> +		netif_stop_queue(dev);
> +		err = NETDEV_TX_BUSY;
> +		goto out;
> +	}
> +
> +	if (skb_put_padto(skb, ETH_ZLEN)) {
> +		dev->stats.tx_dropped++;

It's preferred not to use the old dev->stats, but I guess you already
do so :( This is under some locks, right? No chance for another queue
or port to try to touch those stats at the same time?

> +		err = NETDEV_TX_OK;
> +		goto out;
> +	}
> +
> +	/* skb processing */
> +	needed_headroom = max_t(int, IFH_LEN * sizeof(u32) - skb_headroom(skb), 0);
> +	needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
> +	if (needed_headroom || needed_tailroom) {
> +		err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
> +				       GFP_ATOMIC);
> +		if (unlikely(err)) {
> +			dev->stats.tx_dropped++;
> +			err = NETDEV_TX_OK;
> +			goto release;
> +		}
> +	}

You need to skb_cow_head() even if you don't need to grow the headroom
or tailroom.

> +	skb_push(skb, IFH_LEN * sizeof(u32));
> +	memcpy(skb->data, ifh, IFH_LEN * sizeof(u32));
> +	skb_put(skb, 4);
> +
> +	dma_addr = dma_map_single(lan966x->dev, skb->data, skb->len,
> +				  DMA_TO_DEVICE);
> +	if (dma_mapping_error(lan966x->dev, dma_addr)) {
> +		dev->stats.tx_dropped++;
> +		err = NETDEV_TX_OK;
> +		goto release;
> +	}
> +
> +	/* Setup next dcb */
> +	next_dcb = &tx->dcbs[next_to_use];
> +	next_dcb->nextptr = FDMA_DCB_INVALID_DATA;
> +
> +	next_db = &next_dcb->db[0];
> +	next_db->dataptr = dma_addr;
> +	next_db->status = FDMA_DCB_STATUS_SOF |
> +			  FDMA_DCB_STATUS_EOF |
> +			  FDMA_DCB_STATUS_INTR |
> +			  FDMA_DCB_STATUS_BLOCKO(0) |
> +			  FDMA_DCB_STATUS_BLOCKL(skb->len);
> +
> +	/* Fill up the buffer */
> +	next_dcb_buf = &tx->dcbs_buf[next_to_use];
> +	next_dcb_buf->skb = skb;
> +	next_dcb_buf->dma_addr = dma_addr;
> +	next_dcb_buf->used = true;
> +	next_dcb_buf->ptp = false;
> +
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> +	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> +		next_dcb_buf->ptp = true;
> +
> +	skb_tx_timestamp(skb);
> +	if (likely(lan966x->tx.activated)) {
> +		/* Connect current dcb to the next db */
> +		dcb = &tx->dcbs[tx->last_in_use];
> +		dcb->nextptr = tx->dma + (next_to_use *
> +					  sizeof(struct lan966x_tx_dcb));
> +
> +		lan966x_fdma_tx_reload(tx);
> +	} else {
> +		/* Because it is first time, then just activate */
> +		lan966x->tx.activated = true;
> +		lan966x_fdma_tx_activate(tx);
> +	}
> +
> +	/* Move to next dcb because this last in use */
> +	tx->last_in_use = next_to_use;
> +
> +	dev->stats.tx_packets++;
> +	dev->stats.tx_bytes += skb->len;

I think it's best practice to increase the stats when processing
completions, you're not sure at this point whether the skb will
actually get transmitted. Also normally skb could be freed by the 
IRQ handler as soon as its given to HW, but I think you have a lock 
so no risk of UAF on the skb->len access?

> +	return NETDEV_TX_OK;
> +
> +out:
> +	return err;
> +
> +release:
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> +	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> +		lan966x_ptp_txtstamp_release(port, skb);
> +
> +	dev_kfree_skb_any(skb);
> +	return err;

I think you're better off returning BUSY directly then you can forgo
setting err and always return TX_OK.

> +void lan966x_fdma_init(struct lan966x *lan966x)
> +{
> +	lan966x->rx.lan966x = lan966x;
> +	lan966x->rx.channel_id = FDMA_XTR_CHANNEL;
> +	lan966x->tx.lan966x = lan966x;
> +	lan966x->tx.channel_id = FDMA_INJ_CHANNEL;
> +	lan966x->tx.last_in_use = -1;
> +
> +	lan966x_fdma_rx_alloc(&lan966x->rx);
> +	lan966x_fdma_tx_alloc(&lan966x->tx);
> +
> +	lan966x_fdma_rx_start(&lan966x->rx);

Not checking for any errors here is highly suspicious
