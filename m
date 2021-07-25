Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3B3D4CB6
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 10:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhGYH5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhGYH5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 03:57:15 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF625C061757;
        Sun, 25 Jul 2021 01:37:45 -0700 (PDT)
Subject: Re: [PATCH] mlx4: Fix missing error code in mlx4_load_one()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627202261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMDPb1pPl3PoQQ83a9gmENv6+Js5xeBQrgRul+VOSA8=;
        b=NMob4IOxzOJIflzmWNgdGZpMurTIcvdCJcDmG3YjcOCWkVGU1V/BiETNFBlfO8qsMvKgUg
        gruh7+sVDdprhByWJ4snzZeHR0jd7pPKSVjzWxQQh1nNwB+ex1hidp65gcP800GQUe8nyo
        1G6THX5FnUllnpgbBpIFT4XDg6SsNOs=
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, tariqt@nvidia.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Gal Pressman <gal.pressman@linux.dev>
Message-ID: <9a9cfded-cbce-b36d-77f1-020caeaf6052@linux.dev>
Date:   Sun, 25 Jul 2021 11:37:38 +0300
MIME-Version: 1.0
In-Reply-To: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: gal.pressman@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2021 13:36, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:3538 mlx4_load_one() warn:
> missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 7ae0e400cd93 ("net/mlx4_core: Flexible (asymmetric) allocation of
> EQs and MSI-X vectors for PF/VFs")

Fixes line shouldn't be wrapped.

> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 00c8465..28ac469 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3535,6 +3535,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
>  
>  		if (!SRIOV_VALID_STATE(dev->flags)) {
>  			mlx4_err(dev, "Invalid SRIOV state\n");
> +			err = -EINVAL;
>  			goto err_close;
>  		}
>  	}
> 

I think this patch is missing a few occurrences:
https://elixir.bootlin.com/linux/v5.14-rc2/source/drivers/net/ethernet/mellanox/mlx4/main.c#L3455
https://elixir.bootlin.com/linux/v5.14-rc2/source/drivers/net/ethernet/mellanox/mlx4/main.c#L3468
https://elixir.bootlin.com/linux/v5.14-rc2/source/drivers/net/ethernet/mellanox/mlx4/main.c#L3490
