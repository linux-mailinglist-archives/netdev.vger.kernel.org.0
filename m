Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A178B60533E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiJSWhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiJSWhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:37:23 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A7C18148D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666219044; x=1697755044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PCQgcrrE/Z8HWZMAZqdL6ug8wNDcFN51aVHn98akOXw=;
  b=PKpfzMmYFqipURUWp5bZMsmKr9MsHEe5zshB+rvLZcqmB4s5mBjMUXEi
   gtyn4bQxVyt5ngi99gcvLvRoEy1fUplLWzfAp/Zzm5fpSj4R9bNq5dxgY
   uLG5A77No5HHdwX88hxp1OjPDoHSHXPZNGdKHmpLKrjyivZLi75/ZogBh
   w=;
X-IronPort-AV: E=Sophos;i="5.95,196,1661817600"; 
   d="scan'208";a="253918658"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 22:37:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id E5967A2A58;
        Wed, 19 Oct 2022 22:37:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 22:37:20 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.213) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 22:37:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 4/5] inet6: Remove inet6_destroy_sock().
Date:   Wed, 19 Oct 2022 15:36:02 -0700
Message-ID: <20221019223603.22991-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019223603.22991-1-kuniyu@amazon.com>
References: <20221019223603.22991-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last user of inet6_destroy_sock() is its wrapper inet6_cleanup_sock().
Let's rename inet6_destroy_sock() to inet6_cleanup_sock().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/transp_v6.h | 2 --
 net/ipv6/af_inet6.c     | 8 +-------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index b830463e3dff..d27b1caf3753 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -58,8 +58,6 @@ ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp, __u16 srcp,
 
 #define LOOPBACK4_IPV6 cpu_to_be32(0x7f000006)
 
-void inet6_destroy_sock(struct sock *sk);
-
 #define IPV6_SEQ_DGRAM_HEADER					       \
 	"  sl  "						       \
 	"local_address                         "		       \
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 6540551ea7ec..68075295d587 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -490,7 +490,7 @@ int inet6_release(struct socket *sock)
 }
 EXPORT_SYMBOL(inet6_release);
 
-void inet6_destroy_sock(struct sock *sk)
+void inet6_cleanup_sock(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sk_buff *skb;
@@ -515,12 +515,6 @@ void inet6_destroy_sock(struct sock *sk)
 		txopt_put(opt);
 	}
 }
-EXPORT_SYMBOL_GPL(inet6_destroy_sock);
-
-void inet6_cleanup_sock(struct sock *sk)
-{
-	inet6_destroy_sock(sk);
-}
 EXPORT_SYMBOL_GPL(inet6_cleanup_sock);
 
 /*
-- 
2.30.2

