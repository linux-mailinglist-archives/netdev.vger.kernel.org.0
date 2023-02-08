Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9435B68E531
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBHBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 20:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBHBBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 20:01:52 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918B17EF6
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 17:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675818111; x=1707354111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mp2L0ELl5mM2NGT0izHQ10Jnul+4DWJrYU3Y+J1HLdY=;
  b=mZLzzo32TbFgUedrJnOaPhiwbuiCCPOOeWlFBTgJFtuENDKsdLbhI5aO
   yOdOG1t6911ei6QCkYpPm2wP82gdAmLIfdOv2KmILBLWoci7XZYkbsxWn
   cKo5RbkZJ9gLkFSw2UpcJG7XUaWBWP9/jPnY8nJe3WvTrQGccMIIWP8U8
   s=;
X-IronPort-AV: E=Sophos;i="5.97,279,1669075200"; 
   d="scan'208";a="179503306"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 01:01:48 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id B75414139B;
        Wed,  8 Feb 2023 01:01:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 8 Feb 2023 01:01:46 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Wed, 8 Feb 2023 01:01:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuniyu@amazon.com>
CC:     <christophpaasch@icloud.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <matthieu.baerts@tessares.net>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 net] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
Date:   Tue, 7 Feb 2023 17:01:35 -0800
Message-ID: <20230208010135.84591-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230208003713.83105-1-kuniyu@amazon.com>
References: <20230208003713.83105-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Tue, 7 Feb 2023 16:37:13 -0800
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Tue, 7 Feb 2023 20:25:19 +0100
> > On Tue, Feb 7, 2023 at 7:37 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > In commit b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in
> > > sk->sk_prot->destroy()."), we delay freeing some IPv6 resources
> > > from sk->destroy() to sk->sk_destruct().
> > >
> > > Christoph Paasch reported the commit started triggering
> > > WARN_ON_ONCE(sk->sk_forward_alloc) in sk_stream_kill_queues()
> > > (See [0 - 2]).
> > >
> > > For example, if inet6_sk(sk)->rxopt is not zero by setting
> > > IPV6_RECVPKTINFO or its friends, tcp_v6_do_rcv() clones a skb
> > > and calls skb_set_owner_r(), which charges it to sk.
> > 
> > skb_set_owner_r() in this place seems wrong.
> > This could lead to a negative sk->sk_forward_alloc
> > (because we have not sk_rmem_schedule() it ?)
> > 
> > Do you have a repro ?
> 
> I created a repro and confirmed sk->sk_forward_alloc was always positive.

This was just before sk_stream_kill_queues(), and actually
sk->sk_forward_alloc was able to be negative by the
skb_set_owner_r() as you thought.

I'll fix this, thank you!
