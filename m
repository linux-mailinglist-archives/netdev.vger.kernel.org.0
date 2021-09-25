Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F83E417FD8
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 07:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345140AbhIYFdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 01:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhIYFdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 01:33:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B848C061571;
        Fri, 24 Sep 2021 22:31:40 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m26so10728171pff.3;
        Fri, 24 Sep 2021 22:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zr13fx33D6cGBCWCx+EfPVnEBz7yzV66x12ZC0rnuPo=;
        b=oco4OO7JDCAMQy8O/ExD798iffrBCo84es7gNI5WdqOZQgvzkRhfEeMzc9qT3efptZ
         WlIBOva7zgUZt34B4JI8w6n3RKCGykEHZw/mpTfOiEbHTyVYVtUt0JX5zwg+Loc5H9Fe
         Remg9qvqQ81kuQWx/xB7qej2R7RV7PMzxYieUpz9+P0Rp/VAZf1XB7ipvob5Cm+KByMY
         XttpWIceYsWGFiS6lX1qB5MouWRUz878Fu+PyMqVvufML8f5LO1GMIZRZeH/MM2Bf1LJ
         O0kS7yrEVvopyNzELO+lPmWFYi503iBGqoltRwjqVHan7d7zjnWD6OxqxtFQTSwA0J+Z
         tEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zr13fx33D6cGBCWCx+EfPVnEBz7yzV66x12ZC0rnuPo=;
        b=tp9iyR/afaTYxmjGSptYzc4122p62iICOK+mOnts+3ulAgq01Fcff2Rs2gkhMQGErq
         78TmuJw715vTgB3srfAFj00OpzTzr54Wt5lLFqlr+oz2f99hPgDEx54uMt6Ka2RkHQWe
         nvtjsYldm6rihS0cORUUx3TQY2WEE2s89l7Iw7mu7cy/wBuixTUtfmBnzfwvCXZH7Y0d
         wQ2SDxWkrFh6ty98tMzc5ORN7ycvplQDqkWYGz9hDdetLbEJHbpWxE+heWOSbFGpDN49
         TwpbpREBh5OPX5W1pLNapPkHxStdlcA4KsZSZ0t1m1ClcAeIEx2WbL7zw2lBWdCbToph
         cBng==
X-Gm-Message-State: AOAM532dmcYJIYVb+qx/wwGFenNLYmYw3hkysXdwyOt+4V05f/k3pZY0
        Tdj/tLuhbWB7QN4i6/ukuQw=
X-Google-Smtp-Source: ABdhPJxQECHfMr7dYmbxc6CrMVXdPR3ODuHy1sHJU9WOWD3xIhZY2fSCyw+zq5IGeQXq4z3BPq9lUA==
X-Received: by 2002:a63:9a19:: with SMTP id o25mr6978416pge.90.1632547899681;
        Fri, 24 Sep 2021 22:31:39 -0700 (PDT)
Received: from ty-ThinkPad-X280.sugnm1.kt.home.ne.jp (61-24-168-251.rev.home.ne.jp. [61.24.168.251])
        by smtp.gmail.com with ESMTPSA id o9sm11841829pfh.217.2021.09.24.22.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 22:31:39 -0700 (PDT)
From:   Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     th.yasumatsu@gmail.com, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Fix integer overflow in prealloc_elems_and_freelist()
Date:   Sat, 25 Sep 2021 14:31:06 +0900
Message-Id: <20210925053106.1031798-1-th.yasumatsu@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In prealloc_elems_and_freelist(), the multiplication to calculate the
size passed to bpf_map_area_alloc() could lead to an integer overflow.
As a result, out-of-bounds write could occur in pcpu_freelist_populate()
as reported by KASAN:

[...]
[   16.968613] BUG: KASAN: slab-out-of-bounds in pcpu_freelist_populate+0xd9/0x100
[   16.969408] Write of size 8 at addr ffff888104fc6ea0 by task crash/78
[   16.970038]
[   16.970195] CPU: 0 PID: 78 Comm: crash Not tainted 5.15.0-rc2+ #1
[   16.970878] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   16.972026] Call Trace:
[   16.972306]  dump_stack_lvl+0x34/0x44
[   16.972687]  print_address_description.constprop.0+0x21/0x140
[   16.973297]  ? pcpu_freelist_populate+0xd9/0x100
[   16.973777]  ? pcpu_freelist_populate+0xd9/0x100
[   16.974257]  kasan_report.cold+0x7f/0x11b
[   16.974681]  ? pcpu_freelist_populate+0xd9/0x100
[   16.975190]  pcpu_freelist_populate+0xd9/0x100
[   16.975669]  stack_map_alloc+0x209/0x2a0
[   16.976106]  __sys_bpf+0xd83/0x2ce0
[...]

The possibility of this overflow was originally discussed in [0], but
was overlooked.

Fix the integer overflow by casting one operand to u64.

[0] https://lore.kernel.org/bpf/728b238e-a481-eb50-98e9-b0f430ab01e7@gmail.com/

Fixes: 557c0c6e7df8 ("bpf: convert stackmap to pre-allocation")
Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
---
 kernel/bpf/stackmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 09a3fd97d329..8941dc83a769 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -66,7 +66,7 @@ static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 	u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
 	int err;
 
-	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
+	smap->elems = bpf_map_area_alloc((u64)elem_size * smap->map.max_entries,
 					 smap->map.numa_node);
 	if (!smap->elems)
 		return -ENOMEM;
-- 
2.25.1

