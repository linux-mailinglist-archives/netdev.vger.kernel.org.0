Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB566C52C
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjAPQCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjAPQBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:01:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164272386D;
        Mon, 16 Jan 2023 08:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B9DB81061;
        Mon, 16 Jan 2023 16:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF783C433F0;
        Mon, 16 Jan 2023 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673884906;
        bh=y0ykQ5LxFyBMrgAOQxypx7vnPabzGGYUIb99kre3vn0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RZrpQpaLuDnKOcBDICQF/OAAYXnQ43KVfMZ7t1c7g4/ozCliZf8WnDSxoesPwBMeQ
         b1u/BOlnUqWiov9JRjEAgH74CZ3QPMYBJqZFwG4N7w90eCOYqCXL0R2c2c/5LbtEgZ
         5t9JAzBkogX9B5qnVSnLzYSBiTYUV+G7L0EI5UhTNkYVgHNGr4GIA0uNajhpbo/hZI
         bKEiE01cZjbG10SXTHWSs6Cd+0EV7+tx8i1y+P+6gaWgpSytcYtHko3ZcrLQ7sTGbn
         xxv8+o/7BZEQc76RkwitlAp1o5GFWoshQ3sPysrqSszHiWg0Onpl6sYLBdsnsDj87U
         OZxEEHwPOvo+Q==
Message-ID: <b33c25c5-c93f-6860-b0a5-58279022a91c@kernel.org>
Date:   Mon, 16 Jan 2023 18:01:40 +0200
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
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
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

Hi Siddharth,

On 16/01/2023 09:43, Siddharth Vadapalli wrote:
> 
> 
> On 16/01/23 13:00, Leon Romanovsky wrote:
>> On Mon, Jan 16, 2023 at 10:15:17AM +0530, Siddharth Vadapalli wrote:
>>> The am65_cpts_release() function is registered as a devm_action in the
>>> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
>>> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
>>> actions associated with the am65-cpsw driver's device.
>>>
>>> In the event of probe failure or probe deferral, the platform_drv_probe()
>>> function invokes dev_pm_domain_detach() which powers off the CPSW and the
>>> CPSW's CPTS hardware, both of which share the same power domain. Since the
>>> am65_cpts_disable() function invoked by the am65_cpts_release() function
>>> attempts to reset the CPTS hardware by writing to its registers, the CPTS
>>> hardware is assumed to be powered on at this point. However, the hardware
>>> is powered off before the devm actions are executed.
>>>
>>> Fix this by getting rid of the devm action for am65_cpts_release() and
>>> invoking it directly on the cleanup and exit paths.
>>>
>>> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>>> ---
>>> Changes from v1:
>>> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
>>>    error was reported by kernel test robot <lkp@intel.com> at:
>>>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
>>> 2. Collect Reviewed-by tag from Roger Quadros.
>>>
>>> v1:
>>> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
>>>
>>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
>>>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
>>>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
>>>  3 files changed, 18 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>> index 5cac98284184..00f25d8a026b 100644
>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>> @@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
>>>  	return 0;
>>>  }
>>>  
>>> +static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
>>> +{
>>> +	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
>>
>> Why do you have IS_ENABLED(CONFIG_TI_K3_AM65_CPTS), if
>> am65_cpts_release() defined as empty when CONFIG_TI_K3_AM65_CPTS not set?
>>
>> How is it possible to have common->cpts == NULL?
> 
> Thank you for reviewing the patch. I realize now that checking
> CONFIG_TI_K3_AM65_CPTS is unnecessary.
> 
> common->cpts remains NULL in the following cases:
> 1. am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not enabled.
> 2. am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not defined.
> 3. The call to am65_cpts_create() fails within the am65_cpsw_init_cpts()
> function with a return value of 0 when cpts is disabled.

In this case common->cpts is not NULL and is set to error pointer.
Probe will continue normally.
Is it OK to call any of the cpts APIs with invalid handle?
Also am65_cpts_release() will be called with invalid handle.

> 4. The call to am65_cpts_create() within the am65_cpsw_init_cpts() function
> fails with an error.

In this case common->cpts is not NULL and will invoke am65_cpts_release() with
invalid handle.

> 
> Of the above cases, the am65_cpsw_cpts_cleanup() function would have to handle
> cases 1 and 3, since the probe might fail at a later point, following which the
> probe cleanup path will invoke the am65_cpts_cpts_cleanup() function. This
> function then checks for common->cpts not being NULL, so that it can invoke the
> am65_cpts_release() function with this pointer.
> 
>>
>> And why do you need special am65_cpsw_cpts_cleanup() which does nothing
>> except call to am65_cpts_release()? It will be more intuitive change
>> the latter to be exported function.
> 
> The am65_cpts_release() function expects the cpts pointer to be valid. Thus, I
> had added the am65_cpsw_cpts_cleanup() function to conditionally invoke the
> am65_cpts_release() function whenever the cpts pointer is valid. Based on your
> suggestion, I believe that you want me to check for the cpts pointer being valid
> within the am65_cpts_release() function instead, so that the
> am65_cpsw_cpts_cleanup() function doesn't have to be added. Please let me know
> if this is what you meant.
> 
> Regards,
> Siddharth.

cheers,
-roger
