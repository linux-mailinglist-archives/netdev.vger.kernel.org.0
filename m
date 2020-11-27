Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81FC2C6803
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 15:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgK0Ohk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 09:37:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:18262 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbgK0Ohk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 09:37:40 -0500
IronPort-SDR: 9x+NQZY/ESsg6SfUQceoijLGhFwOBl2RaTfBTYb2S+f50c730dHS7vrotUdTudEHtcojnOp+Lr
 tqCTxh0Lo4oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9817"; a="168898768"
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="168898768"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2020 06:37:39 -0800
IronPort-SDR: DkQQ7MSX6HgC8GKV7EEhQZqotAjWrVe30YrtU2RvocTcJqTsIb239O378xVYbkIJPNr8KbSfpV
 rkjCJRoQJkQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="333699992"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga006.jf.intel.com with ESMTP; 27 Nov 2020 06:37:37 -0800
Date:   Fri, 27 Nov 2020 15:29:19 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
Message-ID: <20201127142919.GB26825@ranger.igk.intel.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <6491d6ba855c7e736383e7f603321fe7184681bc.1606150838.git.camelia.groza@nxp.com>
 <20201124195204.GC12808@ranger.igk.intel.com>
 <VI1PR04MB5807BAB32C7B43C752C7B662F2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5807BAB32C7B43C752C7B662F2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 03:49:45PM +0000, Camelia Alexandra Groza wrote:
