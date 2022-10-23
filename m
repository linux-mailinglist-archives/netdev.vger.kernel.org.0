Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBCB6091BD
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 10:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJWH7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 03:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJWH7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 03:59:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B622792C
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 00:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11CA3B80BA8
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 07:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CCBC433D6;
        Sun, 23 Oct 2022 07:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666511972;
        bh=VgXB2XwceE4fEDMcG13BV72y122Sr8VxhaNxuYuDtWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pvAPi9uubv3lVtwXLUcC7zZdRBdm9wlTelrd1fV4lk0eBRLUEsoV+oskW3rF8W+tw
         zGrQWu5iX2l30ZIUsaIe88AeeEiEQJVsOUMPtiJ5PLqxBytpPk88Xxbx+6a1rWqk2b
         5SLxoTv86z53swtVWFz23GO9rvyAoOxx0geTfBf2lTWVTQ+2pjQgKiw+sTqa2pDyPl
         6D5yz8QKKS/iZOmQ7XoQFf55NA/l+KTUpPIeBbQbaLoDxc9kE4rg38ee+yQoOAnv3H
         5a0U61YfWd/GVdmbfwB1szmr4P6sqWUL+YX9RMzdRG7251iY8qo4YvZpSdAL3mvVee
         yxOnXwBf1fy3Q==
Date:   Sun, 23 Oct 2022 10:59:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net
Subject: Re: [PATCH net] net: hns: fix possible memory leak in
 hnae_ae_register()
Message-ID: <Y1T0YG6EfrZ4JfX9@unreal>
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
 <Y06i/kWwJNT5mbj8@unreal>
 <bcde51e2-3abf-6ff7-b5a5-c23c7886d2f4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bcde51e2-3abf-6ff7-b5a5-c23c7886d2f4@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 03:45:17PM +0800, Yang Yingliang wrote:
> 
> On 2022/10/18 20:58, Leon Romanovsky wrote:
> > On Tue, Oct 18, 2022 at 08:24:51PM +0800, Yang Yingliang wrote:
> > > Inject fault while probing module, if device_register() fails,
> > > but the refcount of kobject is not decreased to 0, the name
> > > allocated in dev_set_name() is leaked. Fix this by calling
> > > put_device(), so that name can be freed in callback function
> > > kobject_cleanup().
> > > 
> > > unreferenced object 0xffff00c01aba2100 (size 128):
> > >    comm "systemd-udevd", pid 1259, jiffies 4294903284 (age 294.152s)
> > >    hex dump (first 32 bytes):
> > >      68 6e 61 65 30 00 00 00 18 21 ba 1a c0 00 ff ff  hnae0....!......
> > >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >    backtrace:
> > >      [<0000000034783f26>] slab_post_alloc_hook+0xa0/0x3e0
> > >      [<00000000748188f2>] __kmem_cache_alloc_node+0x164/0x2b0
> > >      [<00000000ab0743e8>] __kmalloc_node_track_caller+0x6c/0x390
> > >      [<000000006c0ffb13>] kvasprintf+0x8c/0x118
> > >      [<00000000fa27bfe1>] kvasprintf_const+0x60/0xc8
> > >      [<0000000083e10ed7>] kobject_set_name_vargs+0x3c/0xc0
> > >      [<000000000b87affc>] dev_set_name+0x7c/0xa0
> > >      [<000000003fd8fe26>] hnae_ae_register+0xcc/0x190 [hnae]
> > >      [<00000000fe97edc9>] hns_dsaf_ae_init+0x9c/0x108 [hns_dsaf]
> > >      [<00000000c36ff1eb>] hns_dsaf_probe+0x548/0x748 [hns_dsaf]
> > > 
> > > Fixes: 6fe6611ff275 ("net: add Hisilicon Network Subsystem hnae framework support")
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > ---
> > >   drivers/net/ethernet/hisilicon/hns/hnae.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
> > > index 00fafc0f8512..430eccea8e5e 100644
> > > --- a/drivers/net/ethernet/hisilicon/hns/hnae.c
> > > +++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
> > > @@ -419,8 +419,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
> > >   	hdev->cls_dev.release = hnae_release;
> > >   	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
> >                ^^^^^^^^^^^^ this is unexpected in netdev code.
> Did you mean the 'void' can be removed ?

I mean that ethernet names are provided by netdev code and I don't
expect to see any dev_set_name() call in drivers/net/ethernet/* folders.

> > 
> > >   	ret = device_register(&hdev->cls_dev);
> > > -	if (ret)
> > > +	if (ret) {
> > > +		put_device(&hdev->cls_dev);
> > >   		return ret;
> > > +	}
> > >   	__module_get(THIS_MODULE);
> >          ^^^^^^^^ I'm curious why? I don't see why you need this.
> hnae_ae_register() is called from hns_dsaf.ko(hns_dsaf_probe()), the
> refcount of module hnae is already be got while loading hns_dsaf.ko
> in resolve_symbol(),  so I think this can be removed.

Yes.

> 
> Thanks,
> Yang
> > 
> > The change itself is ok.
> > 
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> > .
