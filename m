Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56F1145717
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgAVNux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:50:52 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5266207FF;
        Wed, 22 Jan 2020 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579701051;
        bh=c/2Qn8oALLz0bmD99XxDGplqFTpvOoL2edmjxlLclN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7o09RbGoBIS/zm+x0XVXRdlOIPKDn3U88s1y3oUNJiLVLJP7hJ0xi2F4tQh9nvMD
         JI9iV4asg2pof7lTWyr6z5BfUMyDFY6VkyECp0zjhKju6o0scHbjObTbsGb8J7R7/x
         1kU9AuQ49zBNacXk7mo90HNCs1edrVClRVXm2Xmg=
Date:   Wed, 22 Jan 2020 15:50:47 +0200
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
Message-ID: <20200122135047.GD7018@unreal>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
 <1579623382-6934-4-git-send-email-paulb@mellanox.com>
 <20200121190827.GN51881@unreal>
 <efe524c5-b325-78a5-1d6d-657ba32759b2@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efe524c5-b325-78a5-1d6d-657ba32759b2@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 01:42:33PM +0000, Paul Blakey wrote:
>
> On 1/21/2020 9:08 PM, Leon Romanovsky wrote:
> > On Tue, Jan 21, 2020 at 06:16:12PM +0200, Paul Blakey wrote:
> >> Multi chain support requires the miss path to continue the processing
> >> from the last chain id, and for that we need to save the chain
> >> miss tag (a mapping for 32bit chain id) on reg_c0 which will
> >> come in a next patch.
> >>
> >> Currently reg_c0 is exclusively used to store the source port
> >> metadata, giving it 32bit, it is created from 16bits of vcha_id,
> >> and 16bits of vport number.
> >>
> >> We will move this source port metadata to upper 16bits, and leave the
> >> lower bits for the chain miss tag. We compress the reg_c0 source port
> >> metadata to 16bits by taking 8 bits from vhca_id, and 8bits from
> >> the vport number.
> >>
> >> Since we compress the vport number to 8bits statically, and leave two
> >> top ids for special PF/ECPF numbers, we will only support a max of 254
> >> vports with this strategy.
> >>
> >> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> >> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> >> Reviewed-by: Mark Bloch <markb@mellanox.com>
> >> ---
> >>   drivers/infiniband/hw/mlx5/main.c                  |  3 +-
> >>   .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 81 +++++++++++++++++++---
> >>   include/linux/mlx5/eswitch.h                       | 11 ++-
> >>   3 files changed, 82 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> >> index 90489c5..844351c 100644
> >> --- a/drivers/infiniband/hw/mlx5/main.c
> >> +++ b/drivers/infiniband/hw/mlx5/main.c
> >> @@ -3535,7 +3535,8 @@ static void mlx5_ib_set_rule_source_port(struct mlx5_ib_dev *dev,
> >>   		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> >>   				    misc_parameters_2);
> >>
> >> -		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
> >> +		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
> >> +			 mlx5_eswitch_get_vport_metadata_mask());
> >>   	} else {
> >>   		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
> >>   				    misc_parameters);
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >> index a6d0b62..873b19c 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> >> @@ -50,6 +50,19 @@
> >>   #define MLX5_ESW_MISS_FLOWS (2)
> >>   #define UPLINK_REP_INDEX 0
> >>
> >> +/* Reg C0 usage:
> >> + * Reg C0 = < VHCA_ID_BITS(8) | VPORT BITS(8) | CHAIN_TAG(16) >
> >> + *
> >> + * Highest 8 bits of the reg c0 is the vhca_id, next 8 bits is vport_num,
> >> + * the rest (lowest 16 bits) is left for tc chain tag restoration.
> >> + * VHCA_ID + VPORT comprise the SOURCE_PORT matching.
> >> + */
> >> +#define VHCA_ID_BITS 8
> >> +#define VPORT_BITS 8
> >> +#define SOURCE_PORT_METADATA_BITS (VHCA_ID_BITS + VPORT_BITS)
> >> +#define SOURCE_PORT_METADATA_OFFSET (32 - SOURCE_PORT_METADATA_BITS)
> >> +#define CHAIN_TAG_METADATA_BITS (32 - SOURCE_PORT_METADATA_BITS)
> >> +
>
> [...]
>
>
> >> +u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
> >>   					      u16 vport_num)
> >>   {
> >> -	return ((MLX5_CAP_GEN(esw->dev, vhca_id) & 0xffff) << 16) | vport_num;
> >> +	u32 vport_num_mask = GENMASK(VPORT_BITS - 1, 0);
> >> +	u32 vhca_id_mask = GENMASK(VHCA_ID_BITS - 1, 0);
> >> +	u32 vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
> >> +	u32 val;
> >> +
> >> +	/* Make sure the vhca_id fits the VHCA_ID_BITS */
> >> +	WARN_ON_ONCE(vhca_id >= BIT(VHCA_ID_BITS));
> >> +
> >> +	/* Trim vhca_id to VHCA_ID_BITS */
> >> +	vhca_id &= vhca_id_mask;
> >> +
> >> +	/* Make sure pf and ecpf map to end of VPORT_BITS range so they
> >> +	 * don't overlap with VF numbers, and themselves, after trimming.
> >> +	 */
> >> +	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) <
> >> +		     vport_num_mask - 1);
> >> +	WARN_ON_ONCE((MLX5_VPORT_ECPF & vport_num_mask) <
> >> +		     vport_num_mask - 1);
> >> +	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) ==
> >> +		     (MLX5_VPORT_ECPF & vport_num_mask));
> >> +
> >> +	/* Make sure that the VF vport_num fits VPORT_BITS and don't
> >> +	 * overlap with pf and ecpf.
> >> +	 */
> >> +	if (vport_num != MLX5_VPORT_UPLINK &&
> >> +	    vport_num != MLX5_VPORT_ECPF)
> >> +		WARN_ON_ONCE(vport_num >= vport_num_mask - 1);
> >> +
> >> +	/* We can now trim vport_num to VPORT_BITS */
> >> +	vport_num &= vport_num_mask;
> >> +
> >> +	val = (vhca_id << VPORT_BITS) | vport_num;
> >> +	return val << (32 - SOURCE_PORT_METADATA_BITS);
> >>   }
> >>   EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
> >> +
> >> +u32 mlx5_eswitch_get_vport_metadata_mask(void)
> >> +{
> >> +	return GENMASK(31, 32 - SOURCE_PORT_METADATA_BITS);
> >> +}
> >> +EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_mask);
> > This function can be inline in .h file easily and actually does nothing
> > except return 0xFFFF.
>
> We will move this and relevant defines to the h file, and remove the exported symbol

Thanks
