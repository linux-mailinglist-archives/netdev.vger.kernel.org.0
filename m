Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472C72B91CB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 12:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgKSLrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 06:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgKSLmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 06:42:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CF7C0617A7;
        Thu, 19 Nov 2020 03:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z2wOlmDrz/QfDBFn6ctWN3OgjQZgcVppTZgX8Pi6wGw=; b=co0OjL/MI1Wj9zjx2cJrcNvsU5
        R6Y69/TFYkDr9yE5TOSz/Lqu8cu/qMXc8DeMSupBdLz9EiLkMyHOqQn5JZ8KMswn7JwMXloOHNDDh
        An1mXtVjEZxwi9MXuhv9zWEWy9qv+7iN7BeOumB4D9g+1Aff4Ojk+/LyyIbnvIaMi9XvbwOeCXByl
        bb4YD2+xUY54Hq9h2IMD/T2iFRCUiDr7/g+dWKaUQ2I8VMK+rGIe7YJhA7TLJNu/iLhWJSbpl3gi2
        2aq8h4BEZm1zuQAggSLFmHUcOIw6DaUKqyp01IhvG4jPB/YFlgGpuWYhe5j5ETqZhZ/fo5crvUwKg
        fRI42W3A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfiJz-0006HH-Dw; Thu, 19 Nov 2020 11:41:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1E0693069B1;
        Thu, 19 Nov 2020 12:41:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C85A02C0AB058; Thu, 19 Nov 2020 12:41:49 +0100 (CET)
Date:   Thu, 19 Nov 2020 12:41:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        linmiaohe@huawei.com, martin.varghese@nokia.com, pabeni@redhat.com,
        pshelar@ovn.org, fw@strlen.de, gnault@redhat.com,
        steffen.klassert@secunet.com, kyk.segfault@gmail.com,
        viro@zeniv.linux.org.uk, vladimir.oltean@nxp.com,
        edumazet@google.com, saeed@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: add in_softirq() debug checking in
 napi_consume_skb()
Message-ID: <20201119114149.GI3121392@hirez.programming.kicks-ass.net>
References: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
 <20201031153824.7ae83b90@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b04ad33-1611-8d7b-8fec-4269c01ecab3@huawei.com>
 <20201102114110.4a20d461@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5bd6de52-b8e0-db6f-3362-862ae7b2c728@huawei.com>
 <20201118074348.3bbd1468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201118155757.GY3121392@hirez.programming.kicks-ass.net>
 <20201118082658.2aa41190@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <b00f1c28-668c-ecdb-6aa7-282e57475e25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b00f1c28-668c-ecdb-6aa7-282e57475e25@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:19:44PM +0800, Yunsheng Lin wrote:
> On 2020/11/19 0:26, Jakub Kicinski wrote:
> > On Wed, 18 Nov 2020 16:57:57 +0100 Peter Zijlstra wrote:
> >> On Wed, Nov 18, 2020 at 07:43:48AM -0800, Jakub Kicinski wrote:
> >>
> >>> TBH the last sentence I wrote isn't clear even to me at this point ;D
> >>>
> >>> Maybe using just the macros from preempt.h - like this?
> >>>
> >>> #define lockdep_assert_in_softirq()                                    \
> >>> do {                                                                   \
> >>>        WARN_ON_ONCE(__lockdep_enabled                  &&              \
> >>>                     (!in_softirq() || in_irq() || in_nmi())	\
> >>> } while (0)
> 
> One thing I am not so sure about is the different irq context indicator
> in preempt.h and lockdep.h, for example lockdep_assert_in_irq() uses
> this_cpu_read(hardirq_context) in lockdep.h, and in_irq() uses
> current_thread_info()->preempt_count in preempt.h, if they are the same
> thing?

Very close, for more regular code they should be the same.
