Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7D830B7FD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhBBGok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231879AbhBBGof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D3E64ED5;
        Tue,  2 Feb 2021 06:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248233;
        bh=BGjvFLNh/0WDV2j379ELhhUuvu24KWUBOZP63EXJua4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o7yIcGNvfUJfqAGaZYs7QE92ztkbBHODXqNac6LA7+YlIRFIQwIF5du4Q1o7OPM9B
         X2W+zx2qeYcmLIV0RCVoXJD1hdb6MFQ5UrgTeArfvbrnHHEifYyhEkWL1k2icqrrb4
         +JZ0009zUBI7zCUeVYZCp0+wQXpSYH7frAO9xEXFj0wJbj2MzRUCKoHSeuoP+aGxWm
         rtwCXKT3xVhAPRAcyKL1136mIy78tJcJCt/8Hy++tZ5jv2Phph1g31qykMo6+btekg
         Z8IzIC24Kr/66F24o4RL8qN20NaKyEkwW3wrc+Sv6KKfFya/V96UdWmZVmJp6rXQuI
         ukkMjUSYrSn/w==
Date:   Tue, 2 Feb 2021 08:43:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next v1] RDMA/mlx5: Cleanup the synchronize_srcu()
 from the ODP flow
Message-ID: <20210202064349.GA1945456@unreal>
References: <20210128064812.1921519-1-leon@kernel.org>
 <c79124a204f2207f5f1fae69cc34fb08d91d3535.camel@kernel.org>
 <549b337b-b51e-c984-a4d8-72f9f738be9c@nvidia.com>
 <20210201194952.GS4247@nvidia.com>
 <b6dc9fc1532a17efd7fdc33d65641626d9760183.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6dc9fc1532a17efd7fdc33d65641626d9760183.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 12:03:15PM -0800, Saeed Mahameed wrote:
> On Mon, 2021-02-01 at 15:49 -0400, Jason Gunthorpe wrote:
> > On Sun, Jan 31, 2021 at 03:24:50PM +0200, Yishai Hadas wrote:
> > > On 1/29/2021 2:23 PM, Saeed Mahameed wrote:
> > > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > > > b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > > > index 9eb51f06d3ae..50af84e76fb6 100644
> > > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > > > @@ -56,6 +56,7 @@ int mlx5_core_create_mkey(struct
> > > > > mlx5_core_dev
> > > > > *dev,
> > > > >          mkey->size = MLX5_GET64(mkc, mkc, len);
> > > > >          mkey->key |= mlx5_idx_to_mkey(mkey_index);
> > > > >          mkey->pd = MLX5_GET(mkc, mkc, pd);
> > > > > +       init_waitqueue_head(&mkey->wait);
> > > > >
> > > > >          mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n",
> > > > > mkey_index, mkey-
> > > > > > key);
> > > > >          return 0;
> > > > > diff --git a/include/linux/mlx5/driver.h
> > > > > b/include/linux/mlx5/driver.h
> > > > > index 4901b4fadabb..f9e7036ae5a5 100644
> > > > > +++ b/include/linux/mlx5/driver.h
> > > > > @@ -373,6 +373,8 @@ struct mlx5_core_mkey {
> > > > >          u32                     key;
> > > > >          u32                     pd;
> > > > >          u32                     type;
> > > > > +       struct wait_queue_head wait;
> > > > > +       refcount_t usecount;
> > > > mlx5_core_mkey is used everywhere in mlx5_core and we don't care
> > > > about
> > > > odp complexity, i would like to keep the core simple and
> > > > primitive as
> > > > it is today.
> > > > please keep the layer separation and find a way to manage
> > > > refcount and
> > > > wait queue in mlx5_ib driver..
> > > >
> > > The alternative could really be to come with some wrapped mlx5_ib
> > > structure
> > > that will hold 'mlx5_core_mkey' and will add those two fields.
> >
> > Yes
> >
> > struct mlx5_ib_mkey
> > {
> >    struct mlx5_core_mkey mkey;
> >    struct wait_queue_head wait;
> >    refcount_t usecount;
> > }
> >
> > struct mlx5_ib_mr/mw/devx
> > {
> >     struct mlx5_ib_mkey mkey;
> > }
> >
>
> Yep, also i have a series internally that moves mlx5_core_mkey to
> mlx5_ib, in mlx5_core we don't need it we only need the u32 key :)
>
> I will send you this series internally.

Let's first finish this patch and perform "moving" later.

Thanks

>
>
