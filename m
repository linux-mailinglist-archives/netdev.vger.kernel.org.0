Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF77604DFC
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiJSQ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiJSQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:58:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C070107CFB
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666198719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMbRR8N3NBN7JRc14l4V9PVHBT8vqQAtLm8Prh9zzPA=;
        b=Fe3Wu8YBjjrjrvMCQeOecgQlqDCNpSh9NyCQGWBBm6xAjgJHRfe3Enca0jrSoldlIrOfgV
        1ssF3W2K/GYMM2gH2nQWwV6o8lUA4BVebfeIEAf21LL347ZPIjEDonUOHo4/zRP7Pgg1Kf
        N88kMG9zXifsWqoQ01tso0Tbl6Qx3/A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-GuleNNhTObCMWjjAHwPc2Q-1; Wed, 19 Oct 2022 12:58:38 -0400
X-MC-Unique: GuleNNhTObCMWjjAHwPc2Q-1
Received: by mail-qv1-f69.google.com with SMTP id kr13-20020a0562142b8d00b004b1d5953a2cso10981590qvb.3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMbRR8N3NBN7JRc14l4V9PVHBT8vqQAtLm8Prh9zzPA=;
        b=fw3osqfFGQSiLG3eG04MDnQj46oD/1bs185pZe/Bk33LTNO0kvYyZQXy6gTCc9oNma
         80/mbKlSIJx83v/yHTR+k9qFCcVGeWjkzBuOaYgcHyxkQvfjM28U4unCOLQ+zcj9Qtk4
         N9FTdcnIiyq7wY9gGAkOnvGWO07NT1wn5sNsjkDVnAs8ViPquBRu/vknFpXQlpysj6Gs
         bK/nGI6sC7OVHn/7IvlZnWic50/Jd1eSzOmI2icdAOJNhVZTJnQ7dWN1SlS56RGUT0bg
         i8iYhvom4PU2SEsqlDHKbxzf8N23/m4ylcrArjrysBWClfgC8SIGYxokEodZQ/4p/U0Y
         0x9w==
X-Gm-Message-State: ACrzQf0MZvzIioDgLMFf48L/oHNIVFWqpqYd/vgWGuF4hi+FXhJ9JLKc
        pjHnVMVW+NEJqb0TlFVBTofdrpTqVBHOesHDxhrdzB7rtMu2dIpO2rG3DpxNT7XVe8PGxUwutYF
        fjnqJ9+aW6VpgtMz/
X-Received: by 2002:a05:622a:1110:b0:39c:d568:8b26 with SMTP id e16-20020a05622a111000b0039cd5688b26mr7152674qty.280.1666198717820;
        Wed, 19 Oct 2022 09:58:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7R4XPY2GyUXWh4pLiDdzoE84zGdhYpvBc1m/P9tyQ811yZd60DHb1QxzQ3yJTPDUQSfnUTgA==
X-Received: by 2002:a05:622a:1110:b0:39c:d568:8b26 with SMTP id e16-20020a05622a111000b0039cd5688b26mr7152620qty.280.1666198716740;
        Wed, 19 Oct 2022 09:58:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id l12-20020a37f90c000000b006cbc6e1478csm5248009qkj.57.2022.10.19.09.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:58:36 -0700 (PDT)
Message-ID: <48dc93489465e75a0f37c4b02f4711598cb1ed4d.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] udp: track the forward memory release
 threshold in an hot cacheline
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        netdev@vger.kernel.org
Date:   Wed, 19 Oct 2022 18:58:33 +0200
In-Reply-To: <20221019163306.70984-1-kuniyu@amazon.com>
References: <dafe09ca2e14c4ab45f3d9db56b768e06750e382.1666173045.git.pabeni@redhat.com>
         <20221019163306.70984-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-19 at 09:33 -0700, Kuniyuki Iwashima wrote:
