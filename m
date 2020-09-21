Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F1327236F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgIUMNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgIUMN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:28 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719EFC0613D5
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:25 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y15so12401531wmi.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O8mI6GHH25/RwxEPJ9d1rEplqdAhaWXBqgldUo4yRSY=;
        b=ZlxmKwtVnJmDLtZwGyrMeHkNiKj+SM+y82vPFblqwrSnTVnCjpRVVweHgVKO+Leaya
         1WUjxRbzMdMvY2JK0U0h3tmfSmFiMKHc/3nNm5CZnGD2yq9o/KGDt4bnPWOlBLd7lD3t
         AnpAzAYBaKltQ33qDcTShS3oTCyrq/b+oPqbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O8mI6GHH25/RwxEPJ9d1rEplqdAhaWXBqgldUo4yRSY=;
        b=H6go0dXc3Gtev1RwW6HBMLtcf5SgmYrxjwtbRHPk8zuFZ00550gUa2Xx3ul0UmhKrZ
         LUkabVbERPTyKLfeYpkoW8qfyY66vc9j2tD7arbea9e+Ciq6Kgw7cUSuJH1yaps2WiTc
         Gq1hemUxx/6j6u5O96sRt/mTGfpVtTd6Dc2W5zYje+mIqA+CE7YHmxNQqDAWUaVN4tar
         d6uKgUvMDYQ1gc8Hnu4Qmh8iUhsjNuhIcsqhLGByYF9jt8bLnp3Q7ukV4mTZ7S4zJnZC
         x0BtZBAL0oVxjFvk+yPkaxGlBGPCsPPjifZK+TBeQxge9TyDMJKv33joXS/qsqLN3fac
         MReg==
X-Gm-Message-State: AOAM531WhsZe8be19YecINNpMIVckncWATv7Bj6rRLupBC5p2Tu6b2gl
        uCVa/RFU9+oBo9YEIeVNn8EtBQ==
X-Google-Smtp-Source: ABdhPJzXR+4Tunbp6gBRvat1r4iz1CAdywj0QfSXgcIx3scL0r4V/rPQeyySy/6uYH/BoIHRak0lKA==
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr30505755wmj.16.1600690404201;
        Mon, 21 Sep 2020 05:13:24 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:23 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 07/11] bpf: make context access check generic
Date:   Mon, 21 Sep 2020 13:12:23 +0100
Message-Id: <20200921121227.255763-8-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always check context access if the register we're operating on is
PTR_TO_CTX, rather than relying on ARG_PTR_TO_CTX. This allows
simplifying the arg_type checking section of the function.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0f7a9c65db5c..7d0f9ba18916 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3974,9 +3974,6 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		      arg_type == ARG_PTR_TO_CTX_OR_NULL)) {
 			if (type != expected_type)
 				goto err_type;
-			err = check_ctx_reg(env, reg, regno);
-			if (err < 0)
-				return err;
 		}
 	} else if (arg_type == ARG_PTR_TO_SOCK_COMMON) {
 		expected_type = PTR_TO_SOCK_COMMON;
@@ -4060,6 +4057,10 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 				regno);
 			return -EACCES;
 		}
+	} else if (type == PTR_TO_CTX) {
+		err = check_ctx_reg(env, reg, regno);
+		if (err < 0)
+			return err;
 	}
 
 	if (reg->ref_obj_id) {
-- 
2.25.1

