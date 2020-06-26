Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31C320B022
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgFZLBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgFZLBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:01:14 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07385C08C5C1;
        Fri, 26 Jun 2020 04:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yIua4md0cM89ux/q6VciAse47KIrRNpMAh8h5H0zSh8=; b=f9MSj6Q/rF3jSca9cRGwsnADUm
        wJ/Uj46JkwvR6ptbyIwdQgYTUe+i/B619nkSKsjD2CLaHg+AnwlHtfHD+Kew2+6HY8EMYrHK0OAnr
        0qf2QYmvEHXpQoXjFjdth90ycNbza0ZMEGwtH9Ve/MIX50o+9obpJwkHMCrxpcMRpbx8RdEjpFe1+
        ivgJvC63B+/OlwoFG9mn1xWOEMeWN/gOQLy0HD6Xrb0OIJQvUaJ+L1JBlkdVqlJR9ng3y1rdgUOVc
        B5xamG3XS8hpX/wQ50ybgTO8MOYXLSST5/hw5wmGGF2EbV7ydJYKu+db6uKsqhtOkXJjtORGSqD75
        TJyk3dtg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jom6B-0004zJ-EE; Fri, 26 Jun 2020 11:00:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A6B9A301DFC;
        Fri, 26 Jun 2020 13:00:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9A71829C4228A; Fri, 26 Jun 2020 13:00:46 +0200 (CEST)
Date:   Fri, 26 Jun 2020 13:00:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org
Subject: Re: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
Message-ID: <20200626110046.GB4817@hirez.programming.kicks-ass.net>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626001332.1554603-2-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 05:13:29PM -0700, Song Liu wrote:
> This would be used by bpf stack mapo.

Would it make sense to sanitize the API a little before exposing it?

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 334d48b16c36..016894b0d2c2 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -159,8 +159,10 @@ static struct perf_callchain_entry *get_callchain_entry(int *rctx)
 		return NULL;
 
 	entries = rcu_dereference(callchain_cpus_entries);
-	if (!entries)
+	if (!entries) {
+		put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
 		return NULL;
+	}
 
 	cpu = smp_processor_id();
 
@@ -183,12 +185,9 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 	int rctx;
 
 	entry = get_callchain_entry(&rctx);
-	if (rctx == -1)
+	if (!entry || rctx == -1)
 		return NULL;
 
-	if (!entry)
-		goto exit_put;
-
 	ctx.entry     = entry;
 	ctx.max_stack = max_stack;
 	ctx.nr	      = entry->nr = init_nr;
