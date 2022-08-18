Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202F5597C71
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiHRD4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbiHRD4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:56:08 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9DEA220A
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660794968; x=1692330968;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ciyGAVs7acn1U98JEDRtg3PFOXr7JWt71O+dKx/lHTc=;
  b=roX1PNqgXQBZVjCr3L+fjjAp12+JHYL0XQGRZHRaj1SsmLx9pAc4Sx6G
   cZ/tPN37wCIKpCBCTjYpL0+1DncBvW9v9EJIrGPxBTfIr+/TEIElH5+yx
   eQbfXjLg7x4KmzCs7EHG7eowyDRLqNKGyYVS0w+9EEM1tStLbeAl5Mf9Y
   0=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="234359320"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:56:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com (Postfix) with ESMTPS id 35E2B160072;
        Thu, 18 Aug 2022 03:56:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:56:03 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:56:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net 13/17] net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
Date:   Wed, 17 Aug 2022 20:52:23 -0700
Message-ID: <20220818035227.81567-14-kuniyu@amazon.com>
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

While reading sysctl_fb_tunnels_only_for_init_net, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 79134e6ce2c9 ("net: do not create fallback tunnels for non-default namespaces")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/netdevice.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a3cb93c3dcc..89a9545d90db 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -640,9 +640,11 @@ extern int sysctl_devconf_inherit_init_net;
  */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
+	int fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
+
 	return !IS_ENABLED(CONFIG_SYSCTL) ||
-	       !sysctl_fb_tunnels_only_for_init_net ||
-	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
+	       !fb_tunnels_only_for_init_net ||
+	       (net == &init_net && fb_tunnels_only_for_init_net == 1);
 }
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
-- 
2.30.2

