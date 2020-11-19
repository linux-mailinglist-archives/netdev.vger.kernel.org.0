Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641FF2B9EF7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgKSX7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:59:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:45450 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKSX7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 18:59:12 -0500
IronPort-SDR: r0eFVgMMOZZheHMy1CTVJDc4Ci9budgOmYovCSjCh339USF1xu2b9ZB+bYqjGFeg4ZxSlns5Ju
 8absZo5HxFXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="150653337"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="150653337"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 15:59:11 -0800
IronPort-SDR: O5T0HeilPFqzAdmHGd784uCm5pfve9glzuzYODE+lXK+/jQGn4wDfiaPBRhVaUJr4uvDap8RR3
 9xeF61C+314Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="534973224"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 19 Nov 2020 15:59:09 -0800
Date:   Fri, 20 Nov 2020 00:50:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
Message-ID: <20201119235034.GA24983@ranger.igk.intel.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <aa8bbb5c404f57fdb7915eb236305a177800becb.1605802951.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa8bbb5c404f57fdb7915eb236305a177800becb.1605802951.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 06:29:33PM +0200, Camelia Groza wrote:
> Use an xdp_frame structure for managing the frame. Store a backpointer to
> the structure at the start of the buffer before enqueueing. Use the XDP
> API for freeing the buffer when it returns to the driver on the TX
> confirmation path.

Completion path?

> 
> This approach will be reused for XDP REDIRECT.
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 129 ++++++++++++++++++++++++-
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
>  2 files changed, 126 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 242ed45..cd5f4f6 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -1130,6 +1130,24 @@ static int dpaa_fq_init(struct dpaa_fq *dpaa_fq, bool td_enable)
>  
>  	dpaa_fq->fqid = qman_fq_fqid(fq);
>  
> +	if (dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
> +	    dpaa_fq->fq_type == FQ_TYPE_RX_PCD) {
> +		err = xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq->net_dev,
> +				       dpaa_fq->fqid);
> +		if (err) {
> +			dev_err(dev, "xdp_rxq_info_reg failed\n");

Print out the err?

Also, shouldn't you call qman_destroy_fq() for these error paths?

> +			return err;
> +		}
> +
> +		err = xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
> +						 MEM_TYPE_PAGE_ORDER0, NULL);
> +		if (err) {
> +			dev_err(dev, "xdp_rxq_info_reg_mem_model failed\n");
> +			xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> +			return err;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1159,6 +1177,10 @@ static int dpaa_fq_free_entry(struct device *dev, struct qman_fq *fq)
>  		}
>  	}
>  
> +	if (dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
> +	    dpaa_fq->fq_type == FQ_TYPE_RX_PCD)

You should call xdp_rxq_info_is_reg() before the unregister below.

> +		xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> +
>  	qman_destroy_fq(fq);
>  	list_del(&dpaa_fq->list);
>  
> @@ -1625,6 +1647,9 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
>   *
>   * Return the skb backpointer, since for S/G frames the buffer containing it
>   * gets freed here.
> + *
> + * No skb backpointer is set when transmitting XDP frames. Cleanup the buffer
> + * and return NULL in this case.
>   */
>  static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
>  					  const struct qm_fd *fd, bool ts)
> @@ -1636,6 +1661,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
>  	void *vaddr = phys_to_virt(addr);
>  	const struct qm_sg_entry *sgt;
>  	struct dpaa_eth_swbp *swbp;
> +	struct xdp_frame *xdpf;

This local variable feels a bit unnecessary.

>  	struct sk_buff *skb;
>  	u64 ns;
>  	int i;
> @@ -1664,13 +1690,22 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
>  		}
>  	} else {
>  		dma_unmap_single(priv->tx_dma_dev, addr,
> -				 priv->tx_headroom + qm_fd_get_length(fd),
> +				 qm_fd_get_offset(fd) + qm_fd_get_length(fd),
>  				 dma_dir);
>  	}
>  
>  	swbp = (struct dpaa_eth_swbp *)vaddr;
>  	skb = swbp->skb;
>  
> +	/* No skb backpointer is set when running XDP. An xdp_frame
> +	 * backpointer is saved instead.
> +	 */
> +	if (!skb) {
> +		xdpf = swbp->xdpf;
> +		xdp_return_frame(xdpf);
> +		return NULL;
> +	}
> +
>  	/* DMA unmapping is required before accessing the HW provided info */
>  	if (ts && priv->tx_tstamp &&
>  	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> @@ -2350,11 +2385,76 @@ static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
>  	return qman_cb_dqrr_consume;
>  }
>  
> +static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
> +			       struct xdp_frame *xdpf)
> +{
> +	struct dpaa_priv *priv = netdev_priv(net_dev);
> +	struct rtnl_link_stats64 *percpu_stats;
> +	struct dpaa_percpu_priv *percpu_priv;
> +	struct dpaa_eth_swbp *swbp;
> +	struct netdev_queue *txq;
> +	void *buff_start;
> +	struct qm_fd fd;
> +	dma_addr_t addr;
> +	int err;
> +
> +	percpu_priv = this_cpu_ptr(priv->percpu_priv);
> +	percpu_stats = &percpu_priv->stats;
> +
> +	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {

Could you shed some light on DPAA_TX_PRIV_DATA_SIZE usage?

> +		err = -EINVAL;
> +		goto out_error;
> +	}
> +
> +	buff_start = xdpf->data - xdpf->headroom;
> +
> +	/* Leave empty the skb backpointer at the start of the buffer.
> +	 * Save the XDP frame for easy cleanup on confirmation.
> +	 */
> +	swbp = (struct dpaa_eth_swbp *)buff_start;
> +	swbp->skb = NULL;
> +	swbp->xdpf = xdpf;
> +
> +	qm_fd_clear_fd(&fd);
> +	fd.bpid = FSL_DPAA_BPID_INV;
> +	fd.cmd |= cpu_to_be32(FM_FD_CMD_FCO);
> +	qm_fd_set_contig(&fd, xdpf->headroom, xdpf->len);
> +
> +	addr = dma_map_single(priv->tx_dma_dev, buff_start,
> +			      xdpf->headroom + xdpf->len,
> +			      DMA_TO_DEVICE);
> +	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
> +		err = -EINVAL;
> +		goto out_error;
> +	}
> +
> +	qm_fd_addr_set64(&fd, addr);
> +
> +	/* Bump the trans_start */
> +	txq = netdev_get_tx_queue(net_dev, smp_processor_id());
> +	txq->trans_start = jiffies;
> +
> +	err = dpaa_xmit(priv, percpu_stats, smp_processor_id(), &fd);

