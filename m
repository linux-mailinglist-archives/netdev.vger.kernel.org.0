Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9738742ED11
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhJOJGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbhJOJGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 05:06:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7A0C061753
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 02:04:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so8911847pjw.0
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 02:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Va56VXzThcapfyuRQ5Jm4rTPogdKDliZvBqOga5mRCw=;
        b=hnSlvkSy8cjPjchSs3Hpxei9lPzOzdRKnGEDp0hhdCM+8yKQM4Kt1BRIwSd26KLl2l
         EFt5IAwN/0QrDf9Ta4giZbi+cJSj/gjcY7WvJljtnfU+YA/iP4/es2U9Po4uq36kYsqt
         ZJkQW2CtqgeF7zNus5pDXLAia3sR2pzy+X97VVYBrEUz4GSuz34o7soP/h9oeIV5YShH
         J5rb+9ip9FiehgJgt/fE4mfeSqpbFLNggzPBdWu+jW0bLOZEiexIKguWCTWM3PUQXc3d
         qBvugIE6AYBQ6nGxzs2FajNbJidlKnQD4W9TkFUG+Ccbcta63FTpS54osYsbSKjCJdnD
         waxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Va56VXzThcapfyuRQ5Jm4rTPogdKDliZvBqOga5mRCw=;
        b=L9+7kGN3TwaqyychkcQ2PhctGXPmTXWKsynFUbpTdhPKAvygOU9JGMdXRNPRQL52ZT
         QP7+g7xeZ74Cn3CFY6uBIDWHTi7/ATcr6B0jdj1r3cRySv+priZ1exZjYFyTCpIxyxQN
         A5YOIV/OW/DTnKI6Ql1QJjv53hNusZqDQayMJYp4g1PeIRgQAptWPUj9Z0roWH2rGoAr
         xnnabfMbDBO+jLJ8qy1c+VYvui2VfCzwdEM9C/3PDRRTtmgmQsDjwBGDbGKEwMeZT/qF
         FlZtlSI1dBLNEsOnLWOfI4ZqD24o6/qaR4OrKFGHtSm7rz+P70gNrJRUK35wG2lvDnpz
         LnxQ==
X-Gm-Message-State: AOAM532pEscYxHoV2VYejnlBaEz9ky4t1+Eiu3RZMYJypOwGEJay+8py
        neMwek+d4F6zq2/IcMlMOfQFhg==
X-Google-Smtp-Source: ABdhPJwUUlt2PziUSmkUXhAgxMM7TpA7Blg+ObSbfCjY4jh7FhM1njWaFNuIMt+ySOT3pqCxqR6rXA==
X-Received: by 2002:a17:903:41c2:b0:13f:f26:d6b9 with SMTP id u2-20020a17090341c200b0013f0f26d6b9mr10019185ple.14.1634288667413;
        Fri, 15 Oct 2021 02:04:27 -0700 (PDT)
Received: from C02CV1DAMD6P.bytedance.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id k190sm4366009pfd.211.2021.10.15.02.04.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Oct 2021 02:04:27 -0700 (PDT)
From:   Chengming Zhou <zhouchengming@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouchengming@bytedance.com
Subject: [PATCH] bpf: use count for prealloc hashtab too
Date:   Fri, 15 Oct 2021 17:03:53 +0800
Message-Id: <20211015090353.31248-1-zhouchengming@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only use count for kmalloc hashtab not for prealloc hashtab, because
__pcpu_freelist_pop() return NULL when no more elem in pcpu freelist.

But the problem is that __pcpu_freelist_pop() will traverse all CPUs and
spin_lock for all CPUs to find there is no more elem at last.

We encountered bad case on big system with 96 CPUs that alloc_htab_elem()
would last for 1ms. This patch use count for prealloc hashtab too,
avoid traverse and spin_lock for all CPUs in this case.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 kernel/bpf/hashtab.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 32471ba02708..0c432a23aa00 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -855,12 +855,12 @@ static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
 static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 {
 	htab_put_fd_value(htab, l);
+	atomic_dec(&htab->count);
 
 	if (htab_is_prealloc(htab)) {
 		check_and_free_timer(htab, l);
 		__pcpu_freelist_push(&htab->freelist, &l->fnode);
 	} else {
-		atomic_dec(&htab->count);
 		l->htab = htab;
 		call_rcu(&l->rcu, htab_elem_free_rcu);
 	}
@@ -938,6 +938,11 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 		} else {
 			struct pcpu_freelist_node *l;
 
+			if (atomic_inc_return(&htab->count) > htab->map.max_entries) {
+				l_new = ERR_PTR(-E2BIG);
+				goto dec_count;
+			}
+
 			l = __pcpu_freelist_pop(&htab->freelist);
 			if (!l)
 				return ERR_PTR(-E2BIG);
-- 
2.11.0

