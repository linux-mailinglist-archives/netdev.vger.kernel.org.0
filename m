Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132953C7AC9
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbhGNBIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbhGNBIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29145C0613DD;
        Tue, 13 Jul 2021 18:05:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cu14so316081pjb.0;
        Tue, 13 Jul 2021 18:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N5V2h3pUYlPw7d2Up3eyEuqgg6Ycv3++rqRVjsFc5Qo=;
        b=hg3gTqNkaBGQjZUh4A/JvSH5DTUpahy+Ng8FDVew1vmljpxTnBhhslHlvreP4dDB8r
         gUC8xODkE8fkab//ahc4epIpH0LJK7dt0gYgA5hDbPem708y/CVawqnZKDhmgDjohQbW
         448ZawERQMR0YQOZgjSFJZBSCcA6tJyHFkFXTe7Y79tvbW54enCfNog15X5DykJf2g3t
         nbgS5Pe28HM8zwgP7xd0qUywJjTJJg1cTfH0AksVyjvY9y5wxRkjiYryiWH7KvKa2VAr
         XE/5LQ8vTxBszWYuD7iU74iJgOQQIKEN4/YNCDl1yGdjEb56tSornIuU35XdvloHCUfP
         GGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N5V2h3pUYlPw7d2Up3eyEuqgg6Ycv3++rqRVjsFc5Qo=;
        b=DyIbQ68rU0sWhkbOicCgLg6m1TIrgYM2sC/cSC4Hr8YUwwTpkDzOmUpBWl9lf/Kidp
         ue09Lx7/EC4YNuCNjq7UxvLFjc7Jnk0ssXWBWLzfJHLT/oYagNcYVxHKVP5veU55Z2Gd
         x85edrv7MdqNzyv4jmnnWPzXAyK4Ftj0n7JM7UhgKYW+PlxUcvrGaUD3eh2xbElodl/v
         eLKghZIEr3EYExXMa9nR0CvrYyf5E7bpjWIfbowdIqaIX/8Jy+iGyqEk6ziTotnXF8Th
         CYv7ci4M0ZkBTD4ptc69rg0/gcWHc2h72DpNjHktnzMzXY9yLXyv1dJb8ZL8dn1Ld9Ub
         CLdw==
X-Gm-Message-State: AOAM533Zg4hezKnBtAk/+EKhl5fMjLLGZfdo7h/L5kNaXx56uf7Ue7Gb
        o9l5vuDATAfxCYS/pA77jyk=
X-Google-Smtp-Source: ABdhPJwcg5GS9rB6sxciAbmEfcxXHJJNaqP8EnQfxmK4cRoJtEgZfxls0u3AnIM/xEWgW9jrGOmRyQ==
X-Received: by 2002:a17:90a:24c:: with SMTP id t12mr6971303pje.64.1626224724648;
        Tue, 13 Jul 2021 18:05:24 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:24 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 01/11] bpf: Prepare bpf_prog_put() to be called from irq context.
Date:   Tue, 13 Jul 2021 18:05:09 -0700
Message-Id: <20210714010519.37922-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
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

