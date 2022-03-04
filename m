Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B924CD58E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiCDNyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbiCDNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:54:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1FF154D14
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 05:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646402014; x=1677938014;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=I1A0UXHBKD/FFzjM19qTJWvEipsjj1pVwT2ACXutZL0=;
  b=S+xEDPpVhI2Mpl6AGJXpXT3kBks+nLgnbDE/D4GwSlhAq9EPjxC2lILN
   McK6pa5scWW6qO+A4M4jNpY0Bok6I3mDRmvu1TojDeyrQGWDX/OvcrFps
   zfgh5egNgh2s2VZPwXrLk9BC5090/q86+rFfGOBJvqRbOobAHeEmA35ZC
   REUVJUGHScgy1ZatyJfmCEIlMDy8EKBsfOEcExfzGhhjtTxp1yy/QnAzL
   61/UDvmA9CWByGFCCqIfYGkCLmKO8YEsoXQID+im8kbHwGr2/bW97x6Iu
   JvH0rAjbbz8eJMWJh7dIMWup+0vCbIyGtWRwr3kGX8PzeyCsmDLM+CD1+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="234585569"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="234585569"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 05:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="609948631"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga004.fm.intel.com with ESMTP; 04 Mar 2022 05:53:31 -0800
Date:   Fri, 4 Mar 2022 14:53:30 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 5/5] nfp: xsk: add AF_XDP zero-copy Rx and Tx
 support
Message-ID: <YiIZ2nVNdH2HMTSI@boxer>
References: <20220304102214.25903-1-simon.horman@corigine.com>
 <20220304102214.25903-6-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220304102214.25903-6-simon.horman@corigine.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 11:22:14AM +0100, Simon Horman wrote:
> From: Niklas Söderlund <niklas.soderlund@corigine.com>
> 
> This patch adds zero-copy Rx and Tx support for AF_XDP sockets. It do so
> by adding a separate NAPI poll function that is attached to a each
> channel when the XSK socket is attached with XDP_SETUP_XSK_POOL, and
> restored when the XSK socket is terminated, this is done per channel.
> 
> Support for XDP_TX is implemented and the XDP buffer can safely be moved
> from the Rx to the Tx queue and correctly freed and returned to the XSK
> pool once it's transmitted.
> 
> Note that when AF_XDP zero-copy is enabled, the XDP action XDP_PASS
> will allocate a new buffer and copy the zero-copy frame prior
> passing it to the kernel stack.
> 
> This patch is based on previous work by Jakub Kicinski.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/Makefile   |   1 +
>  drivers/net/ethernet/netronome/nfp/nfp_net.h  |  31 +-
>  .../ethernet/netronome/nfp/nfp_net_common.c   |  98 ++-
>  .../ethernet/netronome/nfp/nfp_net_debugfs.c  |  33 +-
>  .../net/ethernet/netronome/nfp/nfp_net_xsk.c  | 592 ++++++++++++++++++
>  .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |  29 +
>  6 files changed, 756 insertions(+), 28 deletions(-)
>  create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
>  create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h

(...)

