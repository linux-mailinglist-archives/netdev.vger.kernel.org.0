Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B6A32C3FB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354702AbhCDAJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842927AbhCCKWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:22:37 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFDC08ED9A
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:18:31 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l22so4697354wme.1
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m7RqUGlAZKFc49U41qGqNoOsHvlpZbIedEeyhnhCTbI=;
        b=vFfwPzKlE69j0Ac264LeBOMMNkh5yehzQtSMAQqvigC5zP+/hXV+uLzg8Bc4lttfCj
         zGIZDfDDf5BNigZOi7IZ73eL1QGUkhtV7i+sanHxQiE1AFxvlF/IJa5m1NW2RfwnMpnb
         4LkowWVoSUb5oS/D3wuxZbKsTjQhTNRSNTq1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7RqUGlAZKFc49U41qGqNoOsHvlpZbIedEeyhnhCTbI=;
        b=K5R63blFyHCE2j6MC1h87jUVQTFu6ZW/htAQId0SwMrn/AATehZqOJsiVcm/QTKb2k
         pT5+/jWkId4hYhN575x48g8TezHTVV9yk5ET4KSQl1iEGElLHn4RclirJWR89V5ijaAi
         P5ned42l7kUwJb/vk1VaO5d1P5qqDB1hRySOQ5CG0f74LjXNU5r4xAFLiv1wTyUFyRIk
         sPvSSF/ErRF1ReClxsGkZ90zQMEYLvz6X3cZNrIPCozvbmTUn8lRF6wGkJ3a/ZbfHZh1
         Dpp/yaBrIaWnIyBqyLi5qZuYE7Ya5svpFR1U2YK99vNFM4g7OTobmL/leHHzJlZjYF8c
         qZ5w==
X-Gm-Message-State: AOAM530eeTdXl4vIoHkc5R5FSNmw+hOcCUMGyn9oK5G7fwrpUsJsPUgA
        a1BjKWm7U4+L/j/tLGew9/JIkrMZ8sqHkQ==
X-Google-Smtp-Source: ABdhPJzXfkuGxJzNyeUuwV29XXHgjHZK0WPs/8olb4JlJXIcOzbOdocjnf6xPFm8S8FwTiONnv97tA==
X-Received: by 2002:a1c:7ed4:: with SMTP id z203mr7985456wmc.89.1614766710353;
        Wed, 03 Mar 2021 02:18:30 -0800 (PST)
Received: from localhost.localdomain (c.a.8.8.c.1.2.8.8.7.0.2.6.c.a.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1ac6:2078:821c:88ac])
        by smtp.gmail.com with ESMTPSA id r26sm1710761wmn.28.2021.03.03.02.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 02:18:30 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v4 5/5] selftests: bpf: don't run sk_lookup in verifier tests
Date:   Wed,  3 Mar 2021 10:18:16 +0000
Message-Id: <20210303101816.36774-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303101816.36774-1-lmb@cloudflare.com>
References: <20210303101816.36774-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_lookup doesn't allow setting data_in for bpf_prog_run. This doesn't
play well with the verifier tests, since they always set a 64 byte
input buffer. Allow not running verifier tests by setting
bpf_test.runs to a negative value and don't run the ctx access case
for sk_lookup. We have dedicated ctx access tests so skipping here
doesn't reduce coverage.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/test_verifier.c          | 4 ++--
 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 58b5a349d3ba..1512092e1e68 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -105,7 +105,7 @@ struct bpf_test {
 	enum bpf_prog_type prog_type;
 	uint8_t flags;
 	void (*fill_helper)(struct bpf_test *self);
-	uint8_t runs;
+	int runs;
 #define bpf_testdata_struct_t					\
 	struct {						\
 		uint32_t retval, retval_unpriv;			\
@@ -1165,7 +1165,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 
 	run_errs = 0;
 	run_successes = 0;
-	if (!alignment_prevented_execution && fd_prog >= 0) {
+	if (!alignment_prevented_execution && fd_prog >= 0 && test->runs >= 0) {
 		uint32_t expected_val;
 		int i;
 
diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
index fb13ca2d5606..d78627be060f 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -239,6 +239,7 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.runs = -1,
 },
 /* invalid 8-byte reads from a 4-byte fields in bpf_sk_lookup */
 {
-- 
2.27.0