> > -----Original Message-----
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Sent: Tuesday, November 24, 2020 21:52
> > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > davem@davemloft.net; Madalin Bucur (OSS)
> > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
> > 
> > On Mon, Nov 23, 2020 at 07:36:22PM +0200, Camelia Groza wrote:
> > > Use an xdp_frame structure for managing the frame. Store a backpointer
> > to
> > > the structure at the start of the buffer before enqueueing for cleanup
> > > on TX confirmation. Reserve DPAA_TX_PRIV_DATA_SIZE bytes from the
> > frame
> > > size shared with the XDP program for this purpose. Use the XDP
> > > API for freeing the buffer when it returns to the driver on the TX
> > > confirmation path.
> > >
> > > The frame queues are shared with the netstack.
> > 
> > Can you also provide the info from cover letter about locklessness (is
> > that even a word?) in here?
> 
> Sure.
> 
> > One question below and:
> > 
> > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > 
> > >
> > > This approach will be reused for XDP REDIRECT.
> > >
> > > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > > ---
> > > Changes in v4:
> > > - call xdp_rxq_info_is_reg() before unregistering
> > > - minor cleanups (remove unneeded variable, print error code)
> > > - add more details in the commit message
> > > - did not call qman_destroy_fq() in case of xdp_rxq_info_reg() failure
> > > since it would lead to a double free of the fq resources
> > >
> > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 128
> > ++++++++++++++++++++++++-
> > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> > >  2 files changed, 125 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > index ee076f4..0deffcc 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > @@ -1130,6 +1130,24 @@ static int dpaa_fq_init(struct dpaa_fq *dpaa_fq,
> > bool td_enable)
> > >
> > >  	dpaa_fq->fqid = qman_fq_fqid(fq);
> > >
> > > +	if (dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
> > > +	    dpaa_fq->fq_type == FQ_TYPE_RX_PCD) {
> > > +		err = xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq-
> > >net_dev,
> > > +				       dpaa_fq->fqid);
> > > +		if (err) {
> > > +			dev_err(dev, "xdp_rxq_info_reg() = %d\n", err);
> > > +			return err;
> > > +		}
> > > +
> > > +		err = xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
> > > +						 MEM_TYPE_PAGE_ORDER0,
> > NULL);
> > > +		if (err) {
> > > +			dev_err(dev, "xdp_rxq_info_reg_mem_model() =
> > %d\n", err);
> > > +			xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > > +			return err;
> > > +		}
> > > +	}
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -1159,6 +1177,11 @@ static int dpaa_fq_free_entry(struct device
> > *dev, struct qman_fq *fq)
> > >  		}
> > >  	}
> > >
> > > +	if ((dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
> > > +	     dpaa_fq->fq_type == FQ_TYPE_RX_PCD) &&
> > > +	    xdp_rxq_info_is_reg(&dpaa_fq->xdp_rxq))
> > > +		xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > > +
> > >  	qman_destroy_fq(fq);
> > >  	list_del(&dpaa_fq->list);
> > >
> > > @@ -1625,6 +1648,9 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv
> > *priv)
> > >   *
> > >   * Return the skb backpointer, since for S/G frames the buffer containing it
> > >   * gets freed here.
> > > + *
> > > + * No skb backpointer is set when transmitting XDP frames. Cleanup the
> > buffer
> > > + * and return NULL in this case.
> > >   */
> > >  static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
> > >  					  const struct qm_fd *fd, bool ts)
> > > @@ -1664,13 +1690,21 @@ static struct sk_buff
> > *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
> > >  		}
> > >  	} else {
> > >  		dma_unmap_single(priv->tx_dma_dev, addr,
> > > -				 priv->tx_headroom +
> > qm_fd_get_length(fd),
> > > +				 qm_fd_get_offset(fd) +
> > qm_fd_get_length(fd),
> > >  				 dma_dir);
> > >  	}
> > >
> > >  	swbp = (struct dpaa_eth_swbp *)vaddr;
> > >  	skb = swbp->skb;
> > >
> > > +	/* No skb backpointer is set when running XDP. An xdp_frame
> > > +	 * backpointer is saved instead.
> > > +	 */
> > > +	if (!skb) {
> > > +		xdp_return_frame(swbp->xdpf);
> > > +		return NULL;
> > > +	}
> > > +
> > >  	/* DMA unmapping is required before accessing the HW provided
> > info */
> > >  	if (ts && priv->tx_tstamp &&
> > >  	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > > @@ -2350,11 +2384,76 @@ static enum qman_cb_dqrr_result
> > rx_error_dqrr(struct qman_portal *portal,
> > >  	return qman_cb_dqrr_consume;
> > >  }
> > >
> > > +static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
> > > +			       struct xdp_frame *xdpf)
> > > +{
> > > +	struct dpaa_priv *priv = netdev_priv(net_dev);
> > > +	struct rtnl_link_stats64 *percpu_stats;
> > > +	struct dpaa_percpu_priv *percpu_priv;
> > > +	struct dpaa_eth_swbp *swbp;
> > > +	struct netdev_queue *txq;
> > > +	void *buff_start;
> > > +	struct qm_fd fd;
> > > +	dma_addr_t addr;
> > > +	int err;
> > > +
> > > +	percpu_priv = this_cpu_ptr(priv->percpu_priv);
> > > +	percpu_stats = &percpu_priv->stats;
> > > +
> > > +	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
> > > +		err = -EINVAL;
> > > +		goto out_error;
> > > +	}
> > > +
> > > +	buff_start = xdpf->data - xdpf->headroom;
> > > +
> > > +	/* Leave empty the skb backpointer at the start of the buffer.
> > > +	 * Save the XDP frame for easy cleanup on confirmation.
> > > +	 */
> > > +	swbp = (struct dpaa_eth_swbp *)buff_start;
> > > +	swbp->skb = NULL;
> > > +	swbp->xdpf = xdpf;
> > > +
> > > +	qm_fd_clear_fd(&fd);
> > > +	fd.bpid = FSL_DPAA_BPID_INV;
> > > +	fd.cmd |= cpu_to_be32(FM_FD_CMD_FCO);
> > > +	qm_fd_set_contig(&fd, xdpf->headroom, xdpf->len);
> > > +
> > > +	addr = dma_map_single(priv->tx_dma_dev, buff_start,
> > > +			      xdpf->headroom + xdpf->len,
> > > +			      DMA_TO_DEVICE);
> > 
> > Not sure if I asked that.  What is the purpose for including the headroom
> > in frame being set? I would expect to take into account only frame from
> > xdpf->data.
> 
> The xdpf headroom becomes the fd's offset, the area before the data where the backpointers for cleanup are stored. This area isn't sent out with the frame.

But if I'm reading this right you clearly include the headroom space in
the DMA region that you are mapping. Why this couldn't be:

	addr = dma_map_single(priv->tx_dma_dev, xdpf->data,
			      xdpf->len, DMA_TO_DEVICE);

And then frame descriptor wouldn't need to have the offset at all?
Probably that's implementation details, but this way it seems
cleaner/easier to follow to me.

