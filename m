Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A453AF8B4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhFUWng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231817AbhFUWne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2ECA6124B;
        Mon, 21 Jun 2021 22:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624315279;
        bh=UXd0EyfCTFXC5zHmXZWHGRM8gwslzKUqjbDHNEzxVfo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=kDb6cwsQ+u/G1qukOtXSytwcTsshNyCF6ilM3FqjLc0THc4lnd88yV49yrN2GYoWC
         JgyHuVSBi6nyyVXA/fhZ5ofYCR+9DnEN7wsDJzUIMkgzEAqOl8hZsMf++wSAg6BtCk
         +eVbTT0Cj4W34NQafsPcqiwauPeBsr/U2ATWtZcK8MVY326DsRrOdy2EYyCceSzwxZ
         fC9p5Axvo1whYj+xAM7SLsOlyUs66TwM2wZSK6ZPuNSe0KRlW4YD83jNgvqVLOlaOl
         5OJW+orEIzGGwXISlZFZTDYYC4kZdCsvj2l4KBTsy9SGIMJl5Jr5lt1C2/DsCj3Jj9
         tB1i16c1lj+IQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 6F0265C052D; Mon, 21 Jun 2021 15:41:19 -0700 (PDT)
Date:   Mon, 21 Jun 2021 15:41:19 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, dvyukov@google.com, fw@strlen.de,
        jiangshanlai@gmail.com, joel@joelfernandes.org,
        john.fastabend@gmail.com, josh@joshtriplett.org,
        kadlec@netfilter.org, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        peterz@infradead.org, rcu@vger.kernel.org, rostedt@goodmis.org,
        shakeelb@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yanfei.xu@windriver.com,
        yhs@fb.com, yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] KASAN: use-after-free Read in
 check_all_holdout_tasks_trace
Message-ID: <20210621224119.GW4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <000000000000f034fc05c2da6617@google.com>
 <000000000000cac82d05c5214992@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000cac82d05c5214992@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 09:54:06AM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Apr 21 07:51:08 2021 +0000
> 
>     netfilter: arp_tables: pass table pointer via nf_hook_ops
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dceae8300000
> start commit:   0c38740c selftests/bpf: Fix ringbuf test fetching map FD
> git tree:       bpf-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12dceae8300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14dceae8300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a6380da8984033f1
> dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1264c2d7d00000
> 
> Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
> Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

I am not seeing any mention of check_all_holdout_tasks_trace() in
the console output, but I again suggest the following two patches:

6a04a59eacbd ("rcu-tasks: Don't delete holdouts within trc_inspect_reader()"
dd5da0a9140e ("rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()")

							Thanx, Paul
