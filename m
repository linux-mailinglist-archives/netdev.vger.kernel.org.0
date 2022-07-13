Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27097573E4B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbiGMUyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237416AbiGMUyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:54:15 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FFABB6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745655; x=1689281655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t1rWcVL6N2wsLTDWGevSMkPhml/AaaCi4Mr1fbJEwPY=;
  b=tKT+qPJizf/C5tT/eVkEZG8DMnCTF+ELvODmeZ+3WU5UHGXLpNl6SNEn
   2/aXdMArxXiipsUKSfhFEN1XUmdroAo1XZGfxqfX8WNkV4F9Tf+zM4nOi
   L48JifuLd+d9XUfVrO2FXxjicp0mQRmWwRaRcc/iY6iYMEDBDLLXw+cv3
   0=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="108048781"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 13 Jul 2022 20:53:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 93A80340039;
        Wed, 13 Jul 2022 20:53:55 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:53:54 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:53:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 05/15] ip: Fix data-races around sysctl_ip_nonlocal_bind.
Date:   Wed, 13 Jul 2022 13:51:55 -0700
Message-ID: <20220713205205.15735-6-kuniyu@amazon.com>
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

While reading sysctl_ip_nonlocal_bind, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_sock.h | 2 +-
 net/sctp/protocol.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index daead5fb389a..68d337775564 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -374,7 +374,7 @@ static inline bool inet_get_convert_csum(struct sock *sk)
 static inline bool inet_can_nonlocal_bind(struct net *net,
 					  struct inet_sock *inet)
 {
-	return net->ipv4.sysctl_ip_nonlocal_bind ||
+	return READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind) ||
 		inet->freebind || inet->transparent;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 35928fefae33..1a094b087d88 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -358,7 +358,7 @@ static int sctp_v4_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (addr->v4.sin_addr.s_addr != htonl(INADDR_ANY) &&
 	   ret != RTN_LOCAL &&
 	   !sp->inet.freebind &&
-	   !net->ipv4.sysctl_ip_nonlocal_bind)
+	    !READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind))
 		return 0;
 
 	if (ipv6_only_sock(sctp_opt2sk(sp)))
-- 
2.30.2

