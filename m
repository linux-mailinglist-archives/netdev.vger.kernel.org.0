Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF73E2D20
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbhHFPFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243303AbhHFPFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:05:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D81C0613CF;
        Fri,  6 Aug 2021 08:05:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so12610532pjz.0;
        Fri, 06 Aug 2021 08:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJ3Iah5T2bgSvwhjM0PqRF2Eb+ZURNu+WMrZDh3yrtc=;
        b=Ty7y4vqOOuW6S8/mSgNw3XsjYQ0eY2yDaL6VKvYATAKZJZsprHVsLzP91Bpkf/KyLl
         ZsqUtsPRCSMW+Slsjwq9lY8xxMhdqjHTttL8uuV7XEekQ8jfBeKJEQ3Zl3sQOmSIqQAN
         2GCAw1SJi+TaZjqa7a83ikABLG1uMkA6xOu/NKGZG8ngZoNzBr3MHQGrCxEg9aN1n39q
         gayL4N9/7eAoap/PolAT16uZl0Ybk40wUUHWU7skcx42mpN0vNZowh+LvCsqK1Z0E5pt
         l52l9Rt7T5hrT7ULd+uR+SfuPeuF7MKB12uAYMPG3nUbM5AxuCuU2GI1dwkXrYt2b6es
         xrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aJ3Iah5T2bgSvwhjM0PqRF2Eb+ZURNu+WMrZDh3yrtc=;
        b=m19lFvNCvaTafdJX5WMnNB9fODoi3LGokC4fv26fuiLWCfP4XPCHvHuVHdcrHJJFLC
         QcTY4RX1/8cohdiiKsWV3uGG0pH2aDLJFPIBfggsGU+3zDazIdC9QawkfqPApQ6eWtPj
         LzNiA8cAUCoRGkTijyuy7xS4wm2el+Z1F93w+2+EdF2r003E9Uolmtb1X5ZD1zKQJ7MK
         k8bI3wAx/nr+8pZ6vqZdqJCKfbSU+YbtlZxW1ZU6wxA18OjGFWIGEFErTBuYc07dDeow
         Xq04TLFQViXqAiqpffSqpSbK3bjFTdVqo3mjy8iHRFm5dKcwu7MjiFdnAc/pdr4PhsW7
         D5mg==
X-Gm-Message-State: AOAM533k37mSZE2Bo3nblIpuTPRaPhSij8Sr706DhyBTtRlZPaZVSay+
        cucC9GAcse6jux4Sm+vjueE=
X-Google-Smtp-Source: ABdhPJwoyQ++fr3l/sIj3REs/l+n2BN54DKPIRdG6PnDA1VvLRgmybye5AwhiUUtsPkwd67G947wPw==
X-Received: by 2002:a17:90b:1018:: with SMTP id gm24mr11055370pjb.86.1628262300733;
        Fri, 06 Aug 2021 08:05:00 -0700 (PDT)
Received: from localhost.localdomain ([240b:11:82a2:3000:e2d5:fd62:ea40:4dc4])
        by smtp.gmail.com with ESMTPSA id c14sm623588pjv.11.2021.08.06.08.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 08:04:59 -0700 (PDT)
From:   Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     th.yasumatsu@gmail.com, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] bpf: Fix integer overflow involving bucket_size
Date:   Sat,  7 Aug 2021 00:04:18 +0900
Message-Id: <20210806150419.109658-1-th.yasumatsu@gmail.com>
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

Fix the integer overflow by calling kvmalloc_array() instead of
kvmalloc() to allocate memory.

Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
---
v2:
- Fix the overflow by calling kvmalloc_array(), instead of casting one
  operand to u64.

 kernel/bpf/hashtab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 72c58cc516a3..9c011f3a2687 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1565,8 +1565,8 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	/* We cannot do copy_from_user or copy_to_user inside
 	 * the rcu_read_lock. Allocate enough space here.
 	 */
-	keys = kvmalloc(key_size * bucket_size, GFP_USER | __GFP_NOWARN);
-	values = kvmalloc(value_size * bucket_size, GFP_USER | __GFP_NOWARN);
+	keys = kvmalloc_array(key_size, bucket_size, GFP_USER | __GFP_NOWARN);
+	values = kvmalloc_array(value_size, bucket_size, GFP_USER | __GFP_NOWARN);
 	if (!keys || !values) {
 		ret = -ENOMEM;
 		goto after_loop;
-- 
2.25.1

