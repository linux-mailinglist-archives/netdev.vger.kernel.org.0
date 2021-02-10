Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E993165AC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhBJLv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhBJLtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 06:49:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F14DC64E2A;
        Wed, 10 Feb 2021 11:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612957704;
        bh=7ujan/Y55mB+voeYbBmqMFejxrtzQ5uecRG/+ce1SfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FyTjeDTz69uEJWayNnqbZXSaCsfFp30veQIUibFa3hINVS12fJNqZEBttqI+EfkCy
         poRxBO+XJIYjNQYpYB9MDEg+7hU1YTRt/vqHpQz1BxH1qao6aVDsxzIOUseBVZWl/A
         UeNvjHzASRlD/5ma35SPafCtJ5/UqMVQA+cszISkGojy6c1UTDaqqa10RrLlENo5Wi
         mw9CTLt19WYqXntmPMzsLQ7QilyfvwM/4GupK6JzTaAZ9DVOXfeuK5tyUBtr4Xe4TZ
         kG6WJP+r6E2ZkjwFRUlYHc8IfBT/Qd3I0o8F0ewo/9jecO97NybXnvfOACxTa9GO1I
         9jX9caI4jYsjQ==
Date:   Wed, 10 Feb 2021 13:48:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     vladbu@nvidia.com, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [bug report] net/mlx5e: E-Switch, Maintain vhca_id to vport_num
 mapping
Message-ID: <20210210114820.GA741034@unreal>
References: <YCOep5XDMt5IM/PV@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCOep5XDMt5IM/PV@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:51:51AM +0300, Dan Carpenter wrote:
> Hello Vlad Buslov,
>
> The patch 84ae9c1f29c0: "net/mlx5e: E-Switch, Maintain vhca_id to
> vport_num mapping" from Sep 23, 2020, leads to the following static
> checker warning:
>
> 	drivers/net/ethernet/mellanox/mlx5/core/vport.c:1170 mlx5_vport_get_other_func_cap()
> 	warn: odd binop '0x0 & 0x1'
>
> drivers/net/ethernet/mellanox/mlx5/core/vport.c
>   1168  int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
>   1169  {
>   1170          u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
>
> HCA_CAP_OPMOD_GET_MAX is zero.  The 0x01 is a magical number.
>
>   1171          u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
>   1172
>   1173          MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
>   1174          MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
>   1175          MLX5_SET(query_hca_cap_in, in, function_id, function_id);
>   1176          MLX5_SET(query_hca_cap_in, in, other_function, true);
>   1177          return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
>   1178  }

Dan,

I'm running smatch which is based on 6193b3b71beb ("extra: fix some error pointer handling")
and I don't see this error. Should I run something special?

Thanks

>
> regards,
> dan carpenter
