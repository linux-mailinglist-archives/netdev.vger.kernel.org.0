Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0718564CBC
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 06:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiGDEoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 00:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiGDEoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 00:44:05 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6609A64C9;
        Sun,  3 Jul 2022 21:44:03 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2644hcJu001374;
        Sun, 3 Jul 2022 23:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1656909818;
        bh=T7N8m2YpYMDZxLn9rSjck49AtpxoHFmWO3QqAbu+bUs=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=ZG1B0R0cWzXDikhxRKkm53/JbnhqW5uP/jSUBaorYfnXrdcIR3DTO6QRVW3xQ+aCv
         Ov4WmyzwOYwMREncJOxIcbk0QopNs+MHBcA66hZWKRwLZApt0uNfggVcG+ZUuGD0u2
         tYeiT804PAl24W8jEU4lX1XJ3jlMlT5qeWM3yekc=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2644hcJA025249
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 3 Jul 2022 23:43:38 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Sun, 3
 Jul 2022 23:43:37 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Sun, 3 Jul 2022 23:43:37 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2644hXVP025521;
        Sun, 3 Jul 2022 23:43:34 -0500
Message-ID: <86898268-df1b-3b7c-d5be-97632bd58ca2@ti.com>
Date:   Mon, 4 Jul 2022 10:13:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
CC:     <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: Fix devlink port register
 sequence
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220623044337.6179-1-s-vadapalli@ti.com>
 <20220624164234.6268f2b7@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220624164234.6268f2b7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On 25/06/22 05:12, Jakub Kicinski wrote:
> On Thu, 23 Jun 2022 10:13:37 +0530 Siddharth Vadapalli wrote:
>> Renaming interfaces using udevd depends on the interface being registered
>> before its netdev is registered. Otherwise, udevd reads an empty
>> phys_port_name value, resulting in the interface not being renamed.
>>
>> Fix this by registering the interface before registering its netdev
>> by invoking am65_cpsw_nuss_register_devlink() before invoking
>> register_netdev() for the interface.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> 
> Please add a Fixes tag and [PATCH net] in the subject.
Thank you for reviewing the patch. I will add the Fixes tag and include net in
the subject of the v2 patch.

> 
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index fb92d4c1547d..47a6c4e5360b 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>>  		return ret;
>>  	}
>>  
>> +	ret = am65_cpsw_nuss_register_devlink(common);
>> +	if (ret)
>> +		goto err_cleanup_ndev;
> 
> You need to take the devlink_port_type_eth_set() out of this function
> if it's now called before netdev registration and call it after netdev
> registration. Otherwise devlink will generate a netlink notification
> about the port state change with a half-initialized netdev.

I will fix this and post the v2 patch.

Regards,
Siddharth.
