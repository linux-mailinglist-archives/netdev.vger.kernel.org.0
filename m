Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3611F6633F7
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 23:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbjAIWbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 17:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbjAIWbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 17:31:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B203E1021;
        Mon,  9 Jan 2023 14:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A5661471;
        Mon,  9 Jan 2023 22:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F41C433D2;
        Mon,  9 Jan 2023 22:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673303493;
        bh=Uc5WenqYkqW6dXtYkha+ekpUGsJUKJ8K89nHF7I7Xrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUZ15TgkdqGK+BQJT0GYjUAXfM/ouYw42LvgvGJOlgBI0i8gIJiKqiGbgXDkzyMcF
         c0vPNXlfZoVrf/6x2J7fC87bDJkAK32NL4ABC+PGsDTHIyoi5rbuzjDGrQCiHo+zCa
         cUoRBsAOZMO88QOaJw/Nuy0bUL65i9vxzWnFWYxexWw98sCkFRV1AR0gL1YONlzkbZ
         dIVCl8yj9AFXReRk+gZQRxErBe9X2UmPMKj4N1kW7ycWCBNBGvYqPK1Tf+8GqUr7WZ
         oyVIkmSKk4rT9X9dyYnWnGOf99bUbgGwrvb4qVOe1NlB4GoJAPddkhhSy/NBRmMbvt
         alPOSHdxWedqw==
Date:   Mon, 9 Jan 2023 14:31:32 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Use query_special_contexts for
 mkeys
Message-ID: <Y7yVxD1eNYwx3VT0@x130>
References: <cover.1672819469.git.leonro@nvidia.com>
 <849b3e708a147a3e2fc94277b805f5cc388f16ab.1672819469.git.leonro@nvidia.com>
 <Y7dyLlo3T1ibHMNn@x130>
 <Y7qb1aeuGowalgzs@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y7qb1aeuGowalgzs@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Jan 12:32, Leon Romanovsky wrote:
>On Thu, Jan 05, 2023 at 04:58:22PM -0800, Saeed Mahameed wrote:
>> On 04 Jan 10:11, Leon Romanovsky wrote:
>> > From: Or Har-Toov <ohartoov@nvidia.com>
>> >
>> > Using query_sepcial_contexts in order to get the correct value of
>> > terminate_scatter_list_mkey, as FW will change it in some configurations.
>> > This is done one time when the device is loading and the value is being
>> > saved in the device context.
>> >
>> > Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
>> > Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
>> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> > ---
>> > .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
>> > .../net/ethernet/mellanox/mlx5/core/main.c    | 27 +++++++++++++++++++
>> > include/linux/mlx5/driver.h                   |  1 +
>> > 3 files changed, 29 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> > index c76f15505a76..33d7a7095988 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> > @@ -826,7 +826,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>> > 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
>> > 				wqe->data[f].byte_count = 0;
>> > 				wqe->data[f].lkey =
>> > -					MLX5_TERMINATE_SCATTER_LIST_LKEY;
>> > +					mdev->terminate_scatter_list_mkey;
>> > 				wqe->data[f].addr = 0;
>> > 			}
>> > 		}
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> > index 7f5db13e3550..d39d758744a0 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> > @@ -1221,6 +1221,28 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
>> > 	return 0;
>> > }
>> >
>> > +static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
>> > +{
>> > +	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
>> > +	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
>> > +	int err;
>> > +
>> > +	MLX5_SET(query_special_contexts_in, in, opcode,
>> > +		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
>> > +	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
>>
>> Why did you execute the command unconditionally if the output is only read
>> conditionally?
>>
>> early exit before executing the command, older FW might fail and driver will
>> be unusable ..
>
>According to the documentation, this functionality was forever, but you
>are presenting valid concern.
>
>>
>> > +		dev->terminate_scatter_list_mkey =
>> > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
>> > +					     terminate_scatter_list_mkey));
>> > +		return 0;
>> > +	}
>> > +	dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
>>
>> Another concern, what happens with old driver that is using the hardcoded
>> value with newer fw ? will it fail ? will it be accepted ?
>
>It will be accepted and everything will work without glitches.
>FW keeps backward compatibility and use MLX5_TERMINATE_SCATTER_LIST_LKEY
>internally as a default.
>

Then please don't change mlx5e to use  mdev->terminate_scatter_list_mkey in
this patch, just keep it as is and have a separate patch to change mlx5e.

