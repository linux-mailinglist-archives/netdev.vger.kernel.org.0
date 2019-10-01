Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88822C3AF9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfJAQkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbfJAQko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E7421D79;
        Tue,  1 Oct 2019 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948043;
        bh=8rXf1rcCw3zLras7kS4IMtEFY7Dv0pAdekM63Zo4p1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hw0rp2UpCOnwwt+y7MLvTR0/AixA8DMxxoqItXLEpo8mN62bPcckG4dLPgwngg5sa
         fAly+fz7licAcUa4bDyQbh5j7svzd2NDiSRVgveSwisIaGynvGm/TjlFalFjfB7jxe
         9aOf+oiI/rE7GyTrF3sYpVLYl6ejHNffhzFPlfjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.3 50/71] selftests/bpf: adjust strobemeta loop to satisfy latest clang
Date:   Tue,  1 Oct 2019 12:39:00 -0400
Message-Id: <20191001163922.14735-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 4670d68b9254710fdeaf794cad54d8b2c9929e0a ]

Some recent changes in latest Clang started causing the following
warning when unrolling strobemeta test case main loop:

  progs/strobemeta.h:416:2: warning: loop not unrolled: the optimizer was
  unable to perform the requested transformation; the transformation might
  be disabled or specified as part of an unsupported transformation
  ordering [-Wpass-failed=transform-warning]

This patch simplifies loop's exit condition to depend only on constant
max iteration number (STROBE_MAX_MAP_ENTRIES), while moving early
termination logic inside the loop body. The changes are equivalent from
program logic standpoint, but fixes the warning. It also appears to
improve generated BPF code, as it fixes previously failing non-unrolled
strobemeta test cases.

Cc: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/strobemeta.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 8a399bdfd9203..067eb625d01c5 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -413,7 +413,10 @@ static __always_inline void *read_map_var(struct strobemeta_cfg *cfg,
 #else
 #pragma unroll
 #endif
-	for (int i = 0; i < STROBE_MAX_MAP_ENTRIES && i < map.cnt; ++i) {
+	for (int i = 0; i < STROBE_MAX_MAP_ENTRIES; ++i) {
+		if (i >= map.cnt)
+			break;
+
 		descr->key_lens[i] = 0;
 		len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
 					 map.entries[i].key);
-- 
2.20.1

