Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3495A2CC9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344753AbiHZQwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344844AbiHZQwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:52:13 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8311D13E;
        Fri, 26 Aug 2022 09:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661532732; x=1693068732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AifsETKjVBdEZkARs4pnvbl9WN6FK2d6+rJgAQDuJSk=;
  b=Ha9Df+Ostym8xtBZQXMN72P6nk9FIUTj6dBQhghr0AiBKH5Iy2Oo2sqY
   ifGa8XG312vg+7lPuK3iBjs408VIqfjgQQKkZ4/xoHVE4UP93bDqkiUu1
   i9s+VMSZ+jxSFWVeX0A7qHIdxO454bjtjwvviuL8bTqE8GroVac4Nisn3
   A=;
X-IronPort-AV: E=Sophos;i="5.93,265,1654560000"; 
   d="scan'208";a="234474557"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 16:51:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com (Postfix) with ESMTPS id A372BC0326;
        Fri, 26 Aug 2022 16:51:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 16:51:55 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.228) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 16:51:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <jlayton@kernel.org>, <keescook@chromium.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-fsdevel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net-next 00/13] tcp/udp: Introduce optional per-netns hash table.
Date:   Fri, 26 Aug 2022 09:51:44 -0700
Message-ID: <20220826165144.95976-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+pfVeH0Gs4tFPcZstnfxjz-Vp2D86H5AQsdsR_+p_3qQ@mail.gmail.com>
References: <CANn89i+pfVeH0Gs4tFPcZstnfxjz-Vp2D86H5AQsdsR_+p_3qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.228]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:17:25 -0700
> On Thu, Aug 25, 2022 at 5:05 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > The more sockets we have in the hash table, the more time we spend
> > looking up the socket.  While running a number of small workloads on
> > the same host, they penalise each other and cause performance degradation.
> >
> > Also, the root cause might be a single workload that consumes much more
> > resources than the others.  It often happens on a cloud service where
> > different workloads share the same computing resource.
> >
> > On EC2 c5.24xlarge instance (196 GiB memory and 524288 (1Mi / 2) ehash
> > entries), after running iperf3 in different netns, creating 24Mi sockets
> > without data transfer in the root netns causes about 10% performance
> > regression for the iperf3's connection.
> >
> >  thash_entries          sockets         length          Gbps
> >         524288                1              1          50.7
> >                            24Mi             48          45.1
> >
> > It is basically related to the length of the list of each hash bucket.
> > For testing purposes to see how performance drops along the length,
> > I set 131072 (1Mi / 8) to thash_entries, and here's the result.
> >
> >  thash_entries          sockets         length          Gbps
> >         131072                1              1          50.7
> >                             1Mi              8          49.9
> >                             2Mi             16          48.9
> >                             4Mi             32          47.3
> >                             8Mi             64          44.6
> >                            16Mi            128          40.6
> >                            24Mi            192          36.3
> >                            32Mi            256          32.5
> >                            40Mi            320          27.0
> >                            48Mi            384          25.0
> >
> > To resolve the socket lookup degradation, we introduce an optional
> > per-netns hash table for TCP and UDP.  With a smaller hash table, we
> > can look up sockets faster and isolate noisy neighbours.  Also, we can
> > reduce lock contention.
> >
> > We can control and check the hash size via sysctl knobs.  It requires
> > some tuning based on workloads, so the per-netns hash table is disabled
> > by default.
> >
> >   # dmesg | cut -d ' ' -f 5- | grep "established hash"
> >   TCP established hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
> >
> >   # sysctl net.ipv4.tcp_ehash_entries
> >   net.ipv4.tcp_ehash_entries = 524288  # can be changed by thash_entries
> >
> >   # sysctl net.ipv4.tcp_child_ehash_entries
> >   net.ipv4.tcp_child_ehash_entries = 0  # disabled by default
> >
> >   # ip netns add test1
> >   # ip netns exec test1 sysctl net.ipv4.tcp_ehash_entries
> >   net.ipv4.tcp_ehash_entries = -524288  # share the global ehash
> >
> >   # sysctl -w net.ipv4.tcp_child_ehash_entries=100
> >   net.ipv4.tcp_child_ehash_entries = 100
> >
> >   # sysctl net.ipv4.tcp_child_ehash_entries
> >   net.ipv4.tcp_child_ehash_entries = 128  # rounded up to 2^n
> >
> >   # ip netns add test2
> >   # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
> >   net.ipv4.tcp_ehash_entries = 128  # own per-netns ehash
> >
> >   [ UDP has the same interface as udp_hash_entries and
> >     udp_child_hash_entries. ]
> >
> > When creating per-netns concurrently with different sizes, we can
> > guarantee the size by doing one of these ways.
> >
> >   1) Share the global hash table and create per-netns one
> >
> >   First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
> >   netns sysctl knobs where we can safely change tcp_child_ehash_entries
> >   and clone()/unshare() to create a per-netns hash table.
> >
> >   2) Lock the sysctl knob
> >
> 
> This is orthogonal.
> 
> Your series should have been split in three really.
> 
> I do not want to discuss the merit of re-instating LOCK_MAND :/

I see.
I'll drop the flock() part at once and respin TCP part only in v2.
