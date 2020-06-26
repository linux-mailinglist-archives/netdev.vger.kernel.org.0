Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C4920AE54
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgFZIR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728817AbgFZIR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:17:29 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A699C08C5C1;
        Fri, 26 Jun 2020 01:17:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b7so4359800pju.0;
        Fri, 26 Jun 2020 01:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYq1Y9aWDgREts6+cri2Mc5nFwfHU78WYm8M5Y2X4r8=;
        b=PERjFh+18pZzXOyiGAcwc1opZO/k8UUn50vE05VjxBLHxisOX6vLHIPV0sorvf3bhT
         pnSoqfwcG4g2+JT+FH6qaHRuUBtTg0LxWgK/oIH18L2yw8ZCchZtWyOA/Ba93Zsx1wEt
         UsEgmJveUgCsgLWSgXfBI6bC1KsTMWbsDHEKj2YfP4QNRRjoSt8qXXt1m4sSRLUKGaXA
         cCZ4IVVwfx5YOwvf0yDQi5pgOg9N22JRntBDSO28tzc+0HD/53mqK1j6O2YGKbqrpo9X
         OE4YZMhOuSG/jMJBBRZdfL+e1R7sXrPBbSdvk3jMdxLV1cW7239x1H0lJqpi7ZOJp04l
         Yr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYq1Y9aWDgREts6+cri2Mc5nFwfHU78WYm8M5Y2X4r8=;
        b=I3ayzzeKf2IXTgNFfBT1tn08PPRSwps4bJdZR0TbW42gbO2Zy15CVpGF4t9HPxTjVN
         t2JvSDtIxzm8u6ysUR22FaD/NECXMULZT98W+VC2b0vPg/mO183ALIEFwWDbMRxKtIUT
         GYin2fnNuy1un4ZeO8hQ8c/wiNWP6oe+IwJ8wmVLZBK2sCHjKVB40PInc9G+rCjzcx76
         drvxGW3Q+k/QrGyRmgzKhhL62Q92R+02XDnRQozOYZum5VQHg6MQxAZ4DNCj9UxSrqZV
         rwJNxlwBbT0qsjp71CwQ4vVGgLSkDPGExm4JPjStfN2wV41KkfuTudUEaE6LL0Bx1vZ4
         R73w==
X-Gm-Message-State: AOAM530XGI1v+OIK3QjC9FqugJXrnmdUhbDYo4KeWeowtgd9aFR9fN5u
        o9rWpjGpuIDLOuAB9AFZtA==
X-Google-Smtp-Source: ABdhPJxPIUFRYkQiZm5a710GjcMu1oA3vgO3yY4D5PCwIRT6NoheQ6MUKzL+8+VKYtYj2Y8L8Xekag==
X-Received: by 2002:a17:90a:fe93:: with SMTP id co19mr2171910pjb.83.1593159448989;
        Fri, 26 Jun 2020 01:17:28 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s22sm16514023pgv.43.2020.06.26.01.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 01:17:28 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/3] samples: bpf: fix bpf programs with kprobe/sys_connect event
Date:   Fri, 26 Jun 2020 17:17:18 +0900
Message-Id: <20200626081720.5546-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, BPF programs with kprobe/sys_connect does not work properly.

Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
This commit modifies the bpf_load behavior of kprobe events in the x64
architecture. If the current kprobe event target starts with "sys_*",
add the prefix "__x64_" to the front of the event.

Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
solution to most of the problems caused by the commit below.

    commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
    pt_regs-based sys_*() to __x64_sys_*()")

However, there is a problem with the sys_connect kprobe event that does
not work properly. For __sys_connect event, parameters can be fetched
normally, but for __x64_sys_connect, parameters cannot be fetched.

Because of this problem, this commit fixes the sys_connect event by
specifying the __sys_connect directly and this will bypass the
"__x64_" appending rule of bpf_load.

Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/map_perf_test_kern.c         | 2 +-
 samples/bpf/test_map_in_map_kern.c       | 2 +-
 samples/bpf/test_probe_write_user_kern.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 1bb1fdb9cdf8..69ecd717d998 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -159,7 +159,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/sys_connect")
+SEC("kprobe/__sys_connect")
 int stress_lru_hmap_alloc(struct pt_regs *ctx)
 {
 	char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 6cee61e8ce9b..b1562ba2f025 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -102,7 +102,7 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
 	return result ? *result : -ENOENT;
 }
 
-SEC("kprobe/sys_connect")
+SEC("kprobe/__sys_connect")
 int trace_sys_connect(struct pt_regs *ctx)
 {
 	struct sockaddr_in6 *in6;
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index 6579639a83b2..9b3c3918c37d 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -26,7 +26,7 @@ struct {
  * This example sits on a syscall, and the syscall ABI is relatively stable
  * of course, across platforms, and over time, the ABI may change.
  */
-SEC("kprobe/sys_connect")
+SEC("kprobe/__sys_connect")
 int bpf_prog1(struct pt_regs *ctx)
 {
 	struct sockaddr_in new_addr, orig_addr = {};
-- 
2.25.1

