Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26452584A29
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 05:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiG2DWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 23:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiG2DWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 23:22:11 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BD27C196
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1659064930; x=1690600930;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XC65Q5mr+Yoj/cgavGleB2iWzxNdc6agrE7CWcdciUY=;
  b=wIiiNYKOmnYSCmRByXS90yf+zJG81WV448bHL6/HmcVsuIuNoCxNGbOx
   3CwcM3IFpz332QG3ZkQR0JWFCJt5/JQSHqorzq+ETYIvl1QwyvhpKA3xl
   sGzLOuk7XLEMl+2SFp/cuSTjIbQ3K/UetbRn4M8VF4Y1IEQhNMvoMMPfG
   M=;
X-IronPort-AV: E=Sophos;i="5.93,200,1654560000"; 
   d="scan'208";a="113495221"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 03:21:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id 2FE2FC0BA0;
        Fri, 29 Jul 2022 03:21:54 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 29 Jul 2022 03:21:53 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.87) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 29 Jul 2022 03:21:51 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next] udp: Remove redundant __udp_sysctl_init() call from udp_init().
Date:   Thu, 28 Jul 2022 20:21:37 -0700
Message-ID: <20220729032137.60616-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.87]
X-ClientProxiedBy: EX13D47UWA004.ant.amazon.com (10.43.163.47) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__udp_sysctl_init() is called for init_net via udp_sysctl_ops.

While at it, we can rename __udp_sysctl_init() to udp_sysctl_init().

Fixes: 1e8029515816 ("udp: Move the udp sysctl to namespace.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2516078aa03e..34eda973bbf1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3264,7 +3264,7 @@ u32 udp_flow_hashrnd(void)
 }
 EXPORT_SYMBOL(udp_flow_hashrnd);
 
-static void __udp_sysctl_init(struct net *net)
+static int __net_init udp_sysctl_init(struct net *net)
 {
 	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
 	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
@@ -3272,11 +3272,7 @@ static void __udp_sysctl_init(struct net *net)
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	net->ipv4.sysctl_udp_l3mdev_accept = 0;
 #endif
-}
 
-static int __net_init udp_sysctl_init(struct net *net)
-{
-	__udp_sysctl_init(net);
 	return 0;
 }
 
@@ -3352,8 +3348,6 @@ void __init udp_init(void)
 	sysctl_udp_mem[1] = limit;
 	sysctl_udp_mem[2] = sysctl_udp_mem[0] * 2;
 
-	__udp_sysctl_init(&init_net);
-
 	/* 16 spinlocks per cpu */
 	udp_busylocks_log = ilog2(nr_cpu_ids) + 4;
 	udp_busylocks = kmalloc(sizeof(spinlock_t) << udp_busylocks_log,
-- 
2.30.2

