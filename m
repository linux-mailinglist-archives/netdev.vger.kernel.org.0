Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146B741DB98
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351572AbhI3N6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351466AbhI3N6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:58:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A7FC06176A;
        Thu, 30 Sep 2021 06:56:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d4-20020a17090ad98400b0019ece228690so6808069pjv.5;
        Thu, 30 Sep 2021 06:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0U6U7F9Zgp+wZ7g2AX2OTa14R90ArQj48ZC1W7zXZlw=;
        b=Y6XfwN9KGIUmH1IGD2oahVk1xOjjgETnUNOvyifVabnEtpdyR71NEpRBCR9jyGmQG3
         mh7gBJuATdk3i0by/QVSedl2HZsodvQ86oAf/rk3deUdmp40G9H85rCblb1fxRGEjUgv
         lT0P1mMOsrBGavph0m/RnyyeB390ti2b52aPjH23Mq+ZlAm+O60XOi+RX0hUkcauoxw0
         gljA0TbtUtDL5BFJ90b3j+hZxdgzdQlRmyKx2r+mQClScvgmfbSYQm0R8sl/TuLRY7Xw
         cK89u0vobiWSJkmxxjNNi83vO3+NAprMggHRuruLbeRt9goUadGTMIsGSm8MQiT4obf6
         N7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0U6U7F9Zgp+wZ7g2AX2OTa14R90ArQj48ZC1W7zXZlw=;
        b=nqSQDMDtT0ohngk9hchE0SDdMSE2MzeOlEJmddECyc+Sn/aK0SSnsYotUbQ24d/trM
         8qwdYii4nsOiLZjiWCOqRoJlC18+ngYNheUJ1qmv04tDBv3ltezsv787YS5ZxjFUNKiU
         k/jr03Uw8jxrp86U75Unjs3PCHYT+bNHIHUzh92M9EGL83fOYBhK71H2mLbwW8MGlxf9
         urSfNUEo50ryw4lq1JCnfVzmbD61GQ0gyaSZEq+rpejZcb1xehOvzRymblLLwluzgT+M
         ZWLFv9wF37UjhpO6bsiOe9NLRZhClXxB6m87W2iNfvZEZ7Xm+ig1bF8JcjvlMFwf2Q2D
         D9AA==
X-Gm-Message-State: AOAM532AtuuYxIqHEVQ2qAASMA2aOhInJ+XGbwCrqQdy8/CXv/WgnqGY
        H4c1enU8/ht9pTFK1udkM30=
X-Google-Smtp-Source: ABdhPJxskhGCZQq6q0V8aUn0+OErUrNfGLFiwoWtcY4D6y230MVpZB9Z/qHBqnagkgIND/vvOTqKtA==
X-Received: by 2002:a17:902:e78f:b0:13d:f99f:34bb with SMTP id cp15-20020a170902e78f00b0013df99f34bbmr4393360plb.48.1633010183787;
        Thu, 30 Sep 2021 06:56:23 -0700 (PDT)
Received: from localhost.localdomain ([240b:11:82a2:3000:1c6:8111:fb18:a91e])
        by smtp.gmail.com with ESMTPSA id b129sm3188209pfg.157.2021.09.30.06.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:56:23 -0700 (PDT)
From:   Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     th.yasumatsu@gmail.com, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] bpf: Fix integer overflow in prealloc_elems_and_freelist()
Date:   Thu, 30 Sep 2021 22:55:45 +0900
Message-Id: <20210930135545.173698-1-th.yasumatsu@gmail.com>
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

Fix the integer overflow by changing elem_size to u64 from u32.

[0] https://lore.kernel.org/bpf/728b238e-a481-eb50-98e9-b0f430ab01e7@gmail.com/

Fixes: 557c0c6e7df8 ("bpf: convert stackmap to pre-allocation")
Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
---
- v2:
  Fix the overflow by changing elem_size to u64,
  instead of fixing it by casting one operand of the multiplication
  which is passed to bpf_map_area_alloc().

 kernel/bpf/stackmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 09a3fd97d329..6e75bbee39f0 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -63,7 +63,8 @@ static inline int stack_map_data_size(struct bpf_map *map)
 
 static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 {
-	u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
+	u64 elem_size = sizeof(struct stack_map_bucket) +
+			(u64)smap->map.value_size;
 	int err;
 
 	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
-- 
2.25.1

