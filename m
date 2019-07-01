Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAB5B76A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfGAJDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:03:54 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35984 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbfGAJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:03:54 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hhsDx-0003VJ-JJ; Mon, 01 Jul 2019 11:03:45 +0200
Date:   Mon, 1 Jul 2019 11:03:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: use list_for_each_entry_safe in xfrm_policy_flush
Message-ID: <20190701090345.fkd7lrecicrewpnt@breakpoint.cc>
References: <1561969747-8629-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561969747-8629-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li RongQing <lirongqing@baidu.com> wrote:
> The iterated pol maybe be freed since it is not protected
> by RCU or spinlock when put it, lead to UAF, so use _safe
> function to iterate over it against removal
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  net/xfrm/xfrm_policy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 3235562f6588..87d770dab1f5 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1772,7 +1772,7 @@ xfrm_policy_flush_secctx_check(struct net *net, u8 type, bool task_valid)
>  int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
>  {
>  	int dir, err = 0, cnt = 0;
> -	struct xfrm_policy *pol;
> +	struct xfrm_policy *pol, *tmp;
>  
>  	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
>  
> @@ -1781,7 +1781,7 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
>  		goto out;
>  
>  again:
> -	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
> +	list_for_each_entry_safe(pol, tmp, &net->xfrm.policy_all, walk.all) {
>  		dir = xfrm_policy_id2dir(pol->index);
>  		if (pol->walk.dead ||
>  		    dir >= XFRM_POLICY_MAX ||

This function drops the lock, but after re-acquire jumps to the 'again'
label, so I do not see the UAF as the entire loop gets restarted.
