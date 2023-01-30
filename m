Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9B68099E
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbjA3Jfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236597AbjA3Jey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:34:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09990305FB
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 01:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0070760F02
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5C4C433EF;
        Mon, 30 Jan 2023 09:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675071207;
        bh=aIH+z+o38uRTMjxtQvDXkes7YmT+X5rRpigTkXMzNf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jegvxjlq8hx3zthuhr29+7fefcQL8EPV9+BnQacAZCT3930rtS95ldl+mZ0xPMWcQ
         VpPOhplTNSS3UC8ppzdUrenGgPjsuCU8ujFc/vbsrn5hKu/KyZY65WmxjqxieNh923
         rrrEOx6vwLSrNOBfJRdBoed3EowCl6NfFyjT4US45Cp7Ip7RBsGr5kacv563jJ7ieO
         AvL2oDx3ky6Jn7VMhKcHtSX9xdr9XMv0Orhrogah/cZsLRF8sJwArHNSDNjzK4iIT1
         P7iDIzw2bYOZL8e9yVyUY0lkRi0QmXyomiOYvI/hRgBuWjA0xBtWLNIN/o6QWbQv+1
         sIyS1Hz/qZlXA==
Date:   Mon, 30 Jan 2023 11:33:22 +0200
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
Subject: Re: [PATCH net-next v6 4/6] net/mlx5: Refactor tc miss handling to a
 single function
Message-ID: <Y9eO4rZ6zAyuNk6j@unreal>
References: <20230129101613.17201-1-paulb@nvidia.com>
 <20230129101613.17201-5-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129101613.17201-5-paulb@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 12:16:11PM +0200, Paul Blakey wrote:
> Move tc miss handling code to en_tc.c, and remove
> duplicate code.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++----------------
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 221 +++++++++++++++--
>  .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  11 +-
>  4 files changed, 232 insertions(+), 229 deletions(-)

<...>

>  void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
>  			  struct sk_buff *skb)
>  {
> -	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata);
> +	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata), reg_c0, zone_restore_id, tunnel_id;
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
>  
> -	/* If reg_c0 is not equal to the default flow tag then skb->mark
> +	/* If mapped_obj_id is not equal to the default flow tag then skb->mark
>  	 * is not supported and must be reset back to 0.
>  	 */
>  	skb->mark = 0;
>  
>  	priv = netdev_priv(skb->dev);
>  	esw = priv->mdev->priv.eswitch;
> -	err = mapping_find(esw->offloads.reg_c0_obj_pool, reg_c0, &mapped_obj);
> -	if (err) {
> -		netdev_dbg(priv->netdev,
> -			   "Couldn't find mapped object for reg_c0: %d, err: %d\n",
> -			   reg_c0, err);
> -		goto free_skb;
> -	}
> +	mapping_ctx = esw->offloads.reg_c0_obj_pool;
> +	zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
> +	tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
>  
> -	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
> -		if (!mlx5e_restore_skb_chain(skb, mapped_obj.chain, reg_c1, &tc_priv) &&
> -		    !mlx5_ipsec_is_rx_flow(cqe))
> -			goto free_skb;
> -	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
> -		mlx5e_restore_skb_sample(priv, skb, &mapped_obj, &tc_priv);
> -		goto free_skb;
> -	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_INT_PORT_METADATA) {
> -		if (!mlx5e_restore_skb_int_port(priv, skb, &mapped_obj, &tc_priv,
> -						&forward_tx, reg_c1))
> -			goto free_skb;
> -	} else {
> -		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
> +	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> +	uplink_priv = &uplink_rpriv->uplink_priv;
> +	ct_priv = uplink_priv->ct_priv;
> +
> +	if (!mlx5_ipsec_is_rx_flow(cqe) &&
> +	    !mlx5e_tc_update_skb(cqe, skb, mapping_ctx, reg_c0, ct_priv, zone_restore_id, tunnel_id,
> +				 &tc_priv))
>  		goto free_skb;
> -	}
>  
>  forward:
> -	if (forward_tx)
> +	if (tc_priv.skb_done)
> +		goto free_skb;
> +
> +	if (tc_priv.forward_tx)
>  		dev_queue_xmit(skb);
>  	else
>  		napi_gro_receive(rq->cq.napi, skb);
>  
> -	mlx5_rep_tc_post_napi_receive(&tc_priv);
> +	if (tc_priv.fwd_dev)
> +		dev_put(tc_priv.fwd_dev);
>  
>  	return;
>  
>  free_skb:
> +	WARN_ON(tc_priv.fwd_dev);

Kernel splat which can be triggered from the network by sending traffic
to the target is not good idea.

It is safer to remove this WARN_ON().

Thanks
