Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F222C4B5A
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbgKYXMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:12:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbgKYXMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 18:12:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66B042083E;
        Wed, 25 Nov 2020 23:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606345921;
        bh=7epGg0rx1YzbAsegltrvV6e2Wg9WVWnPf6SHCciMmNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lqrk0sxae49CsQ+n0cf099ZVuWnxrK9BJu+ru8YJZ5uJKmzpDVcDEBvFgVhLzSBi3
         z9ymSTwpXQa+EwH5BGihg1tb/Mvl3PkWbRoE0KMUBpIJ7i5M+FqzERkZbc/ARuDfk6
         gOkQBw95Jdzg9LLBpZYyPnFpx7JhgT8wiQ6UD48E=
Date:   Wed, 25 Nov 2020 15:11:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <peterz@infradead.org>, <mingo@redhat.com>, <will@kernel.org>,
        <viro@zeniv.linux.org.uk>, <kyk.segfault@gmail.com>,
        <davem@davemloft.net>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH net-next v3 1/2] lockdep: Introduce in_softirq lockdep
 assert
Message-ID: <20201125151159.0de99e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1606214969-97849-2-git-send-email-linyunsheng@huawei.com>
References: <1606214969-97849-1-git-send-email-linyunsheng@huawei.com>
        <1606214969-97849-2-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:49:28 +0800 Yunsheng Lin wrote:
> The current semantic for napi_consume_skb() is that caller need
> to provide non-zero budget when calling from NAPI context, and
> breaking this semantic will cause hard to debug problem, because
> _kfree_skb_defer() need to run in atomic context in order to push
> the skb to the particular cpu' napi_alloc_cache atomically.
> 
> So add the lockdep_assert_in_softirq() to assert when the running
> context is not in_softirq, in_softirq means softirq is serving or
> BH is disabled, which has a ambiguous semantics due to the BH
> disabled confusion, so add a comment to emphasize that.
> 
> And the softirq context can be interrupted by hard IRQ or NMI
> context, lockdep_assert_in_softirq() need to assert about hard
> IRQ or NMI context too.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V3: add comment to emphasize the ambiguous semantics.
> ---
>  include/linux/lockdep.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index f559487..8d60f46 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -594,6 +594,13 @@ do {									\
>  		      this_cpu_read(hardirqs_enabled)));		\
>  } while (0)
>  
> +/* Much like in_softirq() - semantics are ambiguous, use carefully. */

I've added both of the comments I suggested in the reply to Peter here
and applied to net-next.

Thanks for working on this.

> +#define lockdep_assert_in_softirq()					\
> +do {									\
> +	WARN_ON_ONCE(__lockdep_enabled			&&		\
> +		     (!in_softirq() || in_irq() || in_nmi()));		\
> +} while (0)

