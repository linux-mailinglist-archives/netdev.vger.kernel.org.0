Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FC4516ED7
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 13:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbiEBL1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 07:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240138AbiEBL1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 07:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F339812AD1;
        Mon,  2 May 2022 04:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F32D61295;
        Mon,  2 May 2022 11:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE60C385AC;
        Mon,  2 May 2022 11:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651490655;
        bh=3rC3anycQ5NTAPt0xyG0svDSUTj2eAbnPYyw7sMYy10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p+6JHnX5dGTACClMv5uKBbQoh9WMnQUBX5aSprL4XqdFkyP9dr8J6YZs7EAYV1Fvc
         TqM9/VoIcgX2StDa0mFxyiRnz/4PlLTngyG+FD+2NsGdigtqJRVY8+cLqMpvHOKyi6
         ZPXkT1sB+cY3n3MqKUMVcBGVQM9LRU4AKMaXFVPdfV478UFHaTc6tbnAuFM/XFm09w
         0WkJbL5WKRYdZIkEL88nhr38TUjODqt9cnInduLRtz5n8l+SPc8qUbaHdZZ5RfOj6t
         Y5va0VuZ+rBUbVvx6Y5Bl/Ht4O2PFj9dW7KrZgrKzCnKAkQBKSZrtX0sKC8pg5a9Z/
         S9Jl+MR+fbEfQ==
Date:   Mon, 2 May 2022 14:24:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Changcheng Liu <changchengx.liu@outlook.com>,
        linux-rdma@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: correct ECE offset in query qp output
Message-ID: <Ym+/WnWceotzny4f@unreal>
References: <OSZP286MB1629E3E8563657C551711194FEFB9@OSZP286MB1629.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSZP286MB1629E3E8563657C551711194FEFB9@OSZP286MB1629.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 10:06:11PM +0800, Changcheng Liu wrote:
> 
> From cd2890fc0f756d809f684768fabb34b449df6d29 Mon Sep 17 00:00:00 2001
> From: Changcheng Liu <jerrliu@nvidia.com>
> Date: Tue, 26 Apr 2022 21:28:14 +0800
> Subject: [PATCH] net/mlx5: correct ECE offset in query qp output
> 
> ECE field should be after opt_param_mask in query qp output.
> 
> Fixes: 6b646a7e4af6 ("net/mlx5: Add ability to read and write ECE options")
> Signed-off-by: Changcheng Liu <jerrliu@nvidia.com>

Saeed,

Do you plan to add new patches to mlx5-next?
This change can go to that branch as this field is not used in current
code at all.

Thanks

> 
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 7d2d0ba82144..2e162ec2a3d3 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -5180,12 +5180,11 @@ struct mlx5_ifc_query_qp_out_bits {
>  
>  	u8         syndrome[0x20];
>  
> -	u8         reserved_at_40[0x20];
> -	u8         ece[0x20];
> +	u8         reserved_at_40[0x40];
>  
>  	u8         opt_param_mask[0x20];
>  
> -	u8         reserved_at_a0[0x20];
> +	u8         ece[0x20];
>  
>  	struct mlx5_ifc_qpc_bits qpc;
>  
> -- 
> 2.27.0
> 
