Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162B83BF36A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhGHBVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhGHBVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:21:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAA0C061574;
        Wed,  7 Jul 2021 18:18:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso4875593pjc.0;
        Wed, 07 Jul 2021 18:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bGv8lt8RNeoYZwAKXokdTr6gAVZv4YRPbRC8p2kgseY=;
        b=rYCUSmOf/IelQ/rcTCFbPfWkLsRHlpb4lFh94Opbdm+YlN7Ai1d/YQvQDmZJo6JzOX
         IkQ9nEH9a0TLmOpXQwuDgxYeqYjpG6hrJnDAv9gurpoepztepeQotla7HbpWeIdOVYYd
         yJ8oZThO4Ld05YI1qCXcKdqhRUsZ1tvHpp7B3UgYWVr7yBIeUO1GELX+sfUpB7jiAbXk
         FRJ2/SddgvRUTGpPUCEErmHiUqLVcNdR3z8VRxdewoGhRNZJO9nyFQU3L8LMjd83EeUC
         I38NrN70fbT6vaSR9MEEL3pkgakWqmcAgTSOatuCfcgsSAUcO6NhuX6HDtOEg8qEVawq
         Q+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bGv8lt8RNeoYZwAKXokdTr6gAVZv4YRPbRC8p2kgseY=;
        b=YJPtAJPFHjPNnDIV5YjmZ2/5HGgYXqPX4GGTam1wfCUTsEn0C+gWyUZw1XKVRDxSE4
         rGaAe7gjaMtgB5T+q5Y236wCRRgE2U/FWhszjquoWlGKzjV3HbufRHelZS+7KOnDxE4H
         sjGpovxJwPEPKtd6cBzbyHaHdJEGn/2SfpV5gjakFS0lRdCjmO0SVeD/OfX/7iNQjw/V
         ec99GOE4pWl0DKhy9epf347Y7JLfYBiSXKTBrGKIPRlYjhwDBAwZdd6qYqZ2oyNxZ1vZ
         vQ5oy/IFL5gipyw3NoTiSQ7voRBQ/2p4Zj1N4Q94QKpL1j+hgRP4loICl3I3a5ayYZ4N
         qEIg==
X-Gm-Message-State: AOAM533D64IsOwyGjBMdWrPaGHKy168VcF5d6pXgFzS848xlsM0hkH0F
        WY6znw75iXrSUBKNpCkAqejmScmZqlk=
X-Google-Smtp-Source: ABdhPJwabfMSPTbWecpunDLS+PRr/U1kalg3dSuzDKCUxrnuiRd6yMx8VZn7ED0v7Z3mdk3TQHAxkQ==
X-Received: by 2002:a17:902:b94a:b029:10d:6f56:eeac with SMTP id h10-20020a170902b94ab029010d6f56eeacmr23879819pls.54.1625707119133;
        Wed, 07 Jul 2021 18:18:39 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id d20sm417450pfn.219.2021.07.07.18.18.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:18:38 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 01/11] bpf: Prepare bpf_prog_put() to be called from irq context.
Date:   Wed,  7 Jul 2021 18:18:23 -0700
Message-Id: <20210708011833.67028-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Currently bpf_prog_put() is called from the task context only.
With addition of bpf timers the timer related helpers will start calling
bpf_prog_put() from irq-saved region and in rare cases might drop
the refcnt to zero.
To address this case, first, convert bpf_prog_free_id() to be irq-save
(this is similar to bpf_map_free_id), and, second, defer non irq
appropriate calls into work queue.
For example:
bpf_audit_prog() is calling kmalloc and wake_up_interruptible,
bpf_prog_kallsyms_del_all()->bpf_ksym_del()->spin_unlock_bh().
They are not safe with irqs disabled.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/syscall.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e343f158e556..5d1fee634be8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1699,6 +1699,8 @@ static int bpf_prog_alloc_id(struct bpf_prog *prog)
 
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
 {
+	unsigned long flags;
+
 	/* cBPF to eBPF migrations are currently not in the idr store.
 	 * Offloaded programs are removed from the store when their device
 	 * disappears - even if someone grabs an fd to them they are unusable,
@@ -1708,7 +1710,7 @@ void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
 		return;
 
 	if (do_idr_lock)
-		spin_lock_bh(&prog_idr_lock);
+		spin_lock_irqsave(&prog_idr_lock, flags);
 	else
 		__acquire(&prog_idr_lock);
 
@@ -1716,7 +1718,7 @@ void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
 	prog->aux->id = 0;
 
 	if (do_idr_lock)
-		spin_unlock_bh(&prog_idr_lock);
+		spin_unlock_irqrestore(&prog_idr_lock, flags);
 	else
 		__release(&prog_idr_lock);
 }
@@ -1752,14 +1754,32 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 	}
 }
 
+static void bpf_prog_put_deferred(struct work_struct *work)
+{
+	struct bpf_prog_aux *aux;
+	struct bpf_prog *prog;
+
+	aux = container_of(work, struct bpf_prog_aux, work);
+	prog = aux->prog;
+	perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
+	bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
+	__bpf_prog_put_noref(prog, true);
+}
+
 static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 {
-	if (atomic64_dec_and_test(&prog->aux->refcnt)) {
-		perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
-		bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
+	struct bpf_prog_aux *aux = prog->aux;
+
+	if (atomic64_dec_and_test(&aux->refcnt)) {
 		/* bpf_prog_free_id() must be called first */
 		bpf_prog_free_id(prog, do_idr_lock);
-		__bpf_prog_put_noref(prog, true);
+
+		if (in_irq() || irqs_disabled()) {
+			INIT_WORK(&aux->work, bpf_prog_put_deferred);
+			schedule_work(&aux->work);
+		} else {
+			bpf_prog_put_deferred(&aux->work);
+		}
 	}
 }
 
-- 
2.30.2

