Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8569B63C048
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiK2Mre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiK2Mrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:47:33 -0500
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404375E9F9;
        Tue, 29 Nov 2022 04:47:30 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id e27so33462742ejc.12;
        Tue, 29 Nov 2022 04:47:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sa9E0/v9b1xAmPW/8o9nmxOSrZKgnB1xqUmwf2B/JNM=;
        b=4EW/nF4P1L7/uA4SAMLl9OYwE5k6YohZ7NxROjIkQu8HtA/+jOBdKliJ49MiY2swj6
         lGgWDQAZV+XTL2y4UfjddfdLRZXxdEyrWfEI7U9e0aUb21geRPULgTsV2LtflhLGVS6P
         9dql5vrGtupwsL/onqnpZt60g/vObCaxgpfpWiZeugrvwxvEmrAqRp+SOt1j7l4+Yjze
         i5/x5I1JFZzUTUvFOdfhD5l+ovCHrUi+Ny/JU3pOtNF5/c6iVEq0EXrqknI5FEI5i2hR
         bGx3xGJHkyZ3vv2/VEhtUxRk7tGw0ZBrQunvfl51sQEDK/PeXvnav9UQt5jqEb3vfNaU
         6erw==
X-Gm-Message-State: ANoB5plgVn/f3esNdBYC0vtgdrTeCEJqchQNxkvCwAdtLVSocrY44XHK
        GYN5Mp4NcQremFs0hmIV5ME=
X-Google-Smtp-Source: AA0mqf5mPMJdfEU+nMzytdu19PC8wcc1mvnsSoJbTx1ms+q0Z4xR/Uj00Q+4rh41Dac9Rwmvt48WkA==
X-Received: by 2002:a17:906:9445:b0:7bb:7520:f168 with SMTP id z5-20020a170906944500b007bb7520f168mr22532207ejx.423.1669726048700;
        Tue, 29 Nov 2022 04:47:28 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id n3-20020aa7c683000000b0046353d6f454sm6166678edq.95.2022.11.29.04.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 04:47:28 -0800 (PST)
Date:   Tue, 29 Nov 2022 04:47:26 -0800
From:   Breno Leitao <leitao@debian.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, leit@fb.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of
 WARN_ON_ONCE()
Message-ID: <Y4X/XidkaLaD5Zak@gmail.com>
References: <20221124112229.789975-1-leitao@debian.org>
 <20221129010055.75780-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129010055.75780-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 10:00:55AM +0900, Kuniyuki Iwashima wrote:
> From:   Breno Leitao <leitao@debian.org>
> Date:   Thu, 24 Nov 2022 03:22:29 -0800
> > There are cases where we need information about the socket during a
> > warning, so, it could help us to find bugs that happens and do not have
> > an easy repro.
> > 
> > This diff creates a TCP socket-specific version of WARN_ON_ONCE(), which
> > dumps more information about the TCP socket.
> > 
> > This new warning is not only useful to give more insight about kernel bugs, but,
> > it is also helpful to expose information that might be coming from buggy
> > BPF applications, such as BPF applications that sets invalid
> > tcp_sock->snd_cwnd values.
> 
> Have you finally found a root cause on BPF or TCP side ?

Yes, this demonstrated to be very useful to find out BPF applications
that are doing nasty things with the congestion window.

We currently have this patch applied to Meta's infrastructure to track
BPF applications that are misbehaving, and easily track down to which
BPF application is the responsible one.

> > +#endif  /* _LINUX_TCP_DEBUG_H */
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 54836a6b81d6..dd682f60c7cb 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4705,6 +4705,36 @@ int tcp_abort(struct sock *sk, int err)
> >  }
> >  EXPORT_SYMBOL_GPL(tcp_abort);
> >  
> > +void tcp_sock_warn(const struct tcp_sock *tp)
> > +{
> > +	const struct sock *sk = (const struct sock *)tp;
> > +	struct inet_sock *inet = inet_sk(sk);
> > +	struct inet_connection_sock *icsk = inet_csk(sk);
> > +
> > +	WARN_ON(1);
> > +
> > +	if (!tp)
> 
> Is this needed ?

We are de-referencing tp/sk in the lines below, so, I think it is safe to
check if they are not NULL before the de-refencing it.

Should I do check for "ck" instead of "tp" to make the code a bit
cleaner to read?

> > +	pr_warn("Socket Info: family=%u state=%d sport=%u dport=%u ccname=%s cwnd=%u",
> > +		sk->sk_family, sk->sk_state, ntohs(inet->inet_sport),
> > +		ntohs(inet->inet_dport), icsk->icsk_ca_ops->name, tcp_snd_cwnd(tp));
> > +
> > +	switch (sk->sk_family) {
> > +	case AF_INET:
> > +		pr_warn("saddr=%pI4 daddr=%pI4", &inet->inet_saddr,
> > +			&inet->inet_daddr);
> 
> As with tcp_syn_flood_action(), [address]:port format is easy
> to read and consistent in kernel ?

Absolutely. I am going to fix it in v2. Thanks!
