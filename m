Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8132B9D57
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgKSWFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:05:22 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:40966 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKSWFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:05:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605823522; x=1637359522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NNbBtZjCXMsp/4fAvjLPa6JOaO0+DpCcEqpiZ7EczYg=;
  b=oYARo9sC4KbPLUoo6+UOHC7x0AToj3YdfuRtX0rKL/lqlv+x9NNKKXah
   ISFb6BI7UxMrbj6uNn9evlB2A/6DMtU8y29jqoWBaS5iXu7YOvq52Plzc
   XECQnJR3VvsjnCs+BftUKdTn2jVCRIOV82ymEyY6fcDA/VuZmjFT9v71d
   0=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="97172015"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Nov 2020 22:05:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 2A830A18E8;
        Thu, 19 Nov 2020 22:05:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:05:17 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:05:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Date:   Fri, 20 Nov 2020 07:05:09 +0900
Message-ID: <20201119220509.74768-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <5feaafd3-72ca-72da-0fe8-cc4206bc29e6@gmail.com>
References: <5feaafd3-72ca-72da-0fe8-cc4206bc29e6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.55]
X-ClientProxiedBy: EX13D33UWB003.ant.amazon.com (10.43.161.92) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 18 Nov 2020 17:25:44 +0100
> On 11/17/20 10:40 AM, Kuniyuki Iwashima wrote:
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
> 
> I know some programs are simply removing a listener from the group,
> so that they no longer handle new SYN packets,
> and wait until all timers or 3WHS have completed before closing them.
> 
> They pass fd of newly accepted children to more recent programs using af_unix fd passing,
> while in this draining mode.

Just out of curiosity, can I know the software for more study?


> Quite frankly, mixing eBPF in the picture is distracting.

I agree.
Also, I think eBPF itself is not always necessary in many cases and want
to make user programs simpler with this patchset.

The SO_REUSEPORT implementation is excellent to improve the scalability. On
the other hand, as a trade-off, users have to know deeply how the kernel
handles SYN packets and to implement connection draining by eBPF.


> It seems you want some way to transfer request sockets (and/or not yet accepted established ones)
> from fd1 to fd2, isn't it something that should be discussed independently ?

I understand that you are asking that I should discuss the issue and how to
transfer sockets independently. Please correct me if I have misunderstood
your question.

The kernel handles 3WHS and users cannot know its existence (without eBPF).
Many users believe SO_REUSEPORT should make it possible to distribute all
connections across available listeners ideally, but actually, there are
possibly some connections aborted silently. Some user may think that if the
kernel selected other listeners, the connections would not be dropped.

The root cause is within the kernel, so the issue should be addressed in
the kernel space and should not be visible to userspace. In order not to
make users bother with implementing new some stuff, I want to fix the root
cause by transferring sockets automatically so that users need not take
care of kernel implementation and connection draining.

Moreover, if possible, I did not want to mix eBPF with the issue. But there
may be some cases that different applications listen on the same port and
eBPF routes packets to each by some rules. In such cases, redistributing
sockets without user intention will break the application. This patchset
will work in many cases, but to care such cases, I added the eBPF part.
