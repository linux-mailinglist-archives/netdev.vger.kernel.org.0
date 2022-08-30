Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C413D5A6CA4
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiH3S5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiH3S5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:57:08 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D607755B
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:57:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h13-20020a17090a648d00b001fdb9003787so7421125pjj.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=JSxjBTt0wt4MjUpbSELuAIRIAPSDtw+rk/Q90zhO1yc=;
        b=cFxRjfJgJfgVIf6+k//A9BkSlkXboEjAql6+V+ci49dGSqRK573Nfyglnvue7t+UBs
         FxyQHB/8Vv6ppdGNzmQrsKJmITkVMxM/250ffxTU2/3YRAD6btbSXBZrvtoHOleORz6n
         EHsW+vfH3cxLzKYWKuCZCEifpK4WjOZraGgXF0kDZ7B3he0UwwN2pBWY/e3Mu2NRh++K
         G2QYwYvkANFSFnwSoUhOdvwaQQyw/Vtlp6Dr3TB+fpoeYYm3p1B5Ydu/UZHVI6SYLNJ6
         vPq8W+eusIBFWZMgx324y7olbczKMxSX6vgnDZ+RlNvfh3QESzOgrv0yKAmr75uX7JL4
         ko6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=JSxjBTt0wt4MjUpbSELuAIRIAPSDtw+rk/Q90zhO1yc=;
        b=BeDfijCTCzIIDjvrXxzQA0XcOvaNhmVL311C5x7sob5lXX7qACFHfmSJU54T+B8jo0
         25w01s8AlIDwOVO8EEploBezwdPJDjpJNtijCu29t4wKN5mPdIpRmOnBXEbtNG5ord1G
         tiZkv0G61ZayfH3VnxXcl/dg8G4x6kziDQgbOUa7tWRZ3OHj5OghCpxxkGaw9Uy9V5el
         aMEv6aTSeyQ+VTQjzfclZu+GIhP2SU5g8no3Jh5ZtABsbTAmh6rUWWxOB0M6AC6hfIqo
         KH9t8Sid+Q/rvuomChxzLORgHWS4uJGIUmDohsSQhnC+Yss16BjQBeTWQNQ9jEbnErSd
         7olw==
X-Gm-Message-State: ACgBeo1/KXbb+/lG7OoPBzCyj3EqFvL0knrSlr3gFrDKR1pQ3O8q13IT
        EK6NKqWGBcvy5dJqSGCixJU=
X-Google-Smtp-Source: AA6agR7PbVJUPyov/37ee23oRJzF1Gj25B43YMBWTjZzPfK1OmOpSXTNGfUT1muMBoYnkZZmEF+BAw==
X-Received: by 2002:a17:90a:6b0d:b0:1fa:c6fe:db6 with SMTP id v13-20020a17090a6b0d00b001fac6fe0db6mr24935146pjj.99.1661885824347;
        Tue, 30 Aug 2022 11:57:04 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6f37:1040:8972:152e])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b00173164792aasm10085449pln.127.2022.08.30.11.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 11:57:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 2/2] tcp: make global challenge ack rate limitation per net-ns and default disabled
Date:   Tue, 30 Aug 2022 11:56:56 -0700
Message-Id: <20220830185656.268523-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
In-Reply-To: <20220830185656.268523-1-eric.dumazet@gmail.com>
References: <20220830185656.268523-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Because per host rate limiting has been proven problematic (side channel
attacks can be based on it), per host rate limiting of challenge acks ideally
should be per netns and turned off by default.

This is a long due followup of following commits:

