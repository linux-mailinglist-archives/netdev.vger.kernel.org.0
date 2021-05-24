Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F61238F14F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 18:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhEXQQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 12:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233017AbhEXQQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 12:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6837613B6;
        Mon, 24 May 2021 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621872929;
        bh=u3VrUh36A3ECQFBiR53Uiy/VSXR89V2COL7dCrTuxJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uS0ELkTQLIXeF9NQTuYntfPdmlG0u0ZI1IfUwvERcpABQHmRqHLufunl0wZGNs/Mn
         yRxadZusu/KJSitO0PcOHkm2liWMCnnbDlqh3gTIDK589srR1hWCI9PGV69Yfjxlhl
         ALca0exHpbDVQ/E4vmqNL3In4lRcB1GJqp5dmbXb0I2S5SiIE4DtGgLtnWuRPYAYea
         5K8GFz7X2atHJ10Se6aRkE1jcibhwQDU9zP57coDstYNNNyL0IOUA1O3YjWXIwCt7x
         FWakTMZslJ4xfml9dZImMIJcFqoAdEZK7RurA1rEZhHZCVxrrVmJ5Qas2rKXCzG6J0
         YzOVELGcITHzg==
Date:   Mon, 24 May 2021 09:15:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS
 device goes down and up
Message-ID: <20210524091528.3b53c1ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210524121220.1577321-3-maximmi@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
        <20210524121220.1577321-3-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 May 2021 15:12:20 +0300 Maxim Mikityanskiy wrote:
> @@ -1290,6 +1304,26 @@ static int tls_device_down(struct net_device *netdev)
>  	spin_unlock_irqrestore(&tls_device_lock, flags);
>  
>  	list_for_each_entry_safe(ctx, tmp, &list, list)	{
> +		/* Stop offloaded TX and switch to the fallback.
> +		 * tls_is_sk_tx_device_offloaded will return false.
> +		 */
> +		WRITE_ONCE(ctx->sk->sk_validate_xmit_skb, tls_validate_xmit_skb_sw);
> +
> +		/* Stop the RX and TX resync.
> +		 * tls_dev_resync must not be called after tls_dev_del.
> +		 */
> +		WRITE_ONCE(ctx->netdev, NULL);
> +
> +		/* Start skipping the RX resync logic completely. */
> +		set_bit(TLS_RX_DEV_DEGRADED, &ctx->flags);
> +
> +		/* Sync with inflight packets. After this point:
> +		 * TX: no non-encrypted packets will be passed to the driver.
> +		 * RX: resync requests from the driver will be ignored.
> +		 */
> +		synchronize_net();
> +
> +		/* Release the offload context on the driver side. */
>  		if (ctx->tx_conf == TLS_HW)
>  			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
>  							TLS_OFFLOAD_CTX_DIR_TX);

Can we have the Rx resync take the device_offload_lock for read instead?
Like Tx already does?

> +EXPORT_SYMBOL_GPL(tls_validate_xmit_skb_sw);

Why the export?
