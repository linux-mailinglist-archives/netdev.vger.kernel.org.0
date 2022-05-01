Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8497516334
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 10:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiEAI4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 04:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbiEAI4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 04:56:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CE811156
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 01:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37832B80CB7
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 08:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C7DC385A9;
        Sun,  1 May 2022 08:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651395152;
        bh=+weLeZFFPB90rdTPrNVWwCVdRg7UBegjwV9eens4kUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R14x68MGv84Gi4CcqfU4KTNfJoArOdBG8uIP62eqOOOar2lrtQCvORHWy11N2SWSS
         d/uOsV0B6Pru02imlypNiSXROyujbhZ0CF/nNWs7vAZtHnDYjKz4EjR2sY5MBFJmGB
         8iSnJEUoJgA3BGDJsjSFCPmplblZRtUTrMW1sjgGosGjKqS6FKDjWz1VjWJQV5KZVU
         LfWHX8uQhd2Wm7QJUyZbc3PZeEDKbp4tBRKv67zsL2RZ0j47rTAr6Ijb4/ZI/EGoib
         F1v/aPy9t2toMNYb0L2O70dB8rRt+AK2hBK9dSs3MRYud/1i8g+4n7iit2CgeJJvuF
         O7uqjMautOwCw==
Date:   Sun, 1 May 2022 11:52:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 10/17] net/mlx5: Clean IPsec FS add/delete
 rules
Message-ID: <Ym5KTD6cHatGlVCm@unreal>
References: <cover.1650363043.git.leonro@nvidia.com>
 <874f16edb960923bb25c83382d96cd4cb3732485.1650363043.git.leonro@nvidia.com>
 <20220422222536.uxyyveytmmkwvwjv@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422222536.uxyyveytmmkwvwjv@sx1>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:25:36PM -0700, Saeed Mahameed wrote:
> On 19 Apr 13:13, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Reuse existing struct to pass parameters instead of open code them.
> > 
> 
> Why? what do you mean "open code them" ? they are not open coded, they are
> primitive for a reason ! If we go with this reasoning, then let's pass
> mlx5e_priv to all functions and just forget about modularity.

There is not much value in having modularity between files/layers in
same block. These layers are not usable outside of that block (IPsec)
and ipsec.c is tightly coupled with ipsec_fs.c anyway by ensuring that
unsupported options are handled as early as possible.

