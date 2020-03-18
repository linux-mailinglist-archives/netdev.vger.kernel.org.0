Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE8189D9C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCROJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgCROJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 10:09:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAE912076C;
        Wed, 18 Mar 2020 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584540576;
        bh=jNklIAKPeXF8HdRlafhYPt2WAzMDTcEht1mEZgThi4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/NTyTZph/U8DNw6h9Zz5RKkwmE0aHocs7opErzfenbQuiLzzRNSlzKGw6RBWIf6B
         Fc4BVC6O57OT4qTmDmYm7XXk3/gbP4gy0CZ7eTRd2tDCQuGWNxbk8WnZn1e/23kIYJ
         FpG6dTinRbMOvKstmqtCjCHamUAU6Wncjrnmhr2A=
Date:   Wed, 18 Mar 2020 16:09:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318140932.GB126814@unreal>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
 <20200318132100.GK13183@mellanox.com>
 <20200318135631.GA126497@unreal>
 <20200318140001.GL13183@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200318140001.GL13183@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:00:01AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 18, 2020 at 03:56:31PM +0200, Leon Romanovsky wrote:
> > On Wed, Mar 18, 2020 at 10:21:00AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Mar 18, 2020 at 03:14:50PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Mar 18, 2020 at 09:54:59AM -0300, Jason Gunthorpe wrote:
> > > > > On Wed, Mar 18, 2020 at 02:43:25PM +0200, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > > > >
> > > > > > From Yishai,
> > > > > >
> > > > > > This series exposes API to enable a dynamic allocation and management of a
> > > > > > UAR which now becomes to be a regular uobject.
> > > > > >
> > > > > > Moving to that mode enables allocating a UAR only upon demand and drop the
> > > > > > redundant static allocation of UARs upon context creation.
> > > > > >
> > > > > > In addition, it allows master and secondary processes that own the same command
> > > > > > FD to allocate and manage UARs according to their needs, this can’t be achieved
> > > > > > today.
> > > > > >
> > > > > > As part of this option, QP & CQ creation flows were adapted to support this
> > > > > > dynamic UAR mode once asked by user space.
> > > > > >
> > > > > > Once this mode is asked by mlx5 user space driver on a given context, it will
> > > > > > be mutual exclusive, means both the static and legacy dynamic modes for using
> > > > > > UARs will be blocked.
> > > > > >
> > > > > > The legacy modes are supported for backward compatible reasons, looking
> > > > > > forward we expect this new mode to be the default.
> > > > >
> > > > > We are starting to accumulate a lot of code that is now old-rdma-core
> > > > > only.
> > > >
> > > > Agree
> > > >
> > > > >
> > > > > I have been wondering if we should add something like
> > > > >
> > > > > #if CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION < 21
> > > > > #endif
> > > >
> > > > From one side it will definitely help to see old code, but from another
> > > > it will create many ifdef inside of the code with a very little chance
> > > > of testing. Also we will continue to have the same problem to decide when
> > > > we can delete this code.
> > >
> > > Well, it doesn't have to be an #ifdef, eg just sticking
> > >
> > > if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
> > >      return -ENOPROTOOPT;
> > >
> > > at the top of obsolete functions would go a long way
> >
> > First, how will you set this min_version? hordcoded in the kernel
> > code?
>
> Yes, when a rdma-core release obsoletes the code path then it can
> become annotated.
>
> > Second, it will work for simple flows, but can be extremely complex
> > if your code looks like:
> > if (old_version)
> >  do something
> > if (new version)
> >  do something else
>
> Well, we'd avoid making such complications, it would be something like
>
> if (flag & foo) {
>    if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
>       return -ENOPROTOOPT;
>   [keep going as before]
> }
>
> At least we now know this conditional path isn't used / isn't covered
> by testing

I'm ok with this approach because it helps us to find those dead
paths, but have last question, shouldn't this be achieved with
proper documentation of every flag instead of adding CONFIG_..?

>
> Doug? What does a distro think?
>
> Jason
