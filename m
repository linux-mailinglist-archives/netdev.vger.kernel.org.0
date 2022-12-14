Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CDF64C5C9
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbiLNJU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbiLNJUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:20:54 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFB61AF1A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671009652; x=1702545652;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OlJZ4X+LRCNTLRl3KrcWUtzsePiEfeGx6fbGDySX71Q=;
  b=mgCzEUVhtcObUB1zqAhgEjhwpFMj3Ig3s+7ZmX8Exe2PCB12JMyip2P4
   f9FSoxLQbLyn2bUSRsNDiid+b0dWc1b/Bv+Je5GJjKF+1rMutKef4TSPv
   wRdCC3kExBtnKEEqzBKeXcK10K4tXrVcJVvC7AEcKqW05L0hHjIy9jy4O
   M=;
X-IronPort-AV: E=Sophos;i="5.96,244,1665446400"; 
   d="scan'208";a="1083351086"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 09:20:45 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id B175881899;
        Wed, 14 Dec 2022 09:20:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 14 Dec 2022 09:20:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 14 Dec 2022 09:20:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "Denis V. Lunev" <den@openvz.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net] af_unix: Add error handling in af_unix_init().
Date:   Wed, 14 Dec 2022 18:20:08 +0900
Message-ID: <20221214092008.47330-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D46UWB003.ant.amazon.com (10.43.161.117) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_register() and register_pernet_subsys() in af_unix_init() could
fail.

For example, after loading another PF_UNIX module (it's improbable
though), loading unix.ko fails at sock_register() and leaks slab
memory.  Also, register_pernet_subsys() fails when running out of
memory.

Let's handle errors appropriately.

Fixes: 097e66c57845 ("[NET]: Make AF_UNIX per network namespace safe [v2]")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index ede2b2a140a4..5352f30850f1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3720,7 +3720,7 @@ static void __init bpf_iter_register(void)
 
 static int __init af_unix_init(void)
 {
-	int i, rc = -1;
+	int i, rc;
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
@@ -3730,20 +3730,25 @@ static int __init af_unix_init(void)
 	}
 
 	rc = proto_register(&unix_dgram_proto, 1);
-	if (rc != 0) {
+	if (rc) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
 		goto out;
 	}
 
 	rc = proto_register(&unix_stream_proto, 1);
-	if (rc != 0) {
+	if (rc) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
-		proto_unregister(&unix_dgram_proto);
-		goto out;
+		goto err_proto_register;
 	}
 
-	sock_register(&unix_family_ops);
-	register_pernet_subsys(&unix_net_ops);
+	rc = sock_register(&unix_family_ops);
+	if (rc)
+		goto err_sock_register;
+
+	rc = register_pernet_subsys(&unix_net_ops);
+	if (rc)
+		goto err_register_pernet_subsys;
+
 	unix_bpf_build_proto();
 
 #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
@@ -3752,6 +3757,15 @@ static int __init af_unix_init(void)
 
 out:
 	return rc;
+
+err_register_pernet_subsys:
+	sock_unregister(PF_UNIX);
+err_sock_register:
+	proto_unregister(&unix_stream_proto);
+err_proto_register:
+	proto_unregister(&unix_dgram_proto);
+
+	goto out;
 }
 
 static void __exit af_unix_exit(void)
-- 
2.30.2

