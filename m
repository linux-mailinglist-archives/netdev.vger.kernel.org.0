Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2530646A1AE
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbhLFQs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbhLFQsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:48:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86466C061359;
        Mon,  6 Dec 2021 08:45:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C160ACE16D9;
        Mon,  6 Dec 2021 16:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF9DC341C5;
        Mon,  6 Dec 2021 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638809122;
        bh=m3M8uY2+kP2ZKD7cGq6xWJYvnMzaJ2UYIeThKg6oHT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VuEcUz7l6mG7LtkTDIxRYynQ9UlN9gCYu4Qe3HFH2e7TvrUmPw6fj/vcWxy518PfR
         bjXvc6p9exjS/wSZb03bxLM/cxsj7ImXo+YWNvC5dzifoNS7VxsQ/eLkA6HCsRmcCh
         9q7taZhdFdW2uPkrjjSE71vqQVWj/AVqD4x/lPpddvfVidincZJvY67jOeRIEM7Mjt
         6H6+4BsqT3v6Ww930ZUen5fB7cEEfPn1cqy3p1GSaybVmWB4Tbpl67voe3KO3iNULs
         4wuMVqYNNvS9o5nMmqqVB9Mu7dl9rhw0J/6RckTSgTIlEqE0pCWh9PPXIElWmxI8Xp
         0sKVaDZvdD1uQ==
Date:   Mon, 6 Dec 2021 10:50:50 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] net: prestera: replace zero-length array with
 flexible-array member
Message-ID: <20211206165050.GA48639@embeddedor>
References: <20211204171349.22776-1-jose.exposito89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211204171349.22776-1-jose.exposito89@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 06:13:49PM +0100, José Expósito wrote:
> One-element and zero-length arrays are deprecated and should be
> replaced with flexible-array members:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper.
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/net/ethernet/marvell/prestera/prestera_hw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> index 92cb5e9099c6..6282c9822e2b 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -443,7 +443,7 @@ struct prestera_msg_counter_resp {
>  	__le32 offset;
>  	__le32 num_counters;
>  	__le32 done;
> -	struct prestera_msg_counter_stats stats[0];
> +	struct prestera_msg_counter_stats stats[];
>  };
>  
>  struct prestera_msg_span_req {
> @@ -1900,7 +1900,7 @@ int prestera_hw_counters_get(struct prestera_switch *sw, u32 idx,
>  		.block_id = __cpu_to_le32(idx),
>  		.num_counters = __cpu_to_le32(*len),
>  	};
> -	size_t size = sizeof(*resp) + sizeof(*resp->stats) * (*len);
> +	size_t size = struct_size(resp, stats, *len);
>  	int err, i;
>  
>  	resp = kmalloc(size, GFP_KERNEL);
> -- 
> 2.25.1
> 
