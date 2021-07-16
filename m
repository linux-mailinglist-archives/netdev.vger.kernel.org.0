Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1153CB3B2
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhGPIES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:04:18 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:36926 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbhGPIEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:04:16 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 1501B800056;
        Fri, 16 Jul 2021 10:01:21 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 10:01:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 16 Jul
 2021 10:01:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 228D33180299; Fri, 16 Jul 2021 10:01:20 +0200 (CEST)
Date:   Fri, 16 Jul 2021 10:01:19 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <0x7f454c46@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dima@arista.com>
Subject: Re: [PATCH] xfrm/compat: Fix general protection fault in
 xfrm_user_rcv_msg_compat()
Message-ID: <20210716080119.GC3684238@gauss3.secunet.de>
References: <20210712134002.34048-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210712134002.34048-1-yuehaibing@huawei.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 09:40:02PM +0800, YueHaibing wrote:
> In xfrm_user_rcv_msg_compat() if maxtype is not zero and less than
> XFRMA_MAX, nlmsg_parse_deprecated() do not initialize attrs array fully.
> xfrm_xlate32() will access uninit 'attrs[i]' while iterating all attrs
> array.
> 
> KASAN: probably user-memory-access in range [0x0000000041b58ab0-0x0000000041b58ab7]
> CPU: 0 PID: 15799 Comm: syz-executor.2 Tainted: G        W         5.14.0-rc1-syzkaller #0
> RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
> RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:410 [inline]
> RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:532 [inline]
> RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:577
> [...]
> Call Trace:
>  xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:702 [inline]
> 
> Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/xfrm/xfrm_compat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
> index a20aec9d7393..4738660cadea 100644
> --- a/net/xfrm/xfrm_compat.c
> +++ b/net/xfrm/xfrm_compat.c
> @@ -559,8 +559,8 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
>  	    (h32->nlmsg_flags & NLM_F_DUMP))
>  		return NULL;
>  
> -	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs,
> -			maxtype ? : XFRMA_MAX, policy ? : compat_policy, extack);
> +	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs, XFRMA_MAX,
> +				     policy ? : compat_policy, extack);

This removes the only usage of maxtype in that function. If we don't
need it, we should remove maxtype from the function parameters.

But looking closer at this, it seems that xfrm_xlate32() should
only iterate up to maxtype if set. Dimitry, any opinion on that?
