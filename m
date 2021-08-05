Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628923E166D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbhHEOIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239887AbhHEOIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:08:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EDAC061765;
        Thu,  5 Aug 2021 07:07:45 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so15072025pjr.1;
        Thu, 05 Aug 2021 07:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OibPOHM4csfd5W9jXrElMvcVRfnZS6gDVVfoFCeSUOI=;
        b=BVuGKKHnUlwvm+fNGyv2t1uabrBpZuVRIaJvS/V7uR4Hsfspd77wayaNwI3LvSJ6qk
         mYMltcw12BRXxY8FPF9M9JR2p+H7A5x7iaD8c+2Lkdlt3SYIaQICLEgJybUxtoaI8Q5W
         nCAen9+yaNXxdLna9VdqvtGm9L4hsKgRkMrphhPDkBDVJlNEMQKjLh9tHqljySEwlatU
         8QcbMaVHlIF6on0byMk08kt5VDYBRiFzgIsUbZLiOWlLYajfqFv8lHsKQ3xYxqoC0hdH
         T8+riozdQgYYzDyy6zPATqR0DcZa1MovepWN06sbCUdye2gW5ef3m3aF9wNf6XfxbfVj
         RUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OibPOHM4csfd5W9jXrElMvcVRfnZS6gDVVfoFCeSUOI=;
        b=EtXgCi7Mgn2PKnx9VvrW63/s/JRzBY/Ok7Jo/8PqkdLmq4C1KY+iDLl2bpBVLBMpfK
         JmnPz+Y2J2bCZ2DPJlJ4CS8GAQedgvDbeuOcYFSg/E2cCT+Lx9pEC6hRsratjxetRRjN
         85AfvWiFcd2XARRlADKxThTEDrf6CPywUxUtGTFDgln+5aU0/lI1Hyfn5yEdtPatqx0P
         id3U0O0PkmYBQcs+ZzrGR8sDflJ0f/baa0GCtgavHq0Y4ZlUPEcp4VMA5X3hW2QgGDBL
         qKSt/FazUrdoUZSKsI4BNXiireb78FfiTwcZn0fz4ifvCzy2uZQJ4Xj3Ax9DBNcPKp1X
         /0fw==
X-Gm-Message-State: AOAM533kCl9e31CuCuT2uDnsMKfBhSYw5E9eAYcquZlRRaLhYrsz8zv+
        8rXZxSdNxGxy4f2qG5M5zzs=
X-Google-Smtp-Source: ABdhPJwullE2U2YB4rB8fXaVU00zqEu67SeTVjhu1pKKItUzNZFPjttiUIylxx/1wTB+JW7yVq2CKg==
X-Received: by 2002:a63:e14c:: with SMTP id h12mr510070pgk.431.1628172465075;
        Thu, 05 Aug 2021 07:07:45 -0700 (PDT)
Received: from localhost.localdomain ([240b:11:82a2:3000:45ab:3f64:7350:39b4])
        by smtp.gmail.com with ESMTPSA id y12sm8682892pgk.7.2021.08.05.07.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 07:07:44 -0700 (PDT)
From:   Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     th.yasumatsu@gmail.com, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Fix integer overflow involving bucket_size
Date:   Thu,  5 Aug 2021 23:05:15 +0900
Message-Id: <20210805140515.35630-1-th.yasumatsu@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __htab_map_lookup_and_delete_batch(), hash buckets are iterated over
to count the number of elements in each bucket (bucket_size).
If bucket_size is large enough, the multiplication to calculate
kvmalloc() size could overflow, resulting in out-of-bounds write
as reported by KASAN.

[...]
[  104.986052] BUG: KASAN: vmalloc-out-of-bounds in __htab_map_lookup_and_delete_batch+0x5ce/0xb60
[  104.986489] Write of size 4194224 at addr ffffc9010503be70 by task crash/112
[  104.986889]
[  104.987193] CPU: 0 PID: 112 Comm: crash Not tainted 5.14.0-rc4 #13
[  104.987552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  104.988104] Call Trace:
[  104.988410]  dump_stack_lvl+0x34/0x44
[  104.988706]  print_address_description.constprop.0+0x21/0x140
[  104.988991]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
[  104.989327]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
[  104.989622]  kasan_report.cold+0x7f/0x11b
[  104.989881]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
[  104.990239]  kasan_check_range+0x17c/0x1e0
[  104.990467]  memcpy+0x39/0x60
[  104.990670]  __htab_map_lookup_and_delete_batch+0x5ce/0xb60
[  104.990982]  ? __wake_up_common+0x4d/0x230
[  104.991256]  ? htab_of_map_free+0x130/0x130
[  104.991541]  bpf_map_do_batch+0x1fb/0x220
[...]

In hashtable, if the elements' keys have the same jhash() value, the
elements will be put into the same bucket. By putting a lot of elements
into a single bucket, the value of bucket_size can be increased to
trigger the integer overflow.

Triggering the overflow is possible for both callers with CAP_SYS_ADMIN
and callers without CAP_SYS_ADMIN.

It will be trivial for a caller with CAP_SYS_ADMIN to intentionally
reach this overflow by enabling BPF_F_ZERO_SEED. As this flag will set
the random seed passed to jhash() to 0, it will be easy for the caller
to prepare keys which will be hashed into the same value, and thus put
all the elements into the same bucket.

If the caller does not have CAP_SYS_ADMIN, BPF_F_ZERO_SEED cannot be
used. However, it will be still technically possible to trigger the
overflow, by guessing the random seed value passed to jhash() (32bit)
and repeating the attempt to trigger the overflow. In this case,
the probability to trigger the overflow will be low and will take
a very long time.

Fix the integer overflow by casting 1 operand to u64.

Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
---
 kernel/bpf/hashtab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 72c58cc516a3..e29283c3b17f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1565,8 +1565,8 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	/* We cannot do copy_from_user or copy_to_user inside
 	 * the rcu_read_lock. Allocate enough space here.
 	 */
-	keys = kvmalloc(key_size * bucket_size, GFP_USER | __GFP_NOWARN);
-	values = kvmalloc(value_size * bucket_size, GFP_USER | __GFP_NOWARN);
+	keys = kvmalloc((u64)key_size * bucket_size, GFP_USER | __GFP_NOWARN);
+	values = kvmalloc((u64)value_size * bucket_size, GFP_USER | __GFP_NOWARN);
 	if (!keys || !values) {
 		ret = -ENOMEM;
 		goto after_loop;
-- 
2.25.1

