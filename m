Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347663907F3
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 19:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhEYRkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 13:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhEYRkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 13:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F5F361378;
        Tue, 25 May 2021 17:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621964356;
        bh=6txZc6xzIfFSafm6MIKLC+Nq7ol4S6KvT6xgzKMFftA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K+dS7sPyyWRjaKFU9qEwnL1/3XQ5sSMYWSUQCP+A7HFrQh+Vzwj4hc8qxlc3nVbXd
         h8cTs6HLz14hI6AKxRfVYmnH/0dLRgq2C2rXA1AgEETfJY2XhmKBJNEebnkDvhGEpf
         rNGp40XEU7Rp3qPf6UuPdUdBv22xMxJesEWVdQEonN0yxeel/yBKgOPG2yWqYS1Kun
         yZyFmwvFKbq+j++cFi4hh5cG60FsIicaa5HaNZgcdTgRcFrIcTaqxZCiv/xziAkS75
         Xqz7f2zC2cvfD+epEJMF07QJM//LY0wMojIo5bb28Ej787AqFi//fNv4VfqveQxSoI
         +H9rEjkMDNzew==
Date:   Tue, 25 May 2021 10:39:15 -0700
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
Message-ID: <20210525103915.05264e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> When a netdev with active TLS offload goes down, tls_device_down is
> called to stop the offload and tear down the TLS context. However, the
> socket stays alive, and it still points to the TLS context, which is now
> deallocated. If a netdev goes up, while the connection is still active,
> and the data flow resumes after a number of TCP retransmissions, it will
> lead to a use-after-free of the TLS context.
> 
> This commit addresses this bug by keeping the context alive until its
> normal destruction, and implements the necessary fallbacks, so that the
> connection can resume in software (non-offloaded) kTLS mode.
> 
> On the TX side tls_sw_fallback is used to encrypt all packets. The RX
> side already has all the necessary fallbacks, because receiving
> non-decrypted packets is supported. The thing needed on the RX side is
> to block resync requests, which are normally produced after receiving
> non-decrypted packets.
> 
> The necessary synchronization is implemented for a graceful teardown:
> first the fallbacks are deployed, then the driver resources are released
> (it used to be possible to have a tls_dev_resync after tls_dev_del).
> 
> A new flag called TLS_RX_DEV_DEGRADED is added to indicate the fallback
> mode. It's used to skip the RX resync logic completely, as it becomes
> useless, and some objects may be released (for example, resync_async,
> which is allocated and freed by the driver).
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

> @@ -961,6 +964,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
>  
>  	ctx->sw.decrypted |= is_decrypted;
>  
> +	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {

Why not put the check in tls_device_core_ctrl_rx_resync()?
Would be less code, right?

> +		if (likely(is_encrypted || is_decrypted))
> +			return 0;
> +
> +		/* After tls_device_down disables the offload, the next SKB will
> +		 * likely have initial fragments decrypted, and final ones not
> +		 * decrypted. We need to reencrypt that single SKB.
> +		 */
> +		return tls_device_reencrypt(sk, skb);
> +	}
> +
>  	/* Return immediately if the record is either entirely plaintext or
>  	 * entirely ciphertext. Otherwise handle reencrypt partially decrypted
>  	 * record.


