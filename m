Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD18569685
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiGFXny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiGFXnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:43:41 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD4F2D1E3;
        Wed,  6 Jul 2022 16:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657151021; x=1688687021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AvvrK8qrOu12cbubhLZfU/X+OByykQFjHxBineAuT5M=;
  b=iOcUqYCBYRxd8ja/YLdzrDQXe95nZnPTvTuCDNLXg30Kuj1gnbYUelqD
   GCVhf40ywLRRJv89WeVv3NF2pxHSRF2/GdmxjC9oFHMIIOB893Z+iAP13
   ADn1dDxPSWMjWhcbp4B9SnwgDsApD5L960EIn8bMe/JM+35JFnveMXiX4
   U=;
X-IronPort-AV: E=Sophos;i="5.92,251,1650931200"; 
   d="scan'208";a="105569596"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 06 Jul 2022 23:43:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id C335222015B;
        Wed,  6 Jul 2022 23:43:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 23:43:19 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 23:43:16 +0000
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
Subject: [PATCH v2 net 11/12] icmp: Fix data-races around sysctl.
Date:   Wed, 6 Jul 2022 16:40:02 -0700
Message-ID: <20220706234003.66760-12-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706234003.66760-1-kuniyu@amazon.com>
References: <20220706234003.66760-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading icmp sysctl variables, they can be changed concurrently.
So, we need to add READ_ONCE() to avoid data-races.

Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/icmp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index efea0e796f06..0f9e61d29f73 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -253,11 +253,12 @@ bool icmp_global_allow(void)
 	spin_lock(&icmp_global.lock);
 	delta = min_t(u32, now - icmp_global.stamp, HZ);
 	if (delta >= HZ / 50) {
-		incr = sysctl_icmp_msgs_per_sec * delta / HZ ;
+		incr = READ_ONCE(sysctl_icmp_msgs_per_sec) * delta / HZ;
 		if (incr)
 			WRITE_ONCE(icmp_global.stamp, now);
 	}
-	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
+	credit = min_t(u32, icmp_global.credit + incr,
+		       READ_ONCE(sysctl_icmp_msgs_burst));
 	if (credit) {
 		/* We want to use a credit of one in average, but need to randomize
 		 * it for security reasons.
-- 
2.30.2

