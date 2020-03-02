Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273D11752B2
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 05:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgCBEbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 23:31:32 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:8287 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgCBEbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 23:31:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583123491; x=1614659491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YGlIghSCWtITNJF/xJxvWTjBxch9udqFUB0gnJXOMKQ=;
  b=T9ZE0M0CXWIWvZE6A78SjK3gghQuf3PI2uWnm1Cf3ds/R8qYw5lXLIRa
   Z8/yCDE8gGAZaWM2VIO/JzMijxkk1lRp4SAkj+xGNSTYEzORqHJ7f4gKO
   JLPL0r52r/Py/YIUyo2dL6MnYZ7Y/Q3Zk44cH7K+S0IzT8fGK70eOiU9U
   Q=;
IronPort-SDR: n4qf2hZxibQ79Mdc44SvRH64RwNwlc8ikXYj1CQrrQlbbP7PkU9HRtIOtV0Ngnr3JLQWcZ/4yv
 28R55IqoCZ1w==
X-IronPort-AV: E=Sophos;i="5.70,506,1574121600"; 
   d="scan'208";a="20060971"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 02 Mar 2020 04:31:29 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 1E7A4A2B63;
        Mon,  2 Mar 2020 04:31:26 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 2 Mar 2020 04:31:26 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.74) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Mar 2020 04:31:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Mon, 2 Mar 2020 13:31:16 +0900
Message-ID: <20200302043116.19101-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <0b9db623-0a69-30e6-1e28-b6acb306c360@gmail.com>
References: <0b9db623-0a69-30e6-1e28-b6acb306c360@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.74]
X-ClientProxiedBy: EX13D13UWB002.ant.amazon.com (10.43.161.21) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Sun, 1 Mar 2020 19:42:25 -0800
> On 2/29/20 3:35 AM, Kuniyuki Iwashima wrote:
> > Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
> > condition for bind_conflict") introduced a restriction to forbid to bind
> > SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
> > assign ports dispersedly so that we can connect to the same remote host.
> > 
> > The change results in accelerating port depletion so that we fail to bind
> > sockets to the same local port even if we want to connect to the different
> > remote hosts.
> > 
> > You can reproduce this issue by following instructions below.
> >   1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
> >   2. set SO_REUSEADDR to two sockets.
> >   3. bind two sockets to (address, 0) and the latter fails.
> > 
> > Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
> > fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
> > it possible to connect to different remote (addr, port) tuples.
> > 
> > This patch allows us to bind SO_REUSEADDR enabled sockets to the same
> > (addr, port) only when all ephemeral ports are exhausted.
> > 
> > The only notable thing is that if all sockets bound to the same port have
> > both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
> > ephemeral port and also do listen().
> > 
> > Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
> I am unsure about this, since this could double the time taken by this
> function, which is already very time consuming.

This patch doubles the time on choosing a port only when all ephemeral ports
are exhausted, and this fallback behaviour can eventually decreases the time
on waiting for ports to be released. We cannot know when the ports are
released, so we may not be able to reuse ports without this patch. This
patch gives more chace and raises the probability to succeed to bind().

> We added years ago IP_BIND_ADDRESS_NO_PORT socket option, so that the kernel
> has more choices at connect() time (instead of bind()) time to choose a source port.
>
> This considerably lowers time taken to find an optimal source port, since
> the kernel has full information (source address, destination address & port)

I also think this option is usefull, but it does not allow us to reuse
ports that is reserved by bind(). This is because connect() can reuse ports
only when their tb->fastresue and tb->fastreuseport is -1. So we still
cannot fully utilize 4-tuples.

https://lore.kernel.org/netdev/20200221100155.76241-1-kuniyu@amazon.co.jp/#t

Thanks.
