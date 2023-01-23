Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ECB67757F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 08:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjAWHUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 02:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjAWHUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 02:20:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0896383EF
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 23:20:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8954260DBE
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD65C433D2;
        Mon, 23 Jan 2023 07:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674458432;
        bh=50uwuJt3dOekdXeoCWQ+GuTXd5+iOQQLaunfkFobjwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fsAnUXxzw3biW+tWzgTttwU70czrHy6VsFWmyXLnsryjKuylnWM2pFtQeDmFj9gGI
         h9Pl2DClTgXTyg1PmZgukRxte81zlB6ISNzBTtN+dhnmGMNz/ydXAkQL9trltTrrFD
         KpltO+wLNTTc6vasqWp2QYw4GXF5efkCwjDGuX9wQ3WsP8JYN9g13FQnsWlDxgCnxj
         bxEfI6g4037fS5gwX0h8tr51zcKIXUFmgZfD0vaylaCOI/5kgokgdpZ7bZOv7m7zA7
         ly7zLunR32MqDYfl/+cjHhxu2eoN1YZjZ8dmOoc5gmHiTfYUwMPYBNQyavChl1zLJo
         NJT6dojpo91Nw==
Date:   Mon, 23 Jan 2023 09:20:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Message-ID: <Y841PJnZiF0WfoBn@unreal>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122161602.1958577-2-vadfed@meta.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 08:16:01AM -0800, Vadim Fedorenko wrote:
> Fifo pointers are not checked for overflow and this could potentially
> lead to overflow and double free under heavy PTP traffic.
> 
> Also there were accidental OOO cqe which lead to absolutely broken fifo.
> Add checks to workaround OOO cqe and add counters to show the amount of
> such events.
> 
> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
>  4 files changed, 30 insertions(+), 8 deletions(-)

<...>

> @@ -291,12 +291,16 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
>  {
>  	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>  
> +	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "%s overflow", __func__);

nit, ""%s overflow", __func__" is not needed as call trace already includes function name.

Thanks
