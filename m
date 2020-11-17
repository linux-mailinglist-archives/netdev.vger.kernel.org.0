Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4502B718D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgKQW0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgKQW0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 17:26:03 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDF3241A6;
        Tue, 17 Nov 2020 22:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605651962;
        bh=oolxzZft70FKdrR5koKNa14651ERpY0sfPZUoLt+SKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ngK+nrIRMKPhN+J5uZcql2PrzLrKZaW8pxtXdhSBlqaOF+DNS5W3tkYFFWqhz9jub
         3xEOKj78jUGahxn++pXBprA8VephbYFUS+GCtwgt0ApkOwqc4tVU8+HvNTH+ugf2pF
         bI3VHTWcHH0Dp5kwkh9LqNO/CwAGRpJzHaNvTfyo=
Date:   Tue, 17 Nov 2020 14:25:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH] cxbgb4: Fix build failure when CHELSIO_TLS_DEVICE=n
Message-ID: <20201117142559.37e6847f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201116023140.28975-1-tseewald@gmail.com>
References: <20201116023140.28975-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 20:31:40 -0600 Tom Seewald wrote:
> After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> building the kernel with CHELSIO_T4=y and CHELSIO_TLS_DEVICE=n results
> in the following error:
> 
> ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
> `cxgb_select_queue':
> cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'
> 
> This is caused by cxgb_select_queue() calling cxgb4_is_ktls_skb() without
> checking if CHELSIO_TLS_DEVICE=y. Fix this by calling cxgb4_is_ktls_skb()
> only when this config option is enabled.
> 
> Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index 7fd264a6d085..8e8783afd6df 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -1176,7 +1176,9 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
>  		txq = netdev_pick_tx(dev, skb, sb_dev);
>  		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
>  		    skb->encapsulation ||
> -		    cxgb4_is_ktls_skb(skb) ||
> +#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
> +		cxgb4_is_ktls_skb(skb) ||
> +#endif /* CHELSIO_TLS_DEVICE */
>  		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
>  			txq = txq % pi->nqsets;
>  

The tls header already tries to solve this issue, it just does it
poorly. This is a better fix:

diff --git a/include/net/tls.h b/include/net/tls.h
index baf1e99d8193..2ff3f4f7954a 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -441,11 +441,11 @@ struct sk_buff *
 tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
                      struct sk_buff *skb);
 
 static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 {
-#ifdef CONFIG_SOCK_VALIDATE_XMIT
+#ifdef CONFIG_TLS_DEVICE
        return sk_fullsock(sk) &&
               (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
               &tls_validate_xmit_skb);
 #else
        return false;


Please test this and submit if it indeed solves the problem.

Thanks!
