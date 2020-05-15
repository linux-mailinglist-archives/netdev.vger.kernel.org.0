Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE21D4273
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEOAx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgEOAx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:53:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D265C061A0C;
        Thu, 14 May 2020 17:53:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28DE814DB4EA4;
        Thu, 14 May 2020 17:53:56 -0700 (PDT)
Date:   Thu, 14 May 2020 17:53:55 -0700 (PDT)
Message-Id: <20200514.175355.167885308958584692.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipv6: symbol_get to access a sit symbol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514145101.3000612-5-hch@lst.de>
References: <20200514145101.3000612-1-hch@lst.de>
        <20200514145101.3000612-5-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:53:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 14 May 2020 16:51:01 +0200

> Instead of going through the ioctl handler from kernel space, use
> symbol_get to the newly factored out ipip6_set_dstaddr helper, bypassing
> addrconf.c entirely.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
 ...
> -		memset(&p, 0, sizeof(p));
> -		p.iph.daddr = ireq.ifr6_addr.s6_addr32[3];
> -		p.iph.saddr = 0;
> -		p.iph.version = 4;
> -		p.iph.ihl = 5;
> -		p.iph.protocol = IPPROTO_IPV6;
> -		p.iph.ttl = 64;
> -		ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
> -
> -		if (ops->ndo_do_ioctl) {
> -			mm_segment_t oldfs = get_fs();
> -
> -			set_fs(KERNEL_DS);
> -			err = ops->ndo_do_ioctl(dev, &ifr, SIOCADDTUNNEL);
> -			set_fs(oldfs);
> -		} else
> -			err = -EOPNOTSUPP;
 ...
> +	p.iph.daddr = ireq.ifr6_addr.s6_addr32[3];
> +	p.iph.version = 4;
> +	p.iph.ihl = 5;
> +	p.iph.protocol = IPPROTO_IPV6;
> +	p.iph.ttl = 64;
> +	p.iph.frag_off |= htons(IP_DF);
> +
> +	err = -ENOBUFS;
> +	if (!ipip6_tunnel_locate(dev_net(tunnel_dev), &p, true))
> +		goto out_unlock;

You're not undoing one, but two levels of abstraction here.

Is this "ipip6_tunnel_locate()" call part of the SIT ioctl implementation?
Where did it come from?   Why are ->ndo_do_ioctl() implementations no longer
allowed from here?

Honestly, this feels like a bit much.
