Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F14133DE1
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgAHJIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:08:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:49282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbgAHJId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 04:08:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E696AFB0;
        Wed,  8 Jan 2020 09:08:32 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D23A5E008B; Wed,  8 Jan 2020 10:08:31 +0100 (CET)
Date:   Wed, 8 Jan 2020 10:08:31 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: fix ->reply_size() error handling
Message-ID: <20200108090831.GK22387@unicorn.suse.cz>
References: <20200108054125.feeckqg6xhab3wam@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108054125.feeckqg6xhab3wam@kili.mountain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 08:41:25AM +0300, Dan Carpenter wrote:
> The "ret < 0" comparison is never true because "ret" is still zero.
> 
> Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/ethtool/netlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 5d16436498ac..86b79f9bc08d 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -319,9 +319,10 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
>  	rtnl_unlock();
>  	if (ret < 0)
>  		goto err_cleanup;
> -	reply_len = ops->reply_size(req_info, reply_data);
> +	ret = ops->reply_size(req_info, reply_data);
>  	if (ret < 0)
>  		goto err_cleanup;
> +	reply_len = ret;
>  	ret = -ENOMEM;
>  	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
>  				ops->hdr_attr, info, &reply_payload);
> @@ -555,9 +556,10 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
>  	ret = ops->prepare_data(req_info, reply_data, NULL);
>  	if (ret < 0)
>  		goto err_cleanup;
> -	reply_len = ops->reply_size(req_info, reply_data);
> +	ret = ops->reply_size(req_info, reply_data);
>  	if (ret < 0)
>  		goto err_cleanup;
> +	reply_len = ret;
>  	ret = -ENOMEM;
>  	skb = genlmsg_new(reply_len, GFP_KERNEL);
>  	if (!skb)

Thank you.

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