083ae308280d ("tcp: enable per-socket rate limiting of all 'challenge acks'")
f2b2c582e824 ("tcp: mitigate ACK loops for connections as tcp_sock")
75ff39ccc1bd ("tcp: make challenge acks less predictable")

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 Documentation/networking/ip-sysctl.rst |  5 ++++-
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/tcp_input.c                   | 21 +++++++++++----------
 net/ipv4/tcp_ipv4.c                    |  6 ++++--
 4 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 56cd4ea059b2a33cde01d8db598b160762db1478..a759872a2883bbce925833007a540f06c68a9442 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1035,7 +1035,10 @@ tcp_limit_output_bytes - INTEGER
 tcp_challenge_ack_limit - INTEGER
 	Limits number of Challenge ACK sent per second, as recommended
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
-	Default: 1000
+	Note that this per netns rate limit can allow some side channel
+	attacks and probably should not be enabled.
+	TCP stack implements per TCP socket limits anyway.
+	Default: INT_MAX (unlimited)
 
 UDP variables
 =============
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c7320ef356d940aefba708ea98de502253d2b04d..6320a76cefdcdf6232b7a94ddd0c4a433084887d 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -179,6 +179,8 @@ struct netns_ipv4 {
 	unsigned int sysctl_tcp_fastopen_blackhole_timeout;
 	atomic_t tfo_active_disable_times;
 	unsigned long tfo_active_disable_stamp;
+	u32 tcp_challenge_timestamp;
+	u32 tcp_challenge_count;
 
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c184e15397a28ccfbac142ff0f1d05d555623147..b85a9f755da41505b35bc64e1fa8995581660e90 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3614,12 +3614,9 @@ bool tcp_oow_rate_limited(struct net *net, const struct sk_buff *skb,
 /* RFC 5961 7 [ACK Throttling] */
 static void tcp_send_challenge_ack(struct sock *sk)
 {
-	/* unprotected vars, we dont care of overwrites */
-	static u32 challenge_timestamp;
-	static unsigned int challenge_count;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
-	u32 count, now;
+	u32 count, now, ack_limit;
 
 	/* First check our per-socket dupack rate limit. */
 	if (__tcp_oow_rate_limited(net,
@@ -3627,18 +3624,22 @@ static void tcp_send_challenge_ack(struct sock *sk)
 				   &tp->last_oow_ack_time))
 		return;
 
+	ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
+	if (ack_limit == INT_MAX)
+		goto send_ack;
+
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
-	if (now != READ_ONCE(challenge_timestamp)) {
-		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
+	if (now != READ_ONCE(net->ipv4.tcp_challenge_timestamp)) {
 		u32 half = (ack_limit + 1) >> 1;
 
-		WRITE_ONCE(challenge_timestamp, now);
-		WRITE_ONCE(challenge_count, half + prandom_u32_max(ack_limit));
+		WRITE_ONCE(net->ipv4.tcp_challenge_timestamp, now);
+		WRITE_ONCE(net->ipv4.tcp_challenge_count, half + prandom_u32_max(ack_limit));
 	}
-	count = READ_ONCE(challenge_count);
+	count = READ_ONCE(net->ipv4.tcp_challenge_count);
 	if (count > 0) {
-		WRITE_ONCE(challenge_count, count - 1);
+		WRITE_ONCE(net->ipv4.tcp_challenge_count, count - 1);
+send_ack:
 		NET_INC_STATS(net, LINUX_MIB_TCPCHALLENGEACK);
 		tcp_send_ack(sk);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0c83780dc9bf4293135b8044daf41090b66f8b08..5b019ba2b9d2155b6d612727d32c89433d19be03 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3139,8 +3139,10 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_tso_win_divisor = 3;
 	/* Default TSQ limit of 16 TSO segments */
 	net->ipv4.sysctl_tcp_limit_output_bytes = 16 * 65536;
-	/* rfc5961 challenge ack rate limiting */
-	net->ipv4.sysctl_tcp_challenge_ack_limit = 1000;
+
+	/* rfc5961 challenge ack rate limiting, per net-ns, disabled by default. */
+	net->ipv4.sysctl_tcp_challenge_ack_limit = INT_MAX;
+
 	net->ipv4.sysctl_tcp_min_tso_segs = 2;
 	net->ipv4.sysctl_tcp_tso_rtt_log = 9;  /* 2^9 = 512 usec */
 	net->ipv4.sysctl_tcp_min_rtt_wlen = 300;
-- 
2.37.2.672.g94769d06f0-goog

