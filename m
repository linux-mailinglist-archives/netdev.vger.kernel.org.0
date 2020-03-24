Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55928190C0B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgCXLK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 07:10:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:25641 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgCXLK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 07:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1585048227; x=1616584227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GcH/VHUqB97+J7CroQpL4VCqS0bZZn2XqSMnIHWIkzY=;
  b=TA/QPUPXRvkiq9lOQTNBXDiDDIR7xks6CAfhh3lfNth75ofz8u8aBRR2
   0GIvQj0SPVPFwolJVLeL+1+RRjnKpL5vvTUcHyNayB2v4PFjS4FN5MCGJ
   +3wz4IIUnPnFg9rEly8Zxci/Jpd3iOPAZM+TYT8QBDO2RaHY0FMZkzswF
   4=;
IronPort-SDR: m1mYzDI3aTZAwDiNKu+SDFT+2akl34D6aHKuuCyhrhr6f6HU9TTnV1c3VXUJ5tOc1bCUkmfjrO
 Dje2cheVi33g==
X-IronPort-AV: E=Sophos;i="5.72,300,1580774400"; 
   d="scan'208";a="34504255"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 24 Mar 2020 11:10:25 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 1A7BFA2E7D;
        Tue, 24 Mar 2020 11:10:22 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 24 Mar 2020 11:10:22 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.51) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 24 Mar 2020 11:10:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dccp@vger.kernel.org>,
        <gerrit@erg.abdn.ac.uk>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 1/2] tcp/dccp: Move initialisation of refcounted
Date:   Tue, 24 Mar 2020 20:10:13 +0900
Message-ID: <20200324111013.14268-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iJzxqF8j6uUO9BqmMY0tVh+intVj-v-tygXc_8r6-wjkg@mail.gmail.com>
References: <CANn89iJzxqF8j6uUO9BqmMY0tVh+intVj-v-tygXc_8r6-wjkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.51]
X-ClientProxiedBy: EX13D12UWA003.ant.amazon.com (10.43.160.50) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Mar 2020 11:45:48 -0700
> On Mon, Mar 23, 2020 at 11:18 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > The refcounted is initialised at most three times.
> >
> >   - __inet_lookup_skb() sets it true.
> >   - skb_steal_sock() is false and __inet_lookup() sets it true.
> >   - __inet_lookup_established() is false and __inet_lookup() sets it false.
> >
> > We do not need to initialise refcounted again and again, so we should do
> > it just before return.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> 
> Well, I do not believe this patch (and the following one) makes things
> more readable.
> 
> I doubt setting a boolean in a register or a stack variable has any cost,
> I prefer letting the compiler optimize this.
> 
> The ehash lookup cost is at least 2 or 3 cache lines, this is the
> major contribution.

I confirmed that GCC (v7.3.1) does not make any change with this patch,
but the original code is bit confusing. I think this patch makes the code
bit more readable so that someone (like me...) will not doubt about
complier optimization and write patches.

I will respin only this patch because the changelog can be incorrect by
complier optimization.

Thanks.
