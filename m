Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857C26CC845
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjC1Qlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjC1Qli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:41:38 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E732CA5ED
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680021696; x=1711557696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jki1hohna1iBdp6jm4e3Y2pxExpGReD4VsKNc3dTibo=;
  b=L1pjeLISvJaw2dEa+LbR8ykA/fPwLxoDAPh+IpeQEy2KPAjIVCnWarRv
   2jmz1j5VdEMcuKEwg3+5CMQ25U8QmyTmbLst3dGt+pxXRcW6g33y0qDVT
   6Y+gDNQr841ozsT8oo6x4v2vgcNok8vRobAS8BQBMXNdC3renVBBteOCz
   A=;
X-IronPort-AV: E=Sophos;i="5.98,297,1673913600"; 
   d="scan'208";a="312222612"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 16:41:33 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id 85539645D9;
        Tue, 28 Mar 2023 16:41:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 28 Mar 2023 16:41:29 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.35) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 Mar 2023 16:41:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net] tcp: Refine SYN handling for PAWS.
Date:   Tue, 28 Mar 2023 09:41:19 -0700
Message-ID: <20230328164119.44065-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLF6_iUd6DSbrqALSvowPfNKqnOrX27GpVPLSCG-FipCA@mail.gmail.com>
References: <CANn89iLF6_iUd6DSbrqALSvowPfNKqnOrX27GpVPLSCG-FipCA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.35]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Mar 2023 01:13:09 -0700
> On Mon, Mar 27, 2023 at 4:06=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
> m> wrote:
> >
> > Our Network Load Balancer (NLB) [0] has multiple nodes with different
> > IP addresses, and each node forwards TCP flows from clients to backend
> > targets.  NLB has an option to preserve the client's source IP address
> > and port when routing packets to backend targets.
> >
> > When a client connects to two different NLB nodes, they may select the
> > same backend target.  Then, if the client has used the same source IP
> > and port, the two flows at the backend side will have the same 4-tuple.
> >
> > While testing around such cases, I saw these sequences on the backend
> > target.
> >
> > IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2819965599, win 62=
> 727, options [mss 8365,sackOK,TS val 1029816180 ecr 0,nop,wscale 7], length=
>  0
> > IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3040695044, ack 2=
> 819965600, win 62643, options [mss 8961,sackOK,TS val 1224784076 ecr 102981=
> 6180,nop,wscale 7], length 0
> > IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1, win 491, option=
> s [nop,nop,TS val 1029816181 ecr 1224784076], length 0
> > IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2681819307, win 62=
> 727, options [mss 8365,sackOK,TS val 572088282 ecr 0,nop,wscale 7], length =
> 0
> > IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 1, win 490, option=
> s [nop,nop,TS val 1224794914 ecr 1029816181,nop,nop,sack 1 {4156821004:4156=
> 821005}], length 0
> >
> > It seems to be working correctly, but the last ACK was generated by
> > tcp_send_dupack() and PAWSEstab was increased.  This is because the
> > second connection has a smaller timestamp than the first one.
> >
> > In this case, we should send a challenge ACK instead of a dup ACK and
> > increase the correct counter to rate-limit it properly.
> 
> OK, but this seems about the same thing to me. A challenge ACK is a dup ACK=
>  ?

Yes, I thought you distinguished them with the counter, and I just
followed it :)

e37158991701 ("tcp: refine SYN handling in tcp_validate_incoming")

> 
> It is not clear why it matters, because most probably both ACK make no
> sense for the sender ?

Yes, but it's tricky that which counter is increased depends on the
two timestamp.


> 
> >
> > Let's check the SYN bit after the PAWS tests to avoid adding unnecessary
> > overhead for most packets.
> >
> > Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/int=
> roduction.html [0]
> > Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/loa=
> d-balancer-target-groups.html#client-ip-preservation [1]
> > Fixes: 0c24604b68fc ("tcp: implement RFC 5961 4.2")
> 
> The core of the change was to not send an RST anymore.
> I did not change part of the code which was not sending an RST :)

I see.
Should I replace the tag with add 'CC: stable # backport ver', or
respin for net-next without the tag ?

Thanks,
Kuniyuki


> 
> 
> 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/ipv4/tcp_input.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index cc072d2cfcd8..89fca4c18530 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5714,6 +5714,8 @@ static bool tcp_validate_incoming(struct sock *sk, =
> struct sk_buff *skb,
> >             tp->rx_opt.saw_tstamp &&
> >             tcp_paws_discard(sk, skb)) {
> >                 if (!th->rst) {
> > +                       if (unlikely(th->syn))
> > +                               goto syn_challenge;
> >                         NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABRE=
> JECTED);
> >                         if (!tcp_oow_rate_limited(sock_net(sk), skb,
> >                                                   LINUX_MIB_TCPACKSKIPPED=
> PAWS,
> > --
> > 2.30.2
> >
