Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284AD2968A4
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 05:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460270AbgJWDGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 23:06:41 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:54653 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460266AbgJWDGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 23:06:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603422400; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Nr9BZucj8jUtuCRAiR0LM44wljXrRqbutLb2S4Vohfk=; b=T62EDT6FYQ5oNt6Xpzxtvm99P6/Z4K78vhQQOmxjsFbVMVgOpXAVQw+LJnD/g3dOdxDhJ6Rk
 YWZtqVJnmo1db9ULnJjypefsDJVL29p+4WuhR1cNRSB23AT0UEV5QYVz0/n10IEWbMlvTncJ
 P1AJ1n1IS+4xG7xjDnUKa2kg1Ls=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f9248bf319d4e9cb5e9c394 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Oct 2020 03:06:39
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5EF0EC433C9; Fri, 23 Oct 2020 03:06:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4B9E5C433C9;
        Fri, 23 Oct 2020 03:06:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B9E5C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v6 1/2] bus: mhi: Add mhi_queue_is_full function
To:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        eric.dumazet@gmail.com, Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <8c384f6a-df21-1a39-f586-6077da373c04@codeaurora.org>
Date:   Thu, 22 Oct 2020 20:06:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 10/16/20 2:20 AM, Loic Poulain wrote:
> This function can be used by client driver to determine whether it's
> possible to queue new elements in a channel ring.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[..]
> +static inline bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
> +				    struct mhi_ring *ring)
>   {
>   	void *tmp = ring->wp + ring->el_size;
>   
> @@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
>   }
>   EXPORT_SYMBOL_GPL(mhi_queue_buf);
>   
> +bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir)
> +{
> +	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
> +	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
> +					mhi_dev->ul_chan : mhi_dev->dl_chan;
> +	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
> +
> +	return mhi_is_ring_full(mhi_cntrl, tre_ring);
> +}
> +EXPORT_SYMBOL_GPL(mhi_queue_is_full);
> 
i was wondering if you can make use of mhi_get_free_desc() API (pushed 
as part of MHI UCI - User Control Interface driver) here?

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
