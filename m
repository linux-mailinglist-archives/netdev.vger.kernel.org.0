Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF5559EBEF
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiHWTN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiHWTNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:13:41 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C2EAF0E5
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277067; x=1692813067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnreeUAy6WY30UmIjYDHl/Mw/87V/rQunE2Mfxra1MY=;
  b=i33K+pnVnl8DH8vlZso/XVTP9yJTQozRgbBZM8GX/Y8ZIj+AFD4e0WS2
   FYvguDqAHuFU6kPQoEwBcAQpfqwfRX86q82OjAWOzBsVA9GyGgt3+J2gJ
   FGIryiVzkwh5BDSoZdcsfo6vnA7PWqqpJLLiRjuUm4FXkCdBGPGTMK/by
   M=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="236627545"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:50:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id D633B44E9D;
        Tue, 23 Aug 2022 17:50:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:50:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:50:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v4 net 08/17] net: Fix a data-race around sysctl_net_busy_poll.
Date:   Tue, 23 Aug 2022 10:46:51 -0700
Message-ID: <20220823174700.88411-9-kuniyu@amazon.com>
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

While reading sysctl_net_busy_poll, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 060212928670 ("net: add low latency socket poll")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---
 include/net/busy_poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index c4898fcbf923..f90f0021f5f2 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -33,7 +33,7 @@ extern unsigned int sysctl_net_busy_poll __read_mostly;
 
 static inline bool net_busy_loop_on(void)
 {
-	return sysctl_net_busy_poll;
+	return READ_ONCE(sysctl_net_busy_poll);
 }
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
-- 
2.30.2

