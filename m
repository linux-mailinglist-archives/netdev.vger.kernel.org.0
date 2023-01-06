Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0642B660402
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbjAFQJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbjAFQJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:09:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31F876217;
        Fri,  6 Jan 2023 08:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61895B81D68;
        Fri,  6 Jan 2023 16:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF886C433EF;
        Fri,  6 Jan 2023 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673021376;
        bh=MUEA5P8aUc9cA0WP6rd+wCEMwkUB7jkqwUkSTTU50+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qryNqo57IBPj1BstNTiz1l/XYcGe1XZMnCsIDegK67eKaOVUlOE2WNczmcpPzy5Bk
         pupAbdHSkRxv+xfRSTXBnZu58IJNiyHLr8PPigUyKs5FnnXFioFTM/jW4a+yoKi4cZ
         rIenJ+UuTtQrbt4qq2WiSRLOjlIEjjfO2OMByeOCl5anghu2Lv8haHH/swLhfgIZ6U
         fcNMj1bPa1dP9C1rzM/efcm0y336Qs2zxgVHPHdbqRMnsLMFXTUNaQZcO1BZVN/mK1
         s0dMVWGO8W0bJDOTI77IFc3M3iQnN2NrKHIJSaunQOpIEgylEX5u7x44464vPwfrAj
         FZ9LZK0PUR5Kw==
Date:   Fri, 6 Jan 2023 10:09:40 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Replace 0-length array with flexible array
Message-ID: <Y7hHxKgX24+pGCsI@work>
References: <20230105223642.never.980-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105223642.never.980-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 02:36:43PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct mlx5e_rx_wqe_cyc's
> "data" 0-length array with a flexible array. Detected with GCC 13,
> using -fstrict-flex-arrays=3:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_alloc_rq':
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:827:42: warning: array subscript f is outside array bounds of 'struct mlx5_wqe_data_seg[0]' [-Warray-bounds=]
>   827 |                                 wqe->data[f].byte_count = 0;
>       |                                 ~~~~~~~~~^~~
> In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
>                  from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
>                  from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:42:
> drivers/net/ethernet/mellanox/mlx5/core/en.h:250:39: note: while referencing 'data'
>   250 |         struct mlx5_wqe_data_seg      data[0];
>       |                                       ^~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 2d77fb8a8a01..37cf3b1bb144 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -247,7 +247,7 @@ struct mlx5e_rx_wqe_ll {
>  };
>  
>  struct mlx5e_rx_wqe_cyc {
> -	struct mlx5_wqe_data_seg      data[0];
> +	DECLARE_FLEX_ARRAY(struct mlx5_wqe_data_seg, data);
>  };
>  
>  struct mlx5e_umr_wqe {
> -- 
> 2.34.1
> 
