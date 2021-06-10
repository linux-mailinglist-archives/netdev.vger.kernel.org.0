Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF933A376E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhFJWzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:55:05 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:6626 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFJWzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:55:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623365587; x=1654901587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MavhUkwec3KxpmIuIqa2ujWlt3bbQK3gmsqMev55N9g=;
  b=Uraga2nFfVs8uJU4qboinaI1G46RyK2lL+0NpxF4phJCQaBBLNY8PF8L
   KyYQ1zxQNOIUBhUdkqhDbZ8tvmamqmpTz8cxUkVGDAidAmUgPFgH5/BBr
   M/0IrNI2+S/wKkoboiujkdd3Kzby4DfsSXf7o6MmAAnBURHJhEhgZpGzH
   g=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="115114206"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 10 Jun 2021 22:53:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id F15AFA25D0;
        Thu, 10 Jun 2021 22:53:03 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:53:03 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:52:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 06/11] tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
Date:   Fri, 11 Jun 2021 07:52:55 +0900
Message-ID: <20210610225255.410-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3e02db84-1cda-8b5a-49ea-cdbad900e3ea@gmail.com>
References: <3e02db84-1cda-8b5a-49ea-cdbad900e3ea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D24UWA002.ant.amazon.com (10.43.160.200) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu, 10 Jun 2021 22:21:00 +0200
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > As with the preceding patch, this patch changes reqsk_timer_handler() to
> > call reuseport_migrate_sock() and inet_reqsk_clone() to migrate in-flight
> > requests at retransmitting SYN+ACKs. If we can select a new listener and
> > clone the request, we resume setting the SYN+ACK timer for the new req. If
> > we can set the timer, we call inet_ehash_insert() to unhash the old req and
> > put the new req into ehash.
> > 
> 
> ...
> 
> >  static void reqsk_migrate_reset(struct request_sock *req)
> >  {
> > +	req->saved_syn = NULL;
> > +	inet_rsk(req)->ireq_opt = NULL;
> >  #if IS_ENABLED(CONFIG_IPV6)
> > -	inet_rsk(req)->ipv6_opt = NULL;
> > +	inet_rsk(req)->pktopts = NULL;
> >  #endif
> >  }
> 
> This is fragile. 
> 
> Maybe instead :
> 
> #if IS_ENABLED(CONFIG_IPV6)
> 	inet_rsk(req)->ipv6_opt = NULL;
> 	inet_rsk(req)->pktopts = NULL;
> #else
> 	inet_rsk(req)->ireq_opt = NULL;
> #endif

I will fix this, thank you.

Also I will send a follow-up patch later to fix the same style in
inet_reqsk_alloc().
