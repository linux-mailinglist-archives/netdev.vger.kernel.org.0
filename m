Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8A33BF36D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhGHBV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhGHBVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:21:23 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C672FC061574;
        Wed,  7 Jul 2021 18:18:41 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a127so3939848pfa.10;
        Wed, 07 Jul 2021 18:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f/cAzH+JLmeLEhMLTlyF7CnPirqTReOvrEHg/ibfezQ=;
        b=eytnCZVw8xhgAWrBPYTbkJ+na0mkKRMPVtooaVK+KYaN8XfcCLJQ5vLTQmGG4JfdJC
         pCMuhNOBoW1+R9Ez6NZg2C0mdvPgzcpHSIzuGWGWxamJjLw20tPo5+Cuah7oY0WeCqPI
         DVXnJqPzOaA2N2I8qdkWD3XNogvBnyAyI9YBwZkGUcNKVvSk394siwBNdvauftlbWtUW
         HRD0YmoLAN4VQAwrBs/DGbRVd3OvyOD5zyZwCe/9RAYRdU/7qHyjSztxrvmbJH+d49gQ
         gUBVGIZRveYXsK8z4Spix4+23nuMQRVDJSQYJur45DLnzjC9gaA1+uW7SlSb6LHSMnYm
         6CVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f/cAzH+JLmeLEhMLTlyF7CnPirqTReOvrEHg/ibfezQ=;
        b=WgYqxjebGb2+8sEyiYIp8UpHZClNn0qfyRUZJ46eMP/b4M7xOaLcFZ8OdjZiPQ2Wvv
         nvdyFNGTZWcg/HpN/x0M2tkTnZdMn9qWpge+eqrfhV/GlfWWnnlmQBVyfLcRRlQOzctK
         7EP2nmcCUB5eVO27QSyT6Ia4mCUE7G6LI7w/fxbq3Fw4MX9M145VgsAhJ92GE5mCbIJY
         AdRWN02EDPoVwUws0t3Gz9oLgSh3L7lFNVmURHXqQX/TOUxhBPrzPm1WUxeMmT3WrCmf
         N4hnXtKzX3Q9uDxtN5zRjWNJHbE8xX30GocN4wDBkqA+36bbYj7gm5gl5fSbIl8KdCpX
         /ISA==
X-Gm-Message-State: AOAM5304Fp68kj2IrSIWMFNbMH6LohcfVmJCHfsVJc54wAJ4mNyLXx7W
        WbE7WYcn3Qks1hCp42b2ijM=
X-Google-Smtp-Source: ABdhPJwUtojjhz+CP2LZBTjqQRpXUPwut0WddI5yV4Q41BY7DgrBTTi7nraEdRUkG6UDZOsE2r2FEA==
X-Received: by 2002:a05:6a00:2c3:b029:317:874a:391c with SMTP id b3-20020a056a0002c3b0290317874a391cmr28098152pft.5.1625707120827;
        Wed, 07 Jul 2021 18:18:40 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id d20sm417450pfn.219.2021.07.07.18.18.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:18:40 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 02/11] bpf: Factor out bpf_spin_lock into helpers.
Date:   Wed,  7 Jul 2021 18:18:24 -0700
Message-Id: <20210708011833.67028-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Move ____bpf_spin_lock/unlock into helpers to make it more clear
that quadruple underscore bpf_spin_lock/unlock are irqsave/restore variants.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
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

