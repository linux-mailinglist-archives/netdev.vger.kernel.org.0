Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C99662F59
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjAISjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbjAISjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0694BE69
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VI4LMcTeIJiNVhJgHfAXMNUauvFBQVJ507NiQm3kVQc=; b=DvNcGSf+3xa/Mf9yL7kLaxsx45
        I/xpwjxARB6ELPLZToNiz2WwRsfWQGVXHWhvgu/blC27vY3SdtsReu2Fh43PeWmhbK2cfNM0qxhvE
        6Jla4LjmQWpEZxHRO/CPc09mulA8tEH2VeUU/j3HlwUI3E/GAh3WmInqqvyZ2B9hWaemqTXvHgNoF
        ImBUcyixhNsspFUPRP34BwCxv2BC4VlIVaSkGE7BdXo65ZeSmNd4vooyFDLS1sDOyqDO+UUmYDdiB
        xsVLvTCAK13RevRHFLQOU3933Ra2YfgZDAb3bU1RsJMKJbRCUIHowypRCbI2Wa6+WMg5nyYt8tqc2
        XedbojLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pEx0w-002XBS-U4; Mon, 09 Jan 2023 18:36:54 +0000
Date:   Mon, 9 Jan 2023 18:36:54 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 17/24] page_pool: Convert page_pool_return_skb_page()
 to use netmem
Message-ID: <Y7xexniPnKSgCMVE@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-18-willy@infradead.org>
 <1545f7e7-3c2c-435a-b597-0824decf571c@redhat.com>
 <Y7hR7KAzsOPsXrA1@casper.infradead.org>
 <c0f53cee-aaa7-2fe8-ff5b-0853085b6514@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vDleLtG6VCpo8mjg"
Content-Disposition: inline
In-Reply-To: <c0f53cee-aaa7-2fe8-ff5b-0853085b6514@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vDleLtG6VCpo8mjg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 06, 2023 at 09:16:25PM +0100, Jesper Dangaard Brouer wrote:
> 
> 
> On 06/01/2023 17.53, Matthew Wilcox wrote:
> > On Fri, Jan 06, 2023 at 04:49:12PM +0100, Jesper Dangaard Brouer wrote:
> > > On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> > > > This function accesses the pagepool members of struct page directly,
> > > > so it needs to become netmem.  Add page_pool_put_full_netmem() and
> > > > page_pool_recycle_netmem().
> > > > 
> > > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > > ---
> > > >    include/net/page_pool.h | 14 +++++++++++++-
> > > >    net/core/page_pool.c    | 13 ++++++-------
> > > >    2 files changed, 19 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > > index fbb653c9f1da..126c04315929 100644
> > > > --- a/include/net/page_pool.h
> > > > +++ b/include/net/page_pool.h
> > > > @@ -464,10 +464,16 @@ static inline void page_pool_put_page(struct page_pool *pool,
> > > >    }
> > > >    /* Same as above but will try to sync the entire area pool->max_len */
> > > > +static inline void page_pool_put_full_netmem(struct page_pool *pool,
> > > > +		struct netmem *nmem, bool allow_direct)
> > > > +{
> > > > +	page_pool_put_netmem(pool, nmem, -1, allow_direct);
> > > > +}
> > > > +
> > > >    static inline void page_pool_put_full_page(struct page_pool *pool,
> > > >    					   struct page *page, bool allow_direct)
> > > >    {
> > > > -	page_pool_put_page(pool, page, -1, allow_direct);
> > > > +	page_pool_put_full_netmem(pool, page_netmem(page), allow_direct);
> > > >    }
> > > >    /* Same as above but the caller must guarantee safe context. e.g NAPI */
> > > > @@ -477,6 +483,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> > > >    	page_pool_put_full_page(pool, page, true);
> > > >    }
> > > > +static inline void page_pool_recycle_netmem(struct page_pool *pool,
> > > > +					    struct netmem *nmem)
> > > > +{
> > > > +	page_pool_put_full_netmem(pool, nmem, true);
> > >                                                ^^^^
> > > 
> > > It is not clear in what context page_pool_recycle_netmem() will be used,
> > > but I think the 'true' (allow_direct=true) might be wrong here.
> > > 
> > > It is only in limited special cases (RX-NAPI context) we can allow
> > > direct return to the RX-alloc-cache.
> > 
> > Mmm.  It's a c'n'p of the previous function:
> > 
> > static inline void page_pool_recycle_direct(struct page_pool *pool,
> >                                              struct page *page)
> > {
> >          page_pool_put_full_page(pool, page, true);
> > }
> > 
> > so perhaps it's just badly named?
> 
> Yes, I think so.
> 
> Can we name it:
>  page_pool_recycle_netmem_direct
> 
> And perhaps add a comment with a warning like:
>  /* Caller must guarantee safe context. e.g NAPI */
> 
> Like the page_pool_recycle_direct() function has a comment.

I don't really like the new name you're proposing here.  Really,
page_pool_recycle_direct() is the perfect name, it just has the wrong
type.

I considered the attached megapatch, but I don't think that's a great
idea.

So here's what I'm planning instead:

    page_pool: Allow page_pool_recycle_direct() to take a netmem or a page

    With no better name for a variant of page_pool_recycle_direct() which
    takes a netmem instead of a page, use _Generic() to allow it to take
    either a page or a netmem argument.  It's a bit ugly, but maybe not
    the worst alternative?

    Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index abe3822a1125..1eed8ed2dcc1 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -477,12 +477,22 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
 }

 /* Same as above but the caller must guarantee safe context. e.g NAPI */
