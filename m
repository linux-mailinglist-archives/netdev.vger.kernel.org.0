Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745EF3C29C9
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGITq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGITq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 15:46:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 779BE613C5;
        Fri,  9 Jul 2021 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625859822;
        bh=ew3oJpBlC50NwRBuQF1i5T45r/21kLCR/MatGmU8eyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XPrZRmzJoyOUJw1vcICLqTEk9iZKZgwK5AWknpP7ZKlAcv0AFeAYMT6uSypKVvOym
         C7cOA9LEFdZ5IMrmZ41K6j1rTqOS1chJjIiDNZOrjpS4HH5TOcDkzfEsbIdB33OX0j
         uukuHQ8CbP4ZCzRD7nHOG1nR8UgrAui0tsqs4GnDbX+34AKsgzNYcd1Iik49+cpSFe
         oL1olqtMEILB4o8OzVyv0iHkHjYnjf27GMhboHW/TO+WaZRvBkGeJr4SqSBlSwe+oA
         4G8r2anjfbSGEydcuoq11MzLUccCViMxqgXISiXoYEfu9J38+SNBk0haqeXIYThnOi
         8XrBJGL4p+nEg==
Date:   Fri, 9 Jul 2021 12:43:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        bpf@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] xdp, net: fix use-after-free in
 bpf_xdp_link_release
Message-ID: <20210709124340.44bafef1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210709025525.107314-1-xuanzhuo@linux.alibaba.com>
References: <20210709025525.107314-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Jul 2021 10:55:25 +0800 Xuan Zhuo wrote:
> The problem occurs between dev_get_by_index() and dev_xdp_attach_link().
> At this point, dev_xdp_uninstall() is called. Then xdp link will not be
> detached automatically when dev is released. But link->dev already
> points to dev, when xdp link is released, dev will still be accessed,
> but dev has been released.
> 
> dev_get_by_index()        |
> link->dev = dev           |
>                           |      rtnl_lock()
>                           |      unregister_netdevice_many()
>                           |          dev_xdp_uninstall()
>                           |      rtnl_unlock()
> rtnl_lock();              |
> dev_xdp_attach_link()     |
> rtnl_unlock();            |
>                           |      netdev_run_todo() // dev released
> bpf_xdp_link_release()    |
>     /* access dev.        |
>        use-after-free */  |
> 
> This patch adds a check of dev->reg_state in dev_xdp_attach_link(). If
> dev has been called release, it will return -EINVAL.

Please make sure to include a Fixes tag.

I must say I prefer something closet to v1. Maybe put the if
in the callee? Making ndo calls to unregistered netdevs is 
not legit, it will be confusing for a person reading this 
code to have to search callees to find where unregistered 
netdevs are rejected.

> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..63c9a46ca853 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9544,6 +9544,10 @@ static int dev_xdp_attach_link(struct net_device *dev,
>  			       struct netlink_ext_ack *extack,
>  			       struct bpf_xdp_link *link)
>  {
> +	/* ensure the dev state is ok */
> +	if (dev->reg_state != NETREG_REGISTERED)
> +		return -EINVAL;
> +
>  	return dev_xdp_attach(dev, extack, link, NULL, NULL, link->flags);
>  }
