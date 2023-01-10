Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774C5663B98
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbjAJIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238107AbjAJIp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:45:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45146EB7;
        Tue, 10 Jan 2023 00:45:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2639B8114D;
        Tue, 10 Jan 2023 08:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E831C433F1;
        Tue, 10 Jan 2023 08:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673340354;
        bh=Qd7OfUMzLWLP8aolCplLMa5FTYXFo5TB9j/xkwox/Ts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PNk72vlFmQNOV8gmbdeAMvx+1FB12nROKpMZ+BsvL5AxmPHR9Dsq/boc5tnwP5R6w
         kuNzMvp9YADQ1qL/0M+OaAQbgdgHlz1+JLPifwl5gi6XxX7xf1ZpSZG12Ub+p90yuY
         qvRbszU8f5UTh52mUfGNhGlk4pZUXsmU5G7QSGvgXLsCp1C8lXebiJZ1WEX1/+GqBc
         hHJd3npiZNuW/e7UFWil6LFGXj3pJ4cINJbuhf+gIKun9z//wO8eCljcWJfVEn54EL
         rZTtKEacUca8LCrckPha43cAwP0gXQPeGEaDh1gUJt0skfzD+V43Kv8GYsQShQ1aa4
         mRFOqv9SjGuTA==
Date:   Tue, 10 Jan 2023 10:45:49 +0200
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
Message-ID: <Y70lvUCHeHhNnneq@unreal>
References: <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
 <Y7V5CtJmorEc4u93@nvidia.com>
 <Y7V6otdhR5vJ1nPy@unreal>
 <Y7V7Zmnldy81lRIO@nvidia.com>
 <Y7WFTULBGZ1WczxV@unreal>
 <Y7WFhXk6UhGulLKi@nvidia.com>
 <Y7WHFm7b7N/Y+HpS@unreal>
 <Y7dzg/4MAMSmOR1o@x130>
 <Y7qZLFBUTMIoCa/j@unreal>
 <Y7yUHJukwiIcL5BJ@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7yUHJukwiIcL5BJ@x130>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 02:24:28PM -0800, Saeed Mahameed wrote:
> On 08 Jan 12:21, Leon Romanovsky wrote:
> > On Thu, Jan 05, 2023 at 05:04:03PM -0800, Saeed Mahameed wrote:
> > > On 04 Jan 16:03, Leon Romanovsky wrote:
> > > > On Wed, Jan 04, 2023 at 09:56:21AM -0400, Jason Gunthorpe wrote:
> > > > > On Wed, Jan 04, 2023 at 03:55:25PM +0200, Leon Romanovsky wrote:
> > > > > > On Wed, Jan 04, 2023 at 09:13:10AM -0400, Jason Gunthorpe wrote:
> > > > > > > On Wed, Jan 04, 2023 at 03:09:54PM +0200, Leon Romanovsky wrote:
> > > > > > > > On Wed, Jan 04, 2023 at 09:03:06AM -0400, Jason Gunthorpe wrote:
> > > > > > > > > On Wed, Jan 04, 2023 at 10:11:25AM +0200, Leon Romanovsky wrote:
> > > > > > > > > > -int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
> > > > > > > > > > -{
> > > > > > > > > > -	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> > > > > > > > > > -	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> > > > > > > > > > -	int err;
> > > > > > > > > > +	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
> > > > > > > > > > +	if (err)
> > > > > > > > > > +		return err;
> > > > > > > > > >
> > > > > > > > > > -	MLX5_SET(query_special_contexts_in, in, opcode,
> > > > > > > > > > -		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> > > > > > > > > > -	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> > > > > > > > > > -	if (!err)
> > > > > > > > > > -		*null_mkey = MLX5_GET(query_special_contexts_out, out,
> > > > > > > > > > -				      null_mkey);
> > > > > > > > > > -	return err;
> > > > > > > > > > +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
> > > > > > > > > > +		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
> > > > > > > > > > +						     out, dump_fill_mkey);
> > > > > > > > > > +
> > > > > > > > > > +	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
> > > > > > > > > > +		dev->mkeys.null_mkey = cpu_to_be32(
> > > > > > > > > > +			MLX5_GET(query_special_contexts_out, out, null_mkey));
> > > > > > > > > > +
> > > > > > > > > > +	if (MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)) {
> > > > > > > > > > +		dev->mkeys.terminate_scatter_list_mkey =
> > > > > > > > > > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > > > > > > > > > +					     terminate_scatter_list_mkey));
> > > > > > > > > > +		return 0;
> > > > > > > > > > +	}
> > > > > > > > > > +	dev->mkeys.terminate_scatter_list_mkey =
> > > > > > > > > > +		MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > > > > > > > >
> > > > > > > > > This is already stored in the core dev, why are you recalculating it
> > > > > > > > > here?
> > > > > > > >
> > > > > > > > It is not recalculating but setting default value. In core dev, we will
> > > > > > > > have value only if MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)
> > > > > > > > is true.
> > > > > > >
> > > > > > > No, it has the identical code:
> > > > > > >
> > > > > > > +static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
> > > > > > > +{
> > > > > > > +       if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
> > > > > > > +               dev->terminate_scatter_list_mkey =
> > > > > > > +                       cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > > > > > > +                                            terminate_scatter_list_mkey));
> > > > > > > +               return 0;
> > > > > > > +       }
> > > > > > > +       dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > > > > >
> > > > > > Ahh, you are talking about that.
> > > > > > terminate_scatter_list_mkey is part of an output from MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS,
> > > > > > which is needed to get other mkeys. So instead of doing special logic
> > > > > > for the terminate_scatter_list_mkey, we decided to use same pattern as
> > > > > > for other mkeys, which don't belong to core.
> > > > >
> > > > > Regardless, don't duplicate the code and maybe don't even duplicate
> > > > > the storage of the terminate_scatter_list_mkey
> > > >
> > > > ok, will update and resend.
> > > >
> > > 
> > > Please provide a helper mlx5_get_xyz function, avoid assuming mlx5_core will store
> > > it in dev->xyz.
> > 
> > This helper was used in this version of patch and it is:
> > MLX5_GET(query_special_contexts_out, out, terminate_scatter_list_mkey))
> > Which was dropped in favor of Jason's request to rely on mlx5_core_dev
> > as this value already known:
> > https://lore.kernel.org/all/cover.1672917578.git.leonro@nvidia.com
> > 
> > I don't like the idea to add obfuscation function just for the sake of
> > obfuscation. If you don't want access to mlx5_core_dev, please argue with
> > Jason to accept first variant.
> 
> I think you are confused, 1st version duplicated the logic that already
> existed in mlx5 core, didn't just access with MLX5_GET.

No, the end result is the same: call to the memory to get terminate_scatter_list_mkey
value. MLX5_GET(..) will return exactly the same value as dev->terminate_scatter_list_mkey
or some other function call:

int mlx5_get_terminate_scatter_list_mkey() {
 return dev->terminate_scatter_list_mkey;
}

> 
> 
