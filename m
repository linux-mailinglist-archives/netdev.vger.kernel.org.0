Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A8B5FAD4C
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 09:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJKHRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 03:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJKHRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 03:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D8B844E8;
        Tue, 11 Oct 2022 00:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF686112B;
        Tue, 11 Oct 2022 07:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AF5C433D6;
        Tue, 11 Oct 2022 07:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665472671;
        bh=NtJ7v6/G5QEm210bmOM52lM9FGXyvCrH5npEMhuG5dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZspTNQUzoy4rlvEmPdqABsDYMXx//z2uDjqx8J9ToecczBNWoAdoBSRSmnd3neig
         e613vwQsA5jex30GWEuIxAO5X5weH2GoJ0gzVhD5XhLyA6BIPlArOquIJu0mUibf10
         Gfai9jHxLkER3HNDkwsiRyfGUWQ4RgwnskrrF80tAlWdAqdO3LBbhxhQWcYU/WAMxG
         SmoZr6rHHnXAXAteB40ug7blDmk9V2RBdB71rKX2sOwmJ4IITPMqlWSV8dj68hRlo+
         k/nYLjgTrKkLbRNjO5JTIMEgDvjt19r6nryXjo1MArjYHDM0zpH3dFuMqojJtUNaXJ
         Ortwe82NIAAkA==
Date:   Tue, 11 Oct 2022 10:17:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Rohit Nair <rohit.sajan.kumar@oracle.com>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, manjunath.b.patil@oracle.com,
        rama.nichanamatlu@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: Re: [PATCH 1/1] IB/mlx5: Add a signature check to received EQEs and
 CQEs
Message-ID: <Y0UYml07lb1I38MQ@unreal>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to ping anyone, the patch is registered in patchworks
https://patchwork.kernel.org/project/linux-rdma/patch/20221005174521.63619-1-rohit.sajan.kumar@oracle.com/
and we will get to it.

You sent the patch during merge window, no wonder that none looked on it.

On Wed, Oct 05, 2022 at 10:45:20AM -0700, Rohit Nair wrote:
> As PRM defines, the bytewise XOR of the EQE and the EQE index should be
> 0xff. Otherwise, we can assume we have a corrupt EQE. The same is
> applicable to CQE as well.

I didn't find anything like this in my version of PRM.

> 
> Adding a check to verify the EQE and CQE is valid in that aspect and if
> not, dump the CQE and EQE to dmesg to be inspected.

While it is nice to see prints in dmesg, you need to explain why other
mechanisms (reporters, mlx5 events, e.t.c) are not enough.

> 
> This patch does not introduce any significant performance degradations
> and has been tested using qperf.

What does it mean? You made changes in kernel verbs flow, they are not
executed through qperf.

> 
> Suggested-by: Michael Guralnik <michaelgur@nvidia.com>
> Signed-off-by: Rohit Nair <rohit.sajan.kumar@oracle.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c              | 40 ++++++++++++++++++++++++++++
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 39 +++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index be189e0..2a6d722 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -441,6 +441,44 @@ static void mlx5_ib_poll_sw_comp(struct mlx5_ib_cq *cq, int num_entries,
>  	}
>  }
>  
> +static void verify_cqe(struct mlx5_cqe64 *cqe64, struct mlx5_ib_cq *cq)
> +{
> +	int i = 0;
> +	u64 temp_xor = 0;
> +	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
> +
> +	u32 cons_index = cq->mcq.cons_index;
> +	u64 *eight_byte_raw_cqe = (u64 *)cqe64;
> +	u8 *temp_bytewise_xor = (u8 *)(&temp_xor);
> +	u8 cqe_bytewise_xor = (cons_index & 0xff) ^
> +				((cons_index & 0xff00) >> 8) ^
> +				((cons_index & 0xff0000) >> 16);
> +
> +	for (i = 0; i < sizeof(struct mlx5_cqe64); i += 8) {
> +		temp_xor ^= *eight_byte_raw_cqe;
> +		eight_byte_raw_cqe++;
> +	}
> +
> +	for (i = 0; i < (sizeof(u64)); i++) {
> +		cqe_bytewise_xor ^= *temp_bytewise_xor;
> +		temp_bytewise_xor++;
> +	}
> +
> +	if (cqe_bytewise_xor == 0xff)
> +		return;
> +
> +	dev_err(&dev->mdev->pdev->dev,
> +		"Faulty CQE - checksum failure: cqe=0x%x cqn=0x%x cqe_bytewise_xor=0x%x\n",
> +		cq->ibcq.cqe, cq->mcq.cqn, cqe_bytewise_xor);
> +	dev_err(&dev->mdev->pdev->dev,
> +		"cons_index=%u arm_sn=%u irqn=%u cqe_size=0x%x\n",
> +		cq->mcq.cons_index, cq->mcq.arm_sn, cq->mcq.irqn, cq->mcq.cqe_sz);

mlx5_err ... and not dev_err ...

> +
> +	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET,
> +		       16, 1, cqe64, sizeof(*cqe64), false);
> +	BUG();

No BUG() in new code.

Thanks
