Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9F5604E9
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiF2PtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiF2PtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:49:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1879523BCE;
        Wed, 29 Jun 2022 08:49:02 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id jb13so14494043plb.9;
        Wed, 29 Jun 2022 08:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vxAcFzym4yK6vclsN66EpoJd/l4weH1dmVD/ChYTtkY=;
        b=qv3H0fb6lRBBnyIfBFvc4vOdOCgLdTn2jfPqphNv5dY2pelqa8RtvYeYnJMTTWQ27m
         QHQh8W1xPacszWuUibRB1oy5UTOCr1cGgq3cGtvaeAoatwJ2gH0xuvwYlQ0vdBrxXYc4
         00KKDdqbMPT2nujw+sJmGNYqg3g+hAYpdXPrkNnBr2yHX3fkfH1i2kMdEztjTZMgMI/m
         638y1PtcTmkoOtvbtooxrvlCZLrvy6qzw45L/upyFRwJy4iPTWb3prU/vBEI/XTy3j9n
         Lu1q8cFkkPr+I+6pMAY1jPybjDqkDx3Iw1LxTIQlUxSuIwtQAtAtO3SV0yzGZ4MUpZ0q
         WTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vxAcFzym4yK6vclsN66EpoJd/l4weH1dmVD/ChYTtkY=;
        b=DrErbb+ldO06g8rnhEFk8U9pbRLWp26+4HW2hM1Hb48kc2Tll3lCe1+U7ta7bL03wN
         ovf9NJwr/+ABF9IEM7qumbX2Sa6eVbmbWaBgtuWcPPMmvKue3T6yF9OKf/Qi6qfctC04
         4rg/N+gYp7fiXkYV9vS1GugPeD0dXoPUk/KdDXDt8gWcCh1/InCyB51IbDBlDbhNO514
         mM4m8/WO7YcPA+TSkKqCvqMStE0grRAx197y4XkVDXXVIen1b7ycVRW8elIvftlPnuMu
         H1gRdpvUrLIweHDD5n2t1GGsffC4TsUykzYWUSv+QYwh+UrqW4dGgzNIbH169JE05ukH
         zzSQ==
X-Gm-Message-State: AJIora8wVvGiRVRruWoGaloh/c2XjKiW9OEVA9JnqrtmBT1g4Itbp4Bb
        +y4Y7McUxbU3/NqaJyG9H6ZAgEDByN7zA87YWaA=
X-Google-Smtp-Source: AGRyM1ugnZr1HPSuDuSfEwPx0q0JfyLubjSeJ6L1y3vByg/wZOiYpfPBR6lXjLvtl8iPLN4ox/NwoQ==
X-Received: by 2002:a17:902:e887:b0:16a:5446:6dae with SMTP id w7-20020a170902e88700b0016a54466daemr9723276plg.75.1656517741625;
        Wed, 29 Jun 2022 08:49:01 -0700 (PDT)
Received: from vultr.guest ([45.32.72.20])
        by smtp.gmail.com with ESMTPSA id 1-20020a620501000000b00527d84dfa42sm2661329pff.167.2022.06.29.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:49:00 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, quentin@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 3/4] bpf: Don't do preempt check when migrate is disabled
Date:   Wed, 29 Jun 2022 15:48:31 +0000
Message-Id: <20220629154832.56986-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220629154832.56986-1-laoar.shao@gmail.com>
References: <20220629154832.56986-1-laoar.shao@gmail.com>
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

It doesn't need to do the preempt check when migrate is disabled
after commit
74d862b682f5 ("sched: Make migrate_disable/enable() independent of RT").

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/bpf_task_storage.c | 8 ++++----
 kernel/bpf/hashtab.c          | 6 +++---
 kernel/bpf/trampoline.c       | 4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index e9014dc62682..6f290623347e 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -26,20 +26,20 @@ static DEFINE_PER_CPU(int, bpf_task_storage_busy);
 static void bpf_task_storage_lock(void)
 {
 	migrate_disable();
-	__this_cpu_inc(bpf_task_storage_busy);
+	this_cpu_inc(bpf_task_storage_busy);
 }
 
 static void bpf_task_storage_unlock(void)
 {
-	__this_cpu_dec(bpf_task_storage_busy);
+	this_cpu_dec(bpf_task_storage_busy);
 	migrate_enable();
 }
 
 static bool bpf_task_storage_trylock(void)
 {
 	migrate_disable();
-	if (unlikely(__this_cpu_inc_return(bpf_task_storage_busy) != 1)) {
-		__this_cpu_dec(bpf_task_storage_busy);
+	if (unlikely(this_cpu_inc_return(bpf_task_storage_busy) != 1)) {
+		this_cpu_dec(bpf_task_storage_busy);
 		migrate_enable();
 		return false;
 	}
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 9d4559a1c032..6a3a95037aac 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -166,8 +166,8 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
 	hash = hash & HASHTAB_MAP_LOCK_MASK;
 
 	migrate_disable();
-	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
-		__this_cpu_dec(*(htab->map_locked[hash]));
+	if (unlikely(this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
+		this_cpu_dec(*(htab->map_locked[hash]));
 		migrate_enable();
 		return -EBUSY;
 	}
@@ -190,7 +190,7 @@ static inline void htab_unlock_bucket(const struct bpf_htab *htab,
 		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
 	else
 		spin_unlock_irqrestore(&b->lock, flags);
-	__this_cpu_dec(*(htab->map_locked[hash]));
+	this_cpu_dec(*(htab->map_locked[hash]));
 	migrate_enable();
 }
 
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 93c7675f0c9e..f4486e54fdb3 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -585,7 +585,7 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog, struct bpf_tramp_run_ctx *ru
 
 	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
 
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
@@ -631,7 +631,7 @@ u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_r
 	migrate_disable();
 	might_fault();
 
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
-- 
2.17.1

