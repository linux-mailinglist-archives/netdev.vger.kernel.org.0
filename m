Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0842E6E5733
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 03:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjDRB4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 21:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjDRB4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 21:56:06 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899307A80
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681782931; x=1713318931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hdc/qezI5+IziF3AUJiyKWjOezq2KJKLrEGqovIvy6Q=;
  b=UGgZIfDHJKvM5JcO0ioDsiIf0DlC8LZcGqY93MykbCLlj5KM9dtCwcwN
   AiHT8IlYrnUTH2qMIql12S32MsvJZ0LQLhO/9ikVrWz1DFMU53VKGyTdm
   J9ki73/IQuCqep3v8hXUvAUo47ug1ZbY0HrK1O75fkprdDqkRd1lLVPMd
   c=;
X-IronPort-AV: E=Sophos;i="5.99,205,1677542400"; 
   d="scan'208";a="205334551"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 01:54:57 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 0003440DEC;
        Tue, 18 Apr 2023 01:54:55 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 01:54:53 +0000
Received: from 88665a182662.ant.amazon.com (10.94.51.151) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 01:54:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <willemdebruijn.kernel@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <willemb@google.com>
Subject: RE: [PATCH v1 net] udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Mon, 17 Apr 2023 18:54:42 -0700
Message-ID: <20230418015442.89242-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <643df48f6ce39_30336a294a7@willemb.c.googlers.com.notmuch>
References: <643df48f6ce39_30336a294a7@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.51.151]
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Apr 2023 21:38:23 -0400
> Kuniyuki Iwashima wrote:
[...]
> > > > So, we need to make sure TX tstamp is not queued if SOCK_DEAD is
> > > > flagged and we purge the queue only after marking SOCK_DEAD ?
> > > 
> > > Exactly. Thanks for the sketch.
> > > 
> > > Ideally without having to take an extra lock in the common path.
> > > sk_commmon_release calls sk_prot->destroy == udp_destroy_sock,
> > > which already sets SOCK_DEAD.
> > > 
> > > Could we move the skb_queue_purge in there? That is also what
> > > calls udp_flush_pending_frames.
> > 
> > Yes, that makes sense.
> > 
> > I was thinking if we need a memory barrier for SOCK_DEAD to sync
> > with TX, which reads it locklessly.  Maybe we should check SOCK_DEAD
> > with sk->sk_error_queue.lock held ?
> 
> the flag write needs the lock (which is held). The test_bit in
> sock_flag is atomic.

I was concerning this race:

					if (!sock_flag(sk, SOCK_DEAD)) {
	sock_flag(sk, SOCK_DEAD)
	skb_queue_purge()
						skb_queue_tail()
					}

and thought we can avoid it by checking SOCK_DEAD under sk_error_queue.lock.

					spin_lock_irqsave(sk_error_queue.lock
					if (!sock_flag(SOCK_DEAD)) {
	sock_flag(SOCK_DEAD)			__skb_queue_tail()
					}
					spin_unlock_irqrestore()
	skb_queue_purge()

What do you think ?

>  
> > And I forgot to return error from sock_queue_err_skb() to free skb
> > in __skb_complete_tx_timestamp().
> >
> > ---8<---
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 4c0879798eb8..287b834df9c8 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
> >   */
> >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> >  {
> > +	unsigned long flags;
> > +
> >  	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
> >  	    (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> >  		return -ENOMEM;
> > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> >  	/* before exiting rcu section, make sure dst is refcounted */
> >  	skb_dst_force(skb);
> >  
> > -	skb_queue_tail(&sk->sk_error_queue, skb);
> > -	if (!sock_flag(sk, SOCK_DEAD))
> > -		sk_error_report(sk);
> > +	spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > +	if (sock_flag(sk, SOCK_DEAD)) {
> > +		spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
> > +		return -EINVAL;
> > +	}
> > +	__skb_queue_tail(&sk->sk_error_queue, skb);
> > +	spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
> > +
> > +	sk_error_report(sk);
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(sock_queue_err_skb);
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index c605d171eb2d..7060a5cda711 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -2674,6 +2674,11 @@ void udp_destroy_sock(struct sock *sk)
> >  		if (up->encap_enabled)
> >  			static_branch_dec(&udp_encap_needed_key);
> >  	}
> > +
> > +	/* A zerocopy skb has a refcnt of sk and may be
> > +	 * put into sk_error_queue with TX timestamp
> > +	 */
> > +	skb_queue_purge(&sk->sk_error_queue);
> >  }
> >  
> >  /*
> > ---8<---
