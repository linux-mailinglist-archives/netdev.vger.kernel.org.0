Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68023210E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgG2OzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2OzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:55:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3068C061794;
        Wed, 29 Jul 2020 07:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZYyKJX8gyBkW6F9daVA0jWm+9kP2lb8jGX/Ef1mBZlk=; b=qf71CeE4YFlWKzhXY4jhV1Z2s8
        BM8w59AJ99z+q6KHcBdm+y7itJs+KYqHI3K4NOJP26VlQDBaE8ABd4i5IBmWvbokFj4XqWBqsUkxa
        JtzKXE8sFPW3gtlDTmJR0s9gKPQiE1zx/C8RyXROY3uf4u6msv0xZ0fWSOQ2ZgAvsJfLql928FetY
        HtmeyJFQzjOXtvwiGK18rY3Lb0IkdAiSGR2LQU0EuqebwrN3pJWNXck9qkHpFZsW5KHSir/Wo29uX
        EhgENoTSAjawl0mjMPXBHi/oK5HOja3Rk3itmGCyEf18ds59WWlUX1dqwazUQWx2QlQp0FT9JEx3A
        WHOEPDqA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0nU3-0003wK-Eq; Wed, 29 Jul 2020 14:55:07 +0000
Date:   Wed, 29 Jul 2020 15:55:07 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, a.darwish@linutronix.de,
        tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] seqlock: Fold seqcount_LOCKNAME_t definition
Message-ID: <20200729145507.GW23808@casper.infradead.org>
References: <20200729135249.567415950@infradead.org>
 <20200729140142.347671778@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729140142.347671778@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 03:52:51PM +0200, Peter Zijlstra wrote:
> Manual repetition is boring and error prone.

Yes, but generated functions are hard to grep for, and I'm pretty sure
that kernel-doc doesn't know how to expand macros into comments that it
can then extract documentation from.

I've been thinking about how to cure this (mostly in the context
of page-flags.h).  I don't particularly like the C preprocessor, but
m4 is worse and defining our own preprocessing language seems like a
terrible idea.

So I was thinking about moving the current contents of page-flags.h
to include/src/page-flags.h, making linux/page-flags.h depend on
src/page-flags.h and run '$(CPP) -C' to generate it.  I've been a little
busy recently and haven't had time to do more than muse about this, but
I think it might make sense for some of our more heavily macro-templated
header files.
