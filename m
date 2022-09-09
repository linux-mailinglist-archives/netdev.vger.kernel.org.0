Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06D35B2B2E
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 02:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiIIAuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 20:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIIAuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 20:50:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2FF6B65C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 17:50:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f12-20020a25b6cc000000b0069a9e36de26so308699ybm.16
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 17:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=7JzQvNuV+huKghBCFvtgwncICdsG5n37tZbHNby+uDE=;
        b=KgoEPAM3+QykS7sDbHjAfmjHK056pCk9bgrq46VkaGJEwuUr+Et2rWiWpQdNOMzLl+
         OHLgmz3GXoEu19Mm7KObu4SXUDtfNORDafFUS7IwQLMOBy2CMw5UL5F9qsUVEiKXACZI
         uP3LatSY3Lho1FrblrQvxkzBvktZEga4ToUY5XQ9bT2ayFL79PiDYBsIL/OYdYv9fLsr
         AuEkK7IdQiVJqLK+2fHyUvbxPMyszdsHe5X83GlQiENBTMuUHHHIlY3+otjxRDzT04JB
         3/ArW3UqgGY8WnDtpr1HyghgsJ5rsdZ1cd/U4pJPRm6nNe8HgwBKFxNBtaPI5xR7Ftt8
         knZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=7JzQvNuV+huKghBCFvtgwncICdsG5n37tZbHNby+uDE=;
        b=TIIt63p2AGw3+nQxBL5e1eegRtkUlRyaG8xewHfIlmI0ARJ1C4FJakHXdmMaUvH4ds
         M/lkGgWE8/zW93VsZ5QBajAhCmJfvAO4Hk/0mPQU/QNPu4ZlYg5dpTMf4u4pPikgRGoO
         HFi0xJjITbY676Z9l0zVctXmK06VsG8qiF6g4MC/wLdQizajX7FUIIC13j6/DrSF3E7U
         OSxFvgj1gJ5rjNBsaSwVUhi/ew5ip6NowMKo8SacY/umRFO5AezdaBm0DBXwvy2+lHcE
         YqHR/fEl6rYGeNlduz9uTv70kDBG9mkO61Wts+jzedjpd2DrljqB8bmSWNv2/EMSS7fz
         FbIQ==
X-Gm-Message-State: ACgBeo2N5J+susbPF4WuL2D7cDgOlQV34h1O2r80yofHX6n4EPrFADQD
        EKjMjlDK1L4OVaabQRuYTHmXteBdqRrh/A==
X-Google-Smtp-Source: AA6agR4NaDGITRlVUJv8kUwJ88xUpvK223VI6fF3uWm7HOdggflL5x07gzrOgivwN9S564qsiptFUFnxpbxJpw==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a81:66c5:0:b0:345:3b1c:26 with SMTP id
 a188-20020a8166c5000000b003453b1c0026mr10761617ywc.156.1662684606434; Thu, 08
 Sep 2022 17:50:06 -0700 (PDT)
Date:   Fri,  9 Sep 2022 00:49:39 +0000
In-Reply-To: <cover.1662682323.git.zhuyifei@google.com>
Mime-Version: 1.0
References: <cover.1662682323.git.zhuyifei@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <5764914c252fad4cd134fb6664c6ede95f409412.1662682323.git.zhuyifei@google.com>
Subject: [PATCH v4 bpf-next 1/3] bpf: Invoke cgroup/connect{4,6} programs for
 unprivileged ICMP ping
From:   YiFei Zhu <zhuyifei@google.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually when a TCP/UDP connection is initiated, we can bind the socket
to a specific IP attached to an interface in a cgroup/connect hook.
But for pings, this is impossible, as the hook is not being called.

This adds the hook invocation to unprivileged ICMP ping (i.e. ping
sockets created with SOCK_DGRAM IPPROTO_ICMP(V6) as opposed to
SOCK_RAW. Logic is mirrored from UDP sockets where the hook is invoked
during pre_connect, after a check for suficiently sized addr_len.

Signed-off-by: YiFei Zhu <zhuyifei@google.com>
---
 net/ipv4/ping.c | 15 +++++++++++++++
 net/ipv6/ping.c | 16 ++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b83c2bd9d7223..517042caf6dc1 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -33,6 +33,7 @@
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/export.h>
+#include <linux/bpf-cgroup.h>
 #include <net/sock.h>
 #include <net/ping.h>
 #include <net/udp.h>
@@ -295,6 +296,19 @@ void ping_close(struct sock *sk, long timeout)
 }
 EXPORT_SYMBOL_GPL(ping_close);
 
+static int ping_pre_connect(struct sock *sk, struct sockaddr *uaddr,
+			    int addr_len)
+{
+	/* This check is replicated from __ip4_datagram_connect() and
+	 * intended to prevent BPF program called below from accessing bytes
+	 * that are out of the bound specified by user in addr_len.
+	 */
+	if (addr_len < sizeof(struct sockaddr_in))
+		return -EINVAL;
+
+	return BPF_CGROUP_RUN_PROG_INET4_CONNECT_LOCK(sk, uaddr);
+}
+
 /* Checks the bind address and possibly modifies sk->sk_bound_dev_if. */
 static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 				struct sockaddr *uaddr, int addr_len)
@@ -1009,6 +1023,7 @@ struct proto ping_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.pre_connect =	ping_pre_connect,
 	.connect =	ip4_datagram_connect,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ip_setsockopt,
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 91b8405146569..5f2ef84937142 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -20,6 +20,7 @@
 #include <net/udp.h>
 #include <net/transp_v6.h>
 #include <linux/proc_fs.h>
+#include <linux/bpf-cgroup.h>
 #include <net/ping.h>
 
 static void ping_v6_destroy(struct sock *sk)
@@ -49,6 +50,20 @@ static int dummy_ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
 	return 0;
 }
 
+static int ping_v6_pre_connect(struct sock *sk, struct sockaddr *uaddr,
+			       int addr_len)
+{
+	/* This check is replicated from __ip6_datagram_connect() and
+	 * intended to prevent BPF program called below from accessing
+	 * bytes that are out of the bound specified by user in addr_len.
+	 */
+
+	if (addr_len < SIN6_LEN_RFC2133)
+		return -EINVAL;
+
+	return BPF_CGROUP_RUN_PROG_INET6_CONNECT_LOCK(sk, uaddr);
+}
+
 static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct inet_sock *inet = inet_sk(sk);
@@ -191,6 +206,7 @@ struct proto pingv6_prot = {
 	.init =		ping_init_sock,
 	.close =	ping_close,
 	.destroy =	ping_v6_destroy,
+	.pre_connect =	ping_v6_pre_connect,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
-- 
2.37.2.789.g6183377224-goog

