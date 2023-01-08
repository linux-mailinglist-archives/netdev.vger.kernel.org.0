Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69282661483
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjAHKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHKdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:33:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888CEE08A;
        Sun,  8 Jan 2023 02:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99939B8074A;
        Sun,  8 Jan 2023 10:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8927DC433EF;
        Sun,  8 Jan 2023 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673173978;
        bh=83bCfOEOYeaD3X1wzJT0rvku8xLuP3HjBPuclmqWHvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3LA+AEo5Q5/cEnEo1UaxkuyQXG1IYjGahw2cIFAxjz4+iV3w1s2Tj3sy5hrTokwQ
         YuCz8IWTFTou1jBZ2WQfgN6DsVcgGiy7roYvHQL1Id7+ZYY2dTa+PlsP5nID/5oi5G
         aWiGgeVEEX/cbJX8Vw/Z9MA2SrXqNJSdFEHrk9t7BrcLFk4UN54X/IqV0uHQbpz43P
         3GMXjbUjM4oZbdUrUitAnwNp2qy1xbum9/8wZxb/tDsUEldmz9Oc9m9eZ0kHBJ/Zg/
         vfCNbSqK/L9od59lKN5NJqCKvNYpdGKH4cbrvbHpFXjJQU2RWMN2CInmHBIV7ecCQy
         BS9glS8rH4/Ew==
Date:   Sun, 8 Jan 2023 12:32:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Use query_special_contexts for
 mkeys
Message-ID: <Y7qb1aeuGowalgzs@unreal>
References: <cover.1672819469.git.leonro@nvidia.com>
 <849b3e708a147a3e2fc94277b805f5cc388f16ab.1672819469.git.leonro@nvidia.com>
 <Y7dyLlo3T1ibHMNn@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7dyLlo3T1ibHMNn@x130>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 04:58:22PM -0800, Saeed Mahameed wrote:
> On 04 Jan 10:11, Leon Romanovsky wrote:
> > From: Or Har-Toov <ohartoov@nvidia.com>
> > 
> > Using query_sepcial_contexts in order to get the correct value of
> > terminate_scatter_list_mkey, as FW will change it in some configurations.
> > This is done one time when the device is loading and the value is being
> > saved in the device context.
> > 
> > Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> > Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
> > .../net/ethernet/mellanox/mlx5/core/main.c    | 27 +++++++++++++++++++
> > include/linux/mlx5/driver.h                   |  1 +
> > 3 files changed, 29 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index c76f15505a76..33d7a7095988 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -826,7 +826,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
> > 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
> > 				wqe->data[f].byte_count = 0;
> > 				wqe->data[f].lkey =
> > -					MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > +					mdev->terminate_scatter_list_mkey;
> > 				wqe->data[f].addr = 0;
> > 			}
> > 		}
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index 7f5db13e3550..d39d758744a0 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -1221,6 +1221,28 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
> > 	return 0;
> > }
> > 
> > +static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
> > +{
> > +	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> > +	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> > +	int err;
> > +
> > +	MLX5_SET(query_special_contexts_in, in, opcode,
> > +		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> > +	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> > +	if (err)
> > +		return err;
> > +
> > +	if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
> 
> Why did you execute the command unconditionally if the output is only read
> conditionally?
> 
> early exit before executing the command, older FW might fail and driver will
> be unusable ..

According to the documentation, this functionality was forever, but you
are presenting valid concern.

> 
> > +		dev->terminate_scatter_list_mkey =
> > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > +					     terminate_scatter_list_mkey));
> > +		return 0;
> > +	}
> > +	dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
> 
> Another concern, what happens with old driver that is using the hardcoded
> value with newer fw ? will it fail ? will it be accepted ?

It will be accepted and everything will work without glitches.
FW keeps backward compatibility and use MLX5_TERMINATE_SCATTER_LIST_LKEY
internally as a default.

> 
> The commit message doesn't explain what's going on here very well,
> Let's discuss internally before you submit V2.

NP.

> 
> > +	return 0;
> > +}
> > +
> > static int mlx5_load(struct mlx5_core_dev *dev)
> > {
> > 	int err;
> > @@ -1235,6 +1257,11 @@ static int mlx5_load(struct mlx5_core_dev *dev)
> > 	mlx5_events_start(dev);
> > 	mlx5_pagealloc_start(dev);
> > 
> > +	err = mlx5_get_terminate_scatter_list_mkey(dev);
> > +	if (err) {
> > +		mlx5_core_err(dev, "Failed to query special contexts\n");
> print the err;
> > +		goto err_irq_table;
> > +	}
> 
> you are querying FW too soon, no issue here but better if you move it after
> mlx5_eq_table_create() to use the command EQ rather than the primitive cmd
> interface.

I'll take a look.

Thanks

> 
> > 	err = mlx5_irq_table_create(dev);
> > 	if (err) {
> > 		mlx5_core_err(dev, "Failed to alloc IRQs\n");
> > diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> > index d476255c9a3f..5f2c4038d638 100644
> > --- a/include/linux/mlx5/driver.h
> > +++ b/include/linux/mlx5/driver.h
> > @@ -801,6 +801,7 @@ struct mlx5_core_dev {
> > 	struct mlx5_rsc_dump    *rsc_dump;
> > 	u32                      vsc_addr;
> > 	struct mlx5_hv_vhca	*hv_vhca;
> > +	__be32			terminate_scatter_list_mkey;
> > };
> > 
> > struct mlx5_db {
> > -- 
> > 2.38.1
> > 