The remove of existing artificial layering allows me to see useless
fields (see patch #17) and remove code that can't be executed anyway.

Separation between blocks (mlx5e_priv) is good and right thing,
separation inside blocks is not.

Thanks

> 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 +---
> > .../mellanox/mlx5/core/en_accel/ipsec.h       |  7 +--
> > .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 55 ++++++++++---------
> > 3 files changed, 34 insertions(+), 38 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index 537311a74bfb..81c9831ad286 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -313,9 +313,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> > 	if (err)
> > 		goto err_xfrm;
> > 
> > -	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->attrs,
> > -					    sa_entry->ipsec_obj_id,
> > -					    &sa_entry->ipsec_rule);
> > +	err = mlx5e_accel_ipsec_fs_add_rule(priv, sa_entry);
> 
> To add to my comment on the previous patch, in here the issue is more
> severe as previously ipsec_fs.c was unaware of sa_entry object and used to
> deal with pure fs related objects, you are peppering the code with sa_entry for
> no reason, other than reducing function parameters from 4 to 2.
> > 	if (err)
> > 		goto err_hw_ctx;
> > 
> > @@ -333,8 +331,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> > 	goto out;
> > 
> > err_add_rule:
> > -	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
> > -				      &sa_entry->ipsec_rule);
> > +	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
> > err_hw_ctx:
> > 	mlx5_ipsec_free_sa_ctx(sa_entry);
> > err_xfrm:
> > @@ -357,8 +354,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
> > 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
> > 
> > 	cancel_work_sync(&sa_entry->modify_work.work);
> > -	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
> > -				      &sa_entry->ipsec_rule);
> > +	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
> > 	mlx5_ipsec_free_sa_ctx(sa_entry);
> > 	kfree(sa_entry);
> > }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > index cdcb95f90623..af1467cbb7c7 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > @@ -176,12 +176,9 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
> > void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
> > int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
> > int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
> > -				  struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -				  u32 ipsec_obj_id,
> > -				  struct mlx5e_ipsec_rule *ipsec_rule);
> > +				  struct mlx5e_ipsec_sa_entry *sa_entry);
> > void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
> > -				   struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -				   struct mlx5e_ipsec_rule *ipsec_rule);
> > +				   struct mlx5e_ipsec_sa_entry *sa_entry);
> > 
> > int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
> > void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > index 96ab2e9d6f9a..342828351254 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > @@ -454,11 +454,12 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
> > }
> > 
> > static int rx_add_rule(struct mlx5e_priv *priv,
> > -		       struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -		       u32 ipsec_obj_id,
> > -		       struct mlx5e_ipsec_rule *ipsec_rule)
> > +		       struct mlx5e_ipsec_sa_entry *sa_entry)
> > {
> > 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
> > +	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
> > +	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
> > +	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
> > 	struct mlx5_modify_hdr *modify_hdr = NULL;
> > 	struct mlx5e_accel_fs_esp_prot *fs_prot;
> > 	struct mlx5_flow_destination dest = {};
> > @@ -532,9 +533,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
> > }
> > 
> > static int tx_add_rule(struct mlx5e_priv *priv,
> > -		       struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -		       u32 ipsec_obj_id,
> > -		       struct mlx5e_ipsec_rule *ipsec_rule)
> > +		       struct mlx5e_ipsec_sa_entry *sa_entry)
> > {
> > 	struct mlx5_flow_act flow_act = {};
> > 	struct mlx5_flow_handle *rule;
> > @@ -551,7 +550,8 @@ static int tx_add_rule(struct mlx5e_priv *priv,
> > 		goto out;
> > 	}
> > 
> > -	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
> > +	setup_fte_common(&sa_entry->attrs, sa_entry->ipsec_obj_id, spec,
> > +			 &flow_act);
> > 
> > 	/* Add IPsec indicator in metadata_reg_a */
> > 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
> > @@ -566,11 +566,11 @@ static int tx_add_rule(struct mlx5e_priv *priv,
> > 	if (IS_ERR(rule)) {
> > 		err = PTR_ERR(rule);
> > 		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
> > -				attrs->action, err);
> > +				sa_entry->attrs.action, err);
> > 		goto out;
> > 	}
> > 
> > -	ipsec_rule->rule = rule;
> > +	sa_entry->ipsec_rule.rule = rule;
> > 
> > out:
> > 	kvfree(spec);
> > @@ -580,21 +580,25 @@ static int tx_add_rule(struct mlx5e_priv *priv,
> > }
> > 
> > static void rx_del_rule(struct mlx5e_priv *priv,
> > -		struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -		struct mlx5e_ipsec_rule *ipsec_rule)
> > +			struct mlx5e_ipsec_sa_entry *sa_entry)
> > {
> > +	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
> > +
> > 	mlx5_del_flow_rules(ipsec_rule->rule);
> > 	ipsec_rule->rule = NULL;
> > 
> > 	mlx5_modify_header_dealloc(priv->mdev, ipsec_rule->set_modify_hdr);
> > 	ipsec_rule->set_modify_hdr = NULL;
> > 
> > -	rx_ft_put(priv, attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
> > +	rx_ft_put(priv,
> > +		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
> > }
> > 
> > static void tx_del_rule(struct mlx5e_priv *priv,
> > -		struct mlx5e_ipsec_rule *ipsec_rule)
> > +			struct mlx5e_ipsec_sa_entry *sa_entry)
> > {
> > +	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
> > +
> > 	mlx5_del_flow_rules(ipsec_rule->rule);
> > 	ipsec_rule->rule = NULL;
> > 
> > @@ -602,24 +606,23 @@ static void tx_del_rule(struct mlx5e_priv *priv,
> > }
> > 
> > int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
> > -				  struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -				  u32 ipsec_obj_id,
> > -				  struct mlx5e_ipsec_rule *ipsec_rule)
> > +				  struct mlx5e_ipsec_sa_entry *sa_entry)
> > {
> > -	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
> > -		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
> > -	else
> > -		return tx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
> > +	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT)
> > +		return tx_add_rule(priv, sa_entry);
> > +
> > +	return rx_add_rule(priv, sa_entry);
> > }
> > 
> > void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
> > -		struct mlx5_accel_esp_xfrm_attrs *attrs,
> > -		struct mlx5e_ipsec_rule *ipsec_rule)
> > +				   struct mlx5e_ipsec_sa_entry *sa_entry)
> > {
> > -	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
> > -		rx_del_rule(priv, attrs, ipsec_rule);
> > -	else
> > -		tx_del_rule(priv, ipsec_rule);
> > +	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT) {
> > +		tx_del_rule(priv, sa_entry);
> > +		return;
> > +	}
> > +
> > +	rx_del_rule(priv, sa_entry);
> > }
> > 
> > void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
> > -- 
> > 2.35.1
> > 