> From:   Paolo Abeni <pabeni@redhat.com>
> Date:   Wed, 19 Oct 2022 12:02:01 +0200
> > When the receiver process and the BH runs on different cores,
> > udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
> > as the latter shares the same cacheline with sk_forward_alloc, written
> > by the BH.
> > 
> > With this patch, UDP tracks the rcvbuf value and its update via custom
> > SOL_SOCKET socket options, and copies the forward memory threshold value
> > used by udp_rmem_release() in a different cacheline, already accessed by
> > the above function and uncontended.
> > 
> > Overall the above give a 10% peek throughput increase under UDP flood.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/linux/udp.h |  3 +++
> >  net/ipv4/udp.c      | 22 +++++++++++++++++++---
> >  net/ipv6/udp.c      |  8 ++++++--
> >  3 files changed, 28 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/udp.h b/include/linux/udp.h
> > index e96da4157d04..5cdba00a904a 100644
> > --- a/include/linux/udp.h
> > +++ b/include/linux/udp.h
> > @@ -87,6 +87,9 @@ struct udp_sock {
> >  
> >  	/* This field is dirtied by udp_recvmsg() */
> >  	int		forward_deficit;
> > +
> > +	/* This fields follows rcvbuf value, and is touched by udp_recvmsg */
> > +	int		forward_threshold;
> >  };
> >  
> >  #define UDP_MAX_SEGMENTS	(1 << 6UL)
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 8126f67d18b3..915f573587fa 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1448,7 +1448,7 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
> >  	if (likely(partial)) {
> >  		up->forward_deficit += size;
> >  		size = up->forward_deficit;
> > -		if (size < (sk->sk_rcvbuf >> 2) &&
> > +		if (size < READ_ONCE(up->forward_threshold) &&
> >  		    !skb_queue_empty(&up->reader_queue))
> >  			return;
> >  	} else {
> > @@ -1622,8 +1622,12 @@ static void udp_destruct_sock(struct sock *sk)
> >  
> >  int udp_init_sock(struct sock *sk)
> >  {
> > -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> > +	struct udp_sock *up = udp_sk(sk);
> > +
> > +	skb_queue_head_init(&up->reader_queue);
> > +	up->forward_threshold = sk->sk_rcvbuf >> 2;
> >  	sk->sk_destruct = udp_destruct_sock;
> > +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
> >  	return 0;
> >  }
> >  
> > @@ -2671,6 +2675,18 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
> >  	int err = 0;
> >  	int is_udplite = IS_UDPLITE(sk);
> >  
> > +	if (level == SOL_SOCKET) {
> > +		err = sk_setsockopt(sk, level, optname, optval, optlen);
> > +
> > +		if (optname == SO_RCVBUF || optname == SO_RCVBUFFORCE) {
> > +			sockopt_lock_sock(sk);
> 
> Can we drop this lock by adding READ_ONCE() to sk->sk_rcvbuf below ?

I think we can't. If there are racing thread updating rcvbuf, we could
end-up with mismatching value in forward_threshold. Not a likely
scenario, but still... This is control path, acquiring the lock once
more should not be a problem.

> > +			/* paired with READ_ONCE in udp_rmem_release() */
> > +			WRITE_ONCE(up->forward_threshold, sk->sk_rcvbuf >> 2);
> > +			sockopt_release_sock(sk);
> > +		}
> > +		return err;
> > +	}
> > +
> >  	if (optlen < sizeof(int))
> >  		return -EINVAL;
> >  
> > @@ -2784,7 +2800,7 @@ EXPORT_SYMBOL(udp_lib_setsockopt);
> >  int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> >  		   unsigned int optlen)
> >  {
> > -	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
> > +	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
> >  		return udp_lib_setsockopt(sk, level, optname,
> >  					  optval, optlen,
> >  					  udp_push_pending_frames);
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index 8d09f0ea5b8c..1ed20bcfd7a0 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -64,8 +64,12 @@ static void udpv6_destruct_sock(struct sock *sk)
> >  
> >  int udpv6_init_sock(struct sock *sk)
> >  {
> > -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> > +	struct udp_sock *up = udp_sk(sk);
> > +
> > +	skb_queue_head_init(&up->reader_queue);
> > +	up->forward_threshold = sk->sk_rcvbuf >> 2;
> >  	sk->sk_destruct = udpv6_destruct_sock;
> > +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
> >  	return 0;
> >  }
> 
> It's time to factorise this part like udp_destruct_common() ?

I guess it makes sense. Possibly 'udp_lib_destruct()' just to follow
others helper style?

> 
Thanks,

Paolo

