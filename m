Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F0597C81
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242786AbiHRD4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiHRD4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:56:22 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221F6A98F8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660794982; x=1692330982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mg8N+v1f94NKtfTePka/kejwmYZv37DBXEVyQFBF0go=;
  b=VVd3SGIL0fvlrgTr3z0MPrSL3et/HWiCwbg+EQCrJE6fSlVPqo26Ouai
   Axd9OPFIjRngAxVRqPAwf18X1DnNYr03Id2igYP3V/4z6Lzr7+llD2QYf
   4MwGv3P3jIY2Kqd7xgF7vOdRPT+/wDedbPYwoc1GlwOLSGkGtOH06gWaw
   U=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="1045471987"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:56:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com (Postfix) with ESMTPS id 48CDFC0D54;
        Thu, 18 Aug 2022 03:56:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:56:18 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:56:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH v2 net 14/17] net: Fix data-races around sysctl_devconf_inherit_init_net.
Date:   Wed, 17 Aug 2022 20:52:24 -0700
Message-ID: <20220818035227.81567-15-kuniyu@amazon.com>
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

While reading sysctl_devconf_inherit_init_net, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 856c395cfa63 ("net: introduce a knob to control whether to inherit devconf config")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/devinet.c  | 6 ++++--
 net/ipv6/addrconf.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 92b778e423df..e92428f44f9b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2682,8 +2682,10 @@ static __net_init int devinet_init_net(struct net *net)
 #endif
 
 	if (!net_eq(net, &init_net)) {
+		int devconf_inherit_init_net = READ_ONCE(sysctl_devconf_inherit_init_net);
+
 		if (IS_ENABLED(CONFIG_SYSCTL) &&
-		    sysctl_devconf_inherit_init_net == 3) {
+		    devconf_inherit_init_net == 3) {
 			/* copy from the current netns */
 			memcpy(all, current->nsproxy->net_ns->ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
@@ -2691,7 +2693,7 @@ static __net_init int devinet_init_net(struct net *net)
 			       current->nsproxy->net_ns->ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
 		} else if (!IS_ENABLED(CONFIG_SYSCTL) ||
-			   sysctl_devconf_inherit_init_net != 2) {
+			   devconf_inherit_init_net != 2) {
 			/* inherit == 0 or 1: copy from init_net */
 			memcpy(all, init_net.ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b624e3d8c5f0..ac55b02bbe22 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7164,7 +7164,7 @@ static int __net_init addrconf_init_net(struct net *net)
 
 	if (IS_ENABLED(CONFIG_SYSCTL) &&
 	    !net_eq(net, &init_net)) {
-		switch (sysctl_devconf_inherit_init_net) {
+		switch (READ_ONCE(sysctl_devconf_inherit_init_net)) {
 		case 1:  /* copy from init_net */
 			memcpy(all, init_net.ipv6.devconf_all,
 			       sizeof(ipv6_devconf));
-- 
2.30.2

