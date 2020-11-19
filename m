Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7772B9B13
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgKSTCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:02:39 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:39318 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbgKSTCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:02:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605812557; h=Message-ID: References: In-Reply-To: Reply-To:
 Subject: Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QM3CLPvjkfi6YERoSbKWzDa4BPjcQSDZ5ZJSSMwwfYw=;
 b=p3bt++XyKz71hb7chrxZ08QOj9dt6dcyJ4t6hhiZUMRSfOTvdxu7KLq98uzpnu4K7LnDPlTw
 PHC4CYTQRMqDpKVp2u4PVEytHvatSsVmdxyFQpor1FfqWf2WNMJqsJ9q9ANI9WTL0lFI1xXt
 0yDuhOut5ElbmFHYVWXEUkucLIs=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fb6c14cfa67d9becf71a9f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 19 Nov 2020 19:02:36
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29221C43463; Thu, 19 Nov 2020 19:02:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2AC29C433C6;
        Thu, 19 Nov 2020 19:02:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 19 Nov 2020 11:02:35 -0800
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, ath11k@lists.infradead.org,
        cjhuang@codeaurora.org, clew@codeaurora.org,
        hemantk@codeaurora.org, kvalo@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, jhugo=codeaurora.org@codeaurora.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
Organization: Qualcomm Innovation Center, Inc.
Reply-To: bbhatt@codeaurora.org
Mail-Reply-To: bbhatt@codeaurora.org
In-Reply-To: <2019fe3c-55c5-61fe-758c-1e9952e1cb33@codeaurora.org>
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
 <5e94c0be-9402-7309-5d65-857a27d1f491@codeaurora.org>
 <CAMZdPi_b0=qFNGi1yUke3Dip2bi-zW4ULTg8W4nbyPyEsE3D4w@mail.gmail.com>
 <2019fe3c-55c5-61fe-758c-1e9952e1cb33@codeaurora.org>
Message-ID: <647d1520d0bcefa7ff02d2ef5ee81bd1@codeaurora.org>
X-Sender: bbhatt@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 11:34 AM, Jeffrey Hugo wrote:
> On 11/18/2020 12:14 PM, Loic Poulain wrote:
>> 
>> 
>> Le mer. 18 nov. 2020 à 19:34, Jeffrey Hugo <jhugo@codeaurora.org 
>> <mailto:jhugo@codeaurora.org>> a écrit :
>> 
>>     On 11/18/2020 11:20 AM, Bhaumik Bhatt wrote:
>>      > Reset MHI device channels when driver remove is called due to
>>      > module unload or any crash scenario. This will make sure that
>>      > MHI channels no longer remain enabled for transfers since the
>>      > MHI stack does not take care of this anymore after the 
>> auto-start
>>      > channels feature was removed.
>>      >
>>      > Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org
>>     <mailto:bbhatt@codeaurora.org>>
>>      > ---
>>      >   net/qrtr/mhi.c | 1 +
>>      >   1 file changed, 1 insertion(+)
>>      >
>>      > diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
>>      > index 7100f0b..2bf2b19 100644
>>      > --- a/net/qrtr/mhi.c
>>      > +++ b/net/qrtr/mhi.c
>>      > @@ -104,6 +104,7 @@ static void qcom_mhi_qrtr_remove(struct
>>     mhi_device *mhi_dev)
>>      >       struct qrtr_mhi_dev *qdev = 
>> dev_get_drvdata(&mhi_dev->dev);
>>      >
>>      >       qrtr_endpoint_unregister(&qdev->ep);
>>      > +     mhi_unprepare_from_transfer(mhi_dev);
>>      >       dev_set_drvdata(&mhi_dev->dev, NULL);
>>      >   }
>>      >
>>      >
>> 
>>     I admit, I didn't pay much attention to the auto-start being 
>> removed,
>>     but this seems odd to me.
>> 
>>     As a client, the MHI device is being removed, likely because of 
>> some
>>     factor outside of my control, but I still need to clean it up?  
>> This
>>     really feels like something MHI should be handling.
>> 
>> 
>> I think this is just about balancing operations, what is done in probe 
>> should be undone in remove, so here channels are started in probe and 
>> stopped/reset in remove.
> 
> I understand that perspective, but that doesn't quite match what is
> going on here.  Regardless of if the channel was started (prepared) in
> probe, it now needs to be stopped in remove.  That not balanced in all
> cases
> 
> Lets assume, in response to probe(), my client driver goes and creates
> some other object, maybe a socket.  In response to that socket being
> opened/activated by the client of my driver, I go and start the mhi
> channel.  Now, normally, when the socket is closed/deactivated, I stop
> the MHI channel.  In this case, stopping the MHI channel in remove()
> is unbalanced with respect to probe(), but is now a requirement.
> 
> Now you may argue, I should close the object in response to remove,
> which will then trigger the stop on the channel.  That doesn't apply
> to everything.  For example, you cannot close an open file in the
> kernel. You need to wait for userspace to close it.  By the time that
> happens, the mhi_dev is long gone I expect.
> 
> So if, somehow, the client driver is the one causing the remove to
> occur, then yes it should probably be the one doing the stop, but
> that's a narrow set of conditions, and I think having that requirement
> for all scenarios is limiting.
It should be the client's responsibility to perform a clean-up though.

We cannot assume that the remove() call was due to factors outside of 
the
client's control at all times. You may not know if the remove() was due 
to
device actually crashing or just an unbind/module unload. So, it would 
be
better if you call it as the device should ideally not be left with a 
stale
channel context.

We had an issue where a client was issuing a driver unbind without 
unpreparing
the MHI channels and without Loic's patch [1], we would not issue a 
channel
RESET to the device resulting in incoming data to the host on those 
channels
after host clean-up and an unmapped memory access and kernel panic.

If MHI dev will be gone that NULL/status check must be present in 
something that
userspace could potentially use.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/bus/mhi?h=next-20201119&id=a7f422f2f89e7d48aa66e6488444a4c7f01269d5

Thanks,
Bhaumik
---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
