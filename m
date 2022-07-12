Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E48572242
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiGLSPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiGLSPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:15:22 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00599BDB85
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 11:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657649723; x=1689185723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z9mlpdulBq2E9Lu0yOZJBtHOeb/DiDpBWYc8vHjp7iI=;
  b=Q02CO74kqE698Oh3CaTlUhF5qy4yCXbPEOiBBWU3edHWhdR/Ibay/XG6
   97tu+fPnXwJ6wWBaha/6VyXEypSp+V7yuhYHl8Nu+NraASaU/x2w+CVhX
   APAXYlYtfeSbXGtk9B+zXMUvPQBN651OZTVtBpZPn7Z+9jqRK5YtfBl04
   s=;
X-IronPort-AV: E=Sophos;i="5.92,266,1650931200"; 
   d="scan'208";a="220791012"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 Jul 2022 18:15:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id 36D198133C;
        Tue, 12 Jul 2022 18:15:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 18:15:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.144) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 18:15:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <subashab@codeaurora.org>
Subject: Re: [PATCH v2 net] tcp/udp: Make early_demux back namespacified.
Date:   Tue, 12 Jul 2022 11:14:57 -0700
Message-ID: <20220712181457.41424-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+c5yGoVV5t34diRrita=D1X_Aj-+fXJ2pw7jusnKGL3w@mail.gmail.com>
References: <CANn89i+c5yGoVV5t34diRrita=D1X_Aj-+fXJ2pw7jusnKGL3w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D21UWA001.ant.amazon.com (10.43.160.154) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jul 2022 19:51:02 +0200
> On Tue, Jul 12, 2022 at 7:38 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> > it possible to enable/disable early_demux on a per-netns basis.  Then, we
> > introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> > TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> > tcp and udp").  However, the .proc_handler() was wrong and actually
> > disabled us from changing the behaviour in each netns.
> >
> 
> >  static int proc_tfo_blackhole_detect_timeout(struct ctl_table *table,
> >                                              int write, void *buffer,
> >                                              size_t *lenp, loff_t *ppos)
> > @@ -695,14 +640,18 @@ static struct ctl_table ipv4_net_table[] = {
> >                 .data           = &init_net.ipv4.sysctl_udp_early_demux,
> >                 .maxlen         = sizeof(u8),
> >                 .mode           = 0644,
> > -               .proc_handler   = proc_udp_early_demux
> > +               .proc_handler   = proc_dou8vec_minmax,
> > +               .extra1         = SYSCTL_ZERO,
> > +               .extra2         = SYSCTL_ONE,
> 
> This does not belong to this patch.
> 
> It is IMO too late, some users might use:
> 
> echo 2 >/proc/sys/net/ipv4/udp_early_demux

Ok, I will drop these.


> >         },
> >         {
> >                 .procname       = "tcp_early_demux",
> >                 .data           = &init_net.ipv4.sysctl_tcp_early_demux,
> >                 .maxlen         = sizeof(u8),
> >                 .mode           = 0644,
> > -               .proc_handler   = proc_tcp_early_demux
> > +               .proc_handler   = proc_dou8vec_minmax,
> > +               .extra1         = SYSCTL_ZERO,
> > +               .extra2         = SYSCTL_ONE,
> 
> Same here.
> 
> Again, fix the bug, and only the bug. Do not hide 'fixes' in an innocent patch.
> 
> There is a reason for that, we want each commit to have a clear description,
> and we want to be able to revert a patch without having to think about
> what needs
> to be re-written.

Sorry for bothering you.
But this makes my criteria explicit, thank you!
