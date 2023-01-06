Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281EC66040B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbjAFQMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbjAFQMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:12:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E940F3225F;
        Fri,  6 Jan 2023 08:12:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2950B81C48;
        Fri,  6 Jan 2023 16:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E16C433F0;
        Fri,  6 Jan 2023 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673021559;
        bh=d+IS0UN4ZSAffMlwGmeTMowayqSMiw0tGirs4J36qaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UuhiSQBWy4c/P+Po6LKtVKtT3EkOd+24eEUe3Rgbz67oKs8yULtWTwhRZ0C52gdDP
         FwHaxIbXF5Jh2jN8HPFh73dnwIQoBh/HZXfBiYeHmCDcOcXrQD93WFva7TZVVC1aQM
         hBDC2ApuhuVAtcGLdZ2A48cEO/yWzPwmASSBbiqI2Tfs2d1kXqmPtYWkBXec+R5Lu5
         LBf7JnD8r76bT2dKadgXp5DxFEijWLIz/zTO9ZHW2HA3FfpLhxFGxfKmi1rbSiO60H
         1bMj19Imr8oQNu1D9BeW1xoVv5BDVbJhFryd/apb2Bx24oPHyDL8EOzis2xLa04Hjh
         LUQZShlBiPosQ==
Date:   Fri, 6 Jan 2023 10:12:44 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_router: Replace 0-length array with
 flexible array
Message-ID: <Y7hIfF8uyU59/94l@work>
References: <20230105232224.never.150-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105232224.never.150-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 03:22:29PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct
> mlxsw_sp_nexthop_group_info's "nexthops" 0-length array with a flexible
> array. Detected with GCC 13, using -fstrict-flex-arrays=3:
> 
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c: In function 'mlxsw_sp_nexthop_group_hash_obj':
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3278:38: warning: array subscript i is outside array bounds of 'struct mlxsw_sp_nexthop[0]' [-Warray-bounds=]
>  3278 |                         val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
>       |                                      ^~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:2954:33: note: while referencing 'nexthops'
>  2954 |         struct mlxsw_sp_nexthop nexthops[0];
>       |                                 ^~~~~~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index c22c3ac4e2a1..09e32778b012 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -2951,7 +2951,7 @@ struct mlxsw_sp_nexthop_group_info {
>  	   gateway:1, /* routes using the group use a gateway */
>  	   is_resilient:1;
>  	struct list_head list; /* member in nh_res_grp_list */
> -	struct mlxsw_sp_nexthop nexthops[0];
> +	struct mlxsw_sp_nexthop nexthops[];
>  #define nh_rif	nexthops[0].rif
>  };
>  
> -- 
> 2.34.1
> 
