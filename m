Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A7E53DEED
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 01:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348599AbiFEXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 19:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348593AbiFEXYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 19:24:22 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EBB49CBC
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1654471461; x=1686007461;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FYe6rKhUCpn5xsNFupmu1vLQfJzh57d1Y+G0lSMnvo0=;
  b=ZGjGQ/G5Y7Nlc26+yqlXSLteV4IodmmAOv0ORQDvADzzBIZQFM8seXZy
   pjheqPvr80dlTbYVUzEYNm46vqTnxgT+HDcQgf550TTDav/Lwzl7e6zLz
   /B8zOlC0iITKKOmW7bscPk5KC7+suHRqziFOfr2VZclAN0PwjkO2Tv3RS
   c=;
X-IronPort-AV: E=Sophos;i="5.91,280,1647302400"; 
   d="scan'208";a="225433696"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 05 Jun 2022 23:24:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id D9ED3C08CA;
        Sun,  5 Jun 2022 23:24:03 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 5 Jun 2022 23:24:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.242) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 5 Jun 2022 23:24:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rainer Weikusat <rweikusat@mobileactivedefense.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net] af_unix: Fix a data-race in unix_dgram_peer_wake_me().
Date:   Sun, 5 Jun 2022 16:23:25 -0700
Message-ID: <20220605232325.11804-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.242]
X-ClientProxiedBy: EX13D08UWB002.ant.amazon.com (10.43.161.168) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unix_dgram_poll() calls unix_dgram_peer_wake_me() without `other`'s
lock held and check if its receive queue is full.  Here we need to
use unix_recvq_full_lockless() instead of unix_recvq_full(), otherwise
KCSAN will report a data-race.

Fixes: 7d267278a9ec ("unix: avoid use-after-free in ep_remove_wait_queue")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
As Eric noted in commit 04f08eb44b501, I think rest of unix_recvq_full()
can be turned into the lockless version.  After this merge window, I can
send a follow-up patch if there is no objection.
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 654dcef7cfb3..2206e6f8902d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -490,7 +490,7 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 	 * -ECONNREFUSED. Otherwise, if we haven't queued any skbs
 	 * to other and its full, we will hang waiting for POLLOUT.
 	 */
-	if (unix_recvq_full(other) && !sock_flag(other, SOCK_DEAD))
+	if (unix_recvq_full_lockless(other) && !sock_flag(other, SOCK_DEAD))
 		return 1;
 
 	if (connected)
-- 
2.30.2

