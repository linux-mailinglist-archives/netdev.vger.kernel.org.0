Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1C238C48
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfFGOLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:11:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41233 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfFGOLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 10:11:14 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so3221466eds.8
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 07:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGMgJuq5yq87nZc1iXSw3rrA6LJaXGUavU0uLXBD7Zs=;
        b=lK8ebs9wXyOkapYE4RhrzhhvvopPOCQRlCoKg2ti+4ihvpij2HIRb7/+Yr0erau6p9
         cyqsPXRZ7B+d7ZH5g9nNJCSDVnktTXsAHfLBZBxdt1QKwvvgN9C83/mhO5xUqdhnV5WR
         KtmW5MgHYBkcM4SbMiAgMPxcG9Ijc6fhHKzNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGMgJuq5yq87nZc1iXSw3rrA6LJaXGUavU0uLXBD7Zs=;
        b=FSoeF6LwAZZMuDD9BWoQie0Mr4uiCRE1KY+VAQT/SaAbu/QISQ7vSyUX4jn4ZVV9/Z
         O11XibT8UMLTK5MotoWF6JuUEQZFs8SNNuE4rHPCDZ7BaIcm5fvNxgDBb7hnP9QU1S6/
         LVXoZeQuLbGeZYUuVriG6lBbiXMss1+IoD9oD+NPEgRbvz1XT2xFNqqDm4TZJoQNwF2P
         fwKoZv3QQZts1QnXHBczWWi/datR9vyMTTl2kDYw1/wvGn7YpKntwZnbsDAQ2182BE5P
         WdFvcbGma2+dQlIGmizsKAYRRXsxfa3IHcBby5UVovWsFATb1EQEJ/rn0UGx9bBQDQoX
         Uj3g==
X-Gm-Message-State: APjAAAXa9rslSQJKbexn5qSvf8RSe0Da+C//H7PzFcURICpq8r6ZTvjl
        WLdIaf06yqHZigTDdkkZKbSgxA==
X-Google-Smtp-Source: APXvYqyV7eDm48xD9GpGkIo3m2th7JJi7gj60MYEFlgRiR95zHoQVGVsfxVNPQcKzrUIzJ0gBZrR4g==
X-Received: by 2002:a17:906:3098:: with SMTP id 24mr22761119ejv.106.1559916672400;
        Fri, 07 Jun 2019 07:11:12 -0700 (PDT)
Received: from locke-xps13.fritz.box (dslb-002-205-069-198.002.205.pools.vodafone-ip.de. [2.205.69.198])
        by smtp.gmail.com with ESMTPSA id a40sm546116edd.1.2019.06.07.07.11.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 07:11:11 -0700 (PDT)
From:   =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>
To:     john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Cc:     alban@kinvolk.io, krzesimir@kinvolk.io, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>
Subject: [PATCH bpf-next v5 1/4] bpf: sock ops: add netns ino and dev in bpf context
Date:   Fri,  7 Jun 2019 16:11:03 +0200
Message-Id: <20190607141106.32148-2-iago@kinvolk.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607141106.32148-1-iago@kinvolk.io>
References: <20190607141106.32148-1-iago@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alban Crequy <alban@kinvolk.io>

sockops programs can now access the network namespace inode and device
via (struct bpf_sock_ops)->netns_ino and ->netns_dev. This can be useful
to apply different policies on different network namespaces.

In the unlikely case where network namespaces are not compiled in
(CONFIG_NET_NS=n), the verifier will return netns_dev as usual and will
return 0 for netns_ino.

The generated BPF bytecode for netns_ino is loading the correct inode
number at the time of execution.

However, the generated BPF bytecode for netns_dev is loading an
immediate value determined at BPF-load-time by looking at the initial
network namespace. In practice, this works because all netns currently
use the same virtual device. If this was to change, this code would need
to be updated too.

Co-authored-by: Iago López Galeiras <iago@kinvolk.io>
Signed-off-by: Alban Crequy <alban@kinvolk.io>
Signed-off-by: Iago López Galeiras <iago@kinvolk.io>

---

Changes since v1:
- add netns_dev (review from Alexei)

Changes since v2:
- replace __u64 by u64 in kernel code (review from Y Song)
- remove unneeded #else branch: program would be rejected in
  is_valid_access (review from Y Song)
- allow partial reads (<u64) (review from Y Song)

