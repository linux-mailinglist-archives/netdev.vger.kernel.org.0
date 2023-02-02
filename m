Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08BA687B85
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjBBLHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjBBLHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:07:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C603138E82
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:07:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB2861A69
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 11:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D185FC433D2;
        Thu,  2 Feb 2023 11:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675336039;
        bh=J6317uKZlO7v5P5b468lroMwgaiNrooCahSprv5wjp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YfT2+XVvj5dW+vGgxYcMx073SktkBqQ+gUPfXGT7uWPchJq0g8k8JkWsrkMLMA3+E
         2yK33qUcnipbnxbmiTIlWjdQ1LvWpVvNvPVX+ZpyGMRdCLgyDFCnp+csBXaE+oC4nP
         ABo1IuIkW9w4e3nhBXxbthznDYqcPr2Q2CZTdK+aRc+HDqdO0/dF92SmGoVmOYUqqM
         Z3K2ENKvvDovRgeKGGmHEGPQj4EljX8bTwrQzrSZaVTWnqM75yXKegPg116fm1Fz4T
         PJOqyjn2UXKwdcB/OtlbSDjIp6/C35IVTK+cnNy4+Sc/avEQ0MxIA4A37FKbr8BQfy
         92yh89Zi9rrGw==
Date:   Thu, 2 Feb 2023 13:07:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v7 4/6] net/mlx5: Refactor tc miss handling to a
 single function
Message-ID: <Y9uZYyEJ3c32Fhy1@unreal>
References: <20230131091027.8093-1-paulb@nvidia.com>
 <20230131091027.8093-5-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131091027.8093-5-paulb@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:10:25AM +0200, Paul Blakey wrote:
> Move tc miss handling code to en_tc.c, and remove
> duplicate code.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 224 ++----------------
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 221 +++++++++++++++--
>  .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  11 +-
>  4 files changed, 231 insertions(+), 229 deletions(-)

<...>

>  void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
>  			  struct sk_buff *skb)
>  {
> -	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata);
> +	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata), reg_c0, zone_restore_id, tunnel_id;

I would recommend to put reg_c1 = be32_to_cpu(cqe->ft_metadata) above
reg_c0 = ... below and not as part of long list of variables.

>  	struct mlx5e_tc_update_priv tc_priv = {};
> -	struct mlx5_mapped_obj mapped_obj;
> +	struct mlx5_rep_uplink_priv *uplink_priv;
> +	struct mlx5e_rep_priv *uplink_rpriv;
> +	struct mlx5_tc_ct_priv *ct_priv;
> +	struct mapping_ctx *mapping_ctx;
>  	struct mlx5_eswitch *esw;
> -	bool forward_tx = false;
>  	struct mlx5e_priv *priv;
> -	u32 reg_c0;
> -	int err;
>  
>  	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
>  	if (!reg_c0 || reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
>  		goto forward;

<...>

> +static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
> +				    struct mlx5e_tc_update_priv *tc_priv,
> +				    u32 tunnel_id)
>  {
> -#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> -	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
> -	struct mlx5e_priv *priv = netdev_priv(skb->dev);
> -	struct mlx5_mapped_obj mapped_obj;
> -	struct tc_skb_ext *tc_skb_ext;
> -	struct mlx5e_tc_table *tc;
> +	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> +	struct tunnel_match_enc_opts enc_opts = {};
> +	struct mlx5_rep_uplink_priv *uplink_priv;
> +	struct mlx5e_rep_priv *uplink_rpriv;
> +	struct metadata_dst *tun_dst;
> +	struct tunnel_match_key key;
> +	u32 tun_id, enc_opts_id;
> +	struct net_device *dev;
>  	int err;
>  
> -	reg_b = be32_to_cpu(cqe->ft_metadata);
> -	tc = mlx5e_fs_get_tc(priv->fs);
> -	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
> +	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
> +	tun_id = tunnel_id >> ENC_OPTS_BITS;
>  
> -	err = mapping_find(tc->mapping, chain_tag, &mapped_obj);
> +	if (!tun_id)
> +		return true;
> +
> +	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> +	uplink_priv = &uplink_rpriv->uplink_priv;
> +
> +	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
>  	if (err) {
>  		netdev_dbg(priv->netdev,
> -			   "Couldn't find chain for chain tag: %d, err: %d\n",
> -			   chain_tag, err);
> +			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
> +			   tun_id, err);
> +		return false;
> +	}
> +
> +	if (enc_opts_id) {
> +		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
> +				   enc_opts_id, &enc_opts);
> +		if (err) {
> +			netdev_dbg(priv->netdev,
> +				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
> +				   enc_opts_id, err);
> +			return false;
> +		}
> +	}
> +
> +	if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
> +		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
> +					   key.enc_ip.tos, key.enc_ip.ttl,
> +					   key.enc_tp.dst, TUNNEL_KEY,
> +					   key32_to_tunnel_id(key.enc_key_id.keyid),
> +					   enc_opts.key.len);
> +	} else if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
> +		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
> +					     key.enc_ip.tos, key.enc_ip.ttl,
> +					     key.enc_tp.dst, 0, TUNNEL_KEY,
> +					     key32_to_tunnel_id(key.enc_key_id.keyid),
> +					     enc_opts.key.len);
> +	} else {
> +		netdev_dbg(priv->netdev,
> +			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
> +			   key.enc_control.addr_type);
>  		return false;
>  	}

