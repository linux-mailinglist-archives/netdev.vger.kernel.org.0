Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7E263CA6A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbiK2VQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiK2VQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:16:48 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085075C0DE;
        Tue, 29 Nov 2022 13:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1669756607; x=1701292607;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=hZz60aGuc1JfVxwYGBI9xD6TVS8iQ/A47SbJHgXnVz0=;
  b=gJQzSj5bkrKoB7uzY69Pd6wrcSCx3qJQSkbcb+1GZWjAXi4d+uUmHdYM
   eXPHGdT9ydB6CV0/4CHgY8q0DR02jD3nFAytbS/qtlKwZw6HfCuwH5eoh
   9bL8d1jtiW9tkZW10hq3pYGJv1x0JLgSQRltwgSyLZJSdNhStV7O+f08/
   A=;
X-IronPort-AV: E=Sophos;i="5.96,204,1665446400"; 
   d="scan'208";a="1078651156"
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of WARN_ON_ONCE()
Thread-Topic: [PATCH RESEND net-next] tcp: socket-specific version of WARN_ON_ONCE()
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 21:16:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id D4FCC425C0;
        Tue, 29 Nov 2022 21:16:17 +0000 (UTC)
Received: from EX19D004ANA004.ant.amazon.com (10.37.240.146) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 29 Nov 2022 21:16:17 +0000
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19D004ANA004.ant.amazon.com (10.37.240.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Tue, 29 Nov 2022 21:16:16 +0000
Received: from EX19D004ANA001.ant.amazon.com ([fe80::f099:cbca:cc6b:91ec]) by
 EX19D004ANA001.ant.amazon.com ([fe80::f099:cbca:cc6b:91ec%5]) with mapi id
 15.02.1118.020; Tue, 29 Nov 2022 21:16:16 +0000
From:   "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
To:     Breno Leitao <leitao@debian.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "leit@fb.com" <leit@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Thread-Index: AQHZA44PkgbcE2NjRk6nD9bv4KRS8q5V2lsAgACOKkA=
Date:   Tue, 29 Nov 2022 21:16:16 +0000
Message-ID: <A5D7EBCF-CC49-4575-9DA7-0419BA1F0E9B@amazon.co.jp>
References: <20221124112229.789975-1-leitao@debian.org>
 <20221129010055.75780-1-kuniyu@amazon.com>,<Y4X/XidkaLaD5Zak@gmail.com>
In-Reply-To: <Y4X/XidkaLaD5Zak@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 29, 2022, at 21:48, Breno Leitao <leitao@debian.org> wrote:
>> On Tue, Nov 29, 2022 at 10:00:55AM +0900, Kuniyuki Iwashima wrote:
>> From:   Breno Leitao <leitao@debian.org>
>> Date:   Thu, 24 Nov 2022 03:22:29 -0800
>>> There are cases where we need information about the socket during a
>>> warning, so, it could help us to find bugs that happens and do not have
>>> an easy repro.
>>>=20
>>> This diff creates a TCP socket-specific version of WARN_ON_ONCE(), whic=
h
>>> dumps more information about the TCP socket.
>>>=20
>>> This new warning is not only useful to give more insight about kernel b=
ugs, but,
>>> it is also helpful to expose information that might be coming from bugg=
y
>>> BPF applications, such as BPF applications that sets invalid
>>> tcp_sock->snd_cwnd values.
>>=20
>> Have you finally found a root cause on BPF or TCP side ?
>=20
> Yes, this demonstrated to be very useful to find out BPF applications
> that are doing nasty things with the congestion window.
>=20
> We currently have this patch applied to Meta's infrastructure to track
> BPF applications that are misbehaving, and easily track down to which
> BPF application is the responsible one.

If you have a fix merged on the BPF side,=20
it would be helpful to mention the commit to=20
well understand the issue, background,=20
and why other tooling is not enough as Paolo wondered.



>>> +#endif  /* _LINUX_TCP_DEBUG_H */
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 54836a6b81d6..dd682f60c7cb 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -4705,6 +4705,36 @@ int tcp_abort(struct sock *sk, int err)
>>> }
>>> EXPORT_SYMBOL_GPL(tcp_abort);
>>>=20
>>> +void tcp_sock_warn(const struct tcp_sock *tp)
>>> +{
>>> +   const struct sock *sk =3D (const struct sock *)tp;
>>> +   struct inet_sock *inet =3D inet_sk(sk);
>>> +   struct inet_connection_sock *icsk =3D inet_csk(sk);
>>> +
>>> +   WARN_ON(1);
>>> +
>>> +   if (!tp)
>>=20
>> Is this needed ?
>=20
> We are de-referencing tp/sk in the lines below, so, I think it is safe to
> check if they are not NULL before the de-refencing it.

tp->snd_cwnd is accessed just after this WARN,=20
so I thought there were no cases where tp is NULL.
If it exists, KASAN should be complaining.
I think this additional if could confuse future readers and=20
want to make sure if there is such a case.

Thank you!

>=20
> Should I do check for "ck" instead of "tp" to make the code a bit
> cleaner to read?
>=20
>>> +   pr_warn("Socket Info: family=3D%u state=3D%d sport=3D%u dport=3D%u =
ccname=3D%s cwnd=3D%u",
>>> +           sk->sk_family, sk->sk_state, ntohs(inet->inet_sport),
>>> +           ntohs(inet->inet_dport), icsk->icsk_ca_ops->name, tcp_snd_c=
wnd(tp));
>>> +
>>> +   switch (sk->sk_family) {
>>> +   case AF_INET:
>>> +           pr_warn("saddr=3D%pI4 daddr=3D%pI4", &inet->inet_saddr,
>>> +                   &inet->inet_daddr);
>>=20
>> As with tcp_syn_flood_action(), [address]:port format is easy
>> to read and consistent in kernel ?
>=20
> Absolutely. I am going to fix it in v2. Thanks!
