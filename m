Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B6A8A23
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbfIDP6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731950AbfIDP6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48688238AB;
        Wed,  4 Sep 2019 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612704;
        bh=VCqD+zpgTPlJpeIXx3HdQ9BeStIBLvtyglC5qFeJWV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvp1ufRBZ3TijrYp+Uju1vMfby7xpgHC2RE4WeXggClBGFjnhI0jra45UatNH0UKf
         HS8jhCt+4jM8zZ+fM/lBOb+O7cx92ZV15E3zkrYW66OhrYZ29GqlN4OvBgJlayyulu
         xQZwBm/nQ1L9Bdk9S+7YgXf9+w4Be/SSOsMHITGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 31/94] selftests/bpf: fix test_cgroup_storage on s390
Date:   Wed,  4 Sep 2019 11:56:36 -0400
Message-Id: <20190904155739.2816-31-sashal@kernel.org>
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

[ Upstream commit 806ce6e2117a42528e7bb979e04e28229b34a612 ]

test_cgroup_storage fails on s390 with an assertion failure: packets are
dropped when they shouldn't. The problem is that BPF_DW packet count is
accessed as BPF_W with an offset of 0, which is not correct on
big-endian machines.

Since the point of this test is not to verify narrow loads/stores,
simply use BPF_DW when working with packet counts.

Fixes: 68cfa3ac6b8d ("selftests/bpf: add a cgroup storage test")
Fixes: 919646d2a3a9 ("selftests/bpf: extend the storage test to test per-cpu cgroup storage")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_cgroup_storage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index 2fc4625c1a150..6557290043911 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -20,9 +20,9 @@ int main(int argc, char **argv)
 		BPF_MOV64_IMM(BPF_REG_2, 0), /* flags, not used */
 		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 			     BPF_FUNC_get_local_storage),
-		BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_0, 0),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0),
 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 0x1),
-		BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_3, 0),
+		BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_3, 0),
 
 		BPF_LD_MAP_FD(BPF_REG_1, 0), /* map fd */
 		BPF_MOV64_IMM(BPF_REG_2, 0), /* flags, not used */
@@ -30,7 +30,7 @@ int main(int argc, char **argv)
 			     BPF_FUNC_get_local_storage),
 		BPF_MOV64_IMM(BPF_REG_1, 1),
 		BPF_STX_XADD(BPF_DW, BPF_REG_0, BPF_REG_1, 0),
-		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
 		BPF_ALU64_IMM(BPF_AND, BPF_REG_1, 0x1),
 		BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
-- 
2.20.1

