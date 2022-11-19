Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA26630900
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiKSB61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiKSB57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:57:59 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A393FDEFE;
        Fri, 18 Nov 2022 17:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668822622; x=1700358622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LboCa0BKU7MjtfWSMZn/ryecU+vns7z29tzHwHxxbBY=;
  b=BkgxQWb0tDqLA7FV2+UIW5OfYRyT19+uEE992gHkskRQT7aDHBWLUneu
   rDvLK5XM7pvomV5A4eRR+uMfKktoclpvoFkUBoZU5UH9HskHUqYY4Y0c2
   iVS2Rouj5BS5S7bxV4BbjSivFSWsL9rk/BrHSlQLRKKEJbTtq8M1CLd8R
   c=;
X-IronPort-AV: E=Sophos;i="5.96,175,1665446400"; 
   d="scan'208";a="268449914"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2022 01:50:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id 68EC880FDB;
        Sat, 19 Nov 2022 01:50:18 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 19 Nov 2022 01:50:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sat, 19 Nov 2022 01:50:14 +0000
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
Subject: [PATCH v4 net 2/4] dccp/tcp: Remove NULL check for prev_saddr in inet_bhash2_update_saddr().
Date:   Fri, 18 Nov 2022 17:49:12 -0800
Message-ID: <20221119014914.31792-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221119014914.31792-1-kuniyu@amazon.com>
References: <20221119014914.31792-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D39UWB003.ant.amazon.com (10.43.161.215) To
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
Acked-by: Joanne Koong <joannelkoong@gmail.com>
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

