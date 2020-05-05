Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E6E1C5A91
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgEEPIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:08:16 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:45492 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729571AbgEEPIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588691295; x=1620227295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=IAgZZDQAgmaOCAEF+gMgVxcblMlmWcnuMZ5A1KV3daA=;
  b=UIWX9QriVhXaUgff+rXR8CA9p3BYxPpUa+3orOtDkb6FXERDofUChTKC
   8MUSyAGmNNqx4e362Ei3lvfT5hIds/3aVLJVM9f6g/2h3xKC2V+KhEaIz
   ivDgJKOUSjafjb7ELC0Gws+PdjFwiEyBfNvWkQUC7kzCCxOajjI9ZcNow
   w=;
IronPort-SDR: kyd4994nfXuQCwn5F4nNpODgpRWvzpQJ2KEhGPjS9GIDWdfh2joXL/vSHZCx1BE9ajvdBjCf9k
 VpSuB92/uMKw==
X-IronPort-AV: E=Sophos;i="5.73,355,1583193600"; 
   d="scan'208";a="28970664"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 05 May 2020 15:08:00 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 994FBA1F77;
        Tue,  5 May 2020 15:07:59 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 15:07:59 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.38) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 15:07:50 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        David Miller <davem@davemloft.net>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 17:07:17 +0200
Message-ID: <20200505150717.5688-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iJ6f=x9XSfjSCFc0KNcjSXop3QMEgAfh9PLJ6khTbXrnQ@mail.gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D28UWB004.ant.amazon.com (10.43.161.56) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:

> On Tue, May 5, 2020 at 4:54 AM SeongJae Park <sjpark@amazon.com> wrote:
> >
> > CC-ing stable@vger.kernel.org and adding some more explanations.
> >
> > On Tue, 5 May 2020 10:10:33 +0200 SeongJae Park <sjpark@amazon.com> wrote:
> >
> > > From: SeongJae Park <sjpark@amazon.de>
> > >
> > > The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> > > deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> > > same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
> > > socket_sq with socket itself") made those to have same life cycle.
> > >
> > > The changes made the code much more simple, but also made 'socket_alloc'
> > > live longer than before.  For the reason, user programs intensively
> > > repeating allocations and deallocations of sockets could cause memory
> > > pressure on recent kernels.
> >
> > I found this problem on a production virtual machine utilizing 4GB memory while
> > running lebench[1].  The 'poll big' test of lebench opens 1000 sockets, polls
> > and closes those.  This test is repeated 10,000 times.  Therefore it should
> > consume only 1000 'socket_alloc' objects at once.  As size of socket_alloc is
> > about 800 Bytes, it's only 800 KiB.  However, on the recent kernels, it could
> > consume up to 10,000,000 objects (about 8 GiB).  On the test machine, I
> > confirmed it consuming about 4GB of the system memory and results in OOM.
> >
> > [1] https://github.com/LinuxPerfStudy/LEBench
> 
> To be fair, I have not backported Al patches to Google production
> kernels, nor I have tried this benchmark.
> 
> Why do we have 10,000,000 objects around ? Could this be because of
> some RCU problem ?

Mainly because of a long RCU grace period, as you guess.  I have no idea how
the grace period became so long in this case.

As my test machine was a virtual machine instance, I guess RCU readers
preemption[1] like problem might affected this.

[1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf

> 
> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?

Yes, both the old kernel that prior to Al's patches and the recent kernel
reverting the Al's patches didn't reproduce the problem.


Thanks,
SeongJae Park

> 
> Thanks.
> 
> >
> > >
> > > To avoid the problem, this commit reverts the changes.
> >
> > I also tried to make fixup rather than reverts, but I couldn't easily find
> > simple fixup.  As the commits 6d7855c54e1e and 333f7909a857 were for code
> > refactoring rather than performance optimization, I thought introducing complex
> > fixup for this problem would make no sense.  Meanwhile, the memory pressure
> > regression could affect real machines.  To this end, I decided to quickly
> > revert the commits first and consider better refactoring later.
> >
> >
> > Thanks,
> > SeongJae Park
> >
> > >
> > > SeongJae Park (2):
> > >   Revert "coallocate socket_wq with socket itself"
> > >   Revert "sockfs: switch to ->free_inode()"
> > >
> > >  drivers/net/tap.c      |  5 +++--
> > >  drivers/net/tun.c      |  8 +++++---
> > >  include/linux/if_tap.h |  1 +
> > >  include/linux/net.h    |  4 ++--
> > >  include/net/sock.h     |  4 ++--
> > >  net/core/sock.c        |  2 +-
> > >  net/socket.c           | 23 ++++++++++++++++-------
> > >  7 files changed, 30 insertions(+), 17 deletions(-)
> > >
> > > --
> > > 2.17.1
