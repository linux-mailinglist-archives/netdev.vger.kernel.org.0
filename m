Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA9E31C6EA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhBPHiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhBPHiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 02:38:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 450FD64DC3;
        Tue, 16 Feb 2021 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613461058;
        bh=6OLXpRjMtpO3rJat3zYX+pRYnE0UODR8E8eilUt1wlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKK96cwEMia3biqOl2+yZcIHiH7NduEbANNEqBANbJ1bSnjgLtTIUftS3IH0dRw+L
         0do0UHIe0A2ZgeStQjar6TBFj1a9Es5EyCByeBXYapR4+y5+KbwcUMlMZ0EonCZaXB
         H14tLwwaZ2GRH3XQBrOjhzSTrPSbhMahxvCJVIcgHFy3ZIR5qP9Xg1RRtmKXEhxBl4
         4ZoGqJWs6prNDYBVQtRwH7ElfX4/TGZEQDXf8nlUmH8uGIp0xYbWW8ISJYW5T14KxK
         MGj4i3Qd/GR7WgiISn2OdeuaJtkYCgS1FeSuWnmoYY1VZDk0laA7pxokzvXIz3EQKf
         hS+lnGIr8gx4A==
Date:   Tue, 16 Feb 2021 09:37:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: Re: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Message-ID: <YCt2PiMIZxbR15IA@unreal>
References: <20210216055022.25248-1-elic@nvidia.com>
 <20210216055022.25248-2-elic@nvidia.com>
 <YCtnxyTHJl9TU87L@unreal>
 <20210216064226.GA83717@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216064226.GA83717@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 08:42:26AM +0200, Eli Cohen wrote:
> On Tue, Feb 16, 2021 at 08:35:51AM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 16, 2021 at 07:50:22AM +0200, Eli Cohen wrote:
> > > struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
> > > in mlx5v_remove().
> > >
> > > Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > ---
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 6b0a42183622..4103d3b64a2a 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> > >
> > >  static void mlx5v_remove(struct auxiliary_device *adev)
> > >  {
> > > -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> > > +	struct mlx5_vdpa_net *ndev = dev_get_drvdata(&adev->dev);
> > >
> > > -	vdpa_unregister_device(&mvdev->vdev);
> > > +	vdpa_unregister_device(&ndev->mvdev.vdev);
> > >  }
> >
> > IMHO, The more correct solution is to fix dev_set_drvdata() call,
> > because we are regustering/unregistering/allocating "struct mlx5_vdpa_dev".
> >
>
> We're allocating "struct mlx5_vdpa_net". "struct mlx5_vdpa_dev" is just
> a member field of "struct mlx5_vdpa_net".

I referred to these lines in the mlx5v_probe():
  1986         err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
  1987         if (err)
  1988                 goto err_mtu;
  1989
  1990         err = alloc_resources(ndev);
  1991         if (err)
  1992                 goto err_res;
  1993
  1994         err = vdpa_register_device(&mvdev->vdev);

So mlx5v_remove() is better to be symmetrical.

Thanks

>
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 88dde3455bfd..079b8fe669af 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1995,7 +1995,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> >  	if (err)
> >  		goto err_reg;
> >
> > -	dev_set_drvdata(&adev->dev, ndev);
> > +	dev_set_drvdata(&adev->dev, mvdev);
> >  	return 0;
> >
> >  err_reg:
> >
> > >
> > >  static const struct auxiliary_device_id mlx5v_id_table[] = {
> >
> > > --
> > > 2.29.2
> > >
