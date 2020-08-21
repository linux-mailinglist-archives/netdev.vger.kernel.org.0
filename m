Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A824D10C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 10:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgHUI7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 04:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUI7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 04:59:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDBCC061385;
        Fri, 21 Aug 2020 01:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uopZNaU4cxTyHr7XErQw6ljqaXqVh1WJtny7IaWd5EU=; b=k9QSszUWMXD5l4y3K3nYTu/j6m
        GJR9R8uU0Mt3VajQ6Dw809W31cZnyEta6CIpIfw+AdlDrH0kX1bbNUtOEcdnBgiW/kIUnhaM2E72G
        HKH6qn4iwzqYPXJOs936HaQcyCnuEynsn63BbQSELfNoI6cbZYa1Y5jlbZA98cQOAwZH8x5YAd13X
        K2f0VCxOlQDkg4077nHGxCGAjazAjK+prwNGVdb3VYBE0C1JflQ+cSDt7XzhJZ2JSuuJYXUc1Fxk9
        OXSxl4Ve9tuo3fvSKw3lRabYEweYaEnBKb7QbWn4K7LRXNDUrDiPsmtt1H7nj73eBMcb8IB1tB9KP
        gpNhx2Xw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k92tA-0007u1-U0; Fri, 21 Aug 2020 08:59:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D09A0305815;
        Fri, 21 Aug 2020 10:59:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 89DDA2B649913; Fri, 21 Aug 2020 10:59:07 +0200 (CEST)
Date:   Fri, 21 Aug 2020 10:59:07 +0200
From:   peterz@infradead.org
To:     Marco Elver <elver@google.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
Message-ID: <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
References: <20200821063043.1949509-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821063043.1949509-1-elver@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 08:30:43AM +0200, Marco Elver wrote:
> With KCSAN enabled, prandom_u32() may be called from any context,
> including idle CPUs.
> 
> Therefore, switch to using trace_prandom_u32_rcuidle(), to avoid various
> issues due to recursion and lockdep warnings when KCSAN and tracing is
> enabled.

At some point we're going to have to introduce noinstr to idle as well.
But until that time this should indeed cure things.
