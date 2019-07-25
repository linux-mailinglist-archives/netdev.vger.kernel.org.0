Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC7275AF0
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 00:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfGYWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 18:52:38 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:52256 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfGYWwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 18:52:38 -0400
Received: by mail-pf1-f201.google.com with SMTP id a20so31849010pfn.19
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 15:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q2qVpSEjbdKuRWDTXifa9srSYTSuWUhFa7bELs3sAgg=;
        b=pAB5K0WPtbWnmH0V/wRCJSgo6rxFZ5g829Rc8GCL8bR6p2gXsvvps2+CFdzQcH9MZE
         wkl6ErbC9Xov1xeVK90oFyG3FZ71pbCHIvwuyrP1NE1kInPOClywmgsuzhR4E/iz6tRu
         N0ouwT96RsdrJjGslmf7GtuZxIKrFyX6iNs35QDdYwDJfUbCHK7Cd5/4eFGoH8l6ZDmp
         ywOpu7Vu2xH2ExdcimcDF8IPEVvBfCHha2CSvocPHiLXqMRh4jxqunhKXC+mcOGyEGdl
         jpE4QeK/af3QTSg0L2F7ttcZoqlKyYggcTKxTiE3D27a4u2SmfcdZiNDsYkO3jHZexwY
         0wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q2qVpSEjbdKuRWDTXifa9srSYTSuWUhFa7bELs3sAgg=;
        b=V4KuAIBKsnLzmKI4etwH3PQKZ0Uj9CfQsCh0Cl/4Vv6cL74fxiUM6T9ibX11tmfoCd
         LxtYehJfhbefu8Gny1DGzEEIGqgL/fW3d5BAnNT5QNDEQ0YIzxJY5P/uAZojnD0eenlP
         BO4QMisaBC8w9IqO5/GanKixUtePzPvkdlJ0UUpBUJ/IPKUadVQUO7f3fLM/x6SbigWT
         eBXo6Hw85tC7/ompUzkMrB4C96f8Ql5V/KUF5YNmrENxrCC+uArcDiEN1YRZlMtarDko
         cNJjPHuuW3T7QiczxnVvlzpKTfX0vBkSiwEThbO20DmT04y71LVo+ylhVkbS0Se04KC8
         NOhw==
X-Gm-Message-State: APjAAAWE2IToEk5e414Oilm0fQS1J8wYd3oBC+CKoG9i+GItm3+KwwhJ
        VS1+cwPI0l88VZ9W/FAOg5Tn/fZCjugN8c3UhnpZ/GQjhqS3EfwDRBLwNll7KNRaIZVqqGngGcj
        FVCRGJn0VsP4zfPLbKTfpwmmRdUwHF/F2DpHV/7QuDHqaCJKOW2byVg==
X-Google-Smtp-Source: APXvYqyh66ttMnYzT53+vpXKX2Z8k76Z2Ic/SJ1d7nEJ7lGpINOPXP2Qpw09f63G0blvVy74CNTmQD0=
X-Received: by 2002:a63:5860:: with SMTP id i32mr60300490pgm.124.1564095156486;
 Thu, 25 Jul 2019 15:52:36 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:52:25 -0700
In-Reply-To: <20190725225231.195090-1-sdf@google.com>
Message-Id: <20190725225231.195090-2-sdf@google.com>
Mime-Version: 1.0
References: <20190725225231.195090-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next v3 1/7] bpf/flow_dissector: pass input flags to BPF
 flow dissector program
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

C flow dissector supports input flags that tell it to customize parsing
by either stopping early or trying to parse as deep as possible. Pass
those flags to the BPF flow dissector so it can make the same
decisions. In the next commits I'll add support for those flags to
our reference bpf_flow.c

v3:
* Export copy of flow dissector flags instead of moving (Alexei Starovoitov)

Acked-by: Petar Penkov <ppenkov@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/skbuff.h    |  2 +-
 include/uapi/linux/bpf.h  |  5 +++++
 net/bpf/test_run.c        |  2 +-
 net/core/flow_dissector.c | 12 ++++++++++--
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 718742b1c505..9b7a8038beec 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1271,7 +1271,7 @@ static inline int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 
 struct bpf_flow_dissector;
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
-		      __be16 proto, int nhoff, int hlen);
+		      __be16 proto, int nhoff, int hlen, unsigned int flags);
 
 bool __skb_flow_dissect(const struct net *net,
 			const struct sk_buff *skb,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fa1c753dcdbc..88b9d743036f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
+#define BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
+#define BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL		(1U << 1)
+#define BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
+
 struct bpf_flow_keys {
 	__u16	nhoff;
 	__u16	thoff;
@@ -3528,6 +3532,7 @@ struct bpf_flow_keys {
 			__u32	ipv6_dst[4];	/* in6_addr; network order */
 		};
 	};
+	__u32	flags;
 };
 
 struct bpf_func_info {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 80e6f3a6864d..4e41d15a1098 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -419,7 +419,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
-					  size);
+					  size, 0);
 
 		if (signal_pending(current)) {
 			preempt_enable();
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3e6fedb57bc1..50ed1a688709 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -784,7 +784,7 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 }
 
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
-		      __be16 proto, int nhoff, int hlen)
+		      __be16 proto, int nhoff, int hlen, unsigned int flags)
 {
 	struct bpf_flow_keys *flow_keys = ctx->flow_keys;
 	u32 result;
@@ -795,6 +795,14 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	flow_keys->nhoff = nhoff;
 	flow_keys->thoff = flow_keys->nhoff;
 
+	BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG !=
+		     (int)FLOW_DISSECTOR_F_PARSE_1ST_FRAG);
+	BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL !=
+		     (int)FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+	BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP !=
+		     (int)FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+	flow_keys->flags = flags;
+
 	preempt_disable();
 	result = BPF_PROG_RUN(prog, ctx);
 	preempt_enable();
@@ -914,7 +922,7 @@ bool __skb_flow_dissect(const struct net *net,
 			}
 
 			ret = bpf_flow_dissect(attached, &ctx, n_proto, nhoff,
-					       hlen);
+					       hlen, flags);
 			__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
 						 target_container);
 			rcu_read_unlock();
-- 
2.22.0.709.g102302147b-goog

