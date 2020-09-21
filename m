Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED0527236B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgIUMNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgIUMN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C9C0613D7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so12495233wrx.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kjCcJGj2jbSvcO5ugPvqsSQEkXN07N/VLAM4UYxhIGc=;
        b=MEYK9hz73AsJDa+xR2IMx1Ao4GplNoLwQ9YgnFqSLE4mPdOxTtrOnV95dVFKJb2LCz
         IkavBm5oeKk/JfSsKRez9i+N0pZGUmEUsvgsd91WxFpK/RSsT7z0Udf8uOGO0l7QMz6p
         wxzYqv6XS7FcpffJwXvhM8Ue+FWWMHUXnougE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kjCcJGj2jbSvcO5ugPvqsSQEkXN07N/VLAM4UYxhIGc=;
        b=Tv/1D8WDp9XwbWS4i17mTL9glz9Fce7C9ioqQXh7MLCih3yKaPzLnZUqXlkrqG10QA
         pk7spVxb54Kiquu5mYWT4hvvKhL7dO8W3t4FqKNdNCukzrLAbDkDp6NKL/hnl3hxsGoO
         h6KoDojG2MRsU/RD1UPby+3PvKfixLTc3s8e1ZtY9k7p4oP10s2UsZJlY9HIbtul/87M
         JTlJ28RIg/Rb2D1YgmeXR8wjhG/FSARIaFNLA+oCYEMHhjfT0Xm2/uhlqgr9+nfKle83
         DdRY+Xm7q5clFwX34pWGDR6Fw8gd92f41KAD17pPUxyvv5vrRm3a0lU0tsO1KzPhmqtZ
         DvEA==
X-Gm-Message-State: AOAM530I0obB0LrpWVP87aoyPk9UUOMZghMYHEU4TbWvVy/aM+982+eu
        oOsZlLKJlaSwsoMc9tx5Du3tWA==
X-Google-Smtp-Source: ABdhPJw83QENrSKGXPzIbGywqHbg92R6KMSBFNx5yxHhzcBSTNbRPElrwKntoenSM6uOmJn1M7jibQ==
X-Received: by 2002:a5d:4a4a:: with SMTP id v10mr47600466wrs.72.1600690405438;
        Mon, 21 Sep 2020 05:13:25 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:24 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 08/11] bpf: set meta->raw_mode for pointers close to use
Date:   Mon, 21 Sep 2020 13:12:24 +0100
Message-Id: <20200921121227.255763-9-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we encounter a pointer to memory, we set meta->raw_mode depending
on the type of memory we point at. What isn't obvious is that this
information is only used when the next memory size argument is
encountered.

Move the assignment closer to where it's used, and add a comment that
explains what is going on.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7d0f9ba18916..e09eedb30117 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4020,7 +4020,6 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			 type != PTR_TO_RDWR_BUF &&
 			 type != expected_type)
 			goto err_type;
-		meta->raw_mode = arg_type == ARG_PTR_TO_UNINIT_MEM;
 	} else if (arg_type_is_alloc_mem_ptr(arg_type)) {
 		expected_type = PTR_TO_MEM;
 		if (register_is_null(reg) &&
@@ -4109,6 +4108,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		err = check_helper_mem_access(env, regno,
 					      meta->map_ptr->value_size, false,
 					      meta);
+	} else if (arg_type_is_mem_ptr(arg_type)) {
+		/* The access to this pointer is only checked when we hit the
+		 * next is_mem_size argument below.
+		 */
+		meta->raw_mode = (arg_type == ARG_PTR_TO_UNINIT_MEM);
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
-- 
2.25.1

