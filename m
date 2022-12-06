Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA99C6440FD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiLFKKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiLFKJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:09:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DB625C4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:02:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D376D612F4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A79C433C1;
        Tue,  6 Dec 2022 10:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320959;
        bh=W+U4g9oT9hoz6TyxcYb6WtqTgSP2tm3BeDOnNiaWctw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y8uIOsvjzvGdysVIxHgoZY8WSqBlgd7Ug5oGoEdouyeegqJp5Y/uHYC+nVhBs2IV5
         V4azNNlOtLf6AlS/SyqVaSVmENRCiNmxuTMNdnF5oGYwNx0tSr9mGAas1dTmn1g7a2
         6DX9hJn5zSxWOgPUkjCSGUFm7cBq0Hv87Q4jfnxhPvnv23zD8fdo1RKOro5yURIdUn
         pAxDUuWtPwxazrksTc4xApsfCibJKvnxWZqGe/hJEGKJA7l9y/H31AxaPG5RCiizy7
         MvDFrLa9HBGIRh/O54u+92MB+ZZKjYIzFkoutUdGDulvDm28ei6YO+oxXCjUusl4Qv
         2lkyFZWRtKtJg==
Date:   Tue, 6 Dec 2022 12:02:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jeffrey.t.kirsher@intel.com,
        alice.michael@intel.com, piotr.marczak@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] intel/i40e: Fix potential memory leak in
 i40e_init_recovery_mode()
Message-ID: <Y48TO7s0K9J0kVh0@unreal>
References: <20221206092613.122952-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206092613.122952-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 09:26:13AM +0000, Yuan Can wrote:
> If i40e_vsi_mem_alloc() failed in i40e_init_recovery_mode(), the pf will be
> freed with the pf->vsi leaked.
> Fix by free pf->vsi in the error handling path.
> 
> Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
>  1 file changed, 1 insertion(+)

The patch title needs to be "[PATCH net]..." 

> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index b5dcd15ced36..d23081c224d6 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -15536,6 +15536,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
>  	pci_disable_pcie_error_reporting(pf->pdev);
>  	pci_release_mem_regions(pf->pdev);
>  	pci_disable_device(pf->pdev);
> +	kfree(pf->vsi);
>  	kfree(pf);
>  
>  	return err;

The change is ok, but it is worth to cleanup error flow of i40e_probe and i40e_remove
as they are not really in the same order.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
