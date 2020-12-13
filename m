Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB892D8D1C
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgLMMhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgLMMhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 07:37:05 -0500
Date:   Sun, 13 Dec 2020 14:36:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607862984;
        bh=c2ENREK2Z6RKPg4W+FXNpsuhhr5mRMIvLXbZcapkLDg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iruto6bWsuy4pDN4n951xPOZ9E5ZFPOTjKXFZV0qeD8aZlMm9mk21k609JtcoZ2Qz
         vP8TrTHD/3LC/8T6JCdrUfSksvJayPFqJw1lU39TtCQF0oT8+fFqOmf+CMXb++2/qw
         0eATVD2Zp3crDPMSqBbNq8jZCGlHHGltLTXHKIzAUl/S2IXEOcsJRb48xyinDUPUwb
         3b3WjTqZ8Mn7Z89zAq4Fh4ObUNO2U/jDYvDgfGiVQ2Z8PCj60Ik88gbMNH7FtDIk7h
         Dw/K4OKREA0LpU1aGZuX9FwywdDBBxLNGvSkUzNqUHI43SyxEMzuVHQjrHf8rHdwKA
         rnQpllpFvyFug==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Fix compilation warning for 32-bit
 platform
Message-ID: <20201213123620.GC5005@unreal>
References: <20201213120641.216032-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201213120641.216032-1-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 02:06:41PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav@nvidia.com>
>
> MLX5_GENERAL_OBJECT_TYPES types bitfield is 64-bit field.
>
> Defining an enum for such bit fields on 32-bit platform results in below
> warning.
>
> ./include/vdso/bits.h:7:26: warning: left shift count >= width of type [-Wshift-count-overflow]
>                          ^
> ./include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of macro ‘BIT’
>  MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
>                                              ^~~
>
> Use 32-bit friendly BIT_ULL macro.
>
> Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits and structures")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 2006795fd522..8a359b8bee52 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -10709,9 +10709,9 @@ struct mlx5_ifc_affiliated_event_header_bits {
>  };
>
>  enum {
> -	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
> -	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
> -	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
> +	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
> +	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
> +	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),

Or even better is to use "1ULL << 0x20" directly because we are not
including bits.h in this mlx5_ifc.h file.

Should I resend?

Thanks

>  };
>
>  enum {
> --
> 2.29.2
>
