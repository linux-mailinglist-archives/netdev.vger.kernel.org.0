Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA2481890
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhL3CdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:33:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54466 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbhL3CdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:33:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C8FA615DB;
        Thu, 30 Dec 2021 02:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAF9C36AE7;
        Thu, 30 Dec 2021 02:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640831601;
        bh=uvcU7NWQhw7eLa9PH40G7TjraiSheXYdZ13KSXUqqSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkQuGnZ4PPyxCSZPMr2zci0kKLBUM0laf2V1o0TSTCNmr2VxqIJN+tMhQVw9vpABJ
         TAO1y2ypDeSFdUk5gHcHr43X3cu8Y/8xo/GPpphm2v8nUEx/1rAreKrqCAAtdU1CA5
         MofQ53itdcJb19R6gcYoWbLmOEuYtBaJJk+KbVmh1mprLSttjU/wqssCoHaqsLZGhK
         lzbRt6N2tVHqaOnhwRuVnb2LOkB73GqZEMyafhYziJ+7oWpaR26yMyTt3fG6JLOhHN
         yJjV6YmPC605FAZ7RQIZNZyCwlX7mkGxzcr8bMgPTbQP9En1O3ZnoweOmewaBtI/4m
         ifovYtLd0mVMQ==
Date:   Wed, 29 Dec 2021 18:33:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fjes: Check possible NULL pointer returned by vzalloc
Message-ID: <20211229183320.5631b317@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229102140.1776466-1-jiasheng@iscas.ac.cn>
References: <20211229102140.1776466-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 18:21:40 +0800 Jiasheng Jiang wrote:
> As the possible alloc failure of the vzalloc(), the 'hw->hw_info.trace'
> could be NULL pointer.
> Therefore it should be better to check it to guarantee the complete
> success of the initiation.
> 
> Fixes: 8cdc3f6c5d22 ("fjes: Hardware initialization routine")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/fjes/fjes_hw.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/fjes/fjes_hw.c b/drivers/net/fjes/fjes_hw.c
> index 065bb0a40b1d..4c83f637a135 100644
> --- a/drivers/net/fjes/fjes_hw.c
> +++ b/drivers/net/fjes/fjes_hw.c
> @@ -329,6 +329,9 @@ int fjes_hw_init(struct fjes_hw *hw)
>  	ret = fjes_hw_setup(hw);
>  
>  	hw->hw_info.trace = vzalloc(FJES_DEBUG_BUFFER_SIZE);
> +	if (!hw->hw_info.trace)
> +		return -ENOMEM;
> +
>  	hw->hw_info.trace_size = FJES_DEBUG_BUFFER_SIZE;
>  
>  	return ret;

The rest of this driver is clearly written expecting that
hw_info.trace may be NULL. This change is unnecessary at 
best and may even introduce a regression.

Please do bare minimum of sanity checking your patches.
Your submissions are consistently of very low quality.
