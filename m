Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE57671582
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjARHy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjARHx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:53:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067535B5AC;
        Tue, 17 Jan 2023 23:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EEBEB81A90;
        Wed, 18 Jan 2023 07:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872D3C433D2;
        Wed, 18 Jan 2023 07:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674026745;
        bh=ofOSANDmuIMxfltFXcmeW2ct09Fn7hC4wyKiPDC0fn4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=H6F8olG8fj/O/EGK71hEDqWd8fORumPM9P4Peuyo0WtdGf89dWRcU0fmSS1iHYmYr
         8EuTACIAySa4WfJSNec5ZlEEkhXSsTE89BZCrXlsUtL2l8OE6H/cxndwuNOJt8Ue/F
         ye6a94yr40fAWVxz8ycpeMaFlxBIYHcZnNCF56uTSZZw+5NZZZrUI/yaDjyfs24G8Q
         LpKUp/De7A5ejts8YsIgbs/HCzZE7kijeUuuqqzQYwMK3FMx39cqeDUaCMq4w6BjFk
         IQ28HBZlGlHqJjbp/g+uXYgD/zyw90oR70vvCm6/WoUR62VVl5Za6X1RVXlfIp9vUK
         pwtuZQdItV7+w==
Message-ID: <36906043-4c18-bfff-c4e4-5d16b3445906@kernel.org>
Date:   Wed, 18 Jan 2023 09:25:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS
 release action
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vigneshr@ti.com, srk@ti.com
References: <20230116044517.310461-1-s-vadapalli@ti.com>
 <Y8T8+rWrvv6gfNxa@unreal> <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
 <b33c25c5-c93f-6860-b0a5-58279022a91c@kernel.org>
 <aebaa171-bf4e-c143-a186-a37cd34b724e@ti.com> <Y8aHwSnVK9+sAb24@unreal>
 <7323af1e-1f33-adcf-885e-db604f7a3788@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <7323af1e-1f33-adcf-885e-db604f7a3788@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 18/01/2023 06:58, Siddharth Vadapalli wrote:
