Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A2D3483E7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCXVmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238601AbhCXVmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 17:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C533861A02;
        Wed, 24 Mar 2021 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616622129;
        bh=pO+YZkBPwbdWBeIQV1r0YqV0t1K+79FUzdDrMRVn0gs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KvRoVtbPYEjXPLMeNonhQ1KBOHLBoegTdROJcg7+MIb/hNrazviSXstRPl7uv6Ohj
         kzibuRP3GH15o4Qle8swoOTBCDexBCU1OEw8kRFs6aG8bW8nn4eeYB3O0s/U0voabv
         XwVoLIoWDuY64JpUc5djaqBqFwbQjiZ94mJdFR2kQoDDEzqK012bPrbyXXQXKsFTod
         yz3jatVdYgT3ZwNAfaoZOAkpZVxhcunWdBMfGqv7cKltVLoNkHPKiBrXZhJCPsEZwD
         x2nDzk25Dad+zxDWb7pU1uWpx2LqOLqA3HQ/hHAkc2k51T83WLggdLiQesH3DLYOhx
         FUFGxLrG1IwHg==
Date:   Wed, 24 Mar 2021 14:42:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 1/2] net: mhi: Allow decoupled MTU/MRU
Message-ID: <20210324144208.462e9f97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1616510707-27210-1-git-send-email-loic.poulain@linaro.org>
References: <1616510707-27210-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Mar 2021 15:45:06 +0100 Loic Poulain wrote:
> If a maximum receive unit (MRU) size is specified, use it for RX
> buffers allocation instead of the MTU.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

I don't think this patch represents a logical change. You should merge
your patches into one.

> diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
> index 12e7407..1d0c499 100644
> --- a/drivers/net/mhi/mhi.h
> +++ b/drivers/net/mhi/mhi.h
> @@ -29,6 +29,7 @@ struct mhi_net_dev {
>  	struct mhi_net_stats stats;
>  	u32 rx_queue_sz;
>  	int msg_enable;
> +	unsigned int mru;
>  };
>  
>  struct mhi_net_proto {
> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> index f599608..5ec7a29 100644
> --- a/drivers/net/mhi/net.c
> +++ b/drivers/net/mhi/net.c
> @@ -265,10 +265,12 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
>  						      rx_refill.work);
>  	struct net_device *ndev = mhi_netdev->ndev;
>  	struct mhi_device *mdev = mhi_netdev->mdev;
> -	int size = READ_ONCE(ndev->mtu);
>  	struct sk_buff *skb;
> +	unsigned int size;
>  	int err;
>  
> +	size = mhi_netdev->mru ? mhi_netdev->mru : READ_ONCE(ndev->mtu);
> +
>  	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
>  		skb = netdev_alloc_skb(ndev, size);
>  		if (unlikely(!skb))

