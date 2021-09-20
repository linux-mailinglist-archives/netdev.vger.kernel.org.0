Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1357141156E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbhITNXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 09:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239225AbhITNXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 09:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76CED60C51;
        Mon, 20 Sep 2021 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632144095;
        bh=OJgspc3gS6oHE+t6nF6emlo6dfdxyN2zT0UVxnU7KLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYdQfGQJ72nkJAHnF++hg+o/w58Wcmxq7gPz+urIsM1ZyFc4hMohrCueB7mvbUuEH
         0yNqD7ehet+X08VfrGH2DBdc4RaeGHu2Of/4adNwk7vtjAE84HK8ID1SjE+W/hfK6C
         SN7k1SDIk97d1w3RsnSDh7pX2aKsXeZobugV/A11Z9vaOV1ygMVg3dzKi/QDbAht7T
         ZdFi7WAfa184dLQfDMMuw49vGM7zM0/jjJhT7SqTsTsADtBJtuSNGqZSVxbPpdrGWK
         4slBrSZQntr8Cy9+ZVCjmFoQxuw9iO9zVSTyhQgOvEnD9U4IpNtP2CCEsP9K4o0EHB
         iyoZrKR+maCPQ==
Date:   Mon, 20 Sep 2021 16:21:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Meir Lichtinger <meirl@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Enable UAR to have DevX UID
Message-ID: <YUiK28VZR5glIRav@unreal>
References: <cover.1631660943.git.leonro@nvidia.com>
 <b6580419a845f750014df75f6ee1916cc3f0d2d7.1631660943.git.leonro@nvidia.com>
 <20210915134753.GA212159@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915134753.GA212159@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:47:53AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 15, 2021 at 02:11:23AM +0300, Leon Romanovsky wrote:
> > From: Meir Lichtinger <meirl@nvidia.com>
> > 
> > UID field was added to alloc_uar and dealloc_uar PRM command, to specify
> > DevX UID for UAR. This change enables firmware validating user access to
> > its own UAR resources.
> > 
> > For the kernel allocated UARs the UID will stay 0 as of today.
> > 
> > Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
> > Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >  drivers/infiniband/hw/mlx5/cmd.c  | 24 ++++++++++++++
> >  drivers/infiniband/hw/mlx5/cmd.h  |  2 ++
> >  drivers/infiniband/hw/mlx5/main.c | 55 +++++++++++++++++--------------
> >  3 files changed, 57 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
> > index a8db8a051170..0fe3c4ceec43 100644
> > +++ b/drivers/infiniband/hw/mlx5/cmd.c
> > @@ -206,3 +206,27 @@ int mlx5_cmd_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
> >  	kfree(in);
> >  	return err;
> >  }
> > +
> > +int mlx5_ib_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid)
> > +{
> > +	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {};
> > +	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)] = {};
> > +	int err;
> > +
> > +	MLX5_SET(alloc_uar_in, in, opcode, MLX5_CMD_OP_ALLOC_UAR);
> > +	MLX5_SET(alloc_uar_in, in, uid, uid);
> > +	err = mlx5_cmd_exec_inout(dev, alloc_uar, in, out);
> > +	if (!err)
> > +		*uarn = MLX5_GET(alloc_uar_out, out, uar);
> 
> Success oriented flow:
> 
>  if (err)
>      return err;
>  *uarn = MLX5_GET(alloc_uar_out, out, uar);
>  return 0;
> 
> And why did we add entirely new functions instead of just adding a uid
> argument to the core ones? Or, why doesn't this delete the old core
> functions that look unused outside of IB anyhow?

We didn't want to add not-needed for mlx5_core uid field, the rest
comments are valid and I'm sorry that I missed them.

Thanks

> 
> Jason
