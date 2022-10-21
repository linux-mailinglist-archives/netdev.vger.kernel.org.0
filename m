Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6EE606C77
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 02:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJUA0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 20:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJUA0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 20:26:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF59F1D6A4A
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 17:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99DFCB82A07
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 00:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAF3C433D6;
        Fri, 21 Oct 2022 00:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666311974;
        bh=o7IQeE9hQiOBqTi3cAA1b5V9lUEkjB/RP3VVoIPrSM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uu7fu/v8CquQI4jKv188aMfjYjq9sDkjhIr35DkhaUNrIfOgPLhfAaLWnca5JpZkX
         XsdzABwWoI7w6xvjcrz8qP2ox21S++TpYdanDepxFyToKHvF9WQ367M7TC2VZY5RFY
         Si9xElf25oscldaVcMVIRLDj5RVeF4ZevqM9VYvdGAL7eMPNKeoR+zUoFlzFmAGlEm
         H33dz0AH4lXjjjJLV7f6VN5Dk75DowBWbcOGQecbtPWCHSg1trvY+b1dw2HposLWZg
         FDix7sKIVrXwXDkEUfqQCdrdZVXxeAYHBCYUusplFXOKO5A9tfz2cXz8KL5moLadKM
         fHd0lIy4WWvTg==
Date:   Thu, 20 Oct 2022 17:26:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net 1/2] netdevsim: fix memory leak in nsim_drv_probe()
 when nsim_dev_resources_register() failed
Message-ID: <20221020172612.0a8e60bb@kernel.org>
In-Reply-To: <20221020023358.263414-2-shaozhengchao@huawei.com>
References: <20221020023358.263414-1-shaozhengchao@huawei.com>
        <20221020023358.263414-2-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 10:33:57 +0800 Zhengchao Shao wrote:
> Fixes: 8fb4bc6fd5bd ("netdevsim: rename devlink.c to dev.c to contain per-dev(asic) items")

Looks like a rename patch.

The Fixes tag must point to the commit which introduced the bug.

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 794fc0cc73b8..39231c5319de 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1554,7 +1554,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>  
>  	err = nsim_dev_resources_register(devlink);
>  	if (err)
> -		goto err_vfc_free;
> +		goto err_dl_unregister;

It's better to add the devl_resources_unregister() call to the error
path of nsim_dev_resources_register(). There should be no need to clean
up after functions when they fail.

>  	err = devlink_params_register(devlink, nsim_devlink_params,
>  				      ARRAY_SIZE(nsim_devlink_params));
> @@ -1627,7 +1627,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>  				  ARRAY_SIZE(nsim_devlink_params));
>  err_dl_unregister:
>  	devl_resources_unregister(devlink);
> -err_vfc_free:
>  	kfree(nsim_dev->vfconfigs);
