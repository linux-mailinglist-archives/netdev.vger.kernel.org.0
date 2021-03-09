Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A6332884
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCIOYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCIOYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:24:22 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C38BC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 06:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ke/OC38zqvFyaTXwTIaJd/aCLApUMyHeVmvZfKBeFdw=; b=UY0QyYcIoW2LVb93xmYn/hoWn+
        5hMJKJPSCTFREAJu0WX3Y9SzvTM6YZD8tP0WBmS+L6J8RiKcyeAE+u1+yuHA9h2m0rUlEZaorJrRk
        OUEr1G28t0O93w6IXXriWKz0Yl2/KBxTWMEX5mVqm1OW695AAtvae/ujyKV7Q7/wBuyX12ZWaZb3J
        F+EfQS+3ZJcI+wgtC1U3J3VTDkCNm3xaIuKpPQ76EBTZkkEB/aB242gsaOD0K8mrfs1vpPqRQmjfQ
        AkJfqEDvaaynKRQ2FvDO9AcY00xJ9yq5J5pbYDnbS+cdoZzIBYA/Bzj9vabXHU03Vw7zyB8RJzRpX
        On5tnKIA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJdHW-004phg-Cw; Tue, 09 Mar 2021 14:24:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EE0033010CF;
        Tue,  9 Mar 2021 15:24:17 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D967422B8D9BD; Tue,  9 Mar 2021 15:24:17 +0100 (CET)
Date:   Tue, 9 Mar 2021 15:24:17 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Erhard F." <erhard_f@mailbox.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: seqlock lockdep false positives?
Message-ID: <YEeFEbNUVkZaXDp4@hirez.programming.kicks-ass.net>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YESayEskbtjEWjFd@lx-t490>
 <YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net>
 <20210308214208.42a5577f@yea>
 <YEcpqwhQFMimu6Ml@hirez.programming.kicks-ass.net>
 <e745809b-b6c7-7b6a-b598-4e3bbd3e48d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e745809b-b6c7-7b6a-b598-4e3bbd3e48d7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 11:12:34AM +0100, Eric Dumazet wrote:
> Interesting !
> 
> It seems seqcount_latch_init() might benefit from something similar.

Indeed so. I've added the below on top.

---
Subject: seqlock,lockdep: Fix seqcount_latch_init()
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue Mar 9 15:21:18 CET 2021

seqcount_init() must be a macro in order to preserve the static
variable that is used for the lockdep key. Don't then wrap it in an
inline function, which destroys that.

Luckily there aren't many users of this function, but fix it before it
becomes a problem.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/seqlock.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -664,10 +664,7 @@ typedef struct {
  * seqcount_latch_init() - runtime initializer for seqcount_latch_t
  * @s: Pointer to the seqcount_latch_t instance
  */
-static inline void seqcount_latch_init(seqcount_latch_t *s)
-{
-	seqcount_init(&s->seqcount);
-}
+#define seqcount_latch_init(s) seqcount_init(&(s)->seqcount)
 
 /**
  * raw_read_seqcount_latch() - pick even/odd latch data copy
