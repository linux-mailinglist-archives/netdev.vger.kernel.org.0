Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF2570EE2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiGLAV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiGLAVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:21:07 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A675E275F0;
        Mon, 11 Jul 2022 17:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585208; x=1689121208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YX2l7XA29Kw3L3bWWv7RUMIV57QqrOrOKubbNqWqxAs=;
  b=sL5z0FJWgDrLENrCg7glIHI4MbZH/yg6GJRAvZUpgbKg40YcKW6ri6f/
   S0nTEql05vT3VIlTVxb0siWOiwJB9zneZWreqkeCMlsgI52E73jzvII8t
   pBCCzD6oXC8xPdPXwA/D9vZfiA77PwB91VGSm7JMw3g1fCzfP2OJpjiys
   g=;
X-IronPort-AV: E=Sophos;i="5.92,264,1650931200"; 
   d="scan'208";a="107136168"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 12 Jul 2022 00:20:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id E728143EB1;
        Tue, 12 Jul 2022 00:20:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:20:06 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:20:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH v1 net 12/15] tcp: Fix data-races around sysctl_tcp_ecn.
Date:   Mon, 11 Jul 2022 17:15:30 -0700
Message-ID: <20220712001533.89927-13-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712001533.89927-1-kuniyu@amazon.com>
References: <20220712001533.89927-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.185]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
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

While reading sysctl_tcp_ecn, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 +-
 net/ipv4/syncookies.c                                       | 2 +-
 net/ipv4/sysctl_net_ipv4.c                                  | 2 ++
 net/ipv4/tcp_input.c                                        | 2 +-
 net/ipv4/tcp_output.c                                       | 2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 4af5561cbfc5..7c760aa65540 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1392,7 +1392,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	th_ecn = tcph->ece && tcph->cwr;
 	if (th_ecn) {
 		ect = !INET_ECN_is_not_ect(ip_dsfield);
-		ecn_ok = sock_net(sk)->ipv4.sysctl_tcp_ecn;
+		ecn_ok = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn);
 		if ((!ect && ecn_ok) || tcp_ca_needs_ecn(sk))
 			inet_rsk(oreq)->ecn_ok = 1;
 	}
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index f33c31dd7366..b387c4835155 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -273,7 +273,7 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 	if (!ecn_ok)
 		return false;
 
-	if (net->ipv4.sysctl_tcp_ecn)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_ecn))
 		return true;
 
 	return dst_feature(dst, RTAX_FEATURE_ECN);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 66159d49a575..5e308c1715af 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -676,6 +676,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2e2a9ece9af2..3ec4edc37313 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6729,7 +6729,7 @@ static void tcp_ecn_create_request(struct request_sock *req,
 
 	ect = !INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield);
 	ecn_ok_dst = dst_feature(dst, DST_FEATURE_ECN_MASK);
-	ecn_ok = net->ipv4.sysctl_tcp_ecn || ecn_ok_dst;
+	ecn_ok = READ_ONCE(net->ipv4.sysctl_tcp_ecn) || ecn_ok_dst;
 
 	if (((!ect || th->res1) && ecn_ok) || tcp_ca_needs_ecn(listen_sk) ||
 	    (ecn_ok_dst & DST_FEATURE_ECN_CA) ||
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1c054431e358..3dc17551ce25 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -324,7 +324,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool bpf_needs_ecn = tcp_bpf_ca_needs_ecn(sk);
-	bool use_ecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 1 ||
+	bool use_ecn = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn) == 1 ||
 		tcp_ca_needs_ecn(sk) || bpf_needs_ecn;
 
 	if (!use_ecn) {
-- 
2.30.2

