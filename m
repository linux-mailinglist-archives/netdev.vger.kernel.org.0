Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707B95FE22E
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiJMS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiJMSze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:55:34 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6735222B7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665687259; x=1697223259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obrfB0MkCJmV1cYZuR1eR54M38sB3XIk3cmdTqW6Okk=;
  b=bIuE1aaYDwcbX6+ippW0afaxfLI9aumBkrtKR7sWuqF57z7YH3UdCxKN
   EYx8EkQrSIBxi6V+/iQWS/nYQAUsOtjX2kzwEOYJC1lM85fjTY6aZLTVX
   dh+STsDgax3pvS7qMNkEe+HksTMSlKF8uKHoj0uC/yl0RxRMi1t1nASpz
   8=;
X-IronPort-AV: E=Sophos;i="5.95,182,1661817600"; 
   d="scan'208";a="251720746"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-d803d33a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 18:46:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-d803d33a.us-west-2.amazon.com (Postfix) with ESMTPS id 00903A2A82;
        Thu, 13 Oct 2022 18:46:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 13 Oct 2022 18:46:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.35) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 13 Oct 2022 18:46:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <martin.lau@linux.dev>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kraig@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <martin.lau@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <willemb@google.com>
Subject: Re: [PATCH v2 net] udp: Update reuse->has_conns under reuseport_lock.
Date:   Thu, 13 Oct 2022 11:46:18 -0700
Message-ID: <20221013184618.77785-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <c4f74864-0a6a-5075-891c-d20d0dc20f2f@linux.dev>
References: <c4f74864-0a6a-5075-891c-d20d0dc20f2f@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.35]
X-ClientProxiedBy: EX13D37UWC003.ant.amazon.com (10.43.162.183) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <martin.lau@linux.dev>
Date:   Thu, 13 Oct 2022 10:41:53 -0700
> On 10/13/22 9:09 AM, Eric Dumazet wrote:
> >>>> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> >>>> index 5daa1fa54249..abb414ed4aa7 100644
> >>>> --- a/net/core/sock_reuseport.c
> >>>> +++ b/net/core/sock_reuseport.c
> >>>> @@ -21,6 +21,21 @@ static DEFINE_IDA(reuseport_ida);
> >>>>   static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> >>>>                                 struct sock_reuseport *reuse, bool bind_inany);
> >>>>
> >>>> +void reuseport_has_conns_set(struct sock *sk)
> >>>> +{
> >>>> +       struct sock_reuseport *reuse;
> >>>> +
> >>>> +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
> >>>> +               return;
> >>>> +
> >>>> +       spin_lock(&reuseport_lock);
> 
> It seems other paths are still using the spin_lock_bh().  It will be useful to 
> have a few words here why _bh() is not needed.

I think I forgot to add _bh(), but I'm now wondering what is the hlist
lock mentioned in reuseport_alloc()...


> >>>> +       reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> >>>> +                                         lockdep_is_held(&reuseport_lock));
> >>>
> >>> Could @reuse be NULL at this point ?
> >>>
> >>> Previous  test was performed without reuseport_lock being held.
> >>
> >> Usually, sk_reuseport_cb is changed under lock_sock().
> >>
> >> The only exception is reuseport_grow() & TCP reqsk migration case.
> >>
> >> 1) shutdown() TCP listener, which is moved into the latter part of
> >>     reuse->socks[] to migrate reqsk.
> >>
> >> 2) New listen() overflows reuse->socks[] and call reuseport_grow().
> >>
> >> 3) reuse->max_socks overflows u16 with the new listener.
> >>
> >> 4) reuseport_grow() pops the old shutdown()ed listener from the array
> >>     and update its sk->sk_reuseport_cb as NULL without lock_sock().
> >>
> >> shutdown()ed sk->sk_reuseport_cb can be changed without lock_sock().
> >>
> >> But, reuseport_has_conns_set() is called only for UDP and under
> >> lock_sock(), so @reuse never be NULL in this case.
> > 
> > Given the complexity of this code and how much time is needed to
> > review all possibilities, please add an additional
> > 
> > if (reuse)
> >     reuse->has_conns = 1;
> 
> +1

Acked.

Thank you.
