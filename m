Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530B64B003D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbiBIW2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:28:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbiBIW2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:28:25 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E9EE01977F
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:27:36 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id o5so3191026qvm.3
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3x9p3pCpwlKSG1m+jcqKD4VH4T7Zh9Qtt1uRAHJFIEc=;
        b=AFNmuBRrdA0Rn2i128mSB1ono01t0Yn218qLhKYuwr0lL8XAkNMhfj19G2BOo3/RjF
         DsbSnWzb01ilKfbBJz7A12kb5Onr9zENB579KQHMo8EhDU/EU5Pi98QX7UxMMXqYfwMb
         kmVQ0iz0cY1ZV2waA3VlDe2oZYiCVbgXHh++M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3x9p3pCpwlKSG1m+jcqKD4VH4T7Zh9Qtt1uRAHJFIEc=;
        b=4TzO5yx7iiOOvDKznxgJ2W8C1mrOySl8NSj4zgDlwjMA7QbRnioNyI66VaVj/79P2e
         QM3SZmR29T8bgKbuPMUcGrmAQ+DTMeFh5kEPjkh3Y1blnxPzqT9+vJAqaWOJm7S3mMsO
         qI9wbV0k3U08w4Ia3BVlr5r7kOwCjTxW0DswQbOg7Ry2k8nKsstrieB3++DrTin3/TJq
         /bLGos9qLiWdOsbEKEK6dWTlKTHGjNa6oC6Z+XDSgcZZvrrplhYaAmuIXLLSX0atVWt2
         22GBdIncOtfsEB+NkV1ImTYnYEiYgLmAWE/RssMJkj9f3eoyngmYKsjhWLUlcVrlFjrC
         XPXA==
X-Gm-Message-State: AOAM533daRPv26GjntROMWnrI62W1+JGX20vTC0CAJmPa9xONSun/5Pc
        dBqS4uP+UzeQlz5N57XW40cYaFK7CNdnvMm7KdCDzcnA7cwT6S6L6CvdNnGsdgyvhuRUv5j8uhp
        P8ilGTiv1ib+ZUYwvAotXZ6PtQIrg7Q9zKRBGaLORaDvpNJRufjWVh5jBOa8NOnsqi1lyqg==
X-Google-Smtp-Source: ABdhPJzMJAM+eeL8iG6gA7ZnPCvzmqPpJ5+yz3svE3zUcjnhuqNEw12iRLuS8DMn58OZkLHMPWr1lQ==
X-Received: by 2002:ad4:5f8a:: with SMTP id jp10mr3137887qvb.50.1644445653353;
        Wed, 09 Feb 2022 14:27:33 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h6sm9706287qtx.65.2022.02.09.14.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:27:32 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v6 2/7] libbpf: Expose bpf_core_{add,free}_cands() to bpftool
Date:   Wed,  9 Feb 2022 17:26:41 -0500
Message-Id: <20220209222646.348365-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209222646.348365-1-mauricio@kinvolk.io>
References: <20220209222646.348365-1-mauricio@kinvolk.io>
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

