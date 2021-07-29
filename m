Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A833DAA16
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhG2R1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG2R1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 13:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1637B601FA;
        Thu, 29 Jul 2021 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627579630;
        bh=kssTgqcbXEPlcdsvyvqpSjM1LIWESEJ+zCyffEvb604=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YzdV9ItjgDa2iZKwe24iIX4qYDNymVr5eVUv7OJS1Ygxh2TLodDNSrffuR9zlPADi
         vjvOg9KwUNWxcUQVuCi1D1qllzOv/ryKTAGgtpvKEbPcRdu3VgmoXScsRweEPa/DjN
         78ak1uvc6m1PHtiuwtPFt7liiv8GcWfscpXa+XAOwWoTnV2NS8RMFM/1O6yjdFZkKU
         gHDpVXyKeXV2mMPBECU9HPcTVCNSWZJzcDzUpPFUjMecJ9xcPOBQIckHKnZr3abr2p
         7qKd8NAjlcispml/XK/ONvohYmYEDylbbBUATeg5B0RvKFD4pSJ19Yc/HPfVThpxz7
         aSwIlAPRjI+oQ==
Date:   Thu, 29 Jul 2021 20:27:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 1/5] RDMA/mlx5: Replace struct mlx5_core_mkey
 by u32 key
Message-ID: <YQLk65qM6oJ1J9fg@unreal>
References: <cover.1624362290.git.leonro@nvidia.com>
 <2e0feba18d8fe310b2ed38fbfbdd4af7a9b84bf1.1624362290.git.leonro@nvidia.com>
 <20210729152803.GA2394514@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729152803.GA2394514@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 12:28:03PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 22, 2021 at 03:08:19PM +0300, Leon Romanovsky wrote:
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > index 50af84e76fb6..7a76b5eb1c1a 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > @@ -35,13 +35,11 @@
> >  #include <linux/mlx5/driver.h>
> >  #include "mlx5_core.h"
> >  
> > -int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
> > -			  struct mlx5_core_mkey *mkey,
> > -			  u32 *in, int inlen)
> > +int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
> > +			  int inlen)
> >  {
> >  	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {};
> >  	u32 mkey_index;
> > -	void *mkc;
> >  	int err;
> >  
> >  	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
> > @@ -50,38 +48,32 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
> >  	if (err)
> >  		return err;
> >  
> > -	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
> >  	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
> > -	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
> > -	mkey->size = MLX5_GET64(mkc, mkc, len);
> > -	mkey->key |= mlx5_idx_to_mkey(mkey_index);
> > -	mkey->pd = MLX5_GET(mkc, mkc, pd);
> > -	init_waitqueue_head(&mkey->wait);
> > +	*mkey |= mlx5_idx_to_mkey(mkey_index);
> 
> 
> This conflicts with 0232fc2ddcf4 ("net/mlx5: Reset mkey index on creation")
> 
> Please resend/rebase. I think it should be fixed like
> 
> 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
> 	*mkey = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);
> 
> 	mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index,	*mkey);
> ?

Yes, this is how it is fixed in my tree. I just waited till you finish the review.

> 
> (though I will look at the rest of the series today, so don't rush on
> this)
> 
> Jason
