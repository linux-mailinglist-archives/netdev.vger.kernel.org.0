Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CCD59EBF4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiHWTOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiHWTOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:14:05 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AB9118C9C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277087; x=1692813087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iRH0xCeUEwanTfYdKoJIp1bkuZuOMix4eJz0xgmfkEg=;
  b=foUrB5BojiacQl56Iqu+QYoJs+E8McBDFAFhnfqyzY7SMCc1U1MauF5n
   2g19KIz8LzxmHgkWfUnWB5MMTLCZEVyZFZ3WgFGr43DqEXYF00JREkzFo
   h+OCpTIaMz++e5P9cokEbRgsiBtTVsd+9VFaHe92KQDqbz1wo67nnWEg5
   c=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="233236578"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:49:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id EF0F244A7F;
        Tue, 23 Aug 2022 17:49:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:49:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:49:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net 05/17] ratelimit: Fix data-races in ___ratelimit().
Date:   Tue, 23 Aug 2022 10:46:48 -0700
Message-ID: <20220823174700.88411-6-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading rs->interval and rs->burst, they can be changed
concurrently via sysctl (e.g. net_ratelimit_state).  Thus, we
need to add READ_ONCE() to their readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 lib/ratelimit.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index e01a93f46f83..ce945c17980b 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -26,10 +26,16 @@
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
+	/* Paired with WRITE_ONCE() in .proc_handler().
+	 * Changing two values seperately could be inconsistent
+	 * and some message could be lost.  (See: net_ratelimit_state).
+	 */
+	int interval = READ_ONCE(rs->interval);
+	int burst = READ_ONCE(rs->burst);
 	unsigned long flags;
 	int ret;
 
-	if (!rs->interval)
+	if (!interval)
 		return 1;
 
 	/*
@@ -44,7 +50,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	if (!rs->begin)
 		rs->begin = jiffies;
 
-	if (time_is_before_jiffies(rs->begin + rs->interval)) {
+	if (time_is_before_jiffies(rs->begin + interval)) {
 		if (rs->missed) {
 			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
 				printk_deferred(KERN_WARNING
@@ -56,7 +62,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 		rs->begin   = jiffies;
 		rs->printed = 0;
 	}
-	if (rs->burst && rs->burst > rs->printed) {
+	if (burst && burst > rs->printed) {
 		rs->printed++;
 		ret = 1;
 	} else {
-- 
2.30.2

