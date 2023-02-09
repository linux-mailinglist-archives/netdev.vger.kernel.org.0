Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96E68FCA7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjBIBd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBIBdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:33:54 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D256A10F9
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 17:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675906434; x=1707442434;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yLPPMVaMIWAcBJLdeqBoto2f1RtOD9Xc7CxPus2HrSg=;
  b=bGYJckCq+yQNGOZWoDqlD6bfsqKdu1O2gjke5d8r5kEWvl7Qajk05Q1J
   jG/9Lq3ACu1DJ/sz0MHzgtXLuohzRMWPklaiTgjEr0X+vXNd4ccibs4JA
   g8thqlm0LIgAc4IA8xX750YCgD7Mu418zeuSZNYCeeau4aPARCue/+mml
   g=;
X-IronPort-AV: E=Sophos;i="5.97,281,1669075200"; 
   d="scan'208";a="296820833"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 01:33:51 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id 234C8A1372;
        Thu,  9 Feb 2023 01:33:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 9 Feb 2023 01:33:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Thu, 9 Feb 2023 01:33:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net 0/2] sk->sk_forward_alloc fixes.
Date:   Wed, 8 Feb 2023 17:33:27 -0800
Message-ID: <20230209013329.87879-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D39UWA004.ant.amazon.com (10.43.160.73) To
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
  v2:
    * Add the first patch

  v1: https://lore.kernel.org/netdev/20230207183718.54520-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
  net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
    sk_stream_kill_queues().

 net/caif/caif_socket.c |  1 +
 net/core/stream.c      |  1 -
 net/dccp/ipv6.c        | 23 +++++++++++++++++++----
 net/ipv6/tcp_ipv6.c    | 22 ++++++++++++++++++----
 4 files changed, 38 insertions(+), 9 deletions(-)

-- 
2.30.2

