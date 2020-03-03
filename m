Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD99217839F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbgCCUFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:05:20 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41694 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgCCUFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:05:20 -0500
Received: by mail-qt1-f195.google.com with SMTP id l21so3844180qtr.8;
        Tue, 03 Mar 2020 12:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bSttz86+BMap7bbbGIPBZrmCtfnqk5FnhF3Vjoje2Qk=;
        b=UrAE/WeJtiDhtqfem+oRHag/ihR/uga7dD87ZNTL0ec/y41bVVWB96vUYQuFuxB24t
         LZ+C1fBpFYcbDk2h5LyNf+PoRk1RLa9PG8QkuIn23l0VAnmzBHmquxc0f9ZI990tX5Ja
         f5LB2xgPRkiN1PSYNP5IK6a8EA0N6pOGz8GdQp2dD2kQzjnEcLg+KDpPp+aaw9jias4P
         T4BsQD0C2NvXknQvB2Dn5iiwtDKLBtjjqvpptwQ2DlxVNdnbXykIXt3M63vdODIU4uHe
         WgHAa6eqrIEqUaRQYVTmUdHhYTt+46O4AL+lRBPK9f+wMezdO9LDirB4FCdrKd0JzpV+
         zBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bSttz86+BMap7bbbGIPBZrmCtfnqk5FnhF3Vjoje2Qk=;
        b=o/LQ/k573pJPzZFvj/53WB6AAKKVBCSeDdH7qZ3PvL+eQUaG8mIsCG2Aa6jx9J95LK
         bbHPQ/wkoxffoWPY4xb9lVRpMVGcNvFVpGJlmu9Z4J/3TK43/WbyfMHK8dgV35EAnU4k
         JPUN1FBG1vlOeXNiLv935bGR598bu+IaCghRvG1HUGmaFGGtPaxZnjkkiyM5k+sZfNuY
         XQV7ifZX6KFcn3wtwaB/vn/Elg7R4U5wx+nSMaEtl7riLSz5JY2zUwgBLMqA4O/3miOL
         dpKtemtGBNlljjs8IosUaRB+EuFF80V6bByIROwtz+2Z+CsOAFaHjW2d15cWwr1fPmYN
         ibJg==
X-Gm-Message-State: ANhLgQ193icpxAr/1qrfEU/VFYT3sENfOKPJ9aBYj0FJeqqzFqo8aCca
        FHrc7yEMyuYA5/IJAyE4xHIj5aeL
X-Google-Smtp-Source: ADFU+vvDVdPHOJJuvJbYgRHA/zZs/zMAzy/Fk6uyA0wHAFbX60ik6iRcIi791V0gDMLGy5sVuATryA==
X-Received: by 2002:ac8:3533:: with SMTP id y48mr6074110qtb.380.1583265918919;
        Tue, 03 Mar 2020 12:05:18 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:37b5:dd03:b905:30ea])
        by smtp.gmail.com with ESMTPSA id d7sm9846281qkg.62.2020.03.03.12.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 12:05:18 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next 1/3] bpf: add gso_size to __sk_buff
Date:   Tue,  3 Mar 2020 15:05:01 -0500
Message-Id: <20200303200503.226217-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
References: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

BPF programs may want to know whether an skb is gso. The canonical
answer is skb_is_gso(skb), which tests that gso_size != 0.

Expose this field in the same manner as gso_segs. That field itself
is not a sufficient signal, as the comment in skb_shared_info makes
clear: gso_segs may be zero, e.g., from dodgy sources.

Also prepare net/bpf/test_run for upcoming BPF_PROG_TEST_RUN tests
of the feature.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/uapi/linux/bpf.h |  1 +
 net/bpf/test_run.c       |  7 +++++++
 net/core/filter.c        | 44 +++++++++++++++++++++++++++-------------
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8e98ced0963b..180337fae97e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3176,6 +3176,7 @@ struct __sk_buff {
 	__u32 wire_len;
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	__u32 gso_size;
 };
 
 struct bpf_tunnel_key {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 562443f94133..1cd7a1c2f8b2 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -277,6 +277,12 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	/* gso_segs is allowed */
 
 	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, gso_segs),
+			   offsetof(struct __sk_buff, gso_size)))
+		return -EINVAL;
+
+	/* gso_size is allowed */
+
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, gso_size),
 			   sizeof(struct __sk_buff)))
 		return -EINVAL;
 
@@ -297,6 +303,7 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	if (__skb->gso_segs > GSO_MAX_SEGS)
 		return -EINVAL;
 	skb_shinfo(skb)->gso_segs = __skb->gso_segs;
+	skb_shinfo(skb)->gso_size = __skb->gso_size;
 
 	return 0;
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 4a08c9fb2be7..cd0a532db4e7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7139,6 +7139,27 @@ static u32 flow_dissector_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+static struct bpf_insn *bpf_convert_shinfo_access(const struct bpf_insn *si,
+						  struct bpf_insn *insn)
+{
+	/* si->dst_reg = skb_shinfo(SKB); */
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
+			      BPF_REG_AX, si->src_reg,
+			      offsetof(struct sk_buff, end));
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, head),
+			      si->dst_reg, si->src_reg,
+			      offsetof(struct sk_buff, head));
+	*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
+#else
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
+			      si->dst_reg, si->src_reg,
+			      offsetof(struct sk_buff, end));
+#endif
+
+	return insn;
+}
+
 static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 				  const struct bpf_insn *si,
 				  struct bpf_insn *insn_buf,
@@ -7461,26 +7482,21 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, gso_segs):
-		/* si->dst_reg = skb_shinfo(SKB); */
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
-				      BPF_REG_AX, si->src_reg,
-				      offsetof(struct sk_buff, end));
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, head),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct sk_buff, head));
-		*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
-#else
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct sk_buff, end));
-#endif
+		insn = bpf_convert_shinfo_access(si, insn);
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct skb_shared_info, gso_segs),
 				      si->dst_reg, si->dst_reg,
 				      bpf_target_off(struct skb_shared_info,
 						     gso_segs, 2,
 						     target_size));
 		break;
+	case offsetof(struct __sk_buff, gso_size):
+		insn = bpf_convert_shinfo_access(si, insn);
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct skb_shared_info, gso_size),
+				      si->dst_reg, si->dst_reg,
+				      bpf_target_off(struct skb_shared_info,
+						     gso_size, 2,
+						     target_size));
+		break;
 	case offsetof(struct __sk_buff, wire_len):
 		BUILD_BUG_ON(sizeof_field(struct qdisc_skb_cb, pkt_len) != 4);
 
-- 
2.25.0.265.gbab2e86ba0-goog

