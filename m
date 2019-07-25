Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6921D752BA
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbfGYPeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:34:04 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50489 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389196AbfGYPeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:34:02 -0400
Received: by mail-pf1-f201.google.com with SMTP id h27so31072078pfq.17
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GCDFpw0uwYKg8zzlh+Y1kxTvxF1Qwih2k/AvYXFT5Ik=;
        b=HKwbSIA0mCQhrV2+nOxZIkn2DYopPVzf3R8bk+nGOZrtqV79bm3fyXKHLwLho6yj/0
         q9A8pZ7VWHkonV0ONoE9p+5WB7zcsvd9PGWrS7pQrOLkD+F6+pYCsnHWIKrKwbJxbD3Q
         JxUe/8zBfBZxhpETICtOR8MkHwmKajG2X7frEY5+kYBWZ4KFtbO5DdtLc8lEtqtzFjDV
         QjZYAw/FinWw03/J3djHZLiz4jkPdW/QZco/AaRsDDCtP77mJGJ5lB0d79ZQhDCQLo0Z
         qwf0jjn6RQYkyAUH8K3BHpk4sgtJxgPu4pJmPMynOpYmt6mkvrGucGaf+sC2Gu6QicbA
         yBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GCDFpw0uwYKg8zzlh+Y1kxTvxF1Qwih2k/AvYXFT5Ik=;
        b=iKIY1bZaDYXXKPdasiOCrg40BY9ciyYE/o6nzbqewkvSbwoL9XQNO0OnCrW9vzuE/p
         Tz3LO6CX87FWVbcuN871iYO4jN6T4U+c223hF53sJIsGzv4Pxa6iDQ/fPRjioFriEwkA
         0TA5QfmyGhkvFw6GM95szjg1S94NJcea8v2jx79ip780LeVawLuXkFxGRNqaKs7iKA3y
         rVcXUXyI6sW34GmdgStYMJVw+h2Sp6znIsoSic4Wv2xw1TQuDBocIN/mulp9kr148SvR
         9gKT1I6E8gPbFx4yMXjO1M+1EDoQwukumQPRre7Z+pseXM9PiwnZwNE51nGBWQGmbIJB
         JkpA==
X-Gm-Message-State: APjAAAWu/brOWiCSaRYiTKTYqpufBtk2zIUu80yJQ0jwYGFCsAXs8+eZ
        F+e+XuCFM3wT7a1ighj09B3ZlyoZZ83T++wzqHz8il70jxEkrg9LI7jqyK6k9qKuSbBWEFl3Srp
        xiMFU1WWENRHtvYoVoOaYiBUd/D4B9bXnKWHbNXoflHGMX3zwtWUkpA==
X-Google-Smtp-Source: APXvYqxSgH8dRwQdP+gWtFYoqtycYvcefSC3FwyFRg24iKhyPYiKSqsjQnBF7qbvAilYR/uObeTSPtM=
X-Received: by 2002:a63:c70d:: with SMTP id n13mr85830085pgg.171.1564068841043;
 Thu, 25 Jul 2019 08:34:01 -0700 (PDT)
Date:   Thu, 25 Jul 2019 08:33:41 -0700
In-Reply-To: <20190725153342.3571-1-sdf@google.com>
Message-Id: <20190725153342.3571-7-sdf@google.com>
Mime-Version: 1.0
References: <20190725153342.3571-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next v2 6/7] bpf/flow_dissector: support ipv6 flow_label
 and FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for exporting ipv6 flow label via bpf_flow_keys.
Export flow label from bpf_flow.c and also return early when
FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL is passed.

Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h                      |  1 +
 net/core/flow_dissector.c                     |  9 ++++
 tools/include/uapi/linux/bpf.h                |  1 +
 .../selftests/bpf/prog_tests/flow_dissector.c | 46 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 10 ++++
 5 files changed, 67 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b4ad19bd6aa8..83b4150466af 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3533,6 +3533,7 @@ struct bpf_flow_keys {
 		};
 	};
 	__u32	flags;
