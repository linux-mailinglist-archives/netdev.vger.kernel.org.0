Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7710D2D5EEE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389829AbgLJPEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:04:00 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:46683 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389646AbgLJPDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:03:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607612603; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=fTCspt8fsRDJ1131Yu+GC08GW7hUsw3zqXe2mBHPhEw=; b=pnJNuhjYlxkFSoWk8GSSZL2RE6PIrkxOtbcS9UIgM3d3yCrOY2Dn3gNHFwlBZ7O0Lu09clkA
 cDbwGVjd9Q/uVaatj8WKpvE9hzGkHYSqc+tX0LG9p36l1eUz0N+7NKM+zrubQd9p7AnNLWtC
 DjqE4QdJXUtJgMCmhg6QeAuPSuQ=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fd238693a8ba2142a1c7cc2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 15:02:01
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 86C9AC433CA; Thu, 10 Dec 2020 15:02:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D4171C43465;
        Thu, 10 Dec 2020 15:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D4171C43465
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH v16 4/4] bus: mhi: Add userspace client interface driver
To:     Greg KH <gregkh@linuxfoundation.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1607584885-23824-1-git-send-email-hemantk@codeaurora.org>
 <1607584885-23824-5-git-send-email-hemantk@codeaurora.org>
 <X9HifqAntBUBV0Ce@kroah.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <1ce7fc1a-7794-6815-ab4c-0721f0422564@codeaurora.org>
Date:   Thu, 10 Dec 2020 08:01:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X9HifqAntBUBV0Ce@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2020 1:55 AM, Greg KH wrote:
> On Wed, Dec 09, 2020 at 11:21:25PM -0800, Hemant Kumar wrote:
>> This MHI client driver allows userspace clients to transfer
>> raw data between MHI device and host using standard file operations.
>> Driver instantiates UCI device object which is associated to device
>> file node. UCI device object instantiates UCI channel object when device
>> file node is opened. UCI channel object is used to manage MHI channels
>> by calling MHI core APIs for read and write operations. MHI channels
>> are started as part of device open(). MHI channels remain in start
>> state until last release() is called on UCI device file node. Device
>> file node is created with format
>>
>> /dev/<mhi_device_name>
>>
>> Currently it supports QMI channel.
>>
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
>> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
>> Tested-by: Loic Poulain <loic.poulain@linaro.org>
>> ---
> 
> Can you provide a pointer to the open-source userspace program that will
> be talking to this new kernel driver please?  That should be part of the
> changelog here.

Its listed in the documentation file (patch 3 in the series).  I'm 
guessing you still want it in the change log though, so Hemant should 
probably take care of that.

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
