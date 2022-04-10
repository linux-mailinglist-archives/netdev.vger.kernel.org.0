Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833084FAF49
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243744AbiDJRXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 13:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiDJRXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 13:23:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC124FC7C;
        Sun, 10 Apr 2022 10:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6037AB80E07;
        Sun, 10 Apr 2022 17:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A287AC385A4;
        Sun, 10 Apr 2022 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649611264;
        bh=En/x4sQXrycflDw2rOe4f0ui/DcpMkVuXJKAhHJCcQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pgiukU1LAyNAAMUq9h/sUAStVcsyVAmEe4DtpDpw6ZeZ0Lj357e8FjjfkuT1F4z7F
         LR0zGPSlIL/q6Lf6EH7YU7OVfT6bXRuT9Jx1sobLhsJTyeHKNUi77Kh7h1QxnZohmn
         tng4kGrBJHCtrSJIEl+uPNMGkZ8YG9v5cjeq5Wfbom5xq8aByq4R+bQuLXCOlTMJlc
         svHsknU5dkJHVop0pRuVjC8hq5SR+QLqbMkiTUAThmXWxeNrhGFA29uyA5aMGRbfkf
         aaqDyjHMPcpnU0211lVvW0ZUAgtuuNjxNueQR0Ad0fL1/doJU4vj0yJaVutFLFtP1y
         MhDbjFg4L57UQ==
Date:   Sun, 10 Apr 2022 20:21:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 01/17] net/mlx5: Simplify IPsec flow steering
 init/cleanup functions
Message-ID: <YlMR/CHoS3xg5uRL@unreal>
References: <cover.1649578827.git.leonro@nvidia.com>
 <3f7001272e4dc51fcef031bf896a7e01a2b4b7f6.1649578827.git.leonro@nvidia.com>
 <20220410164620.2dfzhx6qt4cg6b6o@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410164620.2dfzhx6qt4cg6b6o@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 09:46:20AM -0700, Saeed Mahameed wrote:
> On 10 Apr 11:28, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Cleanup IPsec FS initialization and cleanup functions.
> 
> Can you be more clear about what are you cleaning up ?
> 
> unfolding/joining static functions shouldn't be considered as cleanup.

And how would you describe extensive usage of one time called functions
that have no use as standalone ones?

This patch makes sure that all flow steering initialized and cleaned at
one place and allows me to present coherent picture of what is needed
for IPsec FS.

You should focus on the end result of this series rather on single patch.
 15 files changed, 320 insertions(+), 839 deletions(-)

> 
> Also i don't agree these patches should go to mlx5-next, we need to avoid
> bloating  mlx5-next.
> Many of these patches are purely ipsec, yes i understand you are heavily
> modifying include/linux/mlx5/accel.h but from what I can tell, it's not
> affecting rdma.

I'm deleting include/linux/mlx5/accel.h, it is not needed.
But I don't care about the target, it can be net-next and not
mlx5-next.

> 
> Please give me a chance to review the whole series until next week as i am
> out of office this week.

I see this problematic as next week will be combination of my Passover
vacation and paternity leave at the same time.

Thanks