> +
> +static void nfp_net_xsk_tx(struct nfp_net_tx_ring *tx_ring)
> +{
> +	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
> +	struct xdp_desc desc[NFP_NET_XSK_TX_BATCH];
> +	struct xsk_buff_pool *xsk_pool;
> +	struct nfp_net_tx_desc *txd;
> +	u32 pkts = 0, wr_idx;
> +	u32 i, got;
> +
> +	xsk_pool = r_vec->xsk_pool;
> +
> +	while (nfp_net_tx_space(tx_ring) >= NFP_NET_XSK_TX_BATCH) {
> +		for (i = 0; i < NFP_NET_XSK_TX_BATCH; i++)
> +			if (!xsk_tx_peek_desc(xsk_pool, &desc[i]))
> +				break;

Please use xsk_tx_peek_release_desc_batch() and avoid your own internal
batching mechanisms. We introduced the array of xdp_descs on xsk_buff_pool
side just for that purpose, so there's no need for having this here on
stack.

I suppose this will also simplify this ZC support.

Dave, could you give us some time for review? It was on list only for few
hours or so and I see it's already applied :<

> +		got = i;
> +		if (!got)
> +			break;
> +
> +		wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
> +		prefetchw(&tx_ring->txds[wr_idx]);
> +
> +		for (i = 0; i < got; i++)
> +			xsk_buff_raw_dma_sync_for_device(xsk_pool, desc[i].addr,
> +							 desc[i].len);
> +
> +		for (i = 0; i < got; i++) {
> +			wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
> +
> +			tx_ring->txbufs[wr_idx].real_len = desc[i].len;
> +			tx_ring->txbufs[wr_idx].is_xsk_tx = false;
> +
> +			/* Build TX descriptor. */
> +			txd = &tx_ring->txds[wr_idx];
> +			nfp_desc_set_dma_addr(txd,
> +					      xsk_buff_raw_get_dma(xsk_pool,
> +								   desc[i].addr
> +								   ));
> +			txd->offset_eop = PCIE_DESC_TX_EOP;
> +			txd->dma_len = cpu_to_le16(desc[i].len);
> +			txd->data_len = cpu_to_le16(desc[i].len);
> +		}
> +
> +		tx_ring->wr_p += got;
> +		pkts += got;
> +	}
> +
> +	if (!pkts)
> +		return;
> +
> +	xsk_tx_release(xsk_pool);
> +	/* Ensure all records are visible before incrementing write counter. */
> +	wmb();
> +	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, pkts);
> +}
> +
> +static bool
> +nfp_net_xsk_tx_xdp(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
> +		   struct nfp_net_rx_ring *rx_ring,
> +		   struct nfp_net_tx_ring *tx_ring,
> +		   struct nfp_net_xsk_rx_buf *xrxbuf, unsigned int pkt_len,
> +		   int pkt_off)
> +{
> +	struct xsk_buff_pool *pool = r_vec->xsk_pool;
> +	struct nfp_net_tx_buf *txbuf;
> +	struct nfp_net_tx_desc *txd;
> +	unsigned int wr_idx;
> +
> +	if (nfp_net_tx_space(tx_ring) < 1)
> +		return false;
> +
> +	xsk_buff_raw_dma_sync_for_device(pool, xrxbuf->dma_addr + pkt_off, pkt_len);
> +
> +	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
> +
> +	txbuf = &tx_ring->txbufs[wr_idx];
> +	txbuf->xdp = xrxbuf->xdp;
> +	txbuf->real_len = pkt_len;
> +	txbuf->is_xsk_tx = true;
> +
> +	/* Build TX descriptor */
> +	txd = &tx_ring->txds[wr_idx];
> +	txd->offset_eop = PCIE_DESC_TX_EOP;
> +	txd->dma_len = cpu_to_le16(pkt_len);
> +	nfp_desc_set_dma_addr(txd, xrxbuf->dma_addr + pkt_off);
> +	txd->data_len = cpu_to_le16(pkt_len);
> +
> +	txd->flags = 0;
> +	txd->mss = 0;
> +	txd->lso_hdrlen = 0;
> +
> +	tx_ring->wr_ptr_add++;
> +	tx_ring->wr_p++;
> +
> +	return true;
> +}
> +
> +static int nfp_net_rx_space(struct nfp_net_rx_ring *rx_ring)
> +{
> +	return rx_ring->cnt - rx_ring->wr_p + rx_ring->rd_p - 1;
> +}
> +
> +static void
> +nfp_net_xsk_rx_bufs_stash(struct nfp_net_rx_ring *rx_ring, unsigned int idx,
> +			  struct xdp_buff *xdp)
> +{
> +	unsigned int headroom;
> +
> +	headroom = xsk_pool_get_headroom(rx_ring->r_vec->xsk_pool);
> +
> +	rx_ring->rxds[idx].fld.reserved = 0;
> +	rx_ring->rxds[idx].fld.meta_len_dd = 0;
> +
> +	rx_ring->xsk_rxbufs[idx].xdp = xdp;
> +	rx_ring->xsk_rxbufs[idx].dma_addr =
> +		xsk_buff_xdp_get_frame_dma(xdp) + headroom;
> +}
> +
> +static void nfp_net_xsk_rx_unstash(struct nfp_net_xsk_rx_buf *rxbuf)
> +{
> +	rxbuf->dma_addr = 0;
> +	rxbuf->xdp = NULL;
> +}
> +
> +static void nfp_net_xsk_rx_free(struct nfp_net_xsk_rx_buf *rxbuf)
> +{
> +	if (rxbuf->xdp)
> +		xsk_buff_free(rxbuf->xdp);
> +
> +	nfp_net_xsk_rx_unstash(rxbuf);
> +}
> +
> +void nfp_net_xsk_rx_bufs_free(struct nfp_net_rx_ring *rx_ring)
> +{
> +	unsigned int i;
> +
> +	if (!rx_ring->cnt)
> +		return;
> +
> +	for (i = 0; i < rx_ring->cnt - 1; i++)
> +		nfp_net_xsk_rx_free(&rx_ring->xsk_rxbufs[i]);
> +}
> +
> +void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring)
> +{
> +	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
> +	struct xsk_buff_pool *pool = r_vec->xsk_pool;
> +	unsigned int wr_idx, wr_ptr_add = 0;
> +	struct xdp_buff *xdp;
> +
> +	while (nfp_net_rx_space(rx_ring)) {
> +		wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
> +
> +		xdp = xsk_buff_alloc(pool);

Could you use xsk_buff_alloc_batch() with nfp_net_rx_space(rx_ring) passed
as requested count of xdp_bufs instead calling xsk_buff_alloc() in a loop?

> +		if (!xdp)
> +			break;
> +
> +		nfp_net_xsk_rx_bufs_stash(rx_ring, wr_idx, xdp);
> +
> +		nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
> +				      rx_ring->xsk_rxbufs[wr_idx].dma_addr);
> +
> +		rx_ring->wr_p++;
> +		wr_ptr_add++;
> +	}
> +
> +	/* Ensure all records are visible before incrementing write counter. */
> +	wmb();
> +	nfp_qcp_wr_ptr_add(rx_ring->qcp_fl, wr_ptr_add);
> +}
> +

(...)
