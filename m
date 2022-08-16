Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B924C595484
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiHPIGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiHPIFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:05:07 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB1C10E978;
        Mon, 15 Aug 2022 22:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660627639; x=1692163639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnreeUAy6WY30UmIjYDHl/Mw/87V/rQunE2Mfxra1MY=;
  b=T4IQxMm5kYQdWspkbyCllCavyd0E+zvQbKlBqYlbigRYEbiA2bvcfGza
   w1i/0T/44M3KDIpF21R/JNd2JoHg2tv6U9f69XgAy29ycKITXObruuo6d
   iQz0iRmu1aELb3Hjm8P+/LoduQ1PuLphF0B3MhjVFrlzHFeprdnMOgyzB
   4=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="230040066"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:27:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 757DC81151;
        Tue, 16 Aug 2022 05:27:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 05:27:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 05:27:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v1 net 12/15] net: Fix a data-race around sysctl_net_busy_poll.
Date:   Mon, 15 Aug 2022 22:23:44 -0700
Message-ID: <20220816052347.70042-13-kuniyu@amazon.com>
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

