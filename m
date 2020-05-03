Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3D71C2A1D
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 07:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgECFaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 01:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgECFaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 01:30:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F19B120752;
        Sun,  3 May 2020 05:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588483809;
        bh=WtCk5/q8+MaoojxvwsgJEVRFB6x1Zkn5zzl85+0q0CU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w8u5EhmdphVWSvbyOCnsjz6uAcfLr8HpI8YnkcO55IcnQpIiaqKSYqPCcbcRSLAjq
         nqCYNTucxOcnETvOIzdpcl+kx3gYa+mIZAc+TAB5pk6V5qvhplr8RCd2tslAySMrh0
         bSdIqBlW/yoMkzXWb03kg6Jb5A0K5BpZXqmDdCik=
Date:   Sun, 3 May 2020 08:30:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in qp_read_field
Message-ID: <20200503053005.GC111287@unreal>
References: <20200428212357.2708786-1-arnd@arndb.de>
 <20200430052157.GD432386@unreal>
 <CAK8P3a25MeyBgwZ9ZF2JbfpVChQuZ1wWc6VT1MFZ8-7haubVDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a25MeyBgwZ9ZF2JbfpVChQuZ1wWc6VT1MFZ8-7haubVDw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 04:37:14PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 30, 2020 at 7:22 AM Leon Romanovsky <leon@kernel.org> wrote:
> > On Tue, Apr 28, 2020 at 11:23:47PM +0200, Arnd Bergmann wrote:
> > > Moving the mlx5_ifc_query_qp_out_bits structure on the stack was a bit
> > > excessive and now causes the compiler to complain on 32-bit architectures:
> > >
> > > drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: In function 'qp_read_field':
> > > drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:274:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > >
> > > Revert the previous patch partially to use dynamically allocation as
> > > the code did before. Unfortunately there is no good error handling
> > > in case the allocation fails.
> > >
> > > Fixes: 57a6c5e992f5 ("net/mlx5: Replace hand written QP context struct with automatic getters")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > Thanks Arnd, I'll pick it to mlx5-next.
> >
> > I was under impression that the frame size was increased a long
> > time ago. Is this 1K limit still effective for all archs?
> > Or is it is 32-bit leftover?
>
> I got the output on a 32-bit build, but that doesn't make the code
> right on 64-bit.
>
> While warning limit is generally 1024 bytes for 32-bit architectures,
> and 2048 bytes fro 64-bit architectures,  we should probably
> reduce the latter to something like 1280 bytes and fix up the
> warnings that introduces.

It a chicken and an egg problem, I tried to use default frame size, but
the output of my kernel build was constantly flooded with those warnings
and made hard to spot real issues in the code I developed.

Thanks

>
> Generally speaking, I'd say a function using more than a few hundred
> bytes tends to be a bad idea, but we can't warn about those without
> also warning about the handful of cases that do it for a good reason
> and using close to 1024 bytes on 32 bit systems or a little more on
> 64-bit systems, in places that are known not to have deep call chains.
>
>        Arnd
