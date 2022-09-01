Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43F65A9FB3
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbiIATQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiIATQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:16:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D416F6F568
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 12:16:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i191-20020a6387c8000000b0042b44ad723bso8999782pge.19
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 12:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=7JzQvNuV+huKghBCFvtgwncICdsG5n37tZbHNby+uDE=;
        b=Dp4wEGVqxVOJ7JfOYRoFQl6c0FEA7yyWZTp2hBXRzQc66vJcLSh8oTWsCIymHNABrg
         4FjYLyQAV6hfpSbiDSW3gv/f6ZANEi6mB5QPrh4coeMCujZnA/DzUpWo0tWzClX+9S9S
         bDNqqdkK8FegHW18ORmmmWk/r3PaUjZlJbPmCcvMXL1T6Zrhg7m1+0UWuDuWyAMyYFaf
         +vAA7OrofT3poyv8OmdoyNnVevkWuwGSpMqEnoJDRqjCDCjjlM0XlwxiYUmHsGUUflAN
         lnpoKQuY+frNKjwjFPJ+5RlyQm/IyKTAfakPfHgVjqmtTWwGPTR7BPFRuwcaa8VbPWYh
         HFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=7JzQvNuV+huKghBCFvtgwncICdsG5n37tZbHNby+uDE=;
        b=1i9mOpOleXOmSXc4QkWAbhyx9ai8aYGCj5ZgaTFYNcgcFqgWq6Fpv0htspB1Koza+F
         hBQrasZwnmam/LZxeS4U9+/q4zNJbIu/9ZSgwrPDa0MGWsyx4FeudEWBFI0qwzw/68oi
         jGGvjuOueIn6X/GW9JaVEBLjNQH5MpBU2RDs/tpcWFYSFIcl6drhUjqS7tfPVPJdJkmQ
         xYsyUxoJN73DU0Wus1BBS+VoVksTPTRt9e+JA/ypvooZWnM57lY4P+HLUUvktKSdW39f
         lOMGJcpa8Azbeogxtq+AAkMzuZ3mJnRPaRNQik1NUJurKkHX8cSMhSM6OcNX7dW76u47
         1tEg==
X-Gm-Message-State: ACgBeo3Xq2ImLzqbUmjO84naGnGJo+EGu13brbt8N12LteaQ/hzv6m7R
        pfi1yPppKkIkmZd0OKlGuTEzbpBL5jpQqg==
X-Google-Smtp-Source: AA6agR6FS0gs2xXD+xmLyoB6AqKZ2eajhrPQKKrj9IR76uOm/z3lD27VvNTk9Rz6sbjOLV8YA8tu5zvPEYXyEA==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a05:6a00:1687:b0:518:6c6b:6a9a with SMTP
 id k7-20020a056a00168700b005186c6b6a9amr33119678pfc.81.1662059760491; Thu, 01
 Sep 2022 12:16:00 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:15:09 +0000
In-Reply-To: <cover.1662058674.git.zhuyifei@google.com>
Mime-Version: 1.0
References: <cover.1662058674.git.zhuyifei@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <5764914c252fad4cd134fb6664c6ede95f409412.1662058674.git.zhuyifei@google.com>
Subject: [PATCH bpf-next 1/2] bpf: Invoke cgroup/connect{4,6} programs for
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

