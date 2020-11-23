Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74212C163D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbgKWUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:13:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729527AbgKWUNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 15:13:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB27820717;
        Mon, 23 Nov 2020 20:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606162382;
        bh=CEQ2L2BYtixppgyzMZJaZ4Gkzuyqg9xXkHH8PHrHci8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q4FLlnhxAi2i4v6n6MJVkGLIrfm7k0tRE0PH+iTDlEO9zdN1JNxIXW9E277pjA1W/
         ft4/RPIkLSYmks/8oxdbeXNW4bD3RoO+7i+EOHmqMC3aytkd2hddZ3SwsSn5jAA6AK
         kTxKgpZ4mtKJJA7Nur1escY7gtKveyLsNBKi2Fio=
Date:   Mon, 23 Nov 2020 12:12:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     mingo@redhat.com, will@kernel.org, viro@zeniv.linux.org.uk,
        kyk.segfault@gmail.com, davem@davemloft.net, linmiaohe@huawei.com,
        martin.varghese@nokia.com, pabeni@redhat.com, pshelar@ovn.org,
        fw@strlen.de, gnault@redhat.com, steffen.klassert@secunet.com,
        vladimir.oltean@nxp.com, edumazet@google.com, saeed@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 1/2] lockdep: Introduce in_softirq lockdep
 assert
Message-ID: <20201123121259.312dcb82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123142725.GQ3021@hirez.programming.kicks-ass.net>
References: <1605927976-232804-1-git-send-email-linyunsheng@huawei.com>
        <1605927976-232804-2-git-send-email-linyunsheng@huawei.com>
        <20201123142725.GQ3021@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 15:27:25 +0100 Peter Zijlstra wrote:
> On Sat, Nov 21, 2020 at 11:06:15AM +0800, Yunsheng Lin wrote:
> > The current semantic for napi_consume_skb() is that caller need
> > to provide non-zero budget when calling from NAPI context, and
> > breaking this semantic will cause hard to debug problem, because
> > _kfree_skb_defer() need to run in atomic context in order to push
> > the skb to the particular cpu' napi_alloc_cache atomically.
> > 
> > So add the lockdep_assert_in_softirq() to assert when the running
> > context is not in_softirq, in_softirq means softirq is serving or
> > BH is disabled. Because the softirq context can be interrupted by
> > hard IRQ or NMI context, so lockdep_assert_in_softirq() need to
> > assert about hard IRQ or NMI context too.

> Due to in_softirq() having a deprication notice (due to it being
> awefully ambiguous), could we have a nice big comment here that explains
> in detail understandable to !network people (me) why this is actually
> correct?
> 
> I'm not opposed to the thing, if that his what you need, it's fine, but
> please put on a comment that explains that in_softirq() is ambiguous and
> when you really do need it anyway.

One liner would be:

	* Acceptable for protecting per-CPU resources accessed from BH
	
We can add:

	* Much like in_softirq() - semantics are ambiguous, use carefully. *


IIUC we basically want to protect the nc array and counter here:

static inline void _kfree_skb_defer(struct sk_buff *skb)
{
	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);

	/* drop skb->head and call any destructors for packet */
	skb_release_all(skb);

	/* record skb to CPU local list */
	nc->skb_cache[nc->skb_count++] = skb;

#ifdef CONFIG_SLUB
	/* SLUB writes into objects when freeing */
	prefetchw(skb);
#endif

	/* flush skb_cache if it is filled */
	if (unlikely(nc->skb_count == NAPI_SKB_CACHE_SIZE)) {
		kmem_cache_free_bulk(skbuff_head_cache, NAPI_SKB_CACHE_SIZE,
				     nc->skb_cache);
		nc->skb_count = 0;
	}
}

> > +#define lockdep_assert_in_softirq()					\
> > +do {									\
> > +	WARN_ON_ONCE(__lockdep_enabled			&&		\
> > +		     (!in_softirq() || in_irq() || in_nmi()));		\
> > +} while (0)
