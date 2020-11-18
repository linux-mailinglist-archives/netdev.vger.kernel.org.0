Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D12B83E5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgKRScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:32:22 -0500
Received: from albireo.enyo.de ([37.24.231.21]:43476 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgKRScV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:32:21 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kfSFC-0006nX-JX; Wed, 18 Nov 2020 18:31:50 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1kfSFC-0005cN-Gh; Wed, 18 Nov 2020 19:31:50 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
        <20201118121730.12ee645b@gandalf.local.home>
        <20201118181226.GK2672@gate.crashing.org>
Date:   Wed, 18 Nov 2020 19:31:50 +0100
In-Reply-To: <20201118181226.GK2672@gate.crashing.org> (Segher Boessenkool's
        message of "Wed, 18 Nov 2020 12:12:26 -0600")
Message-ID: <87o8jutt2h.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Segher Boessenkool:

> On Wed, Nov 18, 2020 at 12:17:30PM -0500, Steven Rostedt wrote:
>> I could change the stub from (void) to () if that would be better.
>
> Don't?  In a function definition they mean exactly the same thing (and
> the kernel uses (void) everywhere else, which many people find clearer).

And I think () functions expected a caller-provided parameter save
area on powerpc64le, while (void) functions do not.  It does not
matter for an empty function, but GCC prefers to use the parameter
save area instead of setting up a stack frame if it is present.  So
you get stack corruption if you call a () function as a (void)
function.  (The other way round is fine.)
