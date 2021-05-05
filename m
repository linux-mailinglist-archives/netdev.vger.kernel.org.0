Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFD63749ED
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 23:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhEEVKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 17:10:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:42220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233512AbhEEVKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 17:10:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F1F5AF4E;
        Wed,  5 May 2021 21:09:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E219D602DC; Wed,  5 May 2021 23:09:19 +0200 (CEST)
Date:   Wed, 5 May 2021 23:09:19 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netdev@vger.kernel.org, atenart@kernel.org
Subject: Re: [PATCH net] ethtool: fix missing NLM_F_MULTI flag when dumping
Message-ID: <20210505210919.ronrecenr3qrfuuf@lion.mk-sys.cz>
References: <20210504224714.7632-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504224714.7632-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:47:14AM +0200, Fernando Fernandez Mancera wrote:
> When dumping the ethtool information from all the interfaces, the
> netlink reply should contain the NLM_F_MULTI flag. This flag allows
> userspace tools to identify that multiple messages are expected.
> 
> Link: https://bugzilla.redhat.com/1953847
> Fixes: 365f9ae ("ethtool: fix genlmsg_put() failure handling in ethnl_default_dumpit()")

For the record, the issue was not introduced by this commit, this commit
only moved the genlmsg_put() call from ethnl_default_dumpit() into
ethnl_default_dump_one() but genlmsg_put() was called with zero flags
since the code was introduced by commit 728480f12442 ("ethtool: default
handlers for GET requests").

But as the patch has been applied already, it doesn't matter any more.

Michal

> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  net/ethtool/netlink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 290012d0d11d..88d8a0243f35 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -387,7 +387,8 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
>  	int ret;
>  
>  	ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> -			   &ethtool_genl_family, 0, ctx->ops->reply_cmd);
> +			   &ethtool_genl_family, NLM_F_MULTI,
> +			   ctx->ops->reply_cmd);
>  	if (!ehdr)
>  		return -EMSGSIZE;
>  
> -- 
> 2.20.1
> 