I know that you moved this code from some other place, but it is not
mlx5 style, we use switch<->case for code like this.

>  
> -	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
> -		chain = mapped_obj.chain;
> +	if (!tun_dst) {
> +		netdev_dbg(priv->netdev, "Couldn't restore tunnel, no tun_dst\n");
> +		return false;
> +	}
> +

<...>

> +static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
> +				       u32 chain, u32 zone_restore_id,
> +				       u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
> +{
> +	struct mlx5e_priv *priv = netdev_priv(skb->dev);
> +	struct tc_skb_ext *tc_skb_ext;
> +
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)

Is it possible to rewrite all these "#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)"
to something more close to recommended kernel style?

if (IS_ENABLED(CONFIG_NET_TC_SKB_EXT) && chain) {
 ...

Spaghetti code like this is not very friendly to ctags.

> +	if (chain) {
> +		if (!mlx5e_tc_ct_restore_flow(ct_priv, skb, zone_restore_id))
> +			return false;
> +
>  		tc_skb_ext = tc_skb_ext_alloc(skb);
> -		if (WARN_ON(!tc_skb_ext))
> +		if (!tc_skb_ext) {
> +			WARN_ON(1);
>  			return false;
> +		}
>  
>  		tc_skb_ext->chain = chain;
> +	}
> +#endif /* CONFIG_NET_TC_SKB_EXT */

<...>

> +bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)

This function is declared in .h file and has empty implementation for not
enabled CONFIG_NET_TC_SKB_EXT. Why do you need this IS_ENABLED?

> +{
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> +	struct mlx5e_priv *priv = netdev_priv(skb->dev);
> +	u32 mapped_obj_id, reg_b, zone_restore_id;
> +	struct mlx5_tc_ct_priv *ct_priv;
> +	struct mapping_ctx *mapping_ctx;
> +	struct mlx5e_tc_table *tc;
> +
> +	reg_b = be32_to_cpu(cqe->ft_metadata);
> +	tc = mlx5e_fs_get_tc(priv->fs);
> +	mapped_obj_id = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
> +	zone_restore_id = (reg_b >> MLX5_REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
> +			  ESW_ZONE_ID_MASK;
> +	ct_priv = tc->ct;
> +	mapping_ctx = tc->mapping;
> +
> +	return mlx5e_tc_update_skb(cqe, skb, mapping_ctx, mapped_obj_id, ct_priv, zone_restore_id,
> +				   0, NULL);
>  #endif /* CONFIG_NET_TC_SKB_EXT */
>  
>  	return true;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> index ce516dc7f3fd..4fa5d4e024cd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
> @@ -59,6 +59,8 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
>  
>  struct mlx5e_tc_update_priv {
>  	struct net_device *fwd_dev;
> +	bool skb_done;
> +	bool forward_tx;
>  };
>  
>  struct mlx5_nic_flow_attr {
> @@ -386,14 +388,19 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
>  	return false;
>  }
>  
> -bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
> +bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
> +bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
> +			 struct mapping_ctx *mapping_ctx, u32 mapped_obj_id,
> +			 struct mlx5_tc_ct_priv *ct_priv,
> +			 u32 zone_restore_id, u32 tunnel_id,
> +			 struct mlx5e_tc_update_priv *tc_priv);
>  #else /* CONFIG_MLX5_CLS_ACT */
>  static inline struct mlx5e_tc_table *mlx5e_tc_table_alloc(void) { return NULL; }
>  static inline void mlx5e_tc_table_free(struct mlx5e_tc_table *tc) {}
>  static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
>  { return false; }
>  static inline bool
> -mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
> +mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
>  { return true; }
>  #endif
>  
> -- 
> 2.30.1
> 
> 
