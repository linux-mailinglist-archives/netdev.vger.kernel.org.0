Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568DA6D5195
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDCTv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjDCTv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:51:26 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4B730EF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680551485; x=1712087485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kocd7xbyiwQ9rn19px97FmYrfDQ6RScrg+xC5vfGd8c=;
  b=uJO5DNcVKgK0/3/1zk/WqIQU7I8wb6r02RzSgFvX7xXlQyTY6Ov0TSUs
   ajWCjqHJCHRuiXW1L6rLOvkLtts7e5eDHEjJrM/UQ/B1hJ4NC1Nbb4h2G
   6yqwgp0e9hesvNpqZzREDU+9yysjQ4S5P+UV8jYpWAl3TU/XWDEaxjDSK
   w=;
X-IronPort-AV: E=Sophos;i="5.98,315,1673913600"; 
   d="scan'208";a="274424905"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 19:51:19 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com (Postfix) with ESMTPS id D4D818344C;
        Mon,  3 Apr 2023 19:51:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 3 Apr 2023 19:51:17 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.23) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 3 Apr 2023 19:51:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 2/2] ping: Fix potentail NULL deref for /proc/net/icmp.
Date:   Mon, 3 Apr 2023 12:49:59 -0700
Message-ID: <20230403194959.48928-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230403194959.48928-1-kuniyu@amazon.com>
References: <20230403194959.48928-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.23]
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit dbca1596bbb0 ("ping: convert to RCU lookups, get rid
of rwlock"), we use RCU for ping sockets, but we should use spinlock
for /proc/net/icmp to avoid a potential NULL deref mentioned in
the previous patch.

Let's go back to using spinlock there.

Note we can convert ping sockets to use hlist instead of hlist_nulls
because we do not use SLAB_TYPESAFE_BY_RCU for ping sockets.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/ping.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 409ec2a1f95b..5178a3f3cb53 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1089,13 +1089,13 @@ static struct sock *ping_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *ping_seq_start(struct seq_file *seq, loff_t *pos, sa_family_t family)
-	__acquires(RCU)
+	__acquires(ping_table.lock)
 {
 	struct ping_iter_state *state = seq->private;
 	state->bucket = 0;
 	state->family = family;
 
-	rcu_read_lock();
+	spin_lock(&ping_table.lock);
 
 	return *pos ? ping_get_idx(seq, *pos-1) : SEQ_START_TOKEN;
 }
@@ -1121,9 +1121,9 @@ void *ping_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(ping_seq_next);
 
 void ping_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
+	__releases(ping_table.lock)
 {
-	rcu_read_unlock();
+	spin_unlock(&ping_table.lock);
 }
 EXPORT_SYMBOL_GPL(ping_seq_stop);
 
-- 
2.30.2

