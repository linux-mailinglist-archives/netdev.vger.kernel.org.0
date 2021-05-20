Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B028538A07A
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 10:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhETJAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 05:00:24 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:4920 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhETJAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 05:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621501143; x=1653037143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=no9PnC7ByGDo1gM/bT84lXIETBhtfnlKSpWwpRPaUhw=;
  b=g2db0lf6nqHeZg2oyjCIuWps2pLvaniB7EPQHgoUZ0+5VkqJQP4mD72G
   0aXDWjq9iMtmYVry/4Ozk/BI5xi9AABJauCNgz+txT1NLKsp3KRbSbz4h
   JDpqO23DadXs3845RkLrNpwtp2X29Lw8UODCnaoVEbc35MINX+3dm3fOs
   s=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="2272361"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-28209b7b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 20 May 2021 08:59:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-28209b7b.us-east-1.amazon.com (Postfix) with ESMTPS id 13B14A5FE4;
        Thu, 20 May 2021 08:59:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 08:58:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.137) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 08:58:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Thu, 20 May 2021 17:58:49 +0900
Message-ID: <20210520085849.49799-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520063029.vrnv5eld6w4glea6@kafai-mbp.dhcp.thefacebook.com>
References: <20210520063029.vrnv5eld6w4glea6@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D15UWA002.ant.amazon.com (10.43.160.218) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 19 May 2021 23:30:29 -0700
> On Mon, May 17, 2021 at 09:22:47AM +0900, Kuniyuki Iwashima wrote:
> > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > accept connections evenly. However, there is a defect in the current
> > implementation [1]. When a SYN packet is received, the connection is tied
> > to a listening socket. Accordingly, when the listener is closed, in-flight
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners on the same port could accept
> > such connections.
> > 
> > This situation can happen when various server management tools restart
> > server (such as nginx) processes. For instance, when we change nginx
> > configurations and restart it, it spins up new workers that respect the new
> > configuration and closes all listeners on the old workers, resulting in the
> > in-flight ACK of 3WHS is responded by RST.
> > 
> > To avoid such a situation, users have to know deeply how the kernel handles
> > SYN packets and implement connection draining by eBPF [2]:
> > 
> >   1. Stop routing SYN packets to the listener by eBPF.
> >   2. Wait for all timers to expire to complete requests
> >   3. Accept connections until EAGAIN, then close the listener.
> > 
> >   or
> > 
> >   1. Start counting SYN packets and accept syscalls using the eBPF map.
> >   2. Stop routing SYN packets.
> >   3. Accept connections up to the count, then close the listener.
> > 
> > In either way, we cannot close a listener immediately. However, ideally,
> > the application need not drain the not yet accepted sockets because 3WHS
> > and tying a connection to a listener are just the kernel behaviour. The
> > root cause is within the kernel, so the issue should be addressed in kernel
> > space and should not be visible to user space. This patchset fixes it so
> > that users need not take care of kernel implementation and connection
> > draining. With this patchset, the kernel redistributes requests and
> > connections from a listener to the others in the same reuseport group
> > at/after close or shutdown syscalls.
> > 
> > Although some software does connection draining, there are still merits in
> > migration. For some security reasons, such as replacing TLS certificates,
> > we may want to apply new settings as soon as possible and/or we may not be
> > able to wait for connection draining. The sockets in the accept queue have
> > not started application sessions yet. So, if we do not drain such sockets,
> > they can be handled by the newer listeners and could have a longer
> > lifetime. It is difficult to drain all connections in every case, but we
> > can decrease such aborted connections by migration. In that sense,
> > migration is always better than draining. 
> > 
> > Moreover, auto-migration simplifies user space logic and also works well in
> > a case where we cannot modify and build a server program to implement the
> > workaround.
> > 
> > Note that the source and destination listeners MUST have the same settings
> > at the socket API level; otherwise, applications may face inconsistency and
> > cause errors. In such a case, we have to use the eBPF program to select a
> > specific listener or to cancel migration.
> > 
> > Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> > snippets along the way.
> > 
> > 
> > Link:
> >  [1] The SO_REUSEPORT socket option
> >  https://lwn.net/Articles/542629/ 
> > 
> >  [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
> >  https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/
> > 
> > 
> > Changelog:
> >  v6:
> >   * Change description in ip-sysctl.rst
> >   * Test IPPROTO_TCP before reading tfo_listener
> >   * Move reqsk_clone() to inet_connection_sock.c and rename to
> >     inet_reqsk_clone()
> >   * Pass req->rsk_listener to inet_csk_reqsk_queue_drop() and
> >     reqsk_queue_removed() in the migration path of receiving ACK
> >   * s/ARG_PTR_TO_SOCKET/PTR_TO_SOCKET/ in sk_reuseport_is_valid_access()
> >   * In selftest, use atomic ops to increment global vars, drop ACK by XDP,
> >     enable force fastopen, use "skel->bss" instead of "skel->data"
> Some commit messages need to be updated: s/reqsk_clone/inet_reqsk_clone/

I'll fix them.


> 
> One thing needs to be addressed in patch 3.
> 
> Others lgtm.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thank you!!

I'll respin after the discussion about 3rd patch.
