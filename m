Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F30E5765D6
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiGORSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiGORSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:18:51 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0896711C0A
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905528; x=1689441528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YJ/iQqhxxWDcktvMW6qLjWEYpgi2fTmwAq1W1U3lbxg=;
  b=cuqIdO2UAAk1KI2G2UVdru2ZWI/t9iqNOykZKZmxwa5StzMyiWBsu9kj
   D9H456a0ymLM/Gc/pBfIPzdFjv5PFsLJ+GQ+mLpzq95FJWdahX/7tfOx3
   KunFGxlz50vPq+x5j0pMXnLqAzB0s0tvKn3fr60kgjU3+fGEKqid9Aj+w
   g=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="210369669"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 15 Jul 2022 17:18:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id E705F83B0E;
        Fri, 15 Jul 2022 17:18:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:18:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:18:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Philip Downey <pdowney@brocade.com>
Subject: [PATCH v1 net 01/15] igmp: Fix data-races around sysctl_igmp_llm_reports.
Date:   Fri, 15 Jul 2022 10:17:41 -0700
Message-ID: <20220715171755.38497-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
References: <20220715171755.38497-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
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

While reading sysctl_igmp_llm_reports, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

This test can be packed into a helper, so such changes will be in the
follow-up series after net is merged into net-next.

  if (ipv4_is_local_multicast(pmc->multiaddr) &&
      !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))

Fixes: df2cf4a78e48 ("IGMP: Inhibit reports for local multicast groups")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Philip Downey <pdowney@brocade.com>
---
 net/ipv4/igmp.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index b65d074d9620..cf75fff170e4 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -467,7 +467,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ip_mc_list *pmc,
 
 	if (pmc->multiaddr == IGMP_ALL_HOSTS)
 		return skb;
-	if (ipv4_is_local_multicast(pmc->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(pmc->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -593,7 +594,7 @@ static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 			if (pmc->multiaddr == IGMP_ALL_HOSTS)
 				continue;
 			if (ipv4_is_local_multicast(pmc->multiaddr) &&
-			     !net->ipv4.sysctl_igmp_llm_reports)
+			    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 				continue;
 			spin_lock_bh(&pmc->lock);
 			if (pmc->sfcount[MCAST_EXCLUDE])
@@ -736,7 +737,8 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	if (type == IGMPV3_HOST_MEMBERSHIP_REPORT)
 		return igmpv3_send_report(in_dev, pmc);
 
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return 0;
 
 	if (type == IGMP_HOST_LEAVE_MESSAGE)
@@ -920,7 +922,8 @@ static bool igmp_heard_report(struct in_device *in_dev, __be32 group)
 
 	if (group == IGMP_ALL_HOSTS)
 		return false;
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return false;
 
 	rcu_read_lock();
@@ -1045,7 +1048,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 		spin_lock_bh(&im->lock);
 		if (im->tm_running)
@@ -1296,7 +1299,8 @@ static void __igmp_group_dropped(struct ip_mc_list *im, gfp_t gfp)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	reporter = im->reporter;
@@ -1338,7 +1342,8 @@ static void igmp_group_added(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	if (in_dev->dead)
@@ -1642,7 +1647,7 @@ static void ip_mc_rejoin_groups(struct in_device *in_dev)
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 
 		/* a failover is happening and switches
-- 
2.30.2

