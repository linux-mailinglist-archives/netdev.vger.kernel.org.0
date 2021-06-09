Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017F93A0870
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 02:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhFIAgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 20:36:45 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:51384 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbhFIAgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 20:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623198890; x=1654734890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mLH4j0tpi3aVM2PjiX7dgm3Yj3RRjDwIaDvyaMgv1nE=;
  b=kcTa0d2KFvpXi8BqwPV/EDXyTYcUJn58OQg0SYkWrWFDLUwVwsDjV54L
   VpeYkW97hYmusVibID37BhZ/y6HomAINvKuHMLHsV2ECUGGL/SyuHyjoF
   9IPbndk3Y0jeLRiKksRCFihb37WgPJUUAXBo5zNw3LcLtOHc6/ci0mZta
   8=;
X-IronPort-AV: E=Sophos;i="5.83,259,1616457600"; 
   d="scan'208";a="117519497"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 09 Jun 2021 00:34:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 1F0F8A178D;
        Wed,  9 Jun 2021 00:34:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 9 Jun 2021 00:34:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.201) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 9 Jun 2021 00:34:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <ycheng@google.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Wed, 9 Jun 2021 09:34:34 +0900
Message-ID: <20210609003434.49627-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAK6E8=cgFKuGecTzSCSQ8z3YJ_163C0uwO9yRvfDSE7vOe9mJA@mail.gmail.com>
References: <CAK6E8=cgFKuGecTzSCSQ8z3YJ_163C0uwO9yRvfDSE7vOe9mJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.201]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 8 Jun 2021 16:47:37 -0700
> On Tue, Jun 8, 2021 at 4:04 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   Yuchung Cheng <ycheng@google.com>
> > Date:   Tue, 8 Jun 2021 10:48:06 -0700
> > > On Tue, May 25, 2021 at 11:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > > > > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > > > > accept connections evenly. However, there is a defect in the current
> > > > > implementation [1]. When a SYN packet is received, the connection is tied
> > > > > to a listening socket. Accordingly, when the listener is closed, in-flight
> > > > > requests during the three-way handshake and child sockets in the accept
> > > > > queue are dropped even if other listeners on the same port could accept
> > > > > such connections.
> > > > >
> > > > > This situation can happen when various server management tools restart
> > > > > server (such as nginx) processes. For instance, when we change nginx
> > > > > configurations and restart it, it spins up new workers that respect the new
> > > > > configuration and closes all listeners on the old workers, resulting in the
> > > > > in-flight ACK of 3WHS is responded by RST.
> > > > >
> > > > > To avoid such a situation, users have to know deeply how the kernel handles
> > > > > SYN packets and implement connection draining by eBPF [2]:
> > > > >
> > > > >    1. Stop routing SYN packets to the listener by eBPF.
> > > > >    2. Wait for all timers to expire to complete requests
> > > > >    3. Accept connections until EAGAIN, then close the listener.
> > > > >
> > > > >    or
> > > > >
> > > > >    1. Start counting SYN packets and accept syscalls using the eBPF map.
> > > > >    2. Stop routing SYN packets.
> > > > >    3. Accept connections up to the count, then close the listener.
> > > > >
> > > > > In either way, we cannot close a listener immediately. However, ideally,
> > > > > the application need not drain the not yet accepted sockets because 3WHS
> > > > > and tying a connection to a listener are just the kernel behaviour. The
> > > > > root cause is within the kernel, so the issue should be addressed in kernel
> > > > > space and should not be visible to user space. This patchset fixes it so
> > > > > that users need not take care of kernel implementation and connection
> > > > > draining. With this patchset, the kernel redistributes requests and
> > > > > connections from a listener to the others in the same reuseport group
> > > > > at/after close or shutdown syscalls.
> > > > >
> > > > > Although some software does connection draining, there are still merits in
> > > > > migration. For some security reasons, such as replacing TLS certificates,
> > > > > we may want to apply new settings as soon as possible and/or we may not be
> > > > > able to wait for connection draining. The sockets in the accept queue have
> > > > > not started application sessions yet. So, if we do not drain such sockets,
> > > > > they can be handled by the newer listeners and could have a longer
> > > > > lifetime. It is difficult to drain all connections in every case, but we
> > > > > can decrease such aborted connections by migration. In that sense,
> > > > > migration is always better than draining.
> > > > >
> > > > > Moreover, auto-migration simplifies user space logic and also works well in
> > > > > a case where we cannot modify and build a server program to implement the
> > > > > workaround.
> > > > >
> > > > > Note that the source and destination listeners MUST have the same settings
> > > > > at the socket API level; otherwise, applications may face inconsistency and
> > > > > cause errors. In such a case, we have to use the eBPF program to select a
> > > > > specific listener or to cancel migration.
> > > This looks to be a useful feature. What happens to migrating a
> > > passively fast-opened socket in the old listener but it has not yet
> > > been accepted (TFO is both a mini-socket and a full-socket)?
> > > It gets tricky when the old and new listener have different TFO key
> >
> > The tricky situation can happen without this patch set. We can change
> > the listener's TFO key when TCP_SYN_RECV sockets are still in the accept
> > queue. The change is already handled properly, so it does not crash
> > applications.
> >
> > In the normal 3WHS case, a full-socket is created after 3WHS. In the TFO
> > case, a full-socket is created after validating the TFO cookie in the
> > initial SYN packet.
> >
> > After that, the connection is basically handled via the full-socket, except
> > for accept() syscall. So in the both cases, the mini-socket is poped out of
> > old listener's queue, cloned, and put into the new listner's queue. Then we
> > can accept() its full-socket via the cloned mini-socket.
> 
> Thanks, that makes sense. Eric is the expert in this part to review
> the correctness. My only suggestion is to add some stats tracking the
> mini-sockets that fail to migrate due to a variety of reasons (the
> code locations that the requests need to be dropped). This can be
> useful to evaluate the effectiveness of this new feature.

That's nice idea.
I'll implement it as a follow-up patch or in the next spin.

For now, I would like to wait for Eric's review.

Thank you.
