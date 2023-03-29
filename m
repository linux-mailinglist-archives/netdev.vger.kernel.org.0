Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD8A6CD3E3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjC2IB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2IBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEA135A9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED74661B27
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FD8C433EF;
        Wed, 29 Mar 2023 08:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680076911;
        bh=6rdoVjNX6oU2P18Y4CljgWi3eESyh50zkmHEOykH2Ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=da6HGXAz+fZPdPMpFyTw8ZuliTN+8Xbe0ipl93OHJdJIfU94OAnsOeaPBwCqc7y6h
         P6UjxM43C92BITminRbD3H7hiE8vX7i36N8UhkaXJqKMT4GABUnrRi7fRTKRgioB1i
         MYv3XZl3yN9Ui333fL+JXGNfv/J2LBYS/HpBtKgbhC9PrRM+ubwFcV7ezxrLlqftgh
         DJFwwCI7n6hC0oSQo9O9hFEH2u6fZmyb2Xz3LmnJOPk/q7fb7VAPFA0kDyzLWzEH/9
         RPyRYkmGk7mIedTfgpgoGukLaO8qWo4tApSzq+pLnYYM+wgXf7dA4s3U3oZIuBC29U
         Qy3qqWRI3yIeA==
Date:   Wed, 29 Mar 2023 11:01:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/4] net/mlx5: Implement devlink port function
 cmds to control ipsec_crypto
Message-ID: <20230329080147.GI831478@unreal>
References: <20230323111059.210634-1-dchumak@nvidia.com>
 <20230323111059.210634-3-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323111059.210634-3-dchumak@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:10:57PM +0200, Dima Chumak wrote:
> Implement devlink port function commands to enable / disable IPsec
> crypto offloads.  This is used to control the IPsec capability of the
> device.
> 
> When ipsec_crypto is enabled for a VF, it prevents adding IPsec crypto
> offloads on the PF, because the two cannot be active simultaneously due
> to HW constraints. Conversely, if there are any active IPsec crypto
> offloads on the PF, it's not allowed to enable ipsec_crypto on a VF,
> until PF IPsec offloads are cleared.
> 
> Signed-off-by: Dima Chumak <dchumak@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/switchdev.rst      |   8 +
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
>  .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 ++
>  .../ethernet/mellanox/mlx5/core/esw/ipsec.c   | 271 ++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c |  29 ++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |  20 ++
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 100 +++++++
>  .../ethernet/mellanox/mlx5/core/lib/ipsec.h   |  41 +++
>  include/linux/mlx5/driver.h                   |   1 +
>  include/linux/mlx5/mlx5_ifc.h                 |   3 +
>  11 files changed, 494 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h

<...>

> +static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vport, bool *crypto)
> +{
> +	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
> +	void *hca_cap = NULL, *query_cap = NULL;
> +	bool ipsec_enabled;
> +	int err;
> +
> +	/* Querying IPsec caps only makes sense when generic ipsec_offload
> +	 * HCA cap is enabled
> +	 */
> +	err = esw_ipsec_vf_query_generic(dev, vport->index, &ipsec_enabled);
> +	if (err)
> +		return err;
> +	if (!ipsec_enabled) {
> +		*crypto = false;
> +		return 0;
> +	}
> +
> +	query_cap = kvzalloc(query_sz, GFP_KERNEL);
> +	if (!query_cap)
> +		return -ENOMEM;
> +
> +	err = mlx5_vport_get_other_func_cap(dev, vport->index, query_cap, MLX5_CAP_IPSEC);
> +	if (err)
> +		goto out;
> +
> +	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
> +	*crypto = MLX5_GET(ipsec_cap, hca_cap, ipsec_crypto_offload);

This is very optimistic check to decide if crypto is supported/enabled or not.

Take a look on mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
implementation to take into account other capabilities too:
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/tree/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c?h=wip/leon-for-next#n13

It will be nice if you can reuse existing MLX5_IPSEC_CAP_* enum andextend existing
mlx5_ipsec_device_caps() to query other vports.

Thanks
