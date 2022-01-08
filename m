Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22EA4880E2
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 03:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiAHCWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 21:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiAHCWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 21:22:32 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C791AC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 18:22:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z30so3769552pge.4
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 18:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openresty-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=kGrdecSC3sPdHtWn9polPOvxxPNBR4DlkW3QJLsVlic=;
        b=KPgC6CipYjBN1/pAogCBoywf5xWdGJ/B9J1tE0Hjb5fDeS78+bRTKYKFp+dRTA50iR
         jO8NboZ1pDij5ZzWF1Bd/xLD8gjq3VCnc3rgCrlYet288M2HgQnc+N3crLRiaMjABrJ9
         GkBSXOqYM8tqEIG0zIOr5Mc6CBrdse+Mp8jQ10jmIqqKBrO/CDmWYjPAIfIRciBdMAMs
         j44VKzPle4WaUYSt/LQcPDR5GZF6ZVyzVFs5U/gvy1macxEh/jf0mRblD/Nr0dSMtBa2
         GkIKnNiSwbsZ/5wmDRnVM/hew30R1R9C/M7XRdzFVpFqBIS15pX4Uatv61K+MF2WHRqz
         h+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kGrdecSC3sPdHtWn9polPOvxxPNBR4DlkW3QJLsVlic=;
        b=m9ZhPpNbfwmuJvFwrmE+gow6OE6mYKJw+nmoYfOeEeJEfV3ev7QQpmD3QQV2tRT09j
         5eUYK9Z5w7PDjmbAEniWaosWKJMgP26sHwlneI/fC69RhX9un1gBbQoy0GBFGqoY39CS
         7MD6OM8dIdA5uu+IC4BWrt4CeNIGhff7MK+YqNq5FoA/2qKA0wswo81P3AgbyHTtbBgs
         WqNiA+LJBUidIafcQ+uH2ZfX4cqVj7FeRTUfTHXPl9e9Z56bY1MahCpcw+4frfGyloCm
         lwUFA9/8bdZ8DCH4Ea8EO1o5sY0xz4TEYLr8yAZtjsN4C17tBzaNbGvNYIBm4Y/x6J6A
         j/dA==
X-Gm-Message-State: AOAM533dezOQWmVxXtLlE1Sp/Lxjfu1/1vPIAFaoIhbVqpG2+eCkl8kd
        1NCEuB+YODbUDTD9cBcgAf251g==
X-Google-Smtp-Source: ABdhPJxCSy6VDT37VYN49wFdKlTjPScq9HkyQDn/tBoXW63qDWHpTqEY0bRELQJ9YMLrm9tBHwPbEw==
X-Received: by 2002:a63:af1c:: with SMTP id w28mr54159096pge.372.1641608552345;
        Fri, 07 Jan 2022 18:22:32 -0800 (PST)
Received: from localhost.localdomain (c-98-35-249-89.hsd1.ca.comcast.net. [98.35.249.89])
        by smtp.gmail.com with ESMTPSA id w2sm169050pgt.93.2022.01.07.18.22.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jan 2022 18:22:31 -0800 (PST)
From:   "Yichun Zhang (agentzh)" <yichun@openresty.com>
To:     yichun@openresty.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH] bpf: btf: Fix a var size check in validator
Date:   Fri,  7 Jan 2022 18:22:12 -0800
Message-Id: <20220108022212.962-1-yichun@openresty.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The btf validator should croak when the variable size is larger than
its type size, not less. The LLVM optimizer may use smaller sizes for
the C type.

We ran into this issue with real-world BPF programs emitted by the
latest version of Clang/LLVM.

Fixes: 1dc92851849cc ("bpf: kernel side support for BTF Var and DataSec")
Signed-off-by: Yichun Zhang (agentzh) <yichun@openresty.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9bdb03767db5..2a6967b13ce1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3696,7 +3696,7 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
 			return -EINVAL;
 		}
 
-		if (vsi->size < type_size) {
+		if (vsi->size > type_size) {
 			btf_verifier_log_vsi(env, v->t, vsi, "Invalid size");
 			return -EINVAL;
 		}
-- 
2.17.2

