Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D492AE6AA
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgKKC7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgKKC7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 21:59:08 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3BEC0613D1;
        Tue, 10 Nov 2020 18:59:08 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id z24so510781pgk.3;
        Tue, 10 Nov 2020 18:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cmuGKLPg2fKagnBNFJRp+kMIsgYat3uEwShsaWeBPng=;
        b=Ef5p3IggSZLJhFBl2qc/e6vxrUxuAzOZNi89+cd8dEiinnEfE5snSJzCPWf+ETVAC1
         yzctav2eYJrGoDF+XW9fyZQcNi4nzRaBCZnLxzsO/k0MrYDKixQ9S0mgWc9E+YfSJDb4
         /g/CGQJnaGW/P4K+xpw8OJZMGfUsDnFKV+bd5U4siPRPnOR3jnmLmh95nSnml9iqYFCI
         KLNRRlUGFAID1lpwYdYztaC1EMfLlcNl1XsU3/b7FdaPfvDDqFyXh5JGMtST9axNyyud
         dFoq/WSE4YtOt3nAZKRklzdkxi8T26oqUVRxQGA9Dy5HHJdriDcfzUu1vZsiGYQ+S11g
         0RdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cmuGKLPg2fKagnBNFJRp+kMIsgYat3uEwShsaWeBPng=;
        b=o6pvkmwEcTWNs0UjOk8NnopSyPA4S83dErc32s5nDwr418LJsjO9rbcL2yqz4UyPW0
         Osa0TpkBPrQOSjt1CfbOBGKunTWfm3IP9b/2YVvDfLxoq897oSWjCd41k0lLYCoB5eIk
         Qed83xktNf4EMKNakidqexWXAvEEQ/nBqm1Hpy6QsVdWnbLUkDWRIzZ5XfsXLomhiFDV
         VloXybFWQFeONOK1V8Q0Jft8HOMv/bv708e5usMRnxT4Y77WGIFYoqHY/j8Lh5BA3kMD
         38fDBSWDXQAYvbCow0Bf+dJ8rudMxjKuk3HQyA11HsSEiaARt85zsXEdMRAUgIDsjXUt
         fCKA==
X-Gm-Message-State: AOAM5337HfTWo6SaHy+z2+fHGVrQwY1B3TQDB8jX8EpAuaaK3ZTKajIn
        p1lE5n7gEOmYh/kK7WlAxA==
X-Google-Smtp-Source: ABdhPJyCD/INw5TfkdrEJdz6unWyFxd6yWmxkZ6tciyzS1mOFwlYNbMb2dXA9UAy3egxk9ggwCMksA==
X-Received: by 2002:a17:90b:3314:: with SMTP id kf20mr1679065pjb.156.1605063548230;
        Tue, 10 Nov 2020 18:59:08 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c15sm406051pjc.43.2020.11.10.18.59.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 18:59:06 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
Date:   Wed, 11 Nov 2020 10:59:01 +0800
Message-Id: <1605063541-25424-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The unsigned variable datasec_id is assigned a return value from the call
to check_pseudo_btf_id(), which may return negative error code.

Fixes coccicheck warning:

./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared with zero: datasec_id > 0

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
v2:
 -split out datasec_id definition into a separate line.

 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6200519582a6..3fea4fc04e94 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9572,7 +9572,8 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			       struct bpf_insn *insn,
 			       struct bpf_insn_aux_data *aux)
 {
-	u32 datasec_id, type, id = insn->imm;
+	s32 datasec_id;
+	u32 type, id = insn->imm;
 	const struct btf_var_secinfo *vsi;
 	const struct btf_type *datasec;
 	const struct btf_type *t;
-- 
2.20.0