-static inline void page_pool_recycle_direct(struct page_pool *pool,
+static inline void __page_pool_recycle_direct(struct page_pool *pool,
+                                           struct netmem *nmem)
+{
+       page_pool_put_full_netmem(pool, nmem, true);
+}
+
+static inline void __page_pool_recycle_page_direct(struct page_pool *pool,
                                            struct page *page)
 {
-       page_pool_put_full_page(pool, page, true);
+       page_pool_put_full_netmem(pool, page_netmem(page), true);
 }

+#define page_pool_recycle_direct(pool, mem)    _Generic((mem),         \
+       struct netmem *: __page_pool_recycle_direct(pool, (struct netmem *)mem),                \
+       struct page *:   __page_pool_recycle_page_direct(pool, (struct page *)mem))
+
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT        \
                (sizeof(dma_addr_t) > sizeof(unsigned long))



--vDleLtG6VCpo8mjg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="direct-netmem.diff"

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 2c3c81473b97..eda5ed12ecee 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -188,10 +188,10 @@ NAPI poller
     dma_dir = page_pool_get_dma_dir(dring->page_pool);
     while (done < budget) {
         if (some error)
-            page_pool_recycle_direct(page_pool, page);
+            page_pool_recycle_direct(page_pool, page_netmem(page));
         if (packet_is_xdp) {
             if XDP_DROP:
-                page_pool_recycle_direct(page_pool, page);
+                page_pool_recycle_direct(page_pool, page_netmem(page));
         } else (packet_is_skb) {
             page_pool_release_page(page_pool, page);
             new_page = page_pool_dev_alloc_pages(page_pool);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 16ce7a90610c..088c2b31e450 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -736,7 +736,7 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 	*mapping = dma_map_page_attrs(dev, page, 0, PAGE_SIZE, bp->rx_dir,
 				      DMA_ATTR_WEAK_ORDERING);
 	if (dma_mapping_error(dev, *mapping)) {
-		page_pool_recycle_direct(rxr->page_pool, page);
+		page_pool_recycle_direct(rxr->page_pool, page_netmem(page));
 		return NULL;
 	}
 	return page;
@@ -2975,7 +2975,8 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 			dma_unmap_page_attrs(&pdev->dev, mapping, PAGE_SIZE,
 					     bp->rx_dir,
 					     DMA_ATTR_WEAK_ORDERING);
-			page_pool_recycle_direct(rxr->page_pool, data);
+			page_pool_recycle_direct(rxr->page_pool,
+							page_netmem(data));
 		} else {
 			dma_unmap_single_attrs(&pdev->dev, mapping,
 					       bp->rx_buf_use_size, bp->rx_dir,
@@ -3002,7 +3003,8 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 			rx_agg_buf->page = NULL;
 			__clear_bit(i, rxr->rx_agg_bmap);
 
-			page_pool_recycle_direct(rxr->page_pool, page);
+			page_pool_recycle_direct(rxr->page_pool,
+						page_netmem(page));
 		} else {
 			dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
 					     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 36d5202c0aee..df410ce24028 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -156,7 +156,8 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 			for (j = 0; j < frags; j++) {
 				tx_cons = NEXT_TX(tx_cons);
 				tx_buf = &txr->tx_buf_ring[tx_cons];
-				page_pool_recycle_direct(rxr->page_pool, tx_buf->page);
+				page_pool_recycle_direct(rxr->page_pool,
+						page_netmem(tx_buf->page));
 			}
 		}
 		tx_cons = NEXT_TX(tx_cons);
@@ -209,7 +210,7 @@ void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
 	for (i = 0; i < shinfo->nr_frags; i++) {
 		struct page *page = skb_frag_page(&shinfo->frags[i]);
 
-		page_pool_recycle_direct(rxr->page_pool, page);
+		page_pool_recycle_direct(rxr->page_pool, page_netmem(page));
 	}
 	shinfo->nr_frags = 0;
 }
@@ -310,7 +311,8 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, &xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
-			page_pool_recycle_direct(rxr->page_pool, page);
+			page_pool_recycle_direct(rxr->page_pool,
+							page_netmem(page));
 			return true;
 		}
 
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bf0190e1d2ea..ef078a72aa26 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -920,7 +920,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 
 			napi_gro_receive(napi, skb);
 		} else {
-			page_pool_recycle_direct(rx->page_pool, entry->page);
+			page_pool_recycle_direct(rx->page_pool,
+						page_netmem(entry->page));
 
 			rx->dropped++;
 		}
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 644f3c963730..cb4406933794 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1675,7 +1675,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
 		if (unlikely(!skb)) {
-			page_pool_recycle_direct(rxq->page_pool, page);
+			page_pool_recycle_direct(rxq->page_pool,
+							page_netmem(page));
 			ndev->stats.rx_dropped++;
 
 			netdev_err_once(ndev, "build_skb failed!\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index c8820ab22169..152cf434102a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -335,7 +335,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_u
 	/* Non-XSK always uses PAGE_SIZE. */
 	addr = dma_map_page(rq->pdev, au->page, 0, PAGE_SIZE, rq->buff.map_dir);
 	if (unlikely(dma_mapping_error(rq->pdev, addr))) {
-		page_pool_recycle_direct(rq->page_pool, au->page);
+		page_pool_recycle_direct(rq->page_pool, page_netmem(au->page));
 		au->page = NULL;
 		return -ENOMEM;
 	}
@@ -360,7 +360,7 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool rec
 			return;
 
 		mlx5e_page_dma_unmap(rq, page);
-		page_pool_recycle_direct(rq->page_pool, page);
+		page_pool_recycle_direct(rq->page_pool, page_netmem(page));
 	} else {
 		mlx5e_page_dma_unmap(rq, page);
 		page_pool_release_page(rq->page_pool, page);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 5314c064ceae..8bb172aad9f0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -43,7 +43,7 @@ static void lan966x_fdma_rx_free_page(struct lan966x_rx *rx)
 	if (unlikely(!page))
 		return;
 
-	page_pool_recycle_direct(rx->page_pool, page);
+	page_pool_recycle_direct(rx->page_pool, page_netmem(page));
 }
 
 static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
@@ -534,7 +534,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	return skb;
 
 free_page:
-	page_pool_recycle_direct(rx->page_pool, page);
+	page_pool_recycle_direct(rx->page_pool, page_netmem(page));
 
 	return NULL;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6951c976f5d..ce7ff8032038 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5251,7 +5251,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			stmmac_rx_extended_status(priv, &priv->dev->stats,
 					&priv->xstats, rx_q->dma_erx + entry);
 		if (unlikely(status == discard_frame)) {
-			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			page_pool_recycle_direct(rx_q->page_pool,
+						page_netmem(buf->page));
 			buf->page = NULL;
 			error = 1;
 			if (!priv->hwts_rx_en)
@@ -5357,7 +5358,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			skb_put(skb, buf1_len);
 
 			/* Data payload copied into SKB, page ready for recycle */
-			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			page_pool_recycle_direct(rx_q->page_pool,
+						page_netmem(buf->page));
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 13c9c2d6b79b..c2f6ea843fe2 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -380,7 +380,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		}
 
 		/* the interface is going down, pages are purged */
-		page_pool_recycle_direct(pool, page);
+		page_pool_recycle_direct(pool, page_netmem(page));
 		return;
 	}
 
