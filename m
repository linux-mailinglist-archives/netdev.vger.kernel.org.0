Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C64759EBFA
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiHWTPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiHWTO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:14:58 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC8F9F0D4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277142; x=1692813142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6twB4CeMTUwa9Ft3vw4/Yav1Jcmh0dSXJXVNECF9zSk=;
  b=ZrtL4pQGUIP3UDJ45MdGP6ekTZKkRHTlCXfOzB5IAlvZqXl9PL+fUXYh
   L3pVGsmkfPyPVz9/ucVh0p5XbbOI7KhJda4yVXWHV0bEPhNjqefWFXhLC
   5uNgu4IEl4up2XB7U949RMePKsE16j1hNQ+Xi21bkQkHND3QqohtAtiM1
   k=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="122631715"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:51:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com (Postfix) with ESMTPS id AFC4445202;
        Tue, 23 Aug 2022 17:51:31 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:51:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:51:28 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net 13/17] net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
Date:   Tue, 23 Aug 2022 10:46:56 -0700
Message-ID: <20220823174700.88411-14-kuniyu@amazon.com>
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

While reading sysctl_fb_tunnels_only_for_init_net, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 79134e6ce2c9 ("net: do not create fallback tunnels for non-default namespaces")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/netdevice.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a3cb93c3dcc..6d3a33fd0cdb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -640,9 +640,14 @@ extern int sysctl_devconf_inherit_init_net;
  */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return !IS_ENABLED(CONFIG_SYSCTL) ||
-	       !sysctl_fb_tunnels_only_for_init_net ||
-	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
+#if IS_ENABLED(CONFIG_SYSCTL)
+	int fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
+
+	return !fb_tunnels_only_for_init_net ||
+		(net_eq(net, &init_net) && fb_tunnels_only_for_init_net == 1);
+#else
+	return true;
+#endif
 }
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
-- 
2.30.2

