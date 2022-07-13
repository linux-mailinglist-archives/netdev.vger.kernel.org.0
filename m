Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45385573AD6
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 18:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiGMQJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 12:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiGMQJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 12:09:45 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6801C237C0;
        Wed, 13 Jul 2022 09:09:43 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id l2so8686213qtp.11;
        Wed, 13 Jul 2022 09:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l7OBy2jXoTg8s36dQ++DUXMpilAnuGrXyLSTh8rtfcQ=;
        b=pY7+8gTXxdyxlnhuyWR1LFX8qHgwxLqYAdavHYf7FkyHm53d+Z8IJjCsHMFtgo+Yrr
         dLtR8xTiZpxrFtLQfstJfvguFLFKwHepFHbiFur6M/bPcxYX9XNRTrAsQxCynunKF9Ii
         FmEhqDJVYJeScbl6fL2YPwq6ZYDqYpgUtUdOvCHEQcSOUfbB/Id28mkzEqb22xMuECg5
         XwhZ4gFzkTIYfAYyMJFJXA9WQhiafcmWeFFoZPEIb7i8mHAw89QGnYC2x8S4QB+Suwnv
         eRMwMSzHZr6i/3TnuTRP+CebJI9psIFBkmxswiEIG5IXcJdF5FS85vgTyBB5/J/cpjad
         R8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l7OBy2jXoTg8s36dQ++DUXMpilAnuGrXyLSTh8rtfcQ=;
        b=hLW/LDpuxE2NIR88lJCMWNrf4EOfMzNXL0ZmCwsGgL3GZjVELv1ZEJs7V4oUx/SS7L
         d5gb6r7jmUBvT5iDtHaDcs9yhQxPeyxQQl9VPY6s/4JA1Qr7HqbIe/k8jXdOlH5+kNHS
         I1Uy2NqDgZSdWVKKltP3FQZGFr3BNFrsxc1c4af/+qIVtIz3aOpPgyn6gnuApxwjxabr
         YlJwsEb/hhGENsOHySGO+22/36WN+faizlQozWQa2Qft1iuCe59/y2MM+ytOYpzdo83e
         FL+BrPxpbuU5BBB2jPc+7qN+Oa7Pyo3fGJxrBYSta3M5P0UMrj77BwSESSocAeEcEOMQ
         pX5w==
X-Gm-Message-State: AJIora8DyKWCME9wHSR30+bGxqRPSJ/rL61lTJDjfzub3R2D8JN/iO4v
        QGf2WfhsDvrfp+GZCSpX+QI=
X-Google-Smtp-Source: AGRyM1s9tn4jzuLscb2/HIDf6XZU+pQOvc4nY7/Qh0kdiwc2er7aI+qRXEKbkd1UsKhBLoRZ5QP7kg==
X-Received: by 2002:a05:622a:199e:b0:31e:b14a:f2e5 with SMTP id u30-20020a05622a199e00b0031eb14af2e5mr3727291qtc.423.1657728582397;
        Wed, 13 Jul 2022 09:09:42 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:5c00:1117:5400:4ff:fe11:4f31])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87744000000b0031eca8c88f6sm1774161qtu.51.2022.07.13.09.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 09:09:41 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v4] bpf: Warn on non-preallocated case for BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE
Date:   Wed, 13 Jul 2022 16:09:36 +0000
Message-Id: <20220713160936.57488-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE is also tracing type, which may
cause unexpected memory allocation if we set BPF_F_NO_PREALLOC.
Let's also warn on it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

---
v4: warn on BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE only (Yonghong)
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 328cfab3af60..c5b11d772663 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12562,6 +12562,7 @@ static bool is_tracing_prog_type(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_TRACEPOINT:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		return true;
 	default:
 		return false;
-- 
2.17.1

