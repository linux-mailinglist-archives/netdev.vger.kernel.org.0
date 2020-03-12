Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1D6183D70
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCLXg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:36:57 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51053 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLXg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:36:56 -0400
Received: by mail-pj1-f65.google.com with SMTP id u10so3198030pjy.0;
        Thu, 12 Mar 2020 16:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LnFK17YH474GVsLv4gKaKdxVAfL31coFm8M6jGIUVQA=;
        b=KuhxZPgwySuSQ74hJ2BQ8x2GA1ItV9oMyLQS5b0LB3+PYpc/LMAVWfsJpuF3tNYkwm
         e+VaZUvf0xgqa/1293POx8lykGO1diWnhQbtpuIay1sWkZSgu1f1o2D9qrs+kBw4LKVp
         edzxLh8NyFufXk/0F4Eay/qkkI/uyIGc1YI90du7crFHTKdEEFlvQBxCX68UZ4oRdw7D
         dFWr5dfuvujRyJfq60mcIvbCD+JPUoRSKehudRZRaLyAvpPP/ODeEaV5hIJo1IgskfsJ
         B2GPndgXUkZuJin4FaYn8d1MbHm03JcZzP6GHi1FJAW1bFOthfunhTuODLtZBJkl/brW
         jg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LnFK17YH474GVsLv4gKaKdxVAfL31coFm8M6jGIUVQA=;
        b=qtLquaZjoxpg7FNSYUblM8pMwbC6jhDvpvxffUuHAPgKR/KRrKNMgSunxG3wdGgtn7
         z3GiibGJEDmdICAc+I+qxvmxNXBShCtdVAUGLQ9al9f+PDNDbVA4Yjs0ZR+NqnH4VPSf
         wN5FWwDWabPZH85oZylCDJn2141cFH92yBn4Glkt7OkNDl7qTRijgswRon2vgXbd5DVY
         GvGgbgN/s1Q2F1ehv6IyQkNr5ZxpIhMMiOkFy21PbJeu35R2TM9WkqPSVXYJP7VgOwlD
         DA4XhOZxBDB309i4BRmVOcLvZYu7XyMZpBsIAloWZObgLVaD6AnLzuqV0dKu6tLr36ma
         GwZw==
X-Gm-Message-State: ANhLgQ3uhlg3az8p0IMTmXBDiHoNVdKPoGCq7ZbY7XHRC5mtMXqyKbjJ
        1tqv9jOgeCbnyRoGZAf6tnZ0oXYq
X-Google-Smtp-Source: ADFU+vvekdjpAXhyC9OE8nFP6ujWDNyM57llG8onSl+JydKJ6HAq6fB0ZC9HqRt/KBuJ6a4bBK5JfA==
X-Received: by 2002:a17:902:7043:: with SMTP id h3mr10204462plt.207.1584056213480;
        Thu, 12 Mar 2020 16:36:53 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:52 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 2/7] dst: Add socket prefetch metadata destinations
Date:   Thu, 12 Mar 2020 16:36:43 -0700
Message-Id: <20200312233648.1767-3-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Metadata destinations were introduced in commit f38a9eb1f77b
("dst: Metadata destinations") to "carry per packet metadata
between forwarding and processing elements via the skb->dst pointer".

The aim of this new METADATA_SK_PREFETCH destination type is to allow
early forwarding elements to store a socket destination for the duration
of receiving into the IP stack, which can be later be identified to
avoid orphaning the skb and losing the prefetched socket in ip_rcv_core().

The destination is stored temporarily in a per-CPU buffer to ensure that
if applications attempt to reach out from loopback address to loopback
address, they may restore the original destination and avoid martian
packet drops.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 include/net/dst_metadata.h | 31 +++++++++++++++++++++++++++++++
 net/core/dst.c             | 30 ++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 56cb3c38569a..31574c553a07 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -9,6 +9,7 @@
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_SK_PREFETCH,
 };
 
 struct hw_port_info {
@@ -80,6 +81,8 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);
+	case METADATA_SK_PREFETCH:
+		return 0;
 	default:
 		return 1;
 	}
@@ -214,4 +217,32 @@ static inline struct metadata_dst *ipv6_tun_rx_dst(struct sk_buff *skb,
 				  0, ip6_flowlabel(ip6h), flags, tunnel_id,
 				  md_size);
 }
+
+extern const struct metadata_dst dst_sk_prefetch;
+
+static inline bool dst_is_sk_prefetch(const struct dst_entry *dst)
+{
+	return dst == &dst_sk_prefetch.dst;
+}
+
+static inline bool skb_dst_is_sk_prefetch(const struct sk_buff *skb)
+{
+	return dst_is_sk_prefetch(skb_dst(skb));
+}
+
+void dst_sk_prefetch_store(struct sk_buff *skb);
+void dst_sk_prefetch_fetch(struct sk_buff *skb);
+
+/**
+ * dst_sk_prefetch_reset - reset prefetched socket dst
+ * @skb: buffer
+ *
+ * Reverts the dst back to the originally stored dst if present.
+ */
+static inline void dst_sk_prefetch_reset(struct sk_buff *skb)
+{
+	if (unlikely(skb_dst_is_sk_prefetch(skb)))
+		dst_sk_prefetch_fetch(skb);
+}
+
 #endif /* __NET_DST_METADATA_H */
diff --git a/net/core/dst.c b/net/core/dst.c
index 193af526e908..cf1a1d5b6b0a 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -330,3 +330,33 @@ void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)
 	free_percpu(md_dst);
 }
 EXPORT_SYMBOL_GPL(metadata_dst_free_percpu);
+
+const struct metadata_dst dst_sk_prefetch = {
+	.dst = {
+		.ops = &md_dst_ops,
+		.input = dst_md_discard,
+		.output = dst_md_discard_out,
+		.flags = DST_NOCOUNT | DST_METADATA,
+		.obsolete = DST_OBSOLETE_NONE,
+		.__refcnt = ATOMIC_INIT(1),
+	},
+	.type = METADATA_SK_PREFETCH,
+};
+EXPORT_SYMBOL(dst_sk_prefetch);
+
+DEFINE_PER_CPU(unsigned long, dst_sk_prefetch_dst);
+
+void dst_sk_prefetch_store(struct sk_buff *skb)
+{
+	unsigned long refdst;
+
+	refdst = skb->_skb_refdst;
+	__this_cpu_write(dst_sk_prefetch_dst, refdst);
+	skb_dst_set_noref(skb, (struct dst_entry *)&dst_sk_prefetch.dst);
+}
+
+void dst_sk_prefetch_fetch(struct sk_buff *skb)
+{
+	skb->_skb_refdst = __this_cpu_read(dst_sk_prefetch_dst);
+}
+EXPORT_SYMBOL(dst_sk_prefetch_fetch);
-- 
2.20.1

