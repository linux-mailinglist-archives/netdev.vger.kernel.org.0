Return-Path: <netdev+bounces-9938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C04672B34B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA453280EBA
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17EBE54B;
	Sun, 11 Jun 2023 17:35:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CE0523E
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52106C433D2;
	Sun, 11 Jun 2023 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686504908;
	bh=AhAg6PO6vYKl/A49pu/XOmPaUepT665ZeDUknSI0Kvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=apj3eaKYuQPkyb5KQ55Lz4lAe5P/hnWV2mRH4/Q1g4d0BmoA1nI0NRBS80Pmn8Fx7
	 2ryVfpIjur9QXU7qeQzce1t4qdoh473tkXH1kS0s2CwVtSW11Kza8rVeXjReaWoKGi
	 91vw3gZbJzRgOk16fJBXRyWjDNXtHZWLNT4KMZ92qq1hhp7c+pPRLh8sxbzi0VatRQ
	 sZZgEM7hz8yMbX4IRD36eX7SLx3EmCiWEfU57mvGEO91OKBo3pZbFGdWmCC2tSOLlR
	 kwe+gxHForrwA3U1tzERvZsXXY9QjDa6EPaChQq1y+5plSwU9pGoZDW/aK7+b60RDV
	 EiBuarOZZ8SCA==
Date: Sun, 11 Jun 2023 20:35:03 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>,
	Saeed Mahameed <saeedm@nvidia.com>
Cc: paulb@nvidia.com, linux-rdma@vger.kernel.org,
	linux-netdev <netdev@vger.kernel.org>
Subject: Re: [bug report] net/mlx5e: TC, Set CT miss to the specific ct
 action instance
Message-ID: <20230611173503.GF12152@unreal>
References: <497f5a7a-9f14-478e-b551-1fa74720b6f8@moroto.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497f5a7a-9f14-478e-b551-1fa74720b6f8@moroto.mountain>

+ netdev

