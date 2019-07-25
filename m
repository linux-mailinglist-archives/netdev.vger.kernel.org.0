Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBDA5752AD
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389040AbfGYPdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:33:49 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35851 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387422AbfGYPds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:33:48 -0400
Received: by mail-pl1-f202.google.com with SMTP id a5so26523009pla.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BiKfBntvSFGLnKAjRbgK5CvGVATtpbHbwqwm+GPuZM4=;
        b=Y+nZ4sF3XfsqIdOBUvW6QLFFURKIkSbiN2BirNiVi09bpzTbt/WkF9toIjRNZVRPMc
         4Pw7iVR+Ki4t68gxFEEfyi93KvLpti3+lhXOwN0vasftojfM/a3wL/zI5i+FqUthpkYn
         njLCufcM56Tbum98fAPzBCga//Re2YIbDCNIAtSb3FZ/9OusYh44rykwdB6BIxxFvtoV
         OHJeb/aSO8tRUoyK68jJvpHWJGiSOZOEJa2v1km7aNETL5ViGKMDXny4x9H/FwDPcTDy
         wKoWN52AtQ1TZ9zsZGuKNtVpsm0+nVWYZeTEexvSf9b3s+qbyHxzaFQBQZPFpUS2QvXm
         6hzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BiKfBntvSFGLnKAjRbgK5CvGVATtpbHbwqwm+GPuZM4=;
        b=EJJkinXcEBYaeI8IJDB+gPcx4vOwvuP4meoe2I+xLN7EGmFt8Fh/b7ELl6ZhAX0+yD
         PnHn4OkU4vxjowigZ3C7Tq5iyVVEp90/OyW9WUZjGlBZfvhg0sA85TsRHnuTEvbOUcVz
         sjxUXoSs/tTSimHOdV9XoOC+DQZPMAr38CtjJo6AytcOiHBf3c3ybqGG+NLcvr0emagz
         Gm27fkleQ5sYMqDyn0uNE8daxKbAUdINsH7IexePdGnhQIq8+zNU+G2n9+sQFflP1qtx
         ywTIEHtAfeeMo5xVtAcO63PX8pnqBvlE2HCocxatTy7Z5k9hi7W0feq0vSiotjP+D6hg
         KNDA==
X-Gm-Message-State: APjAAAVbYtodN8JUxdz+s0sjSsQ+gi1jmiZnVAxT5D4nqPzaj9XPuPQY
        UDoYBcRQMcADjxcD/1nff3eO2XchXus0naoz4gUxEEK4jIqgB6f1cAFWpk6UiaqHbBKpJcHl2Jy
        96gg3mF5x/aZiBS43dIWOXWA7LPV5kk0EiMgEMj53+kutWLeSbXwMfQ==
X-Google-Smtp-Source: APXvYqxZ0SC77ZxbxqR3/hY40el0h/u5xVtOwr2M2vPzJXBpCCswhoYh6QYZSLr8aAqW9Pm73y3YREk=
X-Received: by 2002:a63:d23:: with SMTP id c35mr86278020pgl.376.1564068827362;
 Thu, 25 Jul 2019 08:33:47 -0700 (PDT)
Date:   Thu, 25 Jul 2019 08:33:36 -0700
In-Reply-To: <20190725153342.3571-1-sdf@google.com>
Message-Id: <20190725153342.3571-2-sdf@google.com>
Mime-Version: 1.0
References: <20190725153342.3571-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next v2 1/7] bpf/flow_dissector: pass input flags to BPF
 flow dissector program
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

C flow dissector supports input flags that tell it to customize parsing
by either stopping early or trying to parse as deep as possible. Pass
those flags to the BPF flow dissector so it can make the same
decisions. In the next commits I'll add support for those flags to
our reference bpf_flow.c

Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Song Liu <songliubraving@fb.com>
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

