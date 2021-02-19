Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8D31FA3E
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 15:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhBSODD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 09:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhBSODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 09:03:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F272C061574;
        Fri, 19 Feb 2021 06:02:21 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lD6M4-00088D-SZ; Fri, 19 Feb 2021 15:02:00 +0100
Date:   Fri, 19 Feb 2021 15:02:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix incorrect types in assignment
Message-ID: <20210219140200.GG22944@breakpoint.cc>
References: <1613728134-66887-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613728134-66887-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:
> Fix the following sparse warnings:
> net/xfrm/xfrm_policy.c:1303:22: warning: incorrect type in assignment
> (different address spaces)
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  net/xfrm/xfrm_policy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index b74f28c..5c67407 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1225,7 +1225,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
>  	struct xfrm_policy *pol;
>  	struct xfrm_policy *policy;
>  	struct hlist_head *chain;
> -	struct hlist_head *odst;
> +	struct hlist_head __rcu *odst;

This doesn't look right.  Try something like

- odst = net->xfrm.policy_bydst[dir].table;
+ odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
			           lockdep_is_held(&net->xfrm.xfrm_policy_lock));
