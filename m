Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2CF2B7584
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 05:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgKRE5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 23:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgKRE5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 23:57:48 -0500
Received: from paulmck-ThinkPad-P72.home (50-39-104-11.bvtn.or.frontiernet.net [50.39.104.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B852463F;
        Wed, 18 Nov 2020 04:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605675467;
        bh=P6T1UQXF1TGia034LOF14sr42Ekt76ERzkz1oq8E3pE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=op/XhzDH1RzBgaMZ3dceJ1Hc/gg18B0n4VUvAVUZZIo1VagaAJQ21dC8+BDqWtUaZ
         2ASqsbR/ubmvO2BKkDKKAbbQUpc9tmajREw1+l6cANKSskmxNpVvItB1agtPvoih07
         p2OPJoQMLYrEtSWwDUGmFI8N3KzukBKvbFECk0J0=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 5CE003523137; Tue, 17 Nov 2020 20:57:47 -0800 (PST)
Date:   Tue, 17 Nov 2020 20:57:47 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Matt Mullins <mmullins@mmlx.us>,
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
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201118045747.GN1437@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20201115055256.65625-1-mmullins@mmlx.us>
 <20201116121929.1a7aeb16@gandalf.local.home>
 <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
 <20201116154437.254a8b97@gandalf.local.home>
 <20201116160218.3b705345@gandalf.local.home>
 <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com>
 <20201116171027.458a6c17@gandalf.local.home>
 <609819191.48825.1605654351686.JavaMail.zimbra@efficios.com>
 <20201118004242.rygrwivqcdgeowi7@hydra.tuxags.com>
 <20201117200922.195ba28c@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117200922.195ba28c@oasis.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 08:09:22PM -0500, Steven Rostedt wrote:
> On Tue, 17 Nov 2020 16:42:44 -0800
> Matt Mullins <mmullins@mmlx.us> wrote:
> 
> 
> > > Indeed with a stub function, I don't see any need for READ_ONCE/WRITE_ONCE.  
> > 
> > I'm not sure if this is a practical issue, but without WRITE_ONCE, can't
> > the write be torn?  A racing __traceiter_ could potentially see a
> > half-modified function pointer, which wouldn't work out too well.
> 
> This has been discussed before, and Linus said:
> 
> "We add READ_ONCE and WRITE_ONCE annotations when they make sense. Not
> because of some theoretical "compiler is free to do garbage"
> arguments. If such garbage happens, we need to fix the compiler"
> 
> https://lore.kernel.org/lkml/CAHk-=wi_KeD1M-_-_SU_H92vJ-yNkDnAGhAS=RR1yNNGWKW+aA@mail.gmail.com/

I have to ask...  Did the ARM compilers get fixed?  As of a few
months ago, they would tear stores of some constant values.

> > This was actually my gut instinct before I wrote the __GFP_NOFAIL
> > instead -- currently that whole array's memory ordering is provided by
> > RCU and I didn't dive deep enough to evaluate getting too clever with
> > atomic modifications to it.
> 
> The pointers are always going to be the architecture word size (by
> definition), and any compiler that tears a write of a long is broken.

But yes, if the write is of a non-constant pointer, the compiler does
have less leverage.

							Thanx, Paul
