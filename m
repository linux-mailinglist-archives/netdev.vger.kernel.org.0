Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C71187451
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgCPU4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:56:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40070 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPU4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 16:56:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so10606347pfl.7
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 13:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NZ/7vQHI7KE97BesE+3WxlmFuT1Y/pVRDjy/XH5FkC0=;
        b=sp8cn/ioOKcQrBGgpv/MwvdbUYmqLpY3kwI0x736FzBzMjDBs+K3pg5UUG1Q1DCeI5
         1zn/f5brLanFHqo0Pi0PlKHd5FTKycUoSSyfxNbIRzD0Gm8PrzXSWOP/yv1NXIywvuWV
         NvWUdv8eYUpXPvoGC6Q7n8PkYcU1IOx3Ty8eAJPkTabAUsLDTP0BN+QnS2rYduD9ixFa
         x8DTDXw1Y8QHmn3HdSK2F61wnQzHBQBCPgkC9kZDUmTWVrr3qd+cK8dXytoA6SleFib7
         dNliIlDgmEDxwl4YuOOZ5bVeMwLMEEXEedpVexup+LT/AAjgdd16EmutVUrhVjABss71
         cTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZ/7vQHI7KE97BesE+3WxlmFuT1Y/pVRDjy/XH5FkC0=;
        b=CuJRrA9wRoq6NVdjEJX2is6L1G6W1jEN7PcNN7eDCnhRMQmgJh7smTnNPwpNWAGbIV
         BhQUDqoOywJyF0OIC/kCX32ut+8L/0+nWpjH/UX5w72vG6ZnNuta/h4eYNgYBA8TpbDC
         OP0IjGaeTK4+JmQJrjyOTQxq/okkwwwaF2FsGYZa34T8KeTXEUseivr/KyqyeFRaHY72
         2zyyh+eyu5thXhSuL1JbcYiZ05UdeCwL606iqlFCKXOufiE0dTFaVouMZ0Z3vJdrBUun
         uJhcZfBlGkTJi95KExwbyyVp7EQAMt0pKEwiSIZTCxQ2FPFTISTR2ifk76aBieAW8ZvY
         pxpA==
X-Gm-Message-State: ANhLgQ3oAXBTGTjWKEbovMOBmLbXoSL/MsioWNa9Qe0cUfzF3lfrdIM5
        ErmiLqG2BaI04GuVyK3NzeTueJghThWM/EGAuf8lDw==
X-Google-Smtp-Source: ADFU+vuCQ97q6HcYQkHwhQj8C1S5Oa2alEBysaM6RamyvELgnI7a1zylhDyl+jjS4YkMyCE133hnoh3bBFYURu9FD5U=
X-Received: by 2002:a05:6a00:42:: with SMTP id i2mr1554887pfk.108.1584392167596;
 Mon, 16 Mar 2020 13:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200316203452.32998-1-natechancellor@gmail.com>
In-Reply-To: <20200316203452.32998-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 16 Mar 2020 13:55:55 -0700
Message-ID: <CAKwvOdkDUYYm9ZoTeKt-5kGhDTxo6w2XhOjONWhzh6M4rE5LpA@mail.gmail.com>
Subject: Re: [PATCH] mlx5: Remove uninitialized use of key in mlx5_core_create_mkey
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 1:35 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> ../drivers/net/ethernet/mellanox/mlx5/core/mr.c:63:21: warning: variable
> 'key' is uninitialized when used here [-Wuninitialized]
>                       mkey_index, key, mkey->key);
>                                   ^~~
> ../drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h:54:6: note:
> expanded from macro 'mlx5_core_dbg'
>                  ##__VA_ARGS__)
>                    ^~~~~~~~~~~
> ../include/linux/dev_printk.h:114:39: note: expanded from macro
> 'dev_dbg'
>         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                                              ^~~~~~~~~~~
> ../include/linux/dynamic_debug.h:158:19: note: expanded from macro
> 'dynamic_dev_dbg'
>                            dev, fmt, ##__VA_ARGS__)
>                                        ^~~~~~~~~~~
> ../include/linux/dynamic_debug.h:143:56: note: expanded from macro
> '_dynamic_func_call'
>         __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
>                                                               ^~~~~~~~~~~
> ../include/linux/dynamic_debug.h:125:15: note: expanded from macro
> '__dynamic_func_call'
>                 func(&id, ##__VA_ARGS__);               \
>                             ^~~~~~~~~~~
> ../drivers/net/ethernet/mellanox/mlx5/core/mr.c:47:8: note: initialize
> the variable 'key' to silence this warning
>         u8 key;
>               ^
>                = '\0'
> 1 warning generated.
>
> key's initialization was removed in commit fc6a9f86f08a ("{IB,net}/mlx5:
> Assign mkey variant in mlx5_ib only") but its use was not fully removed.
> Remove it now so that there is no more warning.
>
> Fixes: fc6a9f86f08a ("{IB,net}/mlx5: Assign mkey variant in mlx5_ib only")
> Link: https://github.com/ClangBuiltLinux/linux/issues/932
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch and analysis, looks good to me!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/mr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> index fd3e6d217c3b..366f2cbfc6db 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> @@ -44,7 +44,6 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
>         u32 mkey_index;
>         void *mkc;
>         int err;
> -       u8 key;
>
>         MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
>
> @@ -59,8 +58,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
>         mkey->key |= mlx5_idx_to_mkey(mkey_index);
>         mkey->pd = MLX5_GET(mkc, mkc, pd);
>
> -       mlx5_core_dbg(dev, "out 0x%x, key 0x%x, mkey 0x%x\n",
> -                     mkey_index, key, mkey->key);
> +       mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index, mkey->key);
>         return 0;
>  }
>  EXPORT_SYMBOL(mlx5_core_create_mkey);
> --
> 2.26.0.rc1
>
> --

-- 
Thanks,
~Nick Desaulniers