> On 17/01/23 17:04, Leon Romanovsky wrote:
>> On Tue, Jan 17, 2023 at 10:30:26AM +0530, Siddharth Vadapalli wrote:
>>> Roger, Leon,
>>>
>>> On 16/01/23 21:31, Roger Quadros wrote:
>>>> Hi Siddharth,
>>>>
>>>> On 16/01/2023 09:43, Siddharth Vadapalli wrote:
>>>>>
>>>>>
>>>>> On 16/01/23 13:00, Leon Romanovsky wrote:
>>>>>> On Mon, Jan 16, 2023 at 10:15:17AM +0530, Siddharth Vadapalli wrote:
>>>>>>> The am65_cpts_release() function is registered as a devm_action in the
>>>>>>> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
>>>>>>> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
>>>>>>> actions associated with the am65-cpsw driver's device.
>>>>>>>
>>>>>>> In the event of probe failure or probe deferral, the platform_drv_probe()
>>>>>>> function invokes dev_pm_domain_detach() which powers off the CPSW and the
>>>>>>> CPSW's CPTS hardware, both of which share the same power domain. Since the
>>>>>>> am65_cpts_disable() function invoked by the am65_cpts_release() function
>>>>>>> attempts to reset the CPTS hardware by writing to its registers, the CPTS
>>>>>>> hardware is assumed to be powered on at this point. However, the hardware
>>>>>>> is powered off before the devm actions are executed.
>>>>>>>
>>>>>>> Fix this by getting rid of the devm action for am65_cpts_release() and
>>>>>>> invoking it directly on the cleanup and exit paths.
>>>>>>>
>>>>>>> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
>>>>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>>>>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>>>>>>> ---
>>>>>>> Changes from v1:
>>>>>>> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
>>>>>>>    error was reported by kernel test robot <lkp@intel.com> at:
>>>>>>>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
>>>>>>> 2. Collect Reviewed-by tag from Roger Quadros.
>>>>>>>
>>>>>>> v1:
>>>>>>> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
>>>>>>>
>>>>>>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
>>>>>>>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>>>>>>>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>>>>>>>  3 files changed, 18 insertions(+), 10 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>> index 5cac98284184..00f25d8a026b 100644
>>>>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>> @@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
>>>>>>>  	return 0;
>>>>>>>  }
>>>>>>>  
>>>>>>> +static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
>>>>>>> +{
>>>>>>> +	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
>>>>>>
>>>>>> Why do you have IS_ENABLED(CONFIG_TI_K3_AM65_CPTS), if
>>>>>> am65_cpts_release() defined as empty when CONFIG_TI_K3_AM65_CPTS not set?
>>>>>>
>>>>>> How is it possible to have common->cpts == NULL?
>>>>>
>>>>> Thank you for reviewing the patch. I realize now that checking
>>>>> CONFIG_TI_K3_AM65_CPTS is unnecessary.
>>>>>
>>>>> common->cpts remains NULL in the following cases:
>>>
>>> I realized that the cases I mentioned are not explained clearly. Therefore, I
>>> will mention the cases again, along with the section of code they correspond to,
>>> in order to make it clear.
>>>
>>> Case-1: am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not
>>> enabled. This corresponds to the following section within am65_cpsw_init_cpts():
>>>
>>> if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
>>> 	return 0;
>>>
>>> In this case, common->cpts remains NULL, but it is not a problem even if the
>>> am65_cpsw_nuss_probe() fails later, since the am65_cpts_release() function is
>>> NOP. Thus, this case is not an issue.
>>>
>>> Case-2: am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not present
>>> in the device tree. This corresponds to the following section within
>>> am65_cpsw_init_cpts():
>>>
>>> node = of_get_child_by_name(dev->of_node, "cpts");
>>> if (!node) {
>>> 	dev_err(dev, "%s cpts not found\n", __func__);
>>> 	return -ENOENT;
>>> }
>>>
>>> In this case as well, common->cpts remains NULL, but it is not a problem because
>>> the probe fails and the execution jumps to "err_of_clear", which doesn't invoke
>>> am65_cpsw_cpts_cleanup(). Therefore, common->cpts being NULL is not a problem.
>>>
>>> Case-3 and Case-4 are described later in this mail.
>>>
>>>>> 1. am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not enabled.
>>>>> 2. am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not defined.
>>>>> 3. The call to am65_cpts_create() fails within the am65_cpsw_init_cpts()
>>>>> function with a return value of 0 when cpts is disabled.
>>>>
>>>> In this case common->cpts is not NULL and is set to error pointer.
>>>> Probe will continue normally.
>>>> Is it OK to call any of the cpts APIs with invalid handle?
>>>> Also am65_cpts_release() will be called with invalid handle.
>>>
>>> Yes Roger, thank you for pointing it out. When I wrote "cpts is disabled", I had
>>> meant that the following section is executed within the am65_cpsw_init_cpts()
>>> function:
>>>
>>> Case-3:
>>>
>>> cpts = am65_cpts_create(dev, reg_base, node);
>>> if (IS_ERR(cpts)) {
>>> 	int ret = PTR_ERR(cpts);
>>>
>>> 	of_node_put(node);
>>> 	if (ret == -EOPNOTSUPP) {
>>> 		dev_info(dev, "cpts disabled\n");
>>> 		return 0;
>>> 	}
>>
>> This code block is unreachable, because of config earlier.
>>   1916 static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
>>   1917 {
>> ...
>>   1923         if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
>>   1924                 return 0;
>> ...
>>   1933         cpts = am65_cpts_create(dev, reg_base, node);
>>   1934         if (IS_ERR(cpts)) {
>>   1935                 int ret = PTR_ERR(cpts);
>>   1936
>>   1937                 of_node_put(node);
>>   1938                 if (ret == -EOPNOTSUPP) {
>>   1939                         dev_info(dev, "cpts disabled\n");
>>   1940                         return 0;
>>   1941                 }
>>
>> You should delete all the logic above.
> 
> Leon,
> 
> I did not realize that the code block is unreachable. I had assumed it was valid
> and handled the case where the CONFIG_TI_K3_AM65_CPTS config is enabled and one
> of the functions within am65_cpts_create() return -EOPNOTSUPP, since this
> section of code was already present. I analyzed the possible return values of
> all the functions within am65_cpts_create() and like you pointed out, none of
> them seem to return -EOPNOTSUPP.
> 
> 
> Roger,
> 
> Please let me know if you can identify a case where CONFIG_TI_K3_AM65_CPTS is
> enabled and one of the functions within the am65_cpts_create() function return
> -EOPNOTSUPP. I was unable to find one after analyzing the return values.

I couldn't find either.

> Therefore, I shall proceed with adding a cleanup patch which deletes the
> unreachable code block, followed by updating this patch with Leon's first
> suggestion of dropping am65_cpsw_cpts_cleanup() entirely, since common->cpts
> being NULL won't have any problem and am65_cpts_release() can be invoked
> directly. I will post these two patches as the v3 series if there are no issues.


cheers,
-roger
