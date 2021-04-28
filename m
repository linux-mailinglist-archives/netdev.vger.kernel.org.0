Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A465936D3C0
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhD1IOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:14:47 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:30260 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1IOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619597641; x=1651133641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lH6gKKzDnBLSLUiWoNNJ7pa+DrbTroJokx0jp1w2ygo=;
  b=pJ9gQYtRZZO4HbZ2zvhIiVekNZLY58axq4rYS2S1nMSVXJyRXOlJUiqw
   C0VMPJOAEF1l1tsdDzJCWGcBuG8RtFAEUgaaa1wrljduRF6idicekj5En
   3RIhSrr0OwDLNv9iafh9kcNlOziilSl/bq0e9M5bJAJUx09SQguTur2j2
   w=;
X-IronPort-AV: E=Sophos;i="5.82,257,1613433600"; 
   d="scan'208";a="131388202"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 28 Apr 2021 08:14:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 414CFA212E;
        Wed, 28 Apr 2021 08:14:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 08:13:58 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.81) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 08:13:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <jbaron@akamai.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Wed, 28 Apr 2021 17:13:42 +0900
Message-ID: <20210428081342.1944-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
References: <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.81]
X-ClientProxiedBy: EX13D27UWB003.ant.amazon.com (10.43.161.195) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jason Baron <jbaron@akamai.com>
Date:   Tue, 27 Apr 2021 12:38:58 -0400
> On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
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
> 
> Hi Kuniyuki,
> 
> I had implemented a different approach to this that I wanted to get your
> thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
> listen fd (or any other fd) around. Currently, if you have an 'old' webserver
> that you want to replace with a 'new' webserver, you would need a separate
> process to receive the listen fd and then have that process send the fd to
> the new webserver, if they are not running con-currently. So instead what
> I'm proposing is a 'delayed close' for a unix socket. That is, one could do:
> 
> 1) bind unix socket with path '/sockets'
> 2) sendmsg() the listen fd via the unix socket
> 2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
> 3) exit/close the old webserver and the listen socket
> 4) start the new webserver
> 5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
> 6) recvmsg() the listen fd
> 
> So the idea is that we set a timeout on the unix socket. If the new process
> does not start and bind to the unix socket, it simply closes, thus releasing
> the listen socket. However, if it does bind it can now call recvmsg() and
> use the listen fd as normal. It can then simply continue to use the old listen
> fds and/or create new ones and drain the old ones.
> 
> Thus, the old and new webservers do not have to run concurrently. This doesn't
> involve any changes to the tcp layer and can be used to pass any type of fd.
> not sure if it's actually useful for anything else though.
> 
> I'm not sure if this solves your use-case or not but I thought I'd share it.
> One can also inherit the fds like in systemd's socket activation model, but
> that again requires another process to hold open the listen fd.

Thank you for sharing code.

It seems bit more crash-tolerant than normal fd passing, but it can still
suffer if the process dies before passing fds. With this patch set, we can
migrate children sockets even if the process dies.

Also, as Martin said, fd passing tends to make application complicated.

If we do not mind these points, your approach could be an option.


> 
> I have a very rough patch (emphasis on rough), that implements this idea that
> I'm attaching below to explain it better. It would need a bunch of fixups and
> it's against an older kernel, but hopefully gives this direction a better
> explanation.
> 
> Thanks,
> 
> -Jason
