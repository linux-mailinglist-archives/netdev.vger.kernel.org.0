Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F96F1C5D24
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgEEQNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:13:43 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:5592 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbgEEQNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588695222; x=1620231222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=KzvE+DVjzy/zrI1y9QhRcUUXKHj3IDMUSCkxhsXLtEM=;
  b=k1HmngUNjFBQkv/HnRiY35X/2hF2jlysrf67YglREdRs0vRKuGHZKeOg
   B97YimC78pbA0oSPrXzZn046ox+ze0YnISZG0wDblOvDU2xKT5BhmmB3L
   xhtKwWoEAP5G2Y3D52L4OPzbcv5MltSQQAqVJltO/J/XcA63Ni2EGe9F7
   I=;
IronPort-SDR: xjLM36pNFmpanr4FmO5MQR+NRdJl03/cefOtoL7Zf9khbQnmUXqUq526sBI2b1Ohg3vf9AZLE1
 3VvwQM1ViZXg==
X-IronPort-AV: E=Sophos;i="5.73,355,1583193600"; 
   d="scan'208";a="33080699"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 May 2020 16:13:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 5D662A21BE;
        Tue,  5 May 2020 16:13:35 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 16:13:34 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.26) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 16:13:25 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 18:13:02 +0200
Message-ID: <20200505161302.547-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iLHV2wyhk6-d6j_4=Ns01AEE5HSA4Qu3LO0gqKgcG81vQ@mail.gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D21UWB002.ant.amazon.com (10.43.161.177) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:

> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
> >
> > On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > >
> > >
> > > On 5/5/20 8:07 AM, SeongJae Park wrote:
> > > > On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > >
> > > >> Why do we have 10,000,000 objects around ? Could this be because of
> > > >> some RCU problem ?
> > > >
> > > > Mainly because of a long RCU grace period, as you guess.  I have no idea how
> > > > the grace period became so long in this case.
> > > >
> > > > As my test machine was a virtual machine instance, I guess RCU readers
> > > > preemption[1] like problem might affected this.
> > > >
> > > > [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
> > > >
> > > >>
> > > >> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
> > > >
> > > > Yes, both the old kernel that prior to Al's patches and the recent kernel
> > > > reverting the Al's patches didn't reproduce the problem.
> > > >
> > >
> > > I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
> > >
> > > TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
> > > object that was allocated in sock_alloc_inode() before Al patches.
> > >
> > > These objects should be visible in kmalloc-64 kmem cache.
> >
> > Not exactly the 10,000,000, as it is only the possible highest number, but I
> > was able to observe clear exponential increase of the number of the objects
> > using slabtop.  Before the start of the problematic workload, the number of
> > objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
> > to 1,136,576.
> >
> >           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> > before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
> > after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
> >
> 
> Great, thanks.
> 
> How recent is the kernel you are running for your experiment ?

It's based on 5.4.35.

> 
> Let's make sure the bug is not in RCU.

One thing I can currently say is that the grace period passes at last.  I
modified the benchmark to repeat not 10,000 times but only 5,000 times to run
the test without OOM but easily observable memory pressure.  As soon as the
benchmark finishes, the memory were freed.

If you need more tests, please let me know.


Thanks,
SeongJae Park

> 
> After Al changes, RCU got slightly better under stress.
> 
