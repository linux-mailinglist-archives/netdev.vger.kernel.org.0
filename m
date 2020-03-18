Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69911189D71
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgCRN4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgCRN4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 09:56:36 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA2D120767;
        Wed, 18 Mar 2020 13:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584539795;
        bh=s2Syxr6GUpgn4pQlOKtFC5d8LE8eQFOrX5wK6AAWQT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kHFmFoknlP6Op3f1shVWtVQ9vxp+RCwcw3Ei1K72+2GS9jyD0celskeeyNoQQpaS0
         +hs8Ara2HYc2y1Y2Zly234kr3rCLxmSyj5QrSaR8OD9Rz6irYIeyTl7eppx8XwKYYX
         3LPNVZOr0poX2XEeIisOMicK0ZguX1CST3Iy6c0c=
Date:   Wed, 18 Mar 2020 15:56:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318135631.GA126497@unreal>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
 <20200318132100.GK13183@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200318132100.GK13183@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:21:00AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 18, 2020 at 03:14:50PM +0200, Leon Romanovsky wrote:
> > On Wed, Mar 18, 2020 at 09:54:59AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Mar 18, 2020 at 02:43:25PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > From Yishai,
> > > >
> > > > This series exposes API to enable a dynamic allocation and management of a
> > > > UAR which now becomes to be a regular uobject.
> > > >
> > > > Moving to that mode enables allocating a UAR only upon demand and drop the
> > > > redundant static allocation of UARs upon context creation.
> > > >
> > > > In addition, it allows master and secondary processes that own the same command
> > > > FD to allocate and manage UARs according to their needs, this can’t be achieved
> > > > today.
> > > >
> > > > As part of this option, QP & CQ creation flows were adapted to support this
> > > > dynamic UAR mode once asked by user space.
> > > >
> > > > Once this mode is asked by mlx5 user space driver on a given context, it will
> > > > be mutual exclusive, means both the static and legacy dynamic modes for using
> > > > UARs will be blocked.
> > > >
> > > > The legacy modes are supported for backward compatible reasons, looking
> > > > forward we expect this new mode to be the default.
> > >
> > > We are starting to accumulate a lot of code that is now old-rdma-core
> > > only.
> >
> > Agree
> >
> > >
> > > I have been wondering if we should add something like
> > >
> > > #if CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION < 21
> > > #endif
> >
> > From one side it will definitely help to see old code, but from another
> > it will create many ifdef inside of the code with a very little chance
> > of testing. Also we will continue to have the same problem to decide when
> > we can delete this code.
>
> Well, it doesn't have to be an #ifdef, eg just sticking
>
> if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
>      return -ENOPROTOOPT;
>
> at the top of obsolete functions would go a long way

First, how will you set this min_version? hordcoded in the kernel code?
Second, it will work for simple flows, but can be extremely complex
if your code looks like:
if (old_version)
 do something
if (new version)
 do something else

You will need to add logic to handle this -ENOPROTOOPT error value.

>
> > > So we can keep track of what is actually a used code flow and what is
> > > now hard to test legacy code.
> > >
> > > eg this config would also disable the write interface(), turn off
> > > compat write interfaces as they are switched to use ioctl, etc, etc.
> >
> > What about if we introduce one ifdef, let's say CONFIG_INFINIBAND_LEGACY
> > and put everything that will be declared as legacy to that bucket? And
> > once every 5 (???) years delete everything from that bucket.
>
> It is much harder to see what is really old vs only a little old
>
> I'm not sure we can ever completely delete any of this, but at least
> the distros can make an informed choice to either do more detailed
> test of old libraries or disable those code paths.

It will be nice to hear how distros decide to disable/drop the code.

Thanks

>
> Jason
