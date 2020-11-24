Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7442C3240
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgKXU6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:58:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:22179 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbgKXU6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 15:58:39 -0500
IronPort-SDR: pJyJ5J+XzSd2o8rHx/4hf+06TqUtSoOiyE+JrzazTGdOAC8fceZ3zZzMXeP1d4izavQIgTn2i+
 aQfiMP1iKmLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="151855428"
X-IronPort-AV: E=Sophos;i="5.78,367,1599548400"; 
   d="scan'208";a="151855428"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 12:58:38 -0800
IronPort-SDR: PujZX7qaR9LZ6dM64j0ZPCkzoquEy1ghzE7FB9f+UM4WVEMuGcLNSFmW5KZOVL/W4WwCP89APB
 CvLPldzVA+Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,367,1599548400"; 
   d="scan'208";a="546979430"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2020 12:58:36 -0800
Date:   Tue, 24 Nov 2020 21:50:40 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 7/7] dpaa_eth: implement the A050385 erratum
 workaround for XDP
Message-ID: <20201124205040.GA19977@ranger.igk.intel.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <e53e361d320cb901b0d9b9b82e6c16a04fbe6f86.1606150838.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e53e361d320cb901b0d9b9b82e6c16a04fbe6f86.1606150838.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 07:36:25PM +0200, Camelia Groza wrote:
> For XDP TX, even tough we start out with correctly aligned buffers, the
> XDP program might change the data's alignment. For REDIRECT, we have no
> control over the alignment either.
> 
> Create a new workaround for xdp_frame structures to verify the erratum
> conditions and move the data to a fresh buffer if necessary. Create a new
> xdp_frame for managing the new buffer and free the old one using the XDP
> API.
> 
> Due to alignment constraints, all frames have a 256 byte headroom that
> is offered fully to XDP under the erratum. If the XDP program uses all
> of it, the data needs to be move to make room for the xdpf backpointer.

Out of curiosity, wouldn't it be easier to decrease the headroom that is
given to xdp rather doing to full copy of a buffer in case you miss a few
bytes on headroom?

> 
> Disable the metadata support since the information can be lost.
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 82 +++++++++++++++++++++++++-
>  1 file changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 149b549..d8fc19d 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2170,6 +2170,52 @@ static int dpaa_a050385_wa_skb(struct net_device *net_dev, struct sk_buff **s)
>  
>  	return 0;
>  }
> +
> +static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
> +				struct xdp_frame **init_xdpf)
> +{
> +	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
> +	void *new_buff;
> +	struct page *p;
> +
> +	/* Check the data alignment and make sure the headroom is large
> +	 * enough to store the xdpf backpointer. Use an aligned headroom
> +	 * value.
> +	 *
> +	 * Due to alignment constraints, we give XDP access to the full 256
> +	 * byte frame headroom. If the XDP program uses all of it, copy the
> +	 * data to a new buffer and make room for storing the backpointer.
> +	 */
> +	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
> +	    xdpf->headroom >= priv->tx_headroom) {
> +		xdpf->headroom = priv->tx_headroom;
> +		return 0;
> +	}
> +
> +	p = dev_alloc_pages(0);
> +	if (unlikely(!p))
> +		return -ENOMEM;
> +
> +	/* Copy the data to the new buffer at a properly aligned offset */
> +	new_buff = page_address(p);
> +	memcpy(new_buff + priv->tx_headroom, xdpf->data, xdpf->len);
> +
> +	/* Create an XDP frame around the new buffer in a similar fashion
> +	 * to xdp_convert_buff_to_frame.
> +	 */
> +	new_xdpf = new_buff;
> +	new_xdpf->data = new_buff + priv->tx_headroom;
> +	new_xdpf->len = xdpf->len;
> +	new_xdpf->headroom = priv->tx_headroom;

What if ptr was not aligned so you got here but tx_headroom was less than
xdpf->headroom? Shouldn't you choose the bigger one? Aren't you shrinking
the headroom for this case.

> +	new_xdpf->frame_sz = DPAA_BP_RAW_SIZE;
> +	new_xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
> +
> +	/* Release the initial buffer */
> +	xdp_return_frame_rx_napi(xdpf);
> +
> +	*init_xdpf = new_xdpf;
> +	return 0;
> +}
>  #endif
>  
>  static netdev_tx_t
> @@ -2406,6 +2452,15 @@ static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
>  	percpu_priv = this_cpu_ptr(priv->percpu_priv);
>  	percpu_stats = &percpu_priv->stats;
>  
> +#ifdef CONFIG_DPAA_ERRATUM_A050385
> +	if (unlikely(fman_has_errata_a050385())) {
> +		if (dpaa_a050385_wa_xdpf(priv, &xdpf)) {
> +			err = -ENOMEM;
> +			goto out_error;
> +		}
> +	}
> +#endif
> +
>  	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
>  		err = -EINVAL;
>  		goto out_error;
> @@ -2479,6 +2534,20 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
>  	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
>  	xdp.rxq = &dpaa_fq->xdp_rxq;
>  
> +	/* We reserve a fixed headroom of 256 bytes under the erratum and we
> +	 * offer it all to XDP programs to use. If no room is left for the
> +	 * xdpf backpointer on TX, we will need to copy the data.
> +	 * Disable metadata support since data realignments might be required
> +	 * and the information can be lost.
> +	 */
> +#ifdef CONFIG_DPAA_ERRATUM_A050385
> +	if (unlikely(fman_has_errata_a050385())) {
> +		xdp_set_data_meta_invalid(&xdp);
> +		xdp.data_hard_start = vaddr;
> +		xdp.frame_sz = DPAA_BP_RAW_SIZE;
> +	}
> +#endif
> +
>  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
>  
>  	/* Update the length and the offset of the FD */
> @@ -2486,7 +2555,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
>  
>  	switch (xdp_act) {
>  	case XDP_PASS:
> -		*xdp_meta_len = xdp.data - xdp.data_meta;
> +		*xdp_meta_len = xdp_data_meta_unsupported(&xdp) ? 0 :
> +				xdp.data - xdp.data_meta;

You could consider surrounding this with ifdef and keep the old version in
the else branch so that old case is not hurt with that additional branch
that you're introducing with that ternary operator.

>  		break;
>  	case XDP_TX:
>  		/* We can access the full headroom when sending the frame
> @@ -3188,10 +3258,16 @@ static u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
>  	 */
>  	headroom = (u16)(bl[port].priv_data_size + DPAA_HWA_SIZE);
>  
> -	if (port == RX)
> +	if (port == RX) {
> +#ifdef CONFIG_DPAA_ERRATUM_A050385
> +		if (unlikely(fman_has_errata_a050385()))
> +			headroom = XDP_PACKET_HEADROOM;
> +#endif
> +
>  		return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
> -	else
> +	} else {
>  		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
> +	}
>  }
>  
>  static int dpaa_eth_probe(struct platform_device *pdev)
> -- 
> 1.9.1
> 
