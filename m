Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A813831C685
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBPGgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhBPGgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 01:36:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9DB364DDA;
        Tue, 16 Feb 2021 06:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613457355;
        bh=JyrtpZs3nYiCe3lUIYAVThOqh4wJbPYr0RlJDjeDkjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q9cM3sN/iw/E5UBd3Lweuiw84wvHuanw14mFpmpS3uEqH26cfZex5oqlNDHIjOzY5
         CJ4KgCLsiTEyBhsfZ+yVuHfEdg0og1hs+mMdi/9t+J+DQUlS9KE5rffSlsIWRg3HCM
         MwBHk5Dhqa0iRODR76SCh+McfkLEEgQZASSslTbODH6ec9Lwb9DKFNPLHFT6Wl7hMk
         U2VuN9kd536E78U+Mld2RIxtK2wFjTx/EzPE3BMVcmEcuNiH5eDX5UVJNeprXGe5YT
         tLj8rmYjRTJ3BMWCMCQSdlgIp+MZ3K1uaI/mRwPF4kME+6Am2TCyjhk+65oEbrzGoe
         GuXFYO9V0WT6A==
Date:   Tue, 16 Feb 2021 08:35:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: Re: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Message-ID: <YCtnxyTHJl9TU87L@unreal>
References: <20210216055022.25248-1-elic@nvidia.com>
 <20210216055022.25248-2-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216055022.25248-2-elic@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 07:50:22AM +0200, Eli Cohen wrote:
> struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
> in mlx5v_remove().
>
> Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 6b0a42183622..4103d3b64a2a 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>
>  static void mlx5v_remove(struct auxiliary_device *adev)
>  {
> -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> +	struct mlx5_vdpa_net *ndev = dev_get_drvdata(&adev->dev);
>
> -	vdpa_unregister_device(&mvdev->vdev);
> +	vdpa_unregister_device(&ndev->mvdev.vdev);
>  }

IMHO, The more correct solution is to fix dev_set_drvdata() call,
because we are regustering/unregistering/allocating "struct mlx5_vdpa_dev".

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 88dde3455bfd..079b8fe669af 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1995,7 +1995,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	if (err)
 		goto err_reg;

-	dev_set_drvdata(&adev->dev, ndev);
+	dev_set_drvdata(&adev->dev, mvdev);
 	return 0;

 err_reg:

>
>  static const struct auxiliary_device_id mlx5v_id_table[] = {

> --
> 2.29.2
>
