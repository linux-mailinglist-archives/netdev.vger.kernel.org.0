Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEECC272367
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgIUMNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgIUMNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:19 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE68BC0613D1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so12395829wmb.4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Qf5LrUrrFDb7ZG/DC+Ibysm2jzcOs3sVRYjuHbV+04=;
        b=In/nYtmFwJzMbBug5p7vdYS0mHscrMy/mUPclVvZH7QWrY+KakdP/YsmU2wTir43lv
         cPPI56SI/FBvhemkEjnGe7L5ZPngZuXznkdyGiXx+QKhsLLGBPi751wNECTe1Jv63fau
         UBN09GaOJYaBeX2pNbzQMMcyGdKp0J6X1KqdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Qf5LrUrrFDb7ZG/DC+Ibysm2jzcOs3sVRYjuHbV+04=;
        b=Fh+2EnYw6SnSMAH88cDWy/AuD38bEgLk0N8ZgzI0Mw8mBfILNZuYwk7Zz+pDXePYu/
         MkWnCtdZya48qIgX0xCrEnXVJ/PbiBFzInjmukzpzlK5Ml5iHwv6SjBS8IbqwcAHCnAx
         oxMvknEmbFu/wIFR/JXbTY0PtEWwu7qLNf0ud5xV+g7jCIKQaiVuIOZpQA3GVlW7Z9BL
         EXEAHvYHIN4y2r0Lp89ROywhoALbLL+Gn3a6mBXlfKhPjGxwo5KVyTUO4FMT2+PCx+i2
         F3j065BCu65PhCd8aKImIyPUSreTGPqNDEX5WjOY4hO0EgOO8waMjmwR+lcIq+NaPUB/
         GsmQ==
X-Gm-Message-State: AOAM533yaZmlEee50UW8CNAnNeMiS8GZ2xs3/EZj8dtYyLkwpoSUryJv
        imk6sbmyI/PgS876KutBKlucMw==
X-Google-Smtp-Source: ABdhPJzynkzl86XscjoKSbryUrk4hodhxiSLWtSLy+3c8NwhJbhOzuStSQNHpNtaeqho7eHUEEWjKg==
X-Received: by 2002:a1c:6341:: with SMTP id x62mr30056809wmb.70.1600690397457;
        Mon, 21 Sep 2020 05:13:17 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:16 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v4 02/11] bpf: check scalar or invalid register in check_helper_mem_access
Date:   Mon, 21 Sep 2020 13:12:18 +0100
Message-Id: <20200921121227.255763-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the check for a NULL or zero register to check_helper_mem_access. This
makes check_stack_boundary easier to understand.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/verifier.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 814bc6c1ad16..c997f81c500b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3594,18 +3594,6 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 	struct bpf_func_state *state = func(env, reg);
 	int err, min_off, max_off, i, j, slot, spi;
 
-	if (reg->type != PTR_TO_STACK) {
-		/* Allow zero-byte read from NULL, regardless of pointer type */
-		if (zero_size_allowed && access_size == 0 &&
-		    register_is_null(reg))
-			return 0;
-
-		verbose(env, "R%d type=%s expected=%s\n", regno,
-			reg_type_str[reg->type],
-			reg_type_str[PTR_TO_STACK]);
-		return -EACCES;
-	}
-
 	if (tnum_is_const(reg->var_off)) {
 		min_off = max_off = reg->var_off.value + reg->off;
 		err = __check_stack_boundary(env, regno, min_off, access_size,
@@ -3750,9 +3738,19 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 					   access_size, zero_size_allowed,
 					   "rdwr",
 					   &env->prog->aux->max_rdwr_access);
-	default: /* scalar_value|ptr_to_stack or invalid ptr */
+	case PTR_TO_STACK:
 		return check_stack_boundary(env, regno, access_size,
 					    zero_size_allowed, meta);
+	default: /* scalar_value or invalid ptr */
+		/* Allow zero-byte read from NULL, regardless of pointer type */
+		if (zero_size_allowed && access_size == 0 &&
+		    register_is_null(reg))
+			return 0;
+
+		verbose(env, "R%d type=%s expected=%s\n", regno,
+			reg_type_str[reg->type],
+			reg_type_str[PTR_TO_STACK]);
+		return -EACCES;
 	}
 }
 
-- 
2.25.1

