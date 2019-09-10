Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E03CAF210
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfIJTwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:52:11 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39156 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfIJTwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:52:10 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so18328578qki.6;
        Tue, 10 Sep 2019 12:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RR/8LQYEhemm58mBqc6PRWMnQiy34VPyY85MVE0Ja8g=;
        b=NWS/07d31j6nd/4JnxIxVkXAE7O5ZtqcRBXUt9//h8DzdAuEgciW7Tv4mGaFPoKaDp
         kqhU/W87zLpi1Gcw3xFKFKL961DJ3HnvWtcVKG/J3peZAQT72JG9Qp856lZYT26u4KsU
         WN6H59lPIcSu08x/lxFvgNeBu3MxXuxaD2db5pB8z+FxrrNBIFmwpWrxJ3WChKz7Yq+5
         PDlItoU2s8yWaDZxgQxSvE18sIzYuXuE0XwvDV4TFVqaqPTT/6wDhpnIS+/krm05wTV0
         MwoNslO44WxdYcgg4UUTuZZOlTYY+NUu1JMe7f0J2HCM3XdXEIt/deEJvPtbl1YfyCGk
         cZ2Q==
X-Gm-Message-State: APjAAAVoZ4Rg2sihvH8rck1T5/y3xcRbIbZG3I60u5/wCfkQbP1EzRYZ
        9mUvD3bi0Isy1udVTOQz8VdT4UvupDfKT3kVpb9gl4Tj
X-Google-Smtp-Source: APXvYqzEex4e0zJt+OCqc4YJRDYS66/waGOw4gnYnBMJkY0zuoeULENx7qUHKj2mxeWsuaUYforX1fiftvmZSvBsu2Q=
X-Received: by 2002:a37:8044:: with SMTP id b65mr9509831qkd.138.1568145129659;
 Tue, 10 Sep 2019 12:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190909195024.3268499-1-arnd@arndb.de> <20190909195024.3268499-2-arnd@arndb.de>
 <8311cb643690d3e80dddd5d4f2f6a7d923b9fbbc.camel@mellanox.com>
In-Reply-To: <8311cb643690d3e80dddd5d4f2f6a7d923b9fbbc.camel@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 Sep 2019 21:51:53 +0200
Message-ID: <CAK8P3a3CFYrQ53as4+xAmxHfa67E25mhN8q1NZwhQ50iSavp+Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] mlx5: fix type mismatch
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 7:56 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Mon, 2019-09-09 at 21:50 +0200, Arnd Bergmann wrote:
> > In mlx5, pointers to 'phys_addr_t' and 'u64' are mixed since the
> > addition
> > of the pool memory allocator, leading to incorrect behavior on 32-bit
> > architectures and this compiler warning:
> >
> > drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c:121:8:
> > error: incompatible pointer types passing 'u64 *' (aka 'unsigned long
> > long *') to parameter of type 'phys_addr_t *' (aka 'unsigned int *')
> > [-Werror,-Wincompatible-pointer-types]
> >                                    &icm_mr->dm.addr, &icm_mr-
> > >dm.obj_id);
> >                                    ^~~~~~~~~~~~~~~~
> > include/linux/mlx5/driver.h:1092:39: note: passing argument to
> > parameter 'addr' here
> >                          u64 length, u16 uid, phys_addr_t *addr, u32
> > *obj_id);
> >
> > Change the code to use 'u64' consistently in place of 'phys_addr_t'
> > to
> > fix this. The alternative of using phys_addr_t more would require a
> > larger
> > rework.
> >
> > Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hi Arnd,
>
> Nathan Chancellor Already submitted a patch to fix this and it is more
> minimal:
> https://patchwork.ozlabs.org/patch/1158177/
>
> I would like to use that patch if it is ok with you..

Yes, please do. I think I had tried something like that
initially and concluded it wasn't quite right before I went
into a different direction with my patch.

Looking at the two versions now, I also prefer Nathan's,
and I just confirmed that it fixes all the randconfig failures
I ran into.

       Arnd