+	__be32	flow_label;
 };
 
 struct bpf_func_info {
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index a74c4ed1b30d..bcdb863cad28 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -737,6 +737,7 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 	struct flow_dissector_key_basic *key_basic;
 	struct flow_dissector_key_addrs *key_addrs;
 	struct flow_dissector_key_ports *key_ports;
+	struct flow_dissector_key_tags *key_tags;
 
 	key_control = skb_flow_dissector_target(flow_dissector,
 						FLOW_DISSECTOR_KEY_CONTROL,
@@ -781,6 +782,14 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 		key_ports->src = flow_keys->sport;
 		key_ports->dst = flow_keys->dport;
 	}
+
+	if (dissector_uses_key(flow_dissector,
+			       FLOW_DISSECTOR_KEY_FLOW_LABEL)) {
+		key_tags = skb_flow_dissector_target(flow_dissector,
+						     FLOW_DISSECTOR_KEY_FLOW_LABEL,
+						     target_container);
+		key_tags->flow_label = ntohl(flow_keys->flow_label);
+	}
 }
 
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a0e1c891b56f..c26ca432b1b3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3530,6 +3530,7 @@ struct bpf_flow_keys {
 		};
 	};
 	__u32	flags;
+	__be32	flow_label;
 };
 
 struct bpf_func_info {
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index f93a115db650..ada032be6199 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -20,6 +20,7 @@
 	      "is_encap=%u/%u "						\
 	      "ip_proto=0x%x/0x%x "					\
 	      "n_proto=0x%x/0x%x "					\
+	      "flow_label=0x%x/0x%x "					\
 	      "sport=%u/%u "						\
 	      "dport=%u/%u\n",						\
 	      got.nhoff, expected.nhoff,				\
@@ -30,6 +31,7 @@
 	      got.is_encap, expected.is_encap,				\
 	      got.ip_proto, expected.ip_proto,				\
 	      got.n_proto, expected.n_proto,				\
+	      got.flow_label, expected.flow_label,			\
 	      got.sport, expected.sport,				\
 	      got.dport, expected.dport)
 
@@ -257,6 +259,50 @@ struct test tests[] = {
 			.is_first_frag = true,
 		},
 	},
+	{
+		.name = "ipv6-flow-label",
+		.pkt.ipv6 = {
+			.eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.iph.nexthdr = IPPROTO_TCP,
+			.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
+			.iph.flow_lbl = { 0xb, 0xee, 0xef },
+			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
+		},
+		.keys = {
+			.nhoff = ETH_HLEN,
+			.thoff = ETH_HLEN + sizeof(struct ipv6hdr),
+			.addr_proto = ETH_P_IPV6,
+			.ip_proto = IPPROTO_TCP,
+			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.sport = 80,
+			.dport = 8080,
+			.flow_label = __bpf_constant_htonl(0xbeeef),
+		},
+	},
+	{
+		.name = "ipv6-no-flow-label",
+		.pkt.ipv6 = {
+			.eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.iph.nexthdr = IPPROTO_TCP,
+			.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
+			.iph.flow_lbl = { 0xb, 0xee, 0xef },
+			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
+		},
+		.keys = {
+			.flags = FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL,
+			.nhoff = ETH_HLEN,
+			.thoff = ETH_HLEN + sizeof(struct ipv6hdr),
+			.addr_proto = ETH_P_IPV6,
+			.ip_proto = IPPROTO_TCP,
+			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.flow_label = __bpf_constant_htonl(0xbeeef),
+		},
+		.flags = FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL,
+	},
 };
 
 static int create_tap(const char *ifname)
diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 0eabe5e57944..7d73b7bfe609 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -83,6 +83,12 @@ static __always_inline int export_flow_keys(struct bpf_flow_keys *keys,
 	return ret;
 }
 
+#define IPV6_FLOWLABEL_MASK		__bpf_constant_htonl(0x000FFFFF)
+static inline __be32 ip6_flowlabel(const struct ipv6hdr *hdr)
+{
+	return *(__be32 *)hdr & IPV6_FLOWLABEL_MASK;
+}
+
 static __always_inline void *bpf_flow_dissect_get_header(struct __sk_buff *skb,
 							 __u16 hdr_size,
 							 void *buffer)
@@ -307,6 +313,10 @@ PROG(IPV6)(struct __sk_buff *skb)
 
 	keys->thoff += sizeof(struct ipv6hdr);
 	keys->ip_proto = ip6h->nexthdr;
+	keys->flow_label = ip6_flowlabel(ip6h);
+
+	if (keys->flags & FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL)
+		return export_flow_keys(keys, BPF_OK);
 
 	return parse_ipv6_proto(skb, ip6h->nexthdr);
 }
-- 
2.22.0.657.g960e92d24f-goog

