Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2CD60C3EB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiJYGmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJYGmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA6F20BCE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 23:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75009B81A49
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 06:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E182C433C1;
        Tue, 25 Oct 2022 06:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666680131;
        bh=l00E+eZjHM9+he3LnrSwL0OtgxlWvyTBo+jQSGz/0+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZaCAviUMgZcTYW92ryB9+rN3mv3ijP4Xs9YCbpuVFqDTwT0u6I64uk3Av4YEHJULB
         JdFKPC//pIAis3GCAxquJVHq6BIA/TUzisoH+Os+PVakoKgIfj1PloZ0stqBVgXvmC
         reabi0qzjSCC2jaGkoGrRpWLl16yM8nrqG+NQUMCVA09wz/3KbOKcsHE60LB5sclQN
         i6BaenHnhdpqzRh0IyaQIGz6ttUKdJdHNRReUtlwxPU1UdziSk60kjPnDwE80p+zb7
         VA4BhdcyngjJo+8jXwkijiayYghcci/l4IRlSt9F4QqEtSVd/jKCNn24RVkTp8MqWE
         NBE80p9+GUr0Q==
Date:   Tue, 25 Oct 2022 09:42:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net] net: fealnx: fix missing pci_disable_device()
Message-ID: <Y1eFP1dGZl28atCB@unreal>
References: <20221024135728.2894863-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024135728.2894863-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 09:57:28PM +0800, Yang Yingliang wrote:
> pci_disable_device() need be called while module exiting, switch
> to use pcim_enable(), pci_disable_device() and pci_release_regions()
> will be called in pcim_release() while unbinding device.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/fealnx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
> index ed18450fd2cc..fb139f295b67 100644
> --- a/drivers/net/ethernet/fealnx.c
> +++ b/drivers/net/ethernet/fealnx.c
> @@ -494,7 +494,7 @@ static int fealnx_init_one(struct pci_dev *pdev,
>  
>  	option = card_idx < MAX_UNITS ? options[card_idx] : 0;
>  
> -	i = pci_enable_device(pdev);
> +	i = pcim_enable_device(pdev);
>  	if (i) return i;
>  	pci_set_master(pdev);
>  
> @@ -670,7 +670,6 @@ static int fealnx_init_one(struct pci_dev *pdev,
>  err_out_unmap:
>  	pci_iounmap(pdev, ioaddr);
>  err_out_res:
> -	pci_release_regions(pdev);
>  	return err;
>  }
>  
> @@ -689,7 +688,6 @@ static void fealnx_remove_one(struct pci_dev *pdev)
>  		unregister_netdev(dev);
>  		pci_iounmap(pdev, np->mem);
>  		free_netdev(dev);
> -		pci_release_regions(pdev);
>  	} else
>  		printk(KERN_ERR "fealnx: remove for unknown device\n");
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This path is not possible.

>  }
> -- 
> 2.25.1
> 
