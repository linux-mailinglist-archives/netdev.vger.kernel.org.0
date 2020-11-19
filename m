Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625F92B9D84
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgKSWSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:18:01 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:52928 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgKSWSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605824280; x=1637360280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=naMwbifHzZmoRi9T57FZ79pmFr4gy3EnvcPKguxXddA=;
  b=ESA3OsRa5kTDZjfR+Vb9NccXSwWIXAVdMvBYpo4UGhnzaIrsHVSlVl4L
   eX3FpoPfi1igyUOYP8dejd0suGRBrBN8iAM4p+LZ/qprUuBN5drvfd2+D
   IWW8jO+okN+IQs/87mFvfG2himG5dFcGJXmzIP2fOCHG4/a00dMiEZA6a
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="67539727"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Nov 2020 22:17:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 468E7A2134;
        Thu, 19 Nov 2020 22:17:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:17:57 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.229) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:17:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Date:   Fri, 20 Nov 2020 07:17:49 +0900
Message-ID: <20201119221749.77783-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201119014913.syllymkfcohcdt4q@kafai-mbp.dhcp.thefacebook.com>
References: <20201119014913.syllymkfcohcdt4q@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D24UWB003.ant.amazon.com (10.43.161.222) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 18 Nov 2020 17:49:13 -0800
> On Tue, Nov 17, 2020 at 06:40:15PM +0900, Kuniyuki Iwashima wrote:
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
> > 
> > As a workaround for this issue, we can do connection draining by eBPF:
> > 
> >   1. Before closing a listener, stop routing SYN packets to it.
> >   2. Wait enough time for requests to complete 3WHS.
> >   3. Accept connections until EAGAIN, then close the listener.
> > 
> > Although this approach seems to work well, EAGAIN has nothing to do with
> > how many requests are still during 3WHS. Thus, we have to know the number
> It sounds like the application can already drain the established socket
> by accept()?  To solve the problem that you have,
> does it mean migrating req_sk (the in-progress 3WHS) is enough?

Ideally, the application needs to drain only the accepted sockets because
3WHS and tying a connection to a listener are just kernel behaviour. Also,
there are some cases where we want to apply new configurations as soon as
possible such as replacing TLS certificates.

It is possible to drain the established sockets by accept(), but the
sockets in the accept queue have not started application sessions yet. So,
if we do not drain such sockets (or if the kernel happened to select
another listener), we can (could) apply the new settings much earlier.

Moreover, the established sockets may start long-standing connections so
that we cannot complete draining for a long time and may have to
force-close them (and they would have longer lifetime if they are migrated
to a new listener).


> Applications can already use the bpf prog to do (1) and divert
> the SYN to the newly started process.
> 
> If the application cares about service disruption,
> it usually needs to drain the fd(s) that it already has and
> finishes serving the pending request (e.g. https) on them anyway.
> The time taking to finish those could already be longer than it takes
> to drain the accept queue or finish off the 3WHS in reasonable time.
> or the application that you have does not need to drain the fd(s) 
> it already has and it can close them immediately?

In the point of view of service disruption, I agree with you.

However, I think that there are some situations where we want to apply new
configurations rather than to drain sockets with old configurations and
that if the kernel migrates sockets automatically, we can simplify user
programs.

