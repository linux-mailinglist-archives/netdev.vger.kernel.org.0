Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AA0623EEF
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiKJJpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKJJpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:45:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28CD6AECB
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:45:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 402F66068E
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04D4C433C1;
        Thu, 10 Nov 2022 09:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668073513;
        bh=s9zWLdlIS/HHFfbJ6ktzCjpFa9qwCJhTM0+31HNFaBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oQqhg+ibeeIQ/vy1Sb3ztieY/+iZ9XIsvwwWqJAeJrRVPl2cQfjlBMqBbLPUSWFbn
         YKD4kIkPCQfgNJZdeYikyrXW6tVsvU6pvQPvCAtR+zjLMmv0YJBR/B2/RKbeEDufx9
         eWLCMFnEEtBoCh/FiC8qsBNYTZs9JDvNjvXzl/p6FbkYcHN+jlE42fMGIw6GW/z4dP
         1RiHcXlYtsAI6TToKAnm6MWJEvgNOAR4sJRN9roDRLuZIBSJBWQvMDSf+KvRceAUEI
         uCUxxoJxiboiDmBXAJMZPxGr/qqtgHaUdXG9ub18KQoqUhErZ2fZztGEy/VaZqEaAr
         NhtPIXf0ffqCw==
Date:   Thu, 10 Nov 2022 11:45:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        rvatsavayi@caviumnetworks.com, gregkh@linuxfoundation.org,
        tseewald@gmail.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] net: liquidio: release resources when liquidio
 driver open failed
Message-ID: <Y2zII4SL4tlwfVi/@unreal>
References: <20221110013116.270258-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110013116.270258-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:31:16AM +0800, Zhengchao Shao wrote:
> When liquidio driver open failed, it doesn't release resources. Compile
> tested only.
> 
> Fixes: 5b07aee11227 ("liquidio: MSIX support for CN23XX")
> Fixes: dbc97bfd3918 ("net: liquidio: Add missing null pointer checks")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  .../net/ethernet/cavium/liquidio/lio_main.c   | 40 ++++++++++++++++---
>  1 file changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> index d312bd594935..713689cf212c 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -1795,12 +1795,15 @@ static int liquidio_open(struct net_device *netdev)
>  	ifstate_set(lio, LIO_IFSTATE_RUNNING);
>  
>  	if (OCTEON_CN23XX_PF(oct)) {
> -		if (!oct->msix_on)
> -			if (setup_tx_poll_fn(netdev))
> -				return -1;
> +		if (!oct->msix_on) {
> +			ret = setup_tx_poll_fn(netdev);
> +			if (ret)
> +				goto err_poll;
> +		}
>  	} else {
> -		if (setup_tx_poll_fn(netdev))
> -			return -1;
> +		ret = setup_tx_poll_fn(netdev);
> +		if (ret)
> +			goto err_poll;
>  	}

Instead of this hairy code, you can squeeze everything into one if:

if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && oct->msix_on)) {
  ret = setup_tx_poll_fn(netdev);
  if (ret)
     ,,,

Thanks
