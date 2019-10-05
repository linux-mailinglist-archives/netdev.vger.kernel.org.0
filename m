Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52F3CCB03
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfJEQL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 12:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfJEQL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 12:11:56 -0400
Received: from paulmck-ThinkPad-P72 (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0585222C0;
        Sat,  5 Oct 2019 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570291915;
        bh=uVvN8miFlyBBEL1s+R/jjVoYmf+OtDC+ppk3W/XU+LA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=VrOhGxHBUp2QBoaABNkTv59q46KU+zMgoXVjo4A+z8jyTemuC+d+MnJsoKBSsLKyk
         ab+nbGBh74pV2MAWEd6dae0UUaaGgTHUo+Pxk5q4buhnWbsEjUplJRXx2cQJmszJIH
         SRZCjP7IRd5OSeWeBIWD3gEfvjE8KJ7BdrXylHRw=
Date:   Sat, 5 Oct 2019 09:11:53 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, dhowells@redhat.com,
        Eric Dumazet <edumazet@google.com>, fweisbec@gmail.com,
        Oleg Nesterov <oleg@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 6/9] bpf/cgroup: Replace
 rcu_swap_protected() with rcu_replace()
Message-ID: <20191005161153.GG2689@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
 <20191003014310.13262-6-paulmck@kernel.org>
 <CAEf4BzaBuktutCZr2ZUC6b-XK_JJ7prWZmO-5Yew2tVp5DxbBA@mail.gmail.com>
 <CAPhsuW6vFwhhYngbftZk4NrSJ+qQx3F6ChUCm=n16HDK-N9vMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6vFwhhYngbftZk4NrSJ+qQx3F6ChUCm=n16HDK-N9vMg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 01:58:13PM -0700, Song Liu wrote:
> On Thu, Oct 3, 2019 at 10:43 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Oct 2, 2019 at 6:45 PM <paulmck@kernel.org> wrote:
> > >
> > > From: "Paul E. McKenney" <paulmck@kernel.org>
> > >
> > > This commit replaces the use of rcu_swap_protected() with the more
> > > intuitively appealing rcu_replace() as a step towards removing
> > > rcu_swap_protected().
> > >
> > > Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> > > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Cc: Song Liu <songliubraving@fb.com>
> > > Cc: Yonghong Song <yhs@fb.com>
> > > Cc: <netdev@vger.kernel.org>
> > > Cc: <bpf@vger.kernel.org>
> > > ---
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> Acked-by: Song Liu <songliubraving@fb.com>

Applied, thank you both!

							Thanx, Paul
