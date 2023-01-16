Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9D766BB2E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjAPKF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjAPKEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:04:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704B6193C3;
        Mon, 16 Jan 2023 02:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF16060EEA;
        Mon, 16 Jan 2023 10:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1DCC433D2;
        Mon, 16 Jan 2023 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673863478;
        bh=yUzwH9Ke9wKRkIj/1dw81U6sB1xyw9DLNsfLkvCxbhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQ2b33CXN4NLnxZPZ9aUJ19rJ8lQkBrQ3AH3GKReYbpODOYh4GOX56zF2YBFSkq7g
         TPjDDdJP7f5T2AjEbbbdAYY50uvcQ5Eggtm0/ia1cycAVG8atX+mXGdo5skT46kAPK
         79/h71ygJG5BSR+4cJxC2w03UG/RCtUzH314fhunizYYc9/BbVhTnm88i6OvUy26EC
         J86KrxEwOhUM/9K/1dXVgMNMOYQJHFoVni/+iisF24PaaFzySqPjZUewA4JAvlhv3q
         VNdgvEAsrVtn9HStWHcIWfekfKfWAAdcOyA7wZkqff36sDR8bOCONfJqD5odPU+y9g
         8Smx19Evuc6XQ==
Date:   Mon, 16 Jan 2023 12:04:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
Subject: Re: [PATCH net-next v2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS
 release action
Message-ID: <Y8UhMVPTo3qVgkyc@unreal>
References: <20230116044517.310461-1-s-vadapalli@ti.com>
 <Y8T8+rWrvv6gfNxa@unreal>
 <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 01:13:36PM +0530, Siddharth Vadapalli wrote:
> 
> 
> On 16/01/23 13:00, Leon Romanovsky wrote:
> > On Mon, Jan 16, 2023 at 10:15:17AM +0530, Siddharth Vadapalli wrote:
> >> The am65_cpts_release() function is registered as a devm_action in the
> >> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
> >> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
> >> actions associated with the am65-cpsw driver's device.
> >>
> >> In the event of probe failure or probe deferral, the platform_drv_probe()
> >> function invokes dev_pm_domain_detach() which powers off the CPSW and the
> >> CPSW's CPTS hardware, both of which share the same power domain. Since the
> >> am65_cpts_disable() function invoked by the am65_cpts_release() function
> >> attempts to reset the CPTS hardware by writing to its registers, the CPTS
> >> hardware is assumed to be powered on at this point. However, the hardware
> >> is powered off before the devm actions are executed.
> >>
> >> Fix this by getting rid of the devm action for am65_cpts_release() and
> >> invoking it directly on the cleanup and exit paths.
> >>
> >> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
> >> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> >> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> >> ---
> >> Changes from v1:
> >> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
> >>    error was reported by kernel test robot <lkp@intel.com> at:
> >>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
> >> 2. Collect Reviewed-by tag from Roger Quadros.
> >>
> >> v1:
> >> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
> >>
> >>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
> >>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
> >>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
> >>  3 files changed, 18 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> index 5cac98284184..00f25d8a026b 100644
> >> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >> @@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
> >>  	return 0;
> >>  }
> >>  
> >> +static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
> >> +{
> >> +	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
> > 
> > Why do you have IS_ENABLED(CONFIG_TI_K3_AM65_CPTS), if
> > am65_cpts_release() defined as empty when CONFIG_TI_K3_AM65_CPTS not set?
> > 
> > How is it possible to have common->cpts == NULL?
> 
> Thank you for reviewing the patch. I realize now that checking
> CONFIG_TI_K3_AM65_CPTS is unnecessary.
> 
> common->cpts remains NULL in the following cases:
> 1. am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not enabled.

In this case am65_cpsw_cpts_cleanup() will NOP as well.

> 2. am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not defined.

It is an error and all callers unwind properly.

> 3. The call to am65_cpts_create() fails within the am65_cpsw_init_cpts()
> function with a return value of 0 when cpts is disabled.

It is disabled by CONFIG_TI_K3_AM65_CPTS, which in turn will make
am65_cpsw_cpts_cleanup() NOP.

> 4. The call to am65_cpts_create() within the am65_cpsw_init_cpts() function
> fails with an error.
> 
> Of the above cases, the am65_cpsw_cpts_cleanup() function would have to handle
> cases 1 and 3, since the probe might fail at a later point, following which the
> probe cleanup path will invoke the am65_cpts_cpts_cleanup() function. This
> function then checks for common->cpts not being NULL, so that it can invoke the
> am65_cpts_release() function with this pointer.

I still don't see how it is possible.

Thanks
