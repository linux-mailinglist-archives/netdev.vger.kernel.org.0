Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33A614FF69
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 22:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgBBVau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 16:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgBBVat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 16:30:49 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31E72067C;
        Sun,  2 Feb 2020 21:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580679049;
        bh=ZQOaIkjXv+JNK/tgD9QQiopUZMQdGEeJFIvL1c4xmfc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mECmFWBdy2bnANGtth6hvJT18/H9BF1PCuzxnvy/5kUOOcjtwzfZyKi3G2ICfX+8W
         AGqj8Bs6njtg93FegZym/Ngl6x285JZFX6F9HPAXqIRW1K+4+hT/fdM/2qUQjZ4Og5
         L/XOx2+sI6FQkEsYkYqAGhmDWOnbxVJcaHqHl5NM=
Date:   Sun, 2 Feb 2020 13:30:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: fix an OOB access in cls_tcindex
Message-ID: <20200202133047.5deec0e2@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200202181950.18439-1-xiyou.wangcong@gmail.com>
References: <20200202181950.18439-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Feb 2020 10:19:50 -0800, Cong Wang wrote:
> As Eric noticed, tcindex_alloc_perfect_hash() uses cp->hash
> to compute the size of memory allocation, but cp->hash is
> set again after the allocation, this caused an out-of-bound
> access.
> 
> So we have to move all cp->hash initialization and computation
> before the memory allocation. Move cp->mask and cp->shift together
> as cp->hash may need them for computation.
> 
> Reported-and-tested-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
> Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/cls_tcindex.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 3d4a1280352f..2ba8c034fce8 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -333,6 +333,25 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	cp->fall_through = p->fall_through;
>  	cp->tp = tp;
>  
> +	if (tb[TCA_TCINDEX_HASH])
> +		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
> +
> +	if (tb[TCA_TCINDEX_MASK])
> +		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
> +
> +	if (tb[TCA_TCINDEX_SHIFT])
> +		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
> +
> +	if (!cp->hash) {
> +		/* Hash not specified, use perfect hash if the upper limit
> +		 * of the hashing index is below the threshold.
> +		 */
> +		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
> +			cp->hash = (cp->mask >> cp->shift) + 1;
> +		else
> +			cp->hash = DEFAULT_HASH_SIZE;
> +	}
> +
>  	if (p->perfect) {
>  		int i;
> 
		if (tcindex_alloc_perfect_hash(net, cp) < 0)
			goto errout;
		for (i = 0; i < cp->hash; i++)
			cp->perfect[i].res = p->perfect[i].res;
		balloc = 1;
	}

Wouldn't the loop be a problem now? cp->hash defaulted to previous
value - s/cp->hash/min(cp->hash, p->hash)/ ?

Also, unrelated, I think the jump to errout1 leaks cp->perfect and exts?
