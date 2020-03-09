Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0557517DE6B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgCILN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41553 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgCILNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id v4so10528552wrs.8
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QNC/yhj9eA7H5WupK4I1s6LtyzXa8KAaxTwNXTgRG+w=;
        b=GxBeNiBm2mw9UI6mhddkvq45q7UbHjkdwFsx/G6K5dHtl2OypwWM2kampZowcxoGyO
         UtKAhLWsBrfT8UnX39SdHN/iLM5lL1ckz3uyjYB99EHXapWIfysp5TlQXwK9HGsz7Vkd
         xrGTS8hNKVVie+Tbyrlk/8lsFj6lZKn5N5qrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QNC/yhj9eA7H5WupK4I1s6LtyzXa8KAaxTwNXTgRG+w=;
        b=JiY6l/gbxfvYfrSGs2VDmDiSWxvmqKvoIeqlTRp6roGqxa4y5xAfjRRVMBTxvWJYbP
         a9ImXrjYxuv6Y+TkaEM5O755VnAc8TKQxYXEj5pWDeZJdvam62ZQuNpdGRLZxAJ7xvgx
         P8KYO/9/DllPaqfttmHQxToMA7DYyNlZiohD1TygiFpH8pKzAhWigYmu9LjndByLqQhu
         a2hBJhkr+JnHJwV5uObzgX+FBBzo66dXHukmqI62VQi53A72VSUOkBtit1gYae3yG4pI
         LK1RGDWgYX4zUI/nVUxz9Ljtz11EOj8OAKPGFtTfBMnQgI04XUMEmAAyLySxGvBY8W6U
         7GEw==
X-Gm-Message-State: ANhLgQ1yPd3qYPLe7ALQ1bgAOp1SJLhOZZE6GoeolQ5OQoLCJFDqQE7J
        X9Hg2JsfVDLQhqQ74YlwRcyr7Q==
X-Google-Smtp-Source: ADFU+vvAMeq2nRoM6YsXxONyyZ6j5Q6m9ww8bHHSCZpNHNFCMi/9yJbzsoo4bEpH6kYjYcusvK9+8g==
X-Received: by 2002:a5d:4206:: with SMTP id n6mr19844910wrq.119.1583752401537;
        Mon, 09 Mar 2020 04:13:21 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:20 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 07/12] bpf: add sockmap hooks for UDP sockets
Date:   Mon,  9 Mar 2020 11:12:38 +0000
Message-Id: <20200309111243.6982-8-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
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
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 MAINTAINERS        |  1 +
 include/net/udp.h  |  5 +++++
 net/ipv4/Makefile  |  1 +
 net/ipv4/udp_bpf.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+)
 create mode 100644 net/ipv4/udp_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c23884e084be..14554bde1c06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9370,6 +9370,7 @@ F:	include/linux/skmsg.h
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

