Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F07417F134
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgCJHlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:41:32 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:54708 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgCJHlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583826091; x=1615362091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=C9pqtl2jl3UmwFUiNmWGqxpiEO0oRelcrgpuVPAwu6c=;
  b=CLenHMeSM1zEuO0DysDY62Ly7J/TWlIkGePGCnFKxv3avZn+lA4dAMFz
   tbHCO63I8/ICebOmktuS7uDmu0BB8Yw5b+igZlZscdfYXsRTyxC1ZDTvu
   2nsqYT+rot98WlcviIrqdDvUGnL4fVOMUA3Z30beDay6RiTDvsYY+OOfn
   c=;
IronPort-SDR: AmyPaLlxo7u5PlAvuO6cqTIGv0pTIpswYzAL9q8pevkdx8sqNRCLYHl7kpYgVvWSoq67ERqlXX
 x9uM9CekYYkw==
X-IronPort-AV: E=Sophos;i="5.70,535,1574121600"; 
   d="scan'208";a="21904033"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Mar 2020 07:41:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 6C183A22CE;
        Tue, 10 Mar 2020 07:41:29 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Mar 2020 07:41:28 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.162.115) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 07:41:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v4 net-next 2/5] tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Tue, 10 Mar 2020 16:41:22 +0900
Message-ID: <20200310074122.68021-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <ebaf23ff-6b6e-8e5b-6de5-5388284d611d@gmail.com>
References: <ebaf23ff-6b6e-8e5b-6de5-5388284d611d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.115]
X-ClientProxiedBy: EX13D39UWB004.ant.amazon.com (10.43.161.148) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon, 9 Mar 2020 21:04:24 -0700
> On 3/8/20 11:16 AM, Kuniyuki Iwashima wrote:
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
> >   3. bind two sockets to (localhost, 0) and the latter fails.
> > 
> > Therefore, when ephemeral ports are exhausted, bind(0) should fallback to
> > the legacy behaviour to enable the SO_REUSEADDR option and make it possible
> > to connect to different remote (addr, port) tuples.
> 
> Sadly this commit tries hard to support obsolete SO_REUSEADDR for active connections,
> which makes little sense now we have more powerful IP_BIND_ADDRESS_NO_PORT
> 
> SO_REUSEADDR only really makes sense for a listener, because you want a
> server to be able to restart after core dump, while prior sockets are still
> kept in TIME_WAIT state.
> 
> Same for SO_REUSEPORT : it only made sense for sharded listeners in linux kernel.
> 
> Trying to allocate a sport at bind() time, without knowing the destination address/port
> is really not something that can be fixed.
> 
> Your patches might allow a 2x increase, while IP_BIND_ADDRESS_NO_PORT
> basically allows for 1000x increase of the possible combinations.
> 
> 
> 
> > 
> > This patch allows us to bind SO_REUSEADDR enabled sockets to the same
> > (addr, port) only when all ephemeral ports are exhausted.
> > 
> > The only notable thing is that if all sockets bound to the same port have
> > both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
> > ephemeral port and also do listen().
> > 
> > Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
> 
> I disagree with this Fixes: tag  : I do not want this patch in stable kernels,
> particularly if you put the sysctl patch as a followup without a Fixes: tag.
> 
> Please reorder your patch to first introduce the sysctl, then this one.
> 
> Or squash the two patches.

I'm sorry, I will remove the tag and squash the patches.
