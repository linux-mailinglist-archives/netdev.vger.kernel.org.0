Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB331CAFE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 14:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBPNSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 08:18:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBPNS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 08:18:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1BED64DA5;
        Tue, 16 Feb 2021 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613481468;
        bh=vmkdvq+0gAgPMBKTUi07+7vQKbFc6q4t3W8fgD+9ijI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOGQ6k4scCo+1lFqhGgPdTbgwgNHIKHz8M3p0bpUmr87lSznNvHDjbYbaQY5bGy0V
         btIukcmHUZpm74vJpW+S3d+wklHOpwwBu4Bkv/YmL3T6UuXk8LqsQHHHwtowlVtHfI
         C4AY6KdzSFt3ZaBuwxK/yEdeYr8nWcAr6lMd1m6IPKaE7+VW/Dr5IcJhsSTrQ431/6
         4Yp0A5lHbL7LGwCxOquNVeZYo9+UD7eKjMbYsQyxPHX67CX716ynEADZ2xQ+83yIv8
         MIs67muR1qk5GeZHcmDd41L0mi9U7mcv7AfNF0egtuKm6OAViYp/kAqCCclU1VTEpl
         jxl0DqcZuiR+Q==
Date:   Tue, 16 Feb 2021 15:17:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: Re: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Message-ID: <YCvF+BfHeJWx3x2G@unreal>
References: <20210216055022.25248-1-elic@nvidia.com>
 <20210216055022.25248-2-elic@nvidia.com>
 <YCtnxyTHJl9TU87L@unreal>
 <20210216064226.GA83717@mtl-vdi-166.wap.labs.mlnx>
 <YCt2PiMIZxbR15IA@unreal>
 <20210216124540.GA94503@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216124540.GA94503@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 02:45:40PM +0200, Eli Cohen wrote:
> On Tue, Feb 16, 2021 at 09:37:34AM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 16, 2021 at 08:42:26AM +0200, Eli Cohen wrote:
> > > On Tue, Feb 16, 2021 at 08:35:51AM +0200, Leon Romanovsky wrote:
> > > > On Tue, Feb 16, 2021 at 07:50:22AM +0200, Eli Cohen wrote:
> > > > > struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
> > > > > in mlx5v_remove().
> > > > >
> > > > > Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
> > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > ---
> > > > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > index 6b0a42183622..4103d3b64a2a 100644
> > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > @@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> > > > >
> > > > >  static void mlx5v_remove(struct auxiliary_device *adev)
> > > > >  {
> > > > > -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> > > > > +	struct mlx5_vdpa_net *ndev = dev_get_drvdata(&adev->dev);
> > > > >
> > > > > -	vdpa_unregister_device(&mvdev->vdev);
> > > > > +	vdpa_unregister_device(&ndev->mvdev.vdev);
> > > > >  }
> > > >
> > > > IMHO, The more correct solution is to fix dev_set_drvdata() call,
> > > > because we are regustering/unregistering/allocating "struct mlx5_vdpa_dev".
> > > >
> > >
> > > We're allocating "struct mlx5_vdpa_net". "struct mlx5_vdpa_dev" is just
> > > a member field of "struct mlx5_vdpa_net".
> >
> > I referred to these lines in the mlx5v_probe():
> >   1986         err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
> >   1987         if (err)
> >   1988                 goto err_mtu;
> >   1989
> >   1990         err = alloc_resources(ndev);
> >   1991         if (err)
> >   1992                 goto err_res;
> >   1993
> >   1994         err = vdpa_register_device(&mvdev->vdev);
> >
> > So mlx5v_remove() is better to be symmetrical.
> >
>
> It's "struct mlx5_vdpa_net" that is being allocated here so it makes
> sense to set this pointer as the the driver data.

Anyway, it doesn't important.

Thanks, for the original patch.
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
