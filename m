Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6649E2C0DA7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388741AbgKWO1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730051AbgKWO1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:27:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E34C0613CF;
        Mon, 23 Nov 2020 06:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G5TiL5qRosiCjm5yYQO1p4g/3Rt2+qNua4GF7ajhFoQ=; b=tTwMoZGoco4y8lPfjEAxWPEm/c
        XyzjBBxM4QoYiQKbA5wqRKhGG3OTSVJbEFVbLJ82v530HLJe2/smGuUPAriB/biMUPQH+Rqu7wIqv
        X+DgPik+ymoYPKYXMn3hIuVIQho1rN2jS4l9R0vCxTE6KCKlesfaEGglvtE0zt9X+DBbfv9pG89SX
        /XzIXK0QDkqVMigKqWHofxDQVTQOWUv3GrpCPGmTVfkzdakeGozVJc4KRrtjyIudCRoqb2lrMFYBY
        H+zHmSWjuvGnBEA+nIvpGJ8wnc7ylSHH2tTl1SGiWBXk7WIH4ZTQ+JnJMFKs9doDvprcusnvvgjqR
        7Fgr4i6A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khCoQ-0000AK-LG; Mon, 23 Nov 2020 14:27:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A03C5300DAE;
        Mon, 23 Nov 2020 15:27:25 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 59BD5200FC0F6; Mon, 23 Nov 2020 15:27:25 +0100 (CET)
Date:   Mon, 23 Nov 2020 15:27:25 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     mingo@redhat.com, will@kernel.org, viro@zeniv.linux.org.uk,
        kyk.segfault@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linmiaohe@huawei.com, martin.varghese@nokia.com, pabeni@redhat.com,
        pshelar@ovn.org, fw@strlen.de, gnault@redhat.com,
        steffen.klassert@secunet.com, vladimir.oltean@nxp.com,
        edumazet@google.com, saeed@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 1/2] lockdep: Introduce in_softirq lockdep
 assert
Message-ID: <20201123142725.GQ3021@hirez.programming.kicks-ass.net>
References: <1605927976-232804-1-git-send-email-linyunsheng@huawei.com>
 <1605927976-232804-2-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605927976-232804-2-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 11:06:15AM +0800, Yunsheng Lin wrote:
> The current semantic for napi_consume_skb() is that caller need
> to provide non-zero budget when calling from NAPI context, and
> breaking this semantic will cause hard to debug problem, because
> _kfree_skb_defer() need to run in atomic context in order to push
> the skb to the particular cpu' napi_alloc_cache atomically.
> 
> So add the lockdep_assert_in_softirq() to assert when the running
> context is not in_softirq, in_softirq means softirq is serving or
> BH is disabled. Because the softirq context can be interrupted by
> hard IRQ or NMI context, so lockdep_assert_in_softirq() need to
> assert about hard IRQ or NMI context too.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/lockdep.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index f559487..f5e3d81 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -594,6 +594,12 @@ do {									\
>  		      this_cpu_read(hardirqs_enabled)));		\
>  } while (0)

Due to in_softirq() having a deprication notice (due to it being
awefully ambiguous), could we have a nice big comment here that explains
in detail understandable to !network people (me) why this is actually
correct?

I'm not opposed to the thing, if that his what you need, it's fine, but
please put on a comment that explains that in_softirq() is ambiguous and
when you really do need it anyway.

> +#define lockdep_assert_in_softirq()					\
> +do {									\
> +	WARN_ON_ONCE(__lockdep_enabled			&&		\
> +		     (!in_softirq() || in_irq() || in_nmi()));		\
> +} while (0)
> +
>  #else
>  # define might_lock(lock) do { } while (0)
>  # define might_lock_read(lock) do { } while (0)
> @@ -605,6 +611,7 @@ do {									\
>  
>  # define lockdep_assert_preemption_enabled() do { } while (0)
>  # define lockdep_assert_preemption_disabled() do { } while (0)
> +# define lockdep_assert_in_softirq() do { } while (0)
>  #endif
>  
>  #ifdef CONFIG_PROVE_RAW_LOCK_NESTING
> -- 
> 2.8.1
> 
