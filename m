Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B0C36D3D0
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbhD1IU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:20:28 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:39094 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbhD1IU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619597982; x=1651133982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j9QWlAsK1jnUHugihgPpWh5yTZzPwnYSGQNZKz7LMek=;
  b=B0G9aWgpcXbc/bt2hMA2eewi3S8ZhBPwdgphMLlSU0DmygEwCj2R1Pcw
   Z60cFyfYLW4Cd80uLQdeo3eExGG79KJ5hRx3b1nTbhsR+Qx1h/50Nj9bD
   3igZCPjE0GLgkb7bN04xnUJctiJrRx5uHoNGfJZdvYTDV2W9ycLA7d5cq
   s=;
X-IronPort-AV: E=Sophos;i="5.82,257,1613433600"; 
   d="scan'208";a="104432491"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 28 Apr 2021 08:18:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 2EBAEA2242;
        Wed, 28 Apr 2021 08:18:40 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 08:18:39 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.209) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 08:18:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <zenczykowski@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Wed, 28 Apr 2021 17:18:30 +0900
Message-ID: <20210428081830.2292-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAHo-Ooz252rnWZ=9k6nO0vjGKFkQDoaLxZ1jxiTomtckq9DbYA@mail.gmail.com>
References: <CAHo-Ooz252rnWZ=9k6nO0vjGKFkQDoaLxZ1jxiTomtckq9DbYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D23UWA001.ant.amazon.com (10.43.160.68) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Maciej Żenczykowski <zenczykowski@gmail.com>
Date:   Tue, 27 Apr 2021 15:00:12 -0700
> On Tue, Apr 27, 2021 at 2:55 PM Maciej Żenczykowski
> <zenczykowski@gmail.com> wrote:
> > On Mon, Apr 26, 2021 at 8:47 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > > accept connections evenly. However, there is a defect in the current
> > > implementation [1]. When a SYN packet is received, the connection is tied
> > > to a listening socket. Accordingly, when the listener is closed, in-flight
> > > requests during the three-way handshake and child sockets in the accept
> > > queue are dropped even if other listeners on the same port could accept
> > > such connections.
> > >
> > > This situation can happen when various server management tools restart
> > > server (such as nginx) processes. For instance, when we change nginx
> > > configurations and restart it, it spins up new workers that respect the new
> > > configuration and closes all listeners on the old workers, resulting in the
> > > in-flight ACK of 3WHS is responded by RST.
> >
> > This is IMHO a userspace bug.

I do not think so.

If the kernel selected another listener for incoming connections, they
could be accept()ed. There is no room for usersapce to change the behaviour
without an in-kernel tool, eBPF. A feature that can cause failure
stochastically due to kernel behaviour cannot be a userspace bug.


> >
> > You should never be closing or creating new SO_REUSEPORT sockets on a
> > running server (listening port).
> >
> > There's at least 3 ways to accomplish this.
> >
> > One involves a shim parent process that takes care of creating the
> > sockets (without close-on-exec),
> > then fork-exec's the actual server process[es] (which will use the
> > already opened listening fds),
> > and can thus re-fork-exec a new child while using the same set of sockets.
> > Here the old server can terminate before the new one starts.
> >
> > (one could even envision systemd being modified to support this...)
> >
> > The second involves the old running server fork-execing the new server
> > and handing off the non-CLOEXEC sockets that way.
> 
> (this doesn't even need to be fork-exec -- can just be exec -- and is
> potentially easier)
> 
> > The third approach involves unix fd passing of sockets to hand off the
> > listening sockets from the old process/thread(s) to the new
> > process/thread(s).  Once handed off the old server can stop accept'ing
> > on the listening sockets and close them (the real copies are in the
> > child), finish processing any still active connections (or time them
> 
> (this doesn't actually need to be a child, in can be an entirely new
> parallel instance of the server,
> potentially running in an entirely new container/cgroup setup, though
> in the same network namespace)
> 
> > out) and terminate.
> >
> > Either way you're never creating new SO_REUSEPORT sockets (dup doesn't
> > count), nor closing the final copy of a given socket.

Indeed each approach can be an option, but it makes application more
complicated. Also what if the process holding the listener fd died, there
could be down time.

I do not think every approach works well in everywhere for everyone.


> >
> > This is basically the same thing that was needed not to lose incoming
> > connections in a pre-SO_REUSEPORT world.
> > (no SO_REUSEADDR by itself doesn't prevent an incoming SYN from
> > triggering a RST during the server restart, it just makes the window
> > when RSTs happen shorter)

SO_REUSEPORT makes each process/listener independent, and we need not pass
fds. So, it makes application much simpler. Even with SO_REUSEPORT, one
listener might crash, but it is more tolerant than losing all connections
at once.

To enjoy such merits, isn't it natural to improve the existing feature in
this post-SO_REUSEPORT world?


> >
> > This was from day one (I reported to Tom and worked with him on the
> > very initial distribution function) envisioned to work like this,
> > and we (Google) have always used it with unix fd handoff to support
> > transparent restart.