So it looks like you don't provide the XDP Tx resources and you share the
netstack's Tx queues with XDP, if I'm reading this right.

Please mention it/explain in the cover letter or commit message of this
patch. Furthermore, I don't see any locking happenning over here?

> +	if (err) {
> +		dma_unmap_single(priv->tx_dma_dev, addr,
> +				 qm_fd_get_offset(&fd) + qm_fd_get_length(&fd),
> +				 DMA_TO_DEVICE);
> +		goto out_error;
> +	}
> +
> +	return 0;
> +
> +out_error:
> +	percpu_stats->tx_errors++;
> +	return err;
> +}
> +
>  static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
> -			unsigned int *xdp_meta_len)
> +			struct dpaa_fq *dpaa_fq, unsigned int *xdp_meta_len)
>  {
>  	ssize_t fd_off = qm_fd_get_offset(fd);
>  	struct bpf_prog *xdp_prog;
> +	struct xdp_frame *xdpf;
>  	struct xdp_buff xdp;
>  	u32 xdp_act;
>  
> @@ -2370,7 +2470,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
>  	xdp.data_meta = xdp.data;
>  	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
>  	xdp.data_end = xdp.data + qm_fd_get_length(fd);
> -	xdp.frame_sz = DPAA_BP_RAW_SIZE;
> +	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> +	xdp.rxq = &dpaa_fq->xdp_rxq;
>  
>  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
>  
> @@ -2381,6 +2482,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
>  	case XDP_PASS:
>  		*xdp_meta_len = xdp.data - xdp.data_meta;
>  		break;
> +	case XDP_TX:
> +		/* We can access the full headroom when sending the frame
> +		 * back out

And normally why a piece of headroom is taken away? I probably should have
started from the basic XDP support patch, but if you don't mind, please
explain it a bit.

> +		 */
> +		xdp.data_hard_start = vaddr;
> +		xdp.frame_sz = DPAA_BP_RAW_SIZE;
> +		xdpf = xdp_convert_buff_to_frame(&xdp);
> +		if (unlikely(!xdpf)) {
> +			free_pages((unsigned long)vaddr, 0);
> +			break;
> +		}
> +
> +		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
> +			xdp_return_frame_rx_napi(xdpf);
> +
> +		break;
>  	default:
>  		bpf_warn_invalid_xdp_action(xdp_act);
>  		fallthrough;
> @@ -2415,6 +2532,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
>  	u32 fd_status, hash_offset;
>  	struct qm_sg_entry *sgt;
>  	struct dpaa_bp *dpaa_bp;
> +	struct dpaa_fq *dpaa_fq;
>  	struct dpaa_priv *priv;
>  	struct sk_buff *skb;
>  	int *count_ptr;
> @@ -2423,9 +2541,10 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
>  	u32 hash;
>  	u64 ns;
>  
> +	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
>  	fd_status = be32_to_cpu(fd->status);
>  	fd_format = qm_fd_get_format(fd);
> -	net_dev = ((struct dpaa_fq *)fq)->net_dev;
> +	net_dev = dpaa_fq->net_dev;
>  	priv = netdev_priv(net_dev);
>  	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
>  	if (!dpaa_bp)
> @@ -2494,7 +2613,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
>  
>  	if (likely(fd_format == qm_fd_contig)) {
>  		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> -				       &xdp_meta_len);
> +				       dpaa_fq, &xdp_meta_len);
>  		if (xdp_act != XDP_PASS) {
>  			percpu_stats->rx_packets++;
>  			percpu_stats->rx_bytes += qm_fd_get_length(fd);
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> index 94e8613..5c8d52a 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> @@ -68,6 +68,7 @@ struct dpaa_fq {
>  	u16 channel;
>  	u8 wq;
>  	enum dpaa_fq_type fq_type;
> +	struct xdp_rxq_info xdp_rxq;
>  };
>  
>  struct dpaa_fq_cbs {
> @@ -150,6 +151,7 @@ struct dpaa_buffer_layout {
>   */
>  struct dpaa_eth_swbp {
>  	struct sk_buff *skb;
> +	struct xdp_frame *xdpf;
>  };
>  
>  struct dpaa_priv {
> -- 
> 1.9.1
> 
