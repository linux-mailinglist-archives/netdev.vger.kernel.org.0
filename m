Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39262AE7B6
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 06:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgKKFDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 00:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKKFDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 00:03:53 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BABC0613D1;
        Tue, 10 Nov 2020 21:03:53 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h4so100013pjk.0;
        Tue, 10 Nov 2020 21:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dYRnJX7E52Qr8q+Y6mWaepyoKc/zmQ6oafgF1OqoAbs=;
        b=uEhw4nBRsv6FaF+7krKDl7sr30gt6Yj731sECCjJRsMnIht4l9rPIOtKXhiAq1tfS2
         tMhrxyIkwny9Fg4OL9WmatdEcRZvXnw1ONJ009EkxIdOd3UT+c0ePTFg+VhLmW8xONFh
         LRJXPNSTjaFZ/3cCk8ZuNXr6DmQyfY0G4RPi9BT3i3Nth0H9KZ3siKUgtSERUmIFG8ws
         c3OXL10Z4HaUeJLfGDONBpedGrugvbAY3rNOyD5Ok7pQGcIukLubR6CKUymj9ChqZDFJ
         962o8pJYh4Trv2bF9XvAyD8YSP+HV1Gy+gxBpuVIHNACpJWbuIFa1vuMe0epu0UD2bos
         kbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dYRnJX7E52Qr8q+Y6mWaepyoKc/zmQ6oafgF1OqoAbs=;
        b=B8tuwmz1D4T6oN0m59d9THLBEYMjv4aCzg6gO2KwLgMTCyAEFm2odn6mVwui3J1Wk3
         i9U6RWypD6436hrdHgq/Lo3gTJKAE9clmaM4S3vju2940vtraEXK2Ks5P+l+QKe7Tnii
         TxVkZcnkxNVNIDyCfyGRtsNOmhyE+FDz5n+QRIzc4oj/c6uERIXHECD7uOBO3P9ZZ94d
         1b8vfAkoO1jLCFWKfoytjocBuh7Th+sPVAWChkywOu/Y1SBmLWTFyZwD/iI8atR/O/rI
         L+80rReBtsKy0of6rC26+la+DIpOTHAE6pZ11T77/VPhPjA6FzJq5nle9oruHxJXRJRD
         0kBw==
X-Gm-Message-State: AOAM533mbEp0BQbMXvR9z6yC5qv+0E3At/kON+Pku6r/lQ0UENFNpOBm
        OL2sQT+drrsbUF89VO/8Mw==
X-Google-Smtp-Source: ABdhPJx2jvTgyuea3Ejr0/Y0MbxVTWYXDd89GtP0F70JjQo3LU/KczLNudUpsIA27TZN1nl/1q2BQg==
X-Received: by 2002:a17:90b:512:: with SMTP id r18mr2097099pjz.149.1605071032934;
        Tue, 10 Nov 2020 21:03:52 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id t74sm800093pfc.47.2020.11.10.21.03.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 21:03:52 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
Date:   Wed, 11 Nov 2020 13:03:46 +0800
Message-Id: <1605071026-25906-1-git-send-email-kaixuxia@tencent.com>
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
v3:
 -put the changes on the proper place.

v2:
 -split out datasec_id definition into a separate line.

 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6200519582a6..6204ec705d80 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9572,12 +9572,13 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			       struct bpf_insn *insn,
 			       struct bpf_insn_aux_data *aux)
 {
-	u32 datasec_id, type, id = insn->imm;
 	const struct btf_var_secinfo *vsi;
 	const struct btf_type *datasec;
 	const struct btf_type *t;
 	const char *sym_name;
 	bool percpu = false;
+	u32 type, id = insn->imm;
+	s32 datasec_id;
 	u64 addr;
 	int i;
 
-- 
2.20.0

