Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CB16E887B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbjDTDNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbjDTDNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:13:30 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A873ABD;
        Wed, 19 Apr 2023 20:13:08 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Q22gl27TCz17TfZ;
        Thu, 20 Apr 2023 11:09:23 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 11:13:06 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 4.19 4/5] dccp: Call inet6_destroy_sock() via sk->sk_destruct().
Date:   Thu, 20 Apr 2023 11:13:03 +0800
Message-ID: <9c8ab62821ed56ba0ea082eac0e8c13dcbfa8aa4.1681893438.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1681893438.git.william.xuanziyang@huawei.com>
References: <cover.1681893438.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 1651951ebea54970e0bda60c638fc2eee7a6218f upstream.

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

DCCP sets its own sk->sk_destruct() in the dccp_init_sock(), and
DCCPv6 socket shares it by calling the same init function via
dccp_v6_init_sock().

To call inet6_sock_destruct() from DCCPv6 sk->sk_destruct(), we
export it and set dccp_v6_sk_destruct() in the init function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/dccp/dccp.h     |  1 +
 net/dccp/ipv6.c     | 15 ++++++++-------
 net/dccp/proto.c    |  8 +++++++-
 net/ipv6/af_inet6.c |  1 +
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index aec3c724665f..579f39e0d02e 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -291,6 +291,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 int dccp_rcv_established(struct sock *sk, struct sk_buff *skb,
 			 const struct dccp_hdr *dh, const unsigned int len);
 
+void dccp_destruct_common(struct sock *sk);
 int dccp_init_sock(struct sock *sk, const __u8 ctl_sock_initialized);
 void dccp_destroy_sock(struct sock *sk);
 
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b2a26e41f932..88732ab4887c 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1000,6 +1000,12 @@ static const struct inet_connection_sock_af_ops dccp_ipv6_mapped = {
 #endif
 };
 
+static void dccp_v6_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
 /* NOTE: A lot of things set to zero explicitly by call to
  *       sk_alloc() so need not be done here.
  */
@@ -1012,17 +1018,12 @@ static int dccp_v6_init_sock(struct sock *sk)
 		if (unlikely(!dccp_v6_ctl_sock_initialized))
 			dccp_v6_ctl_sock_initialized = 1;
 		inet_csk(sk)->icsk_af_ops = &dccp_ipv6_af_ops;
+		sk->sk_destruct = dccp_v6_sk_destruct;
 	}
 
 	return err;
 }
 
-static void dccp_v6_destroy_sock(struct sock *sk)
-{
-	dccp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct timewait_sock_ops dccp6_timewait_sock_ops = {
 	.twsk_obj_size	= sizeof(struct dccp6_timewait_sock),
 };
@@ -1045,7 +1046,7 @@ static struct proto dccp_v6_prot = {
 	.accept		   = inet_csk_accept,
 	.get_port	   = inet_csk_get_port,
 	.shutdown	   = dccp_shutdown,
-	.destroy	   = dccp_v6_destroy_sock,
+	.destroy	   = dccp_destroy_sock,
 	.orphan_count	   = &dccp_orphan_count,
 	.max_header	   = MAX_DCCP_HEADER,
 	.obj_size	   = sizeof(struct dccp6_sock),
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index dbbcf50aea35..673502779933 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -174,12 +174,18 @@ const char *dccp_packet_name(const int type)
 
 EXPORT_SYMBOL_GPL(dccp_packet_name);
 
-static void dccp_sk_destruct(struct sock *sk)
+void dccp_destruct_common(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
 	ccid_hc_tx_delete(dp->dccps_hc_tx_ccid, sk);
 	dp->dccps_hc_tx_ccid = NULL;
+}
+EXPORT_SYMBOL_GPL(dccp_destruct_common);
+
+static void dccp_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 5a07d9b7b086..c8f39d61b51e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -112,6 +112,7 @@ void inet6_sock_destruct(struct sock *sk)
 	inet6_cleanup_sock(sk);
 	inet_sock_destruct(sk);
 }
+EXPORT_SYMBOL_GPL(inet6_sock_destruct);
 
 static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
-- 
2.25.1

