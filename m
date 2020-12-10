Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3DA2D541E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 07:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgLJGop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 01:44:45 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:2998 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgLJGop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 01:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607582684; x=1639118684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=RewH6PKPJrv9ycvCUuWlbLXAaaNCiru+bhipcf9bnKU=;
  b=cOMQpekKqnYA13ODct35hxslwWmtItTBKl5EfoyuJfkoKlmT8qUXli8+
   /cmO2vROxdBXHvSBGkxL45Jk+L8/zRQbHKtDZLoM2Kx8tT6uUFBLF1kWc
   NPIXoPfczxddwbSpd05EctZZTDAFWIyl0vMB7O+OHt8Ib6XRXnegZoIu4
   E=;
X-IronPort-AV: E=Sophos;i="5.78,407,1599523200"; 
   d="scan'208";a="901952508"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 10 Dec 2020 06:43:57 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 75B33A1EAB;
        Thu, 10 Dec 2020 06:43:55 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.211) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 06:43:50 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     SeongJae Park <sjpark@amazon.com>, <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>, <kuznet@ms2.inr.ac.ru>,
        <paulmck@kernel.org>, <netdev@vger.kernel.org>,
        <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Thu, 10 Dec 2020 07:43:29 +0100
Message-ID: <20201210064329.6884-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201209151659.125b43da@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13D46UWB002.ant.amazon.com (10.43.161.70) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 15:16:59 -0800 Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 8 Dec 2020 10:45:29 +0100 SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > In 'fqdir_exit()', a work for destruction of the 'fqdir' is enqueued.
> > The work function, 'fqdir_work_fn()', calls 'rcu_barrier()'.  In case of
> > intensive 'fqdir_exit()' (e.g., frequent 'unshare(CLONE_NEWNET)'
> > systemcalls), this increased contention could result in unacceptably
> > high latency of 'rcu_barrier()'.  This commit avoids such contention by
> > doing the destruction in batched manner, as similar to that of
> > 'cleanup_net()'.
> > 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> 
> Looks fine to me, but you haven't CCed Florian or Eric who where the
> last two people to touch this function. Please repost CCing them and
> fixing the nit below, thanks!

Thank you for let me know that.  I will send the next version so.

> 
> >  static void fqdir_work_fn(struct work_struct *work)
> >  {
> > -	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> > -	struct inet_frags *f = fqdir->f;
> > +	struct llist_node *kill_list;
> > +	struct fqdir *fqdir;
> > +	struct inet_frags *f;
> 
> nit: reorder fqdir and f to keep reverse xmas tree variable ordering.

Hehe, ok, I will. :)


Thanks,
SeongJae Park
