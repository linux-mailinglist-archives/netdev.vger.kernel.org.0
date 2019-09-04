Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4133A8A07
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfIDP6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731780AbfIDP6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AAE422CF5;
        Wed,  4 Sep 2019 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612689;
        bh=ZUPeU7rXEE9Ft3yii0aStiNyiPcuIWemP1F9qsfU3JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGvMmWJ/t9Gxtw8X7al5rHm4TV4DwxnaiHyVWbF0aUiTqgUc7axzKDYXJQAzKjrNQ
         S5sr0Aqq3CclxbRvVw8e+jrfPdF1DWIFFR3QYXyOYG6ZOQOzKP5L7JIrdryhHvo3Ml
         eh5cQv4TVosfUBdzG2Mus+5nwJp/lzd9lKqUzXMc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 19/94] selftests/bpf: fix "bind{4, 6} deny specific IP & port" on s390
Date:   Wed,  4 Sep 2019 11:56:24 -0400
Message-Id: <20190904155739.2816-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 27df5c7068bf23cab282dc64b1c9894429b3b8a0 ]

"bind4 allow specific IP & port" and "bind6 deny specific IP & port"
fail on s390 because of endianness issue: the 4 IP address bytes are
loaded as a word and compared with a constant, but the value of this
constant should be different on big- and little- endian machines, which
is not the case right now.

Use __bpf_constant_ntohl to generate proper value based on machine
endianness.

Fixes: 1d436885b23b ("selftests/bpf: Selftest for sys_bind post-hooks.")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index fb679ac3d4b07..0e66527334623 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -13,6 +13,7 @@
 #include <bpf/bpf.h>
 
 #include "cgroup_helpers.h"
+#include "bpf_endian.h"
 #include "bpf_rlimit.h"
 #include "bpf_util.h"
 
@@ -232,7 +233,8 @@ static struct sock_test tests[] = {
 			/* if (ip == expected && port == expected) */
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_ip6[3])),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x01000000, 4),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x00000001), 4),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_port)),
 			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x2001, 2),
@@ -261,7 +263,8 @@ static struct sock_test tests[] = {
 			/* if (ip == expected && port == expected) */
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_ip4)),
-			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x0100007F, 4),
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				    __bpf_constant_ntohl(0x7F000001), 4),
 			BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_6,
 				    offsetof(struct bpf_sock, src_port)),
 			BPF_JMP_IMM(BPF_JNE, BPF_REG_7, 0x1002, 2),
-- 
2.20.1

