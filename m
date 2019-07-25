Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCED75AF4
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 00:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfGYWwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 18:52:43 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:41467 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfGYWwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 18:52:43 -0400
Received: by mail-pl1-f201.google.com with SMTP id i3so27175283plb.8
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 15:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qYiLPfD1jN/p5ufntq2ZDe7HjIN5+8qjpe5If3CnHQU=;
        b=VcVMOoINi1CEqtFaLn318ESdEI3Z1k05sEzIZ9WwDCEYv17xsC1iGTM+XZ8OOI7EHj
         Rpg3LlwupLvOz/alzyWlKE7iUgxwxG2+0/aR+lhQVrhA5fj5iJYJ53GcvusSyODLffEO
         Tm2OvlSAIO5IhlXMRKb2u43JPx2P60w3cASWBjD+6SMUajOZZ/Kkq5XP5K9gb1Wgp03v
         oINVDoqPxOdUirmW6RZck7pcPI54re6M/KZgJgeU9xEAPT7EHR90VMYEhZGOOPfmI3X2
         u5deOYPVG622sDYjwuvGIqeE4zWq4IJVYcOuOXNH1GkB39jWysT9NxOl8OsiXkgyHTQ7
         htIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qYiLPfD1jN/p5ufntq2ZDe7HjIN5+8qjpe5If3CnHQU=;
        b=aZ82o2dwrJZdEJZKC9FSMF2d3GBI/aVYx/jcC88CMABy74QoGRu8TJHLR81a3I9NL2
         0YXvubx2TM04dheH7GbVTYAT6KkBzpKII8vhyHYtJamcWEjC5EXhdRTSHM2fZMIv2oFG
         EnIGTrn4xtVHDohx2nYZnxCikQtb9pJWqlM/zov35f8kUsfFQo5BpcGqL412f3VlLtDc
         VaWkUx2YyJcFw+nv6a3M7QUNYKoDm0N2vtxmSLpEF/nFCXsq5cEVcUjLZ/DncPQ5CNFV
         DqhQvNB2TEZcyGWUFFCN36R/W+x+XxIpo9e8rHKab3Rb3ieA1B4BI6UntfbQHrQWIdrA
         PAwg==
X-Gm-Message-State: APjAAAVPzbZ79gH3+FC1hAMi3Y+435eDqsD5qpKkbSdPmbWLRkpaEJ/C
        Un5JA8uthVf5ORLC6xJBYL0+VR4ORV5plP4BK8S3M32DSr2vlmxoLBYMlFRa2s3soY3GE1A8Onh
        rNT4lbdku3954Ri+KsBqhLi1t/jznAYcyLc+N1BlRVUE5wcHC1j/e0A==
X-Google-Smtp-Source: APXvYqwAChx4jYJmADdPXx1eRfS8HHTSS4iB6rhyvGq2bj+nnCdYN1YJA7tBeF54SjdH4k1bkFHBnIo=
X-Received: by 2002:a65:6081:: with SMTP id t1mr89463688pgu.9.1564095161890;
 Thu, 25 Jul 2019 15:52:41 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:52:27 -0700
In-Reply-To: <20190725225231.195090-1-sdf@google.com>
Message-Id: <20190725225231.195090-4-sdf@google.com>
Mime-Version: 1.0
References: <20190725225231.195090-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next v3 3/7] bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
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

This will allow us to write tests for those flags.

v2:
* Swap kfree(data) and kfree(user_ctx) (Song Liu)

Acked-by: Petar Penkov <ppenkov@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/bpf/test_run.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 4e41d15a1098..1153bbcdff72 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -377,6 +377,22 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	return ret;
 }
 
+static int verify_user_bpf_flow_keys(struct bpf_flow_keys *ctx)
+{
+	/* make sure the fields we don't use are zeroed */
+	if (!range_is_zero(ctx, 0, offsetof(struct bpf_flow_keys, flags)))
+		return -EINVAL;
+
+	/* flags is allowed */
+
+	if (!range_is_zero(ctx, offsetof(struct bpf_flow_keys, flags) +
+			   FIELD_SIZEOF(struct bpf_flow_keys, flags),
+			   sizeof(struct bpf_flow_keys)))
+		return -EINVAL;
+
+	return 0;
+}
+
 int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr)
@@ -384,9 +400,11 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	u32 size = kattr->test.data_size_in;
 	struct bpf_flow_dissector ctx = {};
 	u32 repeat = kattr->test.repeat;
+	struct bpf_flow_keys *user_ctx;
 	struct bpf_flow_keys flow_keys;
 	u64 time_start, time_spent = 0;
 	const struct ethhdr *eth;
+	unsigned int flags = 0;
 	u32 retval, duration;
 	void *data;
 	int ret;
@@ -395,9 +413,6 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (prog->type != BPF_PROG_TYPE_FLOW_DISSECTOR)
 		return -EINVAL;
 
-	if (kattr->test.ctx_in || kattr->test.ctx_out)
-		return -EINVAL;
-
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
@@ -410,6 +425,18 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (!repeat)
 		repeat = 1;
 
+	user_ctx = bpf_ctx_init(kattr, sizeof(struct bpf_flow_keys));
+	if (IS_ERR(user_ctx)) {
+		kfree(data);
+		return PTR_ERR(user_ctx);
+	}
+	if (user_ctx) {
+		ret = verify_user_bpf_flow_keys(user_ctx);
+		if (ret)
+			goto out;
+		flags = user_ctx->flags;
+	}
+
 	ctx.flow_keys = &flow_keys;
 	ctx.data = data;
 	ctx.data_end = (__u8 *)data + size;
@@ -419,7 +446,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	time_start = ktime_get_ns();
 	for (i = 0; i < repeat; i++) {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
-					  size, 0);
+					  size, flags);
 
 		if (signal_pending(current)) {
 			preempt_enable();
@@ -450,8 +477,12 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 
 	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
 			      retval, duration);
+	if (!ret)
+		ret = bpf_ctx_finish(kattr, uattr, user_ctx,
+				     sizeof(struct bpf_flow_keys));
 
 out:
+	kfree(user_ctx);
 	kfree(data);
 	return ret;
 }
-- 
2.22.0.709.g102302147b-goog

