Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28978573E43
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiGMUyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiGMUxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:53:51 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F3617AA0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745623; x=1689281623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZquAC1jsdQdOVKBdyo+AmTKYnf8Fn64ufwscMI4Cjps=;
  b=OHltJIZkDHvPys4EXf5/HUyjplMKHL6l6gY9ySp9fdi49sA1qpYFHAmU
   cmAirkn6Z9ixMxBS39wwlt/cndee6HubXiMh0Vop6PHAUxUsDUeCTW+Oz
   zL8Hr6l7pyoEYe+X0Lq66W4Y6OrirtGaiH/+Ayzc6/yNpNS/dAyGkojT8
   E=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="1033801586"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 13 Jul 2022 20:53:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 2A5482200AE;
        Wed, 13 Jul 2022 20:53:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:53:25 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:53:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH v1 net 04/15] ip: Fix data-races around sysctl_ip_fwd_update_priority.
Date:   Wed, 13 Jul 2022 13:51:54 -0700
Message-ID: <20220713205205.15735-5-kuniyu@amazon.com>
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

While reading sysctl_ip_fwd_update_priority, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 432e05d32892 ("net: ipv4: Control SKB reprioritization after forwarding")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 net/ipv4/ip_forward.c                                 | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0d8a0068e4ca..868d28f3b4e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10523,13 +10523,14 @@ static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
 static int __mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct net *net = mlxsw_sp_net(mlxsw_sp);
-	bool usp = net->ipv4.sysctl_ip_fwd_update_priority;
 	char rgcr_pl[MLXSW_REG_RGCR_LEN];
 	u64 max_rifs;
+	bool usp;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_RIFS))
 		return -EIO;
 	max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
+	usp = READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority);
 
 	mlxsw_reg_rgcr_pack(rgcr_pl, true, true);
 	mlxsw_reg_rgcr_max_router_interfaces_set(rgcr_pl, max_rifs);
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index e3aa436a1bdf..e18931a6d153 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -157,7 +157,7 @@ int ip_forward(struct sk_buff *skb)
 	    !skb_sec_path(skb))
 		ip_rt_send_redirect(skb);
 
-	if (net->ipv4.sysctl_ip_fwd_update_priority)
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority))
 		skb->priority = rt_tos2priority(iph->tos);
 
 	return NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD,
-- 
2.30.2

