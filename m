Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2513E4FB3B3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 08:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244924AbiDKGXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 02:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244925AbiDKGXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 02:23:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3583D1EC;
        Sun, 10 Apr 2022 23:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04454B810E2;
        Mon, 11 Apr 2022 06:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC70C385A3;
        Mon, 11 Apr 2022 06:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649658067;
        bh=9o3rDH5O5UHZ5KfokQRM9PleajSwh2+mspzX60VpeJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IbV+ZaGf1WpawblMnhGtm2s2D2vRPC8vc5tSypOb5bMbYOuTgmUAa58uiCsgqLHeg
         TKjKyXgRHn55l7efmunkT/6lCJcTs0Ejo4alRLljMDFKxm3D1ROWu0fZznmqRXv4UI
         HJqeWTLyzare/jhgPtF47lMST4lhLpYFm6Q8/QIGdgI8z39YfQesY/6iwqUDsAvIOY
         AVBEWk+wgOjFx4x5XPc4n0yMEja2CQwPIArv8ZSHFRT/shnrrAk0z1gVbr97O4G3lq
         JZCpR3YWtDxmusf1Hohl+LYjO7dHKosefeBh3CFsOfH95peabXZgIT/++EYzksvT32
         N4GGAbCbrz9iA==
Date:   Mon, 11 Apr 2022 09:21:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 02/17] net/mlx5: Check IPsec TX flow steering
 namespace in advance
Message-ID: <YlPIz5LA9zO0H4rA@unreal>
References: <cover.1649578827.git.leonro@nvidia.com>
 <123bc1de57218089184a77465218d930997a8cf6.1649578827.git.leonro@nvidia.com>
 <20220410234612.cmhkcuraszf45lfm@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410234612.cmhkcuraszf45lfm@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 04:46:12PM -0700, Saeed Mahameed wrote:
> On 10 Apr 11:28, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Ensure that flow steering is usable as early as possible, to understand
> > if crypto IPsec is supported or not.
> > 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > drivers/net/ethernet/mellanox/mlx5/core/en/fs.h  |  1 -
> > .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c |  1 +
> > .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
> > .../mellanox/mlx5/core/en_accel/ipsec_fs.c       | 16 +++++++++-------
> > 4 files changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
> > index 678ffbb48a25..4130a871de61 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
> > @@ -164,7 +164,6 @@ struct mlx5e_ptp_fs;
> > 
> > struct mlx5e_flow_steering {
> > 	struct mlx5_flow_namespace      *ns;
> > -	struct mlx5_flow_namespace      *egress_ns;
> > #ifdef CONFIG_MLX5_EN_RXNFC
> > 	struct mlx5e_ethtool_steering   ethtool;
> > #endif
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index 5a10755dd4f1..285ccb773de6 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -415,6 +415,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
> > 
> > 	hash_init(ipsec->sadb_rx);
> > 	spin_lock_init(&ipsec->sadb_rx_lock);
> > +	ipsec->mdev = priv->mdev;
> > 	ipsec->en_priv = priv;
> > 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
> > 					    priv->netdev->name);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > index a0e9dade09e9..bbf48d4616f9 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > @@ -61,6 +61,7 @@ struct mlx5e_accel_fs_esp;
> > struct mlx5e_ipsec_tx;
> > 
> > struct mlx5e_ipsec {
> > +	struct mlx5_core_dev *mdev;
> > 	struct mlx5e_priv *en_priv;
> 
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> we could probably remove en_priv, I already sent you a patch, please try to
> include it in the next version.

I removed this en_priv in patch #6 "net/mlx5: Store IPsec ESN update work in XFRM state"
https://lore.kernel.org/netdev/1d965d2697dda0bd2c34fc1ccbbb45efaf03b0de.1649578827.git.leonro@nvidia.com/T/#u

Thanks
