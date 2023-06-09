Return-Path: <netdev+bounces-9693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9E572A375
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 222B72819EF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273D8209B5;
	Fri,  9 Jun 2023 19:54:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D51800E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:54:06 +0000 (UTC)
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCB83AA6;
	Fri,  9 Jun 2023 12:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686340441; x=1717876441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L8AJYXTOF2/4YdwafM0nj79mMZyRJRuD9KvtxPd4yGw=;
  b=SUpga5AjHAN33rob5sz5oxL1kzlXXwAbCdPde+OiGaPKqNcyEP/AfxTl
   B/pqp3qj/wLvtTPmGsBTJwZ9MYA8y3CfRV4JUVobmVpyhtVIS2c14xote
   LBYDrxrCNeSQgf14jaA15fjhAxEufeqwGWYOY0GyxBzsqBGJg9dIwmbth
   g=;
X-IronPort-AV: E=Sophos;i="6.00,230,1681171200"; 
   d="scan'208";a="654069006"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 19:53:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id DDAD740DDB;
	Fri,  9 Jun 2023 19:53:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 9 Jun 2023 19:53:52 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 9 Jun 2023 19:53:47 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <haiyangz@microsoft.com>
CC: <ncardwell@google.com>, <atenart@kernel.org>, <bagasdotme@gmail.com>,
	<corbet@lwn.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
	<kys@microsoft.com>, <linux-doc@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liushixin2@huawei.com>, <maheshb@google.com>, <netdev@vger.kernel.org>,
	<olaf@aepfle.de>, <pabeni@redhat.com>, <simon.horman@corigine.com>,
	<soheil@google.com>, <stephen@networkplumber.org>,
	<tim.gardner@canonical.com>, <vkuznets@redhat.com>, <weiwan@google.com>,
	<ycheng@google.com>, <ykaliuta@redhat.com>
Subject: Re: [PATCH net-next] tcp: Make pingpong threshold tunable
Date: Fri, 9 Jun 2023 12:53:38 -0700
Message-ID: <20230609195338.27299-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CADVnQykbSQTrNtpFm8YVgGY929mmzY2zSQ2-KxGmNthYyR9GLg@mail.gmail.com>
References: <CADVnQykbSQTrNtpFm8YVgGY929mmzY2zSQ2-KxGmNthYyR9GLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.20]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Neal Cardwell <ncardwell@google.com>
Date: Fri, 9 Jun 2023 15:16:00 -0400
> On Fri, Jun 9, 2023 at 12:26 PM Haiyang Zhang <haiyangz@microsoft.com> wrote:
> 
> Regarding the patch title:
> > [PATCH net-next] tcp: Make pingpong threshold tunable
> 
> There are many ways to make something tunable these days, including
> BPF, setsockopt(), and sysctl. :-) This patch only uses sysctl. Please
> consider a more clear/specific title, like:
> 
>    [PATCH net-next] tcp: set pingpong threshold via sysctl
> 
> > TCP pingpong threshold is 1 by default. But some applications, like SQL DB
> > may prefer a higher pingpong threshold to activate delayed acks in quick
> > ack mode for better performance.
> >
> > The pingpong threshold and related code were changed to 3 in the year
> > 2019, and reverted to 1 in the year 2022.
> 
> Please include the specific commit, like:
> 
> The pingpong threshold and related code were changed to 3 in the year
>  2019 in:
>    commit 4a41f453bedf ("tcp: change pingpong threshold to 3")
> and reverted to 1 in the year 2022 in:
>   commit 4d8f24eeedc5 ("Revert "tcp: change pingpong threshold to 3"")
> 
> Then please make sure to use scripts/checkpatch.pl on your resulting
> patch to check the formatting of the commit references, among other
> things.
> 
> > There is no single value that
> > fits all applications.
> >
> > Add net.core.tcp_pingpong_thresh sysctl tunable,
> 
> For consistency, TCP sysctls should be in net.ipv4 rather than
> net.core. Yes, that is awkward, given IPv6 support. But consistency is
> very important here. :-)
> 
> > so it can be tuned for
> > optimal performance based on the application needs.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  Documentation/admin-guide/sysctl/net.rst |  8 ++++++++
> >  include/net/inet_connection_sock.h       | 14 +++++++++++---
> >  net/core/sysctl_net_core.c               |  9 +++++++++
> >  net/ipv4/tcp.c                           |  2 ++
> >  net/ipv4/tcp_output.c                    | 17 +++++++++++++++--
> >  5 files changed, 45 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> > index 4877563241f3..16f54be9461f 100644
> > --- a/Documentation/admin-guide/sysctl/net.rst
> > +++ b/Documentation/admin-guide/sysctl/net.rst
> > @@ -413,6 +413,14 @@ historical importance.
> >
> >  Default: 0
> >
> > +tcp_pingpong_thresh
> > +-------------------
> > +
> > +TCP pingpong threshold is 1 by default, but some application may need a higher
> > +threshold for optimal performance.
> > +
> > +Default: 1, min: 1, max: 3
> 
> If we want to make this tunable, it seems sad to make the max 3. I'd
> suggest making the max 255, since we have 8 bits of space anyway in
> the inet_csk(sk)->icsk_ack.pingpong field.
> 
> > +
> >  2. /proc/sys/net/unix - Parameters for Unix domain sockets
> >  ----------------------------------------------------------
> >
> > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > index c2b15f7e5516..e84e33ddae49 100644
> > --- a/include/net/inet_connection_sock.h
> > +++ b/include/net/inet_connection_sock.h
> > @@ -324,11 +324,11 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
> >
> >  struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
> >
> > -#define TCP_PINGPONG_THRESH    1
> > +extern int tcp_pingpong_thresh;
> 
> To match most TCP sysctls, this should be per-namespace, rather than global.

