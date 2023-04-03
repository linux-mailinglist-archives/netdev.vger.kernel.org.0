Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496EF6D518E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDCTun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjDCTul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:50:41 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7FF3586
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680551438; x=1712087438;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J+KymxwEJm2nGMtJk36D3KLcbq1KrYbrf58C7OGJos4=;
  b=H6sVjQVsqYlgK8wLxzGzwrebZ9vdOtPK8ZG0o3bQ/V6+0X4bHpLJ60kk
   rNjOsMOr98BZHIloV8bHb34ukOxDBf0mxfzXmzga1nnk0ILEwwWyc9xEg
   xCHn4OWh1llOnQ2DkQ1J4wB6rD8J/eUI0v8aynTTjcX48Dw5FtdZCrRVQ
   8=;
X-IronPort-AV: E=Sophos;i="5.98,315,1673913600"; 
   d="scan'208";a="1119087795"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:50:30 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 2DE9EA525D;
        Mon,  3 Apr 2023 19:50:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 3 Apr 2023 19:50:27 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.23) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 3 Apr 2023 19:50:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 0/2] raw/ping: Fix locking in /proc/net/{raw,icmp}.
Date:   Mon, 3 Apr 2023 12:49:57 -0700
Message-ID: <20230403194959.48928-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.23]
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
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

The first patch fixes a NULL deref for /proc/net/raw and second one fixes
the same issue for ping sockets.

The first patch also converts hlist_nulls to hlist, but this is because
the current code uses sk_nulls_for_each() for lockless readers, instead
of sk_nulls_for_each_rcu() which adds memory barrier, but raw sockets
does not use the nulls marker nor SLAB_TYPESAFE_BY_RCU in the first place.

OTOH, the ping sockets already uses sk_nulls_for_each_rcu(), and such
conversion can be posted later for net-next.


Kuniyuki Iwashima (2):
  raw: Fix NULL deref in raw_get_next().
  ping: Fix potentail NULL deref for /proc/net/icmp.

 include/net/raw.h   |  4 ++--
 net/ipv4/ping.c     |  8 ++++----
 net/ipv4/raw.c      | 36 +++++++++++++++++++-----------------
 net/ipv4/raw_diag.c | 10 ++++------
 net/ipv6/raw.c      | 10 ++++------
 5 files changed, 33 insertions(+), 35 deletions(-)

-- 
2.30.2

