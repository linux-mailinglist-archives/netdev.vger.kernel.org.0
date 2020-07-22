Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6EF229CF1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgGVQRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730617AbgGVQR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:17:28 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18BAC0619E1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:17:27 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f5so3095299ljj.10
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FcwspamFpLMvy8ptVddtyaKP8RbDMpDsWcPFu9YxmcQ=;
        b=SpoeVVl8tisue+OLBio6OZtxflJQdnksEMEmWldMDhV8185ro33MhaGYUf6O9i8Dgy
         Fc8eruiR19i4OXmzVQT7VT2NfT2Kb9rV2ybXj0yfvgK32bFqxsfU28N7lL4NkxRTAP1+
         8WNEMKS3LNyBZ56DrXxBakVyFyMXG8OgS+G/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FcwspamFpLMvy8ptVddtyaKP8RbDMpDsWcPFu9YxmcQ=;
        b=YouQIbe5p7JTsW1R/rxRgLkhvDHPYmmEXcjPg/q7PwwRNwj7fwHbNMRDc2lqWh9Yvx
         gBiCGlQxakWt2OymIDO+R80TQhE8Sr90mzxvOG6UFQq48jSvhGcYqBTIKYhvr0nH0cvC
         NfeiN5yF4HgjxK4G/KtGYp1GOzglKSDzZUcrEfaoFLBDvkJUCZkWfrXKPgXuR4D0Dair
         pwUG+DcvDhJl+sjQtgVTY0gWhBGiFBqchou8z/hyLDDjTSMW+wEi4ZQh4X/I/b1wMpjC
         QETqeVes9Z2Dd12dqmmOWO9k6B9y8VWQBipzVmr0Paf2k8+HU3KeS0QuoLTQ8Hpl8qDY
         UZDA==
X-Gm-Message-State: AOAM5319VR4vvAyr8RCtLw8pmbiMUSWdKdxK5/ZbE8uzyXoGvJGGWruN
        gSUYkVcdUre5z3aoavlH0G0DTA==
X-Google-Smtp-Source: ABdhPJylAT4P0G7sOyxKYsqThqqUZFpzp88U7GZxPz2Qlkk8+uKrzFFRE2JhqQ2Fo+qw7XTVsAHv/A==
X-Received: by 2002:a2e:8851:: with SMTP id z17mr605ljj.225.1595434646268;
        Wed, 22 Jul 2020 09:17:26 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h26sm285926ljb.78.2020.07.22.09.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 09:17:25 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Test BPF socket lookup and reuseport with connections
Date:   Wed, 22 Jul 2020 18:17:20 +0200
Message-Id: <20200722161720.940831-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200722161720.940831-1-jakub@cloudflare.com>
References: <20200722161720.940831-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cover the case when BPF socket lookup returns a socket that belongs to a
reuseport group, and the reuseport group contains connected UDP sockets.

Ensure that the presence of connected UDP sockets in reuseport group does
not affect the socket lookup result. Socket selected by reuseport should
always be used as result in such case.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sk_lookup.c      | 54 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index f1784ae4565a..9bbd2b2b7630 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -74,6 +74,7 @@ struct test {
 	struct inet_addr connect_to;
 	struct inet_addr listen_at;
 	enum server accept_on;
+	bool reuseport_has_conns; /* Add a connected socket to reuseport group */
 };
 
 static __u32 duration;		/* for CHECK macro */
@@ -559,7 +560,8 @@ static void query_lookup_prog(struct test_sk_lookup *skel)
 
 static void run_lookup_prog(const struct test *t)
 {
-	int client_fd, server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[MAX_SERVERS] = { -1 };
+	int client_fd, reuse_conn_fd = -1;
 	struct bpf_link *lookup_link;
 	int i, err;
 
@@ -583,6 +585,32 @@ static void run_lookup_prog(const struct test *t)
 			break;
 	}
 
+	/* Regular UDP socket lookup with reuseport behaves
+	 * differently when reuseport group contains connected
+	 * sockets. Check that adding a connected UDP socket to the
+	 * reuseport group does not affect how reuseport works with
+	 * BPF socket lookup.
+	 */
+	if (t->reuseport_has_conns) {
+		struct sockaddr_storage addr = {};
+		socklen_t len = sizeof(addr);
+
+		/* Add an extra socket to reuseport group */
+		reuse_conn_fd = make_server(t->sotype, t->listen_at.ip,
+					    t->listen_at.port,
+					    t->reuseport_prog);
+		if (reuse_conn_fd < 0)
+			goto close;
+
+		/* Connect the extra socket to itself */
+		err = getsockname(reuse_conn_fd, (void *)&addr, &len);
+		if (CHECK(err, "getsockname", "errno %d\n", errno))
+			goto close;
+		err = connect(reuse_conn_fd, (void *)&addr, len);
+		if (CHECK(err, "connect", "errno %d\n", errno))
+			goto close;
+	}
+
 	client_fd = make_client(t->sotype, t->connect_to.ip, t->connect_to.port);
 	if (client_fd < 0)
 		goto close;
@@ -594,6 +622,8 @@ static void run_lookup_prog(const struct test *t)
 
 	close(client_fd);
 close:
+	if (reuse_conn_fd != -1)
+		close(reuse_conn_fd);
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
 		if (server_fds[i] != -1)
 			close(server_fds[i]);
@@ -710,6 +740,17 @@ static void test_redirect_lookup(struct test_sk_lookup *skel)
 			.listen_at	= { INT_IP4, INT_PORT },
 			.accept_on	= SERVER_B,
 		},
+		{
+			.desc		= "UDP IPv4 redir and reuseport with conns",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+			.accept_on	= SERVER_B,
+			.reuseport_has_conns = true,
+		},
 		{
 			.desc		= "UDP IPv4 redir skip reuseport",
 			.lookup_prog	= skel->progs.select_sock_a_no_reuseport,
@@ -754,6 +795,17 @@ static void test_redirect_lookup(struct test_sk_lookup *skel)
 			.listen_at	= { INT_IP6, INT_PORT },
 			.accept_on	= SERVER_B,
 		},
+		{
+			.desc		= "UDP IPv6 redir and reuseport with conns",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+			.accept_on	= SERVER_B,
+			.reuseport_has_conns = true,
+		},
 		{
 			.desc		= "UDP IPv6 redir skip reuseport",
 			.lookup_prog	= skel->progs.select_sock_a_no_reuseport,
-- 
2.25.4

