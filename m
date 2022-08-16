Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6D6595493
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiHPIEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiHPIDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:03:39 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605E85FAE0;
        Mon, 15 Aug 2022 22:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660627594; x=1692163594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pmwCB1rtML/9o8e4ui5GvkioOpZG4mwOUDHFknLWzWw=;
  b=B/g2HQziSnwT+9603TspJyvI6SaAd/cbfj3sw2vnbA8L+zKvF/QtCEUy
   lKb61uieX4A8BMLEdiAMEENZ4EKcsfFOxHQbpp2AR3Inaz2RbIKbarKmu
   yHLLVlp2mqsUH/V1S2YOaxd9Vvhx6DbzZkthzfS1LoUBDFbfCeszUbzZp
   0=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="230039760"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:26:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id 31347E00CF;
        Tue, 16 Aug 2022 05:26:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 05:26:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 05:26:28 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 09/15] ratelimit: Fix data-races in ___ratelimit().
Date:   Mon, 15 Aug 2022 22:23:41 -0700
Message-ID: <20220816052347.70042-10-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816052347.70042-1-kuniyu@amazon.com>
References: <20220816052347.70042-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D24UWB003.ant.amazon.com (10.43.161.222) To
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
concurrently.  Thus, we need to add READ_ONCE() to their readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 lib/ratelimit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index e01a93f46f83..b59a1d3d0cc3 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -26,10 +26,12 @@
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
+	int interval = READ_ONCE(rs->interval);
+	int burst = READ_ONCE(rs->burst);
 	unsigned long flags;
 	int ret;
 
-	if (!rs->interval)
+	if (!interval)
 		return 1;
 
 	/*
@@ -44,7 +46,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
 	if (!rs->begin)
 		rs->begin = jiffies;
 
-	if (time_is_before_jiffies(rs->begin + rs->interval)) {
+	if (time_is_before_jiffies(rs->begin + interval)) {
 		if (rs->missed) {
 			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
 				printk_deferred(KERN_WARNING
@@ -56,7 +58,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
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

