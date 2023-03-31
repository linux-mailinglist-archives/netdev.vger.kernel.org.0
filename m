Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B11A6D1852
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjCaHRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjCaHRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:17:48 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E94191CF;
        Fri, 31 Mar 2023 00:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680247067; x=1711783067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JAtFOpsO/vEk5oySdHeBDtWd8PXf2Ha2sgTmMDDRL3E=;
  b=RYkpXlT9eUa3gTXdVCqMNmsIuws6omjxZZo/JO9QE3SzFlmbfEJZR0ay
   EV9SGpyTJFDCUDMf2BJXS6fudN1jyBaTfZHLMSt3lMvXyzXWrwkSz5xfB
   8zGbwT9Im8UtobgRhAwHYaQiXSX5e4tC+OI9OxuhrIvvQEK3wH503C07R
   4=;
X-IronPort-AV: E=Sophos;i="5.98,307,1673913600"; 
   d="scan'208";a="1118188166"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 07:17:40 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id C5C7660FCC;
        Fri, 31 Mar 2023 07:17:37 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Fri, 31 Mar 2023 07:17:36 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.11) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 31 Mar 2023 07:17:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <threeearcat@gmail.com>
Subject: Re: general protection fault in raw_seq_start
Date:   Fri, 31 Mar 2023 00:17:25 -0700
Message-ID: <20230331071725.66950-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK5D75-SNg28ALi4Zr9JEHnreBpfu_pq0_zLe4jDLT5rw@mail.gmail.com>
References: <CANn89iK5D75-SNg28ALi4Zr9JEHnreBpfu_pq0_zLe4jDLT5rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.11]
X-ClientProxiedBy: EX19D039UWA004.ant.amazon.com (10.13.139.68) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 09:04:47 +0200
> On Thu, Mar 30, 2023 at 11:55 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> 
> > Thanks for reporting the issue.
> >
> > It seems we need to use RCU variant in raw_get_first().
> > I'll post a patch.
> >
> > ---
> > diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> > index 3cf68695b40d..fe0d1ad20b35 100644
> > --- a/net/ipv4/raw.c
> > +++ b/net/ipv4/raw.c
> > @@ -957,7 +957,7 @@ static struct sock *raw_get_first(struct seq_file *seq, int bucket)
> >         for (state->bucket = bucket; state->bucket < RAW_HTABLE_SIZE;
> >                         ++state->bucket) {
> >                 hlist = &h->ht[state->bucket];
> > -               sk_nulls_for_each(sk, hnode, hlist) {
> > +               sk_nulls_for_each_rcu(sk, hnode, hlist) {
> >                         if (sock_net(sk) == seq_file_net(seq))
> >                                 return sk;
> >
> 
> No, we do not want this.
> You missed that sk_nulls_for_each_rcu() needs a specific protocol
> (see Documentation/RCU/rculist_nulls.rst for details)

Ah, exactly SOCK_RAW does not have SLAB_TYPESAFE_BY_RCU.
Thank you for pointing this out!

And I found this seems wrong.

c25b7a7a565e ("inet: ping: use hlist_nulls rcu iterator during lookup")

> 
> RCU is needed in the data path, not for this control path.
> 
> My patch went too far in the RCU conversion. I did not think about
> syzbot harassing /proc files :)
> 
> We need raw_seq_start and friends to go back to use the lock.

Ok, then I'll change /proc/net/{raw, icmp} to use spinlock :)
