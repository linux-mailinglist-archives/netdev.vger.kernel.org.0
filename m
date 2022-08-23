Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817E359EBFD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiHWTPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiHWTPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:15:18 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A925F7EFCD
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277158; x=1692813158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+2FVkKObQOh3GrpXfvEKdKt9rboCcdoyqGLpNHC76lg=;
  b=Ltcbg+AtsXw5NcQ2JsgOZdP2x4QhHA2vodSF3/foSV1naCF7hKKHv5/5
   6S9ELXpGMEADRocZ0xZuLXNY25TmFE2OyCiDO4Vv9J0GQLdMrma8bj1Bp
   VVN17qJxreGUAgh+o17PdGud8a2IGaUirhYBuL5BSU7a08vNTINwFz61i
   8=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="220380891"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:51:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id 0B56645133;
        Tue, 23 Aug 2022 17:51:47 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:51:46 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:51:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH v4 net 14/17] net: Fix data-races around sysctl_devconf_inherit_init_net.
Date:   Tue, 23 Aug 2022 10:46:57 -0700
Message-ID: <20220823174700.88411-15-kuniyu@amazon.com>
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

While reading sysctl_devconf_inherit_init_net, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 856c395cfa63 ("net: introduce a knob to control whether to inherit devconf config")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/netdevice.h |  9 +++++++++
 net/ipv4/devinet.c        | 16 ++++++++++------
 net/ipv6/addrconf.c       |  5 ++---
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6d3a33fd0cdb..05d6f3facd5a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -650,6 +650,15 @@ static inline bool net_has_fallback_tunnels(const struct net *net)
 #endif
 }
 
+static inline int net_inherit_devconf(void)
+{
+#if IS_ENABLED(CONFIG_SYSCTL)
+	return READ_ONCE(sysctl_devconf_inherit_init_net);
+#else
+	return 0;
+#endif
+}
+
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
 {
 #if defined(CONFIG_XPS) && defined(CONFIG_NUMA)
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 92b778e423df..e8b9a9202fec 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2682,23 +2682,27 @@ static __net_init int devinet_init_net(struct net *net)
 #endif
 
 	if (!net_eq(net, &init_net)) {
-		if (IS_ENABLED(CONFIG_SYSCTL) &&
-		    sysctl_devconf_inherit_init_net == 3) {
+		switch (net_inherit_devconf()) {
+		case 3:
 			/* copy from the current netns */
 			memcpy(all, current->nsproxy->net_ns->ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
 			memcpy(dflt,
 			       current->nsproxy->net_ns->ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
-		} else if (!IS_ENABLED(CONFIG_SYSCTL) ||
-			   sysctl_devconf_inherit_init_net != 2) {
-			/* inherit == 0 or 1: copy from init_net */
+			break;
+		case 0:
+		case 1:
+			/* copy from init_net */
 			memcpy(all, init_net.ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
 			memcpy(dflt, init_net.ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
+			break;
+		case 2:
+			/* use compiled values */
+			break;
 		}
-		/* else inherit == 2: use compiled values */
 	}
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b624e3d8c5f0..e15f64f22fa8 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7162,9 +7162,8 @@ static int __net_init addrconf_init_net(struct net *net)
 	if (!dflt)
 		goto err_alloc_dflt;
 
-	if (IS_ENABLED(CONFIG_SYSCTL) &&
-	    !net_eq(net, &init_net)) {
-		switch (sysctl_devconf_inherit_init_net) {
+	if (!net_eq(net, &init_net)) {
+		switch (net_inherit_devconf()) {
 		case 1:  /* copy from init_net */
 			memcpy(all, init_net.ipv6.devconf_all,
 			       sizeof(ipv6_devconf));
-- 
2.30.2