@@ -417,7 +417,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	skb = build_skb(pa, cpsw_rxbuf_total_len(pkt_size));
 	if (!skb) {
 		ndev->stats.rx_dropped++;
-		page_pool_recycle_direct(pool, page);
+		page_pool_recycle_direct(pool, page_netmem(page));
 		goto requeue;
 	}
 
@@ -447,7 +447,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 				       pkt_size, 0);
 	if (ret < 0) {
 		WARN_ON(ret == -ENOMEM);
-		page_pool_recycle_direct(pool, new_page);
+		page_pool_recycle_direct(pool, page_netmem(new_page));
 	}
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 83596ec0c7cb..7432fd0ec8ee 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -324,7 +324,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		}
 
 		/* the interface is going down, pages are purged */
-		page_pool_recycle_direct(pool, page);
+		page_pool_recycle_direct(pool, page_netmem(page));
 		return;
 	}
 
@@ -360,7 +360,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	skb = build_skb(pa, cpsw_rxbuf_total_len(pkt_size));
 	if (!skb) {
 		ndev->stats.rx_dropped++;
-		page_pool_recycle_direct(pool, page);
+		page_pool_recycle_direct(pool, page_netmem(page));
 		goto requeue;
 	}
 
@@ -391,7 +391,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 				       pkt_size, 0);
 	if (ret < 0) {
 		WARN_ON(ret == -ENOMEM);
-		page_pool_recycle_direct(pool, new_page);
+		page_pool_recycle_direct(pool, page_netmem(new_page));
 	}
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 758295c898ac..c3de972743ba 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1131,7 +1131,8 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 				cpsw_err(priv, ifup,
 					 "cannot submit page to channel %d rx, error %d\n",
 					 ch, ret);
-				page_pool_recycle_direct(pool, page);
+				page_pool_recycle_direct(pool,
+							page_netmem(page));
 				return ret;
 			}
 		}
@@ -1378,7 +1379,7 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 out:
 	return ret;
 drop:
-	page_pool_recycle_direct(cpsw->page_pool[ch], page);
+	page_pool_recycle_direct(cpsw->page_pool[ch], page_netmem(page));
 	return ret;
 }
 
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index abe3822a1125..5cff207c33a4 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -478,9 +478,9 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
 
 /* Same as above but the caller must guarantee safe context. e.g NAPI */
 static inline void page_pool_recycle_direct(struct page_pool *pool,
-					    struct page *page)
+					    struct netmem *nmem)
 {
-	page_pool_put_full_page(pool, page, true);
+	page_pool_put_full_netmem(pool, nmem, true);
 }
 
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\

--vDleLtG6VCpo8mjg--
