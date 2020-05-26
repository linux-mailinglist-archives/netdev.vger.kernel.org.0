Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65E1E19B5
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 05:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388478AbgEZDFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 23:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388417AbgEZDFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 23:05:36 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 387982068D;
        Tue, 26 May 2020 03:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590462335;
        bh=ctHYGfwil2GD6Xy8r0jplUfevlrSVidZqSutpXSOtAQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ZgeVcsu7LISLqTkj2BN7jZxIXtMbJDssuAHJSgunl3+0WpiYXEt5lGUtCHfYI80T9
         459m8XdY7QHcoAGREvcPsuTog2UGhkyuE787QNUgMzdRugBIN7i49M9ORWkvbYfTqF
         oBLojE89DKstpWGLQ/aqCEgrjDEHgSOpp8OF79OQ=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 1A1423522A6D; Mon, 25 May 2020 20:05:35 -0700 (PDT)
Date:   Mon, 25 May 2020 20:05:35 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/7] tools/memory-model: add BPF ringbuf MPSC
 litmus tests
Message-ID: <20200526030535.GE2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-3-andriin@fb.com>
 <20200522003433.GG2869@paulmck-ThinkPad-P72>
 <CAEf4BzaVeFfa2=-M4FCgH5HX17TSkcGsBTDZcjrZxo=He2QESg@mail.gmail.com>
 <CAEf4Bza9aRM+6EfXaokV8xfEj_hRoKhNd5vYKtpc61XFAiewsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza9aRM+6EfXaokV8xfEj_hRoKhNd5vYKtpc61XFAiewsA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 04:33:15PM -0700, Andrii Nakryiko wrote:
> On Fri, May 22, 2020 at 11:51 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, May 21, 2020 at 5:34 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > On Sun, May 17, 2020 at 12:57:22PM -0700, Andrii Nakryiko wrote:
> > > > Add 4 litmus tests for BPF ringbuf implementation, divided into two different
> > > > use cases.
> > > >
> > > > First, two unbounded case, one with 1 producer and another with
> > > > 2 producers, single consumer. All reservations are supposed to succeed.
> > > >
> > > > Second, bounded case with only 1 record allowed in ring buffer at any given
> > > > time. Here failures to reserve space are expected. Again, 1- and 2- producer
> > > > cases, single consumer, are validated.
> > > >
> > > > Just for the fun of it, I also wrote a 3-producer cases, it took *16 hours* to
> > > > validate, but came back successful as well. I'm not including it in this
> > > > patch, because it's not practical to run it. See output for all included
> > > > 4 cases and one 3-producer one with bounded use case.
> > > >
> > > > Each litmust test implements producer/consumer protocol for BPF ring buffer
> > > > implementation found in kernel/bpf/ringbuf.c. Due to limitations, all records
> > > > are assumed equal-sized and producer/consumer counters are incremented by 1.
> > > > This doesn't change the correctness of the algorithm, though.
> > >
> > > Very cool!!!
> > >
> > > However, these should go into Documentation/litmus-tests/bpf-rb or similar.
> > > Please take a look at Documentation/litmus-tests/ in -rcu, -tip, and
> > > -next, including the README file.
> > >
> > > The tools/memory-model/litmus-tests directory is for basic examples,
> > > not for the more complex real-world ones like these guys.  ;-)
> >
> > Oh, ok, I didn't realize there are more litmus tests under
> > Documentation/litmus-tests... Might have saved me some time (more
> > examples to learn from!) when I was writing mine :) Will check those
> > and move everything.
> 
> Ok, so Documentation/litmus-tests is not present in bpf-next, so I
> guess I'll have to split this patch out and post it separately. BTW,
> it's not in -rcu tree either, should I post this against linux-next
> tree directly?

It is on branch "dev" of -rcu, though yet not on branch "master".

							Thanx, Paul
