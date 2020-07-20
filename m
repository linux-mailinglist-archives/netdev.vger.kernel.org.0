Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051AF225D49
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgGTLXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:23:46 -0400
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:38595
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728058AbgGTLXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:23:46 -0400
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 8F276203C1;
        Mon, 20 Jul 2020 11:23:43 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Jul 2020 13:23:43 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH v2] drivers/net/wan/x25_asy: Fix to make it work
Organization: TDT AG
In-Reply-To: <20200716234433.6490-1-xie.he.0141@gmail.com>
References: <20200716234433.6490-1-xie.he.0141@gmail.com>
Message-ID: <b2836ae012e0c57ba01ba1dee0a9eacd@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-17 01:44, Xie He wrote:
> This driver is not working because of problems of its receiving code.
> This patch fixes it to make it work.
> 
> When the driver receives an LAPB frame, it should first pass the frame
> to the LAPB module to process. After processing, the LAPB module passes
> the data (the packet) back to the driver, the driver should then add a
> one-byte pseudo header and pass the data to upper layers.
> 
> The changes to the "x25_asy_bump" function and the
> "x25_asy_data_indication" function are to correctly implement this
> procedure.
> 
> Also, the "x25_asy_unesc" function ignores any frame that is shorter
> than 3 bytes. However the shortest frames are 2-byte long. So we need
> to change it to allow 2-byte frames to pass.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
> 
> Change from v1:
> Added skb_cow before skb_push to ensure skb_push will succeed
> according the suggestion of Eric Dumazet.
> 
> Hi Eric Dumazet and Martin Schiller,
> Can you review this patch again and see if it is OK for me to include
> your names in a "Signed-off-by", "Reviewed-by" or "Acked-by" tag?
> Thank you!
> 
> Hi All,
> I'm happy to answer any questions you might have and make improvements
> according to your suggestions. Thanks!
> 
> ---
>  drivers/net/wan/x25_asy.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
> index 69773d228ec1..84640a0c13f3 100644
> --- a/drivers/net/wan/x25_asy.c
> +++ b/drivers/net/wan/x25_asy.c
> @@ -183,7 +183,7 @@ static inline void x25_asy_unlock(struct x25_asy 
> *sl)
>  	netif_wake_queue(sl->dev);
>  }
> 
> -/* Send one completely decapsulated IP datagram to the IP layer. */
> +/* Send an LAPB frame to the LAPB module to process. */
> 
>  static void x25_asy_bump(struct x25_asy *sl)
>  {
> @@ -195,13 +195,12 @@ static void x25_asy_bump(struct x25_asy *sl)
>  	count = sl->rcount;
>  	dev->stats.rx_bytes += count;
> 
> -	skb = dev_alloc_skb(count+1);
> +	skb = dev_alloc_skb(count);
>  	if (skb == NULL) {
>  		netdev_warn(sl->dev, "memory squeeze, dropping packet\n");
>  		dev->stats.rx_dropped++;
>  		return;
>  	}
> -	skb_push(skb, 1);	/* LAPB internal control */
>  	skb_put_data(skb, sl->rbuff, count);
>  	skb->protocol = x25_type_trans(skb, sl->dev);
>  	err = lapb_data_received(skb->dev, skb);
> @@ -209,7 +208,6 @@ static void x25_asy_bump(struct x25_asy *sl)
>  		kfree_skb(skb);
>  		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
>  	} else {
> -		netif_rx(skb);
>  		dev->stats.rx_packets++;
>  	}
>  }
> @@ -356,12 +354,21 @@ static netdev_tx_t x25_asy_xmit(struct sk_buff 
> *skb,
>   */
> 
>  /*
> - *	Called when I frame data arrives. We did the work above - throw it
> - *	at the net layer.
> + *	Called when I frame data arrive. We add a pseudo header for upper
> + *	layers and pass it to upper layers.
>   */
> 
>  static int x25_asy_data_indication(struct net_device *dev, struct 
> sk_buff *skb)
>  {
> +	if (skb_cow(skb, 1)) {
> +		kfree_skb(skb);
> +		return NET_RX_DROP;
> +	}
> +	skb_push(skb, 1);
> +	skb->data[0] = X25_IFACE_DATA;
> +
> +	skb->protocol = x25_type_trans(skb, dev);
> +
>  	return netif_rx(skb);
>  }
> 
> @@ -657,7 +664,7 @@ static void x25_asy_unesc(struct x25_asy *sl,
> unsigned char s)
>  	switch (s) {
>  	case X25_END:
>  		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
> -		    sl->rcount > 2)
> +		    sl->rcount >= 2)
>  			x25_asy_bump(sl);
>  		clear_bit(SLF_ESCAPE, &sl->flags);
>  		sl->rcount = 0;

LGTM.

I have never used the driver, but the adjustments look conclusive. The
functionality is now comparable to the one in the drivers lapbether or
hdlc_x25.

Reviewed-by: Martin Schiller <ms@dev.tdt.de>

