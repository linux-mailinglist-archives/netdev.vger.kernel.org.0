Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998103D96F0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhG1UlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhG1UlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 16:41:08 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C5460F9B;
        Wed, 28 Jul 2021 20:41:05 +0000 (UTC)
Date:   Wed, 28 Jul 2021 16:41:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Subject: Re: tracepoints and %p [was: Re: [Patch net-next resend v2] net:
 use %px to print skb address in trace_netif_receive_skb]
Message-ID: <20210728164103.245c9db4@oasis.local.home>
In-Reply-To: <202107281146.B2160202D@keescook>
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
        <202107230000.B52B102@keescook>
        <CAG48ez0b-t_kJXVeFixYMoqRa-g1VRPUhFVknttiBYnf-cjTyg@mail.gmail.com>
        <20210728115633.614e9bd9@oasis.local.home>
        <202107281146.B2160202D@keescook>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Jul 2021 11:48:11 -0700
Kees Cook <keescook@chromium.org> wrote:

> > That is exactly what is happening. I wrote the following to the replied
> > text up at the top, then noticed you basically stated the same thing
> > here ;-)  
> 
> Where is the %px being formatted then? If it's the kernel itself (which
> is the only thing that does %px), then it doesn't need to be %px, since
> the raw data is separate. i.e. leave it %p for whatever logs will get
> spilled out to who knows where.

The trace events shown by tracefs/trace are formatted via the kernel
sprintf() and friends, which will hash "%p".

But the raw data read to trace-cmd (and other tools), uses
libtraceevent, that parses the printf-fmt of a trace event just like
the kernel does. But since we are already in user space, it is pretty
pointless to implement "%p" with hashing. But it does understand what
"%px" is.

> 
> How does ftrace interact with lockdown's confidentiality mode?
> 

as Jann replied. If you enable "LOCKDOWN_TRACEFS" you lose all access
to the tracing interface.

-- Steve
