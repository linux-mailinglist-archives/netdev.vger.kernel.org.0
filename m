Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EAC2D10AC
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgLGMiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgLGMiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:38:18 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10FAC0613D0;
        Mon,  7 Dec 2020 04:37:31 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so19159856ejb.13;
        Mon, 07 Dec 2020 04:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aUwTnuqZnXrzXUdRMDyUoF+/uTT+YAcAeAhD7mlLVbQ=;
        b=Q8uUqcRvNNq6yYwv5RqGt+ClFR3tpVNNPyQNW4ZnhPAOiHmdPfjMHKxd15EphDGh6o
         gM92fXdFpmMP1M6tndBnP2C4MrGgN+ll6SRYJmQkuZuCsN+fFvyKPgWAy67DfKEewewx
         Mwo5LbrAL/NSih9hTd1LG0LHNnkd3znXkew80+lXY8BXFAhrIZ3ZN0H6W0uE870kIOv2
         rd88rX6SRj7Htzw2zyIbITKjtEYACAICish9SInrsVxET3DYoGWlBdanro5DUwIrn/90
         VzT8tjPsb+ul0JJ6JiFRgY8ctKxOe9ROi+JtxWjzD4bpnILEN2ovhn2WuxseM1UuAYsw
         H31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aUwTnuqZnXrzXUdRMDyUoF+/uTT+YAcAeAhD7mlLVbQ=;
        b=Uu1i5Lkp3bdl1IDhE9zGTt1/+z3a9BYrvzXXbjBkipk+3xhdzmKU6BIcHnc0+IP6Na
         yIqNvojU5bF53B70yUZAQVigsY4YmyqlxFrg03TujNTxJHbvQBIxey+tUsZFPmEjhJvg
         Ty2C0dntmJGDiEJLq1guBtLQMEQQwEEAjB8NM6dlJxPXI+gH68YctZf3fuWVmJA66x8j
         c/0DCWU6mioJLRcnmcH4DJWFSwKgHA+yRoBkjfnWU2/y4cyjauY1BRldLfKLO7mogkqY
         s/2WmB7lwjjwUtQr/XdU1Mtnj000BsDj9tAENUrE+qcrp+OnkPjqJv6IKxOEQmfjrEf4
         cMDQ==
X-Gm-Message-State: AOAM532zU/z3gRJt//XnM9udbU2BG/BnAOchdH4BGAp1a2akjcN+cILx
        PMAn/LbShZ5xW+arWArcaQk=
X-Google-Smtp-Source: ABdhPJzSM/eEU1fO8yP9OhDoxsK91+z17v3cKu2RB7tpgf6FWeYRxqKkYeaQoCrQSzhN31xWp0Mnog==
X-Received: by 2002:a17:906:2581:: with SMTP id m1mr18311458ejb.28.1607344650673;
        Mon, 07 Dec 2020 04:37:30 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d4a:c600:c0f8:50a9:4ab0:a9ab])
        by smtp.gmail.com with ESMTPSA id u15sm13848265edt.24.2020.12.07.04.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 04:37:30 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        kernel-janitors@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] bpf: propagate __user annotations properly
Date:   Mon,  7 Dec 2020 13:37:20 +0100
Message-Id: <20201207123720.19111-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__htab_map_lookup_and_delete_batch() stores a user pointer in the local
variable ubatch and uses that in copy_{from,to}_user(), but ubatch misses a
__user annotation.

So, sparse warns in the various assignments and uses of ubatch:

  kernel/bpf/hashtab.c:1415:24: warning: incorrect type in initializer
    (different address spaces)
  kernel/bpf/hashtab.c:1415:24:    expected void *ubatch
  kernel/bpf/hashtab.c:1415:24:    got void [noderef] __user *

  kernel/bpf/hashtab.c:1444:46: warning: incorrect type in argument 2
    (different address spaces)
  kernel/bpf/hashtab.c:1444:46:    expected void const [noderef] __user *from
  kernel/bpf/hashtab.c:1444:46:    got void *ubatch

  kernel/bpf/hashtab.c:1608:16: warning: incorrect type in assignment
    (different address spaces)
  kernel/bpf/hashtab.c:1608:16:    expected void *ubatch
  kernel/bpf/hashtab.c:1608:16:    got void [noderef] __user *

  kernel/bpf/hashtab.c:1609:26: warning: incorrect type in argument 1
    (different address spaces)
  kernel/bpf/hashtab.c:1609:26:    expected void [noderef] __user *to
  kernel/bpf/hashtab.c:1609:26:    got void *ubatch

Add the __user annotation to repair this chain of propagating __user
annotations in __htab_map_lookup_and_delete_batch().

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on current master (v5.10-rc7) and next-20201204

BPF maintainers, please pick this minor non-urgent clean-up patch.

 kernel/bpf/hashtab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index fe7a0733a63a..76c791def033 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1412,7 +1412,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	void *keys = NULL, *values = NULL, *value, *dst_key, *dst_val;
 	void __user *uvalues = u64_to_user_ptr(attr->batch.values);
 	void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
-	void *ubatch = u64_to_user_ptr(attr->batch.in_batch);
+	void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
 	u32 batch, max_count, size, bucket_size;
 	struct htab_elem *node_to_free = NULL;
 	u64 elem_map_flags, map_flags;
-- 
2.17.1

