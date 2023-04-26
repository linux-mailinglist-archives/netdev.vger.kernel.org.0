Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81026EEDB3
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbjDZFwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbjDZFv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:51:59 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABBE273C;
        Tue, 25 Apr 2023 22:51:12 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33Q5ntgs029373;
        Wed, 26 Apr 2023 00:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682488195;
        bh=OoC9MWwrdE8UzFkXZkLmaX88mbpfdUSP+bjvTP1SP1c=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=S61NcwhTbYqH193vzyQHYRrtFCjlPYdeSSDRxF4oeQ52nnZ73vKtiySDgB4z2gL80
         jcj0/Xxtk4XaeqRcF1UbRQ86Xkpt4xZClSW5uTZbE1nhWKHWXFxZVlV8K6XsdIRC3D
         XItobHj6LUZV6URSRcW6VgoRWX6rmoK5ln5Kd9NI=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33Q5ntXv065180
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Apr 2023 00:49:55 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 26
 Apr 2023 00:49:54 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 26 Apr 2023 00:49:54 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33Q5noAE008767;
        Wed, 26 Apr 2023 00:49:51 -0500
Message-ID: <99932a4f-4573-b80b-080b-7d9d3f57bef0@ti.com>
Date:   Wed, 26 Apr 2023 11:19:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [RFC PATCH 2/2] net: phy: dp83869: fix mii mode when rgmii strap
 cfg is used
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-3-s-vadapalli@ti.com>
 <cbbedaab-b2bf-4a37-88ed-c1a8211920e9@lunn.ch>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <cbbedaab-b2bf-4a37-88ed-c1a8211920e9@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/04/23 17:48, Andrew Lunn wrote:
> On Tue, Apr 25, 2023 at 11:14:29AM +0530, Siddharth Vadapalli wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> The DP83869 PHY on TI's k3-am642-evm supports both MII and RGMII
>> interfaces and is configured by default to use RGMII interface (strap).
>> However, the board design allows switching dynamically to MII interface
>> for testing purposes by applying different set of pinmuxes.
> 
> Only for testing? So nobody should actually design a board to use MII
> and use software to change the interface from RGMII to MII?
> 
> This does not seem to be a fix, it is a new feature. So please submit
> to net-next, in two weeks time when it opens again.

Sure. I will split this patch from the series and post the v2 of this patch with
the subject "RFC PATCH net-next" for requesting further feedback on this patch
if needed. Following that, I will post it to net-next as a new patch.

> 
>> @@ -692,8 +692,11 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>>  	/* Below init sequence for each operational mode is defined in
>>  	 * section 9.4.8 of the datasheet.
>>  	 */
>> +	phy_ctrl_val = dp83869->mode;
>> +	if (phydev->interface == PHY_INTERFACE_MODE_MII)
>> +		phy_ctrl_val |= DP83869_OP_MODE_MII;
> 
> Should there be some validation here with dp83869->mode?
> 
> DP83869_RGMII_COPPER_ETHERNET, DP83869_RGMII_SGMII_BRIDGE etc don't
> make sense if MII is being used. DP83869_100M_MEDIA_CONVERT and maybe
> DP83869_RGMII_100_BASE seem to be the only valid modes with MII?

The DP83869_OP_MODE_MII macro corresponds to BIT(5) which is the RGMII_MII_SEL
bit in the OP_MODE_DECODE register. If the RGMII_MII_SEL bit is set, MII mode is
selected. If the bit is cleared, which is the default value, RGMII mode is
selected. As pointed out by you, there are modes which aren't valid with MII
mode. However, a mode which isn't valid with RGMII mode (default value of the
RGMII_MII_SEL bit) also exists: DP83869_SGMII_COPPER_ETHERNET. For this reason,
I believe that setting the bit when MII mode is requested shouldn't cause any
issues.

> 
> 	Andrew

-- 
Regards,
Siddharth.
