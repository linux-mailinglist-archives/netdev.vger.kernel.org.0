Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3802D549B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 08:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgLJH2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 02:28:18 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:52988 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgLJH2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 02:28:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607585296; x=1639121296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=+ZgNEknmUpfCWrXl5dEdMSWKoi9I8sDyFxoRQJHgM0k=;
  b=mmbMJazMT6B24v+M9OhYzfal/T9RpSBS8NyUDIEP2uBVuwcUW5gT75aI
   VuqanPZyKEFcGZqmAWhCxHSoDOXf4CSS2yRUsreECE+rf7if+l8mjii5E
   nds10u4sdDg5hcRbPPBYwGNEkxAJZAXGpMp4tz1jmc3+qkGHM5vj2QDRF
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,407,1599523200"; 
   d="scan'208";a="70252257"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Dec 2020 07:27:28 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 6C765A19EB;
        Thu, 10 Dec 2020 07:27:27 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.53) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 07:27:22 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     SeongJae Park <sjpark@amazon.com>, <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <paulmck@kernel.org>,
        <netdev@vger.kernel.org>, <rcu@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Thu, 10 Dec 2020 08:27:07 +0100
Message-ID: <20201210072707.16079-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <6d3e32f6-c2df-a1a6-3568-b7387cd0c933@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D48UWA002.ant.amazon.com (10.43.163.16) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 01:17:58 +0100 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> 
> 
> On 12/8/20 10:45 AM, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > In 'fqdir_exit()', a work for destruction of the 'fqdir' is enqueued.
> > The work function, 'fqdir_work_fn()', calls 'rcu_barrier()'.  In case of
> > intensive 'fqdir_exit()' (e.g., frequent 'unshare(CLONE_NEWNET)'
> > systemcalls), this increased contention could result in unacceptably
> > high latency of 'rcu_barrier()'.  This commit avoids such contention by
> > doing the destruction in batched manner, as similar to that of
> > 'cleanup_net()'.
> 
> Any numbers to share ? I have never seen an issue.

On our 40 CPU cores / 70GB DRAM machine, 15GB of available memory was reduced
within 2 minutes while my artificial reproducer runs.  The reproducer merely
repeats 'unshare(CLONE_NEWNET)' in a loop for 50,000 times.  The reproducer is
not only artificial but resembles the behavior of our real workloads.
While the reproducer runs, 'cleanup_net()' was called only 4 times.  First two
calls quickly finished, but third call took about 30 seconds, and the fourth
call didn't finished until the reproducer finishes.  We also confirmed the
third and fourth calls just waiting for 'rcu_barrier()'.

I think you've not seen this issue before because we are doing very intensive
'unshare()' calls.  Also, this is not reproducible on every hardware.  On my 6
CPU machine, the problem didn't reproduce.

> 
> > 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  include/net/inet_frag.h  |  2 +-
> >  net/ipv4/inet_fragment.c | 28 ++++++++++++++++++++--------
> >  2 files changed, 21 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> > index bac79e817776..558893d8810c 100644
> > --- a/include/net/inet_frag.h
> > +++ b/include/net/inet_frag.h
> > @@ -20,7 +20,7 @@ struct fqdir {
> >  
> >  	/* Keep atomic mem on separate cachelines in structs that include it */
> >  	atomic_long_t		mem ____cacheline_aligned_in_smp;
> > -	struct work_struct	destroy_work;
> > +	struct llist_node	destroy_list;
> >  };
> >  
> >  /**
> > diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> > index 10d31733297d..796b559137c5 100644
> > --- a/net/ipv4/inet_fragment.c
> > +++ b/net/ipv4/inet_fragment.c
> > @@ -145,12 +145,19 @@ static void inet_frags_free_cb(void *ptr, void *arg)
> >  		inet_frag_destroy(fq);
> >  }
> >  
> > +static LLIST_HEAD(destroy_list);
> > +
> >  static void fqdir_work_fn(struct work_struct *work)
> >  {
> > -	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> > -	struct inet_frags *f = fqdir->f;
> > +	struct llist_node *kill_list;
> > +	struct fqdir *fqdir;
> > +	struct inet_frags *f;
> > +
> > +	/* Atomically snapshot the list of fqdirs to destroy */
> > +	kill_list = llist_del_all(&destroy_list);
> >  
> > -	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> > +	llist_for_each_entry(fqdir, kill_list, destroy_list)
> > +		rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> > 
> 
> 
> OK, it seems rhashtable_free_and_destroy() has cond_resched() so we are not going
> to hold this cpu for long periods.
>  
> >  	/* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
> >  	 * have completed, since they need to dereference fqdir.
> > @@ -158,10 +165,13 @@ static void fqdir_work_fn(struct work_struct *work)
> >  	 */
> >  	rcu_barrier();
> >  
> > -	if (refcount_dec_and_test(&f->refcnt))
> > -		complete(&f->completion);
> > +	llist_for_each_entry(fqdir, kill_list, destroy_list) {
> 
> Don't we need the llist_for_each_entry_safe() variant here ???

Oh, indeed.  I will do so in the next version.

> 
> > +		f = fqdir->f;
> > +		if (refcount_dec_and_test(&f->refcnt))
> > +			complete(&f->completion);
> >  
> > -	kfree(fqdir);
> > +		kfree(fqdir);
> > +	}


Thanks,
SeongJae Park
