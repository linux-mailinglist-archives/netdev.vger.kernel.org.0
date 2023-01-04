Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDA65D3EA
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbjADNMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239342AbjADNLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:11:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF06139FA2;
        Wed,  4 Jan 2023 05:10:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 006CCB8166B;
        Wed,  4 Jan 2023 13:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A9EC433D2;
        Wed,  4 Jan 2023 13:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672837798;
        bh=uXDIxDVJc1n3JZGzA1HHV00snaOK3Trd96VgdE7aBL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PIGhKlnzdLjkkuq5Hdw5qPVdWvib9onGYaCosOARRczor/Ipstr+LQmkEZOURZn8w
         Ft2ffUI+X3lB6IPjihydZNepkGvc1+yeaurqPOmG64ymkHJujwaa2pdepOtKTw+qhE
         HD1OlmpzvWaXoJZLu821sqYEymaNQPgul7YO1or1VMEnhpDIWViPChJbqAJ7DMKksR
         i/Eorc3qbeOBV/UtT5xBYWwYk08or/0bdwK07vLfbvHb81FNaoSMskTA1sL7PD+qwE
         SGq6nMaA8rXKg+6hsref5biZPCOSFpq7TtQbY/oRFknJdk1ScjUPq4NfvVpHLusTVp
         k2YDyaQKp5nOA==
Date:   Wed, 4 Jan 2023 15:09:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 4/4] RDMA/mlx5: Use query_special_contexts for
 mkeys
Message-ID: <Y7V6otdhR5vJ1nPy@unreal>
References: <cover.1672819469.git.leonro@nvidia.com>
 <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
 <Y7V5CtJmorEc4u93@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7V5CtJmorEc4u93@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 09:03:06AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 04, 2023 at 10:11:25AM +0200, Leon Romanovsky wrote:
> > -int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
> > -{
> > -	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> > -	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> > -	int err;
> > +	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
> > +	if (err)
> > +		return err;
> >  
> > -	MLX5_SET(query_special_contexts_in, in, opcode,
> > -		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> > -	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> > -	if (!err)
> > -		*null_mkey = MLX5_GET(query_special_contexts_out, out,
> > -				      null_mkey);
> > -	return err;
> > +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
> > +		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
> > +						     out, dump_fill_mkey);
> > +
> > +	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
> > +		dev->mkeys.null_mkey = cpu_to_be32(
> > +			MLX5_GET(query_special_contexts_out, out, null_mkey));
> > +
> > +	if (MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)) {
> > +		dev->mkeys.terminate_scatter_list_mkey =
> > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > +					     terminate_scatter_list_mkey));
> > +		return 0;
> > +	}
> > +	dev->mkeys.terminate_scatter_list_mkey =
> > +		MLX5_TERMINATE_SCATTER_LIST_LKEY;
> 
> This is already stored in the core dev, why are you recalculating it
> here?

It is not recalculating but setting default value. In core dev, we will
have value only if MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)
is true.

Thanks

> 
> Jason
