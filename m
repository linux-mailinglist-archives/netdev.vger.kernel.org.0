Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72150440FB5
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 18:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJaRQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 13:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhJaRQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 13:16:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672B5C061570;
        Sun, 31 Oct 2021 10:13:58 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t7so15066028pgl.9;
        Sun, 31 Oct 2021 10:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Anqb1HFE6tyy8XhRpxJJ0FE7FabhrGsV+UlluUO+y0=;
        b=cQlWQy9/eL7uTjJT3hcuoVwneL2/OLI7t4sQ9vCwPWt8/Eq/CqgTWmOvUcfv/1i6fA
         D5qklqdK0V6W0XLekIzYTWuDvQ7Hw/8KKdG4kA9Ax5TFnKpe7rS+Gk+cZeQWN828Z9V4
         bkWcqs3DytUGYbfrc7qgSQUbkE6olGmMCA14lA713q7db95x45Q8PlinJYLf/vL/NjhN
         h4zjUsLaiMmlH+PoJYMQ6l+qDPOW1W4ik8penhmfO2oVkBqkM0AXDYXfhxZgvkqECb3a
         t6sRPeb/saTlH1p5loDW/O/YkJqeSp1nDtzuxEYniBuW9jBtyEMlatN/iDLCULjeeph4
         tn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Anqb1HFE6tyy8XhRpxJJ0FE7FabhrGsV+UlluUO+y0=;
        b=Mcwu56Mi2aZIrBJD9kbrHOpRlfaGQ0fNZHBXvC83zGbQbfkRLkb/+HfyPXBLZO3CM7
         3DyzYpnaIregTVqI0QHUCTI5LLP5ZOKLKe2Ts96ZTA8gxYSpL7E5D3D27QJR+FpuwGmu
         daLb4JvUG5FG3mo9uC25we2bFTWc6r26xYe/S0thJpHnCSB7SIjaZ8I7w9fQyToB/BCU
         poRK+GJ+GwbTJVK2aW97gyKriVfIfAUicpSUok4r+v5gc58E5WdjQWZ8ImsqDn7Pirzh
         2gNNk8Vgl8epP6xXhib9xgl9o+VjJBw5Ndwa0u8FVu01GgXjlhWLxBkxMfmaNbhpGYHt
         iFRA==
X-Gm-Message-State: AOAM532ZwxMqDEAaSPuuJZp0h46lBsiZBbONB4jMhUofB0lwDvyJSE2i
        k8WlSYoWkIg/x6oXgeAY9Xk=
X-Google-Smtp-Source: ABdhPJztizmoc9dBdmy5Dlk6fA3ErbCI8c7pIPZ66iucxT22RmnIdMNjaLDf7gnUrX5SSkcQsy7ehQ==
X-Received: by 2002:a05:6a00:1484:b0:47b:f6a3:868f with SMTP id v4-20020a056a00148400b0047bf6a3868fmr23725203pfu.66.1635700437640;
        Sun, 31 Oct 2021 10:13:57 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2233:f5ab:4727:14bc])
        by smtp.gmail.com with ESMTPSA id t4sm12963574pfj.166.2021.10.31.10.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 10:13:57 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, Joanne Koong <joannekoong@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH bpf-next] bpf: add missing map_delete_elem method to bloom filter map
Date:   Sun, 31 Oct 2021 10:13:53 -0700
Message-Id: <20211031171353.4092388-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Without it, kernel crashes in map_delete_elem(), as reported
by syzbot.

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 72c97067 P4D 72c97067 PUD 1e20c067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 6518 Comm: syz-executor196 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc90002bafcb8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff92000575f9f RCX: 0000000000000000
RDX: 1ffffffff1327aba RSI: 0000000000000000 RDI: ffff888025a30c00
RBP: ffffc90002baff08 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff818525d8 R11: 0000000000000000 R12: ffffffff8993d560
R13: ffff888025a30c00 R14: ffff888024bc0000 R15: 0000000000000000
FS:  0000555557491300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000070189000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 map_delete_elem kernel/bpf/syscall.c:1220 [inline]
 __sys_bpf+0x34f1/0x5ee0 kernel/bpf/syscall.c:4606
 __do_sys_bpf kernel/bpf/syscall.c:4719 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4717 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4717
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Joanne Koong <joannekoong@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 kernel/bpf/bloom_filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index 7c50232b7571f3f038dd45b5c0bd7289125e6d43..31a7af15a83d74af1d88d04cc8d71aa7d403b4ef 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -77,6 +77,11 @@ static int pop_elem(struct bpf_map *map, void *value)
 	return -EOPNOTSUPP;
 }
 
+static int delete_elem(struct bpf_map *map, void *value)
+{
+	return -EOPNOTSUPP;
+}
+
 static struct bpf_map *map_alloc(union bpf_attr *attr)
 {
 	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
@@ -189,6 +194,7 @@ const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_pop_elem = pop_elem,
 	.map_lookup_elem = lookup_elem,
 	.map_update_elem = update_elem,
+	.map_delete_elem = delete_elem,
 	.map_check_btf = check_btf,
 	.map_btf_name = "bpf_bloom_filter",
 	.map_btf_id = &bpf_bloom_btf_id,
-- 
2.33.1.1089.g2158813163f-goog

