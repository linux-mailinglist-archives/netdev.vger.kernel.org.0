Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8710FF01
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 14:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfLCNmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 08:42:31 -0500
Received: from mx01-fr.bfs.de ([193.174.231.67]:18570 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfLCNmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 08:42:31 -0500
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id 69DCA20321;
        Tue,  3 Dec 2019 14:42:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1575380545; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zTrdGdcdKAaJuFODTrzP2KCZ1YSOb/GviD8pdPVM5pM=;
        b=DT8PXpnOOCWJdd8tlABC6YIWcanBJmmhfohIt62je7d8mRfsZPjNo0PhXKP4ys1RlVD0UE
        y9A4oiHQbwg6kR12IkVB05eYhN+1op/CqPz8hQilZQZMZqY4L0Nc41VLPkDp0Mzpv6wBFN
        E7YC5yKx/zpVDZDJKD3yxZNeU3802R/q7o2UeFnpvz3VP7jU2AhNgZLSvnf2G/ZkNoXGaz
        GU21DkZzKDmeVnOjhD0BgOeyqCaj4eELJi/iOxLCGLPZPUv0sS1ldQtlFxZqAjDfrtxKqb
        IcNVX/ZHy8/aWZfXz2hUGskXONUB7fxRP4/dkj+ZCiuVvtBBPXfCpQTAmBUZKQ==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id 4CE28BEEBD;
        Tue,  3 Dec 2019 14:42:24 +0100 (CET)
Message-ID: <5DE6663F.40803@bfs.de>
Date:   Tue, 03 Dec 2019 14:42:23 +0100
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: fix a leak in register_netdevice()
References: <20191203130011.wzzwdi5sebevkenj@kili.mountain>
In-Reply-To: <20191203130011.wzzwdi5sebevkenj@kili.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.10
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-3.10 / 7.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         MIME_GOOD(-0.10)[text/plain];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWELVE(0.00)[12];
         NEURAL_HAM(-0.00)[-0.999,0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_TLS_ALL(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 03.12.2019 14:00, schrieb Dan Carpenter:
> We have to free "dev->name_node" on this error path.
> 
> Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> Reported-by: syzbot+6e13e65ffbaa33757bcb@syzkaller.appspotmail.com
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/core/dev.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d75fd04d4e2c..9cc4b193d8c4 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9246,7 +9246,7 @@ int register_netdevice(struct net_device *dev)
>  		if (ret) {
>  			if (ret > 0)
>  				ret = -EIO;
> -			goto out;
> +			goto err_free_name;
>  		}
>  	}
>  
> @@ -9361,12 +9361,13 @@ int register_netdevice(struct net_device *dev)
>  	return ret;
>  
>  err_uninit:
> -	if (dev->name_node)
> -		netdev_name_node_free(dev->name_node);
>  	if (dev->netdev_ops->ndo_uninit)
>  		dev->netdev_ops->ndo_uninit(dev);
>  	if (dev->priv_destructor)
>  		dev->priv_destructor(dev);
> +err_free_name:
> +	if (dev->name_node)
> +		netdev_name_node_free(dev->name_node);
>  	goto out;
>  }
>  EXPORT_SYMBOL(register_netdevice);

nitpick:
netdev_name_node_free() is a wrapper for kfree().
no need to check dev->name_node.

jm2c

re,
 wh
