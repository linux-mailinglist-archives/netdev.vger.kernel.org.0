Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10769572185
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiGLRDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiGLRDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:03:35 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173EFE87
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657645413; x=1689181413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8DtFh9+twygDYJByYFhJ3SPAK4ip6KdpU2tSgeoeOvw=;
  b=A31+CSP2mrzWHwy4g9wogBRIPt75769GXqzYStfUN1NKsV8jXVeWBU/B
   T76WVQ4yAOkhxP1NtIVgV3IgDA2D2iYP8efjEmnoJeh7UScofcv2O9DVm
   5KduNFFNeDMm81Din4f7ZH0aXEpBqwRpCJMo7LxpFwI2oQzSLgF1HGvDH
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,266,1650931200"; 
   d="scan'208";a="237456708"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 12 Jul 2022 17:03:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com (Postfix) with ESMTPS id D86342024FB;
        Tue, 12 Jul 2022 17:03:13 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 17:03:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.144) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 17:03:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <subashab@codeaurora.org>
Subject: Re: [PATCH v1 net] tcp/udp: Make early_demux back namespacified.
Date:   Tue, 12 Jul 2022 10:03:02 -0700
Message-ID: <20220712170302.37685-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+k084b4RuoOOrFzYkd9uB0GUbW7VxcCCDSpqWWJaNXnQ@mail.gmail.com>
References: <CANn89i+k084b4RuoOOrFzYkd9uB0GUbW7VxcCCDSpqWWJaNXnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jul 2022 18:51:51 +0200
> On Tue, Jul 12, 2022 at 6:33 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> > it possible to enable/disable early_demux on a per-netns basis.  Then, we
> > introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> > TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> > tcp and udp").  However, the .proc_handler() was wrong and actually
> > disabled us from changing the behaviour in each netns.
> 
> ...
> 
> > -int tcp_v4_early_demux(struct sk_buff *skb)
> > +void tcp_v4_early_demux(struct sk_buff *skb)
> >  {
> >         const struct iphdr *iph;
> >         const struct tcphdr *th;
> >         struct sock *sk;
> >
> >         if (skb->pkt_type != PACKET_HOST)
> > -               return 0;
> > +               return;
> >
> >         if (!pskb_may_pull(skb, skb_transport_offset(skb) + sizeof(struct tcphdr)))
> > -               return 0;
> > +               return;
> >
> >         iph = ip_hdr(skb);
> >         th = tcp_hdr(skb);
> >
> >         if (th->doff < sizeof(struct tcphdr) / 4)
> > -               return 0;
> > +               return;
> >
> >         sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
> >                                        iph->saddr, th->source,
> > @@ -1740,7 +1740,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
> >                                 skb_dst_set_noref(skb, dst);
> >                 }
> >         }
> > -       return 0;
> > +       return;
> >  }
> >
> 
> You have a tendency of making your patches larger than needed.
> 
> If you fix a bug, please do not add 'cleanups'.

Ah sorry.  I thought it would be confusing if we just drop the returned
value when calling tcp_v4_early_demux().

I drop the part in v2 and send it to net-next after net is merged.

Thank you!
