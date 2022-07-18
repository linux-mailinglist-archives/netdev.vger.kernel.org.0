Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55290578872
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbiGRRaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiGRRaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:30:08 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394AB11461
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165405; x=1689701405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6FwUlFAxeI1VDgQRC1N7POnccoMdBVOP4w7XUEoV3mM=;
  b=C341b3qj8KeUAbmyI/7mQqsMUagN5mIaglZFjwfBQRrJ9guggRwZePqq
   iJKSycqZTOw1iHMw/OCI1T7tirrQhPCot7ohVWmrW4bfEXN3sE4qENukr
   ih7NjZyAAT658jB0jyIW8OJbBxYsSF8B7/TIe55iZVgMex46zJ6fr1p3O
   4=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="109671198"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 18 Jul 2022 17:27:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 4E3404C0078;
        Mon, 18 Jul 2022 17:27:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:27:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:27:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v1 net 03/15] ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
Date:   Mon, 18 Jul 2022 10:26:41 -0700
Message-ID: <20220718172653.22111-4-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_fib_multipath_hash_fields, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: ce5c9c20d364 ("ipv4: Add a sysctl to control multipath hash fields")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 net/ipv4/route.c                                      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index de63a5f3b767..85aa1c468cd4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10342,7 +10342,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_mp_hash_inner_l3(config);
 		break;
 	case 3:
-		hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+		hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 		/* Outer */
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 521194dd1c99..4702c61207a8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1929,7 +1929,7 @@ static u32 fib_multipath_custom_hash_outer(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool *p_has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
@@ -1958,7 +1958,7 @@ static u32 fib_multipath_custom_hash_inner(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	/* We assume the packet carries an encapsulation, but if none was
@@ -2018,7 +2018,7 @@ static u32 fib_multipath_custom_hash_skb(const struct net *net,
 static u32 fib_multipath_custom_hash_fl4(const struct net *net,
 					 const struct flowi4 *fl4)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
-- 
2.30.2

