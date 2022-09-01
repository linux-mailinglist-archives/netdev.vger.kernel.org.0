Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7029A5AA179
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiIAVZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiIAVZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:25:50 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AAF647F2
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 14:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662067548; x=1693603548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ORZfamlXf3I4Eo/nSy8t+f5FS+7tcOlTysTmXbR8UY=;
  b=kbQSlhjTxGx1gRrbmqSnOMeyyWISRRmVEWr+0ujs9BAWTKfOii5PuLpV
   dwwhSN87IWR3pTtaijCQhxpWXHhuNGDgXygXhIN++xLOs9VFMcgoOfZni
   t6YDkwbgDloU9MJy4SVLg/mj3Y13acJfXQvN2BzOVq6ndCL3/gktQVeBa
   0=;
X-IronPort-AV: E=Sophos;i="5.93,281,1654560000"; 
   d="scan'208";a="240136423"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 21:25:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com (Postfix) with ESMTPS id 038398D083;
        Thu,  1 Sep 2022 21:25:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 1 Sep 2022 21:25:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 1 Sep 2022 21:25:28 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>, <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Thu, 1 Sep 2022 14:25:20 -0700
Message-ID: <20220901212520.11421-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <f154fcd1d7e9c856c46dbf00ef4998773574a5cc.camel@redhat.com>
References: <f154fcd1d7e9c856c46dbf00ef4998773574a5cc.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Thu, 01 Sep 2022 12:57:33 +0200
> On Tue, 2022-08-30 at 12:15 -0700, Kuniyuki Iwashima wrote:
> > We will soon introduce an optional per-netns ehash.
> > 
> > This means we cannot use tcp_hashinfo directly in most places.
> > 
> > Instead, access it via net->ipv4.tcp_death_row->hashinfo.
> > 
> > The access will be valid only while initialising tcp_hashinfo
> > itself and creating/destroying each netns.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  .../chelsio/inline_crypto/chtls/chtls_cm.c    |  5 +-
> >  net/core/filter.c                             |  5 +-
> >  net/ipv4/esp4.c                               |  3 +-
> >  net/ipv4/inet_hashtables.c                    |  2 +-
> >  net/ipv4/netfilter/nf_socket_ipv4.c           |  2 +-
> >  net/ipv4/netfilter/nf_tproxy_ipv4.c           | 17 +++--
> >  net/ipv4/tcp_diag.c                           | 18 +++++-
> >  net/ipv4/tcp_ipv4.c                           | 63 +++++++++++--------
> >  net/ipv4/tcp_minisocks.c                      |  2 +-
> >  net/ipv6/esp6.c                               |  3 +-
> >  net/ipv6/inet6_hashtables.c                   |  4 +-
> >  net/ipv6/netfilter/nf_socket_ipv6.c           |  2 +-
> >  net/ipv6/netfilter/nf_tproxy_ipv6.c           |  5 +-
> >  net/ipv6/tcp_ipv6.c                           | 16 ++---
> >  net/mptcp/mptcp_diag.c                        |  7 ++-
> >  15 files changed, 92 insertions(+), 62 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> > index ddfe9208529a..f90bfba4b303 100644
> > --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> > +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> > @@ -1069,8 +1069,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
> >  	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
> >  }
> >  
> > -static void inet_inherit_port(struct inet_hashinfo *hash_info,
> > -			      struct sock *lsk, struct sock *newsk)
> > +static void inet_inherit_port(struct sock *lsk, struct sock *newsk)
> >  {
> >  	local_bh_disable();
> >  	__inet_inherit_port(lsk, newsk);
> > @@ -1240,7 +1239,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
> >  						     ipv4.sysctl_tcp_window_scaling),
> >  					   tp->window_clamp);
> >  	neigh_release(n);
> > -	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
> > +	inet_inherit_port(lsk, newsk);
> >  	csk_set_flag(csk, CSK_CONN_INLINE);
> >  	bh_unlock_sock(newsk); /* tcp_create_openreq_child ->sk_clone_lock */
> 
> I looks to me that the above chunks are functionally a no-op and I
> think that omitting the 2 drivers from the v2:
> 
> https://lore.kernel.org/netdev/20220829161920.99409-4-kuniyu@amazon.com/
> 
> should break mlx5/nfp inside a netns. I don't understand why including
> the above and skipping the latters?!? I guess is a question mostly for
> Eric :)

My best guess is that it's ok unless it does not touch TCP stack deeply
and if it does, the driver developer must catch up with the core changes
not to burden maintainers...?

If so, I understand that take.  OTOH, I also don't want to break anything
when we know the change would do.

So, I'm fine to either stay as is or add the change in v4 again.


> 
> > @@ -1728,6 +1728,7 @@ EXPORT_SYMBOL(tcp_v4_do_rcv);
> >  
> >  int tcp_v4_early_demux(struct sk_buff *skb)
> >  {
> > +	struct net *net = dev_net(skb->dev);
> >  	const struct iphdr *iph;
> >  	const struct tcphdr *th;
> >  	struct sock *sk;
> > @@ -1744,7 +1745,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
> >  	if (th->doff < sizeof(struct tcphdr) / 4)
> >  		return 0;
> >  
> > -	sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
> > +	sk = __inet_lookup_established(net, net->ipv4.tcp_death_row->hashinfo,
> >  				       iph->saddr, th->source,
> >  				       iph->daddr, ntohs(th->dest),
> >  				       skb->skb_iif, inet_sdif(skb));
> 
> /Me is thinking aloud...
> 
> I'm wondering if the above has some measurable negative effect for
> large deployments using only the main netns?
> 
> Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> >hashinfo already into the working set data for established socket?
> Would the above increase the WSS by 2 cache-lines?

Currently, the death_row and hashinfo are touched around tw sockets or
connect().  If connections on the deployment are short-lived or frequently
initiated by itself, that would be host and included in WSS.

If the workload is server and there's no active-close() socket or
connections are long-lived, then it might not be included in WSS.
But I think it's not likely than the former if the deployment is
large enough.

If this change had large impact, then we could revert fbb8295248e1
which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
that tried to fire a TW timer after netns is freed, but 0dad4087a86a
has already reverted.


> 
> Thanks!
> 
> Paolo
