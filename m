Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F5757E674
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiGVSYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiGVSYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:24:42 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476B29E7A7
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658514281; x=1690050281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=In4Wd+SYQwY74S1FEFiUwR1FHom6iUohzZSuXmsIcBg=;
  b=BK1eFgsXrCNfWA6rp2KtPWtvmYhYQsKkgzI8uz6wNS6n+2KO2jm0xwBI
   trH+GudRFxRclxOJhwc/+kUxEUZTzuav1X+M1uOzvd1tEfqv1ASsF/NsI
   UFRxHrQ9zq3tpx8Py8fwLccDYjDrVObI7FO1fi3KmsIJZCAzQd06RK9lh
   o=;
X-IronPort-AV: E=Sophos;i="5.93,186,1654560000"; 
   d="scan'208";a="1037018079"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-c275e159.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 22 Jul 2022 18:24:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-c275e159.us-west-2.amazon.com (Postfix) with ESMTPS id C7F9E92CC3;
        Fri, 22 Jul 2022 18:24:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 22 Jul 2022 18:24:22 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 22 Jul 2022 18:24:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH v1 net 7/7] ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.
Date:   Fri, 22 Jul 2022 11:22:05 -0700
Message-ID: <20220722182205.96838-8-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220722182205.96838-1-kuniyu@amazon.com>
References: <20220722182205.96838-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_fib_notify_on_flag_change, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Amit Cohen <amcohen@nvidia.com>
---
 net/ipv4/fib_trie.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 46e8a5125853..452ff177e4da 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1042,6 +1042,7 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 {
+	u8 fib_notify_on_flag_change;
 	struct fib_alias *fa_match;
 	struct sk_buff *skb;
 	int err;
@@ -1063,14 +1064,16 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	WRITE_ONCE(fa_match->offload, fri->offload);
 	WRITE_ONCE(fa_match->trap, fri->trap);
 
+	fib_notify_on_flag_change = READ_ONCE(net->ipv4.sysctl_fib_notify_on_flag_change);
+
 	/* 2 means send notifications only if offload_failed was changed. */
-	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
+	if (fib_notify_on_flag_change == 2 &&
 	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
 	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
-	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
+	if (!fib_notify_on_flag_change)
 		goto out;
 
 	skb = nlmsg_new(fib_nlmsg_size(fa_match->fa_info), GFP_ATOMIC);
-- 
2.30.2

