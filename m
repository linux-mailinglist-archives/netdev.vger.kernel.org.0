Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40438CB24
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 18:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhEUQhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 12:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236370AbhEUQhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 12:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A35D3613E3;
        Fri, 21 May 2021 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621614939;
        bh=fbS4tegkDEGEwjG+qSSclbPKmztmBb0iRMLQXbmx4/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDWMlKelM2KVVp9hgNrNjtTZpPuH/fL6EYO4kccVeu+v1g5bGC7QrXsqnBe5fiCFX
         cSW0/3Ony/CFYht98GfuRxgIYyIxH0liquTJlLSCWXPDFvPhAw3CXIOAO7zkRfQzpx
         JXbNEcN2UZUIyWzf4AnnP5S6ZL/Mbmxyc8C6537o/pojNlSVRBmC9uTbNT/ZVA3qa1
         3lbnSpSKPM+MEN2oS8ZLPMMlRgBYB+aIm0ZwbhNwSufvYgDzLjbCM4xMAinwNDZPLz
         O6nfDJng503NBlqZN7GU4CJuICJjVU9acmY3ABhqhaMLGSFRIslam/zmBo84JZPoul
         taKhEuNR5YwPg==
Date:   Fri, 21 May 2021 22:05:30 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH v2] bus: mhi: Add inbound buffers allocation flag
Message-ID: <20210521163530.GO70095@thinkpad>
References: <1621603519-16773-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621603519-16773-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ netdev, Dave, Jakub

On Fri, May 21, 2021 at 03:25:19PM +0200, Loic Poulain wrote:
> Currently, the MHI controller driver defines which channels should
> have their inbound buffers allocated and queued. But ideally, this is
> something that should be decided by the MHI device driver instead,
> which actually deals with that buffers.
> 
> Add a flag parameter to mhi_prepare_for_transfer allowing to specify
> if buffers have to be allocated and queued by the MHI stack.
> 
> Keep auto_queue flag for now, but should be removed at some point.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Tested-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  v2: Update API in mhi_wwan_ctrl driver
> 
>  drivers/bus/mhi/core/internal.h  |  2 +-
>  drivers/bus/mhi/core/main.c      | 11 ++++++++---
>  drivers/net/mhi/net.c            |  2 +-
>  drivers/net/wwan/mhi_wwan_ctrl.c |  2 +-

Since this patch touches the drivers under net/, I need an Ack from Dave or
Jakub to take it via MHI tree.

Thanks,
Mani

>  include/linux/mhi.h              | 12 +++++++++++-
>  net/qrtr/mhi.c                   |  2 +-
>  6 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
> index 5b9ea66..672052f 100644
> --- a/drivers/bus/mhi/core/internal.h
> +++ b/drivers/bus/mhi/core/internal.h
> @@ -682,7 +682,7 @@ void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
>  		      struct image_info *img_info);
>  void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl);
>  int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> -			struct mhi_chan *mhi_chan);
> +			struct mhi_chan *mhi_chan, enum mhi_chan_flags flags);
>  int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
>  		       struct mhi_chan *mhi_chan);
>  void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
> diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> index 0f1febf..432b53b 100644
> --- a/drivers/bus/mhi/core/main.c
> +++ b/drivers/bus/mhi/core/main.c
> @@ -1384,7 +1384,8 @@ static void mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
>  }
>  
>  int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> -			struct mhi_chan *mhi_chan)
> +			struct mhi_chan *mhi_chan,
> +			enum mhi_chan_flags flags)
>  {
>  	int ret = 0;
>  	struct device *dev = &mhi_chan->mhi_dev->dev;
> @@ -1409,6 +1410,9 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
>  	if (ret)
>  		goto error_pm_state;
>  
> +	if (mhi_chan->dir == DMA_FROM_DEVICE)
> +		mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
> +
>  	/* Pre-allocate buffer for xfer ring */
>  	if (mhi_chan->pre_alloc) {
>  		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
> @@ -1555,7 +1559,8 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
>  }
>  
>  /* Move channel to start state */
> -int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
> +int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
> +			     enum mhi_chan_flags flags)
>  {
>  	int ret, dir;
>  	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
> @@ -1566,7 +1571,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
>  		if (!mhi_chan)
>  			continue;
>  
> -		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
> +		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
>  		if (ret)
>  			goto error_open_chan;
>  	}
> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> index 6b5bf23..3ddfb72 100644
> --- a/drivers/net/mhi/net.c
> +++ b/drivers/net/mhi/net.c
> @@ -323,7 +323,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>  	u64_stats_init(&mhi_netdev->stats.tx_syncp);
>  
>  	/* Start MHI channels */
> -	err = mhi_prepare_for_transfer(mhi_dev);
> +	err = mhi_prepare_for_transfer(mhi_dev, 0);
>  	if (err)
>  		goto out_err;
>  
> diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> index 3a44b22..84e75e4 100644
> --- a/drivers/net/wwan/mhi_wwan_ctrl.c
> +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> @@ -110,7 +110,7 @@ static int mhi_wwan_ctrl_start(struct wwan_port *port)
>  	int ret;
>  
>  	/* Start mhi device's channel(s) */
> -	ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev);
> +	ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev, 0);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> index d095fba..9372acf 100644
> --- a/include/linux/mhi.h
> +++ b/include/linux/mhi.h
> @@ -60,6 +60,14 @@ enum mhi_flags {
>  };
>  
>  /**
> + * enum mhi_chan_flags - MHI channel flags
> + * @MHI_CH_INBOUND_ALLOC_BUFS: Automatically allocate and queue inbound buffers
> + */
> +enum mhi_chan_flags {
> +	MHI_CH_INBOUND_ALLOC_BUFS = BIT(0),
> +};
> +
> +/**
>   * enum mhi_device_type - Device types
>   * @MHI_DEVICE_XFER: Handles data transfer
>   * @MHI_DEVICE_CONTROLLER: Control device
> @@ -719,8 +727,10 @@ void mhi_device_put(struct mhi_device *mhi_dev);
>   *                            host and device execution environments match and
>   *                            channels are in a DISABLED state.
>   * @mhi_dev: Device associated with the channels
> + * @flags: MHI channel flags
>   */
> -int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
> +int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
> +			     enum mhi_chan_flags flags);
>  
>  /**
>   * mhi_unprepare_from_transfer - Reset UL and DL channels for data transfer.
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 2bf2b19..47afded 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -77,7 +77,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	int rc;
>  
>  	/* start channels */
> -	rc = mhi_prepare_for_transfer(mhi_dev);
> +	rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
>  	if (rc)
>  		return rc;
>  
> -- 
> 2.7.4
> 
