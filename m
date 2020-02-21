Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9AD167A12
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 11:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgBUKCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 05:02:08 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:28258 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgBUKCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 05:02:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582279327; x=1613815327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OdYkcQoWrMjc+iiAVAXc2tI9Lo7M+Wca7y8tkhQi4Xw=;
  b=C/omDTPoKDQy4Yef5D7yi6/p2JoBD9bm936p0NEo/827n2Hrp+uf3Bmb
   kQN5Gj8Zv3q+1iuJP9Vsh2yg8g3Jb4pQtXMTLmINhYn0nydx39IrQF/V3
   D3WoRqJ8B9Gavig0DEMqz6819jYhbeNKQiWldmTS8J1Pfud5ggGm30nTy
   8=;
IronPort-SDR: XyaypfgOrTgNxxnyyzmAcpEh5R9z/RzIvAKGHMjcygrRywOMtAAeoc+jttWX9Bde6eB3R8fnLP
 h2Vkh93IJorg==
X-IronPort-AV: E=Sophos;i="5.70,467,1574121600"; 
   d="scan'208";a="18017910"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Feb 2020 10:02:06 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 2EEA0A2EFE;
        Fri, 21 Feb 2020 10:02:03 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Feb 2020 10:02:02 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.109) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Feb 2020 10:01:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <david.laight@aculab.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Date:   Fri, 21 Feb 2020 19:01:55 +0900
Message-ID: <20200221100155.76241-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <2aead5c10d7c4bc6b80bbc5f079bef8e@AcuMS.aculab.com>
References: <2aead5c10d7c4bc6b80bbc5f079bef8e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.109]
X-ClientProxiedBy: EX13D23UWC004.ant.amazon.com (10.43.162.219) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 20 Feb 2020 17:11:46 +0000
> From: Kuniyuki Iwashima
> > Sent: 20 February 2020 15:20
> >
> > Currently we fail to bind sockets to ephemeral ports when all of the ports
> > are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> > we still have a chance to connect to the different remote hosts.
> >
> > The second and third patches fix the behaviour to fully utilize all space
> > of the local (addr, port) tuples.
> 
> Would it make sense to only do this for the implicit bind() done
> when connect() is called on an unbound socket?
> In that case only the quadruplet of the local and remote addresses
> needs to be unique.

The function to reserve a epehemral port is different between bind() and
connect(). 

  bind    : inet_csk_find_open_port
  connect : __inet_hash_connect

The connect() cannot use ports which are consumed by bind()
because __inet_hash_connect() fails to get a port if tb->fastreuse or
or tb->fastreuseport is not -1, which only __inet_hash_connect() sets.
On the other hand, bind() can use ports which are used by connect().

Moreover, we can call bind() before connect() to decide which IP to use.
By setting IP_BIND_ADDRESS_NO_PORT to socket, we can defer getting a port
until connect() is called. However, this means that getting port
is done by __inet_hash_connect, so that connect() may fail to get a local 
port if it is reserved by bind(). So if we want to reuse ports consumed by
bind(), we have to call bind() to get ports.

Without this patch, we may fail to get a ephemeral port and to fail to 
bind() in such case we should be able to reuse a local port when connecting
to remote hosts.
