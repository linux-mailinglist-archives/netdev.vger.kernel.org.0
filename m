Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4431B4C5E97
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 21:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiB0U2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 15:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiB0U2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 15:28:39 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4123ED3E
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 12:28:01 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id l12so2857471ljh.12
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 12:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HcX6QIHBexFnM7/ZWxha4rDjE47zmHJGP0UcfZC2560=;
        b=gQM/q0fzcSYIYJwkT6qKUzrvOnhj6iEMs1hQslqLe2dTX9YJYPMnRWZGmTAOC81AY4
         P8uUQeg8i3ZJB+sbbE2MzJTBW6VaLFR0ENEo7NIIokXgXSZtdXOnyzCZWwfUkCXEa2jZ
         TCT82eigO2QEJ6IfY4RJowpGjORFLNEivi6n0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HcX6QIHBexFnM7/ZWxha4rDjE47zmHJGP0UcfZC2560=;
        b=KuN5nM+FPNslwIYZUFrXFLwWWhO0dICVMlzOnj6RK0JEtxNmOlwUxWjSltFzv/3ceG
         iCXqTWwxVIYTFi2tHDn58p45Wc99+HQ+VZ5To3bO55DYYfmQTgCs6iLlTQr/E/49AU4O
         zbb3G9hUZ4zds3BFzozmLrw3Cdsait/R+QmlOvi8XT+iBNTzsHMz/j34qyHhkNhRpyvX
         aB+ICQJdhqTdoBvpZ/nMQtvKWP8BMSsXa+ATt6ul5aDAGC4OrMOrDJ4XFFgXSpMGtACf
         t58YqfD/nFCzOPsd/ufjwVWQ/HZIQw5U+OIjqbSLoUUVxANvnU75j2NfO1/Dev/j4v9e
         8uSg==
X-Gm-Message-State: AOAM533UYBUV2VbSDeTRJ16RhwZaBqxgLk4cvidJwhpYe2uvUkglSNpy
        mwczE7RGO6MljuKZVYTo3HMeFw==
X-Google-Smtp-Source: ABdhPJx1y59iwtFIH2K6sqVTbgJgt53EYQL4uaLHm0VMbPbdlpoOAOwVJdKfcgDCC5773pUt00AnKg==
X-Received: by 2002:a2e:94c:0:b0:246:3922:7bec with SMTP id 73-20020a2e094c000000b0024639227becmr12247514ljj.430.1645993680246;
        Sun, 27 Feb 2022 12:28:00 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id 22-20020a05651c009600b002447ce4b34esm1034472ljq.116.2022.02.27.12.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 12:27:59 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Martin KaFai Lau <kafai@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf-next v2 2/3] selftests/bpf: Check dst_port only on the client socket
Date:   Sun, 27 Feb 2022 21:27:56 +0100
Message-Id: <20220227202757.519015-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220227202757.519015-1-jakub@cloudflare.com>
References: <20220227202757.519015-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgroup_skb/egress programs which sock_fields test installs process packets
flying in both directions, from the client to the server, and in reverse
direction.

Recently added dst_port check relies on the fact that destination
port (remote peer port) of the socket which sends the packet is known ahead
of time. This holds true only for the client socket, which connects to the
known server port.

Filter out any traffic that is not bound to be egressing from the client
socket in the test program for reading the dst_port.

Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../testing/selftests/bpf/progs/test_sock_fields.c  | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
index 3e2e3ee51cc9..186fed1deaab 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -42,6 +42,11 @@ struct {
 	__type(value, struct bpf_spinlock_cnt);
 } sk_pkt_out_cnt10 SEC(".maps");
 
+enum {
+	TCP_SYN_SENT = 2,
+	TCP_LISTEN = 10,
+};
+
 struct bpf_tcp_sock listen_tp = {};
 struct sockaddr_in6 srv_sa6 = {};
 struct bpf_tcp_sock cli_tp = {};
@@ -138,7 +143,7 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	 * TCP_LISTEN (10) socket will be copied at the ingress side.
 	 */
 	if (sk->family != AF_INET6 || !is_loopback6(sk->src_ip6) ||
-	    sk->state == 10)
+	    sk->state == TCP_LISTEN)
 		return CG_OK;
 
 	if (sk->src_port == bpf_ntohs(srv_sa6.sin6_port)) {
@@ -233,7 +238,7 @@ int ingress_read_sock_fields(struct __sk_buff *skb)
 		return CG_OK;
 
 	/* Only interested in TCP_LISTEN */
-	if (sk->state != 10)
+	if (sk->state != TCP_LISTEN)
 		return CG_OK;
 
 	/* It must be a fullsock for cgroup_skb/ingress prog */
@@ -281,6 +286,10 @@ int read_sk_dst_port(struct __sk_buff *skb)
 	if (!sk)
 		RET_LOG();
 
+	/* Ignore everything but the SYN from the client socket */
+	if (sk->state != TCP_SYN_SENT)
+		return CG_OK;
+
 	if (!sk_dst_port__load_word(sk))
 		RET_LOG();
 	if (!sk_dst_port__load_half(sk))
-- 
2.35.1

