Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA02BBE65
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 11:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKUKNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 05:13:48 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:61637 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKUKNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 05:13:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605953627; x=1637489627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sWEOxI7muAIsnweqdEEF9gqvvegGjKtMi9NaOGJpSMs=;
  b=kHC9JCzyObNDj2zBbLc09cg4NTeIcubutOzSvLN7y6BqppMi7fdQnnt/
   M5uiT2yppecFR0pBE5NU+MpjLYccgloL/Ntzwt7kyPjShCfR/xRhn39kM
   jP51ialKgQ1Jeu7CkVdzVzVvgwhxMGsOKtHHNK5va314kOHx7d9hbWoau
   g=;
X-IronPort-AV: E=Sophos;i="5.78,359,1599523200"; 
   d="scan'208";a="67907410"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Nov 2020 10:13:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id 73D1DC1314;
        Sat, 21 Nov 2020 10:13:43 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 21 Nov 2020 10:13:42 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.50) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 21 Nov 2020 10:13:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 3/8] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Sat, 21 Nov 2020 19:13:22 +0900
Message-ID: <20201121101322.97015-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201120015346.sokqxwx4uavmoctz@kafai-mbp.dhcp.thefacebook.com>
References: <20201120015346.sokqxwx4uavmoctz@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWB003.ant.amazon.com (10.43.161.222) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 19 Nov 2020 17:53:46 -0800
> On Fri, Nov 20, 2020 at 07:09:22AM +0900, Kuniyuki Iwashima wrote:
> > From: Martin KaFai Lau <kafai@fb.com>
> > Date: Wed, 18 Nov 2020 15:50:17 -0800
> > > On Tue, Nov 17, 2020 at 06:40:18PM +0900, Kuniyuki Iwashima wrote:
> > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > which is used only by inet_unhash(). If it is not NULL,
> > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > sockets from the closing listener to the selected one.
> > > > 
> > > > Listening sockets hold incoming connections as a linked list of struct
> > > > request_sock in the accept queue, and each request has reference to a full
> > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we unlink the
> > > > requests from the closing listener's queue and relink them to the head of
> > > > the new listener's queue. We do not process each request, so the migration
> > > > completes in O(1) time complexity. However, in the case of TCP_SYN_RECV
> > > > sockets, we will take special care in the next commit.
> > > > 
> > > > By default, we select the last element of socks[] as the new listener.
> > > > This behaviour is based on how the kernel moves sockets in socks[].
> > > > 
> > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > first two by turns. The sockets move in socks[] like below. (See also [1])
> > > > 
> > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > >   socks[2] : C   |      socks[2] : C --'
> > > >   socks[3] : D --'
> > > > 
> > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > requests evenly to new listeners.
> > > I don't think it should emphasize/claim there is a specific way that
> > > the kernel-pick here can redistribute the requests evenly.  It depends on
> > > how the application close/listen.  The userspace can not expect the
> > > ordering of socks[] will behave in a certain way.
> > 
> > I've expected replacing listeners by generations as a general use case.
> > But exactly. Users should not expect the undocumented kernel internal.
> > 
> > 
> > > The primary redistribution policy has to depend on BPF which is the
> > > policy defined by the user based on its application logic (e.g. how
> > > its binary restart work).  The application (and bpf) knows which one
> > > is a dying process and can avoid distributing to it.
> > > 
> > > The kernel-pick could be an optional fallback but not a must.  If the bpf
> > > prog is attached, I would even go further to call bpf to redistribute
> > > regardless of the sysctl, so I think the sysctl is not necessary.
> > 
> > I also think it is just an optional fallback, but to pick out a different
> > listener everytime, choosing the moved socket was reasonable. So the even
> > redistribution for a specific use case is a side effect of such socket
> > selection.
> > 
> > But, users should decide to use either way:
> >   (1) let the kernel select a new listener randomly
> >   (2) select a particular listener by eBPF
> > 
> > I will update the commit message like:
> > The kernel selects a new listener randomly, but as the side effect, it can
> > redistribute packets evenly for a specific case where an application
> > replaces listeners by generations.
> Since there is no feedback on sysctl, so may be something missed
> in the lines.

I'm sorry, I have missed this point while thinking about each reply...


> I don't think this migration logic should depend on a sysctl.
> At least not when a bpf prog is attached that is capable of doing
> migration, it is too fragile to ask user to remember to turn on
> the sysctl before attaching the bpf prog.
> 
> Your use case is to primarily based on bpf prog to pick or only based
> on kernel to do a random pick?

I think we have to care about both cases.

I think we can always enable the migration feature if eBPF prog is not
attached. On the other hand, if BPF_PROG_TYPE_SK_REUSEPORT prog is attached
to select a listener by some rules, along updating the kernel,
redistributing requests without user intention can break the application.
So, there is something needed to confirm user intension at least if eBPF
prog is attached.

But honestly, I believe such eBPF users can follow this change and
implement migration eBPF prog if we introduce such a breaking change.


> Also, IIUC, this sysctl setting sticks at "*reuse", there is no way to
> change it until all the listening sockets are closed which is exactly
> the service disruption problem this series is trying to solve here.

Oh, exactly...
If we apply this series by live patching, we cannot enable the feature
without service disruption.

To enable the migration feature dynamically, how about this logic?
In this logic, we do not save the sysctl value and check it at each time.

  1. no eBPF prog attached -> ON
  2. eBPF prog attached and sysctl is 0 -> OFF
  3. eBPF prog attached and sysctl is 1 -> ON

So, replacing 

  if (reuse->migrate_req)

to 

  if (!reuse->prog || net->ipv4.sysctl_tcp_migrate_req)
