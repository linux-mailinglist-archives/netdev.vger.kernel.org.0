Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED67A28A99A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgJKTSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgJKTSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 15:18:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEBD62078A;
        Sun, 11 Oct 2020 19:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602443885;
        bh=HhlBchMur5+dR0BQIrVbePlgVQWliYk8BEnEPi2xzLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ycxvxyjEAlRr3NUMTzWuXph28DNOB/LCA9i+XOyWvL/n4gP6ZkXh1QPXUOqKpJmwZ
         wccrPrD1m18L0j6kWuwNCaDU1FlpwIxdi/NOZWXmBQ+DEzMiy8DXf1UGHMFf6CjBmG
         tN3/PCiMcj7H+mZvlrq2D0JKUWp73syzncXMyeHQ=
Date:   Sun, 11 Oct 2020 12:18:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xianting Tian <tian.xianting@h3c.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Avoid allocing memory on memoryless numa node
Message-ID: <20201011121803.2c003c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011041140.8945-1-tian.xianting@h3c.com>
References: <20201011041140.8945-1-tian.xianting@h3c.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 12:11:40 +0800 Xianting Tian wrote:
> In architecture like powerpc, we can have cpus without any local memory
> attached to it. In such cases the node does not have real memory.
> 
> Use local_memory_node(), which is guaranteed to have memory.
> local_memory_node is a noop in other architectures that does not support
> memoryless nodes.
> 
> Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 266073e30..dcb4533ef 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2590,7 +2590,7 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
>  		new_map = kzalloc(XPS_MAP_SIZE(alloc_len), GFP_KERNEL);
>  	else
>  		new_map = kzalloc_node(XPS_MAP_SIZE(alloc_len), GFP_KERNEL,
> -				       cpu_to_node(attr_index));
> +				       local_memory_node(cpu_to_node(attr_index)));
>  	if (!new_map)
>  		return NULL;
>  

Are we going to patch all kmalloc_node() callers now to apply
local_memory_node()?  Can't the allocator take care of this?

