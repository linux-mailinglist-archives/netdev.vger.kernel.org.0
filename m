Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC138F0F8
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbhEXQHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 12:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhEXQG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 12:06:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 604A06108E;
        Mon, 24 May 2021 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621872330;
        bh=xxwTuzCehtGXTttrCBCxHJ1IYhWIATF7eTxPdqqwEqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bew+67UOMxeDbppRjvTcpDUIQobmD5dDVg2e3gC/kO4GPIzlm1eVDM4J1XXzonzTf
         SNfB4HGSbJ12My4cSJaGgsXxCoQgHLKBTkVkcqfPGYU4oWUXW0tcN7BAmdy3UVQrBM
         lqaVLG0oSuSDsc/0SbvEiKs/HlUKuK2i3wuhMEcm/zrYyogFKjQej2FprO3FG3snxz
         yDW4Nb/jYpKLeoa/NO7mCiU5Pxx2lAqKfICjisM7CS+iP59aoxwGafgvOeURZSkgYe
         Bu8Srj3veaO0mnWVOOVQyiBOEhYr0Bf3mZBGDujYIVmgfVIWcwbQkvkcgyiEJFUrUs
         BrkeGpjdHxeAA==
Date:   Mon, 24 May 2021 09:05:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
Message-ID: <20210524090529.442ec7cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210524121220.1577321-2-maximmi@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
        <20210524121220.1577321-2-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 May 2021 15:12:19 +0300 Maxim Mikityanskiy wrote:
> RCU synchronization is guaranteed to finish in finite time, unlike a
> busy loop that polls a flag. This patch is a preparation for the bugfix
> in the next patch, where the same synchronize_net() call will also be
> used to sync with the TX datapath.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/net/tls.h    |  1 -
>  net/tls/tls_device.c | 10 +++-------
>  2 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 3eccb525e8f7..6531ace2a68b 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -193,7 +193,6 @@ struct tls_offload_context_tx {
>  	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
>  
>  enum tls_context_flags {
> -	TLS_RX_SYNC_RUNNING = 0,
>  	/* Unlike RX where resync is driven entirely by the core in TX only
>  	 * the driver knows when things went out of sync, so we need the flag
>  	 * to be atomic.
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 76a6f8c2eec4..171752cd6910 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -680,15 +680,13 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
>  	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
>  	struct net_device *netdev;
>  
> -	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
> -		return;
> -
>  	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
> +	rcu_read_lock();
>  	netdev = READ_ONCE(tls_ctx->netdev);
>  	if (netdev)
>  		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
>  						   TLS_OFFLOAD_CTX_DIR_RX);

Now this can't sleep right? No bueno.

> -	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
> +	rcu_read_unlock();
>  	TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICERESYNC);
>  }
>  

