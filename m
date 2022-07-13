Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B40573E50
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbiGMUyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiGMUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:54:33 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D249E0FB
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745668; x=1689281668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d+MpdCOr3ab0vkWqXM1ZMsKzF2B39nFijIh3zzcJ7/o=;
  b=viEmH2Shw6aVxkcJ7EdTo11YIsjY1+/HFLV8MlaI+hNbE+udCLF/7T/Q
   HnAiL2dWhH3MxHsCpwSdKez6kyPBUKCNzw8P9keii5ZDLehPxmbNzWOFt
   5uLWBV7swC5MuZsVutWoJHpMLoJjRq/nkwDSRTgSDhbSNgEczurFGR9VL
   M=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="1033801860"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 13 Jul 2022 20:54:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com (Postfix) with ESMTPS id 57BD9D97D4;
        Wed, 13 Jul 2022 20:54:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:54:24 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:54:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH v1 net 07/15] ip: Fix a data-race around sysctl_fwmark_reflect.
Date:   Wed, 13 Jul 2022 13:51:57 -0700
Message-ID: <20220713205205.15735-8-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_fwmark_reflect, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: e110861f8609 ("net: add a sysctl to reflect the fwmark on replies")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Lorenzo Colitti <lorenzo@google.com>
---
 include/net/ip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 05fe313f72fa..4a15b6bcb4b8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -384,7 +384,7 @@ void ipfrag_init(void);
 void ip_static_sysctl_init(void);
 
 #define IP4_REPLY_MARK(net, mark) \
-	((net)->ipv4.sysctl_fwmark_reflect ? (mark) : 0)
+	(READ_ONCE((net)->ipv4.sysctl_fwmark_reflect) ? (mark) : 0)
 
 static inline bool ip_is_fragment(const struct iphdr *iph)
 {
-- 
2.30.2

