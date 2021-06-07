Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B2F39DF3B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhFGOwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:52:15 -0400
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:37178 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230330AbhFGOwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:52:14 -0400
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id EB75ADE11;
        Mon,  7 Jun 2021 14:50:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id ECBE71A29F8;
        Mon,  7 Jun 2021 14:50:20 +0000 (UTC)
Message-ID: <3d1c10d4632451fb270a847acb320acefe2d019f.camel@perches.com>
Subject: Re: [PATCH net-next] vxlan: Return the correct errno code
From:   Joe Perches <joe@perches.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 07 Jun 2021 07:50:19 -0700
In-Reply-To: <20210607144422.2848809-1-zhengyongjun3@huawei.com>
References: <20210607144422.2848809-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.90
X-Stat-Signature: j978biwnn5y7k8fyzdhi5b1919jfzjp8
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: ECBE71A29F8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/3L6BQz5wIwlcwJM7FaUHzhg6Cy3peb8s=
X-HE-Tag: 1623077420-873776
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-07 at 22:44 +0800, Zheng Yongjun wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUFS.

Why?  Where in the call chain does it matter?
Have you inspected the entire call chain and their return value tests?

> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
[]
> @@ -711,11 +711,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
>  
> 
>  	rd = kmalloc(sizeof(*rd), GFP_ATOMIC);

And this should probably use kzalloc to avoid possible uninitialized members.

>  	if (rd == NULL)
> -		return -ENOBUFS;
> +		return -ENOMEM;
>  
>  	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
>  		kfree(rd);
> -		return -ENOBUFS;
> +		return -ENOMEM;
>  	}
>  
>  	rd->remote_ip = *ip;

The struct is:

include/net/vxlan.h:struct vxlan_rdst {
include/net/vxlan.h-    union vxlan_addr         remote_ip;
include/net/vxlan.h-    __be16                   remote_port;
include/net/vxlan.h-    u8                       offloaded:1;
include/net/vxlan.h-    __be32                   remote_vni;
include/net/vxlan.h-    u32                      remote_ifindex;
include/net/vxlan.h-    struct net_device        *remote_dev;
include/net/vxlan.h-    struct list_head         list;
include/net/vxlan.h-    struct rcu_head          rcu;
include/net/vxlan.h-    struct dst_cache         dst_cache;
include/net/vxlan.h-};

And the code is:

	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
		kfree(rd);
		return -ENOBUFS;
	}

	rd->remote_ip = *ip;
	rd->remote_port = port;
	rd->offloaded = false;
	rd->remote_vni = vni;
	rd->remote_ifindex = ifindex;

	list_add_tail_rcu(&rd->list, &f->remotes);

	*rdp = rd;

So it appears as if rd->remote_dev and rd->rcu are uninitialized.
I don't know if that matters, but it seems poor form.


