Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FDB3C954D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhGOA5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhGOA5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:57:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8734C06175F;
        Wed, 14 Jul 2021 17:54:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so4986225pju.4;
        Wed, 14 Jul 2021 17:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yrnsqNBXx5G4B7kEH7sQS0AwgCfuvHTBIEke+GNH3SE=;
        b=rm+PsDA5SeS8FIyoe4gIvPxQ1lWyZQFouS8TcotSjxVsmmrrny8euBP4mp6kWGwmA1
         8B8MCOY+95hka6vRQSJfuHrvv8hMEPu62YL+0erBwXuYN+mCl1AFl5BBu9nLF62cAPpG
         zg692vYflztzjKirnrdVtNJbxE786HCOjh9X39tOsX/JnvEvGBCW/X/bHMNZ86bnMuks
         0cVRWFvmKXWAA8xiQbeSws7LYpmKWEqKg5xYSb+lwp33ECu5PBJDTfiEwb5SuRrDYAu3
         dIWWaxeXF8ytUnIv6J9Q0YixBuAX3nNYPtvBCfa/rmQmb6kVXEjfS0WeMvrWJp4eNVyH
         lQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yrnsqNBXx5G4B7kEH7sQS0AwgCfuvHTBIEke+GNH3SE=;
        b=q7dFmC8BV26x4dEzFrxXTHX+6P2jha397uz61xZu3KfiJ7vx0+9Qdx06mlWIziewW5
         83jqc/EIhTHY3npDiLnGVtIN4mJ34fcHtUrI5IIrMODPmr3xgfJYftgKo9YYX4TodvSu
         VEVOD37Lm2H4EqgUvHScvuYBtr9GFMry/CVo5C7hKJGEhHTg/CkZxlERp6Mmy5dksqgg
         lIgDs3NA619NoA9x8eqfoqyBdzqBmNx8bSG1NU2F0VVZ5Q5PY+UheoaQOIMJxK/jQy/Y
         6BPw2I9DrpjQT5JemPvqmFdf8YajWsfAp9g55A3NbV0ajhLpX0HRnm//kruJp4LPbAO6
         hYiQ==
X-Gm-Message-State: AOAM533lJirKVNUHLEb7/T3gJuGJsWw8VX810Cz+0yykSIV2/H4EFYsB
        zAVz9rucxTGOJDNn2pjWPZ2nplNAuIk=
X-Google-Smtp-Source: ABdhPJyDUlrBIARqlNc+A20p8DFYVnlg3iyv9sFG46yFsiE3/S4UATuc8nDV6Vrl+cc8XaeGrQCTHg==
X-Received: by 2002:a17:90a:b284:: with SMTP id c4mr545075pjr.213.1626310465272;
        Wed, 14 Jul 2021 17:54:25 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:120c])
        by smtp.gmail.com with ESMTPSA id nl2sm3439011pjb.10.2021.07.14.17.54.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jul 2021 17:54:24 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 bpf-next 02/11] bpf: Factor out bpf_spin_lock into helpers.
Date:   Wed, 14 Jul 2021 17:54:08 -0700
Message-Id: <20210715005417.78572-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Move ____bpf_spin_lock/unlock into helpers to make it more clear
that quadruple underscore bpf_spin_lock/unlock are irqsave/restore variants.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/helpers.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 62cf00383910..38be3cfc2f58 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -289,13 +289,18 @@ static inline void __bpf_spin_unlock(struct bpf_spin_lock *lock)
 
 static DEFINE_PER_CPU(unsigned long, irqsave_flags);
 
-notrace BPF_CALL_1(bpf_spin_lock, struct bpf_spin_lock *, lock)
+static inline void __bpf_spin_lock_irqsave(struct bpf_spin_lock *lock)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
 	__bpf_spin_lock(lock);
 	__this_cpu_write(irqsave_flags, flags);
+}
+
+notrace BPF_CALL_1(bpf_spin_lock, struct bpf_spin_lock *, lock)
+{
+	__bpf_spin_lock_irqsave(lock);
 	return 0;
 }
 
@@ -306,13 +311,18 @@ const struct bpf_func_proto bpf_spin_lock_proto = {
 	.arg1_type	= ARG_PTR_TO_SPIN_LOCK,
 };
 
-notrace BPF_CALL_1(bpf_spin_unlock, struct bpf_spin_lock *, lock)
+static inline void __bpf_spin_unlock_irqrestore(struct bpf_spin_lock *lock)
 {
 	unsigned long flags;
 
 	flags = __this_cpu_read(irqsave_flags);
 	__bpf_spin_unlock(lock);
 	local_irq_restore(flags);
+}
+
+notrace BPF_CALL_1(bpf_spin_unlock, struct bpf_spin_lock *, lock)
+{
+	__bpf_spin_unlock_irqrestore(lock);
 	return 0;
 }
 
@@ -333,9 +343,9 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 	else
 		lock = dst + map->spin_lock_off;
 	preempt_disable();
-	____bpf_spin_lock(lock);
+	__bpf_spin_lock_irqsave(lock);
 	copy_map_value(map, dst, src);
-	____bpf_spin_unlock(lock);
+	__bpf_spin_unlock_irqrestore(lock);
 	preempt_enable();
 }
 
-- 
2.30.2

