Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA398434C0D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJTNaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:30:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22342 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhJTNaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:30:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634736472; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=c5i1CMhYy4g8vaYaKlzxS5Vj9oYBF5BrdPZbK42iW3Y=; b=h7L5VwNiR57ZdA2CT/+vlIoDFxbws30KCGcR+TEyWhqq2Qz5pq2BLZWiMNcic8JXh6nS8WbI
 DVU7gI8xrjbMxCQj0rmNTeqLAsz2vtPhLv89ApKTef7jYkJMK2gyJCeNMtPNLxhv7K2z6qR1
 tqOAaupu9yFVF48VE/3/9erMShE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 617019535ca800b6c18e95d6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 13:27:47
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39526C43617; Wed, 20 Oct 2021 13:27:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 41A57C4338F;
        Wed, 20 Oct 2021 13:27:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 41A57C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v3 12/13] net: phy: adjust qca8081 master/slave seed value
 if link down
To:     Andrew Lunn <andrew@lunn.ch>, Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-13-luoj@codeaurora.org> <YW3vVt99i7TNCzaC@lunn.ch>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <087c328d-2909-6750-8711-71abb8d5e301@quicinc.com>
Date:   Wed, 20 Oct 2021 21:27:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YW3vVt99i7TNCzaC@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 6:04 AM, Andrew Lunn wrote:
> On Mon, Oct 18, 2021 at 11:33:32AM +0800, Luo Jie wrote:
>> 1. The master/slave seed needs to be updated when the link can't
>> be created.
>>
>> 2. The case where two qca8081 PHYs are connected each other and
>> master/slave seed is generated as the same value also needs
>> to be considered, so adding this code change into read_status
>> instead of link_change_notify.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/at803x.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
>> index 5d007f89e9d3..77aaf9e72781 100644
>> --- a/drivers/net/phy/at803x.c
>> +++ b/drivers/net/phy/at803x.c
>> @@ -1556,6 +1556,22 @@ static int qca808x_read_status(struct phy_device *phydev)
>>   	else
>>   		phydev->interface = PHY_INTERFACE_MODE_SMII;
>>   
>> +	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
>> +	 * except for master/slave configuration fault detected.
>> +	 * the reason for not putting this code into the function link_change_notify is
>> +	 * the corner case where the link partner is also the qca8081 PHY and the seed
>> +	 * value is configured as the same value, the link can't be up and no link change
>> +	 * occurs.
>> +	 */
>> +	if (!phydev->link) {
>> +		if (phydev->master_slave_state == MASTER_SLAVE_STATE_ERR) {
>> +			qca808x_phy_ms_seed_enable(phydev, false);
>> +		} else {
>> +			qca808x_phy_ms_random_seed_set(phydev);
>> +			qca808x_phy_ms_seed_enable(phydev, true);
>> +		}
>> +	}
> Are you assuming here that the status is polled once a second, and
> each poll you choose a new seed and see if it succeeds? What happens
> when interrupts are used, not polling?
>
>       Andrew

Hi Andrew,

yes, this code assumes that the PHY POLL is used, and choose a new 
random seed value

on each poll if no link is created.

when the interrupts is used, this corner case seems can't be covered 
since there is

no related interrupt occurs when the seed is configured as same value.

