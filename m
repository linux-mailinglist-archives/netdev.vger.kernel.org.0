Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998F631C68C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBPGnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:43:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11050 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBPGnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 01:43:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602b69570000>; Mon, 15 Feb 2021 22:42:31 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Feb 2021 06:42:29 +0000
Date:   Tue, 16 Feb 2021 08:42:26 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <si-wei.liu@oracle.com>
Subject: Re: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Message-ID: <20210216064226.GA83717@mtl-vdi-166.wap.labs.mlnx>
References: <20210216055022.25248-1-elic@nvidia.com>
 <20210216055022.25248-2-elic@nvidia.com>
 <YCtnxyTHJl9TU87L@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YCtnxyTHJl9TU87L@unreal>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613457752; bh=qWp9a5RC/NYXw8B6UiqomCrqL0T/roq2ulBa23LKIGg=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=gpHwvTRmfv1AhAaOSEGFheACUhRkKsiLMJJ67roVjBf2iSZLiZHA+ZA+dvZEdKU+/
         LXqr0Ri3SLcsB/GPzCtmyBXOBfD4jzL9I2fCR2kMtCevlJVyNhEfUmSo8PWj6vJ2zy
         /zRmely51lCHorbcAzhLnhOV69Oqpka7WpARAhP6eiPiCY17Sugd/iSov6HRRBdWwI
         D6JndPPkAK4CGsQD0cYGpR6tSRy7ATj+2igOr3dottfdh14XTmueCyp9HVtlRp/5JQ
         L30ZHVUiEy7M9AjHl51YPcGATTXKrL3NNCFg89NWKzRKVUm2fgBSt9wjShzBpAtBcG
         IIyNGDzGpOOyw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 08:35:51AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 16, 2021 at 07:50:22AM +0200, Eli Cohen wrote:
> > struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
> > in mlx5v_remove().
> >
> > Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 6b0a42183622..4103d3b64a2a 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> >
> >  static void mlx5v_remove(struct auxiliary_device *adev)
> >  {
> > -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> > +	struct mlx5_vdpa_net *ndev = dev_get_drvdata(&adev->dev);
> >
> > -	vdpa_unregister_device(&mvdev->vdev);
> > +	vdpa_unregister_device(&ndev->mvdev.vdev);
> >  }
> 
> IMHO, The more correct solution is to fix dev_set_drvdata() call,
> because we are regustering/unregistering/allocating "struct mlx5_vdpa_dev".
> 

We're allocating "struct mlx5_vdpa_net". "struct mlx5_vdpa_dev" is just
a member field of "struct mlx5_vdpa_net".

> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 88dde3455bfd..079b8fe669af 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1995,7 +1995,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>  	if (err)
>  		goto err_reg;
> 
> -	dev_set_drvdata(&adev->dev, ndev);
> +	dev_set_drvdata(&adev->dev, mvdev);
>  	return 0;
> 
>  err_reg:
> 
> >
> >  static const struct auxiliary_device_id mlx5v_id_table[] = {
> 
> > --
> > 2.29.2
> >
