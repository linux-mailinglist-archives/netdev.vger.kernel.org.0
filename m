Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBAE4B7AE3
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244333AbiBOW7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:59:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243447AbiBOW7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:59:38 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55932E3891
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:27 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id l14so378725qtp.7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tILw9h+EVi7AbXoT3aBKukUH7qRYvz45UG177GTgJcA=;
        b=E0s49Ieh/pRwCbrvJI0Ml24cAt3gha4CsccQqGePikrjRoWn3N4IqnV/pO7FCPIpH9
         XQ7wWqJqO64U130d6jyLkIqPwKddLp3ej78YtkQ26ebESRUo5yVwj/o04o28+8SzJRl+
         5fuNytIvF1gltk8ThVCTZhUtm++XEVMrHFxUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tILw9h+EVi7AbXoT3aBKukUH7qRYvz45UG177GTgJcA=;
        b=mJ0n3c5hLu6AtGHsM9PV1CksnY/dL2IkWS+zKuDMb9bt/6To15t8FKDiE3dquBtcWQ
         6aZPHKHbzWur3gwXmVFd6K//aDBc+jgKAksZ9aX5xvrjAAAchYxrKx7LUDaBRNm1NpZq
         er+l0ol6eAb5zZLzzWRIqk+K0EVDwHC5J0A07lGU8Ho0Svn3oV0ImcLEzygFHKeoaRpX
         G8U28MK0TnKWPNpSTt4AsDoihybWy8eyxqFX6i+eUGHje0o0oDtI2fIMyMwBOKzTYDwh
         4+NXKzP7Ob7bM+JCdrdxW7uGg2A+e1lo73IoEoaATaH9CDVHbvXzW4pE+am3syNEh8n2
         pQ7w==
X-Gm-Message-State: AOAM530cMEAt9JSFK2GR0AgB/e2NT5JllyB5YJ5rRUWs1R7P91RtOlkd
        MPBLnGH5MDtdpe9Lc0agA7VyRmlLQeUEi+4MWcgH87ChaZgbIHsL7jTkQbkv87a8X8dRfDW7cu0
        VSf1+Zoy/smNf4i0xwVHgT0P3SeoLyNnAVsLhj3ah0IUFFYAeTV9IEMw9nPrtYQC8U7UnBw==
X-Google-Smtp-Source: ABdhPJzCVeUfxFIW/q9anmSD7aSdm8aJUUyIXaIl2XdvfvUaWgD/U9oKbtSjClBLYE5LdAzvkkimZA==
X-Received: by 2002:a05:622a:205:b0:2d0:a81d:73f3 with SMTP id b5-20020a05622a020500b002d0a81d73f3mr195020qtx.538.1644965964297;
        Tue, 15 Feb 2022 14:59:24 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id w19sm15520021qkp.6.2022.02.15.14.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:59:23 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v7 2/7] libbpf: Expose bpf_core_{add,free}_cands() to bpftool
Date:   Tue, 15 Feb 2022 17:58:51 -0500
Message-Id: <20220215225856.671072-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215225856.671072-1-mauricio@kinvolk.io>
References: <20220215225856.671072-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose bpf_core_add_cands() and bpf_core_free_cands() to handle
candidates list.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 17 ++++++++++-------
 tools/lib/bpf/libbpf_internal.h |  9 +++++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d3c457fb045e..ad43b6ce825e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5192,18 +5192,21 @@ size_t bpf_core_essential_name_len(const char *name)
 	return n;
 }
 
-static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
+void bpf_core_free_cands(struct bpf_core_cand_list *cands)
 {
+	if (!cands)
+		return;
+
 	free(cands->cands);
 	free(cands);
 }
 
-static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
-			      size_t local_essent_len,
-			      const struct btf *targ_btf,
-			      const char *targ_btf_name,
-			      int targ_start_id,
-			      struct bpf_core_cand_list *cands)
+int bpf_core_add_cands(struct bpf_core_cand *local_cand,
+		       size_t local_essent_len,
+		       const struct btf *targ_btf,
+		       const char *targ_btf_name,
+		       int targ_start_id,
+		       struct bpf_core_cand_list *cands)
 {
 	struct bpf_core_cand *new_cands, *cand;
 	const struct btf_type *t, *local_t;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index bc86b82e90d1..4fda8bdf0a0d 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -529,4 +529,13 @@ static inline int ensure_good_fd(int fd)
 	return fd;
 }
 
+/* The following two functions are exposed to bpftool */
+int bpf_core_add_cands(struct bpf_core_cand *local_cand,
+		       size_t local_essent_len,
+		       const struct btf *targ_btf,
+		       const char *targ_btf_name,
+		       int targ_start_id,
+		       struct bpf_core_cand_list *cands);
+void bpf_core_free_cands(struct bpf_core_cand_list *cands);
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.25.1

