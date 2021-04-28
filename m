Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F7936DC7C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbhD1Pxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:53:41 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63948 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbhD1Pxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619625174; x=1651161174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FnCAkov60OO7Dxf0WEMBA9HQ3rKhJnjcWSSFi9gB2V8=;
  b=t+vRPr8+sM854VmJM24YqiBkqCEB8HL8sxQIGENvrNeQlmgqn7s9QIsy
   ZFuOVcK5QE9+bdzGthjaiMrsl2trIjLjKo4nJy5OPjtn+zjGoaT7+zpPW
   arzWfI4daSkF8N+wIRFfPSYpLFo3lecb5tuSrtckP2IczDXz+40R2VsCM
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="104526758"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 28 Apr 2021 15:52:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 66924A1CD9;
        Wed, 28 Apr 2021 15:52:13 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 15:52:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.26) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 15:52:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <jbaron@akamai.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Thu, 29 Apr 2021 00:52:03 +0900
Message-ID: <20210428155203.39974-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <fabd0598-c62e-ea88-f340-050136bb8266@akamai.com>
References: <fabd0598-c62e-ea88-f340-050136bb8266@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D38UWC002.ant.amazon.com (10.43.162.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jason Baron <jbaron@akamai.com>
Date:   Wed, 28 Apr 2021 10:44:12 -0400
> On 4/28/21 4:13 AM, Kuniyuki Iwashima wrote:
> > From:   Jason Baron <jbaron@akamai.com>
> > Date:   Tue, 27 Apr 2021 12:38:58 -0400
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
> >>
> >> I'm not sure if this solves your use-case or not but I thought I'd share it.
> >> One can also inherit the fds like in systemd's socket activation model, but
> >> that again requires another process to hold open the listen fd.
> > 
> > Thank you for sharing code.
> > 
> > It seems bit more crash-tolerant than normal fd passing, but it can still
> > suffer if the process dies before passing fds. With this patch set, we can
> > migrate children sockets even if the process dies.
> > 
> 
> I don't think crashing should be much of an issue. The old server can setup the
> unix socket patch '/sockets' when it starts up and queue the listen sockets
> there from the start. When it dies it will close all its fds, and the new
> server can pick anything up any fds that are in the '/sockets' queue.
> 
> 
> > Also, as Martin said, fd passing tends to make application complicated.
> > 
> 
> It may be but perhaps its more flexible? It gives the new server the
> chance to re-use the existing listen fds, close, drain and/or start new
> ones. It also addresses the non-REUSEPORT case where you can't bind right
> away.

If the flexibility is really worth the complexity, we do not care about it.
But, SO_REUSEPORT can give enough flexibility we want.

With socket migration, there is no need to reuse listener (fd passing),
drain children (incoming connections are automatically migrated if there is
already another listener bind()ed), and of course another listener can
close itself and migrated children.

If two different approaches resolves the same issue and one does not need
complexity in userspace, we select the simpler one.
