Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A454058FA29
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiHKJhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiHKJhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:37:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39EE90802;
        Thu, 11 Aug 2022 02:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54E61CE1FCB;
        Thu, 11 Aug 2022 09:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF321C433D6;
        Thu, 11 Aug 2022 09:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660210648;
        bh=hE/Qb0FD4bADTX3ai6AJnDvlPB0Rt0EGI8kSmltGj/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDJpHh0nYgdvSobJ3dsR6WHj0c5Yam+qZVVKWF+rwbYrSyDTLmw275TTQE++XM3hC
         SX1oSZQNdb3VkXpDwgF0S4m1z2EfePKP8ThZksG/NrcWdkCFUAB2tgjXskuXk+BEaG
         2hsVrdJiJsHbBbQyrhUlOkhj1cIlMqQi3/T0my26TNx9JJExIYQ+s91jXVLNwAtKNV
         nXTUeubw/yPv4L0+ahvm1nMhT1jue9/LEEEm3LF570+KjvbYSbAPeeIleqEjs8hQ4y
         ISop5SP8APX6BJ+IN4ImCIYLYFUTYF+zr32EiVlEtNnrFschuaeHh0/3f8Cf87QqdU
         2yJAT+tbrtjUg==
Date:   Thu, 11 Aug 2022 15:07:21 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        Hemant Kumar <quic_hemantk@quicinc.com>
Subject: Re: [PATCH 1/1] net: qrtr: start MHI channel after endpoit creation
Message-ID: <20220811093721.GA29799@workstation>
References: <20220811092145.1648008-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811092145.1648008-1-fido_max@inbox.ru>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 12:21:45PM +0300, Maxim Kochetkov wrote:
> MHI channel may generates event/interrupt right after enabling.
> It may leads to 2 race conditions issues.
> 
> 1)
> Such event may be dropped by qcom_mhi_qrtr_dl_callback() at check:
> 
> 	if (!qdev || mhi_res->transaction_status)
> 		return;
> 
> Because dev_set_drvdata(&mhi_dev->dev, qdev) may be not performed at
> this moment. In this situation qrtr-ns will be unable to enumerate
> services in device.
> ---------------------------------------------------------------
> 
> 2)
> Such event may come at the moment after dev_set_drvdata() and
> before qrtr_endpoint_register(). In this case kernel will panic with
> accessing wrong pointer at qcom_mhi_qrtr_dl_callback():
> 
> 	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
> 				mhi_res->bytes_xferd);
> 
> Because endpoint is not created yet.
> --------------------------------------------------------------
> So move mhi_prepare_for_transfer_autoqueue after endpoint creation
> to fix it.
> 
> Fixes: a2e2cc0dbb11 ("net: qrtr: Start MHI channels during init")
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Reviewed-by: Hemant Kumar <quic_hemantk@quicinc.com>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> ---
>  net/qrtr/mhi.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 18196e1c8c2f..17520d9e7a51 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -78,11 +78,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	struct qrtr_mhi_dev *qdev;
>  	int rc;
>  
> -	/* start channels */
> -	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
> -	if (rc)
> -		return rc;
> -
>  	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
>  	if (!qdev)
>  		return -ENOMEM;
> @@ -96,6 +91,11 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	if (rc)
>  		return rc;
>  
> +	/* start channels */
> +	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
> +	if (rc)
> +		return rc;

I missed the fact that you need to call qrtr_endpoint_unregister() in
the error path.

Please fix it.

Thanks,
Mani

> +
>  	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
>  
>  	return 0;
> -- 
> 2.34.1
> 
