Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596CC1EC57E
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgFBXKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 19:10:34 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43582 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgFBXKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 19:10:34 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 052NASrt118881;
        Tue, 2 Jun 2020 18:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591139428;
        bh=dE0qBYvIatQtqxHG5Y7eamyWzzcpi2JcluSxv2foNYo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=rVRr6k1nJAKKSCqp997lWVbYLF2j3y8WJrLtvGMazrKUtGUofd+lKlxpkpoFZG3ys
         D4aqm11ptCs6tPhu+ciNstSB/tSFbFR/DqCX6IVDeqWlZ62MImJzktDivSKV19QV/9
         b6Mf++f2N/6iRiRYIwGGOm7CWoUrLPdM6LREC6pQ=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 052NARda022346
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Jun 2020 18:10:27 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 2 Jun
 2020 18:10:27 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 2 Jun 2020 18:10:27 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 052NAReI127270;
        Tue, 2 Jun 2020 18:10:27 -0500
Subject: Re: [PATCH net-next v5 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200602164522.3276-1-dmurphy@ti.com>
 <20200602164522.3276-5-dmurphy@ti.com>
 <c3c68dcd-ccf1-25fd-fc4c-4c30608a1cc8@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <61888788-041f-7b93-9d99-7dad4c148021@ti.com>
Date:   Tue, 2 Jun 2020 18:10:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c3c68dcd-ccf1-25fd-fc4c-4c30608a1cc8@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 6/2/20 5:33 PM, Florian Fainelli wrote:
>
> On 6/2/2020 9:45 AM, Dan Murphy wrote:
>> Add RGMII internal delay configuration for Rx and Tx.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
> [snip]
>
>> +
>>   enum {
>>   	DP83869_PORT_MIRRORING_KEEP,
>>   	DP83869_PORT_MIRRORING_EN,
>> @@ -108,6 +113,8 @@ enum {
>>   struct dp83869_private {
>>   	int tx_fifo_depth;
>>   	int rx_fifo_depth;
>> +	s32 rx_id_delay;
>> +	s32 tx_id_delay;
>>   	int io_impedance;
>>   	int port_mirroring;
>>   	bool rxctrl_strap_quirk;
>> @@ -232,6 +239,22 @@ static int dp83869_of_init(struct phy_device *phydev)
>>   				 &dp83869->tx_fifo_depth))
>>   		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>>   
>> +	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
>> +				   &dp83869->rx_id_delay);
>> +	if (ret) {
>> +		dp83869->rx_id_delay =
>> +				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
>> +		ret = 0;
>> +	}
>> +
>> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>> +				   &dp83869->tx_id_delay);
>> +	if (ret) {
>> +		dp83869->tx_id_delay =
>> +				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
>> +		ret = 0;
>> +	}
> It is still not clear to me why is not the parsing being done by the PHY
> library helper directly?

Why would we do that for these properties and not any other?

Unless there is a new precedence being set here by having the PHY 
framework do all the dt node parsing for common properties.

Dan



