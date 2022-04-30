Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08428515D3E
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbiD3NLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiD3NLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:11:48 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F168D8233A;
        Sat, 30 Apr 2022 06:08:23 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d15so9294064plh.2;
        Sat, 30 Apr 2022 06:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fVPoTVfoA8tVVI1E9eXJGEOkSXxyXZyAXt5cTczWhMQ=;
        b=EEdn93Uq8zk/Vsh4AHDf2M5jAH70LosPoCi0M5MUt5LvTWAbjmBwLOhdvYIiwF0WIZ
         CSdS4sXStWZucVBMRseVkdMhG+b5OXYKKnOOaB7A/XvuRXjarAgij7XcxFWVoLU4PXZ3
         Ii4SevsyujHyLEUKSx2juTOGjKg87oeNm7v2zqLfxehsu1HszeVBqvh/Jv+9qerpwjSu
         ah+GoZdF6LGCrU/0mueSI9sBhz0cPWvHyjsnW5lGYIqR9yPBH/5DlqSmtd3psk6rY6/E
         jVFF29+earsX0xkzgNPFDtJ87b2QczD1Jk/isXEM5aZlakF0Hlt0FbppdAPYImcmEyAF
         OJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fVPoTVfoA8tVVI1E9eXJGEOkSXxyXZyAXt5cTczWhMQ=;
        b=2oGqOxzTh7mx6wnxc/HfrSU+DldPqr51MS7pbR3PcGSJD7t1QOM1yBxxUFBUvbUxbC
         BIlcUsoY7MKMJUo3z5r5C40UAyhDc36gpneYZ/bP6tN3JlLj9k+ZSwOrcimCoujWwbf/
         jhxzCQQ/hGlYoPGIe9R7DGc08gZDDKNAWT2oAbwOy7kDyIoDyJjw0NggfLTagRkI2BK6
         qcFHKUNvyedozt1hxCNhjRLeUMLKrIoAcrrXlLp0WYfSiDp8UXXdECrfqQxzPo/cwzO+
         yXOLWZq6GdJx5qS/SrOr6MLjB2Z+VM6mKWwwo5aV5rv6mu3VDFJBVeej9T1OaT4Hqxbc
         BlcQ==
X-Gm-Message-State: AOAM531VTlTeXl+TQfAB6PQ5K0gDp07pXwSrsYx2Y9hUgI3jVqOM5l4s
        1/wv0kCM67jOF2J1L+5uGbr3/XufqwxU2nlS
X-Google-Smtp-Source: ABdhPJxZWYjTQ6c048DPd3h3iff6QNAe7B6Q2RXDRf2ojuLf0yEsNm/6NptTczoJk2uRjmjLPWEqdQ==
X-Received: by 2002:a17:90a:d58b:b0:1cd:65dc:6a62 with SMTP id v11-20020a17090ad58b00b001cd65dc6a62mr8896280pju.89.1651324103501;
        Sat, 30 Apr 2022 06:08:23 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id r14-20020a63e50e000000b003c14af5060esm8296261pgh.38.2022.04.30.06.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 06:08:22 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Fix potential array overflow in bpf_trampoline_get_progs()
Date:   Sat, 30 Apr 2022 21:08:03 +0800
Message-Id: <20220430130803.210624-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cnt value in the 'cnt >= BPF_MAX_TRAMP_PROGS' check does not
include BPF_TRAMP_MODIFY_RETURN bpf programs, so the number of
the attached BPF_TRAMP_MODIFY_RETURN bpf programs in a trampoline
can exceed BPF_MAX_TRAMP_PROGS.

When this happens, the assignment '*progs++ = aux->prog' in
bpf_trampoline_get_progs() will cause progs array overflow as the
progs field in the bpf_tramp_progs struct can only hold at most
BPF_MAX_TRAMP_PROGS bpf programs.

Fixes: 88fd9e5352fe ("bpf: Refactor trampoline update code")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/trampoline.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index ada97751ae1b..5d8bfb5ef239 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -411,7 +411,7 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
-	int cnt;
+	int cnt = 0, i;
 
 	kind = bpf_attach_type_to_tramp(prog);
 	mutex_lock(&tr->mutex);
@@ -422,7 +422,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		err = -EBUSY;
 		goto out;
 	}
-	cnt = tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT];
+
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		cnt += tr->progs_cnt[i];
+
 	if (kind == BPF_TRAMP_REPLACE) {
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt) {
@@ -500,16 +503,19 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
 
 void bpf_trampoline_put(struct bpf_trampoline *tr)
 {
+	int i;
+
 	if (!tr)
 		return;
 	mutex_lock(&trampoline_mutex);
 	if (!refcount_dec_and_test(&tr->refcnt))
 		goto out;
 	WARN_ON_ONCE(mutex_is_locked(&tr->mutex));
-	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
-		goto out;
-	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
-		goto out;
+
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[i])))
+			goto out;
+
 	/* This code will be executed even when the last bpf_tramp_image
 	 * is alive. All progs are detached from the trampoline and the
 	 * trampoline image is patched with jmp into epilogue to skip
-- 
2.36.0

