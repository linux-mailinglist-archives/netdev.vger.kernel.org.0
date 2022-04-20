Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB01507E83
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358824AbiDTCDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345589AbiDTCDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:03:16 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3901A3AA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1650420032; x=1681956032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QWVhZX6PFNNk3oOMN1NRpoMKFjNreFTcHryr5Vb7fWM=;
  b=WxrhM7ogYENEWfLEvbU1fJLjL8Qk/eY22nPajAgJbXBv6s0TzZZqPbcM
   p/n9fzyu1SkxdQNSx95eVKKxKD9pHeIQJWzk1aMXmhdjA/qbpjJc3yEFv
   W5+PcwrbonA6gSzyeBzTKeJjJSZcJxsv9uUF2kqdXzUMKgB6JBLekMgz0
   c=;
X-IronPort-AV: E=Sophos;i="5.90,274,1643673600"; 
   d="scan'208";a="81168007"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 20 Apr 2022 02:00:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com (Postfix) with ESMTPS id A923840C0D;
        Wed, 20 Apr 2022 02:00:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 20 Apr 2022 02:00:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.236) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 20 Apr 2022 02:00:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/2] ipv6: Use ipv6_only_sock() helper in condition.
Date:   Wed, 20 Apr 2022 10:58:51 +0900
Message-ID: <20220420015851.50237-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420015851.50237-1-kuniyu@amazon.co.jp>
References: <20220420015851.50237-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.236]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces some sk_ipv6only tests with ipv6_only_sock().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 drivers/net/bonding/bond_main.c                                | 2 +-
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c      | 2 +-
 drivers/net/ethernet/netronome/nfp/crypto/tls.c                | 2 +-
 net/core/filter.c                                              | 2 +-
 net/ipv6/af_inet6.c                                            | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 15eddca7b4b6..00e6bc591f77 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5221,7 +5221,7 @@ static void bond_sk_to_flow(struct sock *sk, struct flow_keys *flow)
 	switch (sk->sk_family) {
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		if (sk->sk_ipv6only ||
+		if (ipv6_only_sock(sk) ||
 		    ipv6_addr_type(&sk->sk_v6_daddr) != IPV6_ADDR_MAPPED) {
 			flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 			flow->addrs.v6addrs.src = inet6_sk(sk)->saddr;
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 59683f79959c..60b648b46f75 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -483,7 +483,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 		tx_info->ip_family = AF_INET;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		if (!sk->sk_ipv6only &&
+		if (!ipv6_only_sock(sk) &&
 		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
 			memcpy(daaddr, &sk->sk_daddr, 4);
 			tx_info->ip_family = AF_INET;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 4c4ee524176c..3ae6067c7e6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -102,7 +102,7 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		if (!sk->sk_ipv6only &&
+		if (!ipv6_only_sock(sk) &&
 		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
 			accel_fs_tcp_set_ipv4_flow(spec, sk);
 			ft = &fs_tcp->tables[ACCEL_FS_IPV4_TCP];
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 84d66d138c3d..78368e71ce83 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -289,7 +289,7 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	switch (sk->sk_family) {
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		if (sk->sk_ipv6only ||
+		if (ipv6_only_sock(sk) ||
 		    ipv6_addr_type(&sk->sk_v6_daddr) != IPV6_ADDR_MAPPED) {
 			req_sz = sizeof(struct nfp_crypto_req_add_v6);
 			ipv6 = true;
diff --git a/net/core/filter.c b/net/core/filter.c
index 143f442a9505..2ed81c48c282 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7099,7 +7099,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 6595a78672c8..70564ddccc46 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -318,7 +318,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		/* Binding to v4-mapped address on a v6-only socket
 		 * makes no sense
 		 */
-		if (sk->sk_ipv6only) {
+		if (ipv6_only_sock(sk)) {
 			err = -EINVAL;
 			goto out;
 		}
-- 
2.30.2

