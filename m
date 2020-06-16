Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7F1FC1DD
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFPWxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPWw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 18:52:59 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799F8C06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 15:52:59 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id v197so320530qkb.16
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 15:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FwKJ3q/6fE4EDZGFpwJDQKDs/dstZjG8+NaImCshfEs=;
        b=K3yVwNdzIFHrtdM61GCSwgTjSrJd7YBiZqddu0w99u1ywEu2nZcFXcDYnGN0tZRq1T
         ob5rFfg+qYJE4KTWz3beVcJxGZatZJ5kZg6qSDzZgsnJaGduI4pvNjdOw4ZoFGzujZlE
         a4irXsix3wwNWXl1ghnIU35Ojsp8BgvEGUgzpmi+cEawRGJMOzRPhU3yBVDekKeqiTg4
         sUc4uUrAXfR/FuJvXAKOtzabue0vo4znbAn8per75lzpR19cdKUGNPBI4uJJjkPbIwAy
         F2O6swud+aCcU95SVzqtKivWP0iIuVRnX/KteItqelCvIGOeAMZ79oc9wWVfkEdb0bOG
         UhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FwKJ3q/6fE4EDZGFpwJDQKDs/dstZjG8+NaImCshfEs=;
        b=H0Kz/1hoLMZX6p+PtewDFOIry61cF364SVOmzT7140uXxuGe5W7O453FPjL1GjhKMu
         sZk5/z8v8T937YeJyUtEufj3NTk0oOV2tAOre74RY+jO80RNMYhLtDBShF6J2i+GNzFN
         ThhIStxv5YSLLp9ZgXuAMFN1noEyyGWNDykfUTkHoC4SnexqQjafRgyytyCnEmjDplEE
         WipRNxLdVh4BA33+/9u6o6QgVR5GbMN8oksnUjA4FBNLMvWvQJFxsWr6oD+shriFrSdg
         /5IlF+eP3A6iNf3iapGjOy0C+wdDo/+/MyK7gmrwInxVJiYt/qDaA3foKI+mLkzRmrk/
         xAlg==
X-Gm-Message-State: AOAM5335jgMHIy0AMXlskM3eYOxkUHqnBiS1o+6YWJrVgZLEGGeUoyjv
        NfISi2D7Hm4Nf0CMykHIYCrD+eftu8Kcv13TUFSC56Kz1qr5j6Ey9oYtVmSbaRBUbCgbGFzRfzf
        sB8TsamIk5yICwG96wglTPlsUhJ8XiL8Ox1jkHJ9N6UxwltgE0faJ/g==
X-Google-Smtp-Source: ABdhPJyOo6nigqMS/g8tN8v1GXfAWeEQqAGTgm1HCeCqgUPoiO/TtAYjwhqpBhjOMuKjYTlEem/ytJw=
X-Received: by 2002:a05:6214:b30:: with SMTP id w16mr4758020qvj.28.1592347978506;
 Tue, 16 Jun 2020 15:52:58 -0700 (PDT)
Date:   Tue, 16 Jun 2020 15:52:55 -0700
Message-Id: <20200616225256.246769-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH bpf v4 1/2] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        David Laight <David.Laight@ACULAB.COM>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attaching to these hooks can break iptables because its optval is
usually quite big, or at least bigger than the current PAGE_SIZE limit.
David also mentioned some SCTP options can be big (around 256k).

There are two possible ways to fix it:
1. Increase the limit to match iptables max optval. There is, however,
   no clear upper limit. Technically, iptables can accept up to
   512M of data (not sure how practical it is though).

2. Bypass the value (don't expose to BPF) if it's too big and trigger
   BPF only with level/optname so BPF can still decide whether
   to allow/deny big sockopts.

The initial attempt was implemented using strategy #1. Due to
listed shortcomings, let's switch to strategy #2. When there is
legitimate a real use-case for iptables/SCTP, we can consider increasing
 the PAGE_SIZE limit.

To support the cases where len(optval) > PAGE_SIZE we can
leverage upcoming sleepable BPF work by providing a helper
which can do copy_from_user (sleepable) at the given offset
from the original large buffer.

v4:
* use temporary buffer to avoid optval == optval_end == NULL;
  this removes the corner case in the verifier that might assume
  non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.

v3:
* don't increase the limit, bypass the argument

v2:
* proper comments formatting (Jakub Kicinski)

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Cc: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/filter.h |  1 +
 kernel/bpf/cgroup.c    | 31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 259377723603..f4565a70f8ba 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1276,6 +1276,7 @@ struct bpf_sockopt_kern {
 	s32		optname;
 	s32		optlen;
 	s32		retval;
+	u8		optval_too_large;
 };
 
 #endif /* __LINUX_FILTER_H__ */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 4d76f16524cc..be78c01bf459 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1276,9 +1276,18 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 
 static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 {
-	if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
+	if (unlikely(max_optlen < 0))
 		return -EINVAL;
 
+	if (unlikely(max_optlen > PAGE_SIZE)) {
+		/* We don't expose optvals that are greater than PAGE_SIZE
+		 * to the BPF program.
+		 */
+		ctx->optval = &ctx->optval_too_large;
+		ctx->optval_end = &ctx->optval_too_large;
+		return 0;
+	}
+
 	ctx->optval = kzalloc(max_optlen, GFP_USER);
 	if (!ctx->optval)
 		return -ENOMEM;
@@ -1288,9 +1297,15 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 	return 0;
 }
 
+static int sockopt_has_optval(struct bpf_sockopt_kern *ctx)
+{
+	return ctx->optval != &ctx->optval_too_large;
+}
+
 static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
 {
-	kfree(ctx->optval);
+	if (sockopt_has_optval(ctx))
+		kfree(ctx->optval);
 }
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
@@ -1325,7 +1340,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	ctx.optlen = *optlen;
 
-	if (copy_from_user(ctx.optval, optval, *optlen) != 0) {
+	if (sockopt_has_optval(&ctx) &&
+	    copy_from_user(ctx.optval, optval, *optlen) != 0) {
 		ret = -EFAULT;
 		goto out;
 	}
@@ -1354,7 +1370,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		*level = ctx.level;
 		*optname = ctx.optname;
 		*optlen = ctx.optlen;
-		*kernel_optval = ctx.optval;
+		if (sockopt_has_optval(&ctx))
+			*kernel_optval = ctx.optval;
 	}
 
 out:
@@ -1407,7 +1424,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		if (ctx.optlen > max_optlen)
 			ctx.optlen = max_optlen;
 
-		if (copy_from_user(ctx.optval, optval, ctx.optlen) != 0) {
+		if (sockopt_has_optval(&ctx) &&
+		    copy_from_user(ctx.optval, optval, ctx.optlen) != 0) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1436,7 +1454,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		goto out;
 	}
 
-	if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
+	if ((sockopt_has_optval(&ctx) &&
+	     copy_to_user(optval, ctx.optval, ctx.optlen)) ||
 	    put_user(ctx.optlen, optlen)) {
 		ret = -EFAULT;
 		goto out;
-- 
2.27.0.290.gba653c62da-goog

