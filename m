Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED1C2AE3EC
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731946AbgKJXTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKJXTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:19:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57BA20679;
        Tue, 10 Nov 2020 23:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050344;
        bh=aNEbJ3PUMk0qQBTyGA2GxAgsVjk9T5/7oeE8k22BxMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qnFgUlpFrH76lAAVroSAi0RdWFuVJn9shN2xQRSI6LEItFEzlOsS6+gpUeHR74712
         wiLx4a7TMzVl38Yc6fBVWVKaCBftCtrgPm4ET0cifUA0eZ4CXyEbXq2up/+JhgZkEp
         ToWUnlLi+YjzXGH4iQCH1Pj3legy5s+LJlWCT0ZA=
Date:   Tue, 10 Nov 2020 15:18:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next v2 3/3] net: evaluate
 net.ipvX.conf.all.disable_policy and disable_xfrm
Message-ID: <20201110151857.0da8a9f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107193515.1469030-4-vincent@bernat.ch>
References: <20201107193515.1469030-1-vincent@bernat.ch>
        <20201107193515.1469030-4-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 20:35:15 +0100 Vincent Bernat wrote:
> The disable_policy and disable_xfrm are a per-interface sysctl to
> disable IPsec policy or encryption on an interface. However, while a
> "all" variant is exposed, it was a noop since it was never evaluated.
> We use the usual "or" logic for this kind of sysctls.
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>

CC Steffen

> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index dc2a399cd9f4..a3b60c41cbad 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1741,7 +1741,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
>  		flags |= RTCF_LOCAL;
>  
>  	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
> -			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
> +			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
>  	if (!rth)
>  		return -ENOBUFS;
>  
> @@ -1857,8 +1857,8 @@ static int __mkroute_input(struct sk_buff *skb,
>  	}
>  
>  	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
> -			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
> -			   IN_DEV_CONF_GET(out_dev, NOXFRM));
> +			   IN_DEV_ORCONF(in_dev, NOPOLICY),
> +			   IN_DEV_ORCONF(out_dev, NOXFRM));
>  	if (!rth) {
>  		err = -ENOBUFS;
>  		goto cleanup;
> @@ -2227,7 +2227,7 @@ out:	return err;
>  
>  	rth = rt_dst_alloc(l3mdev_master_dev_rcu(dev) ? : net->loopback_dev,
>  			   flags | RTCF_LOCAL, res->type,
> -			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
> +			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
>  	if (!rth)
>  		goto e_nobufs;
>  
> @@ -2450,8 +2450,8 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
>  
>  add:
>  	rth = rt_dst_alloc(dev_out, flags, type,
> -			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
> -			   IN_DEV_CONF_GET(in_dev, NOXFRM));
> +			   IN_DEV_ORCONF(in_dev, NOPOLICY),
> +			   IN_DEV_ORCONF(in_dev, NOXFRM));
>  	if (!rth)
>  		return ERR_PTR(-ENOBUFS);
>  

