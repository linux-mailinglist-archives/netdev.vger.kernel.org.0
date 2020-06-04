Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A247F1EE27F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgFDKdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 06:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgFDKdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 06:33:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E564206C3;
        Thu,  4 Jun 2020 10:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591266779;
        bh=XIiK0h6bNugMLCpkDBq8N1PeSAZO+VRnF+Wd7lxosO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZUxoz5WCwUqci9NhnUVRkDZEiF0ee/mCvYeTYE35Vw6T/lZCgOzs0gYEfLx9iPXB
         vG2jLl0XZk13o4v+UdZxfNOLq7AsiGWk5QnDbxLYIGtyw/mqUhnAjUZaT3BNNsE8I5
         YWheqFMU9q4fX/cuvsNCm+Zhat4O6gTm3aDZ/x3k=
Date:   Thu, 4 Jun 2020 13:32:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: E-Switch, Fix some error pointer dereferences
Message-ID: <20200604103255.GA8834@unreal>
References: <20200603175436.GD18931@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603175436.GD18931@mwanda>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ netdev

On Wed, Jun 03, 2020 at 08:54:36PM +0300, Dan Carpenter wrote:
> We can't leave "counter" set to an error pointer.  Otherwise either it
> will lead to an error pointer dereference later in the function or it
> leads to an error pointer dereference when we call mlx5_fc_destroy().
>
> Fixes: 07bab9502641d ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c  | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
> index 9bda4fe2eafa7..5dc335e621c57 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
> @@ -162,10 +162,12 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
>
>  	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
>  		counter = mlx5_fc_create(esw->dev, false);
> -		if (IS_ERR(counter))
> +		if (IS_ERR(counter)) {
>  			esw_warn(esw->dev,
>  				 "vport[%d] configure ingress drop rule counter failed\n",
>  				 vport->vport);
> +			counter = NULL;
> +		}
>  		vport->ingress.legacy.drop_counter = counter;
>  	}
>
> @@ -272,7 +274,7 @@ void esw_acl_ingress_lgcy_cleanup(struct mlx5_eswitch *esw,
>  	esw_acl_ingress_table_destroy(vport);
>
>  clean_drop_counter:
> -	if (!IS_ERR_OR_NULL(vport->ingress.legacy.drop_counter)) {
> +	if (vport->ingress.legacy.drop_counter) {
>  		mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
>  		vport->ingress.legacy.drop_counter = NULL;
>  	}
> --
> 2.26.2
>
