Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FF53C9548
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhGOA5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhGOA5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:57:17 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D76C06175F;
        Wed, 14 Jul 2021 17:54:23 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m83so3591888pfd.0;
        Wed, 14 Jul 2021 17:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hkl4bdi8reCzFQCanS6SYURb5jpTCJRZnvhxfg9Iea0=;
        b=mglPbv85zeBn1S187xUNGeojCUdqz1PwDPZQ7EjtQcJHV6y/8Z9juB8ljoot1z2vEl
         j6BQrNCy8rG78xNzCZLDtFuq/zPmf/+hrWepJ/Pub8HPScFoc3gpNSeq1SYxJYLQxHL9
         +hZwhEF30x/w92t+qKbBOnFqrqlIWT8SmoSnyChJFWNzMK2Y3+Ue3JY5Bo1eIBAk1hwF
         Wm9cJ1Hwwcj5wGqetDsDNBifC/szP1yU0ncdunQxYyFI2DzXeIhHGabUqueFZrJPTxhQ
         /UjLuq5lsWQQ6oq92R47oCw+RyOXyQScU8PpKSNRYsvlnlV6rgDG4Z/pR5pKMqGOdyXD
         0EHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hkl4bdi8reCzFQCanS6SYURb5jpTCJRZnvhxfg9Iea0=;
        b=XEK4ltKb425sAkbBJlXP6KhTnLI1bn3ofPhME/DXl3cvRQliTsKvpQHpcQR+suA7eo
         QRS7DlZc83OV+4+6H9rNMPQqYlU3rQj6v15zI/gsWoVoh+ec5dG9I9A8Ad3y8U9sGE4N
         ODWKixoJV/nyNZ1yu7+7vYQdcfe3YKxAuMed0wu3h8xt3Vh7YhLuTND06Z13pelzsnZl
         QvlOcJcWMRNfnhlCTKWiuIlCq8+1H8sToKG5vIdpqD2rk8aYi8YUR0gsIXPUU9s9OSDl
         jTqamoGliwvGrcbDuBajOJBTxw+G6wSXyZptgoU1RhsAoyAfp0lryrDfTsAEyYw+Mz4o
         Dv1g==
X-Gm-Message-State: AOAM530bcGGlxhVIpuR8pIiCz+2k6T3KlLuAvpwPGeQV9zk++O0jl2nq
        h9OvCIO1u33rA4Gj/cViwVI=
X-Google-Smtp-Source: ABdhPJzHuouL6WbRQ65CidTj+SAmIzKBFrEnUj2n8g3DD7RA3pFUe0GPXggdDrEdEH49KMd2cWM6qg==
X-Received: by 2002:aa7:8d56:0:b029:327:6dc:d254 with SMTP id s22-20020aa78d560000b029032706dcd254mr907362pfe.69.1626310463433;
        Wed, 14 Jul 2021 17:54:23 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:120c])
        by smtp.gmail.com with ESMTPSA id nl2sm3439011pjb.10.2021.07.14.17.54.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jul 2021 17:54:22 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 bpf-next 01/11] bpf: Prepare bpf_prog_put() to be called from irq context.
Date:   Wed, 14 Jul 2021 17:54:07 -0700
Message-Id: <20210715005417.78572-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

