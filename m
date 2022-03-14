Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BFE4D7A1B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 06:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiCNFWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 01:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiCNFWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 01:22:32 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A3F3B01F
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 22:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647235284; x=1678771284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rwTQXEvO4Sdg86JfiVFZI2sTFM5v362UbeLTR1cM6oo=;
  b=RN8t42eo+wbmZ0mA7CXT5OnyP6F5vr3zzx7Bt6nRtOictRxmEZLtL2pW
   ZJfsUrtaUaNLX3oKha4VK1HbZYD47/VMn/YDEHOfTcv56Sy3E3kTVyB3n
   pRsoaUjDT/E/Mc+HewZPMYYt+vKtweoF/T0zaXfxxQHGo6TBakkiw4H6M
   M=;
X-IronPort-AV: E=Sophos;i="5.90,179,1643673600"; 
   d="scan'208";a="185670184"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 14 Mar 2022 05:21:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id A0674C0322;
        Mon, 14 Mar 2022 05:21:21 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 14 Mar 2022 05:21:20 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.93) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Mon, 14 Mar 2022 05:21:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net] af_unix: Support POLLPRI for OOB.
Date:   Mon, 14 Mar 2022 14:21:10 +0900
Message-ID: <20220314052110.53634-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D07UWB001.ant.amazon.com (10.43.161.238) To
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
commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
case.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c                                  | 2 ++
 tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c19569819866..711d21b1c3e1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (sk_is_readable(sk))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (unix_sk(sk)->oob_skb)
+		mask |= EPOLLPRI;
 
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

