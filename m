Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4696773481
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfGXRCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:02:24 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:49020 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfGXRAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:00:24 -0400
Received: by mail-pl1-f201.google.com with SMTP id i33so24461337pld.15
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 10:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UK3cLmopCyo0xo53LOpbyMn8ZKhtUu3HrgkMh97T/xw=;
        b=agh1vc5e4oRELu6pa6JWiEOl3V2izSM92RLkkakwTC/L7GVv/WNKmuWoLwCffY77QF
         6s18tzxtRiF1OyU4C8rGiJITM9uBpzVx6a3DMEtqvgTulLh4foRmf2jPhgrtKUBVkrOt
         V8YpZbOtBxQ3vDXHUBq55I3QX5IBls81HPmDx+g9qhQ9YOittWrwfTRy6+u1Iop1kSpH
         7gQNGMTEVgyfBk8Lff0+QMeXvbKTLCf6184MkWSgUUQVfUv03GfS2ZJRqjg0zZnfZ4za
         aZ5LUkJTp0Io01OmWSfbNDP81FYD0JAg3KQ3iBfWkAdLeu+k+n3DriRwX2hTrKBVYizt
         X48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UK3cLmopCyo0xo53LOpbyMn8ZKhtUu3HrgkMh97T/xw=;
        b=osnAyaJZ/2SUXRpymcJybfJ81BW5l49VI6Pn6muXSqxsOHm7+DpH6V+H6G3LrOEW2R
         vXCoNZJWhj1N7CtB+ilyXkncIYjiRCnqoMZNL11QGDuEqRmitnoRmh+dEJipNOQwleP+
         fNizLWKKuXN4VZFF0FqvIPgQML2wpBf9QFH0b9ASvvIiV7b+il6Ej47TWvGr8vwUutKI
         iQ5mkGa55xSFaPPhW51tYw35IBk8FgVovz6nZS1jmmv1+vD4D24iX5Bf1ppde0BaiA4W
         fpCNADLf2XFBwhqZu7bbbYzQmHP2QfY+QF0m01Mbt0ha8p6TSk6UPouWZjszkWk6NtHI
         WLUQ==
X-Gm-Message-State: APjAAAXYzMpX5r9wHgLrvwDi1h/vxViVzpLnu0CCiq5pxD+sWOGZCgTX
        9cKAu2coOKOTZQDjPBceCAA2jl3WYVXKSCFTrOqM2OvUvQuKPF8xD2rUnVYfQ8XhheD5WcPlivb
        pz9QnsMFtkzJi8s8pSkZ9aPgWp4iRqzjBRPvIiIPb36qkK9avcGCvpw==
X-Google-Smtp-Source: APXvYqxIr4bqJ++l5HeQeglDprHYtZis4rGkdQIztLHDE1JZvVKK5uwLvQRl/aqGN4+VLGy/0A3ji6I=
X-Received: by 2002:a65:5584:: with SMTP id j4mr51878707pgs.258.1563987623238;
 Wed, 24 Jul 2019 10:00:23 -0700 (PDT)
Date:   Wed, 24 Jul 2019 10:00:12 -0700
In-Reply-To: <20190724170018.96659-1-sdf@google.com>
Message-Id: <20190724170018.96659-2-sdf@google.com>
Mime-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 1/7] bpf/flow_dissector: pass input flags to BPF flow
 dissector program
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
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

Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/skbuff.h       | 2 +-
 include/net/flow_dissector.h | 4 ----
 include/uapi/linux/bpf.h     | 5 +++++
 net/bpf/test_run.c           | 2 +-
 net/core/flow_dissector.c    | 5 +++--
 5 files changed, 10 insertions(+), 8 deletions(-)

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
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 90bd210be060..3e2642587b76 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -253,10 +253,6 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_MAX,
 };
 
-#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		BIT(0)
-#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	BIT(1)
-#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		BIT(2)
-
 struct flow_dissector_key {
 	enum flow_dissector_key_id key_id;
 	size_t offset; /* offset of struct flow_dissector_key_*
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fa1c753dcdbc..b4ad19bd6aa8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
 	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
 };
 
+#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
+#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	(1U << 1)
+#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
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
index 3e6fedb57bc1..a74c4ed1b30d 100644
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
@@ -794,6 +794,7 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	flow_keys->n_proto = proto;
 	flow_keys->nhoff = nhoff;
 	flow_keys->thoff = flow_keys->nhoff;
+	flow_keys->flags = flags;
 
 	preempt_disable();
 	result = BPF_PROG_RUN(prog, ctx);
@@ -914,7 +915,7 @@ bool __skb_flow_dissect(const struct net *net,
 			}
 
 			ret = bpf_flow_dissect(attached, &ctx, n_proto, nhoff,
-					       hlen);
+					       hlen, flags);
 			__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
 						 target_container);
 			rcu_read_unlock();
-- 
2.22.0.657.g960e92d24f-goog

