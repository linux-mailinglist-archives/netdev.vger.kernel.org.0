Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7F42B8D02
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgKSIWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgKSIWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:22:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0615C0613CF;
        Thu, 19 Nov 2020 00:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q5j8VmWjbCI+JHvHMjaXP6mfZ871EVq/TPzO7+IbdtM=; b=kQKX9s0j6h7jVgBO6f0DlaE/GM
        hROzUlBOsP3v+jPW7raijXtvxttkw6mcCRuHDVE2lyW9kZbJ8oAFEyR/AX/TYFOO7ZqqT6oaNEiuV
        4AtSEpxpxK8j2Twif+iZqfhq+fM5chPp4+9WlOShIls0MTBOPp6FTuCOUhmIP3DU26WEM6oJOoIbA
        eMUxLzSQOLtieTcEPV6XLy/bH/5CE/iSTXEwvTXc7D7ZhmUHdQlw1220Eb9i1rEfQ1DKnzYPXwrdr
        GWOPvWy/YmCR9pEvIkdErbRbRQHZJ6u4MBrrF7ffO1/L0qDsP0GnIIq/iXfqBfjes+m5NClYaMJtj
        7A5R9lAw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kffCd-0002n1-7m; Thu, 19 Nov 2020 08:22:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 27314301E02;
        Thu, 19 Nov 2020 09:21:58 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 049EE203DDBF7; Thu, 19 Nov 2020 09:21:57 +0100 (CET)
Date:   Thu, 19 Nov 2020 09:21:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains@vger.kernel.org
Subject: Re: violating function pointer signature
Message-ID: <20201119082157.GD3121392@hirez.programming.kicks-ass.net>
References: <20201117153451.3015c5c9@gandalf.local.home>
 <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
 <20201118121730.12ee645b@gandalf.local.home>
 <20201118181226.GK2672@gate.crashing.org>
 <87o8jutt2h.fsf@mid.deneb.enyo.de>
 <20201118135823.3f0d24b7@gandalf.local.home>
 <20201118191127.GM2672@gate.crashing.org>
 <20201118143343.4e86e79f@gandalf.local.home>
 <20201118194837.GO2672@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118194837.GO2672@gate.crashing.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 01:48:37PM -0600, Segher Boessenkool wrote:

> If you have at most four or so args, what you wnat to do will work on
> all systems the kernel currently supports, as far as I can tell.  It
> is not valid C, and none of the compilers have an extension for this
> either.  But it will likely work.

So this is where we rely on the calling convention being caller-cleanup
(cdecl has that).

I looked at the GCC preprocessor symbols but couldn't find anything that
seems relevant to the calling convention in use, so barring that, the
best option might to be have a boot-time self-test that triggers this.
Then we'll quickly know if all architectures handle this correctly.
