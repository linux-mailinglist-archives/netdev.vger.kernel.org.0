Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C15057885F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiGRR23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiGRR2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:28:24 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE242CCAA
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165303; x=1689701303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+NrbVqf+dn3oAKH9avpN5B99FkzUZhsECijihpCuqXg=;
  b=fCyTC8WfzSwrEeTcyhnjMXApjYjuXPpB0HPrYJUbxe0s0xfoXDKyppKu
   UKncUzqVW0PRZ9A8mvFNiVIywZdtFOuCRwlCsbLxJHxI3tK1hoqJgRpbJ
   qHMopPBWkBxasEh8qBa4mhy6/y7ycTCT3wD7LIK4HdaJmazo+ILYUMYvL
   I=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="1035321048"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 18 Jul 2022 17:28:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com (Postfix) with ESMTPS id D24BEA282E;
        Mon, 18 Jul 2022 17:28:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:28:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:28:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Robert Shearman <rshearma@brocade.com>
Subject: [PATCH v1 net 05/15] udp: Fix a data-race around sysctl_udp_l3mdev_accept.
Date:   Mon, 18 Jul 2022 10:26:43 -0700
Message-ID: <20220718172653.22111-6-kuniyu@amazon.com>
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

While reading sysctl_udp_l3mdev_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 63a6fff353d0 ("net: Avoid receiving packets with an l3mdev on unbound UDP sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Robert Shearman <rshearma@brocade.com>
---
 include/net/udp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index bb4c227299cc..8dd4aa1485a6 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -238,7 +238,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_udp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_udp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
-- 
2.30.2

