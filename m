Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B02F69154A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBJAWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBJAWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:22:20 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E095FE79
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 16:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675988540; x=1707524540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yDIqadD8h5Oay4ASBCEUAZEJImodZ53cPG3qIg1eIz8=;
  b=dLHmtcW9NrobqkdZjOpWBH5VoPYycgJopAJi81FWPV0Jtg/81LWltrgh
   ekvmcW1ENP5L4lr/fAPthDsHNOYKH66ytyag1IPZCVAc298lnW7LFmAVH
   Ci/D6G2B2oBzNS6/X0pzEeh5JMg02h5BSRjtHi8Os+1Jb4WUp5O0D5Aka
   A=;
X-IronPort-AV: E=Sophos;i="5.97,285,1669075200"; 
   d="scan'208";a="297234838"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 00:22:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id E16AD60B9F;
        Fri, 10 Feb 2023 00:22:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 10 Feb 2023 00:22:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Fri, 10 Feb 2023 00:22:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 0/2] sk->sk_forward_alloc fixes.
Date:   Thu, 9 Feb 2023 16:22:00 -0800
Message-ID: <20230210002202.81442-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
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

The first patch fixes a negative sk_forward_alloc by adding
sk_rmem_schedule() before skb_set_owner_r(), and second patch
removes an unnecessary WARN_ON_ONCE().

Changes:
  v3:
    * Factorise a common pattern in Patch 1 as suggested by Eric

  v2: https://lore.kernel.org/netdev/20230209013329.87879-1-kuniyu@amazon.com/
    * Add the first patch

  v1: https://lore.kernel.org/netdev/20230207183718.54520-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
  net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
    sk_stream_kill_queues().

 include/net/sock.h     | 13 +++++++++++++
 net/caif/caif_socket.c |  1 +
 net/core/stream.c      |  1 -
 net/dccp/ipv6.c        |  7 ++-----
 net/ipv6/tcp_ipv6.c    | 10 +++-------
 5 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.30.2

