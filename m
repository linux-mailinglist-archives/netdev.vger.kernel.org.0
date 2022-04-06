Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B342B4F621C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiDFOs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbiDFOr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:47:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B0547E76;
        Wed,  6 Apr 2022 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649243887; x=1680779887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sx1PWUzlf/cmm4QhPd7Tl79gNKsMMw+SC0XlQZ0jOQU=;
  b=bMM5M951Cm0CORcD66rvskEA+I8uHEWRi3S2qjF8fma0NEEMO78EYc9I
   DNCmnEkiSNOHuONV/n29uU0f2RtsHQtBFqV77hvlCuyNSr2G2OjjwXBv1
   QaqRFYWVv7c0CiF8koHnN1QD+YTG6R3NGCNbm2WgfvqEwjpwfV20oSwVp
   vffFvow3n6LM63KqhcftaWgYKneShhksgqn6SuPA9xo8E10rEP8G42Qzu
   TGqjvpXA668W/EtacfL0TZxMfyzdj8yYXO2K+a0VDrLQOOm0cnhL7KB60
   S8vGnVd4Cp+bC5z6gxKn544sSoYvJclYbaUYgj6qT2PRHuNx1QKj2qVcd
   w==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643698800"; 
   d="scan'208";a="159117745"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 04:18:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 04:18:04 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 6 Apr 2022 04:18:03 -0700
Date:   Wed, 6 Apr 2022 13:21:15 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <michael@walle.cc>
Subject: Re: [PATCH net-next v3 3/4] net: lan966x: Add FDMA functionality
Message-ID: <20220406112115.6kira24azizz6z2b@soft-dev3-1.localhost>
References: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
 <20220404130655.4004204-4-horatiu.vultur@microchip.com>
 <20220405211230.4a1a868d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220405211230.4a1a868d@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/05/2022 21:12, Jakub Kicinski wrote:

Hi Jakub,

