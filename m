Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA53C7ACB
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhGNBIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbhGNBIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE25C0613DD;
        Tue, 13 Jul 2021 18:05:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j3so446876plx.7;
        Tue, 13 Jul 2021 18:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MN9sOv6RAKnkWLWrR9PGQabboX8PLGTkOImuvxIP4b8=;
        b=g3V/q1TaTcwqMP+DvrHfrK06qBgQggCcdTac2JIjRnGrCCC407U5bZbqkByxOKQFjW
         OyQ74u3QdN1CxCzolKkNu6FB1ROyo3iB7AAj+Oczd9ZuCxwyRaXc8Y5nI4/FcAqgODeP
         64V0hycXt20/0GaHRQ1NhoUcIVX0DfTHV8lCP6g5Tzf9ryFUk96CG9TG1Qz0I0br52Yc
         9kWfzEjLydK4lTo6aD1NN7c7zY3GqKBLBGV4JWNqOuyfOXk+nPZgZXHB965wheX1tTfs
         Uv7yzUxdLQwzxIlBRBTx6moHw9F0A7QFNx1yggl21h650vjVTtrNx/1GvwlIyvkbJsFI
         Qxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MN9sOv6RAKnkWLWrR9PGQabboX8PLGTkOImuvxIP4b8=;
        b=IZ3I6rGftS0anr8PlmlK+6s4L7gBeh37E34zkFf3NRpFiM9dQn2TQMwXoZ2SRazhYV
         5pqH0KEstTXcLRjGmVTVGgYXCuULiNQA71+uIxSUDCBZG/Lcc7UwTe+0UjHczt3wMaxi
         GzoGkk8YM9RsKzDnAPux027gfX2+Fx0PvqvsGBaHRA09SaoghZISfkb+GcRvi5ZW1fby
         Rf4k3EQ99DOWB9WKaH0CWlBhggG2Kwd47UEP6eLPYlQH5+epozfxsCA2/0N6qU8DBz5S
         QtC+QiGiChx8azpBjHAKG3jTvw67/wiSxr9krsUad+kIYivZNiS2QUVkFt2kDaUp4yFe
         7ASA==
X-Gm-Message-State: AOAM532GuQFiO+BdDvQVjJ9HDM7lbq8oOgafxkvoUcXgx9jiKXIa0xer
        ZbUgQxo+Fnu0Kfc2IjBykag=
X-Google-Smtp-Source: ABdhPJx6lZ0OvJ3mAGVCLWK5tsXJn87FQrU9s7rsNEKVtT5Lg3LQ70a2rMNks3FrIS1ANsRtzfLRww==
X-Received: by 2002:a17:90a:a511:: with SMTP id a17mr1064011pjq.69.1626224726342;
        Tue, 13 Jul 2021 18:05:26 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:25 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 02/11] bpf: Factor out bpf_spin_lock into helpers.
Date:   Tue, 13 Jul 2021 18:05:10 -0700
Message-Id: <20210714010519.37922-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Move ____bpf_spin_lock/unlock into helpers to make it more clear
that quadruple underscore bpf_spin_lock/unlock are irqsave/restore variants.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
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

