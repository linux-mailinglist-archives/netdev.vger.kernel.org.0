Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335222A1B10
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 23:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgJaWi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 18:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaWi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 18:38:26 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1613D20719;
        Sat, 31 Oct 2020 22:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604183905;
        bh=22+XWVE26AhRs1ATiUQztPuiQNPVAFxkCPBkr1AvdfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJwKK8sOG7Kd0VHV30Ejk6H5rDljP4ijShealUmhN2FECtx5jSyZxGW5H6fj8bi+A
         KnaMI+xlH78OW3kUW5ztbP3KbmTfCPxPbcVEjXHWA3jrZNFThl4Q+Z3j3MIvGGS8og
         KXdV5D5QyIr7sHkbOPE+7v+g80n+lBQxpdmiQurU=
Date:   Sat, 31 Oct 2020 15:38:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <kyk.segfault@gmail.com>,
        <viro@zeniv.linux.org.uk>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH net-next] net: add in_softirq() debug checking in
 napi_consume_skb()
Message-ID: <20201031153824.7ae83b90@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
References: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 19:34:48 +0800 Yunsheng Lin wrote:
> The current semantic for napi_consume_skb() is that caller need
> to provide non-zero budget when calling from NAPI context, and
> breaking this semantic will cause hard to debug problem, because
> _kfree_skb_defer() need to run in atomic context in order to push
> the skb to the particular cpu' napi_alloc_cache atomically.
> 
> So add a in_softirq() debug checking in napi_consume_skb() to catch
> this kind of error.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1ba8f01..1834007 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -897,6 +897,10 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
>  		return;
>  	}
>  
> +	DEBUG_NET_WARN(!in_softirq(),
> +		       "%s is called with non-zero budget outside softirq context.\n",
> +		       __func__);

Can't we use lockdep instead of defining our own knobs?

Like this maybe?

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f5594879175a..5253a167d00c 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -594,6 +594,14 @@ do {                                                                       \
                      this_cpu_read(hardirqs_enabled)));                \
 } while (0)
 
+#define lockdep_assert_in_softirq()                                    \
+do {                                                                   \
+       WARN_ON_ONCE(__lockdep_enabled                  &&              \
+                    (softirq_count() == 0              ||              \
+                     this_cpu_read(hardirq_context)));                 \
+} while (0)



>  	if (!skb_unref(skb))
>  		return;
>  

