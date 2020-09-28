Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C32627A8EE
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgI1HnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgI1HnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 03:43:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 600122100A;
        Mon, 28 Sep 2020 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601278985;
        bh=qEiBrfNJfo3j3guhrzPxyPtqthA1XxTL+21RNCztAmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eB2WTXQVs4jt4p9BSTF7D/b7ouPEOUWfddSU8u9DKfDzceoLwj81z9U77eLd+X96S
         QssGSS5VdGJGgGOaB2W2Bc8px9X1Cgroo8joTvvbQH+U03Bg0zax82FKLZPi+skVsr
         /k6kVfCQonSpYR7G1YwSYjhoMC71ruWXWRkDy1m0=
Date:   Mon, 28 Sep 2020 10:43:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Eli Britstein <elibr@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net/mlx5e: Fix use of freed pointer
Message-ID: <20200928074301.GC3094@unreal>
References: <20200927113254.362480-1-alex.dewar90@gmail.com>
 <20200927113254.362480-3-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927113254.362480-3-alex.dewar90@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 12:32:53PM +0100, Alex Dewar wrote:
> If the call to mlx5_fc_create() fails, then shared_counter will be freed
> before its member, shared_counter->counter, is accessed to retrieve the
> error code. Fix by using an intermediate variable.
>
> Addresses-Coverity: CID 1497153: Memory - illegal accesses (USE_AFTER_FREE)
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---

Please add Fixes line.

>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index b5f8ed30047b..5851a1dfe6e4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -738,6 +738,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
>  	struct mlx5_ct_shared_counter *shared_counter;
>  	struct mlx5_core_dev *dev = ct_priv->dev;
>  	struct mlx5_ct_entry *rev_entry;
> +	struct mlx5_fc *counter;
>  	__be16 tmp_port;
>
>  	/* get the reversed tuple */
> @@ -775,12 +776,13 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
>  	if (!shared_counter)
>  		return ERR_PTR(-ENOMEM);
>
> -	shared_counter->counter = mlx5_fc_create(dev, true);
> -	if (IS_ERR(shared_counter->counter)) {
> +	counter = mlx5_fc_create(dev, true);
> +	if (IS_ERR(counter)) {
>  		ct_dbg("Failed to create counter for ct entry");
>  		kfree(shared_counter);
> -		return ERR_PTR(PTR_ERR(shared_counter->counter));
> +		return (struct mlx5_ct_shared_counter *)counter;

return ERR_CAST(counter);


>  	}
> +	shared_counter->counter = counter;
>
>  	refcount_set(&shared_counter->refcount, 1);
>  	return shared_counter;
> --
> 2.28.0
>
