Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC2730E07D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhBCRGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBCRGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:06:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A91C0613ED;
        Wed,  3 Feb 2021 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c5g2NvNSV0wjbVoiArRl3FgyflzlxGlwPgD4zP2xDxs=; b=GHUUpDWKn/e631xLHt0bVBQuvi
        8HRXLbQWtV0BoCxjAWuGpMWDKy+MwUY9sBtIxA8odgKVhMzm6LVC16DO21UFgc2kxXpjOfdvGGR3F
        hypW2J8ePEHCLXoLNutbdc1zKS7G6388MvfCEq0xbpyvUfgTo2KFHRuyqjti15uBqKNm4ohvgXsNn
        odrVOhWXU2TRzlobFOiqiQoLalJhOR0wssAEOuY9STbu2ZYh9vELRU+pDu1ZFn1J9wK9w1fpswMD1
        /CF5b9UhhXWuhV5HTlu4IMWjxK4OaZiiOc3aPz+AhAsm0R9tiO/H6iXi7RxTvI1Y/48MOOKujgfFK
        qgNy8OHw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7LaT-0007dq-BQ; Wed, 03 Feb 2021 17:05:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5B75930066E;
        Wed,  3 Feb 2021 18:05:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 41F9E20C633CC; Wed,  3 Feb 2021 18:05:01 +0100 (CET)
Date:   Wed, 3 Feb 2021 18:05:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com,
        syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com,
        Matt Mullins <mmullins@mmlx.us>
Subject: Re: [for-next][PATCH 14/15] tracepoint: Do not fail unregistering a
 probe due to memory failure
Message-ID: <YBrXvQHJX1HXLvdf@hirez.programming.kicks-ass.net>
References: <20210203160517.982448432@goodmis.org>
 <20210203160550.710877069@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203160550.710877069@goodmis.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 11:05:31AM -0500, Steven Rostedt wrote:
> [ Note, this version does use undefined compiler behavior (assuming that
>   a stub function with no parameters or return, can be called by a location
>   that thinks it has parameters but still no return value. Static calls
>   do the same thing, so this trick is not without precedent.

Specifically it relies on the C ABI being caller cleanup. CDECL is that.
