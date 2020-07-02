Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6612211A02
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 04:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgGBCRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 22:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgGBCRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 22:17:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32790C08C5C1;
        Wed,  1 Jul 2020 19:17:03 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bj10so5434036plb.11;
        Wed, 01 Jul 2020 19:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OMztTWK7kWNfjxU0pJ3n0Ji8HvEQztJ2Im+aY1zzs1I=;
        b=UXbttS78bT0OnpTsQSEcUe6uJx1cWK94cBamyUa7Idm6fVMg3bDWRL9oDRzBxrk3gJ
         Y/Ieqm89PntuMkMrfiok0eYs0jXB1pUkPveqMiwCAz9zzsdrN1xmHkkleYBXUHhRY/8u
         JLyc/HfpwRi9qTz3l6coMdMSP3WMr5jnMiXlpoMJ0KGMziCrGw6Nt9wewyeVEhd6XlkR
         AUjF6jdnfpI/57hY8ptZk0Xus/l2TVHMNDPzyLtJQQFaqi+5hYAkPXDmqOivqDFnZ9yv
         20TBUTQr36uUIRltY1sxHNZ2PyKz4Wh+2i1PjM5ssS/muubvsCNkmU0qQ9XBiMPZIYUV
         1DEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OMztTWK7kWNfjxU0pJ3n0Ji8HvEQztJ2Im+aY1zzs1I=;
        b=RBAQm8msYlwzKRbX51wPMdxKXCItmBlS1cVVsfqY6N9LqyQMhAoLiGOt/ibI8Bh4hF
         RfBYoTW1tO5/yKeDJ582/4aRYRA+LSpwB9XwP2WQPhYNix2efq/tCu1ngJ2HpWtnNfwv
         69+AC8KRuWMBtf+ErPhtY30/66eajzipAot6NImyLfFypPqrmGXv1aBTjQntSFBX0nAo
         xJfqqy77/8tTi66O6Wmo4rPXnRYbkm+xsOkn7/T2oPWMm+QZ0HXNB0vA143dHb5ODaHt
         TyPkfgv1+mOTpN3VzBcr9QCjzzX2IFWw0x525PWdpKLDOiPnNwUnulnhkbqcNIXNDd4v
         y7Mw==
X-Gm-Message-State: AOAM533RAaJXpnroIr43j0eU7FUUw2Nn40go2crI3BOHRsJotuGkim1t
        OI9eo1kDPtIg81XSd51JmUZob01o2yLc
X-Google-Smtp-Source: ABdhPJwbRRAQ42i1lrv15kg7W1AoqHiEBEuFuDgqKMgY/YDQShZdnB9/fk61IqAAjINxdZHapCVViA==
X-Received: by 2002:a17:90a:e60b:: with SMTP id j11mr31608890pjy.189.1593656222702;
        Wed, 01 Jul 2020 19:17:02 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s1sm6428828pjp.14.2020.07.01.19.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 19:17:02 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with kprobe/sys_connect event
Date:   Thu,  2 Jul 2020 11:16:43 +0900
Message-Id: <20200702021646.90347-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702021646.90347-1-danieltimlee@gmail.com>
References: <20200702021646.90347-1-danieltimlee@gmail.com>
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
index 12e91ae64d4d..cebe2098bb24 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -154,7 +154,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
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

