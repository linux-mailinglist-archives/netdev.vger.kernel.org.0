Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E702F3EBE8B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhHMXGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbhHMXGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:06:05 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38563C0617AD
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 16:05:38 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id t3-20020a0cf9830000b0290359840930bdso4801421qvn.2
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 16:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0xr8nrUTTS+5d46OL567SQwU59+B4NtyiAMj6qZyKDg=;
        b=ZaOHWqRTi3/SjpvxeDmFoegXYtWrKhQjl1B7ZdEh7P42R5k8qboZ7kKjtoEM4zuECQ
         WU1F7llICxKOQM/f/eP2de5svU+pjZWAmm3LofFdACF7oGLp9CbTPSRVAt4Bm5m3wCEA
         ETBBNNxM5KmocCAMMBbYX5OkpGezTPYbU6QZIJyewSYxZk2q2Ppzf9OFso4RGT8vS5vO
         323J2g442DtLQ7lMz0Gva9T1XCkPaYl9TBL0k4NFT1rDONiEEiGXjeHIloOs4i/rdeZk
         LnelfCMYUFhmOQDVJ02MXvHE8tvP/G2+aWt8EA55B+rzBshodyTGKBXF8cw2IQoo3276
         H/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0xr8nrUTTS+5d46OL567SQwU59+B4NtyiAMj6qZyKDg=;
        b=c6HjCYNuGjKXzuAX8i7iieXDN45cgn7jgkTIhHal/aS8+QkgltDnaanHg50mx0Wm61
         fadXRWlG9rNqFwasn+3COeb2RnKC67v+qwoDUKNtOvSHx84QH4tL2M7i2JMTe33iDmJx
         lX5YxM976Yrrr6QnmrVV1DQOwuJWZCeOX+vVpaWRgRugh424gyDFBha+NSeXMj82Ly8V
         EccDrDlnfk5Zn5QS1S5s2GV9WjG417/DMW0iJ2h2IdUp7su7wwyFCdKyes6KBzFTpzt1
         fBXjT+6bOCeFUCH5I3O7A8Dyq9iJsGCoJLbXWHZl5WOL9IhtQnsuILPeUzJzN0uQK4dV
         Wv1Q==
X-Gm-Message-State: AOAM530LiIhaCX4bGa0gqVPLZiOO+H5H1KrCw+2QOYrzw2WOYxmL3nP2
        AvaXy1ZamRZ7uhj/G3Ampg6wIKwVJHpERBUKOciktN5Zt6t6kdsHyZUkBcj/9UwJdEhtk5hZ+5v
        cHClKzfVUJKbkoE0Z/eIQmSjJXWP19UMTMzRrMHIAAe1X7HIdxfWXcA==
X-Google-Smtp-Source: ABdhPJxMM2n8drgip6VNs5+SAbDoXZTQ0PI2bRFJ6gHuUMyRZlVi5D6QEqugvvYh639ySSNFY+LWWIs=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f73:a375:cbb9:779b])
 (user=sdf job=sendgmr) by 2002:ad4:5aa1:: with SMTP id u1mr5008609qvg.2.1628895937374;
 Fri, 13 Aug 2021 16:05:37 -0700 (PDT)
Date:   Fri, 13 Aug 2021 16:05:30 -0700
In-Reply-To: <20210813230530.333779-1-sdf@google.com>
Message-Id: <20210813230530.333779-3-sdf@google.com>
Mime-Version: 1.0
References: <20210813230530.333779-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: verify bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extra calls to sockopt_sk.c.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/progs/sockopt_sk.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index 8acdb99b5959..79c8139b63b8 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -33,6 +33,14 @@ int _getsockopt(struct bpf_sockopt *ctx)
 	__u8 *optval = ctx->optval;
 	struct sockopt_sk *storage;
 
+	/* Make sure bpf_get_netns_cookie is callable.
+	 */
+	if (bpf_get_netns_cookie(NULL) == 0)
+		return 0;
+
+	if (bpf_get_netns_cookie(ctx) == 0)
+		return 0;
+
 	if (ctx->level == SOL_IP && ctx->optname == IP_TOS) {
 		/* Not interested in SOL_IP:IP_TOS;
 		 * let next BPF program in the cgroup chain or kernel
@@ -123,6 +131,14 @@ int _setsockopt(struct bpf_sockopt *ctx)
 	__u8 *optval = ctx->optval;
 	struct sockopt_sk *storage;
 
+	/* Make sure bpf_get_netns_cookie is callable.
+	 */
+	if (bpf_get_netns_cookie(NULL) == 0)
+		return 0;
+
+	if (bpf_get_netns_cookie(ctx) == 0)
+		return 0;
+
 	if (ctx->level == SOL_IP && ctx->optname == IP_TOS) {
 		/* Not interested in SOL_IP:IP_TOS;
 		 * let next BPF program in the cgroup chain or kernel
-- 
2.33.0.rc1.237.g0d66db33f3-goog

