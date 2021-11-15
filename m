Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685E545115A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 20:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbhKOTFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 14:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243401AbhKOTB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 14:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C16E963351;
        Mon, 15 Nov 2021 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637000079;
        bh=1jdsajeUX88NVAQocP9iDcgTXEzKovNOFexILtdxPxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pKKgWeM6XQqj7skT8X/vS0XZMvZndQIDJ3HBoelJssrLAok/ETmJUoFJIp7Nmp8U/
         bHd/V2wbBTRigCWsTkBtKFI3vxfCEhTnY1cWmPrNun0Lf0q/Pb5ofkGB27SRO+PGbi
         k0tPgbf4Vf0ntgBFLmikNhk2KezFLVp36Yg37o+MwoQBFhkN5UVXTHof3prq3bkIvE
         SCvU9rQA2tO7bnrZjYumGYGCcL5QRj/gwyRaJ5bsuuBrViVpqCHtaiVYIr/T3oSmi0
         7/l3/7pPNIHb9Yop0ZSETYUWuwBEhwUgcU+xvAjJZOTjg3/PweAcOiE8S9gMoU9I6r
         T7X7PNEAZ0Ciw==
Date:   Mon, 15 Nov 2021 10:14:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Remove extra assertion from flash
 notification logic
Message-ID: <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
References: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 20:07:47 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mlxsw driver calls to various devlink flash routines even before
> users can get any access to the devlink instance itself. For example,
> mlxsw_core_fw_rev_validate() one of such functions.
> 
> It causes to the WARN_ON to trigger warning about devlink not
> registered, while the flow is valid.

So the fix is to remove the warning and keep generating notifications
about objects which to the best understanding of the user space do not
exist?

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 5ba4f9434acd..6face738b16a 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4229,7 +4229,6 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
>  	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
>  		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
>  		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
> -	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)

