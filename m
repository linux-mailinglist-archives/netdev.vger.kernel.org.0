Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D0F60CB3C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJYLsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJYLsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:48:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4680217F678
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6BE9618EA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93367C433C1;
        Tue, 25 Oct 2022 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666698498;
        bh=2ROlWHa70F2WDyqIW300h9XR0daG/M6Ddk7CUZwWQB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjtFwIQtaLLbBdm0UfyDSH8zE0txpBU2XhyMHWwZSm/xBjkkZtk7XeOTOQzOmRaOO
         nfK7hJEF5egPidZrVkk57HaIWjJeBIBQFjSTUOPGSYfyKrTztotfgnif4RiKBRw50O
         xze/KSTFIRq/83yvy9bCw/352BG+4lZfPsSbjYN9s65YYbBXSX00pspq4Oy4uS01mD
         T+DwzToi9HABOTqBhnjFbyREWapKml2oSDZNBM1a2KsCNjpaMqV2w/36irVY9BXhQt
         dPXhlc8CtB0xPYgaWcDFT/eFCxXh65wxQ6RIuL77d+3BGKgra8H5+RnQCzR/RtJjZj
         oq6GZnr/AZVbw==
Date:   Tue, 25 Oct 2022 14:48:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net] net: fealnx: fix missing pci_disable_device()
Message-ID: <Y1fM/vPXWz2mKhnq@unreal>
References: <20221024135728.2894863-1-yangyingliang@huawei.com>
 <Y1eUnh/DiEvYvVdO@unreal>
 <1adbffd3-6503-938e-b0b8-9525b72f00b3@huawei.com>
 <Y1e5+UMaHn3bsY5Y@unreal>
 <4b1c521f-4d33-a496-81c5-79abe7521446@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b1c521f-4d33-a496-81c5-79abe7521446@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 07:25:48PM +0800, Yang Yingliang wrote:
> 
> On 2022/10/25 18:27, Leon Romanovsky wrote:
> > On Tue, Oct 25, 2022 at 05:01:58PM +0800, Yang Yingliang wrote:
> > > On 2022/10/25 15:47, Leon Romanovsky wrote:
> > > > On Mon, Oct 24, 2022 at 09:57:28PM +0800, Yang Yingliang wrote:
> > > > > pci_disable_device() need be called while module exiting, switch
> > > > > to use pcim_enable(), pci_disable_device() and pci_release_regions()
> > > > > will be called in pcim_release() while unbinding device.
> > > > I didn't understand the description at all, maybe people in CC will.
> > > > Most likely, you wanted something like this:
> > > After using pcim_enable_device(), pcim_release() will be called while
> > > unbinding
> > > device, pcim_release() calls both pci_release_regions() and
> > > pci_disable_device().
> > I'm not sure that you can mix managed with unmanaged PCI APIs.
> > 
> > Thanks
> After pcim_enable_device() being called, the region_mask is set in
> __pci_request_region(). pcim_release() will call pci_release_region()
> because region_mask is set.
> 
> Without device managed, the pci_release_region() and pci_disable_device()
> is called at end of remove() function which is called in device_remove(),
> and
> with managed, they are called in device_unbind_cleanup() which is called
> after device_remove(). So I think it's OK to use this management.

Even so, why do you think that call in device_unbind_cleanup() is the
right one for such an old driver?

Thanks

> 
> Thanks,
> Yang
> > 
> > > Thanks,
> > > Yang
> > > > diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
> > > > index ed18450fd2cc..78107dd4aa57 100644
> > > > --- a/drivers/net/ethernet/fealnx.c
> > > > +++ b/drivers/net/ethernet/fealnx.c
> > > > @@ -690,6 +690,7 @@ static void fealnx_remove_one(struct pci_dev *pdev)
> > > >                   pci_iounmap(pdev, np->mem);
> > > >                   free_netdev(dev);
> > > >                   pci_release_regions(pdev);
> > > > +               pci_disable_device(pdev);
> > > >           } else
> > > >                   printk(KERN_ERR "fealnx: remove for unknown device\n");
> > > > 
> > > > 
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > > > ---
> > > > >    drivers/net/ethernet/fealnx.c | 4 +---
> > > > >    1 file changed, 1 insertion(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
> > > > > index ed18450fd2cc..fb139f295b67 100644
> > > > > --- a/drivers/net/ethernet/fealnx.c
> > > > > +++ b/drivers/net/ethernet/fealnx.c
> > > > > @@ -494,7 +494,7 @@ static int fealnx_init_one(struct pci_dev *pdev,
> > > > >    	option = card_idx < MAX_UNITS ? options[card_idx] : 0;
> > > > > -	i = pci_enable_device(pdev);
> > > > > +	i = pcim_enable_device(pdev);
> > > > >    	if (i) return i;
> > > > >    	pci_set_master(pdev);
> > > > > @@ -670,7 +670,6 @@ static int fealnx_init_one(struct pci_dev *pdev,
> > > > >    err_out_unmap:
> > > > >    	pci_iounmap(pdev, ioaddr);
> > > > >    err_out_res:
> > > > > -	pci_release_regions(pdev);
> > > > >    	return err;
> > > > >    }
> > > > > @@ -689,7 +688,6 @@ static void fealnx_remove_one(struct pci_dev *pdev)
> > > > >    		unregister_netdev(dev);
> > > > >    		pci_iounmap(pdev, np->mem);
> > > > >    		free_netdev(dev);
> > > > > -		pci_release_regions(pdev);
> > > > >    	} else
> > > > >    		printk(KERN_ERR "fealnx: remove for unknown device\n");
> > > > >    }
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> > > > .
> > .
