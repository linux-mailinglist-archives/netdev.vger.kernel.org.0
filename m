Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FB4642982
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiLENhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiLENhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:37:37 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362052639
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 05:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670247457; x=1701783457;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cEybTad5XPcGhVf+yDf6G8480NcjKfuh/ThkTuApRVw=;
  b=k3jBGXwdnBbiNOFTqRKCjB+TkMSvp5yZ6FkNJseBdD7YTwDV268OVDTz
   xMqcswmBMxOw2xqTys8tY8R/hOIrNnWg5IMgy0ZkO+0AEgdAGMZjKn2mZ
   eDOuj2zlvKUl0pgIjKvDaaA6aY1dhIE4riAJHUWewNQZ/7ZzyENHzOFHH
   Ud0QnzTvp793/mufS+FaN0vVS4icTV3JK2DYnVW7y5ANiqe1g65eg+PEm
   oHvwFnzLSZHiy3z86n0FoML9kBOGbPyfru8FNJiehYLCMx19DJDvI/tED
   7Y0y5XFozVB2FMiS49HPpZkBPeWr6ttxSZMAzLV2aSmmuH/wDiMUyqXrz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="402621543"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="402621543"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 05:37:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="788074379"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="788074379"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 05 Dec 2022 05:37:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 8682FF4; Mon,  5 Dec 2022 15:38:01 +0200 (EET)
Date:   Mon, 5 Dec 2022 15:38:01 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, michael.jamet@intel.com,
        YehezkelShB@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] net: thunderbolt: fix memory leak in tbnet_open()
Message-ID: <Y430Od5z5gNI2p0G@black.fi.intel.com>
References: <20221205115559.3189177-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221205115559.3189177-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Dec 05, 2022 at 07:55:59PM +0800, Zhengchao Shao wrote:
> When tb_ring_alloc_rx() failed in tbnet_open(), it doesn't free ida.
> 
> Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/thunderbolt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
> index a52ee2bf5575..70fd61ce15c6 100644
> --- a/drivers/net/thunderbolt.c
> +++ b/drivers/net/thunderbolt.c
> @@ -916,6 +916,7 @@ static int tbnet_open(struct net_device *dev)
>  		netdev_err(dev, "failed to allocate Rx ring\n");
>  		tb_ring_free(net->tx_ring.ring);
>  		net->tx_ring.ring = NULL;
> +		tb_xdomain_release_out_hopid(xd, hopid);

Can you move this before tb_ring_free()? Like this:

  		netdev_err(dev, "failed to allocate Rx ring\n");
 		tb_xdomain_release_out_hopid(xd, hopid);
  		tb_ring_free(net->tx_ring.ring);
  		net->tx_ring.ring = NULL;

Otherwise looks good to me.
