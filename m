Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0FB2D1886
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 19:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgLGS3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 13:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGS3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 13:29:08 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9487C061749;
        Mon,  7 Dec 2020 10:28:27 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c79so10899069pfc.2;
        Mon, 07 Dec 2020 10:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lKkSw7WC6mmGKqF4oIexW044JZVzVeu2zMGGA8P8B88=;
        b=mBciFV04dyE8shbSgMQqaroNgZXqybS+ePs6YurUBcW8nXXmyGuqr1iJB0W+BbkfmP
         p9Sm4vKj0E644ZCfgRDt5GThBLtrlwYDR2mivfdhTgL3nhclZ0roaUnSl67B2LA1QVFC
         y5osyjJ9LXDaTI/AwWDG5pLKXSq06njfHsxph+y5PViWYwhclo0LPhpZz5f0kiVpkpol
         aJjqj5JhEq1plmCsPWOdU5lW9tWuHQJP59YHhWdwgTQIQ1bv02u3vDjQPJsTOLMy/+5p
         pvZBGI+wJ2tbtA3Q3iMBtPWryIFA24nnGMcrAOKPPrirxt+pcoYPWRb0yCVhuXNLVqZU
         6n1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lKkSw7WC6mmGKqF4oIexW044JZVzVeu2zMGGA8P8B88=;
        b=IhWJxcmj85Lq3MnuIfkrHdTm7YyY2N2PpqrA29KNnbTUg86ZHNBh5v+VyVpbwEzlJa
         e7W41RLWoOOR20GJqKxZBq/5VPsuNHOYx0dx1QB2iSu46dAHOIGMRHd0TBvDjMY1usLF
         uuzjvN5DTu+Vv+w10IbLWUIXFOATtkA/VhdxhNpXGnP3EqUNm72JWz44cy+Gn4WYjdsV
         6+sWlrFGBY9gG9HOljk344Diwtzz1CtS/uOrUSiXX2q0lJ/LzMtYc1S/4y5e9QtufUKY
         6MOgdZRdKMEGiOyHWW5UyZENiaON7wxsTE53TWMiK0fZCs+WhjWlFFnHyIbc4YHD7kSO
         Mgeg==
X-Gm-Message-State: AOAM5327Zq64Ifclh1yBWoPLvVmwS6X81PYXYKLa0wUCAdyvXpQx5hL7
        O+hZSJ8HpxJ10TnK7sdjpJnLI3mnoyw=
X-Google-Smtp-Source: ABdhPJxmxJS8kQXm6TpWZR2WG/GqrXcIS2fCnSAZ7fr59d1K5ubUr8PxWstr57YLqrOFGvQoVmn4zg==
X-Received: by 2002:a63:5315:: with SMTP id h21mr19380688pgb.43.1607365707479;
        Mon, 07 Dec 2020 10:28:27 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id iq3sm29112pjb.57.2020.12.07.10.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 10:28:26 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        Roman Gushchin <guro@fb.com>
Subject: [PATCH bpf-next] bpf: avoid overflows involving hash elem_size
Date:   Mon,  7 Dec 2020 10:28:21 -0800
Message-Id: <20201207182821.3940306-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use of bpf_map_charge_init() was making sure hash tables would not use more
than 4GB of memory.

Since the implicit check disappeared, we have to be more careful
about overflows, to support big hash tables.

syzbot triggers a panic using :

bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_LRU_HASH, key_size=16384, value_size=8,
                     max_entries=262200, map_flags=0, inner_map_fd=-1, map_name="",
                     map_ifindex=0, btf_fd=-1, btf_key_type_id=0, btf_value_type_id=0,
                     btf_vmlinux_value_type_id=0}, 64) = ...

BUG: KASAN: vmalloc-out-of-bounds in bpf_percpu_lru_populate kernel/bpf/bpf_lru_list.c:594 [inline]
BUG: KASAN: vmalloc-out-of-bounds in bpf_lru_populate+0x4ef/0x5e0 kernel/bpf/bpf_lru_list.c:611
Write of size 2 at addr ffffc90017e4a020 by task syz-executor.5/19786

CPU: 0 PID: 19786 Comm: syz-executor.5 Not tainted 5.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 bpf_percpu_lru_populate kernel/bpf/bpf_lru_list.c:594 [inline]
 bpf_lru_populate+0x4ef/0x5e0 kernel/bpf/bpf_lru_list.c:611
 prealloc_init kernel/bpf/hashtab.c:319 [inline]
 htab_map_alloc+0xf6e/0x1230 kernel/bpf/hashtab.c:507
 find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
 map_create kernel/bpf/syscall.c:829 [inline]
 __do_sys_bpf+0xa81/0x5170 kernel/bpf/syscall.c:4336
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd93fbc0c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000001a40 RCX: 000000000045deb9
RDX: 0000000000000040 RSI: 0000000020000280 RDI: 0000000000000000
RBP: 000000000119bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf2c
R13: 00007ffc08a7be8f R14: 00007fd93fbc19c0 R15: 000000000119bf2c

Fixes: 755e5d55367a ("bpf: Eliminate rlimit-based memory accounting for hashtab maps")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/hashtab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index fe7a0733a63a173e24f855e2aa7e079c0165ab06..f53cca70e215b02796d528597cef6c876f2d9533 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -224,7 +224,7 @@ static void *fd_htab_map_get_ptr(const struct bpf_map *map, struct htab_elem *l)
 
 static struct htab_elem *get_htab_elem(struct bpf_htab *htab, int i)
 {
-	return (struct htab_elem *) (htab->elems + i * htab->elem_size);
+	return (struct htab_elem *) (htab->elems + i * (u64)htab->elem_size);
 }
 
 static void htab_free_elems(struct bpf_htab *htab)
@@ -280,7 +280,7 @@ static int prealloc_init(struct bpf_htab *htab)
 	if (!htab_is_percpu(htab) && !htab_is_lru(htab))
 		num_entries += num_possible_cpus();
 
-	htab->elems = bpf_map_area_alloc(htab->elem_size * num_entries,
+	htab->elems = bpf_map_area_alloc((u64)htab->elem_size * num_entries,
 					 htab->map.numa_node);
 	if (!htab->elems)
 		return -ENOMEM;
-- 
2.29.2.576.ga3fc446d84-goog

