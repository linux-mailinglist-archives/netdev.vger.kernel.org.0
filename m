Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0333466B863
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjAPHoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjAPHoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:44:05 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B33D12050;
        Sun, 15 Jan 2023 23:43:59 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30G7hfOW047416;
        Mon, 16 Jan 2023 01:43:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673855021;
        bh=r6r7bcwwLxuMz7+5qr6v4Afvf5m5s0L4caeVGAAIpf8=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=HGNU2vvT+Gf6hSUfWjsU8uHc+MSD0gIzi+iKqwYzOCQ8vNCQib8+pLWQ3G+DraAEb
         LXsHQuTqsuX8Mw+zrB4OdQE7VTJRhk0vRobsEuHf6wG1wt4EDXE2fjyIo0rEtm8tqM
         CLLSxmHRWT9GgjLepwgdD7qNFWjKL6ZgDYmyguEA=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30G7hfvT046089
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Jan 2023 01:43:41 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 16
 Jan 2023 01:43:41 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 16 Jan 2023 01:43:41 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30G7hbIF106985;
        Mon, 16 Jan 2023 01:43:37 -0600
Message-ID: <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
Date:   Mon, 16 Jan 2023 13:13:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS
 release action
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
References: <20230116044517.310461-1-s-vadapalli@ti.com>
 <Y8T8+rWrvv6gfNxa@unreal>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <Y8T8+rWrvv6gfNxa@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/01/23 13:00, Leon Romanovsky wrote:
> On Mon, Jan 16, 2023 at 10:15:17AM +0530, Siddharth Vadapalli wrote:
>> The am65_cpts_release() function is registered as a devm_action in the
>> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
>> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
>> actions associated with the am65-cpsw driver's device.
>>
>> In the event of probe failure or probe deferral, the platform_drv_probe()
>> function invokes dev_pm_domain_detach() which powers off the CPSW and the
>> CPSW's CPTS hardware, both of which share the same power domain. Since the
>> am65_cpts_disable() function invoked by the am65_cpts_release() function
>> attempts to reset the CPTS hardware by writing to its registers, the CPTS
>> hardware is assumed to be powered on at this point. However, the hardware
>> is powered off before the devm actions are executed.
>>
>> Fix this by getting rid of the devm action for am65_cpts_release() and
>> invoking it directly on the cleanup and exit paths.
>>
>> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>> ---
>> Changes from v1:
>> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
>>    error was reported by kernel test robot <lkp@intel.com> at:
>>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
>> 2. Collect Reviewed-by tag from Roger Quadros.
>>
>> v1:
>> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
>>
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
>>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>>  3 files changed, 18 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 5cac98284184..00f25d8a026b 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
>>  	return 0;
>>  }
>>  
>> +static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
>> +{
>> +	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
> 
> Why do you have IS_ENABLED(CONFIG_TI_K3_AM65_CPTS), if
> am65_cpts_release() defined as empty when CONFIG_TI_K3_AM65_CPTS not set?
> 
> How is it possible to have common->cpts == NULL?

Thank you for reviewing the patch. I realize now that checking
CONFIG_TI_K3_AM65_CPTS is unnecessary.

common->cpts remains NULL in the following cases:
1. am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not enabled.
2. am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not defined.
3. The call to am65_cpts_create() fails within the am65_cpsw_init_cpts()
function with a return value of 0 when cpts is disabled.
4. The call to am65_cpts_create() within the am65_cpsw_init_cpts() function
fails with an error.

Of the above cases, the am65_cpsw_cpts_cleanup() function would have to handle
cases 1 and 3, since the probe might fail at a later point, following which the
probe cleanup path will invoke the am65_cpts_cpts_cleanup() function. This
function then checks for common->cpts not being NULL, so that it can invoke the
am65_cpts_release() function with this pointer.

> 
> And why do you need special am65_cpsw_cpts_cleanup() which does nothing
> except call to am65_cpts_release()? It will be more intuitive change
> the latter to be exported function.

The am65_cpts_release() function expects the cpts pointer to be valid. Thus, I
had added the am65_cpsw_cpts_cleanup() function to conditionally invoke the
am65_cpts_release() function whenever the cpts pointer is valid. Based on your
suggestion, I believe that you want me to check for the cpts pointer being valid
within the am65_cpts_release() function instead, so that the
am65_cpsw_cpts_cleanup() function doesn't have to be added. Please let me know
if this is what you meant.

Regards,
Siddharth.
