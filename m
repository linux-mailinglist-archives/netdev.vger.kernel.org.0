Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF484334FF
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhJSLtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:49:12 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:38607 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbhJSLtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 07:49:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634644014; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=EvDyrekx5UeDzmCLJosKm7BvUgtHtZESln5Od72Ezpw=; b=UB7rG545eVvXY4mFyIBQrcEsdGDFIZAoBTzKt8saL91hmaQy3rACWLwvrgWd679NdnBFQTwX
 Y6THyFpVzTlSpK/mtvTzg9IqDlJ2y9rP4yjlgnqLqe4DAfYkPAHsuOV0fZWHPf71n3iEz3zw
 ER1hNZtVhf4djnP15hWPsrB/CO0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 616eb02067f107c6119a08d3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 11:46:40
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 27426C43617; Tue, 19 Oct 2021 11:46:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22B57C4338F;
        Tue, 19 Oct 2021 11:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 22B57C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v3 03/13] net: phy: at803x: improve the WOL feature
To:     Andrew Lunn <andrew@lunn.ch>, Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-4-luoj@codeaurora.org> <YW2/wck2NPhgwjuL@lunn.ch>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <0ba3022d-9879-bf85-251d-3f48b9cff93b@quicinc.com>
Date:   Tue, 19 Oct 2021 19:46:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW2/wck2NPhgwjuL@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 2:41 AM, Andrew Lunn wrote:
>> @@ -348,18 +349,29 @@ static int at803x_set_wol(struct phy_device *phydev,
>>   			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
>>   				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
>>   
>> +		/* Enable WOL function */
>> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
>> +				0, AT803X_WOL_EN);
>> +		if (ret)
>> +			return ret;
>> +		/* Enable WOL interrupt */
>>   		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
>>   		if (ret)
>>   			return ret;
>> -		value = phy_read(phydev, AT803X_INTR_STATUS);
>>   	} else {
>> +		/* Disable WoL function */
>> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
>> +				AT803X_WOL_EN, 0);
>> +		if (ret)
>> +			return ret;
>> +		/* Disable WOL interrupt */
>>   		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
>>   		if (ret)
>>   			return ret;
>> -		value = phy_read(phydev, AT803X_INTR_STATUS);
>>   	}
>>   
>> -	return ret;
>> +	/* Clear WOL status */
>> +	return phy_read(phydev, AT803X_INTR_STATUS);
> It looks like you could be clearing other interrupt bits which have
> not been serviced yet. Is it possible to clear just WoL?

Hi Andrew,

when this register AT803X_INTR_STATUS bits are cleared after read, we 
can't clear only WOL interrupt here.

>
> Also, you are returning the contents of the interrupt status register?
> You should probably be returning 0 if the read was successful.
thanks for this comments, will correct it in the next patch set.
>
>      Andrew
