Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AAA3E319D
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbhHFWSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230287AbhHFWSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 784F361181;
        Fri,  6 Aug 2021 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628288277;
        bh=uNwLDC0zzFEjsIANnSLlfVSs/ruzuY8EKIGw7CfINHg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UJGz6msjZYbcA5yPeAoDljc9W+ZzLQdLISN3A/HR9e1u/Un7rNJYIcrULIdaWlW+8
         sPNb3241biuG97ELaOmAaeXjW69Zr+PD7Jqshfui4FCV9wJdhzhn2u3zGWRXaaypdP
         9/7DyxodaEkdXXygMVVSsE7jpPOB5HZ8YMsvzDdB+xTWGg9RxB5+4vGJc/pU97ficA
         qp7J3sgo0uNYg8ccdp1u/FNaR8kKucjgMeGl7gKTv+Me/JqVPj06DzdDTrPmgE+6Yz
         Tew4cgTHPv0yNntw8Voan3ZM/i0WKFue/1c6RqlNLeuCL+gaTaXDyBGYm2TEv1D9pO
         5V2cDpINP1tXw==
Message-ID: <920853c06192a4f5cadf59c90b1510411b197a5e.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Avoid field-overflowing memcpy()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Fri, 06 Aug 2021 15:17:56 -0700
In-Reply-To: <20210806215003.2874554-1-keescook@chromium.org>
References: <20210806215003.2874554-1-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-06 at 14:50 -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-
> time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use flexible arrays instead of zero-element arrays (which look like
> they
> are always overflowing) and split the cross-field memcpy() into two
> halves
> that can be appropriately bounds-checked by the compiler.
> 
> We were doing:
> 
>         #define ETH_HLEN  14
>         #define VLAN_HLEN  4
>         ...
>         #define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
>         ...
>         struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(wq, pi);
>         ...
>         struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
>         struct mlx5_wqe_data_seg *dseg = wqe->data;
>         ...
>         memcpy(eseg->inline_hdr.start, xdptxd->data,
> MLX5E_XDP_MIN_INLINE);
> 
> target is wqe->eth.inline_hdr.start (which the compiler sees as being
> 2 bytes in size), but copying 18, intending to write across start
> (really vlan_tci, 2 bytes). The remaining 16 bytes get written into
> wqe->data[0], covering byte_count (4 bytes), lkey (4 bytes), and addr
> (8 bytes).
> 
> struct mlx5e_tx_wqe {
>         struct mlx5_wqe_ctrl_seg   ctrl;                 /*     0   
> 16 */
>         struct mlx5_wqe_eth_seg    eth;                  /*    16   
> 16 */
>         struct mlx5_wqe_data_seg   data[];               /*    32    
> 0 */
> 
>         /* size: 32, cachelines: 1, members: 3 */
>         /* last cacheline: 32 bytes */
> };
> 
> struct mlx5_wqe_eth_seg {
>         u8                         swp_outer_l4_offset;  /*     0    
> 1 */
>         u8                         swp_outer_l3_offset;  /*     1    
> 1 */
>         u8                         swp_inner_l4_offset;  /*     2    
> 1 */
>         u8                         swp_inner_l3_offset;  /*     3    
> 1 */
>         u8                         cs_flags;             /*     4    
> 1 */
>         u8                         swp_flags;            /*     5    
> 1 */
>         __be16                     mss;                  /*     6    
> 2 */
>         __be32                     flow_table_metadata;  /*     8    
> 4 */
>         union {
>                 struct {
>                         __be16     sz;                   /*    12    
> 2 */
>                         u8         start[2];             /*    14    
> 2 */
>                 } inline_hdr;                            /*    12    
> 4 */
>                 struct {
>                         __be16     type;                 /*    12    
> 2 */
>                         __be16     vlan_tci;             /*    14    
> 2 */
>                 } insert;                                /*    12    
> 4 */
>                 __be32             trailer;              /*    12    
> 4 */
>         };                                               /*    12    
> 4 */
> 
>         /* size: 16, cachelines: 1, members: 9 */
>         /* last cacheline: 16 bytes */
> };
> 
> struct mlx5_wqe_data_seg {
>         __be32                     byte_count;           /*     0    
> 4 */
>         __be32                     lkey;                 /*     4    
> 4 */
>         __be64                     addr;                 /*     8    
> 8 */
> 
>         /* size: 16, cachelines: 1, members: 3 */
>         /* last cacheline: 16 bytes */
> };
> 
> So, split the memcpy() so the compiler can reason about the buffer
> sizes.
> 
> "pahole" shows no size nor member offset changes to struct
> mlx5e_tx_wqe
> nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
> code changes (i.e. only source line number induced differences and
> optimizations).
> 
> 

spiting the memcpy doesn't induce any performance degradation ? extra
instruction to copy the 1st 2 bytes ? 


[...]
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c

why only here ? mlx5 has at least 3 other places where we use this
unbound memcpy .. 

> @@ -341,8 +341,10 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
> struct mlx5e_xmit_data *xdptxd,
>  
>         /* copy the inline part if required */
>         if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
> -               memcpy(eseg->inline_hdr.start, xdptxd->data,
> MLX5E_XDP_MIN_INLINE);
> +               memcpy(eseg->inline_hdr.start, xdptxd->data,
> sizeof(eseg->inline_hdr.start));
>                 eseg->inline_hdr.sz =
> cpu_to_be16(MLX5E_XDP_MIN_INLINE);
> +               memcpy(dseg, xdptxd->data + sizeof(eseg-
> >inline_hdr.start),
> +                      MLX5E_XDP_MIN_INLINE - sizeof(eseg-
> >inline_hdr.start));
>                 dma_len  -= MLX5E_XDP_MIN_INLINE;
>                 dma_addr += MLX5E_XDP_MIN_INLINE;
>                 dseg++;