Changes since v3:
- return netns_dev unconditionally and set netns_ino to 0 if
  CONFIG_NET_NS is not enabled (review from Jakub Kicinski)
- use bpf_ctx_record_field_size and bpf_ctx_narrow_access_ok instead of
  manually deal with partial reads (review from Y Song)
- update commit message to reflect new code and remove note about
  partial reads since it was discussed in the review
- use bpf_ctx_range() and offsetofend()

Changes since v4:
- add netns_dev comment on uapi header (review from Y Song)
- remove redundant bounds check (review from Y Song)
---
 include/uapi/linux/bpf.h |  6 ++++
 net/core/filter.c        | 67 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf66f01a..41f54ac3db95 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3261,6 +3261,12 @@ struct bpf_sock_ops {
 	__u32 sk_txhash;
 	__u64 bytes_received;
 	__u64 bytes_acked;
+	/*
+	 * netns_dev might be zero if there's an error getting it
+	 * when loading the BPF program. This is very unlikely.
+	 */
+	__u64 netns_dev;
+	__u64 netns_ino;
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..ce3dc5fef57e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -76,6 +76,8 @@
 #include <net/lwtunnel.h>
 #include <net/ipv6_stubs.h>
 #include <net/bpf_sk_storage.h>
+#include <linux/kdev_t.h>
+#include <linux/proc_ns.h>
 
 /**
  *	sk_filter_trim_cap - run a packet through a socket filter
@@ -6822,6 +6824,15 @@ static bool sock_ops_is_valid_access(int off, int size,
 		}
 	} else {
 		switch (off) {
+		case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
+			bpf_ctx_record_field_size(info, sizeof(u64));
+			if (!bpf_ctx_narrow_access_ok(off, size, sizeof(u64)))
+				return false;
+			break;
+		case offsetof(struct bpf_sock_ops, netns_ino):
+			if (size != sizeof(u64))
+				return false;
+			break;
 		case bpf_ctx_range_till(struct bpf_sock_ops, bytes_received,
 					bytes_acked):
 			if (size != sizeof(__u64))
@@ -7739,6 +7750,11 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+static struct ns_common *sockops_netns_cb(void *private_data)
+{
+	return &init_net.ns;
+}
+
 static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 				       const struct bpf_insn *si,
 				       struct bpf_insn *insn_buf,
@@ -7747,6 +7763,10 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 {
 	struct bpf_insn *insn = insn_buf;
 	int off;
+	struct inode *ns_inode;
+	struct path ns_path;
+	u64 netns_dev;
+	void *res;
 
 /* Helper macro for adding read access to tcp_sock or sock fields. */
 #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
@@ -7993,6 +8013,53 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		SOCK_OPS_GET_OR_SET_FIELD(sk_txhash, sk_txhash,
 					  struct sock, type);
 		break;
+
+	case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
+		/* We get the netns_dev at BPF-load-time and not at
+		 * BPF-exec-time. We assume that netns_dev is a constant.
+		 */
+		res = ns_get_path_cb(&ns_path, sockops_netns_cb, NULL);
+		if (IS_ERR(res)) {
+			netns_dev = 0;
+		} else {
+			ns_inode = ns_path.dentry->d_inode;
+			netns_dev = new_encode_dev(ns_inode->i_sb->s_dev);
+		}
+		*target_size = 8;
+		*insn++ = BPF_MOV64_IMM(si->dst_reg, netns_dev);
+		break;
+
+	case offsetof(struct bpf_sock_ops, netns_ino):
+#ifdef CONFIG_NET_NS
+		/* Loading: sk_ops->sk->__sk_common.skc_net.net->ns.inum
+		 * Type: (struct bpf_sock_ops_kern *)
+		 *       ->(struct sock *)
+		 *       ->(struct sock_common)
+		 *       .possible_net_t
+		 *       .(struct net *)
+		 *       ->(struct ns_common)
+		 *       .(unsigned int)
+		 */
+		BUILD_BUG_ON(offsetof(struct sock, __sk_common) != 0);
+		BUILD_BUG_ON(offsetof(possible_net_t, net) != 0);
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
+						struct bpf_sock_ops_kern, sk),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern, sk));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
+						possible_net_t, net),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct sock_common, skc_net));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
+						struct ns_common, inum),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct net, ns) +
+				      offsetof(struct ns_common, inum));
+#else
+		*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);
+#endif
+		break;
+
 	}
 	return insn - insn_buf;
 }
-- 
2.21.0

