Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C71597C75
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbiHRDyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243064AbiHRDyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:54:09 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC3898D2E
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660794848; x=1692330848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V+V7SGE1WHozIaXLIy6WGjvIZ5CklIm6fLWTrqxbonM=;
  b=KthrF3ug+dl2mV9AM/wnhPm+FezFIhujH/BBCulDopORSKmjk0AG+dBy
   4j16NcOJ9VIPrp3Y27HF8eGa3+/4+/Uy0grBufDPbNSXWbXuVc9P9U3md
   Kf55XkiamZm0VKUyd9his0K4QfcfzMuJy1tGzRXlHk4jA+JwNAZ6OEA55
   I=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="120456694"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:53:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id A256CC1E8F;
        Thu, 18 Aug 2022 03:53:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:53:49 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:53:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net 04/17] net: Fix data-races around netdev_tstamp_prequeue.
Date:   Wed, 17 Aug 2022 20:52:14 -0700
Message-ID: <20220818035227.81567-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818035227.81567-1-kuniyu@amazon.com>
References: <20220818035227.81567-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading netdev_tstamp_prequeue, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 3b098e2d7c69 ("net: Consistent skb timestamping")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 07da69c1ac0a..4705e6630efa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4928,7 +4928,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_rx(skb);
 
@@ -5281,7 +5281,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	int ret = NET_RX_DROP;
 	__be16 type;
 
-	net_timestamp_check(!netdev_tstamp_prequeue, skb);
+	net_timestamp_check(!READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_receive_skb(skb);
 
@@ -5664,7 +5664,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
@@ -5694,7 +5694,7 @@ void netif_receive_skb_list_internal(struct list_head *head)
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		net_timestamp_check(netdev_tstamp_prequeue, skb);
+		net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 		skb_list_del_init(skb);
 		if (!skb_defer_rx_timestamp(skb))
 			list_add_tail(&skb->list, &sublist);
-- 
2.30.2