> 
> > 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../mellanox/mlx5/core/en_accel/ipsec.c       |  4 +-
> > .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 73 ++++++-------------
> > .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  4 +-
> > 3 files changed, 27 insertions(+), 54 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index c280a18ff002..5a10755dd4f1 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -424,7 +424,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
> > 	}
> > 
> > 	priv->ipsec = ipsec;
> > -	mlx5e_accel_ipsec_fs_init(priv);
> > +	mlx5e_ipsec_fs_init(ipsec);
> > 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
> > 	return 0;
> > }
> > @@ -436,7 +436,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
> > 	if (!ipsec)
> > 		return;
> > 
> > -	mlx5e_accel_ipsec_fs_cleanup(priv);
> > +	mlx5e_ipsec_fs_cleanup(ipsec);
> > 	destroy_workqueue(ipsec->wq);
> > 
> > 	kfree(ipsec);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > index 66b529e36ea1..869b5692e9b9 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > @@ -632,81 +632,54 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
> > 		tx_del_rule(priv, ipsec_rule);
> > }
> > 
> > -static void fs_cleanup_tx(struct mlx5e_priv *priv)
> > -{
> > -	mutex_destroy(&priv->ipsec->tx_fs->mutex);
> > -	WARN_ON(priv->ipsec->tx_fs->refcnt);
> > -	kfree(priv->ipsec->tx_fs);
> > -	priv->ipsec->tx_fs = NULL;
> > -}
> > -
> > -static void fs_cleanup_rx(struct mlx5e_priv *priv)
> > +void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
> > {
> > 	struct mlx5e_accel_fs_esp_prot *fs_prot;
> > 	struct mlx5e_accel_fs_esp *accel_esp;
> > 	enum accel_fs_esp_type i;
> > 
> > -	accel_esp = priv->ipsec->rx_fs;
> > +	if (!ipsec->rx_fs)
> > +		return;
> > +
> > +	mutex_destroy(&ipsec->tx_fs->mutex);
> > +	WARN_ON(ipsec->tx_fs->refcnt);
> > +	kfree(ipsec->tx_fs);
> > +
> > +	accel_esp = ipsec->rx_fs;
> > 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
> > 		fs_prot = &accel_esp->fs_prot[i];
> > 		mutex_destroy(&fs_prot->prot_mutex);
> > 		WARN_ON(fs_prot->refcnt);
> > 	}
> > -	kfree(priv->ipsec->rx_fs);
> > -	priv->ipsec->rx_fs = NULL;
> > -}
> > -
> > -static int fs_init_tx(struct mlx5e_priv *priv)
> > -{
> > -	priv->ipsec->tx_fs =
> > -		kzalloc(sizeof(struct mlx5e_ipsec_tx), GFP_KERNEL);
> > -	if (!priv->ipsec->tx_fs)
> > -		return -ENOMEM;
> > -
> > -	mutex_init(&priv->ipsec->tx_fs->mutex);
> > -	return 0;
> > +	kfree(ipsec->rx_fs);
> > }
> > 
> > -static int fs_init_rx(struct mlx5e_priv *priv)
> > +int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
> > {
> > 	struct mlx5e_accel_fs_esp_prot *fs_prot;
> > 	struct mlx5e_accel_fs_esp *accel_esp;
> > 	enum accel_fs_esp_type i;
> > +	int err = -ENOMEM;
> > 
> > -	priv->ipsec->rx_fs =
> > -		kzalloc(sizeof(struct mlx5e_accel_fs_esp), GFP_KERNEL);
> > -	if (!priv->ipsec->rx_fs)
> > +	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
> > +	if (!ipsec->tx_fs)
> > 		return -ENOMEM;
> > 
> > -	accel_esp = priv->ipsec->rx_fs;
> > +	ipsec->rx_fs = kzalloc(sizeof(*ipsec->rx_fs), GFP_KERNEL);
> > +	if (!ipsec->rx_fs)
> > +		goto err_rx;
> > +
> > +	mutex_init(&ipsec->tx_fs->mutex);
> > +
> > +	accel_esp = ipsec->rx_fs;
> > 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
> > 		fs_prot = &accel_esp->fs_prot[i];
> > 		mutex_init(&fs_prot->prot_mutex);
> > 	}
> > 
> > 	return 0;
> > -}
> > -
> > -void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv)
> > -{
> > -	if (!priv->ipsec->rx_fs)
> > -		return;
> > -
> > -	fs_cleanup_tx(priv);
> > -	fs_cleanup_rx(priv);
> > -}
> > -
> > -int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
> > -{
> > -	int err;
> > -
> > -	err = fs_init_tx(priv);
> > -	if (err)
> > -		return err;
> > -
> > -	err = fs_init_rx(priv);
> > -	if (err)
> > -		fs_cleanup_tx(priv);
> > 
> > +err_rx:
> > +	kfree(ipsec->tx_fs);
> > 	return err;
> > }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
> > index b70953979709..8e0e829ab58f 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
> > @@ -9,8 +9,8 @@
> > #include "ipsec_offload.h"
> > #include "en/fs.h"
> > 
> > -void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
> > -int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
> > +void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
> > +int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
> > int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
> > 				  struct mlx5_accel_esp_xfrm_attrs *attrs,
> > 				  u32 ipsec_obj_id,
> > -- 
> > 2.35.1
> > 
