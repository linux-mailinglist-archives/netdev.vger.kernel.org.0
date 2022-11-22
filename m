Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253AD633EFF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiKVOdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiKVOcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:32:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6882F6B233
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED33961732
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DDAC433C1;
        Tue, 22 Nov 2022 14:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669127533;
        bh=O+R3C1Bx94WBcq34h7V/7LEICMGNxk41mqGTPC04p70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pubPmM2dwZJAjf3wxUZeCDPT1aLOWsdLQgf/StjOkw9FbZSma9D0oRisZdr996K6U
         yzpazaS5N1Cnu4E8fXXsi0cndH47DayR9eWHYM72D1wuHmjvnVXiJJ2S0dJQUYImXL
         lVJIJPu0aivMNxdqBgICWIYtFUnNhmJKGQte2Jhh/Ywvk99GFH1IXE5/wPynoJef65
         1q+0lbCJ3xsLOQALkt0ZZFWdY/aZcH2RkOGT+ZSGe25R5gLD2+BT5brW6TwoGFeIg/
         5egXaI9kzkjNFuXJ+hIBKKlbM2wulaTFboVcHbJ4nFhBaahEf7cTuI+j7jfdRuGied
         NkFwA/80luAQg==
Date:   Tue, 22 Nov 2022 16:32:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y3zdaX1I0Y8rdSLn@unreal>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122121048.776643-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 08:10:48PM +0800, Yang Yingliang wrote:
> I got a UAF report as following when doing fault injection test:
> 
> BUG: KASAN: use-after-free in devlink_compat_running_version+0x5b9/0x6a0
> Read of size 8 at addr ffff88810ac591f0 by task systemd-udevd/458
> 
> CPU: 2 PID: 458 Comm: systemd-udevd Not tainted 6.1.0-rc5-00155-ga9d2b54dd4e7-dirty #1359
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <TASK>
>  kasan_report+0x90/0x190
>  devlink_compat_running_version+0x5b9/0x6a0
>  dev_ethtool+0x2ca/0x340
>  dev_ioctl+0x16c/0xff0
>  sock_do_ioctl+0x1ae/0x220
> 
> Allocated by task 456:
>  kasan_save_stack+0x1c/0x40
>  kasan_set_track+0x21/0x30
>  __kasan_kmalloc+0x7e/0x90
>  __kmalloc+0x59/0x1b0
>  devlink_alloc_ns+0xf7/0xa10
>  nsim_drv_probe+0xa8/0x150 [netdevsim]
>  really_probe+0x1ff/0x660
> 
> Freed by task 456:
>  kasan_save_stack+0x1c/0x40
>  kasan_set_track+0x21/0x30
>  kasan_save_free_info+0x2a/0x50
>  __kasan_slab_free+0x102/0x190
>  __kmem_cache_free+0xca/0x400
>  nsim_drv_probe.cold.31+0x2af/0xf62 [netdevsim]
>  really_probe+0x1ff/0x660
> 
> It happened like this:
> 
> processor A							processor B
> nsim_drv_probe()
>   devlink_alloc_ns()
>   nsim_dev_port_add_all()
>     __nsim_dev_port_add() // add eth1 successful
> 								dev_ethtool()
> 								  ethtool_get_drvinfo(eth1)
> 								    netdev_to_devlink_get(eth1)
> 								      devlink_try_get() // get devlink here
>     __nsim_dev_port_add() // add eth2 failed, goto error
>       devlink_free() // it's called in the error path
> 								  devlink_compat_running_version() <- causes UAF
>   devlink_register() // it's in normal path, not called yet
> 
> There is two ports to add in nsim_dev_port_add_all(), if first
> port is added successful, the devlink is visable and can be get
> by devlink_try_get() on another cpu, but it is not registered
> yet. And then the second port is failed to added, in the error
> path, devlink_free() is called, at last it causes UAF.
> 
> Add check in devlink_try_get(), if the 'devlink' is not registered
> it returns NULL to avoid UAF like this case.
> 
> Fixes: a62fdbbe9403 ("netdevsim: implement ndo_get_devlink_port")
> Reported-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/core/devlink.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 89baa7c0938b..6453ac0558fb 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -250,6 +250,9 @@ void devlink_put(struct devlink *devlink)
>  
>  struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  {
> +	 if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return NULL;
> +

Please fix nsim instead of devlink.

Thanks

>  	if (refcount_inc_not_zero(&devlink->refcount))
>  		return devlink;
>  	return NULL;
> -- 
> 2.25.1
> 
