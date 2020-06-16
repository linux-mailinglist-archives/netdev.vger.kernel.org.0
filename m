Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC181FC1E0
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFPWxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgFPWxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 18:53:01 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25613C061755
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 15:53:01 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id p138so346307qke.7
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 15:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uYsgrhTjCcqGyQB8lXECEJEUapoNfx1UfGYm5IkJ4oI=;
        b=GR2EV+/lzfNbzrsYKOLScf4qmSXmCjS0y5g4N/wEedUgv7CKJETvm+PFCmNTwLOIyc
         EbZoPFEesC/piai2EopxF9HlrhTGGdB5cgNXaghLxzjGKE7KzF0CZwVx+nlWGdmQLe4w
         wiexsJ2assORQz90b9Ll/6dJMBZEF3fRfG4sICR2K60y1UsGWDKowv8wjOeVC5Ca+l0+
         keHogopHQ5iRLKOgP7Ij3u/76sYTYSr1g7gixewsaS+Lr1iE7Sm0/N5Ls8OFhbnvtsUl
         jg1R8CxRu51klLCNQULhvHQ+sMgc0lmcHhJqmSqrr6DHF6td6OO3QfGV0f08qs4A8vIc
         dhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uYsgrhTjCcqGyQB8lXECEJEUapoNfx1UfGYm5IkJ4oI=;
        b=sHijQg6Qutrtvautnq/sO1SEO5YGMzwCo9wCbTQUi71k1U8TPZz5B0h7BwydQ0rju7
         NbGMm7iRqFl23JibLUPgoBKQFRSyed5ToUBwyHVbq4WwdRR4C+fRn4jgU4HQywPdAdlB
         1yq6l/USYyoEMTfs3Qzbb8WrWb6XgQanKLj/FEM6eMgp4BoEVxuvw2TmYU+TuZOcpTl5
         3a3uB07mq57WhNv01ZfUp5OMl28mSPxVX8kkU0mxg9QbWHMOg9b/sNrbcAV+/KEcGjka
         2e4OY8JpsMFjmDwUcinvVZi0SLTgr5NzHrokaPe3Vps4qLmbomZmJhSc0cWUMTpY/eUl
         4fCA==
X-Gm-Message-State: AOAM533lmoy+yMysyR6lPIjqstKToGzsw5hFGMGICUqyTsXGDxa7gqvX
        ZBDXMWSWAB21CfBC8Zg8l8IWRbghr2qX3cwT2aPH6IuDoZNNkSR7UQ9C9Sz/cqSnuFXLz8KB28R
        TNWbbSRsSKSPJToo2Bg542MYv5HFh+Eqz8R/H3ARsBC5q6iDUgSNZFw==
X-Google-Smtp-Source: ABdhPJym6qmBrOaD/XWHPFnQQ9VU+N/rS4SbDpmxR3OtujCYrBbq31OsXendMOUdEk/ZWdHrDfHK4uc=
X-Received: by 2002:a05:6214:332:: with SMTP id j18mr4517686qvu.172.1592347980266;
 Tue, 16 Jun 2020 15:53:00 -0700 (PDT)
Date:   Tue, 16 Jun 2020 15:52:56 -0700
In-Reply-To: <20200616225256.246769-1-sdf@google.com>
Message-Id: <20200616225256.246769-2-sdf@google.com>
Mime-Version: 1.0
References: <20200616225256.246769-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH bpf v4 2/2] selftests/bpf: make sure optvals > PAGE_SIZE are bypassed
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are relying on the fact, that we can pass > sizeof(int) optvals
to the SOL_IP+IP_FREEBIND option (the kernel will take first 4 bytes).
In the BPF program, we return EPERM if optval is greater than optval_end
(implemented via PTR_TO_PACKET/PTR_TO_PACKET_END) and rely on the verifier
to enforce the fact that this data can not be touched.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 26 +++++++++++++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 20 ++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index 2061a6beac0f..eae1c8a1fee0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -13,6 +13,7 @@ static int getsetsockopt(void)
 		char cc[16]; /* TCP_CA_NAME_MAX */
 	} buf = {};
 	socklen_t optlen;
+	char *big_buf;
 
 	fd = socket(AF_INET, SOCK_STREAM, 0);
 	if (fd < 0) {
@@ -78,6 +79,31 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* IP_FREEBIND - BPF can't access optval when optlen > PAGE_SIZE */
+
+	optlen = getpagesize() * 2;
+	big_buf = calloc(1, optlen);
+	if (!big_buf) {
+		log_err("Couldn't allocate two pages");
+		goto err;
+	}
+
+	err = setsockopt(fd, SOL_IP, IP_FREEBIND, big_buf, optlen);
+	if (err != 0) {
+		log_err("Failed to call setsockopt, ret=%d", err);
+		free(big_buf);
+		goto err;
+	}
+
+	err = getsockopt(fd, SOL_IP, IP_FREEBIND, big_buf, &optlen);
+	if (err != 0) {
+		log_err("Failed to call getsockopt, ret=%d", err);
+		free(big_buf);
+		goto err;
+	}
+
+	free(big_buf);
+
 	/* SO_SNDBUF is overwritten */
 
 	buf.u32 = 0x01010101;
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index d5a5eeb5fb52..933a2ef9c930 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -51,6 +51,16 @@ int _getsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
+		if (optval > optval_end) {
+			/* For optval > PAGE_SIZE, the actual data
+			 * is not provided.
+			 */
+			return 0; /* EPERM, unexpected data size */
+		}
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
@@ -112,6 +122,16 @@ int _setsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
+		if (optval > optval_end) {
+			/* For optval > PAGE_SIZE, the actual data
+			 * is not provided.
+			 */
+			return 0; /* EPERM, unexpected data size */
+		}
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
-- 
2.27.0.290.gba653c62da-goog

