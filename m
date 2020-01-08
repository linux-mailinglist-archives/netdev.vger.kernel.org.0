Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7432133DD2
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgAHJGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:06:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:47748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgAHJGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 04:06:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5A333AF38;
        Wed,  8 Jan 2020 09:06:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D3664E008B; Wed,  8 Jan 2020 10:06:45 +0100 (CET)
Date:   Wed, 8 Jan 2020 10:06:45 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: fix a memory leak in
 ethnl_default_start()
Message-ID: <20200108090645.GJ22387@unicorn.suse.cz>
References: <20200108053947.776s3sp3op6v7a6r@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108053947.776s3sp3op6v7a6r@kili.mountain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 08:39:48AM +0300, Dan Carpenter wrote:
> If ethnl_default_parse() fails then we need to free a couple
> memory allocations before returning.
> 
> Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/ethtool/netlink.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 4ca96c7b86b3..5d16436498ac 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -472,8 +472,8 @@ static int ethnl_default_start(struct netlink_callback *cb)
>  		return -ENOMEM;
>  	reply_data = kmalloc(ops->reply_data_size, GFP_KERNEL);
>  	if (!reply_data) {
> -		kfree(req_info);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto free_req_info;
>  	}

We could avoid the block statement by setting ret unconditionally but
this is OK.
>  
>  	ret = ethnl_default_parse(req_info, cb->nlh, sock_net(cb->skb->sk), ops,
> @@ -487,7 +487,7 @@ static int ethnl_default_start(struct netlink_callback *cb)
>  		req_info->dev = NULL;
>  	}
>  	if (ret < 0)
> -		return ret;
> +		goto free_reply_data;
>  
>  	ctx->ops = ops;
>  	ctx->req_info = req_info;
> @@ -496,6 +496,13 @@ static int ethnl_default_start(struct netlink_callback *cb)
>  	ctx->pos_idx = 0;
>  
>  	return 0;
> +
> +free_reply_data:
> +	kfree(reply_data);
> +free_req_info:
> +	kfree(req_info);
> +
> +	return ret;
>  }
>  
>  /* default ->done() handler for GET requests */

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
