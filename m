Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A55569672
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiGFXm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiGFXmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:42:40 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFDF2CE0C;
        Wed,  6 Jul 2022 16:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657150960; x=1688686960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TlBSe1T/jB+nq/KU9u+Is0f8lN4V4SAmfBQAgoWCtoM=;
  b=TZ4cbHESyvdIsGxPBdc1TgKDRcnxjC0O962TKhmi0UykBn3XnxYh+D8b
   5oxpKYGQ66lR1JZZOT3PB/orCEBwEt4MuogVtHU625Ba/ejWuekUCbxH9
   gYNdzsyxGEVh2aBK0tvE7i7c9ewQHGmzeNAzsdTkzuvHSr2g7PtSY4EGs
   E=;
X-IronPort-AV: E=Sophos;i="5.92,251,1650931200"; 
   d="scan'208";a="235612951"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 Jul 2022 23:42:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com (Postfix) with ESMTPS id 7A7171216DF;
        Wed,  6 Jul 2022 23:42:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 23:42:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 23:42:31 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 08/12] inetpeer: Fix data-races around sysctl.
Date:   Wed, 6 Jul 2022 16:39:59 -0700
Message-ID: <20220706234003.66760-9-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706234003.66760-1-kuniyu@amazon.com>
References: <20220706234003.66760-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading inetpeer sysctl variables, they can be changed
concurrently.  So, we need to add READ_ONCE() to avoid data-races.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inetpeer.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index da21dfce24d7..e9fed83e9b3c 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -141,16 +141,20 @@ static void inet_peer_gc(struct inet_peer_base *base,
 			 struct inet_peer *gc_stack[],
 			 unsigned int gc_cnt)
 {
+	int peer_threshold, peer_maxttl, peer_minttl;
 	struct inet_peer *p;
 	__u32 delta, ttl;
 	int i;
 
-	if (base->total >= inet_peer_threshold)
+	peer_threshold = READ_ONCE(inet_peer_threshold);
+	peer_maxttl = READ_ONCE(inet_peer_maxttl);
+	peer_minttl = READ_ONCE(inet_peer_minttl);
+
+	if (base->total >= peer_threshold)
 		ttl = 0; /* be aggressive */
 	else
-		ttl = inet_peer_maxttl
-				- (inet_peer_maxttl - inet_peer_minttl) / HZ *
-					base->total / inet_peer_threshold * HZ;
+		ttl = peer_maxttl - (peer_maxttl - peer_minttl) / HZ *
+			base->total / peer_threshold * HZ;
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
-- 
2.30.2

