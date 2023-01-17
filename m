Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEEC66DC8C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbjAQLfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbjAQLed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:34:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB878A42;
        Tue, 17 Jan 2023 03:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB45A612DB;
        Tue, 17 Jan 2023 11:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4057C433EF;
        Tue, 17 Jan 2023 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673955269;
        bh=XldLmPxsEbAilYUVqfwqqmmmZ6DzQ4wzFtjz1+pmAX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDaDaZjCaJr6OvkbhLZv+QRu0YCqlHhzWZQyJqNa/mg28Uda969mf4R9wq2osjETm
         GSDHbgaa54B5H1kUtrW8Vj/C23Q6svi93VnTZbqbmpwLqFE5KHpC9hfKSJOt82fdll
         FYsK0q6PukUFF5APbBEP2+LS8MdkTLgMFuSQeq30TGpdPiGSkT/JmoSvwoc8H/CmCf
         OjA8TB+GsH72S5QbZFq4FHPQluXKpmsAgL5SZdmMqg0MOmtetF+mWf9GCyyXCig/qb
         cDx+a4Pfou3N24OSs8S66Ppe7VX9xNgU3YvP+hnS1oLrItxfCEgsRVNIRFQEthACpG
         s0vXCIfm4VkVQ==
Date:   Tue, 17 Jan 2023 13:34:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     Roger Quadros <rogerq@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vigneshr@ti.com, srk@ti.com
Subject: Re: [PATCH net-next v2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS
 release action
Message-ID: <Y8aHwSnVK9+sAb24@unreal>
References: <20230116044517.310461-1-s-vadapalli@ti.com>
 <Y8T8+rWrvv6gfNxa@unreal>
 <f83831f8-b827-18df-36d4-48d9ff0056e1@ti.com>
 <b33c25c5-c93f-6860-b0a5-58279022a91c@kernel.org>
 <aebaa171-bf4e-c143-a186-a37cd34b724e@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aebaa171-bf4e-c143-a186-a37cd34b724e@ti.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 10:30:26AM +0530, Siddharth Vadapalli wrote:
> Roger, Leon,
> 
> On 16/01/23 21:31, Roger Quadros wrote:
> > Hi Siddharth,
> > 
> > On 16/01/2023 09:43, Siddharth Vadapalli wrote:
> >>
> >>
> >> On 16/01/23 13:00, Leon Romanovsky wrote:
> >>> On Mon, Jan 16, 2023 at 10:15:17AM +0530, Siddharth Vadapalli wrote:
> >>>> The am65_cpts_release() function is registered as a devm_action in the
> >>>> am65_cpts_create() function in am65-cpts driver. When the am65-cpsw driver
> >>>> invokes am65_cpts_create(), am65_cpts_release() is added in the set of devm
> >>>> actions associated with the am65-cpsw driver's device.
> >>>>
> >>>> In the event of probe failure or probe deferral, the platform_drv_probe()
> >>>> function invokes dev_pm_domain_detach() which powers off the CPSW and the
> >>>> CPSW's CPTS hardware, both of which share the same power domain. Since the
> >>>> am65_cpts_disable() function invoked by the am65_cpts_release() function
> >>>> attempts to reset the CPTS hardware by writing to its registers, the CPTS
> >>>> hardware is assumed to be powered on at this point. However, the hardware
> >>>> is powered off before the devm actions are executed.
> >>>>
> >>>> Fix this by getting rid of the devm action for am65_cpts_release() and
> >>>> invoking it directly on the cleanup and exit paths.
> >>>>
> >>>> Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
> >>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> >>>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> >>>> ---
> >>>> Changes from v1:
> >>>> 1. Fix the build issue when "CONFIG_TI_K3_AM65_CPTS" is not set. This
> >>>>    error was reported by kernel test robot <lkp@intel.com> at:
> >>>>    https://lore.kernel.org/r/202301142105.lt733Lt3-lkp@intel.com/
> >>>> 2. Collect Reviewed-by tag from Roger Quadros.
> >>>>
> >>>> v1:
> >>>> https://lore.kernel.org/r/20230113104816.132815-1-s-vadapalli@ti.com/
> >>>>
> >>>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 ++++++++
> >>>>  drivers/net/ethernet/ti/am65-cpts.c      | 15 +++++----------
> >>>>  drivers/net/ethernet/ti/am65-cpts.h      |  5 +++++
> >>>>  3 files changed, 18 insertions(+), 10 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> index 5cac98284184..00f25d8a026b 100644
> >>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> @@ -1913,6 +1913,12 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
> >>>>  	return 0;
> >>>>  }
> >>>>  
> >>>> +static void am65_cpsw_cpts_cleanup(struct am65_cpsw_common *common)
> >>>> +{
> >>>> +	if (IS_ENABLED(CONFIG_TI_K3_AM65_CPTS) && common->cpts)
> >>>
> >>> Why do you have IS_ENABLED(CONFIG_TI_K3_AM65_CPTS), if
> >>> am65_cpts_release() defined as empty when CONFIG_TI_K3_AM65_CPTS not set?
> >>>
> >>> How is it possible to have common->cpts == NULL?
> >>
> >> Thank you for reviewing the patch. I realize now that checking
> >> CONFIG_TI_K3_AM65_CPTS is unnecessary.
> >>
> >> common->cpts remains NULL in the following cases:
> 
> I realized that the cases I mentioned are not explained clearly. Therefore, I
> will mention the cases again, along with the section of code they correspond to,
> in order to make it clear.
> 
> Case-1: am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not
> enabled. This corresponds to the following section within am65_cpsw_init_cpts():
> 
> if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
> 	return 0;
> 
> In this case, common->cpts remains NULL, but it is not a problem even if the
> am65_cpsw_nuss_probe() fails later, since the am65_cpts_release() function is
> NOP. Thus, this case is not an issue.
> 
> Case-2: am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not present
> in the device tree. This corresponds to the following section within
> am65_cpsw_init_cpts():
> 
> node = of_get_child_by_name(dev->of_node, "cpts");
> if (!node) {
> 	dev_err(dev, "%s cpts not found\n", __func__);
> 	return -ENOENT;
> }
> 
> In this case as well, common->cpts remains NULL, but it is not a problem because
> the probe fails and the execution jumps to "err_of_clear", which doesn't invoke
> am65_cpsw_cpts_cleanup(). Therefore, common->cpts being NULL is not a problem.
> 
> Case-3 and Case-4 are described later in this mail.
> 
> >> 1. am65_cpsw_init_cpts() returns 0 since CONFIG_TI_K3_AM65_CPTS is not enabled.
> >> 2. am65_cpsw_init_cpts() returns -ENOENT since the cpts node is not defined.
> >> 3. The call to am65_cpts_create() fails within the am65_cpsw_init_cpts()
> >> function with a return value of 0 when cpts is disabled.
> > 
> > In this case common->cpts is not NULL and is set to error pointer.
> > Probe will continue normally.
> > Is it OK to call any of the cpts APIs with invalid handle?
> > Also am65_cpts_release() will be called with invalid handle.
> 
> Yes Roger, thank you for pointing it out. When I wrote "cpts is disabled", I had
> meant that the following section is executed within the am65_cpsw_init_cpts()
> function:
> 
> Case-3:
> 
> cpts = am65_cpts_create(dev, reg_base, node);
> if (IS_ERR(cpts)) {
> 	int ret = PTR_ERR(cpts);
> 
> 	of_node_put(node);
> 	if (ret == -EOPNOTSUPP) {
> 		dev_info(dev, "cpts disabled\n");
> 		return 0;
> 	}

This code block is unreachable, because of config earlier.
  1916 static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
  1917 {
...
  1923         if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
  1924                 return 0;
...
  1933         cpts = am65_cpts_create(dev, reg_base, node);
  1934         if (IS_ERR(cpts)) {
  1935                 int ret = PTR_ERR(cpts);
  1936
  1937                 of_node_put(node);
  1938                 if (ret == -EOPNOTSUPP) {
  1939                         dev_info(dev, "cpts disabled\n");
  1940                         return 0;
  1941                 }

You should delete all the logic above.

Thanks
