Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC179B86
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbfG2VvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:51:18 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:40866 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388897AbfG2VvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:51:17 -0400
Received: by mail-pg1-f201.google.com with SMTP id m19so24631608pgv.7
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kBhb0smtLVURD2BBgCfZlpeNqb/3JQfxJqN7MROUQRA=;
        b=hl8xMzZ6ToLMJfpw4O1KGxQFHfHFvvJ/u9S7aHuViuIoUvUvP7ITYfCPIAGUKRBJWX
         EEqZ6FeqreQXt2/+LMXNXqH1RGNMwUUrR47Qur1d2NnOLYcVcg1bzfH8R7r++0dzPurZ
         sGRhBjL0Pr0RphEbvl1FLBSZidHCs1d9jaV7Y1wI6SRU6FY5JHZMRFSKLquP/HBVnaE2
         3oK7wq4bRSVaiFIwfEYmgxwcMLCiheJgwTek6uEtuz9nOXzQE1Ui78uIDnrv0pafTkhe
         5Znt4TQNLnfI5OkZrEhD+oDq9E0pQ/ZIekdq5sGqNLq/yLA3C8vMc0Ii4dWwfiPQNnty
         cRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kBhb0smtLVURD2BBgCfZlpeNqb/3JQfxJqN7MROUQRA=;
        b=GGOoEfeJk9VzQOp/31P/lv1zWyp+Nhjp5b4qI4yUCdkA6J5OuYB2xoPkcibbFMdRq1
         cCvZRw6jajpfbu+cU3cMeU/eYdvdyBMyfvi0wMtnyWiJXUfav3FaVfE2hDGl15v5mAnr
         iO5RCyUm//Joy+clfCdswQn9FaoaliZW9aIF7R26ZHU9D37bg6bvdhGo95/mEc/EUe/q
         qxwLcHVvaQpd25MOc7ufiLAdh3knwkSoEirTg2yothLgkvClIrKdmmV95qeCgRTxLgP/
         f30/2A4WYhgu6FbVNCigAho1GpuTx0yBDSwRoef/g1Ek44yWKXSEppQESf2c57IW4W2u
         Sx8A==
X-Gm-Message-State: APjAAAX43XkaxQpM/yp0tQ3EoqnEQo8f4NueoSAUM/UUXPh8zio0c/31
        jcfxwBqJ8GXGzF8ijKbWl3zZCFmhViU+OD4bFAkkTFqsZ/L1RZN5lTqhyRg+WhB7JRQWENypTYF
        bS45TL+8c8a5Iz9PYzMkkKFgmT7w5Xwnl1QxM4XpkQUTxqKPb+kAc5A==
X-Google-Smtp-Source: APXvYqzOCoB3RhL/aGtJLgOCdcyWpnmkHSq3WV5WrLAx+O1Rkon6J0XFjZ1N2peLo+Y6WRlPnQl6W2s=
X-Received: by 2002:a63:505a:: with SMTP id q26mr103339803pgl.18.1564437076749;
 Mon, 29 Jul 2019 14:51:16 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:51:10 -0700
In-Reply-To: <20190729215111.209219-1-sdf@google.com>
Message-Id: <20190729215111.209219-2-sdf@google.com>
Mime-Version: 1.0
References: <20190729215111.209219-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next 1/2] bpf: always allocate at least 16 bytes for
 setsockopt hook
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we always allocate memory, allocate just a little bit more
for the BPF program in case it need to override user input with
bigger value. The canonical example is TCP_CONGESTION where
input string might be too small to override (nv -> bbr or cubic).

16 bytes are chosen to match the size of TCP_CA_NAME_MAX and can
be extended in the future if needed.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/cgroup.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 0a00eaca6fae..6a6a154cfa7b 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -964,7 +964,6 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
 		return -ENOMEM;
 
 	ctx->optval_end = ctx->optval + max_optlen;
-	ctx->optlen = max_optlen;
 
 	return 0;
 }
@@ -984,7 +983,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		.level = *level,
 		.optname = *optname,
 	};
-	int ret;
+	int ret, max_optlen;
 
 	/* Opportunistic check to see whether we have any BPF program
 	 * attached to the hook so we don't waste time allocating
@@ -994,10 +993,18 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	    __cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_SETSOCKOPT))
 		return 0;
 
-	ret = sockopt_alloc_buf(&ctx, *optlen);
+	/* Allocate a bit more than the initial user buffer for
+	 * BPF program. The canonical use case is overriding
+	 * TCP_CONGESTION(nv) to TCP_CONGESTION(cubic).
+	 */
+	max_optlen = max_t(int, 16, *optlen);
+
+	ret = sockopt_alloc_buf(&ctx, max_optlen);
 	if (ret)
 		return ret;
 
+	ctx.optlen = *optlen;
+
 	if (copy_from_user(ctx.optval, optval, *optlen) != 0) {
 		ret = -EFAULT;
 		goto out;
@@ -1016,7 +1023,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	if (ctx.optlen == -1) {
 		/* optlen set to -1, bypass kernel */
 		ret = 1;
-	} else if (ctx.optlen > *optlen || ctx.optlen < -1) {
+	} else if (ctx.optlen > max_optlen || ctx.optlen < -1) {
 		/* optlen is out of bounds */
 		ret = -EFAULT;
 	} else {
@@ -1063,6 +1070,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	if (ret)
 		return ret;
 
+	ctx.optlen = max_optlen;
+
 	if (!retval) {
 		/* If kernel getsockopt finished successfully,
 		 * copy whatever was returned to the user back
-- 
2.22.0.709.g102302147b-goog

