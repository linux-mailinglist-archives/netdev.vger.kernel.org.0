Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1273C57885B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiGRR2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbiGRR2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:28:17 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323172CDEB
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165296; x=1689701296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gYptKUtANfCOhb6wwJGl228ZqtmZhW8sJwB0anLqL18=;
  b=L9rBCgOd3C6bnIGLApmYXYNPp7zW5Dd3f9aKfmxxB6FjQddCMNx324og
   M4PlmeyCUx4z5rF/y7TYT/T8UbmqEL2ABUBa3leBF4fByw2vt3e+YdUGC
   lKCV7yiV1FSNPJQJCqhgIVEdeJ3QpXAr9sTYkEPnj9cbgCaiUG7HyFEdr
   U=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="222974499"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 18 Jul 2022 17:28:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id E120143F0C;
        Mon, 18 Jul 2022 17:28:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:28:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:27:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Krister Johansen <kjlx@templeofstupid.com>
Subject: [PATCH v1 net 04/15] ip: Fix data-races around sysctl_ip_prot_sock.
Date:   Mon, 18 Jul 2022 10:26:42 -0700
Message-ID: <20220718172653.22111-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718172653.22111-1-kuniyu@amazon.com>
References: <20220718172653.22111-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D04UWA004.ant.amazon.com (10.43.160.234) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysctl_ip_prot_sock is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

Fixes: 4548b683b781 ("Introduce a sysctl that modifies the value of PROT_SOCK.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Krister Johansen <kjlx@templeofstupid.com>
---
 include/net/ip.h           | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 4a15b6bcb4b8..1c979fd1904c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -357,7 +357,7 @@ static inline bool sysctl_dev_name_is_allowed(const char *name)
 
 static inline bool inet_port_requires_bind_service(struct net *net, unsigned short port)
 {
-	return port < net->ipv4.sysctl_ip_prot_sock;
+	return port < READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 }
 
 #else
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 130e9c130311..5490c285668b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -84,7 +84,7 @@ static int ipv4_local_port_range(struct ctl_table *table, int write,
 		 * port limit.
 		 */
 		if ((range[1] < range[0]) ||
-		    (range[0] < net->ipv4.sysctl_ip_prot_sock))
+		    (range[0] < READ_ONCE(net->ipv4.sysctl_ip_prot_sock)))
 			ret = -EINVAL;
 		else
 			set_local_port_range(net, range);
@@ -110,7 +110,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		.extra2 = &ip_privileged_port_max,
 	};
 
-	pports = net->ipv4.sysctl_ip_prot_sock;
+	pports = READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 
@@ -122,7 +122,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		if (range[0] < pports)
 			ret = -EINVAL;
 		else
-			net->ipv4.sysctl_ip_prot_sock = pports;
+			WRITE_ONCE(net->ipv4.sysctl_ip_prot_sock, pports);
 	}
 
 	return ret;
-- 
2.30.2

