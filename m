Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222312B9D48
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgKSWBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:01:54 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6946 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgKSWBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605823315; x=1637359315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dPnWxdnajZFQOuvUOMzQJleM8jxXhD+BGr5YatZS0dM=;
  b=fGm014lUe221JAnqbs/JOQ+AmCqGPju2VlSj6aOLf6pMZ2+TloMHnkTT
   QFgZI/gocJMGjObddNXctPT5pAIz+t0fe3kkPfQRjBl5kZOVyPrPDH3B+
   ajuMpgMVRgVs9SP5nRsiUw9wJmeLbbHGk2SPtIlHIS5+dxGJCWIGndBsG
   E=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="66094964"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Nov 2020 22:01:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id 4D42AA1F2D;
        Thu, 19 Nov 2020 22:01:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:01:50 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:01:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <david.laight@aculab.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: RE: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Date:   Fri, 20 Nov 2020 07:01:41 +0900
Message-ID: <20201119220141.73844-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <01a5c211a87a4dd69940e19c2ff00334@AcuMS.aculab.com>
References: <01a5c211a87a4dd69940e19c2ff00334@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D46UWB004.ant.amazon.com (10.43.161.204) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Laight <David.Laight@ACULAB.COM>
Date:   Wed, 18 Nov 2020 09:18:24 +0000
> From: Kuniyuki Iwashima
> > Sent: 17 November 2020 09:40
> > 
> > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > accept connections evenly. However, there is a defect in the current
> > implementation. When a SYN packet is received, the connection is tied to a
> > listening socket. Accordingly, when the listener is closed, in-flight
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners could accept such connections.
> > 
> > This situation can happen when various server management tools restart
> > server (such as nginx) processes. For instance, when we change nginx
> > configurations and restart it, it spins up new workers that respect the new
> > configuration and closes all listeners on the old workers, resulting in
> > in-flight ACK of 3WHS is responded by RST.
> 
> Can't you do something to stop new connections being queued (like
> setting the 'backlog' to zero), then carry on doing accept()s
> for a guard time (or until the queue length is zero) before finally
> closing the listening socket.

Yes, but with eBPF.
There are some ideas suggested and well discussed in the thread below,
resulting in that connection draining by eBPF was merged.
https://lore.kernel.org/netdev/1443313848-751-1-git-send-email-tolga.ceylan@gmail.com/


Also, setting zero to backlog does not work well.
https://lore.kernel.org/netdev/1447262610.17135.114.camel@edumazet-glaptop2.roam.corp.google.com/

---8<---
From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as
 drain mode
Date: Wed, 11 Nov 2015 09:23:30 -0800
> Actually listen(fd, 0) is not going to work well :
> 
> For request_sock that were created (by incoming SYN packet) before this
> listen(fd, 0) call, the 3rd packet (ACK coming from client) would not be
> able to create a child attached to this listener.
> 
> sk_acceptq_is_full() test in tcp_v4_syn_recv_sock() would simply drop
> the thing.
---8<---
