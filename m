Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11443C572
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbhJ0IsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:48:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240983AbhJ0Irx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635324324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/iKr+S+Cfw+kIjOfu3HmIfYU3r9/PIu5ZM8zunhXac=;
        b=KVCkts/knNTqswKrTNAZ899fYad1hKKKJRY4Wx8gwz1RDKTuVGvse8OOQuGTfvJLZltDPx
        KIpTS0H/AlFR5uS3u1sPoiqETj22hyfirmj/ZLh/fGbZf69gucPT5iZNxPqAIXYDAQUS33
        cwBGv1KtfbYaVqWveImIDfwQmWm79FM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-IaqWy0UnNEq0OOJG8IImkg-1; Wed, 27 Oct 2021 04:45:23 -0400
X-MC-Unique: IaqWy0UnNEq0OOJG8IImkg-1
Received: by mail-wr1-f71.google.com with SMTP id u15-20020a5d514f000000b001687ebddea3so397156wrt.8
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 01:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=A/iKr+S+Cfw+kIjOfu3HmIfYU3r9/PIu5ZM8zunhXac=;
        b=t4Pq4YJG3p42PU4pbaCVynEDVVNMmbGVsM2o+kDvA7XWoKkaPFY7/gA83WCWJVlnNv
         k8EK8hdjHwrjU4k24uAFMDRbnRaW6L4D66mtWUFdZP81gO2v3p5cM3RZ+7zLlXHx015O
         9GKcdpdiNMXOH1CkdEtiix5BcvubedM2H0Tl0wi0Zw1KdrCqvrmf/7miBula0F150u4R
         r4qFt4PlOkdcrPXLYEB/Pmo4hhum+nyuyfcS5T9QAJpAS7nyM7LgUrP3zpyKwJLSD+gk
         /ekM3aoCxytdkNDk2d4ve6qxX5QShWsHVkiGAqy0eyKyUFGqN76lC8XTEFn0H6APaCtB
         XPjQ==
X-Gm-Message-State: AOAM532b5ac3s+dst4u+c34pJLMu6qg2GFw1T7bSuAK/u4dHokCsLYV6
        B7B1EPh11cn2lQZfj3dy9ch/xu+LGEq/urpl0Dx/iaGtl1/wwhad9dRUQvUPFzwbohKSJL+m2rd
        P2hVdiojzuVMBK/fT
X-Received: by 2002:a5d:5274:: with SMTP id l20mr11868665wrc.328.1635324321884;
        Wed, 27 Oct 2021 01:45:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1H1kCle9T0HGyG/WfgBOupEu25tNjkXzBRPQ6gsHacCaZM/ajx9hRVTnlJaFPHbwrDLWAhA==
X-Received: by 2002:a5d:5274:: with SMTP id l20mr11868642wrc.328.1635324321666;
        Wed, 27 Oct 2021 01:45:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-123-146.dyn.eolo.it. [146.241.123.146])
        by smtp.gmail.com with ESMTPSA id m3sm325082wrx.52.2021.10.27.01.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 01:45:21 -0700 (PDT)
Message-ID: <a0c568ca298714e04da75c879f28cb6e3836d813.camel@redhat.com>
Subject: Re: [PATCH net-next v3 04/17] mptcp: Add handling of outgoing
 MP_JOIN requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 27 Oct 2021 10:45:20 +0200
In-Reply-To: <bbbc234b-c597-7294-f044-d90317c6798d@gmail.com>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
         <20200327214853.140669-5-mathew.j.martineau@linux.intel.com>
         <bbbc234b-c597-7294-f044-d90317c6798d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-10-26 at 17:54 -0700, Eric Dumazet wrote:
> 
> On 3/27/20 2:48 PM, Mat Martineau wrote:
> > From: Peter Krystad <peter.krystad@linux.intel.com>
> > 
> > Subflow creation may be initiated by the path manager when
> > the primary connection is fully established and a remote
> > address has been received via ADD_ADDR.
> > 
> > Create an in-kernel sock and use kernel_connect() to
> > initiate connection.
> > 
> > Passive sockets can't acquire the mptcp socket lock at
> > subflow creation time, so an additional list protected by
> > a new spinlock is used to track the MPJ subflows.
> > 
> > Such list is spliced into conn_list tail every time the msk
> > socket lock is acquired, so that it will not interfere
> > with data flow on the original connection.
> > 
> > Data flow and connection failover not addressed by this commit.
> > 
> > Co-developed-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> 
> ...
> 
> > +/* MP_JOIN client subflow must wait for 4th ack before sending any data:
> > + * TCP can't schedule delack timer before the subflow is fully established.
> > + * MPTCP uses the delack timer to do 3rd ack retransmissions
> > + */
> > +static void schedule_3rdack_retransmission(struct sock *sk)
> > +{
> > +	struct inet_connection_sock *icsk = inet_csk(sk);
> > +	struct tcp_sock *tp = tcp_sk(sk);
> > +	unsigned long timeout;
> > +
> > +	/* reschedule with a timeout above RTT, as we must look only for drop */
> > +	if (tp->srtt_us)
> > +		timeout = tp->srtt_us << 1;
> 
> srtt_us is in usec/8 units.
> 
> > +	else
> > +		timeout = TCP_TIMEOUT_INIT;
> 
> TCP_TIMEOUT_INIT is in HZ units.
> 
> 
> > +
> > +	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
> > +	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
> > +	icsk->icsk_ack.timeout = timeout;
> 
> Usually, we have to use jiffies as well...
> 
> > +	sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
> > +}
> > +
> > 
> 
> I wonder if this delack_timer ever worked.


> 
> What about this fix ?
> 
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index 422f4acfb3e6d6d41f6f5f820828eaa40ffaa6b9..9f5edcf562c9f98539256074b8f587c0a64a8693 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -434,12 +434,13 @@ static void schedule_3rdack_retransmission(struct sock *sk)
>  
>         /* reschedule with a timeout above RTT, as we must look only for drop */
>         if (tp->srtt_us)
> -               timeout = tp->srtt_us << 1;
> +               timeout = usecs_to_jiffies(tp->srtt_us >> (3-1));
>         else
>                 timeout = TCP_TIMEOUT_INIT;
>  
>         WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
>         icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
> +       timeout += jiffies;
>         icsk->icsk_ack.timeout = timeout;
>         sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
>  }

Thanks Eric for catching this! We need better packetdrill coverage
here. I would be courious to learn how did you get it? 

The patch LGTM, would you formally submit it, or do you prefer we cope
with the process?

Thanks!

Paolo

