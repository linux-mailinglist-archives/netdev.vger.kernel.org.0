Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE91A30B14C
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhBAUFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhBAUEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 15:04:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C01164D9D;
        Mon,  1 Feb 2021 20:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612209796;
        bh=SPGIH21uIeoPxOc8dBO4zMKLz9H1qPq0rzCK55Pex0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gdwkOKXXKPe4Erfglhl27sEJkbouCQKchoKf5LiR8aXGzdIw2GarFbD4TfgM29wjA
         Jgb6/zYdjMXMk8lBLEEea5bxqJ7Qotl5fY6R/1wurY80DX6xIQ/KmhFEC+6KKMlw3x
         1KYckGXghEVQLgKmbA+9TjPgyiiZLdwOplX6YDwebAuXqIXew1HOdseUn5prONKZgv
         +rvYoPqmJGpsmkW5/2dY45VwUNjrRhsaYcHN86jy6KX0eEFbgUQD82gIYdH0l8CSoX
         JwoXWSQ3gShzRPUmNxNDbuPv3nJCjW2bUFmAPPJlYgXf+jzeRDqLYZ2nDrf3omAVo9
         Hl6np6l0SIX7w==
Message-ID: <b6dc9fc1532a17efd7fdc33d65641626d9760183.camel@kernel.org>
Subject: Re: [PATCH mlx5-next v1] RDMA/mlx5: Cleanup the synchronize_srcu()
 from the ODP flow
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 01 Feb 2021 12:03:15 -0800
In-Reply-To: <20210201194952.GS4247@nvidia.com>
References: <20210128064812.1921519-1-leon@kernel.org>
         <c79124a204f2207f5f1fae69cc34fb08d91d3535.camel@kernel.org>
         <549b337b-b51e-c984-a4d8-72f9f738be9c@nvidia.com>
         <20210201194952.GS4247@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-01 at 15:49 -0400, Jason Gunthorpe wrote:
> On Sun, Jan 31, 2021 at 03:24:50PM +0200, Yishai Hadas wrote:
> > On 1/29/2021 2:23 PM, Saeed Mahameed wrote:
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > > b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > > index 9eb51f06d3ae..50af84e76fb6 100644
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > > @@ -56,6 +56,7 @@ int mlx5_core_create_mkey(struct
> > > > mlx5_core_dev
> > > > *dev,
> > > >          mkey->size = MLX5_GET64(mkc, mkc, len);
> > > >          mkey->key |= mlx5_idx_to_mkey(mkey_index);
> > > >          mkey->pd = MLX5_GET(mkc, mkc, pd);
> > > > +       init_waitqueue_head(&mkey->wait);
> > > > 
> > > >          mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n",
> > > > mkey_index, mkey-
> > > > > key);
> > > >          return 0;
> > > > diff --git a/include/linux/mlx5/driver.h
> > > > b/include/linux/mlx5/driver.h
> > > > index 4901b4fadabb..f9e7036ae5a5 100644
> > > > +++ b/include/linux/mlx5/driver.h
> > > > @@ -373,6 +373,8 @@ struct mlx5_core_mkey {
> > > >          u32                     key;
> > > >          u32                     pd;
> > > >          u32                     type;
> > > > +       struct wait_queue_head wait;
> > > > +       refcount_t usecount;
> > > mlx5_core_mkey is used everywhere in mlx5_core and we don't care
> > > about
> > > odp complexity, i would like to keep the core simple and
> > > primitive as
> > > it is today.
> > > please keep the layer separation and find a way to manage
> > > refcount and
> > > wait queue in mlx5_ib driver..
> > > 
> > The alternative could really be to come with some wrapped mlx5_ib
> > structure
> > that will hold 'mlx5_core_mkey' and will add those two fields.
> 
> Yes
> 
> struct mlx5_ib_mkey
> {
>    struct mlx5_core_mkey mkey;
>    struct wait_queue_head wait;
>    refcount_t usecount;
> }
> 
> struct mlx5_ib_mr/mw/devx
> {
>     struct mlx5_ib_mkey mkey;
> }
> 

Yep, also i have a series internally that moves mlx5_core_mkey to
mlx5_ib, in mlx5_core we don't need it we only need the u32 key :)

I will send you this series internally.


