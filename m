Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BCA2D6ACE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 23:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbgLJWbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:31:15 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7303 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405096AbgLJWVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 17:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607638895; x=1639174895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=sbiloZXFJsIOUJpbzBgsGP4SnD+6CfWaCB8V0p7nQMw=;
  b=hjVAK7Q0pXJJJ89viIUGGFY6SPW5F69q7ZjBXM8ideFz7/T5OPRljIEU
   KzuD46Tzrj05VJKzYzEKxu325eWpdxrbB6c9LbxrulRVjMiukSvWyvwsP
   P/31i1YpB7XjNcmac5/cJIcXOwOcK82pPlZJylHCShdfEDEg/NwBw0wQw
   I=;
X-IronPort-AV: E=Sophos;i="5.78,409,1599523200"; 
   d="scan'208";a="103328887"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Dec 2020 22:16:27 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 09722221EED;
        Thu, 10 Dec 2020 22:16:26 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.214) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 22:16:20 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, <rcu@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] net: Reduce rcu_barrier() contentions from 'unshare(CLONE_NEWNET)'
Date:   Thu, 10 Dec 2020 23:16:05 +0100
Message-ID: <20201210221605.4236-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89i+egqwjJqGE6mZFB+-GuT_1dOQJP=pccREEZvEwQ1SGiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D11UWC004.ant.amazon.com (10.43.162.101) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 15:09:10 +0100 Eric Dumazet <edumazet@google.com> wrote:

> On Thu, Dec 10, 2020 at 9:09 AM SeongJae Park <sjpark@amazon.com> wrote:
> >
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
> > make the number of active slab objects including 'sock_inode_cache' type
> > rapidly and continuously increase.  As a result, memory pressure occurs.
> >
> > In more detail, I made an artificial reproducer that resembles the
> > workload that we found the problem and reproduce the problem faster.  It
> > merely repeats 'unshare(CLONE_NEWNET)' 50,000 times in a loop.  It takes
> > about 2 minutes.  On 40 CPU cores, 70GB DRAM machine, it reduced about
> > 15GB of available memory in total.  Note that the issue don't reproduce
> > on every machine.  On my 6 CPU cores machine, the problem didn't
> > reproduce.
> 
> OK, that is the number before the patch, but what is the number after
> the patch ?

No continuous memory reduction but some fluctuation observed.  Nevertheless,
the available memory reduction was only up to about 400MB.

> 
> I think the idea is very nice, but this will serialize fqdir hash
> tables destruction on one single cpu,
> this might become a real issue _if_ these hash tables are populated.
> 
> (Obviously in your for (i=1;i<50000;i++) unshare(CLONE_NEWNET);  all
> these tables are empty...)
> 
> As you may now, frags are often used as vectors for DDOS attacks.
> 
> I would suggest maybe to not (ab)use system_wq, but a dedicated work queue
> with a limit (@max_active argument set to 1 in alloc_workqueue()) , to
> make sure that the number of
> threads is optimal/bounded.
> 
> Only the phase after hash table removal could benefit from your
> deferral to a single context,
> so that a single rcu_barrier() is active, since the part after
> rcu_barrier() is damn cheap and _can_ be serialized
> 
>   if (refcount_dec_and_test(&f->refcnt))
>                 complete(&f->completion);

Good point, thanks for this kind suggestion.  I will do so in next version.


Thanks,
SeongJae Park
