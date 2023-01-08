Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE266147E
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjAHKVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHKVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:21:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F7DF2A;
        Sun,  8 Jan 2023 02:21:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C79460BCA;
        Sun,  8 Jan 2023 10:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D48CC433EF;
        Sun,  8 Jan 2023 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673173296;
        bh=E2OW3tF6vovZ+kdvFex3KTDxhPSmif/7VgNXdMlM4xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q0bqr7rLE0KOE/0tuyUAJKPf4vQRl9WE3G8iSfEC+gEs4QK0dYLb8572GdZy1ZzYK
         fVAxCnbSk0UQHurPEndlxWMeTmSV8a4VF7InDfd2mCTwUq0AzRayRuPQflKAXZkPs2
         ygMRe1KYT8XGmLLADm9phzzN0Enur8vCoN9dmZjjxogYsE0cB0K0BlYkMqh7Xt5LFm
         J7MbJxgUM2BjrbZ6cxWAnUQArrZnErW48NhRYrofypD7DGRJdnylIVRrs6ve0bVkTm
         RA0otrioWsTtsXjZti+/QIrXE7peAAQ4ndWtiiEjxryiYQhpbRCk13rFEUqvlqKdaE
         bd38znd2HhABA==
Date:   Sun, 8 Jan 2023 12:21:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 4/4] RDMA/mlx5: Use query_special_contexts for
 mkeys
Message-ID: <Y7qZLFBUTMIoCa/j@unreal>
References: <cover.1672819469.git.leonro@nvidia.com>
 <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
 <Y7V5CtJmorEc4u93@nvidia.com>
 <Y7V6otdhR5vJ1nPy@unreal>
 <Y7V7Zmnldy81lRIO@nvidia.com>
 <Y7WFTULBGZ1WczxV@unreal>
 <Y7WFhXk6UhGulLKi@nvidia.com>
 <Y7WHFm7b7N/Y+HpS@unreal>
 <Y7dzg/4MAMSmOR1o@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7dzg/4MAMSmOR1o@x130>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 05:04:03PM -0800, Saeed Mahameed wrote:
> On 04 Jan 16:03, Leon Romanovsky wrote:
> > On Wed, Jan 04, 2023 at 09:56:21AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 04, 2023 at 03:55:25PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Jan 04, 2023 at 09:13:10AM -0400, Jason Gunthorpe wrote:
> > > > > On Wed, Jan 04, 2023 at 03:09:54PM +0200, Leon Romanovsky wrote:
> > > > > > On Wed, Jan 04, 2023 at 09:03:06AM -0400, Jason Gunthorpe wrote:
> > > > > > > On Wed, Jan 04, 2023 at 10:11:25AM +0200, Leon Romanovsky wrote:
> > > > > > > > -int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
> > > > > > > > -{
> > > > > > > > -	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> > > > > > > > -	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> > > > > > > > -	int err;
> > > > > > > > +	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
> > > > > > > > +	if (err)
> > > > > > > > +		return err;
> > > > > > > >
> > > > > > > > -	MLX5_SET(query_special_contexts_in, in, opcode,
> > > > > > > > -		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> > > > > > > > -	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> > > > > > > > -	if (!err)
> > > > > > > > -		*null_mkey = MLX5_GET(query_special_contexts_out, out,
> > > > > > > > -				      null_mkey);
> > > > > > > > -	return err;
> > > > > > > > +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
> > > > > > > > +		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
> > > > > > > > +						     out, dump_fill_mkey);
> > > > > > > > +
> > > > > > > > +	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
> > > > > > > > +		dev->mkeys.null_mkey = cpu_to_be32(
> > > > > > > > +			MLX5_GET(query_special_contexts_out, out, null_mkey));
> > > > > > > > +
> > > > > > > > +	if (MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)) {
> > > > > > > > +		dev->mkeys.terminate_scatter_list_mkey =
> > > > > > > > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > > > > > > > +					     terminate_scatter_list_mkey));
> > > > > > > > +		return 0;
> > > > > > > > +	}
> > > > > > > > +	dev->mkeys.terminate_scatter_list_mkey =
> > > > > > > > +		MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > > > > > >
> > > > > > > This is already stored in the core dev, why are you recalculating it
> > > > > > > here?
> > > > > >
> > > > > > It is not recalculating but setting default value. In core dev, we will
> > > > > > have value only if MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)
> > > > > > is true.
> > > > >
> > > > > No, it has the identical code:
> > > > >
> > > > > +static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
> > > > > +{
> > > > > +       if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
> > > > > +               dev->terminate_scatter_list_mkey =
> > > > > +                       cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > > > > +                                            terminate_scatter_list_mkey));
> > > > > +               return 0;
> > > > > +       }
> > > > > +       dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > > >
> > > > Ahh, you are talking about that.
> > > > terminate_scatter_list_mkey is part of an output from MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS,
> > > > which is needed to get other mkeys. So instead of doing special logic
> > > > for the terminate_scatter_list_mkey, we decided to use same pattern as
> > > > for other mkeys, which don't belong to core.
> > > 
> > > Regardless, don't duplicate the code and maybe don't even duplicate
> > > the storage of the terminate_scatter_list_mkey
> > 
> > ok, will update and resend.
> > 
> 
> Please provide a helper mlx5_get_xyz function, avoid assuming mlx5_core will store
> it in dev->xyz.

This helper was used in this version of patch and it is:
 MLX5_GET(query_special_contexts_out, out, terminate_scatter_list_mkey))
Which was dropped in favor of Jason's request to rely on mlx5_core_dev
as this value already known:
https://lore.kernel.org/all/cover.1672917578.git.leonro@nvidia.com

I don't like the idea to add obfuscation function just for the sake of
obfuscation. If you don't want access to mlx5_core_dev, please argue with
Jason to accept first variant.

Thanks
