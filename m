Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5D15ED43C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 07:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiI1F3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 01:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiI1F3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 01:29:36 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B430CC54;
        Tue, 27 Sep 2022 22:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664342973; x=1695878973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JdaoXNIvuf6u6y5SzbjeaX/ruxbi1wY9fP48C2xll2Q=;
  b=ZlYvLbEjZKjejJdiWrkCRMH2TJLtyyFoNaJ1OR0r1txetPtWtxIl9Wrz
   7sTKRqNAIaXIBJJVhBQhGs+s3Th62psdaWb5L82/kMIeEGYAVU5ds7KQm
   SbMHpPGgZft1XujjkEtBZSgVkpBFJ5FgrNm1iFkm/fdZR8TsN1PCi5I0+
   I=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 05:29:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id 5808781427;
        Wed, 28 Sep 2022 05:29:19 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 05:29:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 28 Sep 2022 05:29:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v2 net 2/5] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
Date:   Tue, 27 Sep 2022 22:29:05 -0700
Message-ID: <20220928052905.82271-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK1HHhvJgDsym377DDxZ3hvL8b8_pbrjb-qeXFRbsvFKA@mail.gmail.com>
References: <CANn89iK1HHhvJgDsym377DDxZ3hvL8b8_pbrjb-qeXFRbsvFKA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D01UWB004.ant.amazon.com (10.43.161.157) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 22:05:09 -0700
> On Tue, Sep 27, 2022 at 5:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Commit 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support") forgot
> > to add a change to free inet6_sk(sk)->rxpmtu while converting an IPv6
> > socket into IPv4 with IPV6_ADDRFORM.  After conversion, sk_prot is
> > changed to udp_prot and ->destroy() never cleans it up, resulting in
> > a memory leak.
> >
> > This is due to the discrepancy between inet6_destroy_sock() and
> > IPV6_ADDRFORM, so let's call inet6_destroy_sock() from IPV6_ADDRFORM
> > to remove the difference.
> >
> > However, this is not enough for now because rxpmtu can be changed
> > without lock_sock() after commit 03485f2adcde ("udpv6: Add lockless
> > sendmsg() support").  We will fix this case in the following patch.
> >
> > Fixes: 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/ipv6/ipv6_sockglue.c | 15 +++------------
> >  1 file changed, 3 insertions(+), 12 deletions(-)
> >
> > diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> > index b61066ac8648..030a4cf23ceb 100644
> > --- a/net/ipv6/ipv6_sockglue.c
> > +++ b/net/ipv6/ipv6_sockglue.c
> > @@ -431,9 +431,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
> >                 if (optlen < sizeof(int))
> >                         goto e_inval;
> >                 if (val == PF_INET) {
> > -                       struct ipv6_txoptions *opt;
> > -                       struct sk_buff *pktopt;
> > -
> >                         if (sk->sk_type == SOCK_RAW)
> >                                 break;
> >
> > @@ -464,7 +461,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
> >                                 break;
> >                         }
> >
> > -                       fl6_free_socklist(sk);
> >                         __ipv6_sock_mc_close(sk);
> >                         __ipv6_sock_ac_close(sk);
> >
> > @@ -501,14 +497,9 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
> >                                 sk->sk_socket->ops = &inet_dgram_ops;
> >                                 sk->sk_family = PF_INET;
> >                         }
> > -                       opt = xchg((__force struct ipv6_txoptions **)&np->opt,
> > -                                  NULL);
> > -                       if (opt) {
> > -                               atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
> > -                               txopt_put(opt);
> > -                       }
> > -                       pktopt = xchg(&np->pktoptions, NULL);
> > -                       kfree_skb(pktopt);
> > +
> 
>  Why is this needed ? I think a comment could help.
> > +                       np->rxopt.all = 0;

I added it to reduce the possibility of lockless allocation in
ipv6_local_rxpmtu(), which checks np->rxopt.bits.rxpmtu first.

But, lockless sendmsg() even races with this, so it might not be
needed or should be added in the next patch?


> 
> > +                       inet6_destroy_sock(sk);
> 
> This name is unfortunate. This really is an inet6_cleanup_sock() in
> this context.

Ok, I'll add inet6_cleanup_sock() as a wrapper of inet6_destroy_sock()
in v3.

And, I'll post a cleanup patch later which renames inet6_destroy_sock()
to inet6_cleanup_sock() and removes all unnecessary inet6_destroy_sock()
calls in each sk->sk_prot->destroy().


> 
> >
> >                         /*
> >                          * ... and add it to the refcnt debug socks count
> > --
> > 2.30.2
