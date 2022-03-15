Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939264D941E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345031AbiCOFtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiCOFta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:49:30 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D5411A25
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647323298; x=1678859298;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c1yjSD9sOU0oKe7b2BQkLeXOcbLonwKQFyM5TyTgsm4=;
  b=rrpAZ9t2ymAbbNVHEF6c8CD6knpPJIiRfqr13ZP0ihEumI70TQmp59Ge
   NuMxU3xA+m4jOpiLenK9mORyOo80IK0+aDhYuujaWi0yo/OchjLWho40s
   ZMDkg54vZo6CmlmrVbVKiUZapsVZzWP4OpxKlaSZHxYDPdFuH32M2XFxa
   s=;
X-IronPort-AV: E=Sophos;i="5.90,182,1643673600"; 
   d="scan'208";a="186011626"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 15 Mar 2022 05:48:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id CACEAE0CB3;
        Tue, 15 Mar 2022 05:48:15 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 05:48:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.128) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 05:48:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net] af_unix: Support POLLPRI for OOB.
Date:   Tue, 15 Mar 2022 14:48:01 +0900
Message-ID: <20220315054801.72035-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.128]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
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
commit replaces `POLLIN|POLLPRI` with just `POLLPRI` in the first test
case.

v2:
  - Add READ_ONCE() to avoid a race reported by KCSAN (Eric)
  - Add IS_ENABLED(CONFIG_AF_UNIX_OOB) (Shoaib)

v1:
https://lore.kernel.org/netdev/20220314052110.53634-1-kuniyu@amazon.co.jp/

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c                                  | 10 +++++++---
 tools/testing/selftests/net/af_unix/test_unix_oob.c |  6 +++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c19569819866..9cf1137ae174 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2049,7 +2049,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
 {
 	struct unix_sock *ousk = unix_sk(other);
@@ -2115,7 +2115,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	err = -EOPNOTSUPP;
 	if (msg->msg_flags & MSG_OOB) {
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (len)
 			len--;
 		else
@@ -2186,7 +2186,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
 		err = queue_oob(sock, msg, other);
 		if (err)
@@ -3139,6 +3139,10 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
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

