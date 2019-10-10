Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4429D24CB
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390036AbfJJIux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388623AbfJJIuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF80810CC1E3;
        Thu, 10 Oct 2019 08:50:51 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E92C560BF4;
        Thu, 10 Oct 2019 08:50:41 +0000 (UTC)
Date:   Thu, 10 Oct 2019 10:50:40 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [PATCH v2 net-next 5/8] net: mvneta: add basic XDP support
Message-ID: <20191010105040.23e5e86f@carbon>
In-Reply-To: <0f471851967abb980d34104b64fea013b0dced7c.1570662004.git.lorenzo@kernel.org>
References: <cover.1570662004.git.lorenzo@kernel.org>
        <0f471851967abb980d34104b64fea013b0dced7c.1570662004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Thu, 10 Oct 2019 08:50:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 01:18:35 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Add basic XDP support to mvneta driver for devices that rely on software
> buffer management. Currently supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT
> - XDP_ABORTED
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 144 ++++++++++++++++++++++++--
>  1 file changed, 135 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index ba4aa9bbc798..e2795dddbcaf 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
[...]

> @@ -1950,16 +1960,60 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
>  	return i;
>  }
>  
> +static int
> +mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
> +	       struct xdp_buff *xdp)
> +{
> +	u32 ret, act = bpf_prog_run_xdp(prog, xdp);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		ret = MVNETA_XDP_PASS;
> +		break;
> +	case XDP_REDIRECT: {
> +		int err;
> +
> +		err = xdp_do_redirect(pp->dev, xdp, prog);
> +		if (err) {
> +			ret = MVNETA_XDP_CONSUMED;
> +			xdp_return_buff(xdp);

> +		} else {
> +			ret = MVNETA_XDP_REDIR;
> +		}
> +		break;
> +	}
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(pp->dev, prog, act);
> +		/* fall through */
> +	case XDP_DROP:
> +		ret = MVNETA_XDP_CONSUMED;
> +		xdp_return_buff(xdp);

Using xdp_return_buff() here is actually not optimal for performance.
I can see that others socionext/netsec.c and AF_XDP also use this
xdp_return_buff().

I do think code wise it looks a lot nice to use xdp_return_buff(), so
maybe we should optimize xdp_return_buff(), instead of using
page_pool_recycle_direct() here?  (That would also help AF_XDP ?)

The problem with xdp_return_buff() is that it does a "full" lookup from
the mem.id (xdp_buff->xdp_rxq_info->mem.id) to find the "allocator"
pointer in this case the page_pool pointer.  Here in the driver we
already have access to the stable allocator page_pool pointer via
struct mvneta_rx_queue *rxq->page_pool.


> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  static int
>  mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  		     struct mvneta_rx_desc *rx_desc,
>  		     struct mvneta_rx_queue *rxq,
> -		     struct page *page)
> +		     struct bpf_prog *xdp_prog,
> +		     struct page *page, u32 *xdp_ret)
>  {
>  	unsigned char *data = page_address(page);
>  	int data_len = -MVNETA_MH_SIZE, len;
>  	struct net_device *dev = pp->dev;
>  	enum dma_data_direction dma_dir;
> +	struct xdp_buff xdp = {
> +		.data_hard_start = data,
> +		.data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE,
> +		.rxq = &rxq->xdp_rxq,
> +	};

Creating the struct xdp_buff (on call-stack) this way is not optimal
for performance (IHMO it looks nicer code-wise, but too bad).

This kind of initialization of only some of the members, cause GCC to
zero out other members (I observed this on Intel, which use an
expensive rep-sto operation).  Thus, this cause extra unnecessary memory
writes.

A further optimization, is that you can avoid re-assigning:
 rxq = &rxq->xdp_rxq
for each frame, as this actually stays the same for all the frames in
this NAPI cycle.  By instead allocating the xdp_buff on the callers
stack, and parsing in xdp_buff as a pointer.


> +	xdp_set_data_meta_invalid(&xdp);
>  
>  	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
>  		len = MVNETA_MAX_RX_BUF_SIZE;
> @@ -1968,13 +2022,27 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  		len = rx_desc->data_size;
>  		data_len += len - ETH_FCS_LEN;
>  	}
> +	xdp.data_end = xdp.data + data_len;
>  
>  	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
>  	dma_sync_single_range_for_cpu(dev->dev.parent,
>  				      rx_desc->buf_phys_addr, 0,
>  				      len, dma_dir);
>  
> -	rxq->skb = build_skb(data, PAGE_SIZE);
> +	if (xdp_prog) {
> +		u32 ret;
> +
> +		ret = mvneta_run_xdp(pp, xdp_prog, &xdp);
> +		if (ret != MVNETA_XDP_PASS) {
> +			mvneta_update_stats(pp, 1, xdp.data_end - xdp.data,
> +					    false);
> +			rx_desc->buf_phys_addr = 0;
> +			*xdp_ret |= ret;
> +			return ret;
> +		}
> +	}
> +
> +	rxq->skb = build_skb(xdp.data_hard_start, PAGE_SIZE);
>  	if (unlikely(!rxq->skb)) {
>  		netdev_err(dev,
>  			   "Can't allocate skb on queue %d\n",
[...]

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
