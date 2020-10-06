Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A295E2854E5
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 01:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgJFXVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 19:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJFXU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 19:20:59 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B44D7208C7;
        Tue,  6 Oct 2020 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602026459;
        bh=7jpBLJCbErIbBdEySBbudikYYK8NonWObYz/Np8x4zw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cm/LmKlSvkVACPdYjr3MV9K6dNZbQGnPjX6h1YUH1XFLTUCMpeSOmDfE6tdtDowF4
         ddhiwp3VIqsbLGcey2ZCLtm8dfY2oLRTjHwlF9jQq2N8STZGu9sg7mkBTigRkgV2L9
         Au4vK8t6kuS+WurDQKewmY9lFfcWUHQPfww0wTH8=
Message-ID: <bc6d5d6ad5b3254d8e14997341995036f56e374d.camel@kernel.org>
Subject: Re: [PATCH][next] net/mlx5: Fix uininitialized pointer read on
 pointer attr
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin King <colin.king@canonical.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Oct 2020 16:20:57 -0700
In-Reply-To: <20201006181243.546661-1-colin.king@canonical.com>
References: <20201006181243.546661-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 19:12 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the error exit path err_free kfree's attr. In the case
> where
> flow and parse_attr failed to be allocated this return path will free
> the uninitialized pointer attr, which is not correct.  In the other
> case where attr fails to allocate attr does not need to be freed. So
> in both error exits via err_free attr should not be freed, so remove
> it.
> 
> Addresses-Coverity: ("Uninitialized pointer read")
> Fixes: ff7ea04ad579 ("net/mlx5e: Fix potential null pointer
> dereference")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index a0c356987e1a..e3a968e9e2a0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -4569,7 +4569,6 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int
> attr_size,
>  err_free:
>  	kfree(flow);
>  	kvfree(parse_attr);
> -	kfree(attr);
>  	return err;
>  }
>  

Applied to net-next-mlx5,

Thanks.

