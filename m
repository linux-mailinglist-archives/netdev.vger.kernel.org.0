Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A8136AACF
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhDZCvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhDZCu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:50:59 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FB8C06138B;
        Sun, 25 Apr 2021 19:50:16 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id o21so12528683qtp.7;
        Sun, 25 Apr 2021 19:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9RuAWLNCN2JVn8Ey2mCpSMGRVaX3wYjjsWZPW7i+saA=;
        b=iuTxBUa/7HnPdhECQDN3rFrc6qyx6a8p4OlKO8gsud+f4JX1JmyTU7Ya6pTVp74xXR
         KddtwktaMn4Y6JbtVTQEDoumiMipBLBx80nlwcdyPtLDqJP8kD1VKuVmApZfaPIKMKHU
         BqgncSUGZPsq1X6HCA4L0O9FVaVIhGHzjYqoBmCsErXYCq8g4zv2mJ84T4HIUuTDCBN2
         yMRVSsySrGb9O4Ag9WFcP3LMhfqOxK+K2EIhTd0mdnew4vpT0MdBs/BA8htW5YH7E4aX
         Bmv+3NGSo8sKV29nDL1tgbxTvUA84alxQnbtmUO9ocRSjKXXd4JSYD/WwDc73W/7BISz
         1FAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9RuAWLNCN2JVn8Ey2mCpSMGRVaX3wYjjsWZPW7i+saA=;
        b=s28X59kqOpAYFq1HOlLMxcwQr5AOeODFjkBmvOA2yUzQ2jbnSoNmmzJ6CyUd6trx8q
         4FgoOtGAzYG3aFKBCsg++sCko0nop1awF75PdJ/fO7at9QlNldShqrS7n7P0vwo69v6x
         Uh8SRSB1U+SN41PB68KGEp1vaPS+T9ZOvujUFCYy4T22+ovMPBJJMX/9zC2g2hmouziw
         u02sYjXnsG/Fg7Iqb2qrB1SQidprO2l51GzQq6E/d53rz029OLAku3sWdhnGYTtq5An2
         wMnWEXOqbRCW/BoHvXw2yqqIbrXmzwtnTCNHiTsfIrO05LOvLk4WMxIS9HNvURrGY8yD
         PBcQ==
X-Gm-Message-State: AOAM530/WFE7TjsLnwPIMTqbbPGf4R2Fp+jeKImeFpQiI6kw2hN2j3vI
        vIaiOvn4MsfrJqRILWFxVaddWWeD7kdF5w==
X-Google-Smtp-Source: ABdhPJwlCvnxkKp3E27lWFZ+Mfyp7t0yInemraRTL/I6ikHobw5gZTBONy67nmNN13yST14QHZ1sUg==
X-Received: by 2002:ac8:7d4d:: with SMTP id h13mr1816175qtb.263.1619405415842;
        Sun, 25 Apr 2021 19:50:15 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 03/10] af_unix: implement ->psock_update_sk_prot()
Date:   Sun, 25 Apr 2021 19:49:54 -0700
Message-Id: <20210426025001.7899-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

unix_proto is special, it is very different from INET proto,
which even does not have a ->close(). We have to add a dummy
one to satisfy sockmap.

And now we can implement unix_bpf_update_proto() to update
sk_prot.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 MAINTAINERS           |  1 +
 include/net/af_unix.h | 10 +++++++++
 net/core/sock_map.c   |  1 +
 net/unix/Makefile     |  1 +
 net/unix/af_unix.c    | 12 ++++++++++-
 net/unix/unix_bpf.c   | 47 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 71 insertions(+), 1 deletion(-)
 create mode 100644 net/unix/unix_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 217c7470bfa9..02532e11da5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10000,6 +10000,7 @@ F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
 F:	net/ipv4/udp_bpf.c
+F:	net/unix/unix_bpf.c
 
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index f42fdddecd41..cca645846af1 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -89,4 +89,14 @@ void unix_sysctl_unregister(struct net *net);
 static inline int unix_sysctl_register(struct net *net) { return 0; }
 static inline void unix_sysctl_unregister(struct net *net) {}
 #endif
+
+#ifdef CONFIG_BPF_SYSCALL
+extern struct proto unix_proto;
+
+int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+void __init unix_bpf_build_proto(void);
+#else
+static inline void __init unix_bpf_build_proto(void)
+{}
+#endif
 #endif
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6f1b82b8ad49..1107c9dcc969 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1536,6 +1536,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
+EXPORT_SYMBOL_GPL(sock_map_close);
 
 static int sock_map_iter_attach_target(struct bpf_prog *prog,
 				       union bpf_iter_link_info *linfo,
diff --git a/net/unix/Makefile b/net/unix/Makefile
index 54e58cc4f945..20491825b4d0 100644
--- a/net/unix/Makefile
+++ b/net/unix/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_UNIX)	+= unix.o
 
 unix-y			:= af_unix.o garbage.o
 unix-$(CONFIG_SYSCTL)	+= sysctl_net_unix.o
+unix-$(CONFIG_BPF_SYSCALL) += unix_bpf.o
 
 obj-$(CONFIG_UNIX_DIAG)	+= unix_diag.o
 unix_diag-y		:= diag.o
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f4dc22db371d..8968ed44a89f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -772,10 +772,18 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.show_fdinfo =	unix_show_fdinfo,
 };
 
-static struct proto unix_proto = {
+static void unix_close(struct sock *sk, long timeout)
+{
+}
+
+struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
+	.close			= unix_close,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= unix_bpf_update_proto,
+#endif
 };
 
 static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
@@ -859,6 +867,7 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	sk->sk_prot->close(sk, 0);
 	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
@@ -2958,6 +2967,7 @@ static int __init af_unix_init(void)
 
 	sock_register(&unix_family_ops);
 	register_pernet_subsys(&unix_net_ops);
+	unix_bpf_build_proto();
 out:
 	return rc;
 }
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
new file mode 100644
index 000000000000..b1582a659427
--- /dev/null
+++ b/net/unix/unix_bpf.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Cong Wang <cong.wang@bytedance.com> */
+
+#include <linux/skmsg.h>
+#include <linux/bpf.h>
+#include <net/sock.h>
+#include <net/af_unix.h>
+
+static struct proto *unix_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(unix_prot_lock);
+static struct proto unix_bpf_prot;
+
+static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+{
+	*prot        = *base;
+	prot->close  = sock_map_close;
+}
+
+static void unix_bpf_check_needs_rebuild(struct proto *ops)
+{
+	if (unlikely(ops != smp_load_acquire(&unix_prot_saved))) {
+		spin_lock_bh(&unix_prot_lock);
+		if (likely(ops != unix_prot_saved)) {
+			unix_bpf_rebuild_protos(&unix_bpf_prot, ops);
+			smp_store_release(&unix_prot_saved, ops);
+		}
+		spin_unlock_bh(&unix_prot_lock);
+	}
+}
+
+int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+{
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		return 0;
+	}
+
+	unix_bpf_check_needs_rebuild(psock->sk_proto);
+	WRITE_ONCE(sk->sk_prot, &unix_bpf_prot);
+	return 0;
+}
+
+void __init unix_bpf_build_proto(void)
+{
+	unix_bpf_rebuild_protos(&unix_bpf_prot, &unix_proto);
+}
-- 
2.25.1

