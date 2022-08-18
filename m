Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD10597C7A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbiHRDz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiHRDzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:55:53 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766FB95AF4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660794952; x=1692330952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JfPF2ZqugN0Yp2GRglcl+Ir+F5lCIdgbdk7Mg+gxAAY=;
  b=obyoU9QoEtylDiKHIk/oEEFTazTDodNEGQjBxobfkaNpyLiiA14czrSL
   p0G/iN+GmSm441DFwHGgKnflslHQo+TRwvojuEFgwDHuZtz973PBr3git
   0+5p+FyN6J54QDG8stI36C1JlE9w1GdtmugM1DICmziSydgJSKdm45GL5
   Y=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="120456985"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:55:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id D384FC1E8F;
        Thu, 18 Aug 2022 03:55:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:55:47 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:55:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Matthew Whitehead <tedheadster@gmail.com>
Subject: [PATCH v2 net 12/17] net: Fix a data-race around netdev_budget_usecs.
Date:   Wed, 17 Aug 2022 20:52:22 -0700
Message-ID: <20220818035227.81567-13-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818035227.81567-1-kuniyu@amazon.com>
References: <20220818035227.81567-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
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

While reading netdev_budget_usecs, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Matthew Whitehead <tedheadster@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c83e23cfc57d..8221322d86db 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6665,7 +6665,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
-		usecs_to_jiffies(netdev_budget_usecs);
+		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
 	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
-- 
2.30.2

