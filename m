Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0803B4FCC
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 20:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFZSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 14:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhFZSPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 14:15:49 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C383C061574;
        Sat, 26 Jun 2021 11:13:26 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id y14so11167979pgs.12;
        Sat, 26 Jun 2021 11:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TV7x7IS13z58V9cXUOKO7Vtfv5hKhMKE2dU8ZRmdcpY=;
        b=BVUp+YEKBA3bkrL4t3ui4SsWqUQ0to10QuCaXovLFBkgILegsQK8Rf7H4+HPAMZenl
         DGuwA7CcYfPKBdyNrVLt0ngEheuqnzzWp2Jon3Z+eTxW/OJ0rv/IAqVh26a+a0op5mVy
         /ADdL4FP4x6h23UA+TgEKXYZ4R+giSdQYT/zvm8GSe0yHqHdO9qsrnM3pqVdzujt70yw
         xKGnlwsVQWYiG80KZXFrR8W9B77bpOqY6/0nazZOGg8yeP09lgcU9pD7CEHTb5yHW72U
         3XNkz6w5zSlq0oTHvF6a6q+ASVmeCppcymVDtUIqKA8Nye8QWAOlXQRZfO0qbXw6RErc
         VPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TV7x7IS13z58V9cXUOKO7Vtfv5hKhMKE2dU8ZRmdcpY=;
        b=KASqoyFeaQCYqOK1+2ODdCtlni0WO6CJ7wx6+nGSZmzhaogUvpGqg4ChSqRzQ0nOKH
         X83RyTQyFEQUx7CKo/5D7msKJlyQHr6HMCvw7uQVY5tc+Z6Eh1ZxAgy5Vsv+yOaAaBAT
         qFB2B0F+lfnY8ZxqA20Iu2W1zGg4RRvnyyjrbhDiMUwA/BMgCuhCYIrjQ0GSa4O3BgcR
         nusE2eRcZjM20/N7kuDBGdSCWia1wZeb2Rpg/H2/q9Z1kPEub2yGqKoJwtOtSxsfurZU
         4GsWFyWONA3QlNsgrieiG5WEUn5D1bCFU6+dAtAPSC58PZYRNJz+slO6XT/2lslW4O6Q
         RPuQ==
X-Gm-Message-State: AOAM5334uZrNVDSay54nPkObuujN3qFVPhYK0XkSzs1yv2hNSyVm7ArI
        7+9UWIPl3QkwPSX7JPuGXFw=
X-Google-Smtp-Source: ABdhPJwK1XYlG8c0j3EYeBpApLydcISYk3DFOUyHKpcI9RLi0rypE1a34F/Jk0ClVkM5xAtFCwZ7pQ==
X-Received: by 2002:a63:f346:: with SMTP id t6mr15337732pgj.277.1624731205748;
        Sat, 26 Jun 2021 11:13:25 -0700 (PDT)
Received: from nuc10.. (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id h22sm9109705pfc.21.2021.06.26.11.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 11:13:25 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH] bpf: fix false positive kmemleak report in bpf_ringbuf_area_alloc()
Date:   Sat, 26 Jun 2021 11:11:56 -0700
Message-Id: <20210626181156.1873604-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak scans struct page, but it does not scan the page content.
if we allocate some memory with kmalloc(), then allocate page with
alloc_page(), and if we put kmalloc pointer somewhere inside that page,
kmemleak will report kmalloc pointer as a false positive.

we can instruct kmemleak to scan the memory area by calling
kmemleak_alloc()/kmemleak_free(), but part of struct bpf_ringbuf is
mmaped to user space, and if struct bpf_ringbuf changes we would have to
revisit and review size argument in kmemleak_alloc(), because we do not
want kmemleak to scan the user space memory.
let's simplify things and use kmemleak_not_leak() here.

Link: https://lore.kernel.org/lkml/YNTAqiE7CWJhOK2M@nuc10/
Link: https://lore.kernel.org/lkml/20210615101515.GC26027@arm.com/
Link: https://syzkaller.appspot.com/bug?extid=5d895828587f49e7fe9b
Reported-and-tested-by: syzbot+5d895828587f49e7fe9b@syzkaller.appspotmail.com
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
---
 kernel/bpf/ringbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 84b3b35fc0d0..9e0c10c6892a 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
+#include <linux/kmemleak.h>
 #include <uapi/linux/btf.h>
 
 #define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
@@ -105,6 +106,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
 		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
+		kmemleak_not_leak(pages);
 		rb->pages = pages;
 		rb->nr_pages = nr_pages;
 		return rb;
-- 
2.30.2

