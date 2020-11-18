Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F462B737F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgKRBJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgKRBJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 20:09:26 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DADF320782;
        Wed, 18 Nov 2020 01:09:23 +0000 (UTC)
Date:   Tue, 17 Nov 2020 20:09:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Matt Mullins <mmullins@mmlx.us>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        paulmck <paulmck@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20201117200922.195ba28c@oasis.local.home>
In-Reply-To: <20201118004242.rygrwivqcdgeowi7@hydra.tuxags.com>
References: <00000000000004500b05b31e68ce@google.com>
        <20201115055256.65625-1-mmullins@mmlx.us>
        <20201116121929.1a7aeb16@gandalf.local.home>
        <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
        <20201116154437.254a8b97@gandalf.local.home>
        <20201116160218.3b705345@gandalf.local.home>
        <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com>
        <20201116171027.458a6c17@gandalf.local.home>
        <609819191.48825.1605654351686.JavaMail.zimbra@efficios.com>
        <20201118004242.rygrwivqcdgeowi7@hydra.tuxags.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 16:42:44 -0800
Matt Mullins <mmullins@mmlx.us> wrote:


> > Indeed with a stub function, I don't see any need for READ_ONCE/WRITE_ONCE.  
> 
> I'm not sure if this is a practical issue, but without WRITE_ONCE, can't
> the write be torn?  A racing __traceiter_ could potentially see a
> half-modified function pointer, which wouldn't work out too well.

This has been discussed before, and Linus said:

"We add READ_ONCE and WRITE_ONCE annotations when they make sense. Not
because of some theoretical "compiler is free to do garbage"
arguments. If such garbage happens, we need to fix the compiler"

https://lore.kernel.org/lkml/CAHk-=wi_KeD1M-_-_SU_H92vJ-yNkDnAGhAS=RR1yNNGWKW+aA@mail.gmail.com/

> 
> This was actually my gut instinct before I wrote the __GFP_NOFAIL
> instead -- currently that whole array's memory ordering is provided by
> RCU and I didn't dive deep enough to evaluate getting too clever with
> atomic modifications to it.

The pointers are always going to be the architecture word size (by
definition), and any compiler that tears a write of a long is broken.

-- Steve
