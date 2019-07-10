Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F08F96409D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGJFWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfGJFWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 01:22:24 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9141A20665;
        Wed, 10 Jul 2019 05:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562736143;
        bh=yG9MOOky9cIIKLWWBpb40bH8p8EqcI4EC3OhoeA5xYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dhrijKo73nXgq0AeyoQfoW2qeSTr20RagZelBGmapoJcaiUKziOWhAWgwpd6b6+0Y
         L7u3fZpD99BFkV/DQHkAItENtRZaJ+rnaXAOZH6tmX3dcKyaS9OEZE27Cwe+wFbymf
         dL8zzhTH9O1NOcMPU+PCHuLkwEKnY5IWxdO5zSEg=
Date:   Wed, 10 Jul 2019 08:22:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2] net/mlx5e: Refactor switch statements to avoid using
 uninitialized variables
Message-ID: <20190710052219.GC7034@mtr-leonro.mtl.com>
References: <20190708231154.89969-1-natechancellor@gmail.com>
 <20190710044748.3924-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710044748.3924-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 09:47:49PM -0700, Nathan Chancellor wrote:
> clang warns:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2:
> warning: variable 'rec_seq_sz' is used uninitialized whenever switch
> default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note:
> uninitialized use occurs here
>         skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
>                                                     ^~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:239:16: note:
> initialize the variable 'rec_seq_sz' to silence this warning
>         u16 rec_seq_sz;
>                       ^
>                        = 0
> 1 warning generated.
>
> The default case statement should return in tx_post_resync_params like
> in fill_static_params_ctx. However, as Nick and Leon point out, the
> switch statements converted into if statements to clean up the code a
> bit since there is only one cipher supported. Do that to clear up the
> code.
>
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/590
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> v1 -> v2:
>
> * Refactor switch statements into if statements
>
>  .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 33 +++++++------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
