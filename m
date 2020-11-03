Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F02A5A36
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgKCWnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbgKCWnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 17:43:16 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928C921534;
        Tue,  3 Nov 2020 22:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604443395;
        bh=dTjs010gbJ6VVbLK8IglW33sxZXfD2QRUF5cnzBezyo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eS20A5CLxPhFskV6advnCEHDXwhqCm+t493GdZRn0qObtv+kRgZW+Gq6hf5SEGHPh
         Q+9wM5jtPz3YoehUbHXoQNQA39zCOmZazH6B4wq6Ybon70qptlxH5bNmBEVeM87e28
         PQwk2XW7HYe/gkn7LK8aVCqF0oQsYlArvh4psaJs=
Message-ID: <f4b03d3c70c2b1e19e42d0209e270110b7668039.camel@kernel.org>
Subject: Re: [PATCH 1/4] gve: Add support for raw addressing device option
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Awogbemila <awogbemila@google.com>, netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Date:   Tue, 03 Nov 2020 14:43:14 -0800
In-Reply-To: <20201103174651.590586-2-awogbemila@google.com>
References: <20201103174651.590586-1-awogbemila@google.com>
         <20201103174651.590586-2-awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Add support to describe device for parsing device options. As
> the first device option, add raw addressing.
> 
> "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> operational mode which allows the driver avoid bounce buffer copies
> which it currently performs using pre-allocated qpls
> (queue_page_lists)
> when sending and receiving packets.
> For egress packets, the provided skb data addresses will be
> dma_map'ed and
> passed to the device, allowing the NIC can perform DMA directly - the
> driver will not have to copy the buffer content into pre-allocated
> buffers/qpls (as in qpl mode).
> For ingress packets, copies are also eliminated as buffers are handed
> to
> the networking stack and then recycled or re-allocated as
> necessary, avoiding the use of skb_copy_to_linear_data().
> 
> This patch only introduces the option to the driver.
> Subsequent patches will add the ingress and egress functionality.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h        |  1 +
>  drivers/net/ethernet/google/gve/gve_adminq.c | 52
> ++++++++++++++++++++
>  drivers/net/ethernet/google/gve/gve_adminq.h | 15 ++++--
>  drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
>  4 files changed, 73 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h
> b/drivers/net/ethernet/google/gve/gve.h
> index f5c80229ea96..80cdae06ee39 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -199,6 +199,7 @@ struct gve_priv {
>  	u64 num_registered_pages; /* num pages registered with NIC */
>  	u32 rx_copybreak; /* copy packets smaller than this */
>  	u16 default_num_queues; /* default num queues to set up */
> +	bool raw_addressing; /* true if this dev supports raw
> addressing */
>  
>  	struct gve_queue_config tx_cfg;
>  	struct gve_queue_config rx_cfg;
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c
> b/drivers/net/ethernet/google/gve/gve_adminq.c
> index 24ae6a28a806..0b7a2653fe33 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -460,11 +460,14 @@ int gve_adminq_destroy_rx_queues(struct
> gve_priv *priv, u32 num_queues)
>  int gve_adminq_describe_device(struct gve_priv *priv)
>  {
>  	struct gve_device_descriptor *descriptor;
> +	struct gve_device_option *dev_opt;
>  	union gve_adminq_command cmd;
>  	dma_addr_t descriptor_bus;
> +	u16 num_options;
>  	int err = 0;
>  	u8 *mac;
>  	u16 mtu;
> +	int i;
>  
>  	memset(&cmd, 0, sizeof(cmd));
>  	descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
> @@ -518,6 +521,55 @@ int gve_adminq_describe_device(struct gve_priv
> *priv)
>  		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
>  	}
>  	priv->default_num_queues = be16_to_cpu(descriptor-
> >default_num_queues);
> +	dev_opt = (void *)(descriptor + 1);
> +
> +	num_options = be16_to_cpu(descriptor->num_device_options);
> +	for (i = 0; i < num_options; i++) {
> +		u16 option_length = be16_to_cpu(dev_opt-
> >option_length);
> +		u16 option_id = be16_to_cpu(dev_opt->option_id);
> +		void *option_end;
> +
> +		option_end = (void *)dev_opt + sizeof(*dev_opt) +
> option_length;
> +		if (option_end > (void *)descriptor +
> be16_to_cpu(descriptor->total_length)) {
> +			dev_err(&priv->dev->dev,
> +				"options exceed device_descriptor's
> total length.\n");
> +			err = -EINVAL;
> +			goto free_device_descriptor;
> +		}
> +
> +		switch (option_id) {
> +		case GVE_DEV_OPT_ID_RAW_ADDRESSING:
> +			/* If the length or feature mask doesn't match,
> +			 * continue without enabling the feature.
> +			 */
> +			if (option_length !=
> GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
> +			    dev_opt->feat_mask !=
> +			    cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRE
> SSING)) {
> +				dev_warn(&priv->pdev->dev,
> +					 "Raw addressing option
> error:\n"
> +					 "	Expected: length=%d,
> feature_mask=%x.\n"
> +					 "	Actual: length=%d,
> feature_mask=%x.\n",
> +					 GVE_DEV_OPT_LEN_RAW_ADDRESSING
> ,
> +					 cpu_to_be32(GVE_DEV_OPT_FEAT_M
> ASK_RAW_ADDRESSING),
> +					 option_length, dev_opt-
> >feat_mask);
> +				priv->raw_addressing = false;
> +			} else {
> +				dev_info(&priv->pdev->dev,
> +					 "Raw addressing device option
> enabled.\n");
> +				priv->raw_addressing = true;
> +			}
> +			break;
> +		default:
> +			/* If we don't recognize the option just
> continue
> +			 * without doing anything.
> +			 */
> +			dev_dbg(&priv->pdev->dev,
> +				"Unrecognized device option 0x%hx not
> enabled.\n",
> +				option_id);
> +			break;
> +		}
> +		dev_opt = (void *)dev_opt + sizeof(*dev_opt) +
> option_length;

This was already calculated above, "option_end"


Suggestion: you can make an iterator macro to return the next opt

next_opt = GET_NEXT_OPT(descriptor, curr_opt);

you can make it check boundaries and return null on last iteration or
when total length is exceeded, and just use it in a more readable
iterator loop.


