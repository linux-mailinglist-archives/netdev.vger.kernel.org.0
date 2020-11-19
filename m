Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F8F2B895C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgKSBND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgKSBNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:13:02 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C5B42145D;
        Thu, 19 Nov 2020 01:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605748381;
        bh=gVLAMVMPsy8FciFWO9NMYeFylenwizoTwx03CB4IsBo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uNizKZr0jMIatXWruu4Etr67K+rJiBUOFa3Ycbm9vdig67EdXCwTSD3sRCYWD2AOw
         IcKZNNHycd30+GcoXC4GpyFbaLch5/VG2OyZwSg8GgdF8OfovzRhi68XFun+LZPqhy
         PWJIOH3S79gKlnlopgnq6Pq9GTnsP8MxCOEXA3Uo=
Date:   Wed, 18 Nov 2020 17:13:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>
Subject: Re: [PATCH net 1/2] net/tls: Protect from calling tls_dev_del for
 TLS RX twice
Message-ID: <20201118171300.71db0be3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117203355.389661-1-saeedm@nvidia.com>
References: <20201117203355.389661-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 12:33:54 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> tls_device_offload_cleanup_rx doesn't clear tls_ctx->netdev after
> calling tls_dev_del if TLX TX offload is also enabled. Clearing
> tls_ctx->netdev gets postponed until tls_device_gc_task. It leaves a
> time frame when tls_device_down may get called and call tls_dev_del for
> RX one extra time, confusing the driver, which may lead to a crash.
> 
> This patch corrects this racy behavior by adding a flag to prevent
> tls_device_down from calling tls_dev_del the second time.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
> For -stable: 5.3
> 
>  include/net/tls.h    | 1 +
>  net/tls/tls_device.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index baf1e99d8193..a0deddfde412 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -199,6 +199,7 @@ enum tls_context_flags {
>  	 * to be atomic.
>  	 */
>  	TLS_TX_SYNC_SCHED = 1,

Please add a comment here explaining that this bit is set when device
state is partially released, and ctx->netdev cannot be cleared but RX
side was already removed.

> +	TLS_RX_DEV_RELEASED = 2,
>  };
>  
>  struct cipher_context {
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index cec86229a6a0..b2261caac6be 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1241,6 +1241,7 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
>  
>  	netdev->tlsdev_ops->tls_dev_del(netdev, tls_ctx,
>  					TLS_OFFLOAD_CTX_DIR_RX);
> +	set_bit(TLS_RX_DEV_RELEASED, &tls_ctx->flags);

Would the semantics of the bit be clearer if we only set the bit in an
else branch below and renamed it TLS_RX_DEV_CLOSED?

Otherwise it could be confusing to the reader that his bit is only set
here but not in tls_device_down().

>  	if (tls_ctx->tx_conf != TLS_HW) {
>  		dev_put(netdev);
> @@ -1274,7 +1275,7 @@ static int tls_device_down(struct net_device *netdev)
>  		if (ctx->tx_conf == TLS_HW)
>  			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
>  							TLS_OFFLOAD_CTX_DIR_TX);
> -		if (ctx->rx_conf == TLS_HW)
> +		if (ctx->rx_conf == TLS_HW && !test_bit(TLS_RX_DEV_RELEASED, &ctx->flags))
>  			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
>  							TLS_OFFLOAD_CTX_DIR_RX);
>  		WRITE_ONCE(ctx->netdev, NULL);

