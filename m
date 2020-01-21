Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB121444D5
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAUTIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgAUTIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 14:08:34 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6102021835;
        Tue, 21 Jan 2020 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579633712;
        bh=OFNsVSAjbpMuz0hW4pYvW7BMa0+ZdAc/H8cfYvtzs1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nwB5xfKDUO14rXg5VbWiOqxNihhhPyR5j1UTD7yHHASnKAePliX1AHQCg7CbpTaYa
         EqKJgbfePhkkUFJPtDVTKNAxJ90Dh8WSyGcpgbAcGHRxjGO7T0QSgcXXJuyjVFZSe/
         fRSr5fP4bt9vXzz6KoagdXPwf4/f5FtivHk3yjyU=
Date:   Tue, 21 Jan 2020 21:08:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next-mlx5 03/13] net/mlx5: E-Switch, Move source port
 on reg_c0 to the upper 16 bits
Message-ID: <20200121190827.GN51881@unreal>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
 <1579623382-6934-4-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579623382-6934-4-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 06:16:12PM +0200, Paul Blakey wrote:
> Multi chain support requires the miss path to continue the processing
> from the last chain id, and for that we need to save the chain
> miss tag (a mapping for 32bit chain id) on reg_c0 which will
> come in a next patch.
>
> Currently reg_c0 is exclusively used to store the source port
> metadata, giving it 32bit, it is created from 16bits of vcha_id,
> and 16bits of vport number.
>
> We will move this source port metadata to upper 16bits, and leave the
> lower bits for the chain miss tag. We compress the reg_c0 source port
> metadata to 16bits by taking 8 bits from vhca_id, and 8bits from
> the vport number.
>
> Since we compress the vport number to 8bits statically, and leave two
> top ids for special PF/ECPF numbers, we will only support a max of 254
> vports with this strategy.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c                  |  3 +-
>  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 81 +++++++++++++++++++---
>  include/linux/mlx5/eswitch.h                       | 11 ++-
>  3 files changed, 82 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 90489c5..844351c 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3535,7 +3535,8 @@ static void mlx5_ib_set_rule_source_port(struct mlx5_ib_dev *dev,
>  		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
>  				    misc_parameters_2);
>
> -		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
> +		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
> +			 mlx5_eswitch_get_vport_metadata_mask());
>  	} else {
>  		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
>  				    misc_parameters);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index a6d0b62..873b19c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -50,6 +50,19 @@
>  #define MLX5_ESW_MISS_FLOWS (2)
>  #define UPLINK_REP_INDEX 0
>
> +/* Reg C0 usage:
> + * Reg C0 = < VHCA_ID_BITS(8) | VPORT BITS(8) | CHAIN_TAG(16) >
> + *
> + * Highest 8 bits of the reg c0 is the vhca_id, next 8 bits is vport_num,
> + * the rest (lowest 16 bits) is left for tc chain tag restoration.
> + * VHCA_ID + VPORT comprise the SOURCE_PORT matching.
> + */
> +#define VHCA_ID_BITS 8
> +#define VPORT_BITS 8
> +#define SOURCE_PORT_METADATA_BITS (VHCA_ID_BITS + VPORT_BITS)
> +#define SOURCE_PORT_METADATA_OFFSET (32 - SOURCE_PORT_METADATA_BITS)
> +#define CHAIN_TAG_METADATA_BITS (32 - SOURCE_PORT_METADATA_BITS)
> +
>  static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
>  						     u16 vport_num)
>  {
> @@ -85,7 +98,8 @@ static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
>  								   attr->in_rep->vport));
>
>  		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
> -		MLX5_SET_TO_ONES(fte_match_set_misc2, misc2, metadata_reg_c_0);
> +		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
> +			 mlx5_eswitch_get_vport_metadata_mask());
>
>  		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
>  		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
> @@ -621,7 +635,8 @@ static void peer_miss_rules_setup(struct mlx5_eswitch *esw,
>  	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
>  		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
>  				    misc_parameters_2);
> -		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
> +		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
> +			 mlx5_eswitch_get_vport_metadata_mask());
>
>  		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
>  	} else {
> @@ -851,8 +866,9 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
>  			 match_criteria_enable,
>  			 MLX5_MATCH_MISC_PARAMETERS_2);
>
> -		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
> -				 misc_parameters_2.metadata_reg_c_0);
> +		MLX5_SET(fte_match_param, match_criteria,
> +			 misc_parameters_2.metadata_reg_c_0,
> +			 mlx5_eswitch_get_vport_metadata_mask());
>  	} else {
>  		MLX5_SET(create_flow_group_in, flow_group_in,
>  			 match_criteria_enable,
> @@ -1134,7 +1150,8 @@ struct mlx5_flow_handle *
>  			 mlx5_eswitch_get_vport_metadata_for_match(esw, vport));
>
>  		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
> -		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
> +		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
> +			 mlx5_eswitch_get_vport_metadata_mask());
>
>  		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
>  	} else {
> @@ -1604,11 +1621,17 @@ static int esw_vport_add_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
>  	static const struct mlx5_flow_spec spec = {};
>  	struct mlx5_flow_act flow_act = {};
>  	int err = 0;
> +	u32 key;
> +
> +	key = mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport);
> +	key >>= SOURCE_PORT_METADATA_OFFSET;
>
>  	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
> -	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
> -	MLX5_SET(set_action_in, action, data,
> -		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport));
> +	MLX5_SET(set_action_in, action, field,
> +		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
> +	MLX5_SET(set_action_in, action, data, key);
> +	MLX5_SET(set_action_in, action, offset, SOURCE_PORT_METADATA_OFFSET);
> +	MLX5_SET(set_action_in, action, length, SOURCE_PORT_METADATA_BITS);
>
>  	vport->ingress.offloads.modify_metadata =
>  		mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
> @@ -2465,9 +2488,47 @@ bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw)
>  }
>  EXPORT_SYMBOL(mlx5_eswitch_vport_match_metadata_enabled);
>
> -u32 mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *esw,
> +u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
>  					      u16 vport_num)
>  {
> -	return ((MLX5_CAP_GEN(esw->dev, vhca_id) & 0xffff) << 16) | vport_num;
> +	u32 vport_num_mask = GENMASK(VPORT_BITS - 1, 0);
> +	u32 vhca_id_mask = GENMASK(VHCA_ID_BITS - 1, 0);
> +	u32 vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
> +	u32 val;
> +
> +	/* Make sure the vhca_id fits the VHCA_ID_BITS */
> +	WARN_ON_ONCE(vhca_id >= BIT(VHCA_ID_BITS));
> +
> +	/* Trim vhca_id to VHCA_ID_BITS */
> +	vhca_id &= vhca_id_mask;
> +
> +	/* Make sure pf and ecpf map to end of VPORT_BITS range so they
> +	 * don't overlap with VF numbers, and themselves, after trimming.
> +	 */
> +	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) <
> +		     vport_num_mask - 1);
> +	WARN_ON_ONCE((MLX5_VPORT_ECPF & vport_num_mask) <
> +		     vport_num_mask - 1);
> +	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) ==
> +		     (MLX5_VPORT_ECPF & vport_num_mask));
> +
> +	/* Make sure that the VF vport_num fits VPORT_BITS and don't
> +	 * overlap with pf and ecpf.
> +	 */
> +	if (vport_num != MLX5_VPORT_UPLINK &&
> +	    vport_num != MLX5_VPORT_ECPF)
> +		WARN_ON_ONCE(vport_num >= vport_num_mask - 1);
> +
> +	/* We can now trim vport_num to VPORT_BITS */
> +	vport_num &= vport_num_mask;
> +
> +	val = (vhca_id << VPORT_BITS) | vport_num;
> +	return val << (32 - SOURCE_PORT_METADATA_BITS);
>  }
>  EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
> +
> +u32 mlx5_eswitch_get_vport_metadata_mask(void)
> +{
> +	return GENMASK(31, 32 - SOURCE_PORT_METADATA_BITS);
> +}
> +EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_mask);

This function can be inline in .h file easily and actually does nothing
except return 0xFFFF.

> diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
> index 98e667b..080b67c 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -71,8 +71,9 @@ enum devlink_eswitch_encap_mode
>  mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev);
>
>  bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
> -u32 mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *esw,
> +u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
>  					      u16 vport_num);
> +u32 mlx5_eswitch_get_vport_metadata_mask(void);
>  u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
>  #else  /* CONFIG_MLX5_ESWITCH */
>
> @@ -94,11 +95,17 @@ static inline u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
>  };
>
>  static inline u32
> -mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *esw,
> +mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
>  					  int vport_num)
>  {
>  	return 0;
>  };
> +
> +static inline u32
> +mlx5_eswitch_get_vport_metadata_mask(void)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_MLX5_ESWITCH */
>
>  #endif
> --
> 1.8.3.1
>
