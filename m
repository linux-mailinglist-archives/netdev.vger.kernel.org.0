Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A478B598B1B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiHRS2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345448AbiHRS23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:28:29 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9398B165A6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847306; x=1692383306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V+V7SGE1WHozIaXLIy6WGjvIZ5CklIm6fLWTrqxbonM=;
  b=iHOih5gl3Q6h6wTKAoWPOwv+gcb4Tn/Btz19E8RXvjbyi2Kvmfcp/SQU
   Z3P4RAWolkSPWWbkRkBxvRjhJeuLogqzsxTly2ovvbZGhfZIcyinVJAbs
   gwfNc9WyBfxjJoh3+uRF9Q8Le0B1qthTnRtaMEPxtF89tsiiT0vwXfEjC
   4=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="234654720"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:28:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com (Postfix) with ESMTPS id BB7CFA2987;
        Thu, 18 Aug 2022 18:28:12 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:28:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:28:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 04/17] net: Fix data-races around netdev_tstamp_prequeue.
Date:   Thu, 18 Aug 2022 11:26:40 -0700
Message-ID: <20220818182653.38940-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818182653.38940-1-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
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

