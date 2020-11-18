Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5702B7347
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgKRAmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:42:46 -0500
Received: from hydra.tuxags.com ([64.13.172.54]:58814 "EHLO mail.tuxags.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgKRAmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:42:45 -0500
Received: by mail.tuxags.com (Postfix, from userid 1000)
        id 2C755144F139C; Tue, 17 Nov 2020 16:42:44 -0800 (PST)
Date:   Tue, 17 Nov 2020 16:42:44 -0800
From:   Matt Mullins <mmullins@mmlx.us>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt <rostedt@goodmis.org>, paulmck <paulmck@kernel.org>,
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
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201118004242.rygrwivqcdgeowi7@hydra.tuxags.com>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        rostedt <rostedt@goodmis.org>, paulmck <paulmck@kernel.org>,
        Matt Mullins <mmullins@mmlx.us>, Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <00000000000004500b05b31e68ce@google.com>
 <20201115055256.65625-1-mmullins@mmlx.us>
 <20201116121929.1a7aeb16@gandalf.local.home>
 <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
 <20201116154437.254a8b97@gandalf.local.home>
 <20201116160218.3b705345@gandalf.local.home>
 <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com>
 <20201116171027.458a6c17@gandalf.local.home>
 <609819191.48825.1605654351686.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <609819191.48825.1605654351686.JavaMail.zimbra@efficios.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:05:51PM -0500, Mathieu Desnoyers wrote:
> ----- On Nov 16, 2020, at 5:10 PM, rostedt rostedt@goodmis.org wrote:
> 
> > On Mon, 16 Nov 2020 16:34:41 -0500 (EST)
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> [...]
> 
> >> I think you'll want a WRITE_ONCE(old[i].func, tp_stub_func) here, matched
> >> with a READ_ONCE() in __DO_TRACE. This introduces a new situation where the
> >> func pointer can be updated and loaded concurrently.
> > 
> > I thought about this a little, and then only thing we really should worry
> > about is synchronizing with those that unregister. Because when we make
> > this update, there are now two states. the __DO_TRACE either reads the
> > original func or the stub. And either should be OK to call.
> > 
> > Only the func gets updated and not the data. So what exactly are we worried
> > about here?
> 
> Indeed with a stub function, I don't see any need for READ_ONCE/WRITE_ONCE.

I'm not sure if this is a practical issue, but without WRITE_ONCE, can't
the write be torn?  A racing __traceiter_ could potentially see a
half-modified function pointer, which wouldn't work out too well.

This was actually my gut instinct before I wrote the __GFP_NOFAIL
instead -- currently that whole array's memory ordering is provided by
RCU and I didn't dive deep enough to evaluate getting too clever with
atomic modifications to it.

> 
> However, if we want to compare the function pointer to some other value and
> conditionally do (or skip) the call, I think you'll need the READ_ONCE/WRITE_ONCE
> to make sure the pointer is not re-fetched between comparison and call.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
