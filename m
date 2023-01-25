Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00A967A8C1
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjAYC3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYC3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:29:13 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBAD45F49;
        Tue, 24 Jan 2023 18:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674613752; x=1706149752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5yENitLhmnB5lcFwq2NGFvsRR9PFM2iW0iudgDkY0c0=;
  b=XjZz2YlVE2fCSJWZyjgXJ6h68of+n7HFh/EutWhFG7aTq95DU1t34Zg4
   aD9WNjSFImuWvIRe24RSsfMqehxv0Z4MtP1SL1fEajp6JAQm6wlPFkda5
   vAHXTqs5y6rEu1JAh2fCOsm0ZZoCsaU/oe4/f+XhkgFGHrvy/srDdIumk
   E=;
X-IronPort-AV: E=Sophos;i="5.97,244,1669075200"; 
   d="scan'208";a="1095923950"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:29:07 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id EC1D541E3B;
        Wed, 25 Jan 2023 02:29:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 25 Jan 2023 02:29:06 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Wed, 25 Jan 2023 02:29:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <v4bel@theori.io>
CC:     <kuniyu@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <imv4bel@gmail.com>, <kuba@kernel.org>,
        <linux-hams@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <ralf@linux-mips.org>
Subject: Re: [PATCH v2] net/rose: Fix to not accept on connected socket
Date:   Tue, 24 Jan 2023 18:28:54 -0800
Message-ID: <20230125022854.69146-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230125020809.67989-1-kuniyu@amazon.com>
References: <20230125020809.67989-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D38UWC002.ant.amazon.com (10.43.162.46) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Tue, 24 Jan 2023 18:08:09 -0800
> From:   Hyunwoo Kim <v4bel@theori.io>
> Date:   Mon, 23 Jan 2023 11:40:20 -0800
> > If listen() and accept() are called on a rose socket
> > that connect() is successful, accept() succeeds immediately.
> > This is because rose_connect() queues the skb to
> > sk->sk_receive_queue, and rose_accept() dequeues it.

Same comment for the netrom patch here.
https://lore.kernel.org/netdev/20230125014347.65971-1-kuniyu@amazon.com/

The skb which the problematic accept() dequeues is created by
sendmsg(), not connect(), right ?


> > 
> > This creates a child socket with the sk of the parent
> > rose socket, which can cause confusion.
> > 
> > Fix rose_listen() to return -EINVAL if the socket has
> > already been successfully connected, and add lock_sock
> > to prevent this issue.
> > 
> > Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> 
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> 
> > ---
> >  net/rose/af_rose.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> > index 36fefc3957d7..ca2b17f32670 100644
> > --- a/net/rose/af_rose.c
> > +++ b/net/rose/af_rose.c
> > @@ -488,6 +488,12 @@ static int rose_listen(struct socket *sock, int backlog)
> >  {
> >  	struct sock *sk = sock->sk;
> >  
> > +	lock_sock(sk);
> > +	if (sock->state != SS_UNCONNECTED) {
> > +		release_sock(sk);
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (sk->sk_state != TCP_LISTEN) {
> >  		struct rose_sock *rose = rose_sk(sk);
> >  
> > @@ -497,8 +503,10 @@ static int rose_listen(struct socket *sock, int backlog)
> >  		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
> >  		sk->sk_max_ack_backlog = backlog;
> >  		sk->sk_state           = TCP_LISTEN;
> > +		release_sock(sk);
> >  		return 0;
> >  	}
> > +	release_sock(sk);
> >  
> >  	return -EOPNOTSUPP;
> >  }
> > -- 
> > 2.25.1
