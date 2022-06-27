Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2555CBEA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbiF0UAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237891AbiF0UAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:00:21 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72B1C919
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 13:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656360020; x=1687896020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMhrZmTY0x9LdBT8G8QBuHNJLR/RzKJQhpecwJxQcPA=;
  b=u2EpTCbZrrRy+M0AR6nZOvfpe0yeZKWHnJk7rz4zcbRk77Ou6WHJWSXA
   dkCWBMrnMg9gQwQaclSbydStGOs0viUf75E5+nkd3KqQtD7iLX5Ws7aCB
   qT46QuHMvPz0ETzCqsjw2P86lB9HM4EeJQIFLVoubGknaVsLIdH0LrIwt
   o=;
X-IronPort-AV: E=Sophos;i="5.92,227,1650931200"; 
   d="scan'208";a="232578179"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 27 Jun 2022 20:00:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com (Postfix) with ESMTPS id 9679786DFE;
        Mon, 27 Jun 2022 20:00:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 20:00:00 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.134) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 19:59:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <herbert@gondor.apana.org.au>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <xemul@openvz.org>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Mon, 27 Jun 2022 12:59:49 -0700
Message-ID: <20220627195949.12000-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJsk7g0LcH17u=JbLy5dwYi0QVg84b3c5eLf-zUTK5b8g@mail.gmail.com>
References: <CANn89iJsk7g0LcH17u=JbLy5dwYi0QVg84b3c5eLf-zUTK5b8g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D11UWC001.ant.amazon.com (10.43.162.151) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 21:36:18 +0200
> On Mon, Jun 27, 2022 at 9:16 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Mon, 27 Jun 2022 21:06:14 +0200
> > > On Mon, Jun 27, 2022 at 8:59 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Mon, 27 Jun 2022 20:40:24 +0200
> > > > > On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > >
> > > > > > From:   Jakub Kicinski <kuba@kernel.org>
> > > > > > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > > > > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > > > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > > > > > >
> > > > > > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > > > > > table and can use it directly.
> > > > > > > >
> > > > > > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > > > >
> > > > > > > > I am not quite certain the savings of a single entry table justivies
> > > > > > > > the complexity.  But the looks correct.
> > > > > > >
> > > > > > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > > > > > Could you add more details to explain the motivation?
> > > > > >
> > > > > > I was working on a series which converts UDP/TCP hash tables into per-netns
> > > > > > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > > > > > memory on a host with thousands of netns, but it can be waste if we do not
> > > > > > have its protocol family's sockets.
> > > > >
> > > > > For the record, I doubt we will accept such a patch (per net-ns
> > > > > TCP/UDP hash tables)
> > > >
> > > > Is it because it's risky?
> > >
> > > Because it will be very expensive. TCP hash tables are quite big.
> >
> > Yes, so I'm wondering if changing the size by sysctl makes sense.  If we
> > have per-netns hash tables, each table should have smaller amount of
> > sockets and smaller size should be enough, I think.
> 
> How can a sysctl be safely used if two different threads call "unshare
> -n" at the same time ?

I think two unshare are safe. Each of them reads its parent netns's sysctl
knob.  Even when the parent is the same, they can read the same value.

But I think we need READ_ONCE()/WRITE_ONCE() in such a sysctl.  While
creating a child netns, another one can change the value and there can be
a data-race.  So we have to use custome handler and pass write/read handler
as conv of do_proc_douintvec(), like do_proc_douintvec_conv_lockless().

If there are some sysctls missing READ_ONCE/WRITE_ONCE(), I will add
more general one, proc_douintvec_lockless().


> > > [    4.917080] tcp_listen_portaddr_hash hash table entries: 65536
> > > (order: 8, 1048576 bytes, vmalloc)
> > > [    4.917260] TCP established hash table entries: 524288 (order: 10,
> > > 4194304 bytes, vmalloc hugepage)
> > > [    4.917760] TCP bind hash table entries: 65536 (order: 8, 1048576
> > > bytes, vmalloc)
> > > [    4.917881] TCP: Hash tables configured (established 524288 bind 65536)
> > >
> > >
> > >
> > > > IIRC, you said we need per netns table for TCP in the future.
> > >
> > > Which ones exactly ? I guess you misunderstood.
> >
> > I think this.
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=04c494e68a13
> 
> "might" is very different than "will"
> 
> I would rather use the list of time_wait, instead of adding huge
> memory costs for hosts with hundreds of netns.

Sorry, my bad.
I would give it a try only for TIME_WAIT.