Also, please change int to u8.


> 
> Please follow a recent example by Eric, perhaps:
>  65466904b015f6eeb9225b51aeb29b01a1d4b59c
>   tcp: adjust TSO packet sizes based on min_rtt
> 
> 
> >
> >  static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
> >  {
> > -       inet_csk(sk)->icsk_ack.pingpong = TCP_PINGPONG_THRESH;
> > +       inet_csk(sk)->icsk_ack.pingpong = tcp_pingpong_thresh;
> >  }
> 
>   inet_csk(sk)->icsk_ack.pingpong =  sock_net(sk)->sysctl_tcp_pingpong_thresh;

Let's use READ_ONCE(sock_net(sk)->sysctl_tcp_pingpong_thresh).
Same for other sysctl reads.


> 
> >  static inline void inet_csk_exit_pingpong_mode(struct sock *sk)
> > @@ -338,7 +338,15 @@ static inline void inet_csk_exit_pingpong_mode(struct sock *sk)
> >
> >  static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
> >  {
> > -       return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
> > +       return inet_csk(sk)->icsk_ack.pingpong >= tcp_pingpong_thresh;
> > +}
> 
> Again, sock_net(sk)->sysctl_tcp_pingpong_thresh rather than tcp_pingpong_thresh.
> 
> > +static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
> > +{
> > +       struct inet_connection_sock *icsk = inet_csk(sk);
> > +
> > +       if (icsk->icsk_ack.pingpong < U8_MAX)
> > +               icsk->icsk_ack.pingpong++;
> >  }
> >
> >  static inline bool inet_csk_has_ulp(struct sock *sk)
> > diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> > index 782273bb93c2..b5253567f2bd 100644
> > --- a/net/core/sysctl_net_core.c
> > +++ b/net/core/sysctl_net_core.c
> > @@ -653,6 +653,15 @@ static struct ctl_table net_core_table[] = {
> 
> Again, in net.ipv4, not net.core.
> 
> >                 .proc_handler   = proc_dointvec_minmax,
> >                 .extra1         = SYSCTL_ZERO,
> >         },
> > +       {
> > +               .procname       = "tcp_pingpong_thresh",
> > +               .data           = &tcp_pingpong_thresh,
> > +               .maxlen         = sizeof(int),
> > +               .mode           = 0644,
> > +               .proc_handler   = proc_dointvec_minmax,
> > +               .extra1         = SYSCTL_ONE,
> > +               .extra2         = SYSCTL_THREE,
> 
> Please make the max U8_MAX to allow more flexibility (since we have 8
> bits of space anyway in the inet_csk(sk)->icsk_ack.pingpong field).

Please use proc_dou8vec_minmax(), then you can drop .extra2.

		.maxlen		= sizeof(u8),
		.mode		= 0644,
		.proc_handler	= proc_dou8vec_minmax,
		.extra1         = SYSCTL_ONE,

Thanks,
Kuniyuki

> 
> > +       },
> >         { }
> >  };
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 53b7751b68e1..dcd143193d41 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -308,6 +308,8 @@ EXPORT_SYMBOL(tcp_have_smc);
> >  struct percpu_counter tcp_sockets_allocated ____cacheline_aligned_in_smp;
> >  EXPORT_SYMBOL(tcp_sockets_allocated);
> >
> > +int tcp_pingpong_thresh __read_mostly = 1;
> > +
> 
> Again, per-network-namespace. You will need to initialize the
> per-netns value in tcp_sk_init(). Again, see Eric's
> 65466904b015f6eeb9225b51aeb29b01a1d4b59c commit for an example.
> 
> >   * TCP splice context
> >   */
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index cfe128b81a01..576d21621778 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -167,12 +167,25 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
> >         if (tcp_packets_in_flight(tp) == 0)
> >                 tcp_ca_event(sk, CA_EVENT_TX_START);
> >
> > +       /* If tcp_pingpong_thresh > 1, and
> > +        * this is the first data packet sent in response to the
> > +        * previous received data,
> > +        * and it is a reply for ato after last received packet,
> > +        * increase pingpong count.
> > +        */
> > +       if (tcp_pingpong_thresh > 1 &&
> > +           before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> > +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> > +               inet_csk_inc_pingpong_cnt(sk);
> > +
> 
> Introducing this new code re-introduces a bug fixed in 4d8f24eeedc5.
> As that commit description noted:
> 
>     This to-be-reverted commit was meant to apply a stricter rule for the
>     stack to enter pingpong mode. However, the condition used to check for
>     interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
>     jiffy based and might be too coarse, which delays the stack entering
>     pingpong mode.
>     We revert this patch so that we no longer use the above condition to
>     determine interactive session,
> 
> >         tp->lsndtime = now;
> >
> > -       /* If it is a reply for ato after last received
> > +       /* If tcp_pingpong_thresh == 1, and
> 
> Please remove the "If tcp_pingpong_thresh == 1, and" part, since this
> is the correct code path no matter the value of the threshold.
> 
> > +        * it is a reply for ato after last received
> >          * packet, enter pingpong mode.
> >          */
> > -       if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> > +       if (tcp_pingpong_thresh == 1 &&
> 
> Please remove the "if (tcp_pingpong_thresh == 1 &&" part, since this
> is the correct code path no matter the value of the threshold.
> 
> > +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> >                 inet_csk_enter_pingpong_mode(sk);
> 
> Please make this call inet_csk_inc_pingpong_cnt(), since this is the
> correct code path no matter the value of the threshold.

