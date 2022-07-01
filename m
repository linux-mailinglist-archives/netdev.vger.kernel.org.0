Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0F756384A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiGAQvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbiGAQvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:51:08 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AB044A0F
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656694267; x=1688230267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tfj3iGiIsWe7DKnvvvYFy455A0ToOsY6ZWgQoFdSE3M=;
  b=odRhUf1PcGYAzt+zE+/y99l6H6iwjfLPMW4K4W07fUIGH6dmykmmb6RR
   S3WwBApQzuZvi6SXOu1gK1ZgNaU1ny+GlD0CowVdcs+M95C8aVWORzmUm
   ethT+oB7qpnzqWukVPAefLgpPySPpk7X11p1fFqgpDB8tD24LvFt5OC/V
   E=;
X-IronPort-AV: E=Sophos;i="5.92,237,1650931200"; 
   d="scan'208";a="217291790"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 01 Jul 2022 16:50:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com (Postfix) with ESMTPS id 34AA1817B7;
        Fri,  1 Jul 2022 16:50:49 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 1 Jul 2022 16:50:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.157) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 1 Jul 2022 16:50:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <cdleonard@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <sachinp@linux.ibm.com>
Subject: Re: [PATCH v1 net-next] af_unix: Put a named socket in the global hash table.
Date:   Fri, 1 Jul 2022 09:50:39 -0700
Message-ID: <20220701165039.96869-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iKk65P3FDiR0sfGuJdgeE53dCADi6WwiCLsEYF+ttHRdg@mail.gmail.com>
References: <CANn89iKk65P3FDiR0sfGuJdgeE53dCADi6WwiCLsEYF+ttHRdg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.157]
X-ClientProxiedBy: EX13D17UWC002.ant.amazon.com (10.43.162.61) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 Jul 2022 18:36:21 +0200
> On Fri, Jul 1, 2022 at 9:25 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Commit cf2f225e2653 ("af_unix: Put a socket into a per-netns hash
> > table.") accidentally broke user API for named sockets.  A named
> > socket was able to connect() to a peer in the same mount namespace
> > even if they were in different network namespaces.
> >
> > The commit put all sockets into each per-netns hash table.  As a
> > result, connect() to a socket in a different netns failed to find
> > the peer and returned -ECONNREFUSED even when they had the same
> > mount namespace.
> >
> > We can reproduce this issue by
> >
> >   Console A:
> >
> >     # python3
> >     >>> from socket import *
> >     >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
> >     >>> s.bind('test')
> >     >>> s.listen(32)
> >
> >   Console B:
> >
> >     # ip netns add test
> >     # ip netns exec test sh
> >     # python3
> >     >>> from socket import *
> >     >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
> >     >>> s.connect('test')
> >
> 
> I think this deserves a new test perhaps...

Exactly.  I will add a selftest in v2.
Thank you.