> 
> On Mon, 4 Apr 2022 15:06:54 +0200 Horatiu Vultur wrote:
> > Ethernet frames can be extracted or injected to or from the device's
> > DDR memory. There is one channel for injection and one channel for
> > extraction. Each of these channels contain a linked list of DCBs which
> > contains DB. The DCB contains only 1 DB for both the injection and
> > extraction. Each DB contains a frame. Every time when a frame is received
> > or transmitted an interrupt is generated.
> >
> > It is not possible to use both the FDMA and the manual
> > injection/extraction of the frames. Therefore the FDMA has priority over
> > the manual because of better performance values.
> >
> > FDMA:
> > iperf -c 192.168.1.1
> > [  5]   0.00-10.02  sec   420 MBytes   352 Mbits/sec    0 sender
> > [  5]   0.00-10.03  sec   420 MBytes   351 Mbits/sec      receiver
> >
> > iperf -c 192.168.1.1 -R
> > [  5]   0.00-10.01  sec   528 MBytes   442 Mbits/sec    0 sender
> > [  5]   0.00-10.00  sec   524 MBytes   440 Mbits/sec      receiver
> >
> > Manual:
> > iperf -c 192.168.1.1
> > [  5]   0.00-10.02  sec  93.8 MBytes  78.5 Mbits/sec    0 sender
> > [  5]   0.00-10.03  sec  93.8 MBytes  78.4 Mbits/sec      receiver
> >
> > ipers -c 192.168.1.1 -R
> > [  5]   0.00-10.03  sec   121 MBytes   101 Mbits/sec    0 sender
> > [  5]   0.00-10.01  sec   118 MBytes  99.0 Mbits/sec      receiver
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> > +static struct sk_buff *lan966x_fdma_rx_alloc_skb(struct lan966x_rx *rx,
> > +                                              struct lan966x_db *db)
> > +{
> > +     struct lan966x *lan966x = rx->lan966x;
> > +     struct sk_buff *skb;
> > +     dma_addr_t dma_addr;
> > +     struct page *page;
> > +     void *buff_addr;
> > +
> > +     page = dev_alloc_pages(rx->page_order);
> > +     if (unlikely(!page))
> > +             return NULL;
> > +
> > +     dma_addr = dma_map_page(lan966x->dev, page, 0,
> > +                             PAGE_SIZE << rx->page_order,
> > +                             DMA_FROM_DEVICE);
> > +     if (unlikely(dma_mapping_error(lan966x->dev, dma_addr)))
> > +             goto free_page;
> > +
> > +     buff_addr = page_address(page);
> > +     skb = build_skb(buff_addr, PAGE_SIZE << rx->page_order);
> 
> build_skb() after the packet comes in rather than upfront, that way
> the skb will be in the CPU cache already when sent up the stack.

Yes, I will do that.

> 
> > +     if (unlikely(!skb))
> > +             goto unmap_page;
> > +
> > +     db->dataptr = dma_addr;
> > +
> > +     return skb;
> > +
> > +unmap_page:
> > +     dma_unmap_page(lan966x->dev, dma_addr,
> > +                    PAGE_SIZE << rx->page_order,
> > +                    DMA_FROM_DEVICE);
> > +
> > +free_page:
> > +     __free_pages(page, rx->page_order);
> > +     return NULL;
> > +}
> 
> > +static int lan966x_fdma_tx_alloc(struct lan966x_tx *tx)
> > +{
> > +     struct lan966x *lan966x = tx->lan966x;
> > +     struct lan966x_tx_dcb *dcb;
> > +     struct lan966x_db *db;
> > +     int size;
> > +     int i, j;
> > +
> > +     tx->dcbs_buf = kcalloc(FDMA_DCB_MAX, sizeof(struct lan966x_tx_dcb_buf),
> > +                            GFP_ATOMIC);
> > +     if (!tx->dcbs_buf)
> > +             return -ENOMEM;
> > +
> > +     /* calculate how many pages are needed to allocate the dcbs */
> > +     size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
> > +     size = ALIGN(size, PAGE_SIZE);
> > +     tx->dcbs = dma_alloc_coherent(lan966x->dev, size, &tx->dma, GFP_ATOMIC);
> 
> This functions seems to only be called from probe, so GFP_KERNEL
> is better.

But in the next patch of this series will be called while holding
the lan966x->tx_lock. Should I still change it to GFP_KERNEL and then
in the next one will change to GFP_ATOMIC?

> 
> > +     if (!tx->dcbs)
> > +             goto out;
> > +
> > +     /* Now for each dcb allocate the db */
> > +     for (i = 0; i < FDMA_DCB_MAX; ++i) {
> > +             dcb = &tx->dcbs[i];
> > +
> > +             for (j = 0; j < FDMA_TX_DCB_MAX_DBS; ++j) {
> > +                     db = &dcb->db[j];
> > +                     db->dataptr = 0;
> > +                     db->status = 0;
> > +             }
> > +
> > +             lan966x_fdma_tx_add_dcb(tx, dcb);
> > +     }
> > +
> > +     return 0;
> > +
> > +out:
> > +     kfree(tx->dcbs_buf);
> > +     return -ENOMEM;
> > +}
> 
> > +static void lan966x_fdma_wakeup_netdev(struct lan966x *lan966x)
> > +{
> > +     struct lan966x_port *port;
> > +     int i;
> > +
> > +     for (i = 0; i < lan966x->num_phys_ports; ++i) {
> > +             port = lan966x->ports[i];
> > +             if (!port)
> > +                     continue;
> > +
> > +             if (netif_queue_stopped(port->dev))
> > +                     netif_wake_queue(port->dev);
> > +     }
> > +}
> > +
> > +static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
> > +{
> > +     struct lan966x_tx *tx = &lan966x->tx;
> > +     struct lan966x_tx_dcb_buf *dcb_buf;
> > +     struct lan966x_db *db;
> > +     unsigned long flags;
> > +     bool clear = false;
> > +     int i;
> > +
> > +     spin_lock_irqsave(&lan966x->tx_lock, flags);
> > +     for (i = 0; i < FDMA_DCB_MAX; ++i) {
> > +             dcb_buf = &tx->dcbs_buf[i];
> > +
> > +             if (!dcb_buf->used)
> > +                     continue;
> > +
> > +             db = &tx->dcbs[i].db[0];
> > +             if (!(db->status & FDMA_DCB_STATUS_DONE))
> > +                     continue;
> > +
> > +             dcb_buf->dev->stats.tx_packets++;
> > +             dcb_buf->dev->stats.tx_bytes += dcb_buf->skb->len;
> > +
> > +             dcb_buf->used = false;
> > +             dma_unmap_single(lan966x->dev,
> > +                              dcb_buf->dma_addr,
> > +                              dcb_buf->skb->len,
> > +                              DMA_TO_DEVICE);
> > +             if (!dcb_buf->ptp)
> > +                     dev_kfree_skb_any(dcb_buf->skb);
> > +
> > +             clear = true;
> > +     }
> > +     spin_unlock_irqrestore(&lan966x->tx_lock, flags);
> > +
> > +     if (clear)
> > +             lan966x_fdma_wakeup_netdev(lan966x);
> 
> You may want to keep this call inside the lock so that the tx path
> doesn't kick in between unlock and wake and fill up the queues.

Good point. I will update this.

> 
> > +}
> > +
> > +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> > +{
> > +     struct lan966x *lan966x = rx->lan966x;
> > +     u64 src_port, timestamp;
> > +     struct lan966x_db *db;
> > +     struct sk_buff *skb;
> > +
> > +     /* Check if there is any data */
> > +     db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
> > +     if (unlikely(!(db->status & FDMA_DCB_STATUS_DONE)))
> > +             return NULL;
> > +
> > +     /* Get the received frame and unmap it */
> > +     skb = rx->skb[rx->dcb_index][rx->db_index];
> > +     dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
> > +                      FDMA_DCB_STATUS_BLOCKL(db->status),
> > +                      DMA_FROM_DEVICE);
> > +
> > +     skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
> > +
> > +     lan966x_ifh_get_src_port(skb->data, &src_port);
> > +     lan966x_ifh_get_timestamp(skb->data, &timestamp);
> > +
> > +     WARN_ON(src_port >= lan966x->num_phys_ports);
> > +
> > +     skb->dev = lan966x->ports[src_port]->dev;
> > +     skb_pull(skb, IFH_LEN * sizeof(u32));
> > +
> > +     if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
> > +             skb_trim(skb, skb->len - ETH_FCS_LEN);
> > +
> > +     lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
> > +     skb->protocol = eth_type_trans(skb, skb->dev);
> > +
> > +     if (lan966x->bridge_mask & BIT(src_port)) {
> > +             skb->offload_fwd_mark = 1;
> > +
> > +             skb_reset_network_header(skb);
> > +             if (!lan966x_hw_offload(lan966x, src_port, skb))
> > +                     skb->offload_fwd_mark = 0;
> > +     }
> > +
> > +     skb->dev->stats.rx_bytes += skb->len;
> > +     skb->dev->stats.rx_packets++;
> > +
> > +     return skb;
> > +}
> > +
> > +static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
> > +{
> > +     struct lan966x *lan966x = container_of(napi, struct lan966x, napi);
> > +     struct lan966x_rx *rx = &lan966x->rx;
> > +     int dcb_reload = rx->dcb_index;
> > +     struct lan966x_rx_dcb *old_dcb;
> > +     struct lan966x_db *db;
> > +     struct sk_buff *skb;
> > +     int counter = 0;
> > +     u64 nextptr;
> > +
> > +     lan966x_fdma_tx_clear_buf(lan966x, weight);
> > +
> > +     /* Get all received skb */
> > +     while (counter < weight) {
> > +             skb = lan966x_fdma_rx_get_frame(rx);
> > +             if (!skb)
> > +                     break;
> > +             napi_gro_receive(&lan966x->napi, skb);
> > +
> > +             rx->skb[rx->dcb_index][rx->db_index] = NULL;
> > +
> > +             rx->dcb_index++;
> > +             rx->dcb_index &= FDMA_DCB_MAX - 1;
> > +             counter++;
> > +     }
> > +
> > +     /* Allocate new skbs and map them */
> > +     while (dcb_reload != rx->dcb_index) {
> > +             db = &rx->dcbs[dcb_reload].db[rx->db_index];
> > +             skb = lan966x_fdma_rx_alloc_skb(rx, db);
> > +             if (unlikely(!skb))
> > +                     break;
> > +             rx->skb[dcb_reload][rx->db_index] = skb;
> > +
> > +             old_dcb = &rx->dcbs[dcb_reload];
> > +             dcb_reload++;
> > +             dcb_reload &= FDMA_DCB_MAX - 1;
> > +
> > +             nextptr = rx->dma + ((unsigned long)old_dcb -
> > +                                  (unsigned long)rx->dcbs);
> > +             lan966x_fdma_rx_add_dcb(rx, old_dcb, nextptr);
> > +             lan966x_fdma_rx_reload(rx);
> > +     }
> > +
> > +     if (counter < weight && napi_complete_done(napi, counter))
> > +             lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
> > +
> > +     return counter;
> > +}
> > +
> > +irqreturn_t lan966x_fdma_irq_handler(int irq, void *args)
> > +{
> > +     struct lan966x *lan966x = args;
> > +     u32 db, err, err_type;
> > +
> > +     db = lan_rd(lan966x, FDMA_INTR_DB);
> > +     err = lan_rd(lan966x, FDMA_INTR_ERR);
> > +
> > +     if (db) {
> > +             lan_wr(0, lan966x, FDMA_INTR_DB_ENA);
> > +             lan_wr(db, lan966x, FDMA_INTR_DB);
> > +
> > +             napi_schedule(&lan966x->napi);
> > +     }
> > +
> > +     if (err) {
> > +             err_type = lan_rd(lan966x, FDMA_ERRORS);
> > +
> > +             WARN(1, "Unexpected error: %d, error_type: %d\n", err, err_type);
> > +
> > +             lan_wr(err, lan966x, FDMA_INTR_ERR);
> > +             lan_wr(err_type, lan966x, FDMA_ERRORS);
> > +     }
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static int lan966x_fdma_get_next_dcb(struct lan966x_tx *tx)
> > +{
> > +     struct lan966x_tx_dcb_buf *dcb_buf;
> > +     int i;
> > +
> > +     for (i = 0; i < FDMA_DCB_MAX; ++i) {
> > +             dcb_buf = &tx->dcbs_buf[i];
> > +             if (!dcb_buf->used && i != tx->last_in_use)
> > +                     return i;
> > +     }
> > +
> > +     return -1;
> > +}
> > +
> > +int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> > +{
> > +     struct lan966x_port *port = netdev_priv(dev);
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct lan966x_tx_dcb_buf *next_dcb_buf;
> > +     struct lan966x_tx_dcb *next_dcb, *dcb;
> > +     struct lan966x_tx *tx = &lan966x->tx;
> > +     struct lan966x_db *next_db;
> > +     int needed_headroom;
> > +     int needed_tailroom;
> > +     dma_addr_t dma_addr;
> > +     int next_to_use;
> > +     int err;
> > +
> > +     /* Get next index */
> > +     next_to_use = lan966x_fdma_get_next_dcb(tx);
> > +     if (next_to_use < 0) {
> > +             netif_stop_queue(dev);
> > +             return NETDEV_TX_BUSY;
> > +     }
> > +
> > +     if (skb_put_padto(skb, ETH_ZLEN)) {
> > +             dev->stats.tx_dropped++;
> > +             return NETDEV_TX_OK;
> > +     }
> > +
> > +     /* skb processing */
> > +     needed_headroom = max_t(int, IFH_LEN * sizeof(u32) - skb_headroom(skb), 0);
> > +     needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
> > +     if (needed_headroom || needed_tailroom || skb_header_cloned(skb)) {
> > +             err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
> > +                                    GFP_ATOMIC);
> > +             if (unlikely(err)) {
> > +                     dev->stats.tx_dropped++;
> > +                     err = NETDEV_TX_OK;
> > +                     goto release;
> > +             }
> > +     }
> > +
> > +     skb_tx_timestamp(skb);
> 
> This could move down after the dma mapping, so it's closer to when
> the devices gets ownership.

The problem is that, if I move this lower, then the SKB is changed
because the IFH is added to the frame. So now if we do timestamping in
the PHY then when we call classify inside 'skb_clone_tx_timestamp'
will always return PTP_CLASS_NONE so the PHY will never get the frame.
That is the reason why I have move it back.

> 
> > +     skb_push(skb, IFH_LEN * sizeof(u32));
> > +     memcpy(skb->data, ifh, IFH_LEN * sizeof(u32));
> > +     skb_put(skb, 4);
> > +
> > +     dma_addr = dma_map_single(lan966x->dev, skb->data, skb->len,
> > +                               DMA_TO_DEVICE);
> > +     if (dma_mapping_error(lan966x->dev, dma_addr)) {
> > +             dev->stats.tx_dropped++;
> > +             err = NETDEV_TX_OK;
> > +             goto release;
> > +     }
> > +
> > +     /* Setup next dcb */
> > +     next_dcb = &tx->dcbs[next_to_use];
> > +     next_dcb->nextptr = FDMA_DCB_INVALID_DATA;
> > +
> > +     next_db = &next_dcb->db[0];
> > +     next_db->dataptr = dma_addr;
> > +     next_db->status = FDMA_DCB_STATUS_SOF |
> > +                       FDMA_DCB_STATUS_EOF |
> > +                       FDMA_DCB_STATUS_INTR |
> > +                       FDMA_DCB_STATUS_BLOCKO(0) |
> > +                       FDMA_DCB_STATUS_BLOCKL(skb->len);
> > +
> > +     /* Fill up the buffer */
> > +     next_dcb_buf = &tx->dcbs_buf[next_to_use];
> > +     next_dcb_buf->skb = skb;
> > +     next_dcb_buf->dma_addr = dma_addr;
> > +     next_dcb_buf->used = true;
> > +     next_dcb_buf->ptp = false;
> > +     next_dcb_buf->dev = dev;
> > +
> > +     if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > +         LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > +             next_dcb_buf->ptp = true;
> > +
> > +     if (likely(lan966x->tx.activated)) {
> > +             /* Connect current dcb to the next db */
> > +             dcb = &tx->dcbs[tx->last_in_use];
> > +             dcb->nextptr = tx->dma + (next_to_use *
> > +                                       sizeof(struct lan966x_tx_dcb));
> > +
> > +             lan966x_fdma_tx_reload(tx);
> > +     } else {
> > +             /* Because it is first time, then just activate */
> > +             lan966x->tx.activated = true;
> > +             lan966x_fdma_tx_activate(tx);
> > +     }
> > +
> > +     /* Move to next dcb because this last in use */
> > +     tx->last_in_use = next_to_use;
> > +
> > +     return NETDEV_TX_OK;
> > +
> > +release:
> > +     if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > +         LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > +             lan966x_ptp_txtstamp_release(port, skb);
> > +
> > +     dev_kfree_skb_any(skb);
> > +     return err;
> > +}
> > +
> > +void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev)
> > +{
> > +     if (lan966x->fdma_ndev)
> > +             return;
> > +
> > +     lan966x->fdma_ndev = dev;
> > +     netif_napi_add(dev, &lan966x->napi, lan966x_fdma_napi_poll,
> > +                    FDMA_WEIGHT);
> 
> Just use NAPI_POLL_WEIGHT. We should just remove the last argument
> to netif_napi_add() completely but that's another story..

OK. I will use NAPI_POLL_WEIGHT.

> 
> > +     napi_enable(&lan966x->napi);
> > +}
> 
> > +
> > +     if (lan966x->fdma_irq) {
> > +             disable_irq(lan966x->fdma_irq);
> 
> You don't add any enable_irq() calls, maybe devm_free_irq() is a better
> choice?

Yes, I will try to use devm_free_irq.

> 
> > +             lan966x->fdma_irq = -ENXIO;
> 
> Semantics of lan966x->fdma_irq are pretty unclear.
> Why is the condition not "> 0" for this block?

That is a mistake. The condition should be 'if (lan966x->fdma)'. I have
mixed too much the lan966x->fdma_irq and lan966x->fdma.

> 
> > +     }
> >  }
> >
> >  static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> > @@ -790,12 +801,12 @@ static void lan966x_init(struct lan966x *lan966x)
> >       /* Do byte-swap and expect status after last data word
> >        * Extraction: Mode: manual extraction) | Byte_swap
> >        */
> > -     lan_wr(QS_XTR_GRP_CFG_MODE_SET(1) |
> > +     lan_wr(QS_XTR_GRP_CFG_MODE_SET(lan966x->fdma ? 2 : 1) |
> >              QS_XTR_GRP_CFG_BYTE_SWAP_SET(1),
> >              lan966x, QS_XTR_GRP_CFG(0));
> >
> >       /* Injection: Mode: manual injection | Byte_swap */
> > -     lan_wr(QS_INJ_GRP_CFG_MODE_SET(1) |
> > +     lan_wr(QS_INJ_GRP_CFG_MODE_SET(lan966x->fdma ? 2 : 1) |
> >              QS_INJ_GRP_CFG_BYTE_SWAP_SET(1),
> >              lan966x, QS_INJ_GRP_CFG(0));
> >
> > @@ -1017,6 +1028,17 @@ static int lan966x_probe(struct platform_device *pdev)
> >               lan966x->ptp = 1;
> >       }
> >
> > +     lan966x->fdma_irq = platform_get_irq_byname(pdev, "fdma");
> > +     if (lan966x->fdma_irq > 0) {
> > +             err = devm_request_irq(&pdev->dev, lan966x->fdma_irq,
> > +                                    lan966x_fdma_irq_handler, 0,
> > +                                    "fdma irq", lan966x);
> > +             if (err)
> > +                     return dev_err_probe(&pdev->dev, err, "Unable to use fdma irq");
> > +
> > +             lan966x->fdma = true;
> > +     }
> > +
> >       /* init switch */
> >       lan966x_init(lan966x);
> >       lan966x_stats_init(lan966x);
> > @@ -1055,8 +1077,15 @@ static int lan966x_probe(struct platform_device *pdev)
> >       if (err)
> >               goto cleanup_fdb;
> >
> > +     err = lan966x_fdma_init(lan966x);
> 
> At at quick read it's unclear why this call is not conditional
> on lan988x->fdma ?

That is a mistake, it should have the lan966x->fdma check.

> 
> > +     if (err)
> > +             goto cleanup_ptp;

-- 
/Horatiu
