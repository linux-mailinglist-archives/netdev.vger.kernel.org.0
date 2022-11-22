Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ED3633C5F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiKVMXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiKVMXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:23:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444D41580A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 751BEB81A2E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78180C433D7;
        Tue, 22 Nov 2022 12:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669119824;
        bh=7hEdVBzmjmNhDuloSeS1mxbcKCROBQcm0XS/Jr+pdeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSgTaWGGf4Ndil1om9PvkOtuPVr0Rs/NC+uhGezGEJbxkrO5fIKFfgohcrGhDPYGg
         fo+5uqLOs4P+AJTQ2Wg8QIzig12CYMZpwvtTzCE1RQ2zptDqcdi+1Hr1gi+urPgMYi
         V64j39vuq6wbthza633ICslDFd2C+g/XgYHur9854fZy/wrPp/T7igBaTbPD9XSdrM
         IF1WBGC5t7scS1fdVBxMaSnZcW+xtmpJCDdv0iDLu+6rAPcU3aOGkKOfUoJvoRmD5V
         xDvCQt1nes5cax2xmcMdzWBTO3hrSuP87Cmdo+HaqtpOpJm2yRABlwESDYXxer7Yea
         OL8JhzKVkOEDQ==
Date:   Tue, 22 Nov 2022 14:23:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        manishc@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2] bnx2x: fix pci device refcount leak in
 bnx2x_vf_is_pcie_pending()
Message-ID: <Y3y/TF3ryvKH9BG6@unreal>
References: <20221119070202.1407648-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119070202.1407648-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 03:02:02PM +0800, Yang Yingliang wrote:
> As comment of pci_get_domain_bus_and_slot() says, it returns
> a pci device with refcount increment, when finish using it,
> the caller must decrement the reference count by calling
> pci_dev_put(). Call pci_dev_put() before returning from
> bnx2x_vf_is_pcie_pending() to avoid refcount leak.
> 
> Fixes: b56e9670ffa4 ("bnx2x: Prepare device and initialize VF database")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Unindents success path suggested by Jakub.
>   And Cc all pepole in the maintainer list.
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index 11d15cd03600..77d4cb4ad782 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -795,16 +795,20 @@ static void bnx2x_vf_enable_traffic(struct bnx2x *bp, struct bnx2x_virtf *vf)
>  
>  static u8 bnx2x_vf_is_pcie_pending(struct bnx2x *bp, u8 abs_vfid)
>  {
> -	struct pci_dev *dev;
>  	struct bnx2x_virtf *vf = bnx2x_vf_by_abs_fid(bp, abs_vfid);
> +	struct pci_dev *dev;
> +	bool pending;
>  
>  	if (!vf)
>  		return false;
>  
>  	dev = pci_get_domain_bus_and_slot(vf->domain, vf->bus, vf->devfn);
> -	if (dev)
> -		return bnx2x_is_pcie_pending(dev);
> -	return false;
> +	if (!dev)
> +		return false;
> +	pending = bnx2x_is_pcie_pending(dev);
> +	pci_dev_put(dev);
> +
> +	return pending;
>  }
>  

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
