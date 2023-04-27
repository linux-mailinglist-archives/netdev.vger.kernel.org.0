Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280696F000F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbjD0EJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjD0EJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:09:12 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C982738;
        Wed, 26 Apr 2023 21:09:11 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33R48q75030133;
        Wed, 26 Apr 2023 23:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682568532;
        bh=BoYCCHxyk+Mm+YKOeD7PWsrSINby+7eRA3vKMdlDGks=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=juV2TQ1J5lOhiYlLbhDPfxFaVBGKE/XUoolDn8B1aTgkDTHIDnsq/tMC0q6v/iWQ8
         lEHlw8cr6fGwyRdP1rp41Rwh0zfUiNoz69vdrQfsSBph5Onvkakm4ZSN6EaTKu+juz
         QWK6dxdVDwupEWk4Olo+0rQrfu5JrqaBkr7kRZng=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33R48qV1029314
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Apr 2023 23:08:52 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 26
 Apr 2023 23:08:52 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 26 Apr 2023 23:08:52 -0500
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33R48m1G068147;
        Wed, 26 Apr 2023 23:08:49 -0500
Message-ID: <cce70be8-4d2a-1499-fea5-5efa6c5f1420@ti.com>
Date:   Thu, 27 Apr 2023 09:38:48 +0530
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
 <99932a4f-4573-b80b-080b-7d9d3f57bef0@ti.com>
 <5a2bc044-5fb0-4162-a75a-24c94f8ed3f7@lunn.ch>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <5a2bc044-5fb0-4162-a75a-24c94f8ed3f7@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/04/23 18:11, Andrew Lunn wrote:
>>>> @@ -692,8 +692,11 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>>>>  	/* Below init sequence for each operational mode is defined in
>>>>  	 * section 9.4.8 of the datasheet.
>>>>  	 */
>>>> +	phy_ctrl_val = dp83869->mode;
>>>> +	if (phydev->interface == PHY_INTERFACE_MODE_MII)
>>>> +		phy_ctrl_val |= DP83869_OP_MODE_MII;
>>>
>>> Should there be some validation here with dp83869->mode?
>>>
>>> DP83869_RGMII_COPPER_ETHERNET, DP83869_RGMII_SGMII_BRIDGE etc don't
>>> make sense if MII is being used. DP83869_100M_MEDIA_CONVERT and maybe
>>> DP83869_RGMII_100_BASE seem to be the only valid modes with MII?
>>
>> The DP83869_OP_MODE_MII macro corresponds to BIT(5) which is the RGMII_MII_SEL
>> bit in the OP_MODE_DECODE register. If the RGMII_MII_SEL bit is set, MII mode is
>> selected. If the bit is cleared, which is the default value, RGMII mode is
>> selected. As pointed out by you, there are modes which aren't valid with MII
>> mode. However, a mode which isn't valid with RGMII mode (default value of the
>> RGMII_MII_SEL bit) also exists: DP83869_SGMII_COPPER_ETHERNET. For this reason,
>> I believe that setting the bit when MII mode is requested shouldn't cause any
>> issues.
> 
> If you say so. I was just thinking you could give the poor software
> engineer a hint the hardware engineer has put on strapping resistors
> which means the PHY is not going to work.

I understand now. I will update this patch to add a print if the MII mode is not
valid with the configured "dp83869->mode". Would you suggest using a dev_err()
or a dev_dbg()?

Thank you for the feedback on this series.

-- 
Regards,
Siddharth.
