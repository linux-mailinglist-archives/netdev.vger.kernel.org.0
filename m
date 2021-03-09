Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEF33327A3
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhCINs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 08:48:57 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:36373 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhCINsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 08:48:37 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1lJciv-0008MS-2Z; Tue, 09 Mar 2021 14:48:33 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1lJciu-0008mO-8s; Tue, 09 Mar 2021 14:48:32 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 58158240041;
        Tue,  9 Mar 2021 14:48:31 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id DABB3240040;
        Tue,  9 Mar 2021 14:48:30 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 90F50200DE;
        Tue,  9 Mar 2021 14:48:30 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 09 Mar 2021 14:48:30 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lapbether: Remove netif_start_queue /
 netif_stop_queue
Organization: TDT AG
In-Reply-To: <20210307113309.443631-1-xie.he.0141@gmail.com>
References: <20210307113309.443631-1-xie.he.0141@gmail.com>
Message-ID: <6f885ff41da24d41cb5d430d9abe42f7@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1615297712-0000C46D-3FE81434/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-07 12:33, Xie He wrote:
> For the devices in this driver, the default qdisc is "noqueue",
> because their "tx_queue_len" is 0.
> 
> In function "__dev_queue_xmit" in "net/core/dev.c", devices with the
> "noqueue" qdisc are specially handled. Packets are transmitted without
> being queued after a "dev->flags & IFF_UP" check. However, it's 
> possible
> that even if this check succeeds, "ops->ndo_stop" may still have 
> already
> been called. This is because in "__dev_close_many", "ops->ndo_stop" is
> called before clearing the "IFF_UP" flag.
> 
> If we call "netif_stop_queue" in "ops->ndo_stop", then it's possible in
> "__dev_queue_xmit", it sees the "IFF_UP" flag is present, and then it
> checks "netif_xmit_stopped" and finds that the queue is already 
> stopped.
> In this case, it will complain that:
> "Virtual device ... asks to queue packet!"
> 
> To prevent "__dev_queue_xmit" from generating this complaint, we should
> not call "netif_stop_queue" in "ops->ndo_stop".
> 
> We also don't need to call "netif_start_queue" in "ops->ndo_open",
> because after a netdev is allocated and registered, the
> "__QUEUE_STATE_DRV_XOFF" flag is initially not set, so there is no need
> to call "netif_start_queue" to clear it.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/lapbether.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index 605fe555e157..c3372498f4f1 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
> @@ -292,7 +292,6 @@ static int lapbeth_open(struct net_device *dev)
>  		return -ENODEV;
>  	}
> 
> -	netif_start_queue(dev);
>  	return 0;
>  }
> 
> @@ -300,8 +299,6 @@ static int lapbeth_close(struct net_device *dev)
>  {
>  	int err;
> 
> -	netif_stop_queue(dev);
> -
>  	if ((err = lapb_unregister(dev)) != LAPB_OK)
>  		pr_err("lapb_unregister error: %d\n", err);

Seems reasonable to me.

Acked-by: Martin Schiller <ms@dev.tdt.de>
