Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5202B8157
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgKRP6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgKRP6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:58:33 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2D1C0613D4;
        Wed, 18 Nov 2020 07:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GOzh1Hc0R1jOyAk5KDQ96c8P+a7sxOoxzcRvNbeKPUI=; b=At2O//XLDIexF2NGZbUhn7yyVa
        +Zc9ZMWhA/asE2jZ/Hch0edDH/Zna/j/o1WqR7l8RLKVAH8ePaNx4axvv+k7bpbXGe0IQl+oScGBj
        Yfgq0caBcZKqhYlyqWHQWdkBtq3PrCHWU/HDpK1nYKz0KTGa9hcLnHqsLS/X7/c42Yc5JeKyJlgja
        /EjYzWcLx55nvYWqznQ0SaVk9G8WXbDxYMPqE+pNSVUD6QY+P4d6UO5d9XmWukc4nRetjpHHg/nCO
        gEIBd2CvRvhEusc/MVzi51XIhlp9GE6mtn6qmLLGBKOiAmNIIFkJOcq46u06JI83Wh1DZLJrfkH8t
        b6Lchzpg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfPqJ-0008Ad-LJ; Wed, 18 Nov 2020 15:57:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 557E83019CE;
        Wed, 18 Nov 2020 16:57:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 115AF235C0B18; Wed, 18 Nov 2020 16:57:57 +0100 (CET)
Date:   Wed, 18 Nov 2020 16:57:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        linmiaohe@huawei.com, martin.varghese@nokia.com, pabeni@redhat.com,
        pshelar@ovn.org, fw@strlen.de, gnault@redhat.com,
        steffen.klassert@secunet.com, kyk.segfault@gmail.com,
        viro@zeniv.linux.org.uk, vladimir.oltean@nxp.com,
        edumazet@google.com, saeed@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: add in_softirq() debug checking in
 napi_consume_skb()
Message-ID: <20201118155757.GY3121392@hirez.programming.kicks-ass.net>
References: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
 <20201031153824.7ae83b90@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b04ad33-1611-8d7b-8fec-4269c01ecab3@huawei.com>
 <20201102114110.4a20d461@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5bd6de52-b8e0-db6f-3362-862ae7b2c728@huawei.com>
 <20201118074348.3bbd1468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118074348.3bbd1468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 07:43:48AM -0800, Jakub Kicinski wrote:

> TBH the last sentence I wrote isn't clear even to me at this point ;D
> 
> Maybe using just the macros from preempt.h - like this?
> 
> #define lockdep_assert_in_softirq()                                    \
> do {                                                                   \
>        WARN_ON_ONCE(__lockdep_enabled                  &&              \
>                     (!in_softirq() || in_irq() || in_nmi())	\
> } while (0)
> 
> We know what we're doing so in_softirq() should be fine (famous last
> words).

So that's not actually using any lockdep state. But if that's what you
need, I don't have any real complaints.
