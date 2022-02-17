Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006CC4BA670
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbiBQQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:52:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiBQQwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:52:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A805112AAF;
        Thu, 17 Feb 2022 08:52:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0F59B82370;
        Thu, 17 Feb 2022 16:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DD4C340E9;
        Thu, 17 Feb 2022 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645116724;
        bh=uuKhceu6jpJKjU6daXptOGO4IPaSMva/iLUpGVkKMh4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f/FTTMWa5LAiJftB3osB8TA1ooRXGyDWsFTmick3lgAl7plXaVr5bAUDBrN7asBwy
         GwKSRI7KI/SiGPN2/QEWQZwrAvMR2Y/l21DCVGpklU8JpU1LHqhKFl3XsJxGGJUmHN
         99E61cX1beqfoRG1c0XMDuV+WwtQ9hJZ0wkTCRD8UzSDjvp1DaZbfxuwpwO4fzSfuE
         NwkTaOAEp8ztlJEJzlGh8Rdrm02h0OJgXLXTz0+Qj2pzqWIXxPKHtRWevI1W5qoe6B
         xxeoWCCpw2F5IMS4MBN/nusdlNyPq+sh69x8tfQb5HNtuJDZwi0JZmdBjNqrJMm1PE
         rQj56P63pex9w==
Date:   Thu, 17 Feb 2022 08:52:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xkernel.wang@foxmail.com
Cc:     davem@davemloft.net, michal.simek@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ll_temac: check the return value of devm_kmalloc()
Message-ID: <20220217085202.00173453@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <tencent_A528B1FF77813031ABE6C6738453F084570A@qq.com>
References: <tencent_A528B1FF77813031ABE6C6738453F084570A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 18:46:42 +0800 xkernel.wang@foxmail.com wrote:
> From: Xiaoke Wang <xkernel.wang@foxmail.com>
> 
> devm_kmalloc() returns a pointer to allocated memory on success, NULL
> on failure. While lp->indirect_lock is allocated by devm_kmalloc()
> without proper check. It is better to check the value of it to
> prevent potential wrong memory access.
> 

Consider adding a Fixes tag, although I guess this is not a real bug
since tiny allocations don't really fail.

> Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
> ---
>  drivers/net/ethernet/xilinx/ll_temac_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 463094c..7c5dd39 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1427,6 +1427,11 @@ static int temac_probe(struct platform_device *pdev)
>  		lp->indirect_lock = devm_kmalloc(&pdev->dev,
>  						 sizeof(*lp->indirect_lock),
>  						 GFP_KERNEL);
> +		if (!lp->indirect_lock) {
> +			dev_err(&pdev->dev,
> +				"indirect register lock allocation failed\n");

There's no need for this message, kmalloc() will display an error
already.

> +			return -ENOMEM;
> +		}
>  		spin_lock_init(lp->indirect_lock);
>  	}
>  

