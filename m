Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004BF59EC01
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiHWTPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiHWTPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:15:32 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F2C6CD18
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277178; x=1692813178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PxL+q0mi80vBEXSE2tqreLr3xAALs/zina6F8jQ63Lk=;
  b=o3eA9rrpcQpmeI4Tkh4J1M1tLjMvHJUZWvkdbJ1v6Z3eJk8L8zU+0H45
   xvCO4N4wMSrzat5QtesCxFGPxZ10jwVH6eNE2w3KXlHXlPrbgBntWUJLo
   OXpo/j6Z9Al5cJG4a7iwLp9rgi7RYRZwA5pAfM6wMVgL+oe7gAgXeN5XG
   s=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="220381082"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:52:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 66D3F453FA;
        Tue, 23 Aug 2022 17:52:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:52:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:52:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net 17/17] net: Fix a data-race around sysctl_somaxconn.
Date:   Tue, 23 Aug 2022 10:47:00 -0700
Message-ID: <20220823174700.88411-18-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823174700.88411-1-kuniyu@amazon.com>
References: <20220823174700.88411-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
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

While reading sysctl_somaxconn, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 9b27c5e4e5ba..7378375d3a5b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1801,7 +1801,7 @@ int __sys_listen(int fd, int backlog)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
-		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
+		somaxconn = READ_ONCE(sock_net(sock->sk)->core.sysctl_somaxconn);
 		if ((unsigned int)backlog > somaxconn)
 			backlog = somaxconn;
 
-- 
2.30.2