> 
> > > +	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
> > > +		err = -EINVAL;
> > > +		goto out_error;
> > > +	}
> > > +
> > > +	qm_fd_addr_set64(&fd, addr);
> > > +
> > > +	/* Bump the trans_start */
> > > +	txq = netdev_get_tx_queue(net_dev, smp_processor_id());
> > > +	txq->trans_start = jiffies;
> > > +
> > > +	err = dpaa_xmit(priv, percpu_stats, smp_processor_id(), &fd);
> > > +	if (err) {
> > > +		dma_unmap_single(priv->tx_dma_dev, addr,
> > > +				 qm_fd_get_offset(&fd) +
> > qm_fd_get_length(&fd),
> > > +				 DMA_TO_DEVICE);
> > > +		goto out_error;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +out_error:
> > > +	percpu_stats->tx_errors++;
> > > +	return err;
> > > +}
> > > +
> > >  static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void
> > *vaddr,
> > > -			unsigned int *xdp_meta_len)
> > > +			struct dpaa_fq *dpaa_fq, unsigned int
> > *xdp_meta_len)
> > >  {
> > >  	ssize_t fd_off = qm_fd_get_offset(fd);
> > >  	struct bpf_prog *xdp_prog;
> > > +	struct xdp_frame *xdpf;
> > >  	struct xdp_buff xdp;
> > >  	u32 xdp_act;
> > >
> > > @@ -2370,7 +2469,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> > struct qm_fd *fd, void *vaddr,
> > >  	xdp.data_meta = xdp.data;
> > >  	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
> > >  	xdp.data_end = xdp.data + qm_fd_get_length(fd);
> > > -	xdp.frame_sz = DPAA_BP_RAW_SIZE;
> > > +	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > > +	xdp.rxq = &dpaa_fq->xdp_rxq;
> > >
> > >  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > >
> > > @@ -2381,6 +2481,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> > struct qm_fd *fd, void *vaddr,
> > >  	case XDP_PASS:
> > >  		*xdp_meta_len = xdp.data - xdp.data_meta;
> > >  		break;
> > > +	case XDP_TX:
> > > +		/* We can access the full headroom when sending the frame
> > > +		 * back out
> > > +		 */
> > > +		xdp.data_hard_start = vaddr;
> > > +		xdp.frame_sz = DPAA_BP_RAW_SIZE;
> > > +		xdpf = xdp_convert_buff_to_frame(&xdp);
> > > +		if (unlikely(!xdpf)) {
> > > +			free_pages((unsigned long)vaddr, 0);
> > > +			break;
> > > +		}
> > > +
> > > +		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
> > > +			xdp_return_frame_rx_napi(xdpf);
> > > +
> > > +		break;
> > >  	default:
> > >  		bpf_warn_invalid_xdp_action(xdp_act);
> > >  		fallthrough;
> > > @@ -2415,6 +2531,7 @@ static enum qman_cb_dqrr_result
> > rx_default_dqrr(struct qman_portal *portal,
> > >  	u32 fd_status, hash_offset;
> > >  	struct qm_sg_entry *sgt;
> > >  	struct dpaa_bp *dpaa_bp;
> > > +	struct dpaa_fq *dpaa_fq;
> > >  	struct dpaa_priv *priv;
> > >  	struct sk_buff *skb;
> > >  	int *count_ptr;
> > > @@ -2423,9 +2540,10 @@ static enum qman_cb_dqrr_result
> > rx_default_dqrr(struct qman_portal *portal,
> > >  	u32 hash;
> > >  	u64 ns;
> > >
> > > +	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
> > >  	fd_status = be32_to_cpu(fd->status);
> > >  	fd_format = qm_fd_get_format(fd);
> > > -	net_dev = ((struct dpaa_fq *)fq)->net_dev;
> > > +	net_dev = dpaa_fq->net_dev;
> > >  	priv = netdev_priv(net_dev);
> > >  	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
> > >  	if (!dpaa_bp)
> > > @@ -2494,7 +2612,7 @@ static enum qman_cb_dqrr_result
> > rx_default_dqrr(struct qman_portal *portal,
> > >
> > >  	if (likely(fd_format == qm_fd_contig)) {
> > >  		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > > -				       &xdp_meta_len);
> > > +				       dpaa_fq, &xdp_meta_len);
> > >  		if (xdp_act != XDP_PASS) {
> > >  			percpu_stats->rx_packets++;
> > >  			percpu_stats->rx_bytes += qm_fd_get_length(fd);
> > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > index 94e8613..5c8d52a 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > > @@ -68,6 +68,7 @@ struct dpaa_fq {
> > >  	u16 channel;
> > >  	u8 wq;
> > >  	enum dpaa_fq_type fq_type;
> > > +	struct xdp_rxq_info xdp_rxq;
> > >  };
> > >
> > >  struct dpaa_fq_cbs {
> > > @@ -150,6 +151,7 @@ struct dpaa_buffer_layout {
> > >   */
> > >  struct dpaa_eth_swbp {
> > >  	struct sk_buff *skb;
> > > +	struct xdp_frame *xdpf;
> > >  };
> > >
> > >  struct dpaa_priv {
> > > --
> > > 1.9.1
> > >
