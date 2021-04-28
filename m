Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9D36DC5C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240699AbhD1PuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:50:17 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:10856 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbhD1PuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619624970; x=1651160970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5gP6+mSSbZLik9ZO6F1dwO2PMgMAiYMMtpZswuKhD34=;
  b=lDfvjQFeCtZc8XscOVIe3n2E6kKWTOFHlBK+APs1ak4OXKtgJDoN1TUX
   M5RIKuTmRcgmZdjxzqrei78VPZ8fmK8NXt4WCZ4DzSXY7p9bQlGWOrRnH
   wQKhveYqpVT5vGylJNVmPox28TrT7xxnhvlJNRqLytTSJb6uGI1uuE5Qh
   s=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="131515488"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 28 Apr 2021 15:49:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 02007140B58;
        Wed, 28 Apr 2021 15:49:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 15:49:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.53) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 15:49:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <jbaron@akamai.com>,
        <kafai@fb.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Thu, 29 Apr 2021 00:49:15 +0900
Message-ID: <20210428154915.39653-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2f4b2039-1144-f26f-4ee7-2fbec7eb415b@gmail.com>
References: <2f4b2039-1144-f26f-4ee7-2fbec7eb415b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D38UWC002.ant.amazon.com (10.43.162.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 28 Apr 2021 16:18:30 +0200
> On 4/28/21 3:27 AM, Martin KaFai Lau wrote:
> > On Tue, Apr 27, 2021 at 12:38:58PM -0400, Jason Baron wrote:
> >>
> >>
> >> On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
> >>> The SO_REUSEPORT option allows sockets to listen on the same port and to
> >>> accept connections evenly. However, there is a defect in the current
> >>> implementation [1]. When a SYN packet is received, the connection is tied
> >>> to a listening socket. Accordingly, when the listener is closed, in-flight
> >>> requests during the three-way handshake and child sockets in the accept
> >>> queue are dropped even if other listeners on the same port could accept
> >>> such connections.
> >>>
> >>> This situation can happen when various server management tools restart
> >>> server (such as nginx) processes. For instance, when we change nginx
> >>> configurations and restart it, it spins up new workers that respect the new
> >>> configuration and closes all listeners on the old workers, resulting in the
> >>> in-flight ACK of 3WHS is responded by RST.
> >>
> >> Hi Kuniyuki,
> >>
> >> I had implemented a different approach to this that I wanted to get your
> >> thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
> >> listen fd (or any other fd) around. Currently, if you have an 'old' webserver
> >> that you want to replace with a 'new' webserver, you would need a separate
> >> process to receive the listen fd and then have that process send the fd to
> >> the new webserver, if they are not running con-currently. So instead what
> >> I'm proposing is a 'delayed close' for a unix socket. That is, one could do:
> >>
> >> 1) bind unix socket with path '/sockets'
> >> 2) sendmsg() the listen fd via the unix socket
> >> 2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
> >> 3) exit/close the old webserver and the listen socket
> >> 4) start the new webserver
> >> 5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
> >> 6) recvmsg() the listen fd
> >>
> >> So the idea is that we set a timeout on the unix socket. If the new process
> >> does not start and bind to the unix socket, it simply closes, thus releasing
> >> the listen socket. However, if it does bind it can now call recvmsg() and
> >> use the listen fd as normal. It can then simply continue to use the old listen
> >> fds and/or create new ones and drain the old ones.
> >>
> >> Thus, the old and new webservers do not have to run concurrently. This doesn't
> >> involve any changes to the tcp layer and can be used to pass any type of fd.
> >> not sure if it's actually useful for anything else though.
> > We also used to do tcp-listen(/udp) fd transfer because the new process can not
> > bind to the same IP:PORT in the old kernel without SO_REUSEPORT.  Some of the
> > services listen to many different IP:PORT(s).  Transferring all of them
> > was ok-ish but the old and new process do not necessary listen to the same set
> > of IP:PORT(s) (e.g. the config may have changed during restart) and it further
> > complicates the fd transfer logic in the userspace.
> > 
> > It was then moved to SO_REUSEPORT.  The new process can create its listen fds
> > without depending on the old process.  It pretty much starts as if there is
> > no old process.  There is no need to transfer the fds, simplified the userspace
> > logic.  The old and new process can work independently.  The old and new process
> > still run concurrently for a brief time period to avoid service disruption.
> > 
> 
> 
> Note that another technique is to force syncookies during the switch of old/new servers.
> 
> echo 2 >/proc/sys/net/ipv4/tcp_syncookies
> 
> If there is interest, we could add a socket option to override the sysctl on a per-socket basis.

It can be a work-around but syncookies has its own downside. Forcing it may
lose some valuable TCP options. If there is an approach without syncookies,
it is better.
