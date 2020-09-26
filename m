Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7D727975A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 08:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgIZGxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 02:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgIZGxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 02:53:13 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C75D920878;
        Sat, 26 Sep 2020 06:53:11 +0000 (UTC)
Date:   Sat, 26 Sep 2020 09:53:08 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Eli Cohen <elic@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200926065308.GC2280698@unreal>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
 <20200924120217-mutt-send-email-mst@kernel.org>
 <20200925072005.GB2280698@unreal>
 <20200925061847-mutt-send-email-mst@kernel.org>
 <821c501c-53ce-3e80-8a73-f0680193df20@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <821c501c-53ce-3e80-8a73-f0680193df20@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 07:29:24PM +0800, Jason Wang wrote:
>
> On 2020/9/25 下午6:19, Michael S. Tsirkin wrote:
> > On Fri, Sep 25, 2020 at 10:20:05AM +0300, Leon Romanovsky wrote:
> > > On Thu, Sep 24, 2020 at 12:02:43PM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 24, 2020 at 08:47:05AM -0700, Randy Dunlap wrote:
> > > > > On 9/24/20 3:24 AM, Eli Cohen wrote:
> > > > > > On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
> > > > > > > > > --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> > > > > > > > > +++ linux-next-20200917/drivers/vdpa/Kconfig
> > > > > > > > > @@ -31,7 +31,7 @@ config IFCVF
> > > > > > > > >
> > > > > > > > >   config MLX5_VDPA
> > > > > > > > >   	bool "MLX5 VDPA support library for ConnectX devices"
> > > > > > > > > -	depends on MLX5_CORE
> > > > > > > > > +	depends on VHOST_IOTLB && MLX5_CORE
> > > > > > > > >   	default n
> > > > > > > > While we are here, can anyone who apply this patch delete the "default n" line?
> > > > > > > > It is by default "n".
> > > > > > I can do that
> > > > > >
> > > > > > > > Thanks
> > > > > > > Hmm other drivers select VHOST_IOTLB, why not do the same?
> > > > > v1 used select, but Saeed requested use of depends instead because
> > > > > select can cause problems.
> > > > >
> > > > > > I can't see another driver doing that. Perhaps I can set dependency on
> > > > > > VHOST which by itself depends on VHOST_IOTLB?
> > > > > > >
> > > > > > > > >   	help
> > > > > > > > >   	  Support library for Mellanox VDPA drivers. Provides code that is
> > > > > > > > >
> > > > Saeed what kind of problems? It's used with select in other places,
> > > > isn't it?
> > > IMHO, "depends" is much more explicit than "select".
> > >
> > > Thanks
> > This is now how VHOST_IOTLB has been designed though.
> > If you want to change VHOST_IOTLB to depends I think
> > we should do it consistently all over.
> >
> >
> > config VHOST_IOTLB
> >          tristate
> >          help
> >            Generic IOTLB implementation for vhost and vringh.
> >            This option is selected by any driver which needs to support
> >            an IOMMU in software.
>
>
> Yes, since there's no prompt for VHOST_IOTLB which means, if there's no
> other symbol that select VHOST_IOTLB, you can't enable MLX5 at all.
>
> See kconfig-language.rst:
>
>
>     In general use select only for non-visible symbols
>     (no prompts anywhere) and for symbols with no dependencies.
>     That will limit the usefulness but on the other hand avoid
>     the illegal configurations all over.

Thanks, I wasn't aware of this clarification.

>
> Thanks
>
>
> >
> >
> > > > > --
> > > > > ~Randy
>