On Wed, Jun 07, 2023 at 10:09:57AM +0300, Dan Carpenter wrote:
> Hello Paul Blakey,
> 
> The patch 6702782845a5: "net/mlx5e: TC, Set CT miss to the specific
> ct action instance" from Feb 18, 2023, leads to the following Smatch
> static checker warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:5648 mlx5e_tc_action_miss_mapping_get() warn: missing error code 'err'
> 
> Let's include some older unpublished Smatch stuff as well.
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:1683 mlx5e_tc_query_route_vport() info: return a literal instead of 'err'
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:4786 mlx5e_stats_flower() warn: missing error code 'err'
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>   1665  int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev, u16 *vport)
>   1666  {
>   1667          struct mlx5e_priv *out_priv, *route_priv;
>   1668          struct mlx5_core_dev *route_mdev;
>   1669          struct mlx5_devcom *devcom;
>   1670          struct mlx5_eswitch *esw;
>   1671          u16 vhca_id;
>   1672          int err;
>   1673          int i;
>   1674  
>   1675          out_priv = netdev_priv(out_dev);
>   1676          esw = out_priv->mdev->priv.eswitch;
>   1677          route_priv = netdev_priv(route_dev);
>   1678          route_mdev = route_priv->mdev;
>   1679  
>   1680          vhca_id = MLX5_CAP_GEN(route_mdev, vhca_id);
>   1681          err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
>   1682          if (!err)
>   1683                  return err;
> 
> This seems intentional but it look more intentional as "return 0;"
> 
>   1684  
>   1685          if (!mlx5_lag_is_active(out_priv->mdev))
>   1686                  return err;
> 
> return -ENOENT; here?
> 
>   1687  
>   1688          rcu_read_lock();
>   1689          devcom = out_priv->mdev->priv.devcom;
>   1690          err = -ENODEV;
>   1691          mlx5_devcom_for_each_peer_entry_rcu(devcom, MLX5_DEVCOM_ESW_OFFLOADS,
>   1692                                              esw, i) {
>   1693                  err = mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
>   1694                  if (!err)
>   1695                          break;
>   1696          }
>   1697          rcu_read_unlock();
>   1698  
>   1699          return err;
>   1700  }
> 
> [ snip ]
> 
>   4727  int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
>   4728                         struct flow_cls_offload *f, unsigned long flags)
>   4729  {
>   4730          struct mlx5_devcom *devcom = priv->mdev->priv.devcom;
>   4731          struct rhashtable *tc_ht = get_tc_ht(priv, flags);
>   4732          struct mlx5e_tc_flow *flow;
>   4733          struct mlx5_fc *counter;
>   4734          u64 lastuse = 0;
>   4735          u64 packets = 0;
>   4736          u64 bytes = 0;
>   4737          int err = 0;
>   4738  
>   4739          rcu_read_lock();
>   4740          flow = mlx5e_flow_get(rhashtable_lookup(tc_ht, &f->cookie,
>   4741                                                  tc_ht_params));
>   4742          rcu_read_unlock();
>   4743          if (IS_ERR(flow))
>   4744                  return PTR_ERR(flow);
>   4745  
>   4746          if (!same_flow_direction(flow, flags)) {
>   4747                  err = -EINVAL;
>   4748                  goto errout;
>   4749          }
>   4750  
>   4751          if (mlx5e_is_offloaded_flow(flow)) {
>   4752                  if (flow_flag_test(flow, USE_ACT_STATS)) {
>   4753                          f->use_act_stats = true;
>   4754                  } else {
>   4755                          counter = mlx5e_tc_get_counter(flow);
>   4756                          if (!counter)
>   4757                                  goto errout;
> 
> No error code.  In this function it's hard to say if these should be
> error paths or not.
> 
>   4758  
>   4759                          mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
>   4760                  }
>   4761          }
>   4762  
>   4763          /* Under multipath it's possible for one rule to be currently
>   4764           * un-offloaded while the other rule is offloaded.
>   4765           */
>   4766          if (!mlx5_devcom_for_each_peer_begin(devcom, MLX5_DEVCOM_ESW_OFFLOADS))
>   4767                  goto out;
> 
> No error code
> 
>   4768  
>   4769          if (flow_flag_test(flow, DUP)) {
>   4770                  struct mlx5e_tc_flow *peer_flow;
>   4771  
>   4772                  list_for_each_entry(peer_flow, &flow->peer_flows, peer_flows) {
>   4773                          u64 packets2;
>   4774                          u64 lastuse2;
>   4775                          u64 bytes2;
>   4776  
>   4777                          if (!flow_flag_test(peer_flow, OFFLOADED))
>   4778                                  continue;
>   4779                          if (flow_flag_test(flow, USE_ACT_STATS)) {
>   4780                                  f->use_act_stats = true;
>   4781                                  break;
>   4782                          }
>   4783  
>   4784                          counter = mlx5e_tc_get_counter(peer_flow);
>   4785                          if (!counter)
>   4786                                  goto no_peer_counter;
> 
> No error code
> 
>   4787                          mlx5_fc_query_cached(counter, &bytes2, &packets2,
>   4788                                               &lastuse2);
>   4789  
>   4790                          bytes += bytes2;
>   4791                          packets += packets2;
>   4792                          lastuse = max_t(u64, lastuse, lastuse2);
>   4793                  }
>   4794          }
>   4795  
>   4796  no_peer_counter:
>   4797          mlx5_devcom_for_each_peer_end(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
>   4798  out:
>   4799          flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
>   4800                            FLOW_ACTION_HW_STATS_DELAYED);
>   4801          trace_mlx5e_stats_flower(f);
>   4802  errout:
>   4803          mlx5e_flow_put(priv, flow);
>   4804          return err;
>   4805  }
> 
> [ snip ]
> 
>   5627  int mlx5e_tc_action_miss_mapping_get(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
>   5628                                       u64 act_miss_cookie, u32 *act_miss_mapping)
>   5629  {
>   5630          struct mlx5_mapped_obj mapped_obj = {};
>   5631          struct mlx5_eswitch *esw;
>   5632          struct mapping_ctx *ctx;
>   5633          int err;
>   5634  
>   5635          ctx = mlx5e_get_priv_obj_mapping(priv);
>   5636          mapped_obj.type = MLX5_MAPPED_OBJ_ACT_MISS;
>   5637          mapped_obj.act_miss_cookie = act_miss_cookie;
>   5638          err = mapping_add(ctx, &mapped_obj, act_miss_mapping);
>   5639          if (err)
>   5640                  return err;
>   5641  
>   5642          if (!is_mdev_switchdev_mode(priv->mdev))
>   5643                  return 0;
>   5644  
>   5645          esw = priv->mdev->priv.eswitch;
>   5646          attr->act_id_restore_rule = esw_add_restore_rule(esw, *act_miss_mapping);
>   5647          if (IS_ERR(attr->act_id_restore_rule))
>   5648                  goto err_rule;
> 
> This one is definitely an error path.
> 
>   5649  
>   5650          return 0;
>   5651  
>   5652  err_rule:
>   5653          mapping_remove(ctx, *act_miss_mapping);
>   5654          return err;
>   5655  }
> 
> regards,
> dan carpenter

