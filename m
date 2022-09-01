Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730ED5AA2AA
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 00:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiIAWOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 18:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiIAWOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 18:14:01 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C45A00F1
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 15:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662070365; x=1693606365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BRICruXywregLv1LJObqhTeo+xVO738bzsvjBRRc5I0=;
  b=SxDxe3pzVEOPJA3ohEgBqVbkRuozmXhqdum4JmdUoOY44GYK4VDX0aZy
   jEOrBlyk7IGqbw8hhaYuu5iclIYCwf5U3SkE7/cLLi28nxS/HeqpQe8LP
   TySaH9KWVIEVZYKpbiqwhw/UsWSa5zXQIjhOw2/gpLjTl0VlVgdBIMtWf
   0=;
X-IronPort-AV: E=Sophos;i="5.93,281,1654560000"; 
   d="scan'208";a="222771738"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-bbd95331.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 22:12:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-bbd95331.us-east-1.amazon.com (Postfix) with ESMTPS id 00481C1A53;
        Thu,  1 Sep 2022 22:12:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 1 Sep 2022 22:12:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 1 Sep 2022 22:12:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Thu, 1 Sep 2022 15:12:16 -0700
Message-ID: <20220901221216.14973-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ=D8o2kNRf6aL=Pa=V6m_fOr6bPBY67yjXFgwTCEAHag@mail.gmail.com>
References: <CANn89iJ=D8o2kNRf6aL=Pa=V6m_fOr6bPBY67yjXFgwTCEAHag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D08UWC001.ant.amazon.com (10.43.162.110) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Sep 2022 14:30:43 -0700
> On Thu, Sep 1, 2022 at 2:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Paolo Abeni <pabeni@redhat.com>
> 
> > > /Me is thinking aloud...
> > >
> > > I'm wondering if the above has some measurable negative effect for
> > > large deployments using only the main netns?
> > >
> > > Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> > > >hashinfo already into the working set data for established socket?
> > > Would the above increase the WSS by 2 cache-lines?
> >
> > Currently, the death_row and hashinfo are touched around tw sockets or
> > connect().  If connections on the deployment are short-lived or frequently
> > initiated by itself, that would be host and included in WSS.
> >
> > If the workload is server and there's no active-close() socket or
> > connections are long-lived, then it might not be included in WSS.
> > But I think it's not likely than the former if the deployment is
> > large enough.
> >
> > If this change had large impact, then we could revert fbb8295248e1
> > which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
> > that tried to fire a TW timer after netns is freed, but 0dad4087a86a
> > has already reverted.
> 
> 
> Concern was fast path.
> 
> Each incoming packet does a socket lookup.
> 
> Fetching hashinfo (instead of &tcp_hashinfo) with a dereference of a
> field in 'struct net' might inccurr a new cache line miss.
> 
> Previously, first cache line of tcp_info was enough to bring a lot of
> fields in cpu cache.

Ok, let me test on that if there could be regressions.
