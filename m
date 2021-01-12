Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821732F2AE9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389838AbhALJO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729821AbhALJO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:14:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BCCC061794;
        Tue, 12 Jan 2021 01:14:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d26so1612780wrb.12;
        Tue, 12 Jan 2021 01:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLveLxeFrNvjHmoCR9A2oV0J+t8vyyrnKRnubdghhuU=;
        b=r2ZJ4ok+qcVmu0I2jzjZu0MSgognlZXsiDDUsoUpv+1D3BJAYs2T5/ZLUOcUkxWsgE
         eGOhsrXNXqcK2NNQObqqK3PuK/Gc9ptXmTSGsNkAC6LZ3hN65ldOXqBri/TAxN5xy3B/
         h8/4GHSJu7p9xOEoZkyqaLKUaSrHkmIlOtkNAmaBLM39TOz6tfoyxbk6d9EZ8NmV0gCe
         y38QmY6dKD/wQvpI9nDJqRUJQcmFg9lQpSGaKUCRaYRchqHRzZX5RB84YQYpnixKDmuF
         HDr2uw9847Ky3yKFsKZlQUnXK2nUYJXSu3YKUQ/Mj5wJsNXlgnzFjOU1soU2/EpbuTNe
         L7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLveLxeFrNvjHmoCR9A2oV0J+t8vyyrnKRnubdghhuU=;
        b=lgaXN//BaqHvzMxNXUQOBU4rXZe5cRyTLc+1YX6vrOUsmaPqcjeSwMvBGjuYfPxOE1
         ugdpfRoE19cMEOyjoK+GHgpLDiSLIDJEommmsdsswGLqITPhweWh9Vt47UXVKjVNnwvq
         H3aXCsMYy0iTjUt175N/vS7OueSNVPwStC0oyvyTykei4zqxzLkyIgMqqnKp3v+8CAYP
         s33YMxefCdzoxOcPDjV7Zqr4JFHV7Yy7ZKrIbE5NsIqlsWSfXEFbOpHpqC2+H5gyvSdq
         SlPFwRaARELs+A/eeDpBcdCbjhQUq9M78zijuWKWwqS7zVz3UiU+/zvDzSQu3ADKG+4A
         61Og==
X-Gm-Message-State: AOAM5332ZiOSLm2BOrI0Q0BShraZGE2MvOndwrTGMI6Up/QAnz/seJbT
        pSmrgZIpdmxcKkeWY+VWJsyF8bn0qcMlLpsu
X-Google-Smtp-Source: ABdhPJzm0yhMovj3Ab546X1eJnZs7ddAADGvQziQllXXPgWOqTQca81g/eYkvRZfdq49xeTN3Xm6cw==
X-Received: by 2002:a05:6000:18a3:: with SMTP id b3mr234261wri.373.1610442855164;
        Tue, 12 Jan 2021 01:14:15 -0800 (PST)
Received: from ubuntu.localdomain (bzq-233-168-31-62.red.bezeqint.net. [31.168.233.62])
        by smtp.googlemail.com with ESMTPSA id b10sm3085995wmj.5.2021.01.12.01.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:14:14 -0800 (PST)
From:   Gilad Reti <gilad.reti@gmail.com>
To:     bpf@vger.kernel.org
Cc:     gilad.reti@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register spilling
Date:   Tue, 12 Jan 2021 11:14:03 +0200
Message-Id: <20210112091403.10458-1-gilad.reti@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for pointer to mem register spilling, to allow the verifier
to track pointer to valid memory addresses. Such pointers are returned
for example by a successful call of the bpf_ringbuf_reserve helper.

This patch was suggested as a solution by Yonghong Song.

The patch was partially contibuted by CyberArk Software, Inc.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
support for it")
Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17270b8404f1..36af69fac591 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_RDWR_BUF:
 	case PTR_TO_RDWR_BUF_OR_NULL:
 	case PTR_TO_PERCPU_BTF_ID:
+	case PTR_TO_MEM:
+	case PTR_TO_MEM_OR_NULL:
 		return true;
 	default:
 		return false;
-- 
2.27.0

