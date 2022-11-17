Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7B162D71B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiKQJdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiKQJdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:33:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3050646D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:33:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF6B62161
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C69BC433D6;
        Thu, 17 Nov 2022 09:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668677616;
        bh=NhTJACCdciFuKX364eFQ/jsqd5A9he7LnvmSKixVX74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7Pwhtc23VkMT5rVJiXcrq7q3U0ja+4IOcWxfcBSxBN/h1Ncwi6dP3VvonB/tz0/6
         G7d9wJ2WVdckCQ478BWYXeoo37dixsIh6x1n0PsY+tt+2wWdkbMHzrPJTJeFR7z5/n
         TuE+F1scHZrZQZjZ+SdI/MuHwS9KkRcdPCz3GdD1/MCWLD0OlLkrPrqwBBCSTM0n3k
         Wt9Qde6jROo1vU01kI2jjonS71B8H6S82CChJMQ8WCDE1GGar8lHoyk4zagYvMIOX2
         5vVfYkXsJHqbxrCI5tqesLdHCqg0A+DUbWAUXA0VDUZCsyI+iLiOTPxxHROtsWnJ+A
         sQFYV8aDoqMcg==
Date:   Thu, 17 Nov 2022 11:33:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next] net: libwx: Fix dead code for duplicate check
Message-ID: <Y3X/63a5sikU711a@unreal>
References: <20221116015835.1187783-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116015835.1187783-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 09:58:35AM +0800, Jiawen Wu wrote:
> Fix duplicate check on polling timeout.
> 
> Fixes: 1efa9bfe58c5 ("net: libwx: Implement interaction with firmware")
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> index 1eb7388f1dd5..c57dc3238b3f 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> @@ -203,8 +203,6 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
>  
>  	status = read_poll_timeout(rd32, hicr, hicr & WX_MNG_MBOX_CTL_FWRDY, 1000,
>  				   timeout * 1000, false, wxhw, WX_MNG_MBOX_CTL);
> -	if (status)
> -		goto rel_out;

BTW, this driver should use readx_poll_timeout() instead of read_poll_timeout(...).

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
