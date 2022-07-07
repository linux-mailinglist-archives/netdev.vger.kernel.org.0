Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67969569E54
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiGGJL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiGGJLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:11:55 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BCF27178;
        Thu,  7 Jul 2022 02:11:54 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2679BfO4067950;
        Thu, 7 Jul 2022 04:11:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1657185101;
        bh=9T7T+TcW3HB3h8rQseCPo2y1Th8ApZJxTQE8TAFp8Gs=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=xVQvcz/s4JVxY3lyuL14IjrzuOByKg/31LSIMxjgkZlety+v0RDEwDW8MxKDUSguO
         lFrJkScwL7IoW3GJSpBEBl5bWdU6P5c3fFwNoroOZXU4QgVvlS8d231em1omyCZoZp
         vcDAfWv6ErAN5S7G/Y1mwyqwK1mAjltJctUB38kI=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2679BeTM004246
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 7 Jul 2022 04:11:41 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 7
 Jul 2022 04:11:40 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 7 Jul 2022 04:11:40 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2679Baj4023761;
        Thu, 7 Jul 2022 04:11:37 -0500
Message-ID: <5d06687a-17f1-4d5c-7d3f-83d11e5ec2e7@ti.com>
Date:   Thu, 7 Jul 2022 14:41:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net v3] net: ethernet: ti: am65-cpsw: Fix devlink port
 register sequence
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>
References: <20220706070208.12207-1-s-vadapalli@ti.com>
 <e454f6de32de3be092260d19da24f58635eb6e49.camel@redhat.com>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <e454f6de32de3be092260d19da24f58635eb6e49.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
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

Hello Paolo,

On 07/07/22 13:00, Paolo Abeni wrote:
> On Wed, 2022-07-06 at 12:32 +0530, Siddharth Vadapalli wrote:
>> Renaming interfaces using udevd depends on the interface being registered
>> before its netdev is registered. Otherwise, udevd reads an empty
>> phys_port_name value, resulting in the interface not being renamed.
>>
>> Fix this by registering the interface before registering its netdev
>> by invoking am65_cpsw_nuss_register_devlink() before invoking
>> register_netdev() for the interface.
>>
>> Move the function call to devlink_port_type_eth_set(), invoking it after
>> register_netdev() is invoked, to ensure that netlink notification for the
>> port state change is generated after the netdev is completely initialized.
>>
>> Fixes: 58356eb31d60 ("net: ti: am65-cpsw-nuss: Add devlink support")
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>> Changelog:
>> v2 -> v3:
>> 1. Add error handling to unregister devlink.
>>
>> v1-> v2:
>> 1. Add Fixes tag in commit message.
>> 2. Update patch subject to include "net".
>> 3. Invoke devlink_port_type_eth_set() after register_netdev() is called.
>> 4. Update commit message describing the cause for moving the call to
>>    devlink_port_type_eth_set().
>>
>> v2: https://lore.kernel.org/r/20220704073040.7542-1-s-vadapalli@ti.com/
>> v1: https://lore.kernel.org/r/20220623044337.6179-1-s-vadapalli@ti.com/
>>
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index fb92d4c1547d..f4a6b590a1e3 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -2467,7 +2467,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
>>  				port->port_id, ret);
>>  			goto dl_port_unreg;
>>  		}
>> -		devlink_port_type_eth_set(dl_port, port->ndev);
>>  	}
>>  	devlink_register(common->devlink);
>>  	return ret;
>> @@ -2511,6 +2510,7 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
>>  static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>>  {
>>  	struct device *dev = common->dev;
>> +	struct devlink_port *dl_port;
>>  	struct am65_cpsw_port *port;
>>  	int ret = 0, i;
>>  
>> @@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>>  		return ret;
>>  	}
>>  
>> +	ret = am65_cpsw_nuss_register_devlink(common);
>> +	if (ret)
>> +		return ret;
>> +
>>  	for (i = 0; i < common->port_num; i++) {
>>  		port = &common->ports[i];
>>  
>> @@ -2539,25 +2543,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>>  				i, ret);
>>  			goto err_cleanup_ndev;
>>  		}
>> +
>> +		dl_port = &port->devlink_port;
>> +		devlink_port_type_eth_set(dl_port, port->ndev);
>>  	}
>>  
>>  	ret = am65_cpsw_register_notifiers(common);
>>  	if (ret)
>>  		goto err_cleanup_ndev;
>>  
>> -	ret = am65_cpsw_nuss_register_devlink(common);
>> -	if (ret)
>> -		goto clean_unregister_notifiers;
>> -
>>  	/* can't auto unregister ndev using devm_add_action() due to
>>  	 * devres release sequence in DD core for DMA
>>  	 */
>>  
>>  	return 0;
>> -clean_unregister_notifiers:
>> -	am65_cpsw_unregister_notifiers(common);
>> +
>>  err_cleanup_ndev:
>>  	am65_cpsw_nuss_cleanup_ndev(common);
>> +	am65_cpsw_unregister_devlink(common);
> 
> It looks strange that there is no error path leading to
> am65_cpsw_unregister_devlink() only.
> 
> Why we don't need to call it when/if devm_request_irq() fails? 

am65_cpsw_nuss_register_devlink() is invoked after devm_request_irq() and
devm_request_irq()'s associated error handling.

> 
> Not strictly related to this patch, but it looks like there is another
> suspect cleanup point: if a 'register_netdev()' call fails, the cleanup
> code will still call unregister_netdev() on the relevant device and the
> later ones, hitting a WARN_ON(1) in unregister_netdevice_many().

Thank you for pointing it out. I will look at it and address it in a separate
cleanup patch.

Regards,
Siddharth.
