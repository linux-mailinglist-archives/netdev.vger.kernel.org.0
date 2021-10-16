Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2B84301B1
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240147AbhJPJzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:55:24 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13678 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbhJPJzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:55:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634377996; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=vlQHGjiycX8bXQaeZ8NFmVxFXANtXPBudym2zYT9hZ8=; b=r0iQ9BDF1pcDfgo+ohORKC2A5Pxqa2QzECBNuIparuWPMIcnWfZIAmaoIDEfSVMWOhSQEFJL
 6wj07WuSHIU8NGrR6mZsIUU728eTRc6T7BwbdMqH8OAq0nwyoGINBhPPclonPPTZjEcubeHf
 cNDOkbiNaoBuahlvvy0jPNJRe9Y=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 616aa0fb446c6db0cba82b09 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 16 Oct 2021 09:52:59
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6502FC4360C; Sat, 16 Oct 2021 09:52:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.192.232.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70DDBC4338F;
        Sat, 16 Oct 2021 09:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 70DDBC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v2 12/13] net: phy: adjust qca8081 master/slave seed value
 if link down
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211015073505.1893-1-luoj@codeaurora.org>
 <20211015073505.1893-13-luoj@codeaurora.org>
 <YWk1TjigOhfx36+3@shell.armlinux.org.uk>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <61001bc5-602c-629d-59ff-f0efaedbc764@quicinc.com>
Date:   Sat, 16 Oct 2021 17:52:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YWk1TjigOhfx36+3@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/15/2021 4:01 PM, Russell King (Oracle) wrote:
> On Fri, Oct 15, 2021 at 03:35:04PM +0800, Luo Jie wrote:
>> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
>> index 4d283c0c828c..6c5dc4eed752 100644
>> --- a/drivers/net/phy/at803x.c
>> +++ b/drivers/net/phy/at803x.c
>> @@ -1556,6 +1556,22 @@ static int qca808x_read_status(struct phy_device *phydev)
>>   	else
>>   		phydev->interface = PHY_INTERFACE_MODE_SMII;
>>   
>> +	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
>> +	 * excpet for master/slave configuration fault detected.
> "except"
will correct it in the next patch set, thanks.
>
