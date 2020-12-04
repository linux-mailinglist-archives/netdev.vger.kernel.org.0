Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F9C2CE5BD
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgLDCcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:32:48 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:39988 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgLDCcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:32:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607049142; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=UKUWIiLYmiHVJsPhpECnnECxvIOzzUiBoKnbeHMlQxc=; b=EPqoE2mBq8GoYvaSEVPjd+G/5NXqParLqiYf7CjtCEdE/qsfnkFIqFsDqcbpPiXyaxRRth7F
 vDVxb3/XEKRH2oTPy+Av92JUuR+ZUOr10SlVf9auuXWab7DCvgQ0vxXBc/FG2OoAlTs8X9ek
 Ee+eJUYqfFa8hYXILTY6JKhjdBc=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fc99f989c3ccbec63a92afa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Dec 2020 02:31:52
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 52046C43466; Fri,  4 Dec 2020 02:31:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 088C3C43461;
        Fri,  4 Dec 2020 02:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 088C3C43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v15 4/4] bus: mhi: Add userspace client interface driver
To:     Jeffrey Hugo <jhugo@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
References: <1607035516-3093-1-git-send-email-hemantk@codeaurora.org>
 <1607035516-3093-5-git-send-email-hemantk@codeaurora.org>
 <1bcddc1c-e489-c867-77fb-f6893a101900@codeaurora.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <d1af1eac-f9bd-7a8e-586b-5c2a76445145@codeaurora.org>
Date:   Thu, 3 Dec 2020 18:31:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1bcddc1c-e489-c867-77fb-f6893a101900@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/3/20 3:45 PM, Jeffrey Hugo wrote:
> On 12/3/2020 3:45 PM, Hemant Kumar wrote:
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
> 
> You dropped Loic's tested by.  Was that a mistake, or did something 
> actually change which would invalidate his testing?
> 
Thanks for pointing this out, it was my bad. Re-sending the patch.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
