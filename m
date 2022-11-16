Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D728462CDA7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiKPW3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiKPW3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:29:11 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05EB4C258;
        Wed, 16 Nov 2022 14:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668637750; x=1700173750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gRqNdVknBq+lykAvvBXxknFXC8VOBJuyRBEFgaHueX4=;
  b=G7LWuwzPNJqY2RrPvLCB7a/W5ikZZKfvjhqGx6Tlj5Ox5qOL7baUiVjl
   Tfx457vey1rfV403NrScHHyYEoBXsHXzj13dBMFw9CoaOGZykAiRHiq+U
   fTgVAKRO7/yWp1qGvEIw3ZlmvthcK43BnBLaZ9FyxCeJNg56+lBHZ4CTO
   c=;
X-IronPort-AV: E=Sophos;i="5.96,169,1665446400"; 
   d="scan'208";a="151530680"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 22:29:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 9329E81D24;
        Wed, 16 Nov 2022 22:29:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 16 Nov 2022 22:29:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 16 Nov 2022 22:29:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH v2 net 2/4] dccp/tcp: Remove NULL check for prev_saddr in inet_bhash2_update_saddr().
Date:   Wed, 16 Nov 2022 14:28:03 -0800
Message-ID: <20221116222805.64734-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116222805.64734-1-kuniyu@amazon.com>
References: <20221116222805.64734-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D44UWB003.ant.amazon.com (10.43.161.52) To
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

When we call inet_bhash2_update_saddr(), prev_saddr is always non-NULL.
Let's remove the unnecessary test.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inet_hashtables.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 033bf3c2538f..d745f962745e 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -877,13 +877,10 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
 
 	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
 
-	if (prev_saddr) {
-		spin_lock_bh(&prev_saddr->lock);
-		__sk_del_bind2_node(sk);
-		inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
-					  inet_csk(sk)->icsk_bind2_hash);
-		spin_unlock_bh(&prev_saddr->lock);
-	}
+	spin_lock_bh(&prev_saddr->lock);
+	__sk_del_bind2_node(sk);
+	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
+	spin_unlock_bh(&prev_saddr->lock);
 
 	spin_lock_bh(&head2->lock);
 	tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
-- 
2.30.2

