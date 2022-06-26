Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E156155AFF6
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 09:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiFZHpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 03:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiFZHpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 03:45:23 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6181813CD1
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 00:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656229522; x=1687765522;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KOJ0eBiodYIMHfV9RI8IPDMXEdsEtAqsU1DeawRR7oE=;
  b=b/4bkBW1xaYB5V69NTK+3eWrUpvKEfHH25wAHYDUmuFzgDheYVHx2n5v
   YDA3SIz8RMVIT4qbIECUjfOVe7Y8k8Fx9YEwQW1TtPLsh05H2od5xa29/
   V01gybCkd7FINPOdisr+L5JWk1L2IUICeeXKwywKGOC8XkX/NNph+VSL/
   w=;
X-IronPort-AV: E=Sophos;i="5.92,223,1650931200"; 
   d="scan'208";a="1028193813"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 26 Jun 2022 07:45:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com (Postfix) with ESMTPS id 3CF1A3E0B26;
        Sun, 26 Jun 2022 07:45:07 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 26 Jun 2022 07:45:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.210) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 26 Jun 2022 07:45:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Sun, 26 Jun 2022 00:44:54 -0700
Message-ID: <20220626074454.28944-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.210]
X-ClientProxiedBy: EX13D20UWC001.ant.amazon.com (10.43.162.244) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While setting up init_net's sysctl table, we need not duplicate the global
table and can use it directly.

Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/sysctl_net_unix.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 01d44e2598e2..1a98ec3b78b9 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -26,11 +26,16 @@ int __net_init unix_sysctl_register(struct net *net)
 {
 	struct ctl_table *table;
 
-	table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
-	if (table == NULL)
-		goto err_alloc;
+	if (net_eq(net, &init_net)) {
+		table = unix_table;
+	} else {
+		table = kmemdup(unix_table, sizeof(unix_table), GFP_KERNEL);
+		if (table == NULL)
+			goto err_alloc;
+
+		table[0].data = &net->unx.sysctl_max_dgram_qlen;
+	}
 
-	table[0].data = &net->unx.sysctl_max_dgram_qlen;
 	net->unx.ctl = register_net_sysctl(net, "net/unix", table);
 	if (net->unx.ctl == NULL)
 		goto err_reg;
@@ -38,7 +43,8 @@ int __net_init unix_sysctl_register(struct net *net)
 	return 0;
 
 err_reg:
-	kfree(table);
+	if (net_eq(net, &init_net))
+		kfree(table);
 err_alloc:
 	return -ENOMEM;
 }
-- 
2.30.2

