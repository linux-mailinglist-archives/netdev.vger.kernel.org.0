Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE0F55CD8B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbiF0XhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 19:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiF0XhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 19:37:06 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789FAE025
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 16:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656373023; x=1687909023;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QZS0h1aqGiB4GTxutispU9s+8iCixwYD06/RfI7l2II=;
  b=oXGi+YJM4G8+W+CP7ZkTX6/CxKDbIkzL5IibF0O2LNWjdrkxnHAQLaS8
   M+ehfEpx7YedAl2d6+CO34+sIFbRe0OINGDc4v/KwY0mM4hjvccam7fRT
   nEaxXBeU6dlIyKBlksCxpvdPTelLHyWQZZpKz9ahUM+wAVWGV25Cy33Uj
   A=;
X-IronPort-AV: E=Sophos;i="5.92,227,1650931200"; 
   d="scan'208";a="212398590"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 27 Jun 2022 23:36:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id 05804817E6;
        Mon, 27 Jun 2022 23:36:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 23:36:50 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.40) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 23:36:47 +0000
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
Subject: [PATCH v3 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Mon, 27 Jun 2022 16:36:27 -0700
Message-ID: <20220627233627.51646-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.40]
X-ClientProxiedBy: EX13D41UWB001.ant.amazon.com (10.43.161.189) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While setting up init_net's sysctl table, we need not duplicate the
global table and can use it directly as ipv4_sysctl_init_net() does.

Unlike IPv4, AF_UNIX does not have a huge sysctl table for now, so it
cannot be a problem, but this patch makes code consistent.

Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v3:
  * Update changelog
  * Fix a bug when we unload unix.ko

v2: https://lore.kernel.org/all/20220626082331.36119-1-kuniyu@amazon.com/
  * Fix NULL comparison style by checkpatch.pl

v1: https://lore.kernel.org/all/20220626074454.28944-1-kuniyu@amazon.com/
---
 net/unix/sysctl_net_unix.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 01d44e2598e2..3f1fdffd6092 100644
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
+		if (!table)
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
@@ -49,5 +55,6 @@ void unix_sysctl_unregister(struct net *net)
 
 	table = net->unx.ctl->ctl_table_arg;
 	unregister_net_sysctl_table(net->unx.ctl);
-	kfree(table);
+	if (!net_eq(net, &init_net))
+		kfree(table);
 }
-- 
2.30.2

