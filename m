Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EDD39073B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhEYRQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 13:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbhEYRQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 13:16:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D086D6141D;
        Tue, 25 May 2021 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621962870;
        bh=GAt6ukerEtm9ec9b8BtGcuFAoGuGuB1CpIXk+jfXw+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2z2ubTj7rOVEHj04AQmK4IitW0C7g8R/4hRFhIDKfGl59Scif1q/ZVa2Oj4RPaal
         HxRfEmXGYzTVXSLty/KnvDpQf3o0/uPgAu8uxQRHDTuhbTUYoUG0Sd51li5QyLs19A
         o3GzXZZLSWxDcdH59Pa81jIZ9aXb6rnX3OU1AkHQQBZRCGD93VZo96ufU+/Zy+PNNT
         8RAvhNaTnOFfTm3SYwKIjzR3trdNg2j02xdR8Aalz/NLv9qkon9yfmrbjtjnQ80iQ1
         nEyDWo/oHbep21Ew7sfnix8C22s4AYx/SR30FSupjojArn8XNiJt96b/yinW890OvH
         GVX+deh0TOSzw==
Date:   Tue, 25 May 2021 10:14:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
Message-ID: <20210525101429.5f80116b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <10605180-22a7-4317-4e71-68e04cb04dd8@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
        <20210524121220.1577321-2-maximmi@nvidia.com>
        <20210524090529.442ec7cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <10605180-22a7-4317-4e71-68e04cb04dd8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 May 2021 11:52:20 +0300 Maxim Mikityanskiy wrote:
> On 2021-05-24 19:05, Jakub Kicinski wrote:
> > On Mon, 24 May 2021 15:12:19 +0300 Maxim Mikityanskiy wrote:  
> >> RCU synchronization is guaranteed to finish in finite time, unlike a
> >> busy loop that polls a flag. This patch is a preparation for the bugfix
> >> in the next patch, where the same synchronize_net() call will also be
> >> used to sync with the TX datapath.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> >> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> >> ---
> >>   include/net/tls.h    |  1 -
> >>   net/tls/tls_device.c | 10 +++-------
> >>   2 files changed, 3 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/include/net/tls.h b/include/net/tls.h
> >> index 3eccb525e8f7..6531ace2a68b 100644
> >> --- a/include/net/tls.h
> >> +++ b/include/net/tls.h
> >> @@ -193,7 +193,6 @@ struct tls_offload_context_tx {
> >>   	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
> >>   
> >>   enum tls_context_flags {
> >> -	TLS_RX_SYNC_RUNNING = 0,
> >>   	/* Unlike RX where resync is driven entirely by the core in TX only
> >>   	 * the driver knows when things went out of sync, so we need the flag
> >>   	 * to be atomic.
> >> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> >> index 76a6f8c2eec4..171752cd6910 100644
> >> --- a/net/tls/tls_device.c
> >> +++ b/net/tls/tls_device.c
> >> @@ -680,15 +680,13 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
> >>   	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
> >>   	struct net_device *netdev;
> >>   
> >> -	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
> >> -		return;
> >> -
> >>   	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
> >> +	rcu_read_lock();
> >>   	netdev = READ_ONCE(tls_ctx->netdev);
> >>   	if (netdev)
> >>   		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
> >>   						   TLS_OFFLOAD_CTX_DIR_RX);  
> > 
> > Now this can't sleep right? No bueno.  
> 
> No, it can't sleep under RCU. However, are you sure it was allowed to 
> sleep before my change? I don't think so. Your commit e52972c11d6b 
> ("net/tls: replace the sleeping lock around RX resync with a bit lock") 
> mentions that "RX resync may get called from soft IRQ", which 
> essentially means that it can't sleep.
> 
> Furthermore, no implementations try to sleep in RX resync, as far as I 
> see from reviewing the code. For example, nfp_net_tls_resync uses 
> GFP_ATOMIC for RX resync and GFP_KERNEL for TX resync. 
> mlx5_fpga_tls_resync_rx also uses GFP_ATOMIC.
> 
> So, I don't think I'm breaking anything with my change.

You're right.
