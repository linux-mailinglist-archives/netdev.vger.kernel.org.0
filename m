Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F2D4DBD60
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiCQDKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349085AbiCQDKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:10:21 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856332126E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647486545; x=1679022545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tqr+StbNEAWNi0UwJrmuZ+OAyxFEaFFETrJcQ84bmUQ=;
  b=qSnFSBFXiT1oyJwRRNigrKqo9uEMbxPJbSPqJ4EHXG51nxJlEOWKo/75
   Q0VRxWxVjFdNgvCd6gnUdcJ36bBdqEdRY62wPIx0t8q1KQJQfrUi83qEU
   b89FunnG5rnMv4xSU20yvZUKYYhB1B3yogwIQaf4gt3hx/Vy9HMrtdlAF
   w=;
X-IronPort-AV: E=Sophos;i="5.90,188,1643673600"; 
   d="scan'208";a="71598623"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 17 Mar 2022 03:09:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id BA15D1A0C60;
        Thu, 17 Mar 2022 03:09:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 03:09:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.100) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 03:08:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net 2/2] af_unix: Support POLLPRI for OOB.
Date:   Thu, 17 Mar 2022 12:08:09 +0900
Message-ID: <20220317030809.63672-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317030809.63672-1-kuniyu@amazon.co.jp>
References: <20220317030809.63672-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D04UWB004.ant.amazon.com (10.43.161.103) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
piece.

In the selftest, normal datagrams are sent followed by OOB data, so this
commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
case.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
v4:
  - Separate nit changes from this series for net-next

v3: https://lore.kernel.org/netdev/20220315183855.15190-1-kuniyu@amazon.co.jp/

v2: https://lore.kernel.org/netdev/20220315054801.72035-1-kuniyu@amazon.co.jp/
  - Add READ_ONCE() to avoid a race reported by KCSAN (Eric)
  - Add IS_ENABLED(CONFIG_AF_UNIX_OOB) (Shoaib)

v1: https://lore.kernel.org/netdev/20220314052110.53634-1-kuniyu@amazon.co.jp/
---
 net/unix/af_unix.c                                  | 4 ++++
 tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0c37e5595aae..1e7ed5829ed5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3137,6 +3137,10 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (sk_is_readable(sk))
 		mask |= EPOLLIN | EPOLLRDNORM;
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (READ_ONCE(unix_sk(sk)->oob_skb))
+		mask |= EPOLLPRI;
+#endif
 
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
index 3dece8b29253..b57e91e1c3f2 100644
--- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
+++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
@@ -218,10 +218,10 @@ main(int argc, char **argv)
 
 	/* Test 1:
 	 * veriyf that SIGURG is
-	 * delivered and 63 bytes are
-	 * read and oob is '@'
+	 * delivered, 63 bytes are
+	 * read, oob is '@', and POLLPRI works.
 	 */
-	wait_for_data(pfd, POLLIN | POLLPRI);
+	wait_for_data(pfd, POLLPRI);
 	read_oob(pfd, &oob);
 	len = read_data(pfd, buf, 1024);
 	if (!signal_recvd || len != 63 || oob != '@') {
-- 
2.30.2

