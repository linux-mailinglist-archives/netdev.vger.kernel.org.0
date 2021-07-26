Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D180F3D69C2
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhGZWGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhGZWGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 18:06:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AD13603E9;
        Mon, 26 Jul 2021 22:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627339634;
        bh=trEsuabCrNaLtPNKLEQphyWCS2PXXyOTtPDqemYONl4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WMiK671EqPUwZpQi0BpTAw16T+RdsU66+Ie/ECzNC+Cxl1eDk4QRtRyM4XqxZiCKw
         VmOnVSjeXnJzu/m7evKrkADZF7zHKlvY3OSMTU6hQeIVPwThmYdhN5Q/sxsTVtBufL
         a5BefCobniFM91s2j4QiQbPyArUiCSRMh58u2GEY5ogcYpE4LlPwOKBFQlWMgikSTt
         ZLxzjaeEnVN5RPCxzFopguYY+e4tIuY6/pre7l/GvWMpk+A3hr9entQCpO7T3qhiVP
         /r1oGsO3Alwk8y0B4wEmEuAj/xXxjx4R412v0b4u65yDjQph/wZOPSfwUtHIR8Sudt
         6J2bUJrxauBxQ==
Message-ID: <b323f3f6aac2139d5160b1bffae0c2b839a16b5b.camel@kernel.org>
Subject: Re: [PATCH v2] net/mlx5: Fix missing return value in
 mlx5_devlink_eswitch_inline_mode_set()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 26 Jul 2021 15:47:13 -0700
In-Reply-To: <1626947897-73558-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1626947897-73558-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-22 at 17:58 +0800, Jiapeng Chong wrote:
> The return value is missing in this code scenario, add the return
> value
> '0' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
> mlx5_devlink_eswitch_inline_mode_set() warn: missing error code
> 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode
> changes")
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   -For the follow advice:
> https://lore.kernel.org/patchwork/patch/1461601/
> 
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git
> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 7579f34..6b0b629 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3079,8 +3079,11 @@ int
> mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8
> mode,
>  
>         switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
>         case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
> -               if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
> +               if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE) {
> +                       err = 0;

Although err is already 0 at this point even before this patch,
otherwise the function would've aborted earlier, I will apply this to
net-next-mlx5, since I like the explicit return value here as it shows
the real intention of the code.
but smatch needs to be investigated.

Applied to net-next-mlx5, 
Thanks.

>                         goto out;
> +               }
> +
>                 fallthrough;
>         case MLX5_CAP_INLINE_MODE_L2:
>                 NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be
> set");



