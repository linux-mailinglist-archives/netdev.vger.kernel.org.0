Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865E05FBD37
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJKVyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJKVyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:54:33 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05F683078
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665525273; x=1697061273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L1vU/VCvdecToLoYPZBwH5/01apI34WvVm19qqfoyj4=;
  b=XfSsVyDyuuW9bz/2pErup584P8VzuGouDqzvIkFuh6FXEdzKut5L9rfs
   p6yFzbIU/l8MyQnR0Q60pTdtQuLylyX5m0+dnJXJf9eNpqaYOhwPVcJQX
   Y9DmgNmREEw7R1EodIrk5U5CJ0ywYfT1A+l8Nl0CGEwxneEy2gzTlA82I
   c=;
X-IronPort-AV: E=Sophos;i="5.95,177,1661817600"; 
   d="scan'208";a="139334039"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 21:54:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 493E1A212B;
        Tue, 11 Oct 2022 21:54:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 11 Oct 2022 21:54:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.58) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 11 Oct 2022 21:54:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <patchwork-bot+netdevbpf@kernel.org>
Subject: Re: [PATCH v6 net-next 0/6] tcp: Introduce optional per-netns ehash.
Date:   Tue, 11 Oct 2022 14:53:59 -0700
Message-ID: <20221011215359.13173-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com>
References: <CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D47UWC002.ant.amazon.com (10.43.162.83) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Oct 2022 14:46:03 -0700
> On Tue, Sep 20, 2022 at 12:00 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >
> > Hello:
> >
> > This series was applied to netdev/net-next.git (master)
> > by Jakub Kicinski <kuba@kernel.org>:
> >
> > On Wed, 7 Sep 2022 18:10:16 -0700 you wrote:
> > > The more sockets we have in the hash table, the longer we spend looking
> > > up the socket.  While running a number of small workloads on the same
> > > host, they penalise each other and cause performance degradation.
> > >
> > > The root cause might be a single workload that consumes much more
> > > resources than the others.  It often happens on a cloud service where
> > > different workloads share the same computing resource.
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [v6,net-next,1/6] tcp: Clean up some functions.
> >     https://git.kernel.org/netdev/net-next/c/08eaef904031
> >   - [v6,net-next,2/6] tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.
> >     https://git.kernel.org/netdev/net-next/c/e9bd0cca09d1
> >   - [v6,net-next,3/6] tcp: Set NULL to sk->sk_prot->h.hashinfo.
> >     https://git.kernel.org/netdev/net-next/c/429e42c1c54e
> >   - [v6,net-next,4/6] tcp: Access &tcp_hashinfo via net.
> >     https://git.kernel.org/netdev/net-next/c/4461568aa4e5
> >   - [v6,net-next,5/6] tcp: Save unnecessary inet_twsk_purge() calls.
> >     https://git.kernel.org/netdev/net-next/c/edc12f032a5a
> >   - [v6,net-next,6/6] tcp: Introduce optional per-netns ehash.
> >     https://git.kernel.org/netdev/net-next/c/d1e5e6408b30
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
> 
> Note that this series is causing issues.
> 
> BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
> include/net/inet_hashtables.h:181 [inline]
> BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
> net/ipv4/inet_connection_sock.c:913
> Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301
> 
> CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
> 6.0.0-syzkaller-02757-gaf7d23f9d96a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 09/22/2022
> Call Trace:
> <IRQ>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:317 [inline]
> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
> tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
> reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
> inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
> inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
> reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
> call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> expire_timers kernel/time/timer.c:1519 [inline]
> __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
> __run_timers kernel/time/timer.c:1768 [inline]
> run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
> __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
> invoke_softirq kernel/softirq.c:445 [inline]
> __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
> </IRQ>
> 
> We forgot to make sure there were no TCP_NEW_SYN_RECV sockets in the
> hash tables before deleting the hash tables.
> 
> Probably inet_twsk_purge() (when called when
> et->ipv4.tcp_death_row.hashinfo->pernet is true)
> also needs to remove all TCP_NEW_SYN_RECV request sockets.

Exactly, I'll do a quick test and post a fix.
Thank you for reporting!
