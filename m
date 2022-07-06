Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BA567D8F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiGFFAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiGFFAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:00:23 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15B51BE91;
        Tue,  5 Jul 2022 22:00:21 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 266504Eo103202;
        Wed, 6 Jul 2022 00:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1657083604;
        bh=D9PtAo2EJpNoBvQxSpTmULzcTbmQj+LZIpS5Xpqazeo=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=jGUJ6DRG9+t8J72nViRq2yQ3hK913hh39fAsLY20CD9me3DUaGelXsTKdva0hPY9D
         xujnZOQfq8w3ZvjbjPQFajIi4FiaYlNSR6UtjsSYFGdi77K1U7CdTSOFD7F+KPTf76
         uvVUh48BxpwjqrrEc3TIkj39GiAJmUQzD2YtafZQ=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 266504Ce070534
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Jul 2022 00:00:04 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Jul 2022 00:00:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Jul 2022 00:00:02 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2664xwDn117319;
        Tue, 5 Jul 2022 23:59:59 -0500
Message-ID: <19b9e05e-f750-8bb5-542e-6e9590812c3c@ti.com>
Date:   Wed, 6 Jul 2022 10:29:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
CC:     <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net v2] net: ethernet: ti: am65-cpsw: Fix devlink port
 register sequence
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220704073040.7542-1-s-vadapalli@ti.com>
 <20220705183901.2a536d50@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220705183901.2a536d50@kernel.org>
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

On 06/07/22 07:09, Jakub Kicinski wrote:
> On Mon, 4 Jul 2022 13:00:40 +0530 Siddharth Vadapalli wrote:
>> @@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>>  		return ret;
>>  	}
>>  
>> +	ret = am65_cpsw_nuss_register_devlink(common);
>> +	if (ret)
>> +		goto err_cleanup_ndev;
>> +
>>  	for (i = 0; i < common->port_num; i++) {
>>  		port = &common->ports[i];
>>  
>> @@ -2539,23 +2543,21 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
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
> 
> No additions to the error handling path? Slightly suspicious.
> Do the devlink ports not have to be removed if netdev registration
> fails?

Thank you for pointing it out. I had missed adding the cleanup for the register
devlink function call. I will add it and post the v3 patch.

Regards,
Siddharth.
