Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537362CC3A3
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389209AbgLBR0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgLBR0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:26:39 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A71C061A04
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:25:23 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m20so1413614pls.21
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4fyW4PdsAf3y8jKosx1QzxVmD8jzD3SrciIUx0NWIe8=;
        b=ovXXdjb+F9BfVp6RKGdXUkNOVLod8jcsDh2z5S6POIE6oK8sKkXAxX6i3VmU8a8TKo
         zP2vRVuO/ZCgZMENwQgRSCPNVaDpxFE+UGd4l8ca8n2EgrdcTrVmLoqyxxfhBkbySMcU
         ZytUYvC+XJNSAgd2Iq++h+nBTXUkVIgSM9lgsTbW2dRHrRlORVtHquT4SMLfzCK87IKI
         3URKP523+3lHYoJb2KkhLb3vxtINtS//WQozrHobXf8v6/dQhDcYAqG54t8tJrgSFgs3
         wOzAdKq8rnx12xVoM1CDJtlv1meqLYyQnuCHCzW8ZO8CvE2JMq5iiO/QQ5OkLluH5MPD
         aCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4fyW4PdsAf3y8jKosx1QzxVmD8jzD3SrciIUx0NWIe8=;
        b=R1QJLCHazZegfNRXj0ge+XEzi/BPSs/rXW9peG4lXIP3wDfD/mLpOe0I+pOIvxpkms
         q2KHPSdwkfD2Xp+WDFs3opB2mkpeyiu54HotV48ib8muTza1K2PFo4XMqAeu4hdWEo05
         WaQixY3t1dmCXgRKuptQ0urMJBlZ+KGDyBz/30vebNOZsuq0sxdfrjvTYJy+HR6jeHET
         TL1+GNnLDt+E6yxQ7H+f4qvHsIyHoGaDjdcizLOqXdM+jryoSusXCsffKrUkuX2air7D
         Ev4zrvTtsT7zHmeDawfH7f120nmtAy32HQtkdQTCvpdWLgu/4x9vBXvYrJqW3RDRnvDK
         RJtQ==
X-Gm-Message-State: AOAM533PwTVtnyG0NuGAnqPH8OOVbTgQvQUGwMFd9CerW2vCqzlu89R6
        u6dD2CKstEWYEvwEDVpWeddoFDIXIrvnXN0MH23s3MyTflYfMYvAmmUifOjFFGtPIXw1MwU7KgY
        WFFiGbhlDfnBYdReD5rf0XVtMgdmQ9SA5jan0CH69IpzeZxpIjeUdsA==
X-Google-Smtp-Source: ABdhPJybIuKzj/Yq60VUaeeS/QoexPkvL8AU+rbDlfTAwGaTupHVtiqdKGOhJJUca6M/FSCtobHh3Jc=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90a:460a:: with SMTP id
 w10mr342625pjg.1.1606929922231; Wed, 02 Dec 2020 09:25:22 -0800 (PST)
Date:   Wed,  2 Dec 2020 09:25:15 -0800
In-Reply-To: <20201202172516.3483656-1-sdf@google.com>
Message-Id: <20201202172516.3483656-3-sdf@google.com>
Mime-Version: 1.0
References: <20201202172516.3483656-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have to now lock/unlock socket for the bind hook execution.
That shouldn't cause any overhead because the socket is unbound
and shouldn't receive any traffic.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
---
 include/linux/bpf-cgroup.h | 12 ++++++------
 net/core/filter.c          |  4 ++++
 net/ipv4/af_inet.c         |  2 +-
 net/ipv6/af_inet6.c        |  2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index ed71bd1a0825..72e69a0e1e8c 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -246,11 +246,11 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
-#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr)			       \
-	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET4_BIND)
+#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)			       \
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
 
-#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr)			       \
-	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET6_BIND)
+#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
 
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
 					    sk->sk_prot->pre_connect)
@@ -434,8 +434,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
-#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr) ({ 0; })
-#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..21d91dcf0260 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6995,6 +6995,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_delete_proto;
 	case BPF_FUNC_setsockopt:
 		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_BIND:
+		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
 			return &bpf_sock_addr_setsockopt_proto;
@@ -7003,6 +7005,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		}
 	case BPF_FUNC_getsockopt:
 		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_BIND:
+		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
 			return &bpf_sock_addr_getsockopt_proto;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b7260c8cef2e..b94fa8eb831b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -450,7 +450,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	/* BPF prog is run before any checks are done so that if the prog
 	 * changes context in a wrong way it will be caught.
 	 */
-	err = BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr);
+	err = BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr);
 	if (err)
 		return err;
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb167..a7e3d170af51 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -451,7 +451,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	/* BPF prog is run before any checks are done so that if the prog
 	 * changes context in a wrong way it will be caught.
 	 */
-	err = BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr);
+	err = BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr);
 	if (err)
 		return err;
 
-- 
2.29.2.454.gaff20da3a2-goog

