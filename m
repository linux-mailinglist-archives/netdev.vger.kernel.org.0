Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B15917BE
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiHMAJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMAJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8085C9EB;
        Fri, 12 Aug 2022 17:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D4C61753;
        Sat, 13 Aug 2022 00:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A62C433C1;
        Sat, 13 Aug 2022 00:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660349367;
        bh=5yIuU8S7Bxx4QtQzdZvHC4r+a75zJUOpa3eix4D1VOY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F3nnxdAZZjxa0g1rP6pr9Rf9UgOIjK5jMf6wmRKk0w7VZNdl3oN9w1z7picsDUV5C
         pxkNajE8hTmdTv+ljdXIKyXe0b0rXTh3IuD/RQnocBcdL0PMib2o1tdxgDRulSfSE4
         jO2IG1P2IdnxRXh/vdR4kQsDsc7rJg8lEQLIiSdRdeYt3HNXMjbRWYj3Y6IzB1DHlB
         NEIpxIDZuXCGp/Hcxuu1KM69KYLO/jIHqCTD2tVoQct6Vvkva97n46Os7Wj4aFWteD
         bopfRVCIbb3ehgEXFK0JZcUf8ggtufd2h7aTh5zHsoWZhaF9xaxwjpVG0Fsv91jx+Q
         Yx5Ay6aw+WdYQ==
Date:   Fri, 12 Aug 2022 17:09:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Kochetkov <fido_max@inbox.ru>, loic.poulain@linaro.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        Hemant Kumar <quic_hemantk@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH v2 1/1] net: qrtr: start MHI channel after endpoit
 creation
Message-ID: <20220812170926.0370b05d@kernel.org>
In-Reply-To: <20220811094840.1654088-1-fido_max@inbox.ru>
References: <20220811094840.1654088-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 12:48:40 +0300 Maxim Kochetkov wrote:
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

You must CC the author of the patch under Fixes, they are usually 
the best person to review the fix. Adding Loic now.

> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 18196e1c8c2f..9ced13c0627a 100644
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
> @@ -96,6 +91,13 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	if (rc)
>  		return rc;
>  
> +	/* start channels */
> +	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
> +	if (rc) {
> +		qrtr_endpoint_unregister(&qdev->ep);
> +		return rc;
> +	}
> +
>  	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
>  
>  	return 0;

