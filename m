Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6C25ABBE6
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 02:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiICApK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 20:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiICApF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 20:45:05 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2650629CBC
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 17:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662165899; x=1693701899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zor+NTT0TtOSNml6Wya6OQokWSTW78jwFeJxCl0lyEU=;
  b=E3w7G72mGC/L0LakLhJ2UZztyCpk3IuNTmjxclRq+F6VMrAGvk2vRVz6
   /UDyqJhtj3rxzcBtaXslrTSd3s40OozBTAgrW7pbuKElj5vRf0z4VnJV/
   4cvXP0ArEBtxjJ0t8HRTMEzGUc/E7iv/C5wYSaacH9wsUp0YVzRVJE5n+
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,285,1654560000"; 
   d="scan'208";a="1050885113"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 00:44:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 74486453FF;
        Sat,  3 Sep 2022 00:44:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Sat, 3 Sep 2022 00:44:31 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.181) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Sat, 3 Sep 2022 00:44:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuniyu@amazon.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Fri, 2 Sep 2022 17:44:20 -0700
Message-ID: <20220903004420.91740-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901221216.14973-1-kuniyu@amazon.com>
References: <20220901221216.14973-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.181]
X-ClientProxiedBy: EX13D07UWA001.ant.amazon.com (10.43.160.145) To
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

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Thu, 1 Sep 2022 15:12:16 -0700
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Thu, 1 Sep 2022 14:30:43 -0700
> > On Thu, Sep 1, 2022 at 2:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Paolo Abeni <pabeni@redhat.com>
> > 
> > > > /Me is thinking aloud...
> > > >
> > > > I'm wondering if the above has some measurable negative effect for
> > > > large deployments using only the main netns?
> > > >
> > > > Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> > > > >hashinfo already into the working set data for established socket?
> > > > Would the above increase the WSS by 2 cache-lines?
> > >
> > > Currently, the death_row and hashinfo are touched around tw sockets or
> > > connect().  If connections on the deployment are short-lived or frequently
> > > initiated by itself, that would be host and included in WSS.
> > >
> > > If the workload is server and there's no active-close() socket or
> > > connections are long-lived, then it might not be included in WSS.
> > > But I think it's not likely than the former if the deployment is
> > > large enough.
> > >
> > > If this change had large impact, then we could revert fbb8295248e1
> > > which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
> > > that tried to fire a TW timer after netns is freed, but 0dad4087a86a
> > > has already reverted.
> > 
> > 
> > Concern was fast path.
> > 
> > Each incoming packet does a socket lookup.
> > 
> > Fetching hashinfo (instead of &tcp_hashinfo) with a dereference of a
> > field in 'struct net' might inccurr a new cache line miss.
> > 
> > Previously, first cache line of tcp_info was enough to bring a lot of
> > fields in cpu cache.
> 
> Ok, let me test on that if there could be regressions.

I tested tcp_hashinfo vs tcp_death_row->hashinfo with super_netperf
and collected HW cache-related metrics with perf.

After the patch the number of L1 miss seems to increase, but the
instructions per cycle also increases, and cache miss rate did not
change.  Also, there was not performance regression for netperf.


Tested:

# cat perf_super_netperf
echo 0 > /proc/sys/kernel/nmi_watchdog
echo 3 > /proc/sys/vm/drop_caches

perf stat -a \
     -e cycles,instructions,cache-references,cache-misses,bus-cycles \
     -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores \
     -e dTLB-loads,dTLB-load-misses \
     -e LLC-loads,LLC-load-misses,LLC-stores \
     ./super_netperf $(($(nproc) * 2)) -H 10.0.0.142 -l 60 -fM

echo 1 > /proc/sys/kernel/nmi_watchdog


Before:

# ./perf_super_netperf
2929.81

 Performance counter stats for 'system wide':

   494,002,600,338      cycles                                                        (23.07%)
   241,230,662,890      instructions              #    0.49  insn per cycle           (30.76%)
     6,303,603,008      cache-references                                              (38.45%)
     1,421,440,332      cache-misses              #   22.550 % of all cache refs      (46.15%)
     4,861,179,308      bus-cycles                                                    (46.15%)
    65,410,735,599      L1-dcache-loads                                               (46.15%)
    12,647,247,339      L1-dcache-load-misses     #   19.34% of all L1-dcache accesses  (30.77%)
    32,912,656,369      L1-dcache-stores                                              (30.77%)
    66,015,779,361      dTLB-loads                                                    (30.77%)
        81,293,994      dTLB-load-misses          #    0.12% of all dTLB cache accesses  (30.77%)
     2,946,386,949      LLC-loads                                                     (30.77%)
       257,223,942      LLC-load-misses           #    8.73% of all LL-cache accesses  (30.77%)
     1,183,820,461      LLC-stores                                                    (15.38%)

      62.132250590 seconds time elapsed


After:

# ./perf_super_netperf
2930.17

 Performance counter stats for 'system wide':

   479,595,776,631      cycles                                                        (23.07%)
   243,318,957,230      instructions              #    0.51  insn per cycle           (30.76%)
     6,169,892,840      cache-references                                              (38.46%)
     1,381,992,694      cache-misses              #   22.399 % of all cache refs      (46.15%)
     4,534,304,190      bus-cycles                                                    (46.16%)
    66,059,178,377      L1-dcache-loads                                               (46.17%)
    12,759,529,139      L1-dcache-load-misses     #   19.32% of all L1-dcache accesses  (30.78%)
    33,292,513,002      L1-dcache-stores                                              (30.78%)
    66,482,176,008      dTLB-loads                                                    (30.77%)
        72,877,970      dTLB-load-misses          #    0.11% of all dTLB cache accesses  (30.76%)
     2,984,881,101      LLC-loads                                                     (30.76%)
       234,747,930      LLC-load-misses           #    7.86% of all LL-cache accesses  (30.76%)
     1,165,606,022      LLC-stores                                                    (15.38%)

      62.110708964 seconds time elapsed

