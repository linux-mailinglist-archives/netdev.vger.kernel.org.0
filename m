Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE23B573E4D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiGMUyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236997AbiGMUyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:54:16 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056BDCD3
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745656; x=1689281656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B7GN+Od/6Xvj8p5d58REL28yY8Rz9nq/rVxHc85KPg8=;
  b=lqMFe5glJ1Cy5O19xuUvclqjyPY4vcg5B1YOG2ZyJOJ1VijbYp1iGGuY
   LYM2p7diSbDimq202EcGQ6mMgj92TDIH661DmKV9YRCh20oWoyBRdYH9v
   /lK5ON0GMNjJ1i6JNCU04l2DZaNjglK2ZQUUfTcpdqDdtpheu8IcSrtmU
   k=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="108048852"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 13 Jul 2022 20:54:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id CBB4C220018;
        Wed, 13 Jul 2022 20:54:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:54:09 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:54:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 06/15] ip: Fix a data-race around sysctl_ip_autobind_reuse.
Date:   Wed, 13 Jul 2022 13:51:56 -0700
Message-ID: <20220713205205.15735-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
References: <20220713205205.15735-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_ip_autobind_reuse, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 4b01a9674231 ("tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 53f5f956d948..2c44556af452 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -263,7 +263,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		goto other_half_scan;
 	}
 
-	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
+	if (READ_ONCE(net->ipv4.sysctl_ip_autobind_reuse) && !relax) {
 		/* We still have a chance to connect to different destinations */
 		relax = true;
 		goto ports_exhausted;
-- 
2.30.2

