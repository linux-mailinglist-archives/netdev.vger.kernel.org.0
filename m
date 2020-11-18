Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E052B8479
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKRTNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:13:41 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:12289 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgKRTNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:13:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605726820; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=8898U5caluN8Fm4wyA6ljvWBwAbzAR4kyIfffD9KtsU=;
 b=KNwTZtYDXAxSD1cgG+AHC4WIwZM7Kg5+3KmkN9/SuzvztyWi3U/1SKjR4Xq3vMnS4O9gwycg
 mrJ9yUuoWjjDLvodN2OR3nubVnC4aFPKt9YOuHv5kLf6QE4hyDasw1no3ou1MqxamWzHflkD
 Ia02yLBvE2z+8WNZyLwziiG3GY0=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fb5726322377520ee7525f3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 19:13:39
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A6469C43462; Wed, 18 Nov 2020 19:13:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6E4CC433ED;
        Wed, 18 Nov 2020 19:13:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 11:13:38 -0800
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, cjhuang@codeaurora.org,
        linux-arm-msm@vger.kernel.org, hemantk@codeaurora.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        clew@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, jhugo=codeaurora.org@codeaurora.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <5e94c0be-9402-7309-5d65-857a27d1f491@codeaurora.org>
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
 <5e94c0be-9402-7309-5d65-857a27d1f491@codeaurora.org>
Message-ID: <4369f0e36886db303f5543b8a380b9d0@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff,
On 2020-11-18 10:34 AM, Jeffrey Hugo wrote:
> On 11/18/2020 11:20 AM, Bhaumik Bhatt wrote:
>> Reset MHI device channels when driver remove is called due to
>> module unload or any crash scenario. This will make sure that
>> MHI channels no longer remain enabled for transfers since the
>> MHI stack does not take care of this anymore after the auto-start
>> channels feature was removed.
>> 
>> Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
>> ---
>>   net/qrtr/mhi.c | 1 +
>>   1 file changed, 1 insertion(+)
>> 
>> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
>> index 7100f0b..2bf2b19 100644
>> --- a/net/qrtr/mhi.c
>> +++ b/net/qrtr/mhi.c
>> @@ -104,6 +104,7 @@ static void qcom_mhi_qrtr_remove(struct mhi_device 
>> *mhi_dev)
>>   	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>>     	qrtr_endpoint_unregister(&qdev->ep);
>> +	mhi_unprepare_from_transfer(mhi_dev);
>>   	dev_set_drvdata(&mhi_dev->dev, NULL);
>>   }
>> 
> 
> I admit, I didn't pay much attention to the auto-start being removed,
> but this seems odd to me.
It allows fair and common treatment for all client drivers.
> 
> As a client, the MHI device is being removed, likely because of some
> factor outside of my control, but I still need to clean it up?  This
> really feels like something MHI should be handling.
It isn't really outside of a client's control every time. If a client 
driver
module is unloaded for example, it should be in their responsibility to 
clean
up and send commands to close those channels which allows the device to 
clean
up the context.

In the event of a kernel panic or some device crash outside of a 
client's
control, this function will just free some memory and return right away 
as MHI
knows not to pursue it over the link anyway.

Some client drivers depend on USB or other drivers, which allows 
flexibility on
their end as to when to call these MHI prepare/unprepare for transfer 
APIs.

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
