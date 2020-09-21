Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129B5273215
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgIUSmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:42:19 -0400
Received: from z5.mailgun.us ([104.130.96.5]:52522 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIUSmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 14:42:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600713738; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=c5mtWHfIaxLFoxw+EoRdIaIWvc6kNm56/MgQRovBjK4=;
 b=qInynERikoLGtMbut4X8mmipvYupTvv3XyZXj4O1eM3GqYGSQnp36GUWAgJhWqYHI6TugsZz
 3VUC3e6xeXALlJNi3ap4IUDwA7xPL+QVCvcVQYclzP6DtAQ8qcEATwKkwCLyC7ejL6OE8C0I
 qXLF21JP9VUy2GwbCe5zeVWIVDE=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f68f40936c8ce93e83b2ada (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Sep 2020 18:42:17
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6AEA0C433F1; Mon, 21 Sep 2020 18:42:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA581C433C8;
        Mon, 21 Sep 2020 18:42:16 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Sep 2020 11:42:16 -0700
From:   bbhatt@codeaurora.org
To:     Loic Poulain <loic.poulain@linaro.org>, clew@codeaurora.org
Cc:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 1/2] bus: mhi: Remove auto-start option
In-Reply-To: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
Message-ID: <20b95a1bd31bedc20ce03c5efc1bdd02@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-21 00:43, Loic Poulain wrote:
> There is really no point having an auto-start for channels.
> This is confusing for the device drivers, some have to enable the
> channels, others don't have... and waste resources (e.g. pre allocated
> buffers) that may never be used.
> 
> This is really up to the MHI device(channel) driver to manage the state
> of its channels.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: split MHI and qrtr changes in dedicated commits
> 
>  drivers/bus/mhi/core/init.c     | 9 ---------
>  drivers/bus/mhi/core/internal.h | 1 -
>  include/linux/mhi.h             | 2 --
>  3 files changed, 12 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> index dccc824..8798deb 100644
> --- a/drivers/bus/mhi/core/init.c
> +++ b/drivers/bus/mhi/core/init.c
> @@ -721,7 +721,6 @@ static int parse_ch_cfg(struct mhi_controller 
> *mhi_cntrl,
>  		mhi_chan->offload_ch = ch_cfg->offload_channel;
>  		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
>  		mhi_chan->pre_alloc = ch_cfg->auto_queue;
> -		mhi_chan->auto_start = ch_cfg->auto_start;
> 
>  		/*
>  		 * If MHI host allocates buffers, then the channel direction
> @@ -1119,11 +1118,6 @@ static int mhi_driver_probe(struct device *dev)
>  			goto exit_probe;
> 
>  		ul_chan->xfer_cb = mhi_drv->ul_xfer_cb;
> -		if (ul_chan->auto_start) {
> -			ret = mhi_prepare_channel(mhi_cntrl, ul_chan);
> -			if (ret)
> -				goto exit_probe;
> -		}
>  	}
> 
>  	ret = -EINVAL;
> @@ -1157,9 +1151,6 @@ static int mhi_driver_probe(struct device *dev)
>  	if (ret)
>  		goto exit_probe;
> 
> -	if (dl_chan && dl_chan->auto_start)
> -		mhi_prepare_channel(mhi_cntrl, dl_chan);
> -
>  	mhi_device_put(mhi_dev);
> 
>  	return ret;
> diff --git a/drivers/bus/mhi/core/internal.h 
> b/drivers/bus/mhi/core/internal.h
> index 5a81a42..73b52a0 100644
> --- a/drivers/bus/mhi/core/internal.h
> +++ b/drivers/bus/mhi/core/internal.h
> @@ -563,7 +563,6 @@ struct mhi_chan {
>  	bool configured;
>  	bool offload_ch;
>  	bool pre_alloc;
> -	bool auto_start;
>  	bool wake_capable;
>  };
> 
> diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> index 811e686..0d277c7 100644
> --- a/include/linux/mhi.h
> +++ b/include/linux/mhi.h
> @@ -214,7 +214,6 @@ enum mhi_db_brst_mode {
>   * @offload_channel: The client manages the channel completely
>   * @doorbell_mode_switch: Channel switches to doorbell mode on M0 
> transition
>   * @auto_queue: Framework will automatically queue buffers for DL 
> traffic
> - * @auto_start: Automatically start (open) this channel
>   * @wake-capable: Channel capable of waking up the system
>   */
>  struct mhi_channel_config {
> @@ -232,7 +231,6 @@ struct mhi_channel_config {
>  	bool offload_channel;
>  	bool doorbell_mode_switch;
>  	bool auto_queue;
> -	bool auto_start;
>  	bool wake_capable;
>  };

Chris, are you OK with this? It will change the current behavior where 
MHI will
not start the up link channel before providing QRTR with a probe.
