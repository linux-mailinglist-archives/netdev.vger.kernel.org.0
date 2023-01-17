Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CD466D5D7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjAQGDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbjAQGDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:03:11 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B119692;
        Mon, 16 Jan 2023 22:03:07 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id i5so6887016oih.11;
        Mon, 16 Jan 2023 22:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihb6f3DcG5Hd+/8ftrTykA88KTsy1zkvL9YpVq6JHBw=;
        b=UKCgEoBAzR0/8VkVtzEDvJI7sUSDyMg6H/Nvu8iK/TAmco7fSi+LGMrMhz/42USvhD
         QeatO+xkqa3zQb+3xK00zEaKfjSoOERtlcdXcga/it3fnUdIiu8mNehKPLvd7OeXjCqh
         QikaFKgBLEq3TQZJ423yHA3PnFCk/xBjz1WeHT+Lnsnr8o1DRy2oJCqsXC0+ME0K3J/r
         Ngbx87FZeENYYm0TvlE6BXjb+1NOyaAIjg4N/GxSBjY3ZG6uNIK74X7BVAj4bvPbt0fj
         yKRzuhKgxRbkuwUi24nxXxuPABSpAAt1Gh/UHSGJBQwP7BPNfA42QQZIHrgf5pXp+85g
         cKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihb6f3DcG5Hd+/8ftrTykA88KTsy1zkvL9YpVq6JHBw=;
        b=rxvi5ZMU5JfBoex/WwJCXJP0rQ5voGaMEtKWwYRWOqHeMRbI7HbAUAw3xTrRg3yas7
         XqC0jIdGvGEdoBenoEezFO1i5kuxIu30avkA8FKkyYs09+9giHpnJ+dq81XQctifQ1tK
         yqzt/ytV0LLK5/NXV82u8B+V9cUN0dPSLEHgkiebYEzfpI4EXt88wlImFu4+lRUwWRb5
         BWlMRwzWUHanxOFgZURkZpHh+b0Hu7cg6b8NK6gpD95iubZ8n3x6DoFFl370tKxuhzAM
         +SKKtNzok+1UTzLfDYeY/KlxrmcEnk0c4Vj+YPoc23UDbqWTOfJOnAgsrdMJLNKUKHFl
         7pFA==
X-Gm-Message-State: AFqh2koZPQg7U7+ucPOV4I09XIc3lRiAmhl7Zzhr+T8B0srGi/7o+jPk
        9aH59TwAUQuP/bxk+KH5yQ5LvDOx4QI=
X-Google-Smtp-Source: AMrXdXtxZaJYuQ6qA024F6G359BvGdgchGsMi61Y96Af/qmrzaXVrkFzZDtE+L28iyDs6QHiwO0RrA==
X-Received: by 2002:a05:6808:1708:b0:364:7cb7:56ef with SMTP id bc8-20020a056808170800b003647cb756efmr1048598oib.55.1673935387010;
        Mon, 16 Jan 2023 22:03:07 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2f2a:7825:8a78:b891])
        by smtp.gmail.com with ESMTPSA id g21-20020a0568080dd500b00360f68d509csm14060974oic.49.2023.01.16.22.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 22:03:06 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next 2/2] bpf: remove a redundant parameter of bpf_prog_free_id()
Date:   Mon, 16 Jan 2023 22:02:49 -0800
Message-Id: <20230117060249.912679-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117060249.912679-1-xiyou.wangcong@gmail.com>
References: <20230117060249.912679-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

The second parameter of bpf_prog_free_id() is always true,
hence can be just eliminated.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h  |  2 +-
 kernel/bpf/offload.c |  2 +-
 kernel/bpf/syscall.c | 23 +++++------------------
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3558c192871c..2c0d2383cea0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1832,7 +1832,7 @@ void bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
 
-void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
+void bpf_prog_free_id(struct bpf_prog *prog);
 void bpf_map_free_id(struct bpf_map *map);
 
 struct btf_field *btf_record_find(const struct btf_record *rec,
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index ae6d5a5c0798..658032e294ed 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -217,7 +217,7 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
 		offload->offdev->ops->destroy(prog);
 
 	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
-	bpf_prog_free_id(prog, true);
+	bpf_prog_free_id(prog);
 
 	list_del_init(&offload->offloads);
 	kfree(offload);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1eaa1a18aef7..b56f65328d9c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1988,7 +1988,7 @@ static int bpf_prog_alloc_id(struct bpf_prog *prog)
 	return id > 0 ? 0 : id;
 }
 
-void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
+void bpf_prog_free_id(struct bpf_prog *prog)
 {
 	unsigned long flags;
 
@@ -2000,18 +2000,10 @@ void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
 	if (!prog->aux->id)
 		return;
 
-	if (do_idr_lock)
-		spin_lock_irqsave(&prog_idr_lock, flags);
-	else
-		__acquire(&prog_idr_lock);
-
+	spin_lock_irqsave(&prog_idr_lock, flags);
 	idr_remove(&prog_idr, prog->aux->id);
 	prog->aux->id = 0;
-
-	if (do_idr_lock)
-		spin_unlock_irqrestore(&prog_idr_lock, flags);
-	else
-		__release(&prog_idr_lock);
+	spin_unlock_irqrestore(&prog_idr_lock, flags);
 }
 
 static void __bpf_prog_put_rcu(struct rcu_head *rcu)
@@ -2057,13 +2049,13 @@ static void bpf_prog_put_deferred(struct work_struct *work)
 	__bpf_prog_put_noref(prog, true);
 }
 
-static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
+void bpf_prog_put(struct bpf_prog *prog)
 {
 	struct bpf_prog_aux *aux = prog->aux;
 
 	if (atomic64_dec_and_test(&aux->refcnt)) {
 		/* bpf_prog_free_id() must be called first */
-		bpf_prog_free_id(prog, do_idr_lock);
+		bpf_prog_free_id(prog);
 
 		if (in_irq() || irqs_disabled()) {
 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
@@ -2073,11 +2065,6 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 		}
 	}
 }
-
-void bpf_prog_put(struct bpf_prog *prog)
-{
-	__bpf_prog_put(prog, true);
-}
 EXPORT_SYMBOL_GPL(bpf_prog_put);
 
 static int bpf_prog_release(struct inode *inode, struct file *filp)
-- 
2.34.1

