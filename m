Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E806B6306
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 04:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCLDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 22:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCLDUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 22:20:10 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD264393F
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 19:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678591204; x=1710127204;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g8KOocNCCYlxIAZAI8Jd0agmpbKSLceEogSaA3W8lXM=;
  b=doMRnWZj3SzGP0KbsDg6Eepd76RkeiMfg1gM67zgh5V8pNPL3eKkOwHo
   SOu/+K4oLfssgiOQI7JS8x19sUjBIWRzZh0l0YlSUZnmjB3yEQAQVbeQc
   Y6hF8L8h/FvcRDTnfdVTaIuljP93fVclYUES4sGR9JgsbpuKIMZ6hR9ME
   w=;
X-IronPort-AV: E=Sophos;i="5.98,253,1673913600"; 
   d="scan'208";a="1111726775"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 03:19:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 913D640DCA;
        Sun, 12 Mar 2023 03:19:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sun, 12 Mar 2023 03:19:58 +0000
Received: from 88665a182662.ant.amazon.com (10.119.80.90) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Sun, 12 Mar 2023 03:19:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Paul Holzinger <pholzing@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for dual-stack wildcard address.
Date:   Sat, 11 Mar 2023 19:19:03 -0800
Message-ID: <20230312031904.4674-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230312031904.4674-1-kuniyu@amazon.com>
References: <20230312031904.4674-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.80.90]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
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

Paul Holzinger reported [0] that commit 5456262d2baa ("net: Fix
incorrect address comparison when searching for a bind2 bucket")
introduced a bind() regression.  Paul also gave a nice repro that
calls two types of bind() on the same port, both of which now
succeed, but the second call should fail:

  bind(fd1, ::, port) + bind(fd2, 127.0.0.1, port)

The cited commit added address family tests in three functions to
fix the uninit-value KMSAN report. [1]  However, the test added to
inet_bind2_bucket_match_addr_any() removed a necessary conflict
check; the dual-stack wildcard address no longer conflicts with
an IPv4 non-wildcard address.

If tb->family is AF_INET6 and sk->sk_family is AF_INET in
inet_bind2_bucket_match_addr_any(), we still need to check
if tb has the dual-stack wildcard address.

Note that the IPv4 wildcard address does not conflict with
IPv6 non-wildcard addresses.

[0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
[1]: https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/

Fixes: 5456262d2baa ("net: Fix incorrect address comparison when searching for a bind2 bucket")
Reported-by: Paul Holzinger <pholzing@redhat.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
Cc: Martin KaFai Lau <martin.lau@kernel.org>
---
Some cleanup patches will be posted against net-next later:

  * s/addr_any/in6addr_any/
  * Remove duplicated tests for net, port, and l3mdev.
---
 net/ipv4/inet_hashtables.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e41fdc38ce19..6edae3886885 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -828,8 +828,14 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any = {};
 
-	if (sk->sk_family != tb->family)
+	if (sk->sk_family != tb->family) {
+		if (sk->sk_family == AF_INET)
+			return net_eq(ib2_net(tb), net) && tb->port == port &&
+				tb->l3mdev == l3mdev &&
+				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
+
 		return false;
+	}
 
 	if (sk->sk_family == AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port == port &&
-- 
2.30.2

