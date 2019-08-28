Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B999FB3F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfH1HPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:15:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40878 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1HPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LCKYQgM1kednGh8zGipmDLqih90IW12ASZGRceJC28s=; b=ZrBVdurcF+KjSFtVBhIaPIsM/
        PovNxMPCKE8EXwzGkkQdQgyTgQFqZi9Ao2HWKViPP/8HIcSySUsejvVyQQmdN+Yfo9207BqtqKJ+L
        X4rhbWytrJSTTVPGSipIAIDdmCDGQE4nCy9oBkVxHHtI6Ui93dbGy3lkefgY+WPmeMhHqpCJAdch1
        rNPivGHLjPuggglOz+vnT3ueExfIo+ZnL+xH26bAqRGAcbHxRZEv22Xc8MT5AB+J0s1b6kVD8Vty0
        30fecCnsQrHkm4MQ+N/KYyz5NRnsd+SLyyqaat1b4bmHZmuM9wx1pVSdyglx+JGSkCF00LXEXhS86
        gEOCQJ2Sg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i2s9w-0004Zr-CD; Wed, 28 Aug 2019 07:14:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 373B63070F4;
        Wed, 28 Aug 2019 09:13:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 15FE720C74263; Wed, 28 Aug 2019 09:14:21 +0200 (CEST)
Date:   Wed, 28 Aug 2019 09:14:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828071421.GK2332@hirez.programming.kicks-ass.net>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:

> > Tracing:
> >
> > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > are necessary to:

That's not tracing, that's perf.

> > +bool cap_bpf_tracing(void)
> > +{
> > +       return capable(CAP_SYS_ADMIN) ||
> > +              (capable(CAP_BPF) && !perf_paranoid_tracepoint_raw());
> > +}

A whole long time ago, I proposed we introduce CAP_PERF or something
along those lines; as a replacement for that horrible crap Android and
Debian ship. But nobody was ever interested enough.

The nice thing about that is that you can then disallow perf/tracing in
general, but tag the perf executable (and similar tools) with the
capability so that unpriv users can still use it, but only limited
through the tool, not the syscalls directly.

