Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0583669ED
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbhDULbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 07:31:36 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:18416 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhDULbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 07:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619004663; x=1650540663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m44H9UlREXJutWtfXlrZv56v4ty8OWzxEvIzG99Sj88=;
  b=abE92+GEGPN0fzgGoZDOYpr9WsBZTQkOwgESm8Fam5H1vNJrkaD83Bsx
   9FpIrHndq/5YyPsGCqClRT5IRmDiBUkGn7mJm+3UwmpoEexT8S5bT5cpl
   oiWJiKw+RPAq/nSRDKyXr4/GwAhVsEiJcavdRVt2ptbrhD24GTO4NMhMz
   U=;
X-IronPort-AV: E=Sophos;i="5.82,238,1613433600"; 
   d="scan'208";a="927936471"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 21 Apr 2021 11:31:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id B96431010AD;
        Wed, 21 Apr 2021 11:30:56 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 11:30:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 11:30:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Wed, 21 Apr 2021 20:30:45 +0900
Message-ID: <20210421113045.88269-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <67fb2df2-3703-4ce9-62d0-ba15435c5a0b@gmail.com>
References: <67fb2df2-3703-4ce9-62d0-ba15435c5a0b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.41]
X-ClientProxiedBy: EX13D10UWA001.ant.amazon.com (10.43.160.216) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Tue, 20 Apr 2021 18:43:36 +0200
> On 4/20/21 5:41 PM, Kuniyuki Iwashima wrote:
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
> > The SO_REUSEPORT option is excellent to improve scalability.
> 
> This was before the SYN processing was made lockless.
>
> I really wonder if we still need SO_REUSEPORT for TCP ?

I'm sorry this might be misleading. This was an old topic in v3.5. Also,
scalability or performance are not the primary reason to use SO_REUSEPORT
for now.

There are cases which need SO_REUSEPORT for other reasons.

If servers take both UDP and TCP requests (for example, proxy of QUIC and
HTTP2), it is nice to have the same eBPF mechanism to handle UDP and TCP.

Also, about reloading configurations, some applications want to keep it
simple to reload configurations by replacing processes.

Then, even with the new accept() syscall, I think there would be migration
(of queue or of children) needed. If the way was like fd passing, it might
not work when the process died in the middle of fd passing.

So, I think it is better to do migration in kernel without interaction with
the old process.

In this point, SO_REUSEPORT is good because we can bind a new process
without interaction with the old process. And with this patchset, we can
migrate requests by close()/shutdown() the old listener.


> 
> Eventually a new accept() system call where different threads
> can express how they want to choose the children sockets would
> be less invasive.
> 
> Instead of having many listeners, have one listener and eventually multiple
> accept queues to improve scalability of accept() phase.

It sounds interesting. Could you elaborate the idea ?

And sorry, I couldn't understand correctly what "invasive" means. Does it
mean the new accept() will have less change or more simple API or something
other ?

Also, I wonder if the new accept() has similar flexibility as eBPF does.
