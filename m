Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD03226178A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgIHRfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:35:46 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:48526 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731699AbgIHRfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:35:36 -0400
Received: from PC192.168.2.51 (p200300e9d72b66a2cea394247181a3e4.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:66a2:cea3:9424:7181:a3e4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id EA5E9C0702;
        Tue,  8 Sep 2020 19:35:20 +0200 (CEST)
Subject: Re: [PATCH net] mac802154: tx: fix use-after-free
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
References: <20200908104025.4009085-1-edumazet@google.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <26f56ee9-e4f8-7464-dab7-356d84db7efb@datenfreihafen.org>
Date:   Tue, 8 Sep 2020 19:35:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200908104025.4009085-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric.

On 08.09.20 12:40, Eric Dumazet wrote:
> syzbot reported a bug in ieee802154_tx() [1]
> 
> A similar issue in ieee802154_xmit_worker() is also fixed in this patch.
> 

[ snip]

> 
> Fixes: 409c3b0c5f03 ("mac802154: tx: move stats tx increment")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Stefan Schmidt <stefan@datenfreihafen.org>
> Cc: linux-wpan@vger.kernel.org
> ---
>   net/mac802154/tx.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index ab52811523e992f33f0855cdb711a2752b602e15..c829e4a7532564d401c0d2d1f90f56c2fe030b2c 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -34,11 +34,11 @@ void ieee802154_xmit_worker(struct work_struct *work)
>   	if (res)
>   		goto err_tx;
>   
> -	ieee802154_xmit_complete(&local->hw, skb, false);
> -
>   	dev->stats.tx_packets++;
>   	dev->stats.tx_bytes += skb->len;
>   
> +	ieee802154_xmit_complete(&local->hw, skb, false);
> +
>   	return;
>   
>   err_tx:
> @@ -78,6 +78,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>   
>   	/* async is priority, otherwise sync is fallback */
>   	if (local->ops->xmit_async) {
> +		unsigned int len = skb->len;
> +
>   		ret = drv_xmit_async(local, skb);
>   		if (ret) {
>   			ieee802154_wake_queue(&local->hw);
> @@ -85,7 +87,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>   		}
>   
>   		dev->stats.tx_packets++;
> -		dev->stats.tx_bytes += skb->len;
> +		dev->stats.tx_bytes += len;
>   	} else {
>   		local->tx_skb = skb;
>   		queue_work(local->workqueue, &local->tx_work);
> 

Thanks for catching this!

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
