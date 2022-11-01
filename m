Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DB8615234
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiKATWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiKATWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:22:30 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420471EAF0
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 12:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667330549; x=1698866549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TuRuTKaZ1Ug7pjZlrtvnGhujcqqgkFxz346q9lSt/XU=;
  b=T45pLQeOkuEmQ/956wAdBpChmqMjfIfDmkOqDWpFzM+KlfxjQsR7lTUP
   Lx9ZSD7FecWNIA1KVo+oSqsjs1DRfS+GteLVW41kuKvrHprt0LvTiEcOx
   URXk5O8dzOFMBmBDbzVTJHdehAAxCYmnAZt9FE1c5kDRvdAwL77nQ61M4
   A=;
X-IronPort-AV: E=Sophos;i="5.95,231,1661817600"; 
   d="scan'208";a="146547919"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 19:22:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com (Postfix) with ESMTPS id 0876481FEE;
        Tue,  1 Nov 2022 19:22:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 1 Nov 2022 19:22:21 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 1 Nov 2022 19:22:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <william.xuanziyang@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <joannelkoong@gmail.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <martin.lau@kernel.org>,
        <mathew.j.martineau@linux.intel.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
Date:   Tue, 1 Nov 2022 12:22:11 -0700
Message-ID: <20221101192211.33498-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <4bd122d2-d606-b71e-dbe7-63fa293f0a73@huawei.com>
References: <4bd122d2-d606-b71e-dbe7-63fa293f0a73@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D22UWC004.ant.amazon.com (10.43.162.198) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Date:   Tue, 1 Nov 2022 15:08:15 +0800
> Hello Kuniyuki Iwashima,
> 
> > Hi,
> > 
> > I want to discuss bhash2 and WARN_ON() being fired every day this month
> > on my syzkaller instance without repro.
> > 
> >   WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> >   ...
> >   inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
> >   inet_listen (net/ipv4/af_inet.c:228)
> >   __sys_listen (net/socket.c:1810)
> >   __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
> >   do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> >   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> > 
> > For the very first implementation of bhash2, there was a similar report
> > hitting the same WARN_ON().  The fix was to update the bhash2 bucket when
> > the kernel changes sk->sk_rcv_saddr from INADDR_ANY.  Then, syzbot has a
> > repro, so we can indeed confirm that it no longer triggers the warning on
> > the latest kernel.
> > 
> >   https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
> > 
> > However, Mat reported at that time that there were at least two variants,
> > the latter being the same as mine.
> > 
> >   https://lore.kernel.org/netdev/4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com/
> >   https://lore.kernel.org/netdev/23d8e9f4-016-7de1-9737-12c3146872ca@linux.intel.com/
> > 
> > This week I started looking into this issue and finally figured out
> > why we could not catch all cases with a single repro.
> > 
> 
> Provide another C repro for analysis. See the attachment.

Thanks for another variant.

Your repro also fails to connect() by RST, which resets saddr without
updating bhash2 bucket, and then listen() hits the WARN_ON().

I meant to say if there was no difference in failure paths we should
have caught all places where we need fixes with a single repro.

Once we know the root cause, it's not so hard to generate variants.

Anyway, I'll post a patch for consistent error handling and later
another patch to fix the root cause when I find a solid way.
