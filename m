Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C12B83ED
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgKRSeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:34:21 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:18828 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgKRSeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:34:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605724460; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=08x4HZK1C0mpGxp1ucPf4OqdqazMVA/m8B1O10e/r7I=; b=ERaw6byqSCQ3bIom3X/D7wTXgQGL7ETiCTXmMvZvFHPyxFaktVqfbLyMs3sFyti7x4GtsaXH
 R9S4i5Efa6+eIAY+yfRRY/294YkFW00Tl9JNEb4+FEy+8m3cZ5W3LQpB+TlrusXkiKJWLH/X
 9ZzZS7y7wCmCjNt/sBZB8yNOAxQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fb5692b0c9500dc7b3f7571 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 18:34:19
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 873E7C433ED; Wed, 18 Nov 2020 18:34:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D9ED1C433C6;
        Wed, 18 Nov 2020 18:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D9ED1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
To:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        manivannan.sadhasivam@linaro.org
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        cjhuang@codeaurora.org, linux-arm-msm@vger.kernel.org,
        hemantk@codeaurora.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, clew@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <5e94c0be-9402-7309-5d65-857a27d1f491@codeaurora.org>
Date:   Wed, 18 Nov 2020 11:34:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2020 11:20 AM, Bhaumik Bhatt wrote:
> Reset MHI device channels when driver remove is called due to
> module unload or any crash scenario. This will make sure that
> MHI channels no longer remain enabled for transfers since the
> MHI stack does not take care of this anymore after the auto-start
> channels feature was removed.
> 
> Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> ---
>   net/qrtr/mhi.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 7100f0b..2bf2b19 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -104,6 +104,7 @@ static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
>   	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>   
>   	qrtr_endpoint_unregister(&qdev->ep);
> +	mhi_unprepare_from_transfer(mhi_dev);
>   	dev_set_drvdata(&mhi_dev->dev, NULL);
>   }
>   
> 

I admit, I didn't pay much attention to the auto-start being removed, 
but this seems odd to me.

As a client, the MHI device is being removed, likely because of some 
factor outside of my control, but I still need to clean it up?  This 
really feels like something MHI should be handling.

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
