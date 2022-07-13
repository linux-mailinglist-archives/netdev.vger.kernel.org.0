Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D6F573E3C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbiGMUxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237053AbiGMUxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:53:14 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE2131399
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745594; x=1689281594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CRokMTnTdgngsCrvntskEesKTAPdgNMcR7H50AacniA=;
  b=Xkx090pyiCAcKDswdiUdm0IuMehlMZ+DNo2lkRU/4sbym32Yw693ghwh
   txeenORelEXD2eRQZ2u0y71F+8WSOLU4jA46/q4J/0HJfSoKMt3pEYvtz
   uLE7mp0qstx3ucY9FtafnsZ3D6sQ7TQ1y5MwHV9PiYcCFJtGrGwaPpsdC
   U=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="107985355"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 13 Jul 2022 20:52:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 1F270200FE9;
        Wed, 13 Jul 2022 20:52:55 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:52:55 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:52:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 02/15] ip: Fix data-races around sysctl_ip_no_pmtu_disc.
Date:   Wed, 13 Jul 2022 13:51:52 -0700
Message-ID: <20220713205205.15735-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
References: <20220713205205.15735-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_ip_no_pmtu_disc, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/af_inet.c    | 2 +-
 net/ipv4/icmp.c       | 2 +-
 net/ipv6/af_inet6.c   | 2 +-
 net/xfrm/xfrm_state.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ac67f6b4ec70..4bc24f9e38b3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -335,7 +335,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	if (net->ipv4.sysctl_ip_no_pmtu_disc)
+	if (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc))
 		inet->pmtudisc = IP_PMTUDISC_DONT;
 	else
 		inet->pmtudisc = IP_PMTUDISC_WANT;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 57c4f0d87a7a..d5d745c3e345 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -881,7 +881,7 @@ static enum skb_drop_reason icmp_unreach(struct sk_buff *skb)
 			 * values please see
 			 * Documentation/networking/ip-sysctl.rst
 			 */
-			switch (net->ipv4.sysctl_ip_no_pmtu_disc) {
+			switch (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc)) {
 			default:
 				net_dbg_ratelimited("%pI4: fragmentation needed and DF set\n",
 						    &iph->daddr);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 70564ddccc46..6f354f8be2c5 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -226,7 +226,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	RCU_INIT_POINTER(inet->mc_list, NULL);
 	inet->rcv_tos	= 0;
 
-	if (net->ipv4.sysctl_ip_no_pmtu_disc)
+	if (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc))
 		inet->pmtudisc = IP_PMTUDISC_DONT;
 	else
 		inet->pmtudisc = IP_PMTUDISC_WANT;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 08564e0eef20..ccfb172eb5b8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2620,7 +2620,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 	int err;
 
 	if (family == AF_INET &&
-	    xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
+	    READ_ONCE(xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc))
 		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
 	err = -EPROTONOSUPPORT;
-- 
2.30.2

