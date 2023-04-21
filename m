Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF26EB5F3
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjDUXuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjDUXud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:50:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60FFC1BFD;
        Fri, 21 Apr 2023 16:50:32 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 11/19] ipvs: Consistently use array_size() in ip_vs_conn_init()
Date:   Sat, 22 Apr 2023 01:50:13 +0200
Message-Id: <20230421235021.216950-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421235021.216950-1-pablo@netfilter.org>
References: <20230421235021.216950-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms@kernel.org>

Consistently use array_size() to calculate the size of ip_vs_conn_tab
in bytes.

Flagged by Coccinelle:
 WARNING: array_size is already used (line 1498) to compute the same size

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 13534e02346c..928e64653837 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1481,6 +1481,7 @@ void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
 
 int __init ip_vs_conn_init(void)
 {
+	size_t tab_array_size;
 	int idx;
 
 	/* Compute size and mask */
@@ -1494,8 +1495,9 @@ int __init ip_vs_conn_init(void)
 	/*
 	 * Allocate the connection hash table and initialize its list heads
 	 */
-	ip_vs_conn_tab = vmalloc(array_size(ip_vs_conn_tab_size,
-					    sizeof(*ip_vs_conn_tab)));
+	tab_array_size = array_size(ip_vs_conn_tab_size,
+				    sizeof(*ip_vs_conn_tab));
+	ip_vs_conn_tab = vmalloc(tab_array_size);
 	if (!ip_vs_conn_tab)
 		return -ENOMEM;
 
@@ -1508,10 +1510,8 @@ int __init ip_vs_conn_init(void)
 		return -ENOMEM;
 	}
 
-	pr_info("Connection hash table configured "
-		"(size=%d, memory=%ldKbytes)\n",
-		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
+	pr_info("Connection hash table configured (size=%d, memory=%zdKbytes)\n",
+		ip_vs_conn_tab_size, tab_array_size / 1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
2.30.2

