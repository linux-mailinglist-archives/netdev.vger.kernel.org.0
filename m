Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5C9578885
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiGRReO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGRReN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:34:13 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09072C644
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658165654; x=1689701654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Um7gG1QJwb2weu1+w2RtnIvkS6JQkdYcnJkQBoKrI18=;
  b=ba/0ZbLSzKwLVCsbPx+UyxAq2tGkyinYKaF7QrtXKfPgyd3Uv7JBKfr/
   pnfaHWXigVAUXCk434bQ3l66Bauk2XGZjc+d6HD5xQYlap3SnFdCD1/Ml
   T0AFkh5kTbAOxuE09yYDdy+NFMQMDZYuSlXXMRDALUbmMv4B8MorqNJPi
   0=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="109609505"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 18 Jul 2022 17:27:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com (Postfix) with ESMTPS id BEC7EA2873;
        Mon, 18 Jul 2022 17:27:32 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 17:27:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 17:27:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH v1 net 02/15] ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
Date:   Mon, 18 Jul 2022 10:26:40 -0700
Message-ID: <20220718172653.22111-3-kuniyu@amazon.com>
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

While reading sysctl_fib_multipath_hash_policy, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: bf4e0a3db97e ("net: ipv4: add support for ECMP hash policy choice")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 net/ipv4/route.c                                      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 868d28f3b4e1..de63a5f3b767 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10324,7 +10324,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 	unsigned long *fields = config->fields;
 	u32 hash_fields;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		mlxsw_sp_mp4_hash_outer_addr(config);
 		break;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 91c4f60de75a..521194dd1c99 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2048,7 +2048,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 	struct flow_keys hash_keys;
 	u32 mhash = 0;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		memset(&hash_keys, 0, sizeof(hash_keys));
 		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
-- 
2.30.2

