Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4EC1A91BE
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 06:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgDOEI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 00:08:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbgDOEIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 00:08:54 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 006F68FE7EA597A0F157;
        Wed, 15 Apr 2020 12:08:49 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Wed, 15 Apr 2020 12:08:41 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <keescook@chromium.org>, <luto@amacapital.net>, <wad@chromium.org>,
        <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] selftests/seccomp: Use bitwise instead of arithmetic operator for flags
Date:   Wed, 15 Apr 2020 12:15:01 +0800
Message-ID: <1586924101-65940-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This silences the following coccinelle warning:

"WARNING: sum of probable bitmasks, consider |"

tools/testing/selftests/seccomp/seccomp_bpf.c:3131:17-18: WARNING: sum of probable bitmasks, consider |
tools/testing/selftests/seccomp/seccomp_bpf.c:3133:18-19: WARNING: sum of probable bitmasks, consider |
tools/testing/selftests/seccomp/seccomp_bpf.c:3134:18-19: WARNING: sum of probable bitmasks, consider |
tools/testing/selftests/seccomp/seccomp_bpf.c:3135:18-19: WARNING: sum of probable bitmasks, consider |

Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 89fb3e0..1b4cdf3 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3128,11 +3128,11 @@ TEST(get_metadata)
 static int user_trap_syscall(int nr, unsigned int flags)
 {
 	struct sock_filter filter[] = {
-		BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
-		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_USER_NOTIF),
-		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, nr, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_USER_NOTIF),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};
 
 	struct sock_fprog prog = {
-- 
2.6.2

