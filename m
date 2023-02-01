Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64414686E50
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjBASne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBASnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:43:32 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347656FD3E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675277012; x=1706813012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yfFYIvMj/uHhMhsTjWJv0ictWp2DY8h5DYfFnW9v/o4=;
  b=gqzBtPVv0McIrOhK6lIM9TAQWE+XniElwr0SDgEiQQ4hqVz51FWr5UKV
   eGgg4c9txkc3zYi66DFXdX5lr3z54IowY1ASosXlR+ssZSGjTKquf55PH
   xwKg4aXCszv+4PInjyN8ghACTPbsYYGLuQ/VnjwJRdlouzcKPyt3wu9Xr
   k=;
X-IronPort-AV: E=Sophos;i="5.97,265,1669075200"; 
   d="scan'208";a="288658004"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 18:43:29 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 84B9E4115F;
        Wed,  1 Feb 2023 18:43:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 1 Feb 2023 18:43:26 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Wed, 1 Feb 2023 18:43:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <christophpaasch@icloud.com>
CC:     <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
        <notifications@github.com>, <pabeni@redhat.com>
Subject: Re: WARNING in sk_stream_kill_queues due to inet6_destroy_sock()-changes
Date:   Wed, 1 Feb 2023 10:43:16 -0800
Message-ID: <20230201184316.17991-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <39725AB4-88F1-41B3-B07F-949C5CAEFF4F@icloud.com>
References: <39725AB4-88F1-41B3-B07F-949C5CAEFF4F@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D42UWB003.ant.amazon.com (10.43.161.45) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Christoph Paasch <christophpaasch@icloud.com>
Date:   Wed, 1 Feb 2023 10:22:42 -0800
> Hello,
> 
> I am running a syzkaller instance and hit an issue where sk_forward_alloc is not 0 in sk_stream_kill_queues().
> 
> I bisected this issue down to the set of changes from the "inet6: Remove inet6_destroy_sock() calls”-series (see below for the commit hashes).
> 
> The reproducer is:
> Reproducer:
> # {Threaded:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false Wifi:false IEEE802154:false Sysctl:false UseTmpDir:false HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false Fault:false FaultCall:0 FaultNth:0}}
> r0 = socket$inet6_tcp(0xa, 0x1, 0x0)
> bind$inet6(r0, &(0x7f00000002c0)={0xa, 0x4e22, 0x0, @loopback}, 0x1c)
> setsockopt$inet6_IPV6_HOPOPTS(r0, 0x29, 0x36, &(0x7f0000000080), 0x8)
> setsockopt$inet6_int(r0, 0x29, 0x35, &(0x7f0000000040)=0x8, 0x4)
> sendmsg$inet6(r0, &(0x7f00000003c0)={&(0x7f0000000000)={0xa, 0x4e22, 0x0, @loopback}, 0x1c, 0x0}, 0x200880c0)
> 
> What ends up happening is that np->pktoptions is not emptied thus the skb’s that have been added there are still accounted in sk_forward_alloc.
> 
> 
> I’m not sure what would be the best way to fix this, besides a plain revert of this patchset as sk_stream_kill_queues() does rely on the things to have been free’d.
> 
> 
> More information on the syzkaller issue can be found at https://github.com/multipath-tcp/mptcp_net-next/issues/341.

Thanks for bisecting and reporting!

I missed that WARN_ON_ONCE(), I'll post a fix.

Thank you,
Kuniyuki


> 
> Cheers,
> Christoph
> 
> 
> b45a337f061e ("inet6: Clean up failure path in do_ipv6_setsockopt().")  (3 months ago) <Kuniyuki Iwashima>
> 1f8c4eeb9455 ("inet6: Remove inet6_destroy_sock().")  (3 months ago) <Kuniyuki Iwashima>
> 6431b0f6ff16 ("sctp: Call inet6_destroy_sock() via sk->sk_destruct().")  (3 months ago) <Kuniyuki Iwashima>
> 1651951ebea5 ("dccp: Call inet6_destroy_sock() via sk->sk_destruct().")  (3 months ago) <Kuniyuki Iwashima>
> b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().")  (3 months ago) <Kuniyuki Iwashima>
