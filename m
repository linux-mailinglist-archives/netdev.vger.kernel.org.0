Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B032E3A8C43
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFOXMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:12:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39508 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhFOXMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:12:39 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C02D521A57;
        Tue, 15 Jun 2021 23:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623798633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DW8AwZzTEcaEbwwzzx2Rih1SOND5HpnSHZDHpKtVpBE=;
        b=ru4Y1rH8p2ZF2joKPyqGQecZaxCTLSt6Tcu92GpabpoIx0dH+CisF0pIAy7Xxxu242p2hq
        5nElocF+8NJeR3u1z5d1XZdM6nP0CRQZ9AtsbhbOj1JAB5MbRr7EYdsMIK8zSuEoqgX9T3
        OX5eeW36Cn6CgA/l9Gl+Eg2j5HUY7mk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623798633;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DW8AwZzTEcaEbwwzzx2Rih1SOND5HpnSHZDHpKtVpBE=;
        b=BPsMy3vqnstthzeIwVWnlC9mge3HSnoxW9uUSSVyyWHVvgM514ezikuLnxdGgKOhkGboYC
        QtVVLPxd+k4AIgBA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B3D2CA3BA8;
        Tue, 15 Jun 2021 23:10:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6B562607D8; Wed, 16 Jun 2021 01:10:33 +0200 (CEST)
Date:   Wed, 16 Jun 2021 01:10:33 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RFC net-next] ethtool: add a stricter length check
Message-ID: <20210615231033.32opvfjz7hhha7zs@lion.mk-sys.cz>
References: <20210612031135.225292-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612031135.225292-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 08:11:35PM -0700, Jakub Kicinski wrote:
> There has been a few errors in the ethtool reply size calculations,
> most of those are hard to trigger during basic testing because of
> skb size rounding up and netdev names being shorter than max.
> Add a more precise check.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Michal, WDYT?

It's definitely an improvement and I agree with it. I only have two
minor comments below.

> 
>  net/ethtool/netlink.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 88d8a0243f35..3f9a1a96b4df 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -315,9 +315,9 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
>  	struct ethnl_req_info *req_info = NULL;
>  	const u8 cmd = info->genlhdr->cmd;
>  	const struct ethnl_request_ops *ops;
> +	int hdr_len, reply_len;
>  	struct sk_buff *rskb;
>  	void *reply_payload;
> -	int reply_len;
>  	int ret;
>  
>  	ops = ethnl_default_requests[cmd];
> @@ -346,15 +346,20 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
>  	ret = ops->reply_size(req_info, reply_data);
>  	if (ret < 0)
>  		goto err_cleanup;
> -	reply_len = ret + ethnl_reply_header_size();
> +	reply_len = ret;
>  	ret = -ENOMEM;
> -	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
> +	rskb = ethnl_reply_init(reply_len + ethnl_reply_header_size(),
> +				req_info->dev, ops->reply_cmd,
>  				ops->hdr_attr, info, &reply_payload);
>  	if (!rskb)
>  		goto err_cleanup;
> +	hdr_len = rskb->len;
>  	ret = ops->fill_reply(rskb, req_info, reply_data);
>  	if (ret < 0)
>  		goto err_msg;
> +	WARN(rskb->len - hdr_len > reply_len,
> +	     "ethnl cmd %d: calculated reply length %d, but consumed %d\n",
> +	     cmd, reply_len, rskb->len - hdr_len);
>  	if (ops->cleanup_data)
>  		ops->cleanup_data(reply_data);

We may want WARN_ONCE or ratelimited here, if there is bug in reply
length estimate for a request not requiring admin privileges, the
warning might be invoked by a regular user at will.

Also the patch changes the meaning of reply_len which is also used in
the original warning after err_msg label. But it's probably not a big
deal, it's not obvious what exactly "payload" means there so that anyone
trying to investigate the problem has to start by checking what exactly
the value reported means.

Michal
