Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC343CD04
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhJ0PJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:09:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242006AbhJ0PJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635347194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WaJsEVK6RTJymXSYFPfb98mvvIHuGJxSuhTn6FMP6ZQ=;
        b=geHamIncjaAg/qLYXkKYHQU3TUp0hE5V1W8t0U7DUfq+VyHbRvZ5w//Ul9CxYcI4wUQZSD
        ocMlcXOr2CQvTC7iZrISVuhvNwNlf3oqpckRwXMTJZsWrT54QiU1VqTUY402mBeB8PK168
        ei1koDQexKp27qIfwY5R/1nNf4ZIpbs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-Hbf2WFX1PzGlsSWL80suJw-1; Wed, 27 Oct 2021 11:06:33 -0400
X-MC-Unique: Hbf2WFX1PzGlsSWL80suJw-1
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso2557099edj.20
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WaJsEVK6RTJymXSYFPfb98mvvIHuGJxSuhTn6FMP6ZQ=;
        b=ImJxzSRzefKfu/GC9PCvgClzxkr4veI/3YK2hU8EkUN/o9ymIWzctYn3tb1k8nRoPP
         kZqblC33Rly1WzhttrYW4f+ffdz3/8faNTUU2ExEvCNtqkxUFL+/4FhozI5M4i+Bkynl
         egzOfmguCj1O2JNiRV7rBWu1nR2bQ+PHyZBcclbQ9Du50z/Wg6kUaX0/USV2PaZdpz5X
         RmSnk8Cx8NqnD17+bTpovU2hGBEeORAoxJ0YMH7BisFqoWp9VABRCuiYldtQJL3MVNoN
         wKsltr02E1/gwzIIaLhYqvUszr6da8scet5kuOsd3XHKw77XQxsZkZpNpchlIr8c/eGx
         OzkQ==
X-Gm-Message-State: AOAM530YHvvQ2psNSVJC4KCxXf37m+TwT8dBbH3l0uoweSvNLtW/4GUw
        O29p/FA8dww2r6ff3e5WurukK9t/vn69vYAY+OlWpE2zpsjyWJJSX4lJVovpWpvlT8H5GvUBkUD
        ZiJrDf5hvlAHL5fNT
X-Received: by 2002:a05:6402:35cb:: with SMTP id z11mr48041247edc.342.1635347192158;
        Wed, 27 Oct 2021 08:06:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlfaeg9PhBqoo83vyHofeMqgaVSyG4wGPQiez7/13IigfY7rs/mMPbP1xyDtBPcD1Fr7vLOg==
X-Received: by 2002:a05:6402:35cb:: with SMTP id z11mr48041220edc.342.1635347191936;
        Wed, 27 Oct 2021 08:06:31 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-123-146.dyn.eolo.it. [146.241.123.146])
        by smtp.gmail.com with ESMTPSA id g8sm73391ejt.104.2021.10.27.08.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:06:31 -0700 (PDT)
Message-ID: <ab3b1f2444e3a3a6b8490255e80f952196a2c00e.camel@redhat.com>
Subject: Re: [PATCH net-next v3 04/17] mptcp: Add handling of outgoing
 MP_JOIN requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 27 Oct 2021 17:06:30 +0200
In-Reply-To: <a0c568ca298714e04da75c879f28cb6e3836d813.camel@redhat.com>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
         <20200327214853.140669-5-mathew.j.martineau@linux.intel.com>
         <bbbc234b-c597-7294-f044-d90317c6798d@gmail.com>
         <a0c568ca298714e04da75c879f28cb6e3836d813.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-27 at 10:45 +0200, Paolo Abeni wrote:
> On Tue, 2021-10-26 at 17:54 -0700, Eric Dumazet wrote:
> > On 3/27/20 2:48 PM, Mat Martineau wrote:
> > > From: Peter Krystad <peter.krystad@linux.intel.com>
> > > 
> > > Subflow creation may be initiated by the path manager when
> > > the primary connection is fully established and a remote
> > > address has been received via ADD_ADDR.
> > > 
> > > Create an in-kernel sock and use kernel_connect() to
> > > initiate connection.
> > > 
> > > Passive sockets can't acquire the mptcp socket lock at
> > > subflow creation time, so an additional list protected by
> > > a new spinlock is used to track the MPJ subflows.
> > > 
> > > Such list is spliced into conn_list tail every time the msk
> > > socket lock is acquired, so that it will not interfere
> > > with data flow on the original connection.
> > > 
> > > Data flow and connection failover not addressed by this commit.
> > > 
> > > Co-developed-by: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > > Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > > Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
> > > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > > ---
> > 
> > ...
> > 
> > > +/* MP_JOIN client subflow must wait for 4th ack before sending any data:
> > > + * TCP can't schedule delack timer before the subflow is fully established.
> > > + * MPTCP uses the delack timer to do 3rd ack retransmissions
> > > + */
> > > +static void schedule_3rdack_retransmission(struct sock *sk)
> > > +{
> > > +	struct inet_connection_sock *icsk = inet_csk(sk);
> > > +	struct tcp_sock *tp = tcp_sk(sk);
> > > +	unsigned long timeout;
> > > +
> > > +	/* reschedule with a timeout above RTT, as we must look only for drop */
> > > +	if (tp->srtt_us)
> > > +		timeout = tp->srtt_us << 1;
> > 
> > srtt_us is in usec/8 units.
> > 
> > > +	else
> > > +		timeout = TCP_TIMEOUT_INIT;
> > 
> > TCP_TIMEOUT_INIT is in HZ units.
> > 
> > 
> > > +
> > > +	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
> > > +	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
> > > +	icsk->icsk_ack.timeout = timeout;
> > 
> > Usually, we have to use jiffies as well...
> > 
> > > +	sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
> > > +}
> > > +
> > > 
> > 
> > I wonder if this delack_timer ever worked.
> > What about this fix ?
> > 
> > diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> > index 422f4acfb3e6d6d41f6f5f820828eaa40ffaa6b9..9f5edcf562c9f98539256074b8f587c0a64a8693 100644
> > --- a/net/mptcp/options.c
> > +++ b/net/mptcp/options.c
> > @@ -434,12 +434,13 @@ static void schedule_3rdack_retransmission(struct sock *sk)
> >  
> >         /* reschedule with a timeout above RTT, as we must look only for drop */
> >         if (tp->srtt_us)
> > -               timeout = tp->srtt_us << 1;
> > +               timeout = usecs_to_jiffies(tp->srtt_us >> (3-1));
> >         else
> >                 timeout = TCP_TIMEOUT_INIT;
> >  
> >         WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
> >         icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
> > +       timeout += jiffies;
> >         icsk->icsk_ack.timeout = timeout;
> >         sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
> >  }
> 
> Thanks Eric for catching this! We need better packetdrill coverage
> here. 

I'm experimenting with a pktdrill test, and there is also at least
another issue: the scheduled delack is cleared before taking action. So
very likely this never worked.

I'll look for a complete fix. Thanks again for head-up and suggestion!

Paolo

