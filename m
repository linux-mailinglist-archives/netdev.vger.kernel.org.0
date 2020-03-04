Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E5178E2D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgCDKNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:13:53 -0500
Received: from mail-lf1-f41.google.com ([209.85.167.41]:35446 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387833AbgCDKNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:51 -0500
Received: by mail-lf1-f41.google.com with SMTP id z9so1030243lfa.2
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0JG4vRN2U1vBjajCliJupAy0Xm38EfZHPBvH9KwfXgk=;
        b=elTxoKyu7RkdVLYq8DExwAcOXjjfFBZEbcj6vrF5UpngljtRqGrZ7ebgasBZPsdubp
         zuovFtYIe0rEhyusnKUocgzt3WlrXT9ZeqK8YMpldRtrMSXiw8t9Hir0CdQkbdyOFnYw
         I7z3lQfWSwm41cFGvT8VytXTt1vcuzNp4ypXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0JG4vRN2U1vBjajCliJupAy0Xm38EfZHPBvH9KwfXgk=;
        b=kJJiyASNjaXKPZSi32zqG98/9svXiiN+Pj0slmcFh62uHDXicxVHelvRa2pxJj15l5
         Y9PWoAJG/r276L4NoYSuB91SXJLdwBwefWg2mgrptA9rhbMTrFGPhGukDFrCDtLwSAkQ
         bOddMW9N/KE8wVkBPUWyhLV/yoGN5A88N+nsCrIxBjzq3nwfPPlF86ppFJi7dpnX+tlO
         pgsnZHYnSirV+5vyNTwkB0mQ/w2OKfp4Iiu5Yl8nZNCqCzNvbP4fN8kRzY967g1iw5zv
         voPZUBV9kbD6+jBXR7+rZjpY9wtBN5ncynDzwLHzCrN3RGJpWV+wMnONiIIUYtlOMdCk
         0yuw==
X-Gm-Message-State: ANhLgQ0PJECGXXVr/fR287tfGbP22TAlq2j/cJWzCWgfUMub17dRZpUl
        Rwwq9Q7tnxwBgE+29ye49qAB/kgiwAfZhJDj
X-Google-Smtp-Source: ADFU+vtOHKTMDKLBdW063ze8vJHAb6ivzE/JIjJvB1eGckwN1kulKZrWnFhZaB0IdtDF9F6BE/XHCQ==
X-Received: by 2002:a19:760b:: with SMTP id c11mr982899lff.140.1583316828295;
        Wed, 04 Mar 2020 02:13:48 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:47 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 07/12] bpf: add sockmap hooks for UDP sockets
Date:   Wed,  4 Mar 2020 11:13:12 +0100
Message-Id: <20200304101318.5225-8-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic psock hooks for UDP sockets. This allows adding and
removing sockets, as well as automatic removal on unhash and close.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 MAINTAINERS        |  1 +
 include/net/udp.h  |  5 +++++
 net/ipv4/Makefile  |  1 +
 net/ipv4/udp_bpf.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+)
 create mode 100644 net/ipv4/udp_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f27f40d22bb..b2fae56dca9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9359,6 +9359,7 @@ F:	include/linux/skmsg.h
 F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
+F:	net/ipv4/udp_bpf.c
 
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
diff --git a/include/net/udp.h b/include/net/udp.h
index e55d5f765807..a8fa6c0c6ded 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -503,4 +503,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
+#ifdef CONFIG_BPF_STREAM_PARSER
+struct sk_psock;
+struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
+#endif /* BPF_STREAM_PARSER */
+
 #endif	/* _UDP_H */
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 9d97bace13c8..9e1a186a3671 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
+obj-$(CONFIG_BPF_STREAM_PARSER) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
new file mode 100644
index 000000000000..eddd973e6575
--- /dev/null
+++ b/net/ipv4/udp_bpf.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Cloudflare Ltd https://cloudflare.com */
+
+#include <linux/skmsg.h>
+#include <net/sock.h>
+#include <net/udp.h>
+
+enum {
+	UDP_BPF_IPV4,
+	UDP_BPF_IPV6,
+	UDP_BPF_NUM_PROTS,
+};
+
+static struct proto *udpv6_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(udpv6_prot_lock);
+static struct proto udp_bpf_prots[UDP_BPF_NUM_PROTS];
+
+static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+{
+	*prot        = *base;
+	prot->unhash = sock_map_unhash;
+	prot->close  = sock_map_close;
+}
+
+static void udp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto *ops)
+{
+	if (sk->sk_family == AF_INET6 &&
+	    unlikely(ops != smp_load_acquire(&udpv6_prot_saved))) {
+		spin_lock_bh(&udpv6_prot_lock);
+		if (likely(ops != udpv6_prot_saved)) {
+			udp_bpf_rebuild_protos(&udp_bpf_prots[UDP_BPF_IPV6], ops);
+			smp_store_release(&udpv6_prot_saved, ops);
+		}
+		spin_unlock_bh(&udpv6_prot_lock);
+	}
+}
+
+static int __init udp_bpf_v4_build_proto(void)
+{
+	udp_bpf_rebuild_protos(&udp_bpf_prots[UDP_BPF_IPV4], &udp_prot);
+	return 0;
+}
+core_initcall(udp_bpf_v4_build_proto);
+
+struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
+{
+	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
+
+	if (!psock->sk_proto)
+		udp_bpf_check_v6_needs_rebuild(sk, READ_ONCE(sk->sk_prot));
+
+	return &udp_bpf_prots[family];
+}
-- 
2.20.1

