Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7746578873
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbiGRRag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiGRRae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:30:34 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FA4B1D4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165434; x=1689701434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LeyEVnno+/O97nfxoCn24g1tfjOASowa3QtrVKzNhuc=;
  b=pAA7GrCyvl7jAsjvJwCgDo0BypItljs5mELaTaazj5x9DO0RCDG2hYXL
   C94uhsEHS2rUIn6/xFFZIXEz1vqNK8ExMlnS8Yk104V5ZObgcMJCueZ2E
   VF1BYlynTdXGPFM9ag49Xz75FwahEVebjdBQm3fLilyud5h+h/rEwqLfZ
   8=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="210954547"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 18 Jul 2022 17:30:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id 1B65999320;
        Mon, 18 Jul 2022 17:30:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:30:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:30:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 13/15] tcp: Fix a data-race around sysctl_tcp_rfc1337.
Date:   Mon, 18 Jul 2022 10:26:51 -0700
Message-ID: <20220718172653.22111-14-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718172653.22111-1-kuniyu@amazon.com>
References: <20220718172653.22111-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D04UWA004.ant.amazon.com (10.43.160.234) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_rfc1337, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6854bb1fb32b..700ea548d125 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -173,7 +173,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			 * Oh well... nobody has a sufficient solution to this
 			 * protocol bug yet.
 			 */
-			if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
+			if (!READ_ONCE(twsk_net(tw)->ipv4.sysctl_tcp_rfc1337)) {
 kill:
 				inet_twsk_deschedule_put(tw);
 				return TCP_TW_SUCCESS;
-- 
2.30.2

